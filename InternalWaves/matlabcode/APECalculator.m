%This program has been written by Sorush Omidvar under supervision of 
%Dr. Woodson in Cobia lab at UGA in Sep 2018 to validate the use of 
%time-varient RhoB in the calculation of APE.

%Notation which is used in this program is based on the article
%"Energetics of Barotropic and Baroclinic Tides in the Monterey Bay Area"
%in 2011

%clear all;
close all;
clc

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');  

ConversionTimeVarientCell=cell(8,1);
ConversionTimeVarient1Cell=cell(8,1);
ConversionTimeVarient2Cell=cell(8,1);
ConversionTimeVarient3Cell=cell(8,1);
ConversionTimeVarient4Cell=cell(8,1);
ConversionTemporalCell=cell(8,1);
ConversionConventionalCell=cell(8,1);
IsopycnalDislocationCell=cell(8,1);

ZCCell=cell(8,1);
TimeCell=cell(8,1);
for i=4:4
    DataPath=strcat('\\Engr668595d\WD2\case',num2str(i),'\InternalWaves\data\Result_0000.nc');
    InterpRes=50;
    TimeStartIndex=8943-floor(44710/60)*2;
    TimeSTR=10;
    [IsopycnalDislocationCell{i},ConversionTimeVarientCell{i},ConversionTimeVarient1Cell{i},...
        ConversionTimeVarient2Cell{i},ConversionTimeVarient3Cell{i},...
        ConversionTimeVarient4Cell{i},ConversionTemporalCell{i},...
        ConversionConventionalCell{i},ZCCell{i},TimeCell{i}]=ConversionCalculator(DataPath,...
        InterpRes,TimeStartIndex,TimeSTR,i);
end

% SingleTimeAveragedPlotterFunc(ConversionConventionalCell,ConversionTimeVarientCell,ZCCell);
% MultiTimeAveragedPlotterFunc(ConversionConventionalCell,ConversionTimeVarientCell,ZCCell);
% SingleDepthIntegratedPlotterFunc(ConversionConventionalCell,...
%     ConversionTimeVarientCell,ConversionTimeVarient1Cell,...
%     ConversionTimeVarient2Cell,ConversionTimeVarient3Cell,...
%     ConversionTimeVarient4Cell,ConversionTemporalCell,TimeCell);

function SingleTimeAveragedPlotterFunc(ConversionConventionalCell,ConversionTimeVarientCell,ZCCell)
    for i=1:8
        if (i==1 || i==2 || i==5 || i==6)
        RhoBFun='Lin';
        elseif (i==3 || i==4 || i==7 || i==8)
        RhoBFun='Tanh';
        end
        if (i==1 || i==2 || i==3 || i==4)
        SlopeStat='Sub-cr';
        elseif (i==5 || i==6 || i==7 || i==8)
        SlopeStat='Sup-cr';
        end
        CaseName=strcat(num2str(i),'-',RhoBFun,'-',SlopeStat);

        FigureSize=[1900,850];
        f=figure('Position',[1 1 FigureSize(1) FigureSize(2)],'units','pixels');
        movegui(f,'center');
        hold on;
        plot(squeeze(nanmean(ConversionConventionalCell{i}(1,:,:),3)),ZCCell{i},':','linewidth',3);
        plot(squeeze(nanmean(ConversionTimeVarientCell{i}(1,:,:),3)),ZCCell{i},'linewidth',3);
        legend(strcat(CaseName,'-','Conv'),strcat(CaseName,'-','Time Var'));
        xlabel('Conversion');
        ylabel('Depth ($m$)');
        grid minor;
        grid on;
        title('Time-averaged Conversion');
        set(gca,'fontsize',18);
        set(gca,'FontWeight','bold');
        savefig(f,strcat(CaseName,'-Time Averaged'));
    end
end

