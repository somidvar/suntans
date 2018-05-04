close all;
clear all;
clc;

FigureSize=[1900,900];
f=figure('Position',[1 1 FigureSize(1) FigureSize(2)],'units','pixels','Resize','off');
movegui(f,'center');

Address='F:\9th\suntans-9th-90001\InternalWaves\data\Result_0000.nc';
Density=ncread(Address,'rho',[1,1,1],[200,Inf,100]);
U=ncread(Address,'uc',[1,1,1],[200,Inf,100]);
W=ncread(Address,'w',[1,1,1],[200,Inf,100]);
W=movsum(W,2,2)/2;
W(:,1,:)=[];%disregarding the first layer becaue for cell i movsum is summing i-1 and i
X=ncread(Address,'xv',1,200);
Z=-ncread(Address,'z_r');
[ZZ,XX]=meshgrid(Z,X/1000);
Time1=10;
Time2=11;
Time3=12;
UMin=-0.1;
UMax=0.1;
WMin=-0.01;
WMax=0.01;

subplot('position',[0.05,0.10,0.4,0.25]);%Bottom Left
pcolor(XX,ZZ,squeeze(U(:,:,Time1)));
shading flat;
colorbar;
ylabel('Depth (m)');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
hold on;
contour(XX,ZZ,squeeze(Density(:,:,Time1)),5,'black');
xlabel('Offshore Distance (km)');
caxis([UMin,UMax]);

subplot('position',[0.55,0.10,0.4,0.25]);%bottom right
pcolor(XX,ZZ,squeeze(W(:,:,Time1)));
shading flat;
colorbar;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
hold on;
contour(XX,ZZ,squeeze(Density(:,:,Time1)),5,'black');
xlabel('Offshore Distance (km)');
set(gca,'yticklabel',{[]}) ;
caxis([WMin,WMax]);

Address='F:\9th\suntans-9th-90001\InternalWaves\data\Result_0000.nc';
Density=ncread(Address,'rho',[1,1,1],[200,Inf,100]);
U=ncread(Address,'uc',[1,1,1],[200,Inf,100]);
W=ncread(Address,'w',[1,1,1],[200,Inf,100]);
W=movsum(W,2,2)/2;
W(:,1,:)=[];%disregarding the first layer becaue for cell i movsum is summing i-1 and i

subplot('position',[0.05,0.40,0.4,0.25]);%Middle Left
pcolor(XX,ZZ,squeeze(U(:,:,Time2)));
shading flat;
colorbar;
ylabel('Depth (m)');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
hold on;
contour(XX,ZZ,squeeze(Density(:,:,Time2)),5,'black');
set(gca,'xticklabel',{[]}) ;
caxis([UMin,UMax]);

subplot('position',[0.55,0.40,0.4,0.25]);%Middle Right
pcolor(XX,ZZ,squeeze(W(:,:,Time2)));
shading flat;
colorbar;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
hold on;
contour(XX,ZZ,squeeze(Density(:,:,Time2)),5,'black');
set(gca,'xticklabel',{[]}) ;
set(gca,'yticklabel',{[]}) ;
caxis([WMin,WMax]);


Address='F:\9th\suntans-9th-90001\InternalWaves\data\Result_0000.nc';
Density=ncread(Address,'rho',[1,1,1],[200,Inf,100]);
U=ncread(Address,'uc',[1,1,1],[200,Inf,100]);
W=ncread(Address,'w',[1,1,1],[200,Inf,100]);
W=movsum(W,2,2)/2;
W(:,1,:)=[];%disregarding the first layer becaue for cell i movsum is summing i-1 and i


subplot('position',[0.05,0.70,0.4,0.25]);%Top Left
pcolor(XX,ZZ,squeeze(U(:,:,Time3)));
shading flat;
colorbar;
ylabel('Depth (m)');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
hold on;
contour(XX,ZZ,squeeze(Density(:,:,Time3)),5,'black');
set(gca,'xticklabel',{[]}) ;
caxis([UMin,UMax]);

subplot('position',[0.55,0.70,0.4,0.25]);%Top Right
pcolor(XX,ZZ,squeeze(W(:,:,Time3)));
shading flat;
colorbar;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
hold on;
contour(XX,ZZ,squeeze(Density(:,:,Time3)),5,'black');
set(gca,'yticklabel',{[]}) ;
set(gca,'xticklabel',{[]}) ;
caxis([WMin,WMax]);


annotation(f,'textbox',[0.01 0.92 0.04 0.04],'String','a)','fontsize',20,'EdgeColor','none','FontWeight','bold');
annotation(f,'textbox',[0.01 0.62 0.04 0.04],'String','b)','fontsize',20,'EdgeColor','none','FontWeight','bold');
annotation(f,'textbox',[0.01 0.32 0.04 0.04],'String','c)','fontsize',20,'EdgeColor','none','FontWeight','bold');
annotation(f,'textbox',[0.53 0.92 0.04 0.04],'String','d)','fontsize',20,'EdgeColor','none','FontWeight','bold');
annotation(f,'textbox',[0.53 0.62 0.04 0.04],'String','e)','fontsize',20,'EdgeColor','none','FontWeight','bold');
annotation(f,'textbox',[0.53 0.32 0.04 0.04],'String','f)','fontsize',20,'EdgeColor','none','FontWeight','bold');

saveas(f,'Velocity.png');