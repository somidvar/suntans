close all;
set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');  
cd D:\Results\;

%Fig 1:RhoB Rho' and converstion at specific X and Z VS time for FLAT case
clear all;
clc;

load('D:\Results\FlatBathymetryAPE','RhoBConventional','RhoBTimeVarient',...
    'RhoPrimeConventional','RhoPrimeTimeVarient','X','ZC','Time',...
    'ConversionConventionalW','ConversionTimeVarientW','Eta');
XPOS=250;
ZPOS=56;

MargineTop=0.10;
MargineBot=0.10;
MargineLeft=0.17;
MargineRight=0.05;
SubplotSpac=0.03;
SubplotNumber=4;

FIG=figure('position',[400 100 800 800]);
omega=1.4026e-4;

SubplotCounter=4;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,squeeze(Eta(XPOS,:)),'-k','LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -0.55 0.55]);
set(gca,'XTickLabel','');
text(0.1,0.4,'a','fontsize',24);
MyYLabel=ylabel({'$\eta$';'$[m]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.10, 0.5, 0]);

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,squeeze(RhoBTimeVarient(XPOS,ZPOS,:)-20),'LineWidth',2);
hold on;
plot((Time-Time(1))*omega/2/pi,squeeze(RhoBConventional(XPOS,ZPOS,:)-20),'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 5.819 5.837]);
set(gca,'XTickLabel','');
yticks([5.82 5.83]);
set(gca,'YTickLabel',[5.82 5.83]);
text(0.1,5.831,'b','fontsize',24);
MyYLabel=ylabel({'$\rho_b$';'$[kg.m^{-3}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.10, 0.5, 0]);

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,1000*squeeze(RhoPrimeTimeVarient(XPOS,ZPOS,:)),'LineWidth',2);
hold on;
plot((Time-Time(1))*omega/2/pi,1000*squeeze(RhoPrimeConventional(XPOS,ZPOS,:)),'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -4.9 4.9]);
set(gca,'XTickLabel','');
yticks([-4 4]);
text(0.1,3.5,'c','fontsize',24);
MyYLabel=ylabel({'$\rho''$';'$[10^{-3}$ $kg.m^{-3}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.10, 0.5, 0]);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,1e6*squeeze(ConversionTimeVarientW(XPOS,ZPOS,:)),'LineWidth',2);
hold on;
plot((Time-Time(1))*omega/2/pi,1e6*squeeze(ConversionConventionalW(XPOS,ZPOS,:)),'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -1.1 1.1]);
xlabel('t/T $[cycle^{-1}]$','fontsize',18);
text(0.1,0.8,'d','fontsize',24);
MyYLabel=ylabel({'$C$';'$[10^{-6}$ $W.m^{-3}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.10, 0.5, 0]);
lgd=legend('Time Varying','Conventional','Orientation','horizontal',[350 570 .1 .1]);
lgd.FontSize=16;
savefig(FIG,'1-Flat');
saveas(FIG,'1-Flat','epsc');
%%
%Fig 2: W velocity for shallow and deep model to show the rays, reflection
%and whole domain
clear all;

TimePos=120;
load('D:\Results\ShallowAPE.mat','W','X','ZC');
WShallow=W;
XShallow=X;
ZCShallow=ZC;

load('D:\Results\DeepShallowAPE.mat','W','X','ZC');
WDeep=W;
XDeep=X;
ZCDeep=ZC;

MapColorNumber=20;
MapColors=cumsum(5*0.95.^(1:MapColorNumber));
MapColors=MapColors-min(MapColors);
MapColors=MapColors/(max(MapColors))/1.2;
%Adding white color to the map
CustomMap=zeros(2*size(MapColors,2)+1,3);
CustomMap(1:size(MapColors,2),1)=MapColors;
CustomMap(1:size(MapColors,2),2)=MapColors;
CustomMap(1:size(MapColors,2),3)=1;
CustomMap(size(MapColors,2)+1,1)=1;
CustomMap(size(MapColors,2)+1,2)=1;
CustomMap(size(MapColors,2)+1,3)=1;
CustomMap(size(MapColors,2)+2:end,3)=fliplr(MapColors);
CustomMap(size(MapColors,2)+2:end,2)=fliplr(MapColors);
CustomMap(size(MapColors,2)+2:end,1)=1;

FIG=figure('position',[400 100 800 800]);
MargineTop=0.05;
MargineBot=0.10;
MargineLeft=0.15;
MargineRight=0.05;
SubplotSpac=0.10;
SubplotNumber=2;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(movmean(XShallow/1000,10),ZCShallow,1e3*movmean(squeeze(WShallow(:,:,TimePos)),10,1)');shading flat;colorbar;caxis([-3.2e-1 3.2e-1]);
colormap(CustomMap);
MyColorbar= colorbar;
MyColorbar.TickLabelInterpreter='latex';
text(130,20,'$W$ $[10^{-3} m/s]$','Interpreter','latex','Fontsize',18);
set(gca,'fontsize',16);
ylabel('Z [m]','fontsize',18);
set(gca, 'Color', 'Black');
text(5,-25,'a','fontsize',24);
ylim([-305,0]);
set(gca,'YTick',[-300:100:0]);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(XDeep/1000,ZCDeep,1e3*squeeze(WDeep(:,:,TimePos))');shading flat;colorbar;caxis([-1 1]);
colormap(CustomMap);
set(gca,'fontsize',16);
xlabel('Offshore distance (km)','fontsize',18);
text(350,200,'$W$ $[10^{-3} m/s]$','Interpreter','latex','Fontsize',18);
ylabel('Z [m]','fontsize',18);
set(gca, 'Color', 'Black');
text(10,-250,'b','fontsize',24);
ylim([-3050,0]);
set(gca,'YTick',[-3000:1000:0]);
savefig(FIG,'2-W-Shallow-DeepModel');
saveas(FIG,'2-W-Shallow-DeepModel','epsc');
%%
%Fig 3: Density stratification and N^2 for both models.
clear all;

load('D:\Results\ShallowAPE.mat','ZC','RhoBConventional');
ZCShallow=ZC;
RhoBConventionalShallow=RhoBConventional;

load('D:\Results\DeepShallowAPE.mat','ZC','RhoBConventional');
ZCDeep=ZC;
RhoBConventionalDeep=RhoBConventional;

XPosDeep=56;
XPosShallow=56;
TimePos=10;

FIG=figure('position',[100 100 1000 800]);
MargineTop=0.15;
MargineBot=0.11;
MargineLeft=0.10;
MargineRight=0.51;
SubplotSpac=0.02;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
x1 = squeeze(RhoBConventionalShallow(XPosShallow,:,TimePos)-20);
y1 = ZCShallow;
x2=sqrt(abs(-9.8/1000*diff(squeeze(RhoBConventionalShallow(XPosShallow,:,TimePos)))./diff(ZCShallow)'));
y2=ZCShallow(1:end-1);
line(x1,y1,'Color','black','LineStyle','-','LineWidth',2);
ax1 = gca; % current axes
ax1.XColor = 'black';
ax1.YColor = 'black';
set(gca,'fontsize',16);

ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,'XAxisLocation','top','YAxisLocation','right','Color','none');
set(gca,'YTickLabel','');
line(x2,y2,'Parent',ax2,'Color','black','LineStyle',':','LineWidth',2);
set(gca,'fontsize',16);
MyText=text(-0.007,-150,'$Z$ $[m]$','Interpreter','latex','Fontsize',20);
set(MyText,'Rotation',90);
text(0.012,-330,'$\rho_b$ $[kg.m^{-3}]$','Interpreter','latex','Fontsize',20);
text(0.014,30,'$N$ $[1/s]$','Interpreter','latex','Fontsize',20);
axis([0 0.034 -300 0]);
set(gca,'XTick',[0.005:0.010:0.030]);
text(0.002,-20,'a','fontsize',24);


MargineTop=0.15;
MargineBot=0.11;
MargineLeft=0.51;
MargineRight=0.10;
SubplotSpac=0.02;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
x1 = squeeze(RhoBConventionalDeep(XPosDeep,:,TimePos)-20);
y1 = ZCDeep;
x2=sqrt(abs(-9.8/1000*diff(squeeze(RhoBConventionalDeep(XPosDeep,:,TimePos)))./diff(ZCDeep)'));
y2=ZCDeep(1:end-1);
line(x1,y1,'Color','black','LineStyle','-','LineWidth',2);
ax1 = gca; % current axes
set(gca,'YTickLabel','');
ax1.XColor = 'black';
ax1.YColor = 'black';
set(gca,'fontsize',16);

ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,'XAxisLocation','top','YAxisLocation','right','Color','none');
line(x2,y2,'Parent',ax2,'Color','black','LineStyle',':','LineWidth',2);
set(gca,'fontsize',16);
MyText=text(0.0255,-1400,'$Z$ $[m]$','Interpreter','latex','Fontsize',20);
set(MyText,'Rotation',90);
text(0.007,-3300,'$\rho_b$ $[kg.m^{-3}]$','Interpreter','latex','Fontsize',20);
text(0.009,300,'$N$ $[1/s]$','Interpreter','latex','Fontsize',20);
set(gca,'XTick',[0.001 0.005:0.005:0.020]);
axis([0 0.021 -3000 0]);
text(0.001,-200,'b','fontsize',24);
line(min(x2),min(y2),'Parent',ax2,'Color','black','LineStyle','-','LineWidth',2);
lgd=legend('Brunt-Vaisala','Density background',[380 570 20 .1]);
lgd.FontSize=16;
savefig(FIG,'3-DensityStratification');
saveas(FIG,'3-DensityStratification','epsc');
%%
%Fig 4: RhoB, Rho', conversion, Temporal terms for shallow case at specific X and Z
clear all;

load('D:\Results\ShallowAPE.mat','Time','X','ZC','RhoBConventional','RhoPrimeConventional','RhoBTimeVarient','RhoPrimeTimeVarient','ConversionConventionalWBar','ConversionTimeVarientWBar','ConversionTimeVarient1WBar','ConversionTemporal');

XPOS=952;
ZPOS=43;

FIG=figure('position',[100 100 1600 800]);
omega=1.4026e-4;
MargineTop=0.07;
MargineBot=0.07;
MargineLeft=0.10;
MargineRight=0.55;
SubplotSpac=0.02;
SubplotNumber=3;

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,squeeze(RhoBTimeVarient(XPOS,ZPOS,:)-20),'LineWidth',2);
hold on;
plot((Time-Time(1))*omega/2/pi,squeeze(RhoBConventional(XPOS,ZPOS,:)-20),'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 2.31 2.33]);
set(gca,'XTickLabel','');
text(0.1,2.328,'a','fontsize',24);
MyYLabel=ylabel({'$\rho_b$';'$[kg.m^{-3}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.15, 0.5, 0]);

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,100*squeeze(RhoPrimeTimeVarient(XPOS,ZPOS,:)),'LineWidth',2);
hold on;
plot((Time-Time(1))*omega/2/pi,100*squeeze(RhoPrimeConventional(XPOS,ZPOS,:)),'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -3.9 +3.9]);
set(gca,'XTickLabel','');
text(0.1,3,'b','fontsize',24);
MyYLabel=ylabel({'$\rho''$';'$[10^{2}*kg.m^{-3}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.15, 0.5, 0]);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(ConversionTimeVarientWBar(XPOS,ZPOS,:)),'LineWidth',2);
hold on;
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(ConversionConventionalWBar(XPOS,ZPOS,:)),'LineWidth',2);
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(ConversionTimeVarient1WBar(XPOS,ZPOS,:)),':','color',[0 113/255 188/255],'LineWidth',2);
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(ConversionTemporal(XPOS,ZPOS,:)),'--','color',[0 113/255 188/255],'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -1 3.5]);
text(0.1,3,'c','fontsize',24);
MyYLabel=ylabel({'$C$';'$[10^{4}*W.m^{-3}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.15, 0.5, 0]);
xlabel('t/T','fontsize',18);

load('D:\Results\DeepShallowAPE.mat','Time','X','ZC','RhoBConventional','RhoPrimeConventional','RhoBTimeVarient','RhoPrimeTimeVarient','ConversionConventionalWBar','ConversionTimeVarientWBar','ConversionTimeVarient1WBar','ConversionTemporal');

XPOS=784;
ZPOS=172;

MargineTop=0.07;
MargineBot=0.07;
MargineLeft=0.55;
MargineRight=0.10;
SubplotSpac=0.02;
SubplotNumber=3;

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,squeeze(RhoBTimeVarient(XPOS,ZPOS,:)-20),'LineWidth',2);
hold on;
plot((Time-Time(1))*omega/2/pi,squeeze(RhoBConventional(XPOS,ZPOS,:)-20),'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 4.1325 4.137]);
set(gca,'XTickLabel','');
text(0.1,4.1365,'d','fontsize',24);

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,1e2*squeeze(RhoPrimeTimeVarient(XPOS,ZPOS,:)),'LineWidth',2);
hold on;
plot((Time-Time(1))*omega/2/pi,1e2*squeeze(RhoPrimeConventional(XPOS,ZPOS,:)),'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -0.8 0.8]);
set(gca,'XTickLabel','');
text(0.1,0.6,'e','fontsize',24);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(ConversionTimeVarientWBar(XPOS,ZPOS,:)),'LineWidth',2);
hold on;
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(ConversionConventionalWBar(XPOS,ZPOS,:)),'LineWidth',2);
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(ConversionTimeVarient1WBar(XPOS,ZPOS,:)),':','color',[0 113/255 188/255],'LineWidth',2);
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(ConversionTemporal(XPOS,ZPOS,:)),'--','color',[0 113/255 188/255],'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -0.3 1.1]);
text(0.1,0.95,'f','fontsize',24);
xlabel('t/T','fontsize',18);
lgd=legend('Time Varying','Conventional','$\rho''gw$','Temporal','Orientation','horizontal',[600 580 20 .1]);
lgd.FontSize=16;
savefig(FIG,'4-Conversion-Shallow-Deep');
saveas(FIG,'4-Conversion-Shallow-Deep','epsc');
%%
%Fig5: Pcolor of conversion
clear all;

load('D:\Results\ShallowAPE.mat','X','ZC','ConversionConventionalTimeAvrWBar','ConversionTimeVarientTimeAvrWBar');

MapColorNumber=40;
%Using MapColorBrightnessThreshold to distinct the colors from white
MapColorBrightnessThreshold=0.5;
%MapColors=logspace(0,MapColorBrightnessThreshold,MapColorNumber);
MapColors=cumsum(5*0.95.^(1:MapColorNumber));
MapColors=MapColors-min(MapColors);
MapColors=MapColors/(max(MapColors))/1.2;
%Adding white color to the map
CustomMap=zeros(2*size(MapColors,2)+1,3);
CustomMap(1:size(MapColors,2),1)=MapColors;
CustomMap(1:size(MapColors,2),2)=MapColors;
CustomMap(1:size(MapColors,2),3)=1;
CustomMap(size(MapColors,2)+1,1)=1;
CustomMap(size(MapColors,2)+1,2)=1;
CustomMap(size(MapColors,2)+1,3)=1;
CustomMap(size(MapColors,2)+2:end,3)=fliplr(MapColors);
CustomMap(size(MapColors,2)+2:end,2)=fliplr(MapColors);
CustomMap(size(MapColors,2)+2:end,1)=1;

FIG=figure('position',[100 100 1600 800]);
omega=1.4026e-4;
MargineTop=0.03;
MargineBot=0.10;
MargineLeft=0.06;
MargineRight=0.53;
SubplotSpac=0.10;
SubplotNumber=2;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(movmean(X/1000,5),ZC,movmean(1e5*ConversionConventionalTimeAvrWBar',5,2));shading flat;caxis([-12 12]);
colormap(CustomMap);
MyColorbar=colorbar('Location','south','Position',[MargineLeft+0.12, MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber-SubplotSpac+0.05, 1-MargineLeft-MargineRight-0.12, SubplotSpac-0.06]);
MyColorbar.TickLabelInterpreter='latex';
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
text(5,-20,'a','fontsize',24);
ylabel('$Z$ $[m]$','fontsize',18);
set(gca,'Color','Black');
text(0,-325,'C$ $[$10^{-5}$ $W.m^{-3}$]','Interpreter','latex','Fontsize',18);
ylim([-305,0]);
set(gca,'YTick',[-300:100:0]);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(movmean(X/1000,5),ZC,movmean(1e5*ConversionTimeVarientTimeAvrWBar',5,2));shading flat;caxis([-12 12]);
colormap(CustomMap);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
text(5,-20,'b','fontsize',24);
ylabel('$Z$ $[m]$','fontsize',18);
xlabel('Offshore Distance (km)','fontsize',18);
set(gca,'Color','Black');
ylim([-305,0]);
set(gca,'YTick',[-300:100:0]);

load('D:\Results\DeepDeepAPE.mat','X','ZC','ConversionConventionalTimeAvrWBar','ConversionTimeVarientTimeAvrWBar');

MargineTop=0.03;
MargineBot=0.10;
MargineLeft=0.53;
MargineRight=0.06;
SubplotSpac=0.10;
SubplotNumber=2;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(movmean(X/1000,5),ZC,movmean(1e5*ConversionConventionalTimeAvrWBar',5,2));shading flat;caxis([-5 5]);
colormap(CustomMap);
MyColorbar=colorbar('Location','south','Position',[MargineLeft+0.12, MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber-SubplotSpac+0.05, 1-MargineLeft-MargineRight-0.12, SubplotSpac-0.06]);
MyColorbar.TickLabelInterpreter='latex';
text(0,-3250,'C$ $[$10^{-5}$ $W.m^{-3}$]','Interpreter','latex','Fontsize',18);
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
text(15,-200,'c','fontsize',24);
set(gca,'Color','Black');
ylim([-3050,0]);
set(gca,'YTick',[-3000:1000:0]);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(movmean(X/1000,5),ZC,movmean(1e5*ConversionTimeVarientTimeAvrWBar',5,2));shading flat;caxis([-5 5]);
colormap(CustomMap);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
text(15,-200,'d','fontsize',24);
xlabel('Offshore Distance (km)','fontsize',18);
set(gca,'Color','Black');
ylim([-3050,0]);
set(gca,'YTick',[-3000:1000:0]);
savefig(FIG,'5-ConversionTimeAvr-Shallow-Deep');
saveas(FIG,'5-ConversionTimeAvr-Shallow-Deep','epsc');
%%
%Fig 6: Depth-integrated time-averaged Conversion for shallow and deep
%model
clear all;

load('D:\Results\ShallowAPE.mat','X','ConversionConventionalTimeAvrDepthIntWBar','ConversionTimeVarient1TimeAvrDepthIntWBar','ConversionTimeVarientTimeAvrDepthIntWBar','ConversionTemporalTimeAvrDepthInt');
XShallow=X;
ConversionConventionalTimeAvrDepthIntWBarShallow=ConversionConventionalTimeAvrDepthIntWBar;
ConversionTimeVarient1TimeAvrDepthIntWBarShallow=ConversionTimeVarient1TimeAvrDepthIntWBar;
ConversionTimeVarientTimeAvrDepthIntWBarShallow=ConversionTimeVarientTimeAvrDepthIntWBar;
ConversionTemporalTimeAvrDepthIntShallow=ConversionTemporalTimeAvrDepthInt;

load('D:\Results\DeepShallowAPE.mat','X','ConversionConventionalTimeAvrDepthIntWBar','ConversionTimeVarient1TimeAvrDepthIntWBar','ConversionTimeVarientTimeAvrDepthIntWBar','ConversionTemporalTimeAvrDepthInt');
XDeep=X;
ConversionConventionalTimeAvrDepthIntWBarDeep=ConversionConventionalTimeAvrDepthIntWBar;
ConversionTimeVarient1TimeAvrDepthIntWBarDeep=ConversionTimeVarient1TimeAvrDepthIntWBar;
ConversionTimeVarientTimeAvrDepthIntWBarDeep=ConversionTimeVarientTimeAvrDepthIntWBar;
ConversionTemporalTimeAvrDepthIntDeep=ConversionTemporalTimeAvrDepthInt;

FIG=figure('position',[100 100 1600 800]);
MargineTop=0.07;
MargineBot=0.10;
MargineLeft=0.06;
MargineRight=0.53;
SubplotSpac=0.02;
SubplotNumber=2;
MovmeanPtNumber=5;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
plot(movmean(XShallow/1000,MovmeanPtNumber),1e3*movmean(ConversionConventionalTimeAvrDepthIntWBarShallow,MovmeanPtNumber),'-','color',[216/255 82/255 24/255],'LineWidth',2);
plot(movmean(XShallow/1000,MovmeanPtNumber),1e3*movmean(ConversionTimeVarientTimeAvrDepthIntWBarShallow,MovmeanPtNumber),'-','color',[0 113/255 188/255],'LineWidth',2);
plot(0,0,':','color',[0 113/255 188/255],'LineWidth',2);
plot(0,0,'--','color',[0 113/255 188/255],'LineWidth',2);
lgd=legend('Conventional','Time Varying','$\rho''gw$','Temporal','Orientation','horizontal',[600 580 20 .1]);
lgd.FontSize=16;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'XTickLabel','');
axis([0 145 -1 5.9]);
MyYLabel=ylabel('$C$ $[10^{-3}$ $W.m^{-2}]$','fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.07, 0.5, 0]);
text(5,5.2,'a','fontsize',24);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
plot(movmean(XShallow,MovmeanPtNumber)/1000,1e3*movmean(ConversionTimeVarient1TimeAvrDepthIntWBarShallow,MovmeanPtNumber),':','color',[0 113/255 188/255],'LineWidth',2);
plot(movmean(XShallow,MovmeanPtNumber)/1000,1e3*movmean(ConversionTemporalTimeAvrDepthIntShallow,MovmeanPtNumber),'--','color',[0 113/255 188/255],'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
xlabel('Offshore Distance [km]','fontsize',18);
axis([0 145 -1 5.9]);
text(5,5.2,'b','fontsize',24);
MyYLabel=ylabel('$[10^{-3}$ $W.m^{-2}]$','fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.07, 0.5, 0]);

MargineTop=0.07;
MargineBot=0.10;
MargineLeft=0.53;
MargineRight=0.10;
SubplotSpac=0.02;
SubplotNumber=2;
MovmeanPtNumber=5;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
plot(movmean(XDeep/1000,MovmeanPtNumber),1e3*movmean(ConversionConventionalTimeAvrDepthIntWBarDeep,MovmeanPtNumber),'-','color',[216/255 82/255 24/255],'LineWidth',2);
plot(movmean(XDeep/1000,MovmeanPtNumber),1e3*movmean(ConversionTimeVarientTimeAvrDepthIntWBarDeep,MovmeanPtNumber),'-','color',[0 113/255 188/255],'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'XTickLabel','');
text(10,14.5,'c','fontsize',24);
axis([0 375 -3 16]);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
plot(movmean(XDeep/1000,MovmeanPtNumber),1e3*movmean(ConversionTimeVarient1TimeAvrDepthIntWBarDeep,MovmeanPtNumber),':','color',[0 113/255 188/255],'LineWidth',2);
plot(movmean(XDeep/1000,MovmeanPtNumber),1e3*movmean(ConversionTemporalTimeAvrDepthIntDeep,MovmeanPtNumber),'--','color',[0 113/255 188/255],'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
xlabel('Offshore Distance [km]','fontsize',18);
text(10,14,'d','fontsize',24);
axis([0 375 -5 16]);
savefig(FIG,'6-ConversionTimeAvrDepthInt-Shallow-Deep');
saveas(FIG,'6-ConversionTimeAvrDepthInt-Shallow-Deep','epsc');
%%
%Fig 7: TimeAvr UBar and WBar

clear all;
load('D:\Results\ShallowAPE.mat','X','ZC','UBar','WBar','Time');

MapColorNumber=40;
%Using MapColorBrightnessThreshold to distinct the colors from white
MapColorBrightnessThreshold=0.5;
%MapColors=logspace(0,MapColorBrightnessThreshold,MapColorNumber);
MapColors=cumsum(5*0.95.^(1:MapColorNumber));
MapColors=MapColors-min(MapColors);
MapColors=MapColors/(max(MapColors))/1.2;
%Adding white color to the map
CustomMap=zeros(2*size(MapColors,2)+1,3);
CustomMap(1:size(MapColors,2),1)=MapColors;
CustomMap(1:size(MapColors,2),2)=MapColors;
CustomMap(1:size(MapColors,2),3)=1;
CustomMap(size(MapColors,2)+1,1)=1;
CustomMap(size(MapColors,2)+1,2)=1;
CustomMap(size(MapColors,2)+1,3)=1;
CustomMap(size(MapColors,2)+2:end,3)=fliplr(MapColors);
CustomMap(size(MapColors,2)+2:end,2)=fliplr(MapColors);
CustomMap(size(MapColors,2)+2:end,1)=1;

FIG=figure('position',[100 100 1600 800]);
omega=1.4026e-4;
MargineTop=0.13;
MargineBot=0.10;
MargineLeft=0.06;
MargineRight=0.53;
SubplotSpac=0.10;
SubplotNumber=2;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(X/1000,ZC,1e4*1/(Time(end)-Time(1))*trapz(Time,UBar,3)');shading flat;
caxis([-1 1]);
MyColorbar=colorbar('Location','northoutside');
MyColorbarPos=MyColorbar.Position;
MyColorbar.delete;
MyColorbar=colorbar('Location','south','Position',[MyColorbarPos(1)+0.1 MyColorbarPos(2)+0.09 MyColorbarPos(3)-0.1 MyColorbarPos(4)]);
colormap(CustomMap);
MyColorbar.TickLabelInterpreter='latex';
ylim([-305,0]);
set(gca,'YTick',[-300:100:0]);
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
text(5,-20,'a','fontsize',24);
ylabel('$Z$ $[m]$','fontsize',18);
set(gca,'Color','Black');
text(0,40,'$\bar{u}$ $[10^{-4}$ $m.s^{-1}]$','Interpreter','latex','Fontsize',18);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(X/1000,ZC,1e5*1/(Time(end)-Time(1))*movmean(trapz(Time,WBar,3)',10,2));shading flat;
caxis([-1 1]);
MyColorbar=colorbar('Location','northoutside');
MyColorbarPos=MyColorbar.Position;
MyColorbar.delete;
MyColorbar=colorbar('Location','south','Position',[MyColorbarPos(1)+0.1 MyColorbarPos(2)+0.09 MyColorbarPos(3)-0.1 MyColorbarPos(4)]);
colormap(CustomMap);
MyColorbar.TickLabelInterpreter='latex';
ylim([-305,0]);
set(gca,'YTick',[-300:100:0]);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
text(5,-20,'b','fontsize',24);
ylabel('$Z$ $[m]$','fontsize',18);
set(gca,'Color','Black');
text(0,40,'$\bar{w}$ $[10^{-5}$ $m.s^{-1}]$','Interpreter','latex','Fontsize',18);
xlabel('Offshore Distance (km)','fontsize',18);
set(gca,'Color','Black');

load('D:\Results\DeepDeepAPE.mat','X','ZC','UBar','WBar','Time');

MargineTop=0.13;
MargineBot=0.10;
MargineLeft=0.53;
MargineRight=0.06;
SubplotSpac=0.10;
SubplotNumber=2;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(X/1000,ZC,1e5*1/(Time(end)-Time(1))*trapz(Time,UBar,3)');shading flat;
caxis([-4 4]);
MyColorbar=colorbar('Location','northoutside');
MyColorbarPos=MyColorbar.Position;
MyColorbar.delete;
MyColorbar=colorbar('Location','south','Position',[MyColorbarPos(1)+0.1 MyColorbarPos(2)+0.09 MyColorbarPos(3)-0.1 MyColorbarPos(4)]);
colormap(CustomMap);
MyColorbar.TickLabelInterpreter='latex';
ylim([-3050,0]);
set(gca,'YTick',[-3000:1000:0]);
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
text(10,-200,'c','fontsize',24);
ylabel('$Z$ $[m]$','fontsize',18);
set(gca,'Color','Black');
text(0,400,'$\bar{u}$ $[10^{-5}$ $m.s^{-1}]$','Interpreter','latex','Fontsize',18);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(X/1000,ZC,1e6*1/(Time(end)-Time(1))*movmean(trapz(Time,WBar,3)',10,2));shading flat;
caxis([-4 4]);
MyColorbar=colorbar('Location','northoutside');
MyColorbarPos=MyColorbar.Position;
MyColorbar.delete;
MyColorbar=colorbar('Location','south','Position',[MyColorbarPos(1)+0.1 MyColorbarPos(2)+0.09 MyColorbarPos(3)-0.1 MyColorbarPos(4)]);
colormap(CustomMap);
MyColorbar.TickLabelInterpreter='latex';
ylim([-3050,0]);
set(gca,'YTick',[-3000:1000:0]);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
text(10,-200,'d','fontsize',24);
ylabel('$Z$ $[m]$','fontsize',18);
set(gca,'Color','Black');
text(0,400,'$\bar{w}$ $[10^{-6}$ $m.s^{-1}]$','Interpreter','latex','Fontsize',18);
xlabel('Offshore Distance (km)','fontsize',18);
set(gca,'Color','Black');

savefig(FIG,'7-UBarWBar-Shallow-Deep');
saveas(FIG,'7-UBarWBar-Shallow-Deep','epsc');