function MultiTimeAveragedPlotterFunc(ConversionConventionalCell,ConversionTimeVarientCell,ZCCell)

        FigureSize=[1900,850];
        f=figure('Position',[1 1 FigureSize(1) FigureSize(2)],'units','pixels');
        movegui(f,'center');
        hold on;
        
        i=1;
        plot(squeeze(nanmean(ConversionConventionalCell{i}(1,50:420,:),3)),ZCCell{i}(50:420),':','linewidth',3);
        plot(squeeze(nanmean(ConversionTimeVarientCell{i}(1,50:420,:),3)),ZCCell{i}(50:420),'linewidth',3);
        
        i=2;
        plot(squeeze(nanmean(ConversionConventionalCell{i}(1,50:1900,:),3)),ZCCell{i}(50:1900),':','linewidth',3);
        plot(squeeze(nanmean(ConversionTimeVarientCell{i}(1,50:1900,:),3)),ZCCell{i}(50:1900),'linewidth',3);
        
        i=5;
        plot(squeeze(nanmean(ConversionConventionalCell{i}(1,50:420,:),3)),ZCCell{i}(50:420),':','linewidth',3);
        plot(squeeze(nanmean(ConversionTimeVarientCell{i}(1,50:420,:),3)),ZCCell{i}(50:420),'linewidth',3);
        
        i=6;
        plot(squeeze(nanmean(ConversionConventionalCell{i}(1,50:1900,:),3)),ZCCell{i}(50:1900),':','linewidth',3);
        plot(squeeze(nanmean(ConversionTimeVarientCell{i}(1,50:1900,:),3)),ZCCell{i}(50:1900),'linewidth',3);
        
        legend('1-Conv','1-Time Var','2-Conv','2-Time Var','5-Conv','5-Time Var','6-Conv','6-Time Var');
        xlabel('Conversion');
        ylabel('Depth ($m$)');
        grid minor;
        grid on;
        title('Time-averaged Conversion for linear $\rho_b$');
        set(gca,'fontsize',18);
        set(gca,'FontWeight','bold');
        
        savefig(f,'Total-Time Averaged');
        
        FigureSize=[1900,850];
        f=figure('Position',[1 1 FigureSize(1) FigureSize(2)],'units','pixels');
        movegui(f,'center');
        hold on;
        
        i=3;
        plot(squeeze(nanmean(ConversionConventionalCell{i}(1,50:420,:),3)),ZCCell{i}(50:420),':','linewidth',3);
        plot(squeeze(nanmean(ConversionTimeVarientCell{i}(1,50:420,:),3)),ZCCell{i}(50:420),'linewidth',3);
        
        i=4;
        plot(squeeze(nanmean(ConversionConventionalCell{i}(1,50:1900,:),3)),ZCCell{i}(50:1900),':','linewidth',3);
        plot(squeeze(nanmean(ConversionTimeVarientCell{i}(1,50:1900,:),3)),ZCCell{i}(50:1900),'linewidth',3);
        
        i=7;
        plot(squeeze(nanmean(ConversionConventionalCell{i}(1,50:420,:),3)),ZCCell{i}(50:420),':','linewidth',3);
        plot(squeeze(nanmean(ConversionTimeVarientCell{i}(1,50:420,:),3)),ZCCell{i}(50:420),'linewidth',3);
        
        i=8;
        plot(squeeze(nanmean(ConversionConventionalCell{i}(1,50:1900,:),3)),ZCCell{i}(50:1900),':','linewidth',3);
        plot(squeeze(nanmean(ConversionTimeVarientCell{i}(1,50:1900,:),3)),ZCCell{i}(50:1900),'linewidth',3);
        
        legend('3-Conv','3-Time Var','4-Conv','4-Time Var','7-Conv','7-Time Var','8-Conv','8-Time Var');
        xlabel('Conversion');
        ylabel('Depth ($m$)');
        grid minor;
        grid on;
        title('Time-averaged Conversion for Tanh $\rho_b$');
        set(gca,'fontsize',18);
        set(gca,'FontWeight','bold');    
        savefig(f,'Total-Time Averaged');
end

