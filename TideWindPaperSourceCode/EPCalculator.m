function [RhoBTimeVarient,IsopycnalDislocation,ConversionTemporal]=EPCalculator(X,ZC,Time,Density,RhoBConventional,Gamma,InterpRes,g)   
    %To better calculate the APE, teh whole density profile is interpolated
    %at each time step for each X. The  the displacement of isopycanls was
    %calculated. After that, the resolution was reduced to the normal. This
    %process has been done to capture the small displacment of isopycanls
    %and also not to interfere with the original vertical resolution.
    defaultProfile=parallel.defaultClusterProfile;
    p=parcluster(defaultProfile);
    p.NumWorkers=48;
    ppool=parpool(p,48);
    
    FirstJIndex=1;
    RangeLimit=1;
    
    RhoBConventionalCell=cell(size(X,1),1);
    RhoBTimeVarientCell=cell(size(X,1),1);
    LastJIndexCell=cell(size(X,1),1);
    ZCCell=cell(size(X,1),1);
    ZCUniqueCell=cell(size(X,1),1);
    GammaCell=cell(size(X,1),1);
    
    for i=1:size(X,1)
        LastJIndexCell{i}=find(RhoBConventional(i,:)*0==0,1,'last');
        [RhoBConventionalUnique,RhoBConventionalUniqueIndex]=...
            unique(RhoBConventional(i,FirstJIndex:LastJIndexCell{i})');
        RhoBConventionalCell{i}=RhoBConventionalUnique;
        ZCUniqueCell{i}=ZC(RhoBConventionalUniqueIndex);
        ZCCell{i}=ZC;
        RhoBTimeVarientCell{i}=nan(size(ZC,1),size(Time,1));
        GammaCell{i}=squeeze(Gamma(i,:,:));
    end
    
    CreatedParallelPool = parallel.pool.DataQueue;	
    afterEach(CreatedParallelPool, @UpdateStatusDisp);	
    ProgressStatus=0;
    
    parfor i=1:size(X,1)
        RhoBConventionalWorker=RhoBConventionalCell{i};
        LastJIndexWorker=LastJIndexCell{i};
        ZCWorker=ZCCell{i};
        ZCUniqueWorker=ZCUniqueCell{i};
        GammaWorker=GammaCell{i};
        for j=RangeLimit:LastJIndexWorker
            for k=1:size(Time,1)
                TempInterp=interp1(ZCUniqueWorker,RhoBConventionalWorker,...
                    ZCWorker(j)-GammaWorker(j,k),'linear','extrap');
                RhoBTimeVarientCell{i}(j,k)=TempInterp;
            end
        end
        send(CreatedParallelPool,i);
    end
    RhoBTimeVarientConv= cellfun(@(TempCellConv)reshape(TempCellConv,1,size(ZC,1),size(Time,1)),RhoBTimeVarientCell,'un',0);
    RhoBTimeVarient= cell2mat(RhoBTimeVarientConv);
    
    DensityCell=cell(size(X,1),1);
    IsopycnalDislocationCell=cell(size(X,1),1);
    ConversionTemporalCell=cell(size(X,1),1);
    RhoBTimeVarientDiffTTempCell=cell(size(X,1),1);
       
    RhoBDiffTTemp=diff(RhoBTimeVarient,1,3)./permute(repmat(diff(Time),1,size(X,1),size(ZC,1)),[2,3,1]);
    RhoBDiffTTemp(:,:,end+1)=RhoBDiffTTemp(:,:,end);
    for i=1:size(X,1)
        DensityCell{i}=squeeze(Density(i,:,:));
        ConversionTemporalCell{i}=nan(size(ZC,1),size(Time,1));
        IsopycnalDislocationCell{i}=nan(size(ZC,1),size(Time,1));
        RhoBTimeVarientDiffTTempCell{i}=squeeze(RhoBDiffTTemp(i,:,:));
    end 

    CreatedParallelPool = parallel.pool.DataQueue;	
    afterEach(CreatedParallelPool, @UpdateStatusDisp);	
    ProgressStatus=0;
    disp('For the sake of numerical, the top 5 meters are dissmissed')
    RangeLimit=1;
    parfor i=1:size(X,1)
        ZCWorker=ZCCell{i};
        LastJIndex=LastJIndexCell{i};
        for k=1:size(Time,1)           
            RhoWorker=squeeze(DensityCell{i}(1:LastJIndex,k));
            RhoBTimeVarientWorker=squeeze(RhoBTimeVarientCell{i}(1:LastJIndex,k));
            RhoBTimeVarientDiffTTempWorker=RhoBTimeVarientDiffTTempCell{i}(1:LastJIndex,k);
            for j=RangeLimit:LastJIndex%Sometimes the value of the Rho at top and bottom cells cannot be find in Rhob
                if (RhoWorker(j)<RhoBTimeVarientWorker(1) || RhoWorker(j)>RhoBTimeVarientWorker(end))%The density profile does not have this value
                    Dislocation=0;
                    ConversionTemporalCell{i}(j,k)=0;
                else
                    [RhoBWorkerUnique,RhoBWorkerUniqueIndex]=unique(RhoBTimeVarientWorker);
                    Dislocation=ZCWorker(j)-interp1(RhoBWorkerUnique,ZCWorker(RhoBWorkerUniqueIndex),RhoWorker(j),'linear');%if Dislocation<0 downwelling and if dislocation>0 upwelling                                  
                    if Dislocation==0
                        ConversionTemporalCell{i}(j,k)=0;	                    
                    elseif Dislocation<0%Downwelling
                        TopBoundary=interp1(RhoBWorkerUnique,ZCWorker(RhoBWorkerUniqueIndex),RhoWorker(j),'linear');
                        BotBoundary=ZCWorker(j);
                        ZCInterp=linspace(TopBoundary,BotBoundary,InterpRes);
                        %EPPrimeCell{i}(j,k)=-g*trapz(-ZCInterp,RhoWorker(j)-RhoBInterp);
                        RhoBDiffTTempInterp=interp1(ZCWorker(1:LastJIndex),RhoBTimeVarientDiffTTempWorker,ZCInterp,'linear');
                        ConversionTemporalCell{i}(j,k)=+g*trapz(-ZCInterp,RhoBDiffTTempInterp);                    
                    elseif Dislocation>0%Upwelling
                        TopBoundary=ZCWorker(j);
                        BotBoundary=interp1(RhoBWorkerUnique,ZCWorker(RhoBWorkerUniqueIndex),RhoWorker(j),'linear');
                        ZCInterp=linspace(TopBoundary,BotBoundary,InterpRes);
                        %EPPrimeCell{i}(j,k)=+g*trapz(-ZCInterp,RhoWorker(j)-RhoBInterp);
                        RhoBDiffTTempInterp=interp1(ZCWorker(1:LastJIndex),RhoBTimeVarientDiffTTempWorker,ZCInterp,'linear');
                        ConversionTemporalCell{i}(j,k)=-g*trapz(-ZCInterp,RhoBDiffTTempInterp);
                    end
                    if(isnan(Dislocation))
                        disp('Error!!! Error in dislocation calculation. The density could not be found')
                    end
                end
                IsopycnalDislocationCell{i}(j,k)=Dislocation;
            end
        end 
        send(CreatedParallelPool,i);
    end
    function UpdateStatusDisp(~)	
        ProgressString=num2str(ProgressStatus/size(X,1)*100,'%2.1f');	
        disp(strcat('Progress Percentage=',ProgressString))	
        ProgressStatus= ProgressStatus + 1;	
    end
  
    IsopycnalDislocationConv= cellfun(@(TempCellConv)reshape(TempCellConv,1,size(ZC,1),size(Time,1)),IsopycnalDislocationCell,'un',0);
    IsopycnalDislocation= cell2mat(IsopycnalDislocationConv);
     
    ConversionTemporalCellConv= cellfun(@(TempCellConv)reshape(TempCellConv,1,size(ZC,1),size(Time,1)),ConversionTemporalCell,'un',0);
    ConversionTemporal= cell2mat(ConversionTemporalCellConv);
end


