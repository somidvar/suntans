%This program has been written by Sorush Omidvar under supervision of 
%Dr. Woodson in Cobia lab at UGA in Sep 2018 to validate the use of 
%time-varient RhoB in the calculation of APE.

clear;
close all;

g=9.8;
Rho0=1000;%Setting the reference density
InterpRes=100;
ntout=10;
Nkmax=200;
NETCDFWriter=0;

Omega=1.4026e-4;%M2 Tide
%Omega=7.29347e-5;%K1 Tide
TidalCycle=3;
TimeStr=1;
TimeProcessStartIndex=nan;
TimeProcessEndIndex=nan;
XProcessStartIndex=1;    
XProcessEndIndex=5000;
XStr=1;
TimeStartIndex=1;
CountTimeIndex=Inf;
ZMaxIndex=Inf;

DataPathRead='/scratch/omidvar/work-directory_0801/Unstratified/iwaves/data/';
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

XVector=[1:5:4200,4250:1:5000];

X=X(XVector);
W=W(XVector,:,:);
Eta=Eta(XVector,:);
Density=Density(XVector,:,:);
U=U(XVector,:,:);

Gamma=permute(repmat(ZC,1,size(X,1),size(Time,1)),[2,1,3]);
Gamma=1-Gamma/nanmin(Gamma(:));
Gamma=Gamma.*permute(repmat(Eta(floor(size(X,1)/3),:),size(X,1),1,size(ZC,1)),[1,3,2]);

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

Gamma=single(Gamma);
Eta=single(Eta);
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