function SingleDepthIntegratedPlotterFunc(ConversionConventionalCell,...
    ConversionTimeVarientCell,ConversionTimeVarient1Cell,...
    ConversionTimeVarient2Cell,ConversionTimeVarient3Cell,...
    ConversionTimeVarient4Cell,ConversionTemporalCell,TimeCell)
    for i=1:8
        if (i==1 || i==2 || i==5 || i==6)
        RhoBFun='Lin';
        elseif (i==3 || i==4 || i==7 || i==8)
        RhoBFun='Tanh';
        end
        if (i==1 || i==2 || i==3 || i==4)
        SlopeStat='Sub-cr';
        elseif (i==5 || i==6 || i==7 || i==8)
        SlopeStat='Sup-cr';
        end
        CaseName=strcat(num2str(i),'-',RhoBFun,'-',SlopeStat);

        FigureSize=[1900,850];
        f=figure('Position',[1 1 FigureSize(1) FigureSize(2)],'units','pixels');
        movegui(f,'center');
        hold on;

        plot(TimeCell{i}/3600,0.1*squeeze(nansum(ConversionConventionalCell{i}(1,:,:),2)),'-','linewidth',1,'Color','black');
        plot(TimeCell{i}/3600,0.1*squeeze(nansum(ConversionTimeVarient4Cell{i}(1,:,:),2)),'-','linewidth',1,'Color','blue');
        plot(TimeCell{i}/3600,0.1*squeeze(nansum(ConversionTimeVarientCell{i}(1,:,:),2)),':','linewidth',1,'Color','green');
        plot(TimeCell{i}/3600,0.1*squeeze(nansum(ConversionTimeVarient1Cell{i}(1,:,:),2)),':','linewidth',1,'Color','yellow');
        plot(TimeCell{i}/3600,0.1*squeeze(nansum(ConversionTimeVarient2Cell{i}(1,:,:),2)),':','linewidth',1,'Color','red');
        plot(TimeCell{i}/3600,0.1*squeeze(nansum(ConversionTimeVarient3Cell{i}(1,:,:),2)),':','linewidth',1,'Color','magenta');
        plot(TimeCell{i}/3600,0.1*squeeze(nansum(ConversionTemporalCell{i}(1,:,:),2)),':','linewidth',1,'Color','cyan');
        
        legend(strcat(CaseName,'-','Conv'),strcat(CaseName,'-','Time Var')...
            ,strcat(CaseName,'-','Term 1'),strcat(CaseName,'-','Term 2')...
            ,strcat(CaseName,'-','Term 3'),strcat(CaseName,'-','Term 4')...
            ,strcat(CaseName,'-','Term Temporal'));
        
        xlabel('Time (hr)');
        ylabel('Conversion');
        grid minor;
        grid on;
        title('Depth-integrated Conversion');
        set(gca,'fontsize',18);
        set(gca,'FontWeight','bold');
        savefig(f,strcat(CaseName,'-Depth Integrated'));
    end
end

