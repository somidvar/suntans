clear all;
close all;
clc


DataPath='D:\Result_0000.nc';

U=ncread(DataPath,'uc');
Eta=ncread(DataPath,'eta');
X=ncread(DataPath,'xv');
Z=ncread(DataPath,'z_r')*-1;
Time=ncread(DataPath,'time');
RhoB=ncread(DataPath,'rho',[1,1,1],[Inf,Inf,1]);

HTotal=repmat(Z,1,size(X,1))'+RhoB*0;
Depth=nanmin(HTotal,[],2);
Depth=repmat(Depth,1,size(Time,1));
HTotal=repmat(HTotal,1,1,size(Time,1));
HTotalDiff=diff(HTotal,1,2);
HTotalDiff(:,end+1,:)=HTotalDiff(:,end,:);

UH=squeeze(nansum(U.*HTotalDiff,2))./Depth;
pcolor(UH);
shading flat;

figure;
pcolor(Eta);
shading flat;
