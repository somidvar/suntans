%This program has been written by Sorush Omidvar under supervision of 
%Dr. Woodson in Cobia lab at UGA in Sep 2018 to validate the use of 
%time-varient RhoB in the calculation of APE.

clear;
close all;

g=9.8;
Rho0=1000;%Setting the reference density
InterpRes=100;
ntout=10;
Nkmax=400;
NETCDFWriter=0;

Omega=1.4026e-4;%M2 Tide
%Omega=7.29347e-5;%K1 Tide
TidalCycle=3;
TimeStr=1;
TimeProcessStartIndex=nan;
TimeProcessEndIndex=nan;
XProcessStartIndex=1;    
XProcessEndIndex=2500;
XStr=1;
TimeStartIndex=1;
CountTimeIndex=Inf;
ZMaxIndex=Inf;

DataPathRead='/scratch/omidvar/work-directory_0801/DeepShallow/iwaves/data/';
DataPathWrite='/scratch/omidvar/work-directory_0801/';
DataPath='/scratch/omidvar/work-directory_0801/example.nc';

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');  

if isempty(dir(strcat(DataPathRead,'*.nc')))
	disp('No Input NETCDF was found')
	[U,W,Density,q,Eta,Time,X,ZC]=NONNETCDFReader(DataPathRead,...
		DataPathWrite,ntout,Nkmax,TimeProcessStartIndex,TimeProcessEndIndex,...
		TimeStr,XProcessStartIndex,XProcessEndIndex,XStr,TidalCycle,Omega,...
		NETCDFWriter,Rho0);
else
	disp('Input NETCDF was found')
	disp(strcat('Reading the NETCDF at',DataPath))
	X=ncread(DataPath,'xv',XProcessStartIndex,XProcessEndIndex);
	Time=ncread(DataPath,'time',TimeStartIndex,CountTimeIndex,TimeStr);
	ZC=-ncread(DataPath,'z_r',1,ZMaxIndex);%I changed ZC and ZE sign to make it compatible with formulas
	Eta=ncread(DataPath,'eta',[XProcessStartIndex,TimeStartIndex],[XProcessEndIndex,CountTimeIndex],[1,TimeStr]);
	disp('Eta is done')
	Temp=ncinfo(DataPath,'w');
	Temp=Temp.Size(2);
	W=ncread(DataPath,'w',[XProcessStartIndex,1,TimeStartIndex],[XProcessEndIndex,ZMaxIndex+1,CountTimeIndex],[1,1,TimeStr]);
	W=movsum(W,2,2)/2;%Averaging the w over two horizontal edge to get the center value
	W(:,1,:)=[];%disregarding the first layer becaue for cell i movsum is summing i-1 and i
	disp('W is done')
	Density=Rho0*ncread(DataPath,'rho',[XProcessStartIndex,1,TimeStartIndex],[XProcessEndIndex,ZMaxIndex,CountTimeIndex],[1,1,TimeStr]);
	disp('Density is done')
end
disp('DATA reading is compeleted')

clear q;
X=movmean(X,2);
W=movmean(W,2,1);
Eta=movmean(Eta,2,1);
Density=movmean(Density,2,1);
U=movmean(U,2,1);

XVector=[1:3:1930,1931:1:2500];

X=X(XVector);
W=W(XVector,:,:);
Eta=Eta(XVector,:);
Density=Density(XVector,:,:);
U=U(XVector,:,:);

Gamma=permute(repmat(ZC,1,size(X,1),size(Time,1)),[2,1,3]);
Gamma=1-Gamma/nanmin(Gamma(:));
Gamma=Gamma.*permute(repmat(Eta(floor(size(X,1)/3),:),size(X,1),1,size(ZC,1)),[1,3,2]);

RhoBConventional=trapz(Time,Density,3)/(Time(end)-Time(1));

disp('EPPrime calculation is started')
[RhoBTimeVarient,IsopycnalDislocation,ConversionTemporal]=EPCalculator(X,ZC,Time,Density,RhoBConventional,Gamma,InterpRes,g);
disp('EPPrime calculation is done')      
RhoBConventional=repmat(RhoBConventional,1,1,size(Time,1));

DPlusZ=permute(repmat(ZC,1,size(X,1),size(Time,1)),[2,1,3])+W*0;
Depth=nanmin(DPlusZ,[],2);
DPlusZ=DPlusZ-repmat(Depth,1,size(ZC,1),1);

UBar=U;
UBar(isnan(UBar))=0;
UBar=repmat(trapz(-ZC,UBar,2),1,size(ZC,1),1);
UBar=UBar./-repmat(Depth,1,size(ZC,1),1);
UBar=UBar+0*W;
WBar=-diff(DPlusZ.*UBar,1,1)./repmat(diff(X,1,1),1,size(ZC,1),size(Time,1));
WBar(end+1,:,:)=WBar(end,:,:);

clear DPlusZ Depth;

RhoPrimeConventional=Density-RhoBConventional;
RhoPrimeTimeVarient=Density-RhoBTimeVarient;
ConversionTimeVarient1W=RhoPrimeTimeVarient.*W*g;
ConversionTimeVarientW=ConversionTimeVarient1W+ConversionTemporal;  
ConversionConventionalW=g*RhoPrimeConventional.*W;  

ConversionTimeVarient1WBar=RhoPrimeTimeVarient.*WBar*g;
ConversionTimeVarientWBar=ConversionTimeVarient1WBar+ConversionTemporal;  
ConversionConventionalWBar=g*RhoPrimeConventional.*WBar;  

clear Density;

[xx,zz]=meshgrid(X,ZC);
ConversionTimeVarientTimeAvrW=trapz(Time,ConversionTimeVarientW,3)/(Time(end)-Time(1));
ConversionConventionalTimeAvrW=trapz(Time,ConversionConventionalW,3)/(Time(end)-Time(1));
ConversionTimeVarient1TimeAvrW=trapz(Time,ConversionTimeVarient1W,3)/(Time(end)-Time(1));

