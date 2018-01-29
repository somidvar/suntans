clear all;
close all;
clc


DataPath='D:\test3\InternalWaves\data\Result_0000.nc';
%DataPath='D:\Result_0000.nc';

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
plot(UH(21,:));
xlabel('time');
ylabel('UBT 15 m');
figure 
pcolor(Eta);
shading flat;
colorbar;
xlabel('time');
ylabel('offshore');

% pcolor(UH);
% shading flat;
% colorbar;

% figure;
% pcolor(Eta);
% shading flat;
% colorbar;
% figure;
% 
% figure('units','normalized','outerposition',[0 0 1 1])
% for k=1:size(Time,1)
%     pcolor(Z,X(1:250),U(1:250,:,k));shading flat;colorbar;caxis([-0.01 0.01]);
%     camroll(90);
%     str=strcat('Time is:',num2str(Time(k)/3600),' (hr)');
%     title(str);
%     pause(0.01);
% end
