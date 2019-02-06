%This program has been written by Sorush Omidvar under supervision of 
%Dr. Woodson in Cobia lab at UGA in Sep 2018 to validate the use of 
%time-varient RhoB in the calculation of APE.

clear all;
close all;
clc

ntout=20;
Nkmax=200;

Omega=1.4026e-4;%M2 Tide
TidalCycle=4;
TimeStr=1;
TimeProcessStartIndex=nan;
TimeProcessEndIndex=nan;

XProcessStartIndex=1;    
XProcessEndIndex=10000;
XStr=1;
DataPathRead='D:\COPY\iwaves\data';
DataPathWrite='D:\';
DataPath='D:\example.nc';


%DataPathRead='/scratch/omidvar/work-directory_0801/case5/iwaves/data';
%DataPathWrite='/scratch/omidvar/work-directory_0801/';
%DataPath='/scratch/omidvar/work-directory_0801/example.nc';

NETCDFWriter(DataPathRead,DataPathWrite,ntout,Nkmax,...
TimeProcessStartIndex,TimeProcessEndIndex,TimeStr,XProcessStartIndex,...
XProcessEndIndex,XStr,TidalCycle,Omega)

%set(groot,'defaulttextinterpreter','latex');  
%set(groot, 'defaultAxesTickLabelInterpreter','latex');  
%set(groot, 'defaultLegendInterpreter','latex');  


InterpRes=100;
TimeStartIndex=1;
CountTimeIndex=Inf;
TimeStr=1;
XStartIndex=1;    
XEndIndex=Inf;
ZMaxIndex=Inf;
g=9.8;
Rho0=1000;%Setting the reference density
RhoBTypeString='power';

disp(strcat('Reading the NETCDF at',DataPath))
X=ncread(DataPath,'xv',XStartIndex,XEndIndex);
Time=ncread(DataPath,'time',TimeStartIndex,CountTimeIndex,TimeStr);
ZC=-ncread(DataPath,'z_r',1,ZMaxIndex);%I changed ZC and ZE sign to make it compatible with formulas
Eta=ncread(DataPath,'eta',[XStartIndex,TimeStartIndex],[XEndIndex,CountTimeIndex],[1,TimeStr]);
disp('Eta is done')

Temp=ncinfo(DataPath,'w');
Temp=Temp.Size(2);
if (Temp==size(ZC,1)+1)%NETCDF
    W=ncread(DataPath,'w',[XStartIndex,1,TimeStartIndex],[XEndIndex,ZMaxIndex+1,CountTimeIndex],[1,1,TimeStr]);
    W=movsum(W,2,2)/2;%Averaging the w over two horizontal edge to get the center value
    W(:,1,:)=[];%disregarding the first layer becaue for cell i movsum is summing i-1 and i
    Density=Rho0*ncread(DataPath,'salt',[XStartIndex,1,TimeStartIndex],[XEndIndex,ZMaxIndex,CountTimeIndex],[1,1,TimeStr])+Rho0;
elseif (Temp==size(ZC,1))%Non-NETCDF
    W=ncread(DataPath,'w',[XStartIndex,1,TimeStartIndex],[XEndIndex,ZMaxIndex,CountTimeIndex],[1,1,TimeStr]);
    Density=Rho0*ncread(DataPath,'rho',[XStartIndex,1,TimeStartIndex],[XEndIndex,ZMaxIndex,CountTimeIndex],[1,1,TimeStr])+Rho0;
else
    disp('Error! The W formatting does not match.')
    return;
end
disp('Density is done')
disp('W is done')
disp('NETCDF reading is compeleted')

ZCTemp=permute(repmat(ZC,1,size(X,1),size(Time,1)),[2,1,3])+Density*0;
DepthTemp=repmat(nanmin(ZCTemp,[],2),1,size(ZC,1),1);
Epsilon=squeeze(Eta(floor(size(X,1)/2),:));
Epsilon=permute(repmat(Epsilon,size(X,1),1,size(ZC,1)),[1,3,2]);
Epsilon=Epsilon.*(1-ZCTemp./DepthTemp);  

