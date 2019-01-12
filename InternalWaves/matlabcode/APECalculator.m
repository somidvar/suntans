%This program has been written by Sorush Omidvar under supervision of 
%Dr. Woodson in Cobia lab at UGA in Sep 2018 to validate the use of 
%time-varient RhoB in the calculation of APE.

clear all;
close all;
clc

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');  

CaseNumberTotal=12;
ConversionTimeVarientCell=cell(CaseNumberTotal,1);
ConversionTimeVarient1Cell=cell(CaseNumberTotal,1);
ConversionTemporalCell=cell(CaseNumberTotal,1);
ConversionConventionalCell=cell(CaseNumberTotal,1);

IsopycnalDislocationCell=cell(CaseNumberTotal,1);
RhoBConventionalCell=cell(CaseNumberTotal,1);
RhoBTimeVarientCell=cell(CaseNumberTotal,1);
RhoPrimeConventionalCell=cell(CaseNumberTotal,1);
RhoPrimeTimeVarientCell=cell(CaseNumberTotal,1);
DensityCell=cell(CaseNumberTotal,1);
WCell=cell(CaseNumberTotal,1);

ZCCell=cell(CaseNumberTotal,1);
TimeCell=cell(CaseNumberTotal,1);
for i=8:8%CaseNumberTotal
    DataPath=strcat('\\Engr668595d\WD2\APE3\case',num2str(i),'\InternalWaves\data\Result_0000.nc');
    DataPath=strcat('D:\step\InternalWaves\data\Result_0000.nc');
    InterpRes=50;
    TimeStartIndex=5962-floor(44710/60*1);
    TimeSTR=1;
    [IsopycnalDislocationCell{i},ConversionTimeVarientCell{i},ConversionTimeVarient1Cell{i},...
        ConversionTemporalCell{i},ConversionConventionalCell{i},...
        ZCCell{i},TimeCell{i},RhoBConventionalCell{i},RhoBTimeVarientCell{i},...
        RhoPrimeConventionalCell{i},RhoPrimeTimeVarientCell{i},WCell{i},DensityCell{i}]=...
        ConversionCalculator(DataPath,InterpRes,TimeStartIndex,TimeSTR,i);
        
        figure;
        hold on;
        RangeLimit=50;
        RangeIndex=find(squeeze(WCell{i}(1,:,1)*0==0),1,'last')-RangeLimit;
        plot(TimeCell{i}/3600,trapz(-ZCCell{i}(RangeLimit:RangeIndex),squeeze(ConversionConventionalCell{i}(1,RangeLimit:RangeIndex,:)),1),'-','linewidth',3,'Color','black');
        plot(TimeCell{i}/3600,trapz(-ZCCell{i}(RangeLimit:RangeIndex),squeeze(ConversionTimeVarientCell{i}(1,RangeLimit:RangeIndex,:)),1),'-','linewidth',3,'Color','blue');
        plot(TimeCell{i}/3600,trapz(-ZCCell{i}(RangeLimit:RangeIndex),squeeze(ConversionTimeVarient1Cell{i}(1,RangeLimit:RangeIndex,:)),1),':','linewidth',1.5,'Color','blue');
        plot(TimeCell{i}/3600,trapz(-ZCCell{i}(RangeLimit:RangeIndex),squeeze(ConversionTemporalCell{i}(1,RangeLimit:RangeIndex,:)),1),'--','linewidth',1.5,'Color','blue');
        legend('Conventional Conversion','Time-Varient Net Conversion','Time-Varient Conversion Term','Time-Varient Temporal Term')
        xlabel('Time (hr)','Interpreter','latex');
        ylabel('Depth-integrated conversion rate');
        grid on
        set(gca,'fontsize',18);
        set(gca,'FontWeight','bold');

        figure;
        hold on;
        plot(trapz(TimeCell{i},squeeze(ConversionConventionalCell{i}(1,RangeLimit:RangeIndex,:)),2)/(TimeCell{i}(end)-TimeCell{i}(1)),ZCCell{i}(RangeLimit:RangeIndex),'-','linewidth',3,'Color','black');
        plot(trapz(TimeCell{i},squeeze(ConversionTimeVarientCell{i}(1,RangeLimit:RangeIndex,:)),2)/(TimeCell{i}(end)-TimeCell{i}(1)),ZCCell{i}(RangeLimit:RangeIndex),'-','linewidth',3,'Color','blue');
        plot(trapz(TimeCell{i},squeeze(ConversionTimeVarient1Cell{i}(1,RangeLimit:RangeIndex,:)),2)/(TimeCell{i}(end)-TimeCell{i}(1)),ZCCell{i}(RangeLimit:RangeIndex),':','linewidth',3,'Color','blue');
        plot(trapz(TimeCell{i},squeeze(ConversionTemporalCell{i}(1,RangeLimit:RangeIndex,:)),2)/(TimeCell{i}(end)-TimeCell{i}(1)),ZCCell{i}(RangeLimit:RangeIndex),'--','linewidth',3,'Color','blue');
        legend('Conventional Conversion','Time-Varient Net Conversion','Time-Varient Conversion Term','Time-Varient Temporal Term')
        xlabel('Time-averaged conversion rate','Interpreter','latex');
        ylabel('Depth (m)');
        grid on
        set(gca,'fontsize',18);
        set(gca,'FontWeight','bold');
