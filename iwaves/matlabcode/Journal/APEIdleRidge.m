%This program has been written by Sorush Omidvar under supervision of 
%Dr. Woodson in Cobia lab at UGA in Sep 2018 to validate the use of 
%time-variant RhoB in the calculation of APE.

clear;
close all;
clc;

g=9.8;
Rho0=1000;%Setting the reference density
InterpRes=100;
DataPath='/scratch/omidvar/work-directory_0801/IdleRidgeInfoCorrect.nc';
YRange=1:30;
Part=1;
ConversionPartCalculator(YRange,Part,DataPath,InterpRes,Rho0,g);

YRange=31:60;
Part=2;
ConversionPartCalculator(YRange,Part,DataPath,InterpRes,Rho0,g);

YRange=61:90;
Part=3;
ConversionPartCalculator(YRange,Part,DataPath,InterpRes,Rho0,g);

YRange=91:118;
Part=4;
ConversionPartCalculator(YRange,Part,DataPath,InterpRes,Rho0,g);

function ConversionPartCalculator(YRange,Part,DataPath,InterpRes,Rho0,g)
	disp(strcat('Reading the NETCDF at',DataPath))
	X=ncread(DataPath,'X');
	Y=ncread(DataPath,'Y');
	ZC=ncread(DataPath,'Z');
	Time=ncread(DataPath,'Time');
	Eta=ncread(DataPath,'Eta');
	disp('Eta is done')
	Density=ncread(DataPath,'Density');
	disp('Density is done')

	Y=Y(YRange);
	Density=Density(:,YRange,:,:);
	Eta=Eta(:,YRange,:);

	X=movmean(X,2);
	Density=movmean(Density,2,1);
	Eta=movmean(Eta,2,1);

	Y=movmean(Y,2);
	Density=movmean(Density,2,2);
	Eta=movmean(Eta,2,2);
	
	if exist(strcat('APEIdleRidge-',num2str(Part),'.nc'))~=0
		delete(strcat('APEIdleRidge-',num2str(Part),'.nc'));
	end
	ncid = netcdf.create(strcat('APEIdleRidge-',num2str(Part),'.nc'),'NETCDF4');

	dimidX = netcdf.defDim(ncid,'XDim',size(X,1)); 
	dimidY = netcdf.defDim(ncid,'YDim',size(Y,1)); 
	dimidZ = netcdf.defDim(ncid,'ZDim',size(ZC,1)); 
	dimidTime = netcdf.defDim(ncid,'TimeDim',size(Time,1)); 
	
	X_ID=netcdf.defVar(ncid,'X','float',dimidX);
	Y_ID=netcdf.defVar(ncid,'Y','float',dimidY);
	Z_ID=netcdf.defVar(ncid,'Z','float',dimidZ);
	Time_ID=netcdf.defVar(ncid,'Time','float',dimidTime);
	U_ID = netcdf.defVar(ncid,'U','float',[dimidX dimidY dimidZ dimidTime]);
	V_ID = netcdf.defVar(ncid,'V','float',[dimidX dimidY dimidZ dimidTime]);
	WBar_ID = netcdf.defVar(ncid,'WBar','float',[dimidX dimidY dimidZ dimidTime]);
	Density_ID = netcdf.defVar(ncid,'Density','float',[dimidX dimidY dimidZ dimidTime]);
	Eta_ID = netcdf.defVar(ncid,'Eta','float',[dimidX dimidY dimidTime]);
	
	ConversionTemporal_ID = netcdf.defVar(ncid,'ConversionTemporal','float',[dimidX dimidY dimidZ dimidTime]);
	RhoPrimeTimeVarient_ID = netcdf.defVar(ncid,'RhoPrimeTimeVarient','float',[dimidX dimidY dimidZ dimidTime]);
	RhoPrimeConventional_ID = netcdf.defVar(ncid,'RhoPrimeConventional','float',[dimidX dimidY dimidZ dimidTime]);
	
	ConversionConventionalWBar_ID = netcdf.defVar(ncid,'ConversionConventionalWBar','float',[dimidX dimidY dimidZ dimidTime]);
	ConversionConventionalTimeAvrWBar_ID = netcdf.defVar(ncid,'ConversionConventionalTimeAvrWBar','float',[dimidX dimidY dimidZ]);
	ConversionConventionalTimeAvrDepthIntWBar_ID = netcdf.defVar(ncid,'ConversionConventionalTimeAvrDepthIntWBar','float',[dimidX dimidY]);
	
	ConversionTimeVarient1WBar_ID = netcdf.defVar(ncid,'ConversionTimeVarient1WBar','float',[dimidX dimidY dimidZ dimidTime]);
	ConversionTimeVarient1TimeAvrWBar_ID = netcdf.defVar(ncid,'ConversionTimeVarient1TimeAvrWBar','float',[dimidX dimidY dimidZ]);
	ConversionTimeVarient1TimeAvrDepthIntWBar_ID = netcdf.defVar(ncid,'ConversionTimeVarient1TimeAvrDepthIntWBar','float',[dimidX dimidY]);
	
	ConversionTemporalTimeAvr_ID = netcdf.defVar(ncid,'ConversionTemporalTimeAvr','float',[dimidX dimidY dimidZ]);
	ConversionTemporalTimeAvrDepthInt_ID = netcdf.defVar(ncid,'ConversionTemporalTimeAvrDepthInt','float',[dimidX dimidY]);
	
	netcdf.endDef(ncid);	

	disp('Writing X in the NETCDF')
	netcdf.putVar(ncid,X_ID,X); 
	
	disp('Writing Y in the NETCDF')
	netcdf.putVar(ncid,Y_ID,Y); 
	
	disp('Writing ZC in the NETCDF')
	netcdf.putVar(ncid,Z_ID,ZC); 
	
	disp('Writing Time in the NETCDF')
	netcdf.putVar(ncid,Time_ID,Time); 
	
	disp('Writing Eta in the NETCDF')	
	netcdf.putVar(ncid,Eta_ID,Eta);
	
	disp('Writing Density in the NETCDF')
	netcdf.putVar(ncid,Density_ID,Density); 
	
	Epsilon=permute(repmat(ZC,1,size(X,1),size(Y,1),size(Time,1)),[2,3,1,4]);
	Epsilon=1-Epsilon/nanmin(Epsilon(:));
	Epsilon=Epsilon.*permute(repmat(Eta(floor(size(X,1)/3),floor(size(Y,1)/2),:),size(X,1),size(Y,1),1,size(ZC,1)),[1,2,4,3]);

	RhoBConventional=Density;
	RhoBConventional(isnan(RhoBConventional))=0;
	RhoBConventional=trapz(Time,RhoBConventional,4)/(Time(end)-Time(1));
	RhoBConventional(RhoBConventional==0)=nan;

	RhoBTimeVarient=nan(size(X,1),size(Y,1),size(ZC,1),size(Time,1));
	ConversionTemporal=nan(size(X,1),size(Y,1),size(ZC,1),size(Time,1));

	CurrentParpool=gcp;
	if (~isempty(CurrentParpool))
		 delete(gcp('nocreate'));
	end
	numcores = feature('numcores');
	parpool(numcores);

	for j=1:size(Y,1)
		disp(strcat('Progress at=',num2str(j*100/size(Y,1)),'%'))
		[RhoBTimeVarientTemp,~,ConversionTemporalTemp]=EPCalculator(X,ZC,Time,...
			squeeze(Density(:,j,:,:)),squeeze(RhoBConventional(:,j,:))...
			,squeeze(Epsilon(:,j,:,:)),InterpRes,g);
		RhoBTimeVarient(:,j,:,:)=RhoBTimeVarientTemp;
		ConversionTemporal(:,j,:,:)=ConversionTemporalTemp;
		disp('EPPrime calculation is done')      
	end
	disp('TVBD calculation is done')      
	
	clear ConversionTemporalTemp RhoBTimeVarientTemp Epsilon;
	ConversionTemporal=single(ConversionTemporal);
	RhoBTimeVarient=single(RhoBTimeVarient);
	
	disp('Writing ConversionTemporal in the NETCDF')
	netcdf.putVar(ncid,ConversionTemporal_ID,ConversionTemporal); 

	RhoBConventional=repmat(RhoBConventional,1,1,1,size(Time,1));
	RhoPrimeTimeVarient=Density-RhoBTimeVarient;
	RhoPrimeConventional=Density-RhoBConventional;
	clear Density;

	disp('Writing RhoPrimeTimeVarient in the NETCDF')
	netcdf.putVar(ncid,RhoPrimeTimeVarient_ID,RhoPrimeTimeVarient); 
	
	disp('Writing RhoPrimeConventional in the NETCDF')
	netcdf.putVar(ncid,RhoPrimeConventional_ID,RhoPrimeConventional); 	

	DPlusZ=permute(repmat(ZC,1,size(X,1),size(Y,1),size(Time,1)),[2,3,1,4])+RhoPrimeTimeVarient*0;
	Depth=nanmin(DPlusZ,[],3);
	DPlusZ=DPlusZ-repmat(Depth,1,1,size(ZC,1),1);

	U=ncread(DataPath,'U');
	disp('U is done')

	U=U(:,YRange,:,:);
	U=movmean(U,2,1);
	U=movmean(U,2,2);
	disp('Writing U in the NETCDF')
	netcdf.putVar(ncid,U_ID,U); 	
	
	UBar=U;
	UBar(isnan(UBar))=0;
	UBar=repmat(trapz(-ZC,UBar,3),1,1,size(ZC,1),1);
	UBar=UBar./-repmat(Depth,1,1,size(ZC,1),1);
	UBar=UBar+0*U;
	clear U;
	disp('UBar calculation is done')      

	V=ncread(DataPath,'V');
	disp('V is done')

	V=V(:,YRange,:,:); 
	V=movmean(V,2,2);  
	V=movmean(V,2,1);
	disp('Writing V in the NETCDF')
	netcdf.putVar(ncid,V_ID,V); 	
	
	VBar=V;
	VBar(isnan(VBar))=0;
	VBar=repmat(trapz(-ZC,VBar,3),1,1,size(ZC,1),1);
	VBar=VBar./-repmat(Depth,1,1,size(ZC,1),1);
	VBar=VBar+0*V;
	clear V;
	disp('VBar calculation is done')      

	clear Depth;

	WBar1=-diff(DPlusZ.*UBar,1,1)./repmat(diff(X,1,1),1,size(Y,1),size(ZC,1),size(Time,1));
	WBar1(end+1,:,:,:)=WBar1(end,:,:,:);
	WBar2=-diff(DPlusZ.*VBar,1,2)./permute(repmat(diff(Y,1,1),1,size(X,1),size(ZC,1),size(Time,1)),[2,1,3,4]);
	WBar2(:,end+1,:,:)=WBar2(:,end,:,:);
	disp('WBar calculation is done')      
	clear DPlusZ;
	WBar2=WBar1+WBar2;
	clear WBar1;
	WBar=WBar2;
	clear WBar2;
	
	disp('Writing WBar in the NETCDF')
	netcdf.putVar(ncid,WBar_ID,WBar); 	
	
	ConversionConventionalWBar=g*RhoPrimeConventional.*WBar;  
	ConversionConventionalTimeAvrWBar=trapz(Time,ConversionConventionalWBar,4)/(Time(end)-Time(1));
	ConversionConventionalTimeAvrDepthIntWBar=ConversionConventionalTimeAvrWBar;
	ConversionConventionalTimeAvrDepthIntWBar(isnan(ConversionConventionalTimeAvrDepthIntWBar))=0;
	ConversionConventionalTimeAvrDepthIntWBar=trapz(-ZC,ConversionConventionalTimeAvrDepthIntWBar,3);

	disp('Writing ConversionConventionalWBar in the NETCDF')
	netcdf.putVar(ncid,ConversionConventionalWBar_ID,ConversionConventionalWBar); 	
	disp('Writing ConversionConventionalTimeAvrWBar in the NETCDF')
	netcdf.putVar(ncid,ConversionConventionalTimeAvrWBar_ID,ConversionConventionalTimeAvrWBar); 	
	disp('Writing ConversionConventionalTimeAvrDepthIntWBar in the NETCDF')
	netcdf.putVar(ncid,ConversionConventionalTimeAvrDepthIntWBar_ID,ConversionConventionalTimeAvrDepthIntWBar); 	

	clear ConversionConventionalWBar;

	ConversionTimeVarient1WBar=RhoPrimeTimeVarient.*WBar*g;
	ConversionTimeVarient1TimeAvrWBar=trapz(Time,ConversionTimeVarient1WBar,4)/(Time(end)-Time(1));
	ConversionTimeVarient1TimeAvrDepthIntWBar=ConversionTimeVarient1TimeAvrWBar;
	ConversionTimeVarient1TimeAvrDepthIntWBar(isnan(ConversionTimeVarient1TimeAvrDepthIntWBar))=0;
	ConversionTimeVarient1TimeAvrDepthIntWBar=trapz(-ZC,ConversionTimeVarient1TimeAvrDepthIntWBar,3);

	disp('Writing ConversionTimeVarient1WBar in the NETCDF')
	netcdf.putVar(ncid,ConversionTimeVarient1WBar_ID,ConversionTimeVarient1WBar); 	
	disp('Writing ConversionTimeVarient1TimeAvrWBar in the NETCDF')
	netcdf.putVar(ncid,ConversionTimeVarient1TimeAvrWBar_ID,ConversionTimeVarient1TimeAvrWBar); 	
	disp('Writing ConversionTimeVarient1TimeAvrDepthIntWBar in the NETCDF')
	netcdf.putVar(ncid,ConversionTimeVarient1TimeAvrDepthIntWBar_ID,ConversionTimeVarient1TimeAvrDepthIntWBar); 		
	
	clear ConversionTimeVarient1WBar;

	ConversionTemporalTimeAvr=trapz(Time,ConversionTemporal,4)/(Time(end)-Time(1));
	ConversionTemporalTimeAvrDepthInt=ConversionTemporalTimeAvr;
	ConversionTemporalTimeAvrDepthInt(isnan(ConversionTemporalTimeAvrDepthInt))=0;
	ConversionTemporalTimeAvrDepthInt=trapz(-ZC,ConversionTemporalTimeAvrDepthInt,3);
	
	disp('Writing ConversionTemporalTimeAvr in the NETCDF')
	netcdf.putVar(ncid,ConversionTemporalTimeAvr_ID,ConversionTemporalTimeAvr); 	
	disp('Writing ConversionTemporalTimeAvrDepthInt in the NETCDF')
	netcdf.putVar(ncid,ConversionTemporalTimeAvrDepthInt_ID,ConversionTemporalTimeAvrDepthInt); 
	
	clear ConversionTemporal;	
	netcdf.close(ncid);
