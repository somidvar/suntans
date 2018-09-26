%This program has been written by Sorush Omidvar under supervision of 
%Dr. Woodson in Cobia lab at UGA in Sep 2018 to validate the use of 
%time-varient RhoB in the calculation of APE.

clear all;
close all;
clc

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');  

CaseNumberTotal=11;
ConversionTimeVarientCell=cell(CaseNumberTotal,1);
ConversionTimeVarient1Cell=cell(CaseNumberTotal,1);
ConversionTemporalCell=cell(CaseNumberTotal,1);
ConversionConventionalCell=cell(CaseNumberTotal,1);

IsopycnalDislocationCell=cell(CaseNumberTotal,1);
RhoBConventionalCell=cell(CaseNumberTotal,1);
RhoBTimeVarientCell=cell(CaseNumberTotal,1);
RhoPrimeConventionalCell=cell(CaseNumberTotal,1);
RhoPrimeTimeVarientCell=cell(CaseNumberTotal,1);
WCell=cell(CaseNumberTotal,1);

ZCCell=cell(CaseNumberTotal,1);
TimeCell=cell(CaseNumberTotal,1);

for i=1:11
    DataPath=strcat('\\Engr668595d\WD2\case',num2str(i),'\InternalWaves\data\Result_0000.nc');
    InterpRes=10;
    TimeStartIndex=8943-floor(44710/60)*4;
    TimeSTR=2;
    [IsopycnalDislocationCell{i},ConversionTimeVarientCell{i},ConversionTimeVarient1Cell{i},...
        ConversionTemporalCell{i},ConversionConventionalCell{i},...
        ZCCell{i},TimeCell{i},RhoBConventionalCell{i},RhoBTimeVarientCell{i},...
        RhoPrimeConventionalCell{i},RhoPrimeTimeVarientCell{i},WCell{i}]=...
        ConversionCalculator(DataPath,InterpRes,TimeStartIndex,TimeSTR,i);
        
        figure;
        hold on;
        plot(TimeCell{i}/3600,0.1*squeeze(nansum(ConversionConventionalCell{i}(1,:,:),2)),'-','linewidth',3,'Color','black');
        plot(TimeCell{i}/3600,0.1*squeeze(nansum(ConversionTimeVarientCell{i}(1,:,:),2)),'-','linewidth',3,'Color','blue');
        plot(TimeCell{i}/3600,0.1*squeeze(nansum(ConversionTimeVarient1Cell{i}(1,:,:),2)),':','linewidth',1.5,'Color','blue');
        plot(TimeCell{i}/3600,0.1*squeeze(nansum(ConversionTemporalCell{i}(1,:,:),2)),'--','linewidth',1.5,'Color','blue');
        legend('Conventional Conversion','Time-Varient Net Conversion','Time-Varient Conversion Term','Time-Varient Temporal Term')
        xlabel('Time (hr)','Interpreter','latex');
        ylabel('Depth-integrated conversion rate');
        grid on
        set(gca,'fontsize',18);
        set(gca,'FontWeight','bold');

        figure;
        hold on;
        plot(squeeze(nanmean(ConversionConventionalCell{i}(1,:,:),3)),ZCCell{i},'-','linewidth',3,'Color','black');
        plot(squeeze(nanmean(ConversionTimeVarientCell{i}(1,:,:),3)),ZCCell{i},'-','linewidth',3,'Color','blue');
        plot(squeeze(nanmean(ConversionTimeVarient1Cell{i}(1,:,:),3)),ZCCell{i},':','linewidth',3,'Color','blue');
        plot(squeeze(nanmean(ConversionTemporalCell{i}(1,:,:),3)),ZCCell{i},'--','linewidth',3,'Color','blue');
        legend('Conventional Method','Time-Varient $\rho_b$')
        xlabel('Time-averaged conversion rate','Interpreter','latex');
        ylabel('Depth (m)');
        grid on
        set(gca,'fontsize',18);
        set(gca,'FontWeight','bold');
end