RhoBConventionalTemp=trapz(Time,Density,3)/(Time(end)-Time(1))-Rho0;
RhoBConventionalTemp=repmat(RhoBConventionalTemp,1,1,size(Time,1));   

RhoBTimeVarient=nan(size(X,1),size(ZC,1),size(Time,1));
RhoBConventional=nan(size(X,1),size(ZC,1),size(Time,1));
for i=1:size(X,1)
    RhoBConvLocal=squeeze(RhoBConventionalTemp(i,:,1))';
    LastJIndex=find(RhoBConvLocal*0==0,1,'last');
    for j=1:LastJIndex
        if(RhoBConvLocal(j)-RhoBConvLocal(1)>0.001)%Finding the mixed layer depth
            FirstJIndex=j;
            break;
        end
    end
    if strcmp(RhoBTypeString,'power')
        F = @(RhoBCoe,RhoData)RhoBCoe(1)*RhoData.^RhoBCoe(2)+RhoBCoe(3);%The fitted profile is Density=a*ZC^b+c
        ZZZ0=[0.024*1000,0.0187,25];%Initial guess is based on the initial conditions
        options = optimoptions('lsqcurvefit','Display','off');
        [RhoBCoeff,~,~,~,~] = lsqcurvefit(F,ZZZ0,-ZC(FirstJIndex:LastJIndex),RhoBConvLocal(FirstJIndex:LastJIndex)...
            ,[],[],options); 
        RhoBFittedA=RhoBCoeff(1);
        RhoBFittedB=RhoBCoeff(2);
        RhoBFittedC=RhoBCoeff(3);
        for j=1:size(ZC,1)
            RhoBConventional(i,j,:)=RhoBFittedA*(-ZC(j))^RhoBFittedB+RhoBFittedC;
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
    elseif strcmp(RhoBTypeString,'linear')
        F = @(RhoBCoe,RhoData)RhoBCoe(1)*RhoData+RhoBCoe(2);%The fitted profile is Density=a*ZC^b+c
        ZZZ0=[1e-3,25];%Initial guess is based on the initial conditions
        options = optimoptions('lsqcurvefit','Display','off');
        [RhoBCoeff,~,~,~,~] = lsqcurvefit(F,ZZZ0,-ZC(FirstJIndex:LastJIndex),RhoBConvLocal(FirstJIndex:LastJIndex)...
            ,[],[],options); 
        RhoBFittedA=RhoBCoeff(1);
        RhoBFittedB=RhoBCoeff(2);
        for j=1:size(ZC,1)
            RhoBConventional(i,j,:)=RhoBFittedA*(-ZC(j))+RhoBFittedB;
            for k=1:size(Time,1)
                if(j<FirstJIndex)
                    RhoBTimeVarient(i,j,k)=RhoBConvLocal(j);
                elseif(~isnan(Epsilon(i,j,k)))
                    RhoBTimeVarient(i,j,k)=RhoBFittedA*(-ZC(j)+Epsilon(i,j,k))+RhoBFittedB;
                else
                    RhoBTimeVarient(i,j,k)=RhoBFittedA*(-ZC(j)+Epsilon(i,LastJIndex,k))+RhoBFittedB;
                end
            end
        end
    else
        disp('Error! Please modify the RhoB function.')
        return;
    end

end 
clear RhoBConventionalTemp;
disp('RhoB has been fitted and corrected')
disp('EPPrime calculation is started')
[IsopycnalDislocation,ConversionTemporal]=EPCalculator(X,ZC,Time,Density-Rho0,RhoBTimeVarient,InterpRes,g);
disp('EPPrime calculation is done')      

RhoPrimeConventional=Density-Rho0-RhoBConventional;
RhoPrimeTimeVarient=Density-Rho0-RhoBTimeVarient;
ConversionTimeVarient1=RhoPrimeTimeVarient.*W*g;
ConversionTimeVarient=ConversionTimeVarient1+ConversionTemporal;  
ConversionConventional=RhoPrimeConventional*g.*W;  