ConversionTimeVarientTimeAvrWBar=trapz(Time,ConversionTimeVarientWBar,3)/(Time(end)-Time(1));
ConversionConventionalTimeAvrWBar=trapz(Time,ConversionConventionalWBar,3)/(Time(end)-Time(1));
ConversionTimeVarient1TimeAvrWBar=trapz(Time,ConversionTimeVarient1WBar,3)/(Time(end)-Time(1));

ConversionTemporalTimeAvr=trapz(Time,ConversionTemporal,3)/(Time(end)-Time(1));

ConversionTimeVarientTimeAvrDepthIntW=ConversionTimeVarientTimeAvrW;
ConversionTimeVarientTimeAvrDepthIntW(isnan(ConversionTimeVarientTimeAvrDepthIntW))=0;
ConversionTimeVarientTimeAvrDepthIntW=trapz(-ZC,ConversionTimeVarientTimeAvrDepthIntW,2);

ConversionConventionalTimeAvrDepthIntW=ConversionConventionalTimeAvrW;
ConversionConventionalTimeAvrDepthIntW(isnan(ConversionConventionalTimeAvrDepthIntW))=0;
ConversionConventionalTimeAvrDepthIntW=trapz(-ZC,ConversionConventionalTimeAvrDepthIntW,2);

ConversionTimeVarient1TimeAvrDepthIntW=ConversionTimeVarient1TimeAvrW;
ConversionTimeVarient1TimeAvrDepthIntW(isnan(ConversionTimeVarient1TimeAvrDepthIntW))=0;
ConversionTimeVarient1TimeAvrDepthIntW=trapz(-ZC,ConversionTimeVarient1TimeAvrDepthIntW,2);

ConversionTimeVarientTimeAvrDepthIntWBar=ConversionTimeVarientTimeAvrWBar;
ConversionTimeVarientTimeAvrDepthIntWBar(isnan(ConversionTimeVarientTimeAvrDepthIntWBar))=0;
ConversionTimeVarientTimeAvrDepthIntWBar=trapz(-ZC,ConversionTimeVarientTimeAvrDepthIntWBar,2);

ConversionConventionalTimeAvrDepthIntWBar=ConversionConventionalTimeAvrWBar;
ConversionConventionalTimeAvrDepthIntWBar(isnan(ConversionConventionalTimeAvrDepthIntWBar))=0;
ConversionConventionalTimeAvrDepthIntWBar=trapz(-ZC,ConversionConventionalTimeAvrDepthIntWBar,2);

ConversionTimeVarient1TimeAvrDepthIntWBar=ConversionTimeVarient1TimeAvrWBar;
ConversionTimeVarient1TimeAvrDepthIntWBar(isnan(ConversionTimeVarient1TimeAvrDepthIntWBar))=0;
ConversionTimeVarient1TimeAvrDepthIntWBar=trapz(-ZC,ConversionTimeVarient1TimeAvrDepthIntWBar,2);

ConversionTemporalTimeAvrDepthInt=ConversionTemporalTimeAvr;
ConversionTemporalTimeAvrDepthInt(isnan(ConversionTemporalTimeAvrDepthInt))=0;
ConversionTemporalTimeAvrDepthInt=trapz(-ZC,ConversionTemporalTimeAvrDepthInt,2);

ConversionConventionalWBar=single(ConversionConventionalWBar);
ConversionTimeVarientWBar=single(ConversionTimeVarientWBar);
ConversionTimeVarient1WBar=single(ConversionTimeVarient1WBar);
ConversionConventionalW=single(ConversionConventionalW);
ConversionTimeVarientW=single(ConversionTimeVarientW);
ConversionTimeVarient1W=single(ConversionTimeVarient1W);
ConversionTemporal=single(ConversionTemporal);
Gamma=single(Gamma);
IsopycnalDislocation=single(IsopycnalDislocation);
RhoBConventional=single(RhoBConventional);
RhoBTimeVarient=single(RhoBTimeVarient);
RhoPrimeConventional=single(RhoPrimeConventional);
RhoPrimeTimeVarient=single(RhoPrimeTimeVarient);
W=single(W);
WBar=single(WBar);
U=single(U);
UBar=single(UBar);

if ~contains(DataPathRead,'work-directory_0801')
	save('D:\APEResult.mat','-v7.3');
	ConversionPlotter(ConversionTimeVarientTimeAvr,...
		ConversionTimeVarientTimeAvrDepthInt,ConversionTemporalTimeAvrDepthInt,...
		ConversionTimeVarient1TimeAvrDepthInt,ConversionConventionalTimeAvr,...
		ConversionConventionalTimeAvrDepthInt,X,xx,zz)
else
	TempAddress=strfind(DataPathRead,'/');
	save(strcat(DataPathRead(1:TempAddress(4)),DataPathRead(TempAddress(4)+1:TempAddress(5)-1),'APE.mat'),'-v7.3');
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

function [RhoBTimeVarient,IsopycnalDislocation,ConversionTemporal]=EPCalculator(X,ZC,Time,Density,RhoBConventional,Gamma,InterpRes,g)   
    %To better calculate the APE, teh whole density profile is interpolated
    %at each time step for each X. The  the displacement of isopycanls was
    %calculated. After that, the resolution was reduced to the normal. This
    %process has been done to capture the small displacment of isopycanls
    %and also not to interfere with the original vertical resolution.
    CurrentParpool=gcp;
 	if (~isempty(CurrentParpool))
         delete(gcp('nocreate'));
    end
    numcores = feature('numcores');
 	parpool(numcores);
    
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