function [IsopycnalDislocation,ConversionTimeVarient,ConversionTimeVarient1,ConversionTimeVarient2...
    ,ConversionTimeVarient3,ConversionTimeVarient4,ConversionTemporal,...
    ConversionConventional,ZC,Time...
    ]=ConversionCalculator(DataPath,InterpRes,...
    TimeStartIndex,TimeSTR,CaseNumber)

    DomainLength=ncread(DataPath,'xv');
    DomainLengthIndex=size(DomainLength,1);
    if CaseNumber==1 || CaseNumber==3
        XStartIndex=193;
    elseif CaseNumber==2 || CaseNumber==4
        XStartIndex=793;
    elseif CaseNumber==5 || CaseNumber==7
        XStartIndex=33;
    elseif CaseNumber==6 || CaseNumber==8
        XStartIndex=133;
    end  
    g=9.8;
    XEndIndex=2;
    TimeEndIndex=Inf;
    Rho0=1025;%Setting the reference density    
    CountTimeIndex=TimeEndIndex-TimeStartIndex;
    disp(strcat('Reading the NETCDF at',DataPath))
    X=ncread(DataPath,'xv',XStartIndex,XEndIndex);
    Time=ncread(DataPath,'time',TimeStartIndex,CountTimeIndex,TimeSTR);
    ZC=-ncread(DataPath,'z_r');%I changed ZC and ZE sign to make it compatible with formulas
    Eta=ncread(DataPath,'eta',[XStartIndex,TimeStartIndex],[XEndIndex,CountTimeIndex],[1,TimeSTR]);
    disp('Eta is done')
    Density=1000*ncread(DataPath,'rho',[XStartIndex,1,TimeStartIndex],[XEndIndex,Inf,CountTimeIndex],[1,1,TimeSTR])+1000;
    disp('Density is done')
    
    RhoB=squeeze(1000*ncread(DataPath,'rho',[DomainLengthIndex,1,TimeStartIndex],[1,Inf,CountTimeIndex],[1,1,TimeSTR])+1000-Rho0);
    disp('RhoB is done')
    
    W=ncread(DataPath,'w',[XStartIndex,1,TimeStartIndex],[XEndIndex,Inf,CountTimeIndex],[1,1,TimeSTR]);
    W=movsum(W,2,2)/2;%Averaging the w over two horizontal edge to get the center value
    W(:,1,:)=[];%disregarding the first layer becaue for cell i movsum is summing i-1 and i
    disp('W is done')
    
    disp('NETCDF reading is compeleted')
    disp('EPPrime calculation is started')
    [IsopycnalDislocation,RhoBZMinusDelta,ConversionTemporal]=EPCalculator(X,ZC,Time,Density-Rho0,RhoB,InterpRes,g);
    disp('EPPrime calculation is done')      
    
    RhoBVerticalvelocity=diff(Eta,1,2)./permute(repmat(diff(Time,1),1,size(X,1)),[2,1]);
    RhoBVerticalvelocity(:,end+1)=RhoBVerticalvelocity(:,end);
    RhoBVerticalvelocity=permute(repmat(RhoBVerticalvelocity,1,1,size(ZC,1)),[1,3,2]);
    
    RhoPrimeConventional=Density-Rho0-permute(repmat(mean(RhoB,2),1,size(Time,1),size(X,1)),[3,1,2]);
    ConversionConventional=RhoPrimeConventional*g.*W;
    
    RhoPrimeTimeVarient=Density-Rho0-permute(repmat(RhoB,1,1,size(X,1)),[3,1,2]); 
    ConversionTimeVarient1=RhoPrimeTimeVarient.*W*g;
    ConversionTimeVarient2=-g*RhoBVerticalvelocity.*RhoPrimeTimeVarient;
    ConversionTimeVarient3=-g*RhoBVerticalvelocity.*permute(repmat(RhoB,1,1,size(X,1)),[3,1,2]);
    ConversionTimeVarient4=+g*RhoBVerticalvelocity.*RhoBZMinusDelta;
    ConversionTimeVarient=ConversionTimeVarient1+ConversionTimeVarient2+...
        ConversionTimeVarient3+ConversionTimeVarient4+ConversionTemporal;  
    disp('Done')
end

