clear;
close all;

i=12004
clearvars -except i

tic
g=9.8;
Rho0=1000;%Setting the reference density
InterpRes=100;
ntout=60;
Nkmax=149;
NETCDFWriter=0;

Omega=2*pi/(12.4*3600);%M2 Tide
%Omega=7.29347e-5;%K1 Tide
TidalCycle=0;%27
TimeStr=1;
TimeProcessStartIndex=614;
TimeProcessEndIndex=5207;
XProcessStartIndex=1;    
XProcessEndIndex=3286;
XStr=1;
TimeStartIndex=1;
CountTimeIndex=Inf;
ZMaxIndex=Inf;

DataPathRead=strcat('/scratch/omidvar/work-directory_0801/12th/suntans-triangular-',num2str(i),'/iwaves/data/')
DataPathWrite='/scratch/omidvar/work-directory_0801/';

fid = fopen(strcat(DataPathWrite,'Result-',num2str(i),'.mat'),'w');
fid=fclose(fid);    

[U,W,Density,Eta,Time,X,ZC]=NONNETCDFReader(DataPathRead,DataPathWrite,ntout,Nkmax,...
	TimeProcessStartIndex,TimeProcessEndIndex,TimeStr,XProcessStartIndex,XProcessEndIndex,...
	XStr,TidalCycle,Omega,NETCDFWriter,Rho0);

disp('DATA reading is compeleted')

Eta=movmean(Eta,2,1);
Density=movmean(Density,2,1);
U=movmean(U,2,1);
W=movmean(W,2,1);

XVector=[1:10:2251,2256:2:XProcessEndIndex];
%XVector=[1:5:4200,4250:1:5000];

% X=X(XVector);
% Density=Density(XVector,:,:);
% U=U(XVector,:,:);
% W=W(XVector,:,:);
% Eta=Eta(XVector,:);

RhoBConventional=trapz(Time,Density,3)/(Time(end)-Time(1));
RhoBConventional=repmat(RhoBConventional,1,1,size(Time,1));
RhoPrimeConventional=Density-RhoBConventional;
FourtyEightHourPeriod=48*3600/(Time(2)-Time(1));
FourtyEightHourPeriod=ceil(FourtyEightHourPeriod);
RhoPrimeConventional=RhoPrimeConventional-movmean(RhoPrimeConventional,[FourtyEightHourPeriod-1,0],3);
clear RhoBConventional;

U=U(:,:,FourtyEightHourPeriod+1:end);
W=W(:,:,FourtyEightHourPeriod+1:end);
Density=Density(:,:,FourtyEightHourPeriod+1:end);
Eta=Eta(:,FourtyEightHourPeriod+1:end);
Time=Time(FourtyEightHourPeriod+1:end);
RhoPrimeConventional=RhoPrimeConventional(:,:,FourtyEightHourPeriod+1:end);

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
clear UBar;

clear DPlusZ Depth;

ConversionConventionalWBar=g*RhoPrimeConventional.*WBar;  

ConversionConventionalTimeAvrWBar=trapz(Time,ConversionConventionalWBar,3)/(Time(end)-Time(1));

ConversionConventionalTimeAvrDepthIntWBar=ConversionConventionalTimeAvrWBar;
ConversionConventionalTimeAvrDepthIntWBar(isnan(ConversionConventionalTimeAvrDepthIntWBar))=0;
ConversionConventionalTimeAvrDepthIntWBar=trapz(-ZC,ConversionConventionalTimeAvrDepthIntWBar,2);

ConversionConventionalWBar=single(ConversionConventionalWBar);
ConversionConventionalTimeAvrWBar=single(ConversionConventionalTimeAvrWBar);
ConversionConventionalTimeAvrDepthIntWBar=single(ConversionConventionalTimeAvrDepthIntWBar);

Density=single(Density);
Eta=single(Eta);
RhoPrimeConventional=single(RhoPrimeConventional);
U=single(U);
W=single(W);
WBar=single(WBar);

if ~contains(DataPathRead,'work-directory_0801')
	save('D:\Result.mat','-v7.3');
else
	TempAddress=strfind(DataPathRead,'-');
	TempAddress=strcat(DataPathWrite,'Result-',DataPathRead(TempAddress(3)+1:TempAddress(3)+5),'.mat');
	save(TempAddress,'-v7.3');
end
toc