end

%save('APEResult.mat')

function [IsopycnalDislocation,ConversionTimeVarient,ConversionTimeVarient1,...
        ConversionTemporal,ConversionConventional,ZC,Time,RhoBConventional...
        ,RhoBTimeVarient,RhoPrimeConventional,RhoPrimeTimeVarient,W,Density]=...
        ConversionCalculator(DataPath,InterpRes,TimeStartIndex,TimeSTR,CaseNumber)
    
    XStartIndex=991;    
    
    g=9.8;
    XEndIndex=2;
    Rho0=1025;%Setting the reference density
    ZMaxIndex=Inf;
    %CountTimeIndex=floor(44710/60/TimeSTR*2);
    CountTimeIndex=Inf;
    disp(strcat('Reading the NETCDF at',DataPath))
    X=ncread(DataPath,'xv',XStartIndex,XEndIndex);
    Time=ncread(DataPath,'time',TimeStartIndex,CountTimeIndex,TimeSTR);
    ZC=-ncread(DataPath,'z_r',1,ZMaxIndex);%I changed ZC and ZE sign to make it compatible with formulas
    Eta=ncread(DataPath,'eta',[XStartIndex,TimeStartIndex],[XEndIndex,CountTimeIndex],[1,TimeSTR]);
    disp('Eta is done')
    Density=1000*ncread(DataPath,'rho',[XStartIndex,1,TimeStartIndex],[XEndIndex,ZMaxIndex,CountTimeIndex],[1,1,TimeSTR])+1000;
    disp('Density is done')
   
    W=ncread(DataPath,'w',[XStartIndex,1,TimeStartIndex],[XEndIndex,ZMaxIndex+1,CountTimeIndex],[1,1,TimeSTR]);
    W=movsum(W,2,2)/2;%Averaging the w over two horizontal edge to get the center value
    W(:,1,:)=[];%disregarding the first layer becaue for cell i movsum is summing i-1 and i
    disp('W is done')
    

    ZCTemp=permute(repmat(ZC,1,size(X,1),size(Time,1)),[2,1,3])+Density*0;
    DepthTemp=repmat(nanmin(ZCTemp,[],2),1,size(ZC,1),1);
    Epsilon=permute(repmat(squeeze(Eta(1,:)),size(X,1),1,size(ZC,1)),[1,3,2]);
    Epsilon=Epsilon.*(1-ZCTemp./DepthTemp);  
    
    RhoBConventional=trapz(Time,Density,3)/(Time(end)-Time(1))-Rho0;
    RhoBConventional=repmat(RhoBConventional,1,1,size(Time,1));   
    RhoPrimeConventional=Density-Rho0-RhoBConventional;
    
    RhoBTimeVarient=nan(size(X,1),size(ZC,1),size(Time,1));
    for i=1:size(X,1)
        RhoBConvLocal=squeeze(RhoBConventional(i,:,1))';
        LastJIndex=find(RhoBConvLocal*0==0,1,'last');
        for j=1:LastJIndex
            if(RhoBConvLocal(j)-RhoBConvLocal(1)>0.001)%Finding the mixed layer depth
                FirstJIndex=j;
                break;
            end
        end
        F = @(RhoBCoe,RhoData)RhoBCoe(1)*RhoData.^RhoBCoe(2)+RhoBCoe(3);%The fitted profile is Density=a*ZC^b+c
        ZZZ0=[0.024*1000,0.0187,0];%Initial guess is based on the initial conditions
        options = optimoptions('lsqcurvefit','Display','off');
        [RhoBCoeff,~,~,~,~] = lsqcurvefit(F,ZZZ0,-ZC(FirstJIndex:LastJIndex),RhoBConvLocal(FirstJIndex:LastJIndex)...
            ,[],[],options); 
        RhoBFittedA=RhoBCoeff(1);
        RhoBFittedB=RhoBCoeff(2);
        RhoBFittedC=RhoBCoeff(3);
        for j=1:size(ZC,1)
            for k=1:size(Time,1)
                if(j<FirstJIndex)
                    RhoBTimeVarient(i,j,k)=RhoBConvLocal(j);
                elseif(~isnan(Epsilon(i,j,k)))
                    RhoBTimeVarient(i,j,k)=RhoBFittedA*(-ZC(j)+Epsilon(i,j,k))^RhoBFittedB+RhoBFittedC;
                else
                    RhoBTimeVarient(i,j,k)=RhoBFittedA*(-ZC(j)+Epsilon(i,LastJIndex,k))^RhoBFittedB+RhoBFittedC;
                end
            end
        end
    end 
    
    disp('NETCDF reading is compeleted')
    disp('EPPrime calculation is started')
    [IsopycnalDislocation,ConversionTemporal]=EPCalculator(X,ZC,Time,Density-Rho0,RhoBTimeVarient,InterpRes,g);
    disp('EPPrime calculation is done')      

    RhoPrimeTimeVarient=Density-Rho0-RhoBTimeVarient;
    ConversionTimeVarient1=RhoPrimeTimeVarient.*W*g;
    ConversionTimeVarient=ConversionTimeVarient1+ConversionTemporal;  
    ConversionConventional=RhoPrimeConventional*g.*W;  
    disp('Done')