function [IsopycnalDislocation,RhoBZMinusDelta,ConversionTemporal]=EPCalculator(X,ZC,Time,Density,RhoB,InterpRes,g)   
    %To better calculate the APE, teh whole density profile is interpolated
    %at each time step for each X. The  the displacement of isopycanls was
    %calculated. After that, the resolution was reduced to the normal. This
    %process has been done to capture the small displacment of isopycanls
    %and also not to interfere with the original vertical resolution.

    ZInterp=linspace(ZC(1),ZC(end),InterpRes*(size(ZC,1)-1)+1);
    ZInterp=ZInterp';
    
    EPPrimeCell=cell(size(X,1),1);
    DensityCell=cell(size(X,1),1);
    ZCCellNoInterp=cell(size(X,1),1);
    ZCCellInterp=cell(size(X,1),1);
    IsopycnalDislocationCell=cell(size(X,1),1);
    RhoBZMinusDeltaCell=cell(size(X,1),1);
    RhoBDiffTInterpTempCell=cell(size(X,1),1);
    ConversionTemporalCell=cell(size(X,1),1);
    RhoBCell=cell(size(X,1),1);
    
    DepthX=0*squeeze(Density(:,:,1))+1;
    DepthX=cumsum(DepthX,2);
    DepthX=nanmax(DepthX,[],2);
    
    [ZCGrid,TimeGrid]=meshgrid(Time,ZC);
    [ZInterpGrid,TimeInterpGrid]=meshgrid(Time,ZInterp);
    RhoBInterp=interp2(ZCGrid,TimeGrid,RhoB,ZInterpGrid,TimeInterpGrid,'linear');%Linear gives fair result while spline,cause numerical oscillation
    
    RhoBDiffTInterpTemp=diff(RhoB,1,2)./permute(repmat(diff(Time),1,size(ZC,1)),[2,1]);
    RhoBDiffTInterpTemp(:,end+1)=RhoBDiffTInterpTemp(:,end);
    RhoBDiffTInterpTemp=interp2(ZCGrid,TimeGrid,RhoBDiffTInterpTemp,ZInterpGrid,TimeInterpGrid,'linear');
    for i=1:size(X,1)
        EPPrimeCell{i}=nan(size(ZC,1),size(Time,1));
        DensityCell{i}=squeeze(Density(i,:,:));
        ZCCellNoInterp{i}=ZC(1:DepthX(i));
        ZCCellInterp{i}=ZInterp(:);
        RhoBCell{i}=RhoBInterp(:,:);
        RhoBDiffTInterpTempCell{i}=RhoBDiffTInterpTemp;
        ConversionTemporalCell{i}=nan(size(ZC,1),size(Time,1));
        IsopycnalDislocationCell{i}=nan(size(ZC,1),size(Time,1));
        RhoBZMinusDeltaCell{i}=nan(size(ZC,1),size(Time,1));
    end  
    CreatedParallelPool = parallel.pool.DataQueue;	
    afterEach(CreatedParallelPool, @UpdateStatusDisp);	
    ProgressStatus=0;

    parfor i=1:size(X,1)
        ZCWorker=ZCCellNoInterp{i};
        ZInterpWorker=ZCCellInterp{i};
        for k=1:size(Time,1)           
            RhoProfile=squeeze(DensityCell{i}(:,k));
            RhoBInterpWorker=squeeze(RhoBCell{i}(:,k));
            for j=1:size(ZCWorker,1)
                [~,TrackedDensityIndex]=nanmin(abs(RhoProfile(j)-RhoBInterpWorker));
                TrackedDensityIndex=TrackedDensityIndex(1);
                Dislocation=ZInterpWorker((j-1)*InterpRes+1)-ZInterpWorker(TrackedDensityIndex);%if Dislocation<0 downwelling and if dislocation>0 upwelling
                
                if Dislocation==0
                    EPPrimeCell{i}(j,k)=0;
                    RhoBZMinusDeltaCell{i}(j,k)=RhoBInterpWorker((j-1)*InterpRes+1);
                    ConversionTemporalCell{i}(j,k)=0;
                elseif Dislocation<0%Downwelling
                    MaxBoundary=(j-1)*InterpRes+1;
                    MinBoundary=TrackedDensityIndex;
                    EPPrimeCell{i}(j,k)=-g*trapz(-ZInterpWorker(MinBoundary:MaxBoundary),...
                        RhoProfile(j)-RhoBInterpWorker(MinBoundary:MaxBoundary));
                    RhoBZMinusDeltaCell{i}(j,k)=RhoBInterpWorker(MinBoundary);
                    ConversionTemporalCell{i}(j,k)=+g*trapz(-ZInterpWorker(MinBoundary:MaxBoundary),...
                        RhoBDiffTInterpTempCell{i}(MinBoundary:MaxBoundary,k));
                elseif Dislocation>0%Upwelling
                    MaxBoundary=TrackedDensityIndex;
                    MinBoundary=(j-1)*InterpRes+1;
                    EPPrimeCell{i}(j,k)=+g*trapz(-ZInterpWorker(MinBoundary:MaxBoundary),...
                        RhoProfile(j)-RhoBInterpWorker(MinBoundary:MaxBoundary));
                    RhoBZMinusDeltaCell{i}(j,k)=RhoBInterpWorker(MaxBoundary);
                    ConversionTemporalCell{i}(j,k)=-g*trapz(-ZInterpWorker(MinBoundary:MaxBoundary),...
                        RhoBDiffTInterpTempCell{i}(MinBoundary:MaxBoundary,k));
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
    
    RhoBZMinusDeltaConv= cellfun(@(TempCellConv)reshape(TempCellConv,1,size(ZC,1),size(Time,1)),RhoBZMinusDeltaCell,'un',0);
    RhoBZMinusDelta= cell2mat(RhoBZMinusDeltaConv);
    
    ConversionTemporalCellConv= cellfun(@(TempCellConv)reshape(TempCellConv,1,size(ZC,1),size(Time,1)),ConversionTemporalCell,'un',0);
    ConversionTemporal= cell2mat(ConversionTemporalCellConv);
end