[xx,zz]=meshgrid(X,ZC);
ConversionTimeVarientTimeAvr=trapz(Time,ConversionTimeVarient,3)/(Time(end)-Time(1));
ConversionConventionalTimeAvr=trapz(Time,ConversionConventional,3)/(Time(end)-Time(1));
ConversionTemporalTimeAvr=trapz(Time,ConversionTemporal,3)/(Time(end)-Time(1));
ConversionTimeVarient1TimeAvr=trapz(Time,ConversionTimeVarient1,3)/(Time(end)-Time(1));

ConversionTimeVarientTimeAvrDepthInt=ConversionTimeVarientTimeAvr;
ConversionConventionalTimeAvrDepthInt=ConversionConventionalTimeAvr;
ConversionTemporalTimeAvrDepthInt=ConversionTemporalTimeAvr;
ConversionTimeVarient1TimeAvrDepthInt=ConversionTimeVarient1TimeAvr;
for i=1:size(X,1)
    for j=1:size(ZC,1)
        if isnan(ConversionTimeVarientTimeAvrDepthInt(i,j))
            ConversionTimeVarientTimeAvrDepthInt(i,j)=0;
            ConversionConventionalTimeAvrDepthInt(i,j)=0;
            ConversionTemporalTimeAvrDepthInt(i,j)=0;
            ConversionTimeVarient1TimeAvrDepthInt(i,j)=0;
        end
    end
end
ConversionTimeVarientTimeAvrDepthInt=trapz(abs(ZC),ConversionTimeVarientTimeAvrDepthInt,2);
ConversionConventionalTimeAvrDepthInt=trapz(abs(ZC),ConversionConventionalTimeAvrDepthInt,2);
ConversionTemporalTimeAvrDepthInt=trapz(abs(ZC),ConversionTemporalTimeAvrDepthInt,2);
ConversionTimeVarient1TimeAvrDepthInt=trapz(abs(ZC),ConversionTimeVarient1TimeAvrDepthInt,2);

if ~contains(DataPathRead,'work-directory_0801')
	save('D:\APEResult.mat');
	ConversionPlotter(ConversionTimeVarientTimeAvr,...
        ConversionTimeVarientTimeAvrDepthInt,ConversionTemporalTimeAvrDepthInt,...
        ConversionTimeVarient1TimeAvrDepthInt,ConversionConventionalTimeAvr,...
        ConversionConventionalTimeAvrDepthInt,X,xx,zz)
else
    save('/scratch/omidvar/work-directory_0801/APEResult.mat');
end

function ConversionPlotter(ConversionTimeVarientTimeAvr,...
    ConversionTimeVarientTimeAvrDepthInt,ConversionTemporalTimeAvrDepthInt,...
    ConversionTimeVarient1TimeAvrDepthInt,ConversionConventionalTimeAvr,...
    ConversionConventionalTimeAvrDepthInt,X,xx,zz)
    

    figure;
    subplot(1,2,1)
    pcolor(xx',zz',ConversionTimeVarientTimeAvr);
    shading flat;
    colorbar;
    caxis([-1e-6 10e-6]);

    subplot(1,2,2)
    pcolor(xx',zz',ConversionConventionalTimeAvr);
    shading flat;
    colorbar;
    caxis([-1e-6 10e-6]);

    figure;hold on;
    plot(X,ConversionTimeVarientTimeAvrDepthInt);
    plot(X,ConversionConventionalTimeAvrDepthInt);
    legend('Time Varient','Conventional');

    figure;hold on;
    plot(X,ConversionTimeVarientTimeAvrDepthInt);
    plot(X,ConversionConventionalTimeAvrDepthInt);
    plot(X,ConversionTemporalTimeAvrDepthInt);
    plot(X,ConversionTimeVarient1TimeAvrDepthInt);
    legend('Time Varient','Conventional','Temporal','RhoPrimeGW');
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
    CurrentParpool=gcp;
	if (~isempty(CurrentParpool))
        delete(gcp('nocreate'));
    end
    numcores = feature('numcores');
	parpool(numcores);
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