end

function [IsopycnalDislocation,ConversionTemporal]=EPCalculator(X,ZC,Time,Density,RhoB,InterpRes,g)   
    %To better calculate the APE, teh whole density profile is interpolated
    %at each time step for each X. The  the displacement of isopycanls was
    %calculated. After that, the resolution was reduced to the normal. This
    %process has been done to capture the small displacment of isopycanls
    %and also not to interfere with the original vertical resolution.

    %EPPrimeCell=cell(size(X,1),1);
    DensityCell=cell(size(X,1),1);
    ZCCell=cell(size(X,1),1);
    IsopycnalDislocationCell=cell(size(X,1),1);
    ConversionTemporalCell=cell(size(X,1),1);
    RhoBCell=cell(size(X,1),1);
    RhoBDiffTTempCell=cell(size(X,1),1);
       
    RhoBDiffTTemp=diff(RhoB,1,3)./permute(repmat(diff(Time),1,size(X,1),size(ZC,1)),[2,3,1]);
    RhoBDiffTTemp(:,:,end+1)=RhoBDiffTTemp(:,:,end);
    for i=1:size(X,1)
        %EPPrimeCell{i}=nan(size(ZC,1),size(Time,1));
        DensityCell{i}=squeeze(Density(i,:,:));
        ZCCell{i}=ZC;
        RhoBCell{i}=squeeze(RhoB(i,:,:));
        ConversionTemporalCell{i}=nan(size(ZC,1),size(Time,1));
        IsopycnalDislocationCell{i}=nan(size(ZC,1),size(Time,1));
        RhoBDiffTTempCell{i}=squeeze(RhoBDiffTTemp(i,:,:));
    end  
    CreatedParallelPool = parallel.pool.DataQueue;	
    afterEach(CreatedParallelPool, @UpdateStatusDisp);	
    ProgressStatus=0;
    disp('For the sake of numerical, the top 5 meters are dissmissed')
    RangeLimit=8;
    parfor i=1:size(X,1)
        ZCWorker=ZCCell{i};
        for k=1:size(Time,1)           
            RhoWorker=squeeze(DensityCell{i}(:,k));
            RhoBWorker=squeeze(RhoBCell{i}(:,k));
            RhoBDiffTTempWorker=RhoBDiffTTempCell{i}(:,k);
            
            LastJIndex=find(RhoWorker*0==0,1,'last');
            RhoWorker=RhoWorker(1:LastJIndex);
            RhoBWorker=RhoBWorker(1:end);%RhoB is extended to the full ZC so that the bottom layers can be calculated more precisely
            RhoBDiffTTempWorker=RhoBDiffTTempWorker(1:end);
            ZCWorker=ZCWorker(1:end);
            for j=RangeLimit:LastJIndex%Sometimes the value of the Rho at top and bottom cells cannot be find in Rhob
                if (abs(RhoWorker(j)-RhoBWorker(j))<0.001)%sometimes the density is constant with depth, to avoid numerical fluctation of Rho in finding the equivalant in RhoB this criteria was enforced
                    Dislocation=0;
                    ConversionTemporalCell{i}(j,k)=0;
                    %EPPrimeCell{i}(j,k)=0;
                elseif (RhoWorker(j)<RhoBWorker(1) || RhoWorker(j)>RhoBWorker(end))%The density profile does not have this value
                    Dislocation=0;
                    ConversionTemporalCell{i}(j,k)=0;
                else
                    [RhoBWorkerUnique,RhoBWorkerUniqueIndex]=unique(RhoBWorker);
                    Dislocation=ZCWorker(j)-interp1(RhoBWorkerUnique,ZCWorker(RhoBWorkerUniqueIndex),RhoWorker(j),'linear');%if Dislocation<0 downwelling and if dislocation>0 upwelling                                  
                    if Dislocation<0%Downwelling
                        TopBoundary=interp1(RhoBWorkerUnique,ZCWorker(RhoBWorkerUniqueIndex),RhoWorker(j),'linear');
                        BotBoundary=ZCWorker(j);
                        ZCInterp=linspace(TopBoundary,BotBoundary,InterpRes);
                        %EPPrimeCell{i}(j,k)=-g*trapz(-ZCInterp,RhoWorker(j)-RhoBInterp);
                        RhoBDiffTTempInterp=interp1(ZCWorker,RhoBDiffTTempWorker,ZCInterp,'linear');
                        ConversionTemporalCell{i}(j,k)=+g*trapz(-ZCInterp,RhoBDiffTTempInterp);                    
                    elseif Dislocation>0%Upwelling
                        TopBoundary=ZCWorker(j);
                        BotBoundary=interp1(RhoBWorkerUnique,ZCWorker(RhoBWorkerUniqueIndex),RhoWorker(j),'linear');
                        ZCInterp=linspace(TopBoundary,BotBoundary,InterpRes);
                        %EPPrimeCell{i}(j,k)=+g*trapz(-ZCInterp,RhoWorker(j)-RhoBInterp);
                        RhoBDiffTTempInterp=interp1(ZCWorker,RhoBDiffTTempWorker,ZCInterp,'linear');
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