end

function [RhoBTimeVarient,IsopycnalDislocation,ConversionTemporal]=EPCalculator(X,ZC,Time,Density,RhoBConventional,Epsilon,InterpRes,g)   
    %To better calculate the APE, the whole density profile is interpolated
    %at each time step for each X. The  the displacement of isopycanls was
    %calculated. After that, the resolution was reduced to the normal. This
    %process has been done to capture the small displacement of isopycanls
    %and also not to interfere with the original vertical resolution.
    
    FirstJIndex=1;
    RangeLimit=1;
    
    RhoBConventionalCell=cell(size(X,1),1);
    RhoBTimeVarientCell=cell(size(X,1),1);
    LastJIndexCell=cell(size(X,1),1);
    ZCCell=cell(size(X,1),1);
    ZCUniqueCell=cell(size(X,1),1);
    EpsilonCell=cell(size(X,1),1);
    
    for i=1:size(X,1)
        LastJIndexCell{i}=find(RhoBConventional(i,:)*0==0,1,'last');
        [RhoBConventionalUnique,RhoBConventionalUniqueIndex]=...
            unique(RhoBConventional(i,FirstJIndex:LastJIndexCell{i})');
        RhoBConventionalCell{i}=RhoBConventionalUnique;
        ZCUniqueCell{i}=ZC(RhoBConventionalUniqueIndex);
        ZCCell{i}=ZC;
        RhoBTimeVarientCell{i}=nan(size(ZC,1),size(Time,1));
        EpsilonCell{i}=squeeze(Epsilon(i,:,:));
    end
    
    CreatedParallelPool = parallel.pool.DataQueue;	
    afterEach(CreatedParallelPool, @UpdateStatusDisp);	
    ProgressStatus=0;
    
    parfor i=1:size(X,1)
        RhoBConventionalWorker=RhoBConventionalCell{i};
        LastJIndexWorker=LastJIndexCell{i};
        ZCWorker=ZCCell{i};
        ZCUniqueWorker=ZCUniqueCell{i};
        EpsilonWorker=EpsilonCell{i};
        for j=RangeLimit:LastJIndexWorker
            for k=1:size(Time,1)
                TempInterp=interp1(ZCUniqueWorker,RhoBConventionalWorker,...
                    ZCWorker(j)-EpsilonWorker(j,k),'linear','extrap');
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
                    if Dislocation<0%Downwelling
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
                        disp(strcat('Error!!! Error in dislocation calculation. The density could not be found at X=',num2str(i),'Z=',num2str(j),'Time=',num2str(k)))
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