save('APEResult.mat')

function [IsopycnalDislocation,ConversionTimeVarient,ConversionTimeVarient1,...
        ConversionTemporal,ConversionConventional,ZC,Time,RhoBConventional...
        ,RhoBTimeVarient,RhoPrimeConventional,RhoPrimeTimeVarient,W]=...
        ConversionCalculator(DataPath,InterpRes,TimeStartIndex,TimeSTR,CaseNumber)

    DomainLength=ncread(DataPath,'xv');
    DomainLengthIndex=size(DomainLength,1);
    if CaseNumber==1 || CaseNumber==3
        XStartIndex=193;
    elseif CaseNumber==2 || CaseNumber==4 || CaseNumber==9 ||CaseNumber==10 || CaseNumber==11
        XStartIndex=793;
    elseif CaseNumber==5 || CaseNumber==7
        XStartIndex=33;
    elseif CaseNumber==6 || CaseNumber==8
        XStartIndex=133;
    end 
    
    g=9.8;
    XEndIndex=2;
    TimeEndIndex=Inf;
    Rho0=1024;%Setting the reference density    
    CountTimeIndex=TimeEndIndex-TimeStartIndex;
    disp(strcat('Reading the NETCDF at',DataPath))
    X=ncread(DataPath,'xv',XStartIndex,XEndIndex);
    Time=ncread(DataPath,'time',TimeStartIndex,CountTimeIndex,TimeSTR);
    ZC=-ncread(DataPath,'z_r');%I changed ZC and ZE sign to make it compatible with formulas
%     Eta=ncread(DataPath,'eta',[XStartIndex,TimeStartIndex],[XEndIndex,CountTimeIndex],[1,TimeSTR]);
%     disp('Eta is done')
    Density=1000*ncread(DataPath,'rho',[XStartIndex,1,TimeStartIndex],[XEndIndex,Inf,CountTimeIndex],[1,1,TimeSTR])+1000;
    disp('Density is done')

    RhoBTimeVarient=squeeze(1000*ncread(DataPath,'rho',[DomainLengthIndex,1,TimeStartIndex],[1,Inf,CountTimeIndex],[1,1,TimeSTR])+1000-Rho0);
    disp('RhoB is done')

    W=ncread(DataPath,'w',[XStartIndex,1,TimeStartIndex],[XEndIndex,Inf,CountTimeIndex],[1,1,TimeSTR]);
    W=movsum(W,2,2)/2;%Averaging the w over two horizontal edge to get the center value
    W(:,1,:)=[];%disregarding the first layer becaue for cell i movsum is summing i-1 and i
    disp('W is done')

    disp('NETCDF reading is compeleted')
    disp('EPPrime calculation is started')
    [IsopycnalDislocation,ConversionTemporal]=EPCalculator(X,ZC,Time,Density-Rho0,RhoBTimeVarient,InterpRes,g);
    disp('EPPrime calculation is done')      

%     RhoBVerticalvelocity=diff(Eta,1,2)./permute(repmat(diff(Time,1),1,size(X,1)),[2,1]);
%     RhoBVerticalvelocity(:,end+1)=RhoBVerticalvelocity(:,end);
%     RhoBVerticalvelocity=permute(repmat(RhoBVerticalvelocity,1,1,size(ZC,1)),[1,3,2]);

    RhoBConventional=permute(repmat(mean(RhoBTimeVarient,2),1,size(Time,1),size(X,1)),[3,1,2]);
    RhoPrimeConventional=Density-Rho0-RhoBConventional;
    ConversionConventional=RhoPrimeConventional*g.*W;

    RhoPrimeTimeVarient=Density-Rho0-permute(repmat(RhoBTimeVarient,1,1,size(X,1)),[3,1,2]); 
    ConversionTimeVarient1=RhoPrimeTimeVarient.*W*g;
    ConversionTimeVarient=ConversionTimeVarient1+ConversionTemporal;  
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
       
    RhoBDiffTTemp=diff(RhoB,1,2)./permute(repmat(diff(Time),1,size(ZC,1)),[2,1]);
    RhoBDiffTTemp(:,end+1)=RhoBDiffTTemp(:,end);
    for i=1:size(X,1)
        %EPPrimeCell{i}=nan(size(ZC,1),size(Time,1));
        DensityCell{i}=squeeze(Density(i,:,:));
        ZCCell{i}=ZC;
        RhoBCell{i}=RhoB;
        ConversionTemporalCell{i}=nan(size(ZC,1),size(Time,1));
        IsopycnalDislocationCell{i}=nan(size(ZC,1),size(Time,1));
        RhoBDiffTTempCell{i}=RhoBDiffTTemp;
    end  
    CreatedParallelPool = parallel.pool.DataQueue;	
    afterEach(CreatedParallelPool, @UpdateStatusDisp);	
    ProgressStatus=0;
    disp('The top and bottom 20 layers were dismissed for the sake of numerical stability')
    parfor i=1:size(X,1)
        ZCWorker=ZCCell{i};
        for k=1:size(Time,1)           
            RhoWorker=squeeze(DensityCell{i}(:,k));
            RhoBWorker=squeeze(RhoBCell{i}(:,k));
            RhoBDiffTTempWorker=RhoBDiffTTempCell{i}(:,k);
            for j=20:size(ZCWorker,1)-20%Sometimes the value of the Rho at top and bottom cells cannot be find in Rhob
                if isnan(RhoWorker(j))%To speed up
                    continue;
                end
                if RhoWorker(j)==RhoBWorker(j)%sometimes the density is constant with depth, to avoid numerical fluctation of Rho in finding the equivalant in RhoB this criteria was enforced
                    Dislocation=0;
                    ConversionTemporalCell{i}(j,k)=0;
                    %EPPrimeCell{i}(j,k)=0;
                else
                    [RhoBWorkerUnique,RhoBWorkerUniqueIndex]=unique(RhoBWorker);
                    Dislocation=ZCWorker(j)-interp1(RhoBWorkerUnique,ZCWorker(RhoBWorkerUniqueIndex),RhoWorker(j),'linear');%if Dislocation<0 downwelling and if dislocation>0 upwelling                                  
                    if Dislocation<0%Downwelling
                        TopBoundary=interp1(RhoBWorkerUnique,ZCWorker(RhoBWorkerUniqueIndex),RhoWorker(j),'linear');
                        BotBoundary=ZCWorker(j);
                        ZCInterp=linspace(TopBoundary,BotBoundary,InterpRes);
                        %RhoBInterp=interp1(ZCWorker,RhoBWorker,ZCInterp,'linear');
                        %EPPrimeCell{i}(j,k)=-g*trapz(-ZCInterp,RhoWorker(j)-RhoBInterp);
                        RhoBDiffTTempInterp=interp1(ZCWorker,RhoBDiffTTempWorker,ZCInterp,'linear');
                        ConversionTemporalCell{i}(j,k)=+g*trapz(-ZCInterp,RhoBDiffTTempInterp);                    
                    elseif Dislocation>0%Upwelling
                        TopBoundary=ZCWorker(j);
                        BotBoundary=interp1(RhoBWorkerUnique,ZCWorker(RhoBWorkerUniqueIndex),RhoWorker(j),'linear');
                        ZCInterp=linspace(TopBoundary,BotBoundary,InterpRes);
                        %RhoBInterp=interp1(ZCWorker,RhoBWorker,ZCInterp,'linear');
                        %EPPrimeCell{i}(j,k)=+g*trapz(-ZCInterp,RhoWorker(j)-RhoBInterp);
                        RhoBDiffTTempInterp=interp1(ZCWorker,RhoBDiffTTempWorker,ZCInterp,'linear');
                        ConversionTemporalCell{i}(j,k)=-g*trapz(-ZCInterp,RhoBDiffTTempInterp);
                    end
                    IsopycnalDislocationCell{i}(j,k)=Dislocation;
                end
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