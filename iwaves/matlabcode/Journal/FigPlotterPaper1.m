close all;
set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');  
cd D:\Paper1Results\;

%%
%Fig 1: Schematic propagation and reflection of IW
clear all;
close all;
FIG=figure('position',[100 100 800 800]);
clf
axis([1500 10000 -1 1.7]);
set(gca,'Position',[0.1 0.1 0.80 0.80])
x=1500:10000;

%XLims=get(gca,'XLim');
%YLims=get(gca,'YLim');
%GCAPos=get(gca, 'Position');
%X1Pixel=0.2;
%Y1Pixel=0.5;
%X2Pixel=0.4;
%Y2Pixel=0.9;
%X1Pixel=(X1-XLims(1))/(XLims(2)-XLims(1))*GCAPos(3)+GCAPos(1);
%Y1Pixel=(Y1-YLims(1))/(YLims(2)-YLims(1))*GCAPos(4)+GCAPos(2);
%X1Axis=(X1Pixel-GCAPos(1))/GCAPos(3)*(XLims(2)-XLims(1))+XLims(1);
%Y1Axis=(Y1Pixel-GCAPos(2))/GCAPos(4)*(YLims(2)-YLims(1))+YLims(1);
%X2Axis=(X2Pixel-GCAPos(1))/GCAPos(3)*(XLims(2)-XLims(1))+XLims(1);
%Y2Axis=(Y2Pixel-GCAPos(2))/GCAPos(4)*(YLims(2)-YLims(1))+YLims(1);

bath=tanh((x-7000)/700);
plot(x,bath,'Color','black','LineWidth',2);
line([0 10000],[1.5 1.5],'Color','black','LineWidth',2);
hold on;
axis([3000 10000 -1 1.7]);

annotation('line',[0.24875 0.795],[0.1025 0.83875],'color',0.5*[1,1,1],'LineWidth',2);
annotation('line',[0.64375 0.49],[0.635 0.83875],'color',0.5*[1,1,1],'LineWidth',2);
annotation('line',[0.24625 0.142687],[0.103125 0.2825],'color',0.5*[1,1,1],'LineWidth',2,'LineStyle','--');
annotation('line',[0.87 0.79625],[0.715 0.84125],'color',0.5*[1,1,1],'LineWidth',2,'LineStyle','--');
annotation('line',[0.37125 0.48875],[0.6875 0.84],'color',0.5*[1,1,1],'LineWidth',2,'LineStyle','--');

annotation('line',[0.57125 0.57125],[0.53775 0.45125],'color','blue','LineWidth',3);
annotation('line',[0.57125 0.5075],[0.5375 0.44875],'color','blue','LineWidth',3);
annotation('line',[0.58625 0.58625],[0.80275 0.71625],'color','blue','LineWidth',3);
annotation('line',[0.58375 0.52375],[0.7175 0.79625],'color','blue','LineWidth',3);

annotation('line',[0.70875 0.63375],[0.6175 0.6175],'color','blue','LineWidth',3);
annotation('line',[0.67375 0.63125],[0.7025 0.61625],'color','blue','LineWidth',3);

annotation('textbox',[0.5225 0.79875 0.036875 0.038749],'String',{'$\theta_{IW}$'},'Linewidth',3,'Interpreter','latex','Fontsize',22,'EdgeColor','none','color','blue');
annotation('textbox',[0.509375 0.4275 0.036875 0.038749],'String',{'$\theta_{IW}$'},'Linewidth',3,'Interpreter','latex','Fontsize',22,'EdgeColor','none','color','blue');
annotation('textbox',[0.66625 0.63125 0.036875 0.038749],'String',{'$\theta_{B}$'},'Linewidth',3,'Interpreter','latex','Fontsize',22,'EdgeColor','none','color','blue');
annotation('textbox',[0.742875 0.73125 0.100875 0.055],'String',{'$Ray 1$'},'Linewidth',3,'Interpreter','latex','Fontsize',22,'EdgeColor','none');
annotation('textbox',[0.442875 0.7125 0.100875 0.055],'String',{'$Ray 2$'},'Linewidth',3,'Interpreter','latex','Fontsize',22,'EdgeColor','none');
annotation('textbox',[0.232875 0.23875 0.100875 0.055],'String',{'$Ray 3$'},'Linewidth',3,'Interpreter','latex','Fontsize',22,'EdgeColor','none');
%text('Parent',gca,'FontSize',22,'Rotation',53.5,'String','$Particle$ $motion$','Position',[5258.59811827958 -0.868510832055215 0],'Interpreter','latex');
%text('Parent',gca,'FontSize',22,'Rotation',53.5,'String','$Constant$ $phase$ $curves$','Position',[4659.10215053764 -0.575774060582823 0],'Interpreter','latex','Color',0.5*[1,1,1]);


set(gca,'FontWeight','bold');
set(gca,'XTick','');
set(gca,'YTick','');
hold off;

hAxes = gca;
hAxes.XRuler.Axle.LineStyle = 'none';  
axis off

savefig(FIG,'Schematic-IW-Reflection');
saveas(FIG,'Schematic-IW-Reflection','epsc');
%%
%Fig 2:RhoB Rho' and converstion at specific X and Z VS time for FLAT case
clear all;
clc;

load('D:\Paper1Results\FlatBathymetryAPE','RhoBConventional','RhoBTimeVarient',...
    'RhoPrimeConventional','RhoPrimeTimeVarient','X','ZC','Time',...
    'ConversionConventionalW','ConversionTimeVarientW','Eta','WBar');
XPOS=250;
ZPOS=56;

MargineTop=0.05;
MargineBot=0.07;
MargineLeft=0.17;
MargineRight=0.05;
SubplotSpac=0.03;
SubplotNumber=6;

FIG=figure('position',[400 50 800 950]);
omega=1.4026e-4;

SubplotCounter=6;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,squeeze(Eta(XPOS,:)),'-k','LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -0.55 0.55]);
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel','');
text(0.1,0.4,'$a$','fontsize',24);
MyYLabel=ylabel({'$\eta$';'$[m]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.10, 0.5, 0]);

SubplotCounter=5;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,squeeze(RhoBTimeVarient(XPOS,ZPOS,:)-20),'LineWidth',2);
hold on;
plot((Time-Time(1))*omega/2/pi,squeeze(RhoBConventional(XPOS,ZPOS,:)-20),'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 5.823 5.832]);
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel','');
text(0.1,5.83,'$b$','fontsize',24);
MyYLabel=ylabel({'$\rho_b$';'$[kg.m^{-3}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.10, 0.5, 0]);

SubplotCounter=4;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,1000*squeeze(RhoPrimeTimeVarient(XPOS,ZPOS,:)),'LineWidth',2);
hold on;
plot((Time-Time(1))*omega/2/pi,1000*squeeze(RhoPrimeConventional(XPOS,ZPOS,:)),'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -4.9 4.9]);
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel','');
yticks([-4 4]);
text(0.1,3.5,'$c$','fontsize',24);
MyYLabel=ylabel({'$\rho''$';'$[10^{-3}$ $kg.m^{-3}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.10, 0.5, 0]);

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(WBar(XPOS,ZPOS,:)),'LineWidth',2,'Color','black');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -0.8 0.8]);
text(0.1,0.45,'$d$','fontsize',24,'BackgroundColor', 'white');
MyYLabel=ylabel({'$W$';'$[10^{-4}$ $m.s^{-1}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.10, 0.5, 0]);
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel','');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
C_BT=(RhoBTimeVarient-RhoBConventional)*9.8.*WBar;
plot((Time-Time(1))*omega/2/pi,1e6*squeeze(C_BT(XPOS,ZPOS,:)),'LineWidth',2,'Color','black');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -1.1 1.1]);
text(0.1,0.75,'$e$','fontsize',24);
MyYLabel=ylabel({'$gW\Delta \rho_b$';'$[10^{-6}$ $W.m^{-3}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.10, 0.5, 0]);
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel','');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,1e6*squeeze(ConversionTimeVarientW(XPOS,ZPOS,:)),'LineWidth',2);
hold on;
plot((Time-Time(1))*omega/2/pi,1e6*squeeze(ConversionConventionalW(XPOS,ZPOS,:)),'LineWidth',2);
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel',{'0',' ',' ',' ','0.5',' ',' ',' ','1',' ',' ',' ','1.5',' ',' ',' ','2',' ',' ',' ','2.5',' ',' ',' ','3'});
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -1.1 1.1]);
xlabel('t/T $[cycle^{-1}]$','fontsize',18);
text(0.1,0.70,'$f$','fontsize',24);
MyYLabel=ylabel({'$C$';'$[10^{-6}$ $W.m^{-3}]$'},'fontsize',18);
set(MyYLabel,'Units', 'Normalized', 'Position', [-0.10, 0.5, 0]);
lgd=legend('TVBD','CBD','Orientation','horizontal');
lgd.Position=[0.427 0.955 0.25 0.028];
lgd.FontSize=16;

savefig(FIG,'Flat');
saveas(FIG,'Flat','epsc');
%%
%Fig 3: W velocity for shallow and deep model to show the rays, reflection
%and whole domain
clear all;

TimePos=120;
load('D:\Paper1Results\ShallowAPE.mat','W','X','ZC');
WShallow=W;
XShallow=X;
ZCShallow=ZC;

load('D:\Paper1Results\DeepShallowAPE.mat','W','X','ZC');
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
text(130,20,'$w$ $[10^{-3} m/s]$','Interpreter','latex','Fontsize',18);
set(gca,'fontsize',16);
ylabel('Z [m]','fontsize',18);
set(gca, 'Color', 'Black');
text(5,-25,'$a$','fontsize',24);
ylim([-305,0]);
set(gca,'YTick',[-300:100:0]);
AxesLineX=xlim;
AxesLineY=ylim;
hold on;
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(1),AxesLineY(1)],'Color','black');
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(2),AxesLineY(2)],'Color','black');
line([AxesLineX(1),AxesLineX(1)],[AxesLineY(1),AxesLineY(2)],'Color','black');
line([AxesLineX(2),AxesLineX(2)],[AxesLineY(1),AxesLineY(2)],'Color','black');
FIG.Color='white';

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(XDeep/1000,ZCDeep,1e3*squeeze(WDeep(:,:,TimePos))');shading flat;colorbar;caxis([-1 1]);
colormap(CustomMap);
set(gca,'fontsize',16);
xlabel('Offshore distance (km)','fontsize',18);
text(350,200,'$w$ $[10^{-3} m/s]$','Interpreter','latex','Fontsize',18);
ylabel('Z [m]','fontsize',18);
set(gca, 'Color', 'Black');
text(10,-250,'$b$','fontsize',24);
ylim([-3050,0]);
set(gca,'YTick',[-3000:1000:0]);
AxesLineX=xlim;
AxesLineY=ylim;
hold on;
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(1),AxesLineY(1)],'Color','black');
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(2),AxesLineY(2)],'Color','black');
line([AxesLineX(1),AxesLineX(1)],[AxesLineY(1),AxesLineY(2)],'Color','black');
line([AxesLineX(2),AxesLineX(2)],[AxesLineY(1),AxesLineY(2)],'Color','black');
FIG.Color='white';

fig = gcf;
fig.InvertHardcopy = 'off';
savefig(FIG,'W-Shallow-DeepModel');
saveas(FIG,'W-Shallow-DeepModel','png');
%%
%Fig 4: Density stratification and N^2 for both models.
clear all;

load('D:\Paper1Results\ShallowAPE.mat','ZC','RhoBConventional');
ZCShallow=ZC;
RhoBConventionalShallow=RhoBConventional;

load('D:\Paper1Results\DeepShallowAPE.mat','ZC','RhoBConventional');
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
text(0.002,-20,'$a$','fontsize',24);


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
text(0.001,-200,'$b$','fontsize',24);
line(min(x2),min(y2),'Parent',ax2,'Color','black','LineStyle','-','LineWidth',2);
lgd=legend('Brunt-Vaisala','Background Density',[380 570 20 .1]);
lgd.FontSize=16;
savefig(FIG,'DensityStratification');
saveas(FIG,'DensityStratification','epsc');
%%
%Fig 5: RhoB, Rho', conversion, Temporal terms for shallow case at specific
%X and Z (generation)
clear all;

load('D:\Paper1Results\ShallowAPE.mat','Time','X','ZC','RhoBConventional','RhoPrimeConventional','RhoBTimeVarient','RhoPrimeTimeVarient','ConversionConventionalWBar','ConversionTimeVarientWBar','ConversionTimeVarient1WBar','ConversionTemporal','WBar');

XPOS=952;
ZPOS=43;

FIG=figure('position',[100 50 1600 950]);
omega=1.4026e-4;
MargineTop=0.07;
MargineBot=0.08;
MargineLeft=0.10;
MargineRight=0.55;
SubplotSpac=0.02;
SubplotNumber=5;

SubplotCounter=5;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,squeeze(RhoBTimeVarient(XPOS,ZPOS,:)-20),'LineWidth',2);
hold on;
plot((Time-Time(1))*omega/2/pi,squeeze(RhoBConventional(XPOS,ZPOS,:)-20),'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 2.31 2.33]);
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel','');
text(0.1,2.328,'$a$','fontsize',24);
MyYLabel=ylabel({'$\rho_b$';'$[kg.m^{-3}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.15, 0.5, 0]);

SubplotCounter=4;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,100*squeeze(RhoPrimeTimeVarient(XPOS,ZPOS,:)),'LineWidth',2);
hold on;
plot((Time-Time(1))*omega/2/pi,100*squeeze(RhoPrimeConventional(XPOS,ZPOS,:)),'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -3.9 +3.9]);
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel','');
text(0.1,2.8,'$b$','fontsize',24);
MyYLabel=ylabel({'$\rho''$';'$[10^{-2}$ $kg.m^{-3}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.15, 0.5, 0]);

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,1e3*squeeze(WBar(XPOS,ZPOS,:)),'LineWidth',2,'Color','black');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -1.3 1.3]);
text(0.1,0.8,'$c$','fontsize',24,'BackgroundColor', 'white');
MyYLabel=ylabel({'$W$';'$[10^{-3}$ $m.s^{-1}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.15, 0.5, 0]);
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel','');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
C_BT=(RhoBTimeVarient-RhoBConventional)*9.8.*WBar;
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(C_BT(XPOS,ZPOS,:)),'LineWidth',2,'Color','black');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -0.5 0.5]);
text(0.1,0.35,'$d$','fontsize',24);
MyYLabel=ylabel({'$gW\Delta \rho_b$';'$[10^{-4}$ $W.m^{-3}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.15, 0.5, 0]);
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel','');

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
text(0.1,3,'$e$','fontsize',24);
MyYLabel=ylabel({'$C$';'$[10^{-4}$ $W.m^{-3}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.15, 0.5, 0]);
xlabel('t/T','fontsize',18);
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel',{'0',' ',' ',' ','0.5',' ',' ',' ','1',' ',' ',' ','1.5',' ',' ',' ','2',' ',' ',' ','2.5',' ',' ',' ','3'});

load('D:\Paper1Results\DeepShallowAPE.mat','Time','X','ZC','RhoBConventional','RhoPrimeConventional','RhoBTimeVarient','RhoPrimeTimeVarient','ConversionConventionalWBar','ConversionTimeVarientWBar','ConversionTimeVarient1WBar','ConversionTemporal','WBar');

XPOS=784;
ZPOS=172;

MargineTop=0.07;
MargineBot=0.08;
MargineLeft=0.55;
MargineRight=0.10;
SubplotSpac=0.02;
SubplotNumber=5;

SubplotCounter=5;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,squeeze(RhoBTimeVarient(XPOS,ZPOS,:)-20),'LineWidth',2);
hold on;
plot((Time-Time(1))*omega/2/pi,squeeze(RhoBConventional(XPOS,ZPOS,:)-20),'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 4.1325 4.137]);
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel','');
text(0.1,4.1365,'$f$','fontsize',24);

SubplotCounter=4;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,1e2*squeeze(RhoPrimeTimeVarient(XPOS,ZPOS,:)),'LineWidth',2);
hold on;
plot((Time-Time(1))*omega/2/pi,1e2*squeeze(RhoPrimeConventional(XPOS,ZPOS,:)),'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -0.8 0.8]);
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel','');
text(0.1,0.6,'$g$','fontsize',24);

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,1e3*squeeze(WBar(XPOS,ZPOS,:)),'LineWidth',2,'Color','black');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -2 2]);
text(0.1,1.30,'$h$','fontsize',24,'BackgroundColor', 'white');
set(gca,'XTickLabel','');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
C_BT=(RhoBTimeVarient-RhoBConventional)*9.8.*WBar;
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(C_BT(XPOS,ZPOS,:)),'LineWidth',2,'Color','black');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -0.22 0.22]);
text(0.1,0.15,'$i$','fontsize',24);
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel','');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(ConversionTimeVarientWBar(XPOS,ZPOS,:)),'LineWidth',2);
hold on;
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(ConversionConventionalWBar(XPOS,ZPOS,:)),'LineWidth',2);
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(ConversionTimeVarient1WBar(XPOS,ZPOS,:)),':','color',[0 113/255 188/255],'LineWidth',2);
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(ConversionTemporal(XPOS,ZPOS,:)),'--','color',[0 113/255 188/255],'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -0.3 1.3]);
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel',{'0',' ',' ',' ','0.5',' ',' ',' ','1',' ',' ',' ','1.5',' ',' ',' ','2',' ',' ',' ','2.5',' ',' ',' ','3'});
text(0.1,0.90,'$j$','fontsize',24);
xlabel('t/T','fontsize',18);
lgd=legend('TVBD','CBD','$\rho''gw$','$IWxBTH$','Orientation','horizontal');
lgd.Position=[0.36 0.94 0.24 0.031];
lgd.FontSize=16;
savefig(FIG,'Conversion-generation-Shallow-Deep');
saveas(FIG,'Conversion-generation-Shallow-Deep','epsc');
%%
%Fig 6: Pcolor of conversion
clear all;

load('D:\Paper1Results\ShallowAPE.mat','X','ZC','ConversionConventionalTimeAvrWBar','ConversionTimeVarientTimeAvrWBar');

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
sorush=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(movmean(X/1000,5),ZC,movmean(1e5*ConversionConventionalTimeAvrWBar',5,2));shading flat;caxis([-12 12]);
colormap(CustomMap);
MyColorbar=colorbar('Location','south','Position',[MargineLeft+0.12, MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber-SubplotSpac+0.05, 1-MargineLeft-MargineRight-0.12, SubplotSpac-0.06]);
MyColorbar.TickLabelInterpreter='latex';
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
text(5,-20,'$a$','fontsize',24);
ylabel('$Z$ $[m]$','fontsize',18);
set(gca,'Color','Black');
text(0,-330,'$\langle C \rangle$ [$10^{-5}$ $W.m^{-3}$]','Interpreter','latex','Fontsize',18);
ylim([-305,0]);
set(gca,'YTick',[-300:100:0]);
AxesLineX=xlim;
AxesLineY=ylim;
hold on;
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(1),AxesLineY(1)],'Color','black');
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(2),AxesLineY(2)],'Color','black');
line([AxesLineX(1),AxesLineX(1)],[AxesLineY(1),AxesLineY(2)],'Color','black');
line([AxesLineX(2),AxesLineX(2)],[AxesLineY(1),AxesLineY(2)],'Color','black');
FIG.Color='white';

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(movmean(X/1000,5),ZC,movmean(1e5*ConversionTimeVarientTimeAvrWBar',5,2));shading flat;caxis([-12 12]);
colormap(CustomMap);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
text(5,-20,'$b$','fontsize',24);
ylabel('$Z$ $[m]$','fontsize',18);
xlabel('Offshore Distance (km)','fontsize',18);
set(gca,'Color','Black');
ylim([-305,0]);
set(gca,'YTick',[-300:100:0]);
AxesLineX=xlim;
AxesLineY=ylim;
hold on;
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(1),AxesLineY(1)],'Color','black');
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(2),AxesLineY(2)],'Color','black');
line([AxesLineX(1),AxesLineX(1)],[AxesLineY(1),AxesLineY(2)],'Color','black');
line([AxesLineX(2),AxesLineX(2)],[AxesLineY(1),AxesLineY(2)],'Color','black');
FIG.Color='white';

load('D:\Paper1Results\DeepShallowAPE.mat','X','ZC','ConversionConventionalTimeAvrWBar','ConversionTimeVarientTimeAvrWBar');

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
text(0,-3300,'$\langle C \rangle$ [$10^{-5}$ $W.m^{-3}$]','Interpreter','latex','Fontsize',18);
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
text(15,-200,'$c$','fontsize',24);
set(gca,'Color','Black');
ylim([-3050,0]);
set(gca,'YTick',[-3000:1000:0]);
AxesLineX=xlim;
AxesLineY=ylim;
hold on;
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(1),AxesLineY(1)],'Color','black');
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(2),AxesLineY(2)],'Color','black');
line([AxesLineX(1),AxesLineX(1)],[AxesLineY(1),AxesLineY(2)],'Color','black');
line([AxesLineX(2),AxesLineX(2)],[AxesLineY(1),AxesLineY(2)],'Color','black');
FIG.Color='white';

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(movmean(X/1000,5),ZC,movmean(1e5*ConversionTimeVarientTimeAvrWBar',5,2));shading flat;caxis([-5 5]);
colormap(CustomMap);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
text(15,-200,'$d$','fontsize',24);
xlabel('Offshore Distance (km)','fontsize',18);
set(gca,'Color','Black');
ylim([-3050,0]);
set(gca,'YTick',[-3000:1000:0]);
AxesLineX=xlim;
AxesLineY=ylim;
hold on;
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(1),AxesLineY(1)],'Color','black');
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(2),AxesLineY(2)],'Color','black');
line([AxesLineX(1),AxesLineX(1)],[AxesLineY(1),AxesLineY(2)],'Color','black');
line([AxesLineX(2),AxesLineX(2)],[AxesLineY(1),AxesLineY(2)],'Color','black');
FIG.Color='white';

fig = gcf;
fig.InvertHardcopy = 'off';
savefig(FIG,'ConversionTimeAvr-Shallow-Deep');
saveas(FIG,'ConversionTimeAvr-Shallow-Deep','epsc');
%%
%Fig 7: Depth-integrated time-averaged Conversion for shallow and deep
%model
clear all;

load('D:\Paper1Results\ShallowAPE.mat','X','ConversionConventionalTimeAvrDepthIntWBar','ConversionTimeVarient1TimeAvrDepthIntWBar','ConversionTimeVarientTimeAvrDepthIntWBar','ConversionTemporalTimeAvrDepthInt');
XShallow=X;
ConversionConventionalTimeAvrDepthIntWBarShallow=ConversionConventionalTimeAvrDepthIntWBar;
ConversionTimeVarient1TimeAvrDepthIntWBarShallow=ConversionTimeVarient1TimeAvrDepthIntWBar;
ConversionTimeVarientTimeAvrDepthIntWBarShallow=ConversionTimeVarientTimeAvrDepthIntWBar;
ConversionTemporalTimeAvrDepthIntShallow=ConversionTemporalTimeAvrDepthInt;

load('D:\Paper1Results\DeepShallowAPE.mat','X','ConversionConventionalTimeAvrDepthIntWBar','ConversionTimeVarient1TimeAvrDepthIntWBar','ConversionTimeVarientTimeAvrDepthIntWBar','ConversionTemporalTimeAvrDepthInt');
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
lgd=legend('CBD','TVBD','$\rho''gw$','$IWxBTH$','Orientation','horizontal');
lgd.Position=[0.36 0.94 0.284 0.031];
lgd.FontSize=16;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'XTickLabel','');
axis([0 145 -1 5.9]);
MyYLabel=ylabel('$\langle \overline{C} \rangle$ $[10^{-3}$ $W.m^{-2}]$','fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.07, 0.5, 0]);
text(5,5.2,'$a$','fontsize',24);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
plot(movmean(XShallow,MovmeanPtNumber)/1000,1e3*movmean(ConversionTimeVarient1TimeAvrDepthIntWBarShallow,MovmeanPtNumber),':','color',[0 113/255 188/255],'LineWidth',2);
plot(movmean(XShallow,MovmeanPtNumber)/1000,1e3*movmean(ConversionTemporalTimeAvrDepthIntShallow,MovmeanPtNumber),'--','color',[0 113/255 188/255],'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
xlabel('Offshore Distance [km]','fontsize',18);
axis([0 145 -1 5.9]);
text(5,5.2,'$b$','fontsize',24);
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
text(10,14.5,'$c$','fontsize',24);
axis([0 375 -3 16]);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
plot(movmean(XDeep/1000,MovmeanPtNumber),1e3*movmean(ConversionTimeVarient1TimeAvrDepthIntWBarDeep,MovmeanPtNumber),':','color',[0 113/255 188/255],'LineWidth',2);
plot(movmean(XDeep/1000,MovmeanPtNumber),1e3*movmean(ConversionTemporalTimeAvrDepthIntDeep,MovmeanPtNumber),'--','color',[0 113/255 188/255],'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
xlabel('Offshore Distance [km]','fontsize',18);
text(10,14,'$d$','fontsize',24);
axis([0 375 -5 16]);
savefig(FIG,'ConversionTimeAvrDepthInt-Shallow-Deep');
saveas(FIG,'ConversionTimeAvrDepthInt-Shallow-Deep','epsc');
%%
%Fig 8: TimeAvr UBar and WBar

clear all;
load('D:\Paper1Results\ShallowAPE.mat','X','ZC','UBar','WBar','Time');

MapColorNumber=20;
%Using MapColorBrightnessThreshold to distinct the colors from white
MapColorBrightnessThreshold=0.5;
%MapColors=logspace(0,MapColorBrightnessThreshold,MapColorNumber);
MapColors=cumsum(5*0.95.^(1:MapColorNumber));
MapColors=MapColors-min(MapColors);
MapColors=MapColors/(max(MapColors))/1.2;
%Adding white color to the map
CustomMapT=zeros(2*size(MapColors,2)+1,3);
CustomMapT(1:size(MapColors,2),1)=MapColors;
CustomMapT(1:size(MapColors,2),2)=MapColors;
CustomMapT(1:size(MapColors,2),3)=1;
CustomMapT(size(MapColors,2)+1,1)=1;
CustomMapT(size(MapColors,2)+1,2)=1;
CustomMapT(size(MapColors,2)+1,3)=1;
CustomMapT(size(MapColors,2)+2:end,3)=fliplr(MapColors);
CustomMapT(size(MapColors,2)+2:end,2)=fliplr(MapColors);
CustomMapT(size(MapColors,2)+2:end,1)=1;

FIG=figure('position',[100 100 1600 800]);
omega=1.4026e-4;
MargineTop=0.13;
MargineBot=0.10;
MargineLeft=0.06;
MargineRight=0.53;
SubplotSpac=0.10;
SubplotNumber=2;

SubplotCounter=2;
SubplotLT=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(X/1000,ZC,1e4*1/(Time(end)-Time(1))*trapz(Time,UBar,3)');shading flat;
caxis([-1 1]);
MyColorbar=colorbar('Location','northoutside');
MyColorbarPos=MyColorbar.Position;
MyColorbar.delete;
MyColorbar=colorbar('Location','south','Position',[MyColorbarPos(1)+0.12 MyColorbarPos(2)+0.09 MyColorbarPos(3)-0.12 MyColorbarPos(4)]);
colormap(SubplotLT,CustomMapT);
MyColorbar.TickLabelInterpreter='latex';
ylim([-305,0]);
set(gca,'YTick',[-300:100:0]);
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
text(5,-20,'$a$','fontsize',24);
ylabel('$Z$ $[m]$','fontsize',18);
set(gca,'Color','Black');
text(0,40,'$\langle U \rangle$ $[10^{-4}$ $m.s^{-1}]$','Interpreter','latex','Fontsize',18);
AxesLineX=xlim;
AxesLineY=ylim;
hold on;
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(1),AxesLineY(1)],'Color','black');
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(2),AxesLineY(2)],'Color','black');
line([AxesLineX(1),AxesLineX(1)],[AxesLineY(1),AxesLineY(2)],'Color','black');
line([AxesLineX(2),AxesLineX(2)],[AxesLineY(1),AxesLineY(2)],'Color','black');
FIG.Color='white';

MapColorNumber=5;
%Using MapColorBrightnessThreshold to distinct the colors from white
MapColorBrightnessThreshold=0.5;
%MapColors=logspace(0,MapColorBrightnessThreshold,MapColorNumber);
MapColors=cumsum(5*0.95.^(1:MapColorNumber));
MapColors=MapColors-min(MapColors);
MapColors=MapColors/(max(MapColors))/1.2;
%Adding white color to the map
CustomMapB=zeros(2*size(MapColors,2)+1,3);
CustomMapB(1:size(MapColors,2),1)=MapColors;
CustomMapB(1:size(MapColors,2),2)=MapColors;
CustomMapB(1:size(MapColors,2),3)=1;
CustomMapB(size(MapColors,2)+1,1)=1;
CustomMapB(size(MapColors,2)+1,2)=1;
CustomMapB(size(MapColors,2)+1,3)=1;
CustomMapB(size(MapColors,2)+2:end,3)=fliplr(MapColors);
CustomMapB(size(MapColors,2)+2:end,2)=fliplr(MapColors);
CustomMapB(size(MapColors,2)+2:end,1)=1;

SubplotCounter=1;
SubplotLB=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(X/1000,ZC,1e6*1/(Time(end)-Time(1))*movmean(trapz(Time,WBar,3)',10,2));shading flat;
caxis([-3 3]);
MyColorbar=colorbar('Location','northoutside');
MyColorbarPos=MyColorbar.Position;
MyColorbar.delete;
MyColorbar=colorbar('Location','south','Position',[MyColorbarPos(1)+0.12 MyColorbarPos(2)+0.09 MyColorbarPos(3)-0.12 MyColorbarPos(4)]);
colormap(SubplotLB,CustomMapB);
MyColorbar.TickLabelInterpreter='latex';
ylim([-305,0]);
set(gca,'YTick',[-300:100:0]);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
text(5,-20,'$b$','fontsize',24);
ylabel('$Z$ $[m]$','fontsize',18);
set(gca,'Color','Black');
text(0,40,'$\langle W \rangle$ $[10^{-6}$ $m.s^{-1}]$','Interpreter','latex','Fontsize',18);
xlabel('Offshore Distance (km)','fontsize',18);
set(gca,'Color','Black');
AxesLineX=xlim;
AxesLineY=ylim;
hold on;
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(1),AxesLineY(1)],'Color','black');
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(2),AxesLineY(2)],'Color','black');
line([AxesLineX(1),AxesLineX(1)],[AxesLineY(1),AxesLineY(2)],'Color','black');
line([AxesLineX(2),AxesLineX(2)],[AxesLineY(1),AxesLineY(2)],'Color','black');
FIG.Color='white';

load('D:\Paper1Results\DeepShallowAPE.mat','X','ZC','UBar','WBar','Time');

MargineTop=0.13;
MargineBot=0.10;
MargineLeft=0.53;
MargineRight=0.06;
SubplotSpac=0.10;
SubplotNumber=2;

SubplotCounter=2;
SubplotRT=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(X/1000,ZC,1e5*1/(Time(end)-Time(1))*trapz(Time,UBar,3)');shading flat;
caxis([-5 5]);
MyColorbar=colorbar('Location','northoutside');
MyColorbarPos=MyColorbar.Position;
MyColorbar.delete;
MyColorbar=colorbar('Location','south','Position',[MyColorbarPos(1)+0.12 MyColorbarPos(2)+0.09 MyColorbarPos(3)-0.12 MyColorbarPos(4)]);
colormap(SubplotRT,CustomMapT);
MyColorbar.TickLabelInterpreter='latex';
ylim([-3050,0]);
set(gca,'YTick',[-3000:1000:0]);
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
text(10,-200,'$c$','fontsize',24);
ylabel('$Z$ $[m]$','fontsize',18);
set(gca,'Color','Black');
text(0,400,'$\langle U \rangle$ $[10^{-5}$ $m.s^{-1}]$','Interpreter','latex','Fontsize',18);
AxesLineX=xlim;
AxesLineY=ylim;
hold on;
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(1),AxesLineY(1)],'Color','black');
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(2),AxesLineY(2)],'Color','black');
line([AxesLineX(1),AxesLineX(1)],[AxesLineY(1),AxesLineY(2)],'Color','black');
line([AxesLineX(2),AxesLineX(2)],[AxesLineY(1),AxesLineY(2)],'Color','black');
FIG.Color='white';

SubplotCounter=1;
SubplotRB=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(X/1000,ZC,1e6*1/(Time(end)-Time(1))*movmean(trapz(Time,WBar,3)',10,2));shading flat;
caxis([-3 3]);
MyColorbar=colorbar('Location','northoutside');
MyColorbarPos=MyColorbar.Position;
MyColorbar.delete;
MyColorbar=colorbar('Location','south','Position',[MyColorbarPos(1)+0.12 MyColorbarPos(2)+0.09 MyColorbarPos(3)-0.12 MyColorbarPos(4)]);
colormap(SubplotRB,CustomMapB);
MyColorbar.TickLabelInterpreter='latex';
ylim([-3050,0]);
set(gca,'YTick',[-3000:1000:0]);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
text(10,-200,'$d$','fontsize',24);
ylabel('$Z$ $[m]$','fontsize',18);
set(gca,'Color','Black');
text(0,400,'$\langle W \rangle$ $[10^{-6}$ $m.s^{-1}]$','Interpreter','latex','Fontsize',18);
xlabel('Offshore Distance (km)','fontsize',18);
set(gca,'Color','Black');
AxesLineX=xlim;
AxesLineY=ylim;
hold on;
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(1),AxesLineY(1)],'Color','black');
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(2),AxesLineY(2)],'Color','black');
line([AxesLineX(1),AxesLineX(1)],[AxesLineY(1),AxesLineY(2)],'Color','black');
line([AxesLineX(2),AxesLineX(2)],[AxesLineY(1),AxesLineY(2)],'Color','black');
FIG.Color='white';

fig = gcf;
fig.InvertHardcopy = 'off';
savefig(FIG,'UBarWBar-Shallow-Deep');
saveas(FIG,'UBarWBar-Shallow-Deep','epsc');
%%
%Fig 9: RhoB, Rho', conversion, Temporal terms for shallow case at specific
%X and Z (reflection)
clear all;

load('D:\Paper1Results\ShallowAPE.mat','Time','X','ZC','RhoBConventional','RhoPrimeConventional','RhoBTimeVarient','RhoPrimeTimeVarient','ConversionConventionalWBar','ConversionTimeVarientWBar','ConversionTimeVarient1WBar','ConversionTemporal','W','WBar','IsopycnalDislocation');
XPOS=607;
ZPOS=22;
WPrime=W-WBar;
DiffDeltaDiffT=diff(squeeze(IsopycnalDislocation(XPOS,ZPOS,:)))./diff(Time);
DiffDeltaDiffT(end+1)=DiffDeltaDiffT(end);

FIG=figure('position',[100 50 1600 950]);
omega=1.4026e-4;
MargineTop=0.07;
MargineBot=0.08;
MargineLeft=0.10;
MargineRight=0.55;
SubplotSpac=0.02;
SubplotNumber=4;

SubplotCounter=4;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,squeeze(RhoBTimeVarient(XPOS,ZPOS,:)-20),'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 1.785 1.830]);
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel','');
text(0.1,1.824,'$a$','fontsize',24);
MyYLabel=ylabel({'$\rho_b$';'$[kg.m^{-3}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.15, 0.5, 0]);

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,100*squeeze(RhoPrimeTimeVarient(XPOS,ZPOS,:)),'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -3.9 +3.9]);
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel','');
text(0.1,2.8,'$b$','fontsize',24);
MyYLabel=ylabel({'$\rho''$';'$[10^{-2}$ $kg.m^{-3}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.15, 0.5, 0]);

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(WBar(XPOS,ZPOS,:)),'LineWidth',2,'color','black','LineStyle','-');
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(WPrime(XPOS,ZPOS,:)),'LineWidth',2,'color','black','LineStyle','--');
plot((Time-Time(1))*omega/2/pi,1e4*DiffDeltaDiffT,'LineWidth',2,'color','black','LineStyle',':');
axis([0 3 -1.5 1.5]);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
MyYLabel=ylabel({'$Vertical$ $velocity$';'$[10^{-4}$ $m.s^{-1}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.15, 0.5, 0]);
text(0.1,1.1,'$c$','fontsize',24,'BackgroundColor', 'white');
FIG.Color='white';
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel','');
box on;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(ConversionTimeVarientWBar(XPOS,ZPOS,:)),'LineWidth',2);
hold on;
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(ConversionConventionalWBar(XPOS,ZPOS,:)),'LineWidth',2);
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(ConversionTimeVarient1WBar(XPOS,ZPOS,:)),':','color',[0 113/255 188/255],'LineWidth',2);
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(ConversionTemporal(XPOS,ZPOS,:)),'--','color',[0 113/255 188/255],'LineWidth',2);
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel',{'0',' ',' ',' ','0.5',' ',' ',' ','1',' ',' ',' ','1.5',' ',' ',' ','2',' ',' ',' ','2.5',' ',' ',' ','3'});
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -0.25 0.25]);
text(0.1,0.18,'$d$','fontsize',24);
MyYLabel=ylabel({'$C$';'$[10^{-4}$ $W.m^{-3}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.15, 0.5, 0]);
xlabel('t/T','fontsize',18);


load('D:\Paper1Results\DeepShallowAPE.mat','Time','X','ZC','RhoBConventional','RhoPrimeConventional','RhoBTimeVarient','RhoPrimeTimeVarient','ConversionConventionalWBar','ConversionTimeVarientWBar','ConversionTimeVarient1WBar','ConversionTemporal','W','WBar','IsopycnalDislocation');

XPOS=426;
ZPOS=52;
WPrime=W-WBar;
DiffDeltaDiffT=diff(squeeze(IsopycnalDislocation(XPOS,ZPOS,:)))./diff(Time);
DiffDeltaDiffT(end+1)=DiffDeltaDiffT(end);

MargineTop=0.07;
MargineBot=0.08;
MargineLeft=0.55;
MargineRight=0.10;
SubplotSpac=0.02;
SubplotNumber=4;

SubplotCounter=4;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,squeeze(RhoBTimeVarient(XPOS,ZPOS,:)-20),'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 2.983 3.007]);
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel','');
text(0.1,3.0035,'$e$','fontsize',24);

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot((Time-Time(1))*omega/2/pi,1e2*squeeze(RhoPrimeTimeVarient(XPOS,ZPOS,:)),'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 3 -1.5 1.6]);
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel','');
text(0.1,1.3,'$f$','fontsize',24);

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(WBar(XPOS,ZPOS,:)),'LineWidth',2,'color','black','LineStyle','-');
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(WPrime(XPOS,ZPOS,:)),'LineWidth',2,'color','black','LineStyle','--');
plot((Time-Time(1))*omega/2/pi,1e4*DiffDeltaDiffT,'LineWidth',2,'color','black','LineStyle',':');
axis([0 3 -3 3]);
set(gca,'fontsize',16);
axis([0 3 -3 3]);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
text(0.1,2.2,'$g$','fontsize',24,'BackgroundColor', 'white');
FIG.Color='white';
set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel','');
box on;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(ConversionTimeVarientWBar(XPOS,ZPOS,:)),'LineWidth',2);
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(ConversionConventionalWBar(XPOS,ZPOS,:)),'LineWidth',2);
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(ConversionTimeVarient1WBar(XPOS,ZPOS,:)),':','color',[0 113/255 188/255],'LineWidth',2);
plot((Time-Time(1))*omega/2/pi,1e4*squeeze(ConversionTemporal(XPOS,ZPOS,:)),'--','color',[0 113/255 188/255],'LineWidth',2);

plot(0,0,'LineWidth',2,'color','black','LineStyle','-');
plot(0,0,'LineWidth',2,'color','black','LineStyle','--');
plot(0,0,'LineWidth',2,'color','black','LineStyle',':');

set(gca,'XTick',[0:0.125:3]);
set(gca,'XTickLabel',{'0',' ',' ',' ','0.5',' ',' ',' ','1',' ',' ',' ','1.5',' ',' ',' ','2',' ',' ',' ','2.5',' ',' ',' ','3'});
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
box on;
axis([0 3 -0.28 0.28]);
text(0.1,0.21,'$h$','fontsize',24);
xlabel('t/T','fontsize',18);
lgd=legend('TVBD','CBD','$\rho''gw$','$IWxBTH$','$W$','$w''$','$\frac{\partial \delta}{\partial t}$');
lgd.Orientation='horizontal';
lgd.Position=[0.45 0.94 0.1 0.05];
lgd.Interpreter='latex';
lgd.FontSize=20;
savefig(FIG,'Conversion-Reflection-Shallow-Deep');
saveas(FIG,'Conversion-Reflection-Shallow-Deep','epsc');
% %%
% %Fig 10: Phase of Rho' and W'
% clear all;
% close all;
% %Phase 1, 2, 3, 4 are WPrime, RhoB, RhoPrime,WBar
% load('D:\Results\Deep-Shallow-Phases.mat');
% Phase1(Phase1<-360)=Phase1(Phase1<-360)+360;
% Phase1(Phase1>360)=Phase1(Phase1>360)-360;
% Phase3(Phase3>360)=Phase3(Phase3>360)-360;
% Phase3(Phase3<-360)=Phase3(Phase3<-360)+360;
% 
% Phase1(Phase1<60)=0;
% Phase1(Phase1>140)=0;
% 
% Phase3(Phase3>20)=0;
% Phase3(Phase3<20)=0;
% 
% 
% MapColorNumber=20;
% MapColors=cumsum(5*0.95.^(1:MapColorNumber));
% MapColors=MapColors-min(MapColors);
% MapColors=MapColors/(max(MapColors))/1.2;
% %Adding white color to the map
% CustomMap=zeros(2*size(MapColors,2)+1,3);
% CustomMap(1:size(MapColors,2),1)=MapColors;
% CustomMap(1:size(MapColors,2),2)=MapColors;
% CustomMap(1:size(MapColors,2),3)=1;
% CustomMap(size(MapColors,2)+1,1)=1;
% CustomMap(size(MapColors,2)+1,2)=1;
% CustomMap(size(MapColors,2)+1,3)=1;
% CustomMap(size(MapColors,2)+2:end,3)=fliplr(MapColors);
% CustomMap(size(MapColors,2)+2:end,2)=fliplr(MapColors);
% CustomMap(size(MapColors,2)+2:end,1)=1;
% 
% FIG=figure('position',[400 100 800 800]);
% MargineTop=0.05;
% MargineBot=0.10;
% MargineLeft=0.15;
% MargineRight=0.05;
% SubplotSpac=0.10;
% SubplotNumber=2;
% 
% 
% SubplotCounter=2;
% subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
% set(gca, 'Color', 'Black');
% pcolor(X,ZC(20:end),Phase3');shading flat;colorbar;caxis([-180 180]);
% colormap(CustomMap);
% % MyColorbar= colorbar;
% % MyColorbar.TickLabelInterpreter='latex';
% % text(130,20,'$\overline{w}$ $[10^{-3} m/s]$','Interpreter','latex','Fontsize',18);
% % set(gca,'fontsize',16);
% % ylabel('Z [m]','fontsize',18);
% 
% text(5,-25,'$a$','fontsize',24);
% ylim([-305,0]);
% set(gca,'YTick',[-300:100:0]);
% AxesLineX=xlim;
% AxesLineY=ylim;
% hold on;
% line([AxesLineX(1),AxesLineX(2)],[AxesLineY(1),AxesLineY(1)],'Color','black');
% line([AxesLineX(1),AxesLineX(2)],[AxesLineY(2),AxesLineY(2)],'Color','black');
% line([AxesLineX(1),AxesLineX(1)],[AxesLineY(1),AxesLineY(2)],'Color','black');
% line([AxesLineX(2),AxesLineX(2)],[AxesLineY(1),AxesLineY(2)],'Color','black');
% FIG.Color='white';
% % 
% % SubplotCounter=1;
% % subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
% % pcolor(XDeep/1000,ZCDeep,1e3*squeeze(WDeep(:,:,TimePos))');shading flat;colorbar;caxis([-1 1]);
% % colormap(CustomMap);
% % set(gca,'fontsize',16);
% % xlabel('Offshore distance (km)','fontsize',18);
% % text(350,200,'$\overline{w}$ $[10^{-3} m/s]$','Interpreter','latex','Fontsize',18);
% % ylabel('Z [m]','fontsize',18);
% % set(gca, 'Color', 'Black');
% % text(10,-250,'$b$','fontsize',24);
% % ylim([-3050,0]);
% % set(gca,'YTick',[-3000:1000:0]);
% % AxesLineX=xlim;
% % AxesLineY=ylim;
% % hold on;
% % line([AxesLineX(1),AxesLineX(2)],[AxesLineY(1),AxesLineY(1)],'Color','black');
% % line([AxesLineX(1),AxesLineX(2)],[AxesLineY(2),AxesLineY(2)],'Color','black');
% % line([AxesLineX(1),AxesLineX(1)],[AxesLineY(1),AxesLineY(2)],'Color','black');
% % line([AxesLineX(2),AxesLineX(2)],[AxesLineY(1),AxesLineY(2)],'Color','black');
% % FIG.Color='white';
% % 
% % fig = gcf;
% % fig.InvertHardcopy = 'off';
% % savefig(FIG,'3-W-Shallow-DeepModel');
% % saveas(FIG,'3-W-Shallow-DeepModel','epsc');

%%
%Fig 10: Bathymetry of IdleRidge case
clear all;

X=ncread('D:\Paper1Results\IdleRidgeInfo.nc','X');
Y=ncread('D:\Paper1Results\IdleRidgeInfo.nc','Y');
ZC=ncread('D:\Paper1Results\IdleRidgeInfo.nc','Z');
Z3D=ncread('D:\Paper1Results\IdleRidgeInfo.nc','Density',[1,1,1,1],[Inf,Inf,Inf,1]);

Z3D=Z3D*0+permute(repmat(ZC,1,size(X,1),size(Y,1)),[2,3,1]);
Z3D=nanmin(Z3D,[],3);
[xx,yy]=meshgrid(X,Y);


XPOS=floor(size(X,1)/2);
YPOS=floor(size(Y,1)/2)

FIG=figure('position',[100 50 1600 950]);
MargineTop=0.07;
MargineBot=0.08;
MargineLeft=0.10;
MargineRight=0.55;
SubplotSpac=0.02;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
surf(xx/1000,yy/1000,Z3D');
shading flat;
MyColorbar=colorbar('Location','east','Position',[MargineRight-0.065, MargineBot, 0.015, 1-MargineBot-MargineTop]);
caxis([-3000 -300]);
MyColorbar.Ticks=[-3000:250:-500,-300];
MyColorbar.TickLabelInterpreter='latex';
view(-30,15);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'XTick',[0:100:600]);
set(gca,'YTick',[0:20:100]);
text(50,100,-250,'$a$','fontsize',24);
MyYLabel=zlabel('Depth [m]','fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.2, 0.5, 0]);
xlabel('X [km]','fontsize',18);
set(get(gca,'xlabel'),'rotation',15);
ylabel('Y [km]','fontsize',18);
set(get(gca,'ylabel'),'rotation',-40);

MargineTop=0.07;
MargineBot=0.08;
MargineLeft=0.55;
MargineRight=0.10;
SubplotSpac=0.10;
SubplotNumber=2;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot(Y/1000,movmean(Z3D(XPOS,:),5),'LineWidth',2,'color','black');
axis([0 100 -3000 0]);
set(gca,'YAxisLocation','right');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
text(5,-250,'$b$','fontsize',24);
MyYLabel=ylabel('Depth [m]','fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [+1.15, 0.5, 0]);
xlabel('Y [km]','fontsize',18);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot(X/1000,Z3D(:,YPOS),'LineWidth',2,'color','black');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([0 600 -3000 0]);
set(gca,'XTick',[0:100:600]);
set(gca,'YAxisLocation','right');
text(30,-250,'$c$','fontsize',24);
MyYLabel=ylabel('Depth [m]','fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [+1.15, 0.5, 0]);
xlabel('X [km]','fontsize',18);

savefig(FIG,'IdleRige-Bathymetry');
saveas(FIG,'IdleRige-Bathymetry','epsc');


clf
Longitude=ncread('D:\Paper1Results\southern_calif_crm_v1.nc','x');
Latitude=ncread('D:\Paper1Results\southern_calif_crm_v1.nc','y');
Bathymetry=ncread('D:\Paper1Results\southern_calif_crm_v1.nc','z');

Bathymetry=Bathymetry(Longitude>-122.9 & Longitude<-122.5,Latitude>35.5 & Latitude<35.9);
Longitude=Longitude(Longitude>-122.9 & Longitude<-122.5);
Latitude=Latitude(Latitude>35.5 & Latitude<35.9);

DataTimeZone = utmzone(mean(Latitude,'omitnan'),mean(Longitude,'omitnan'))
utmstruct = defaultm('utm'); 
utmstruct.zone = DataTimeZone;  
utmstruct.geoid = wgs84Ellipsoid;
utmstruct = defaultm(utmstruct);
[X,Y] = mfwdtran(utmstruct,Latitude,Longitude);

surf(X,Y,movmean(movmean(Bathymetry,5,1),5,2)')
%%
%Fig 11: Conversion of IdleRidge
close all;

YPOS=59;
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


FIG=figure('position',[100 50 1600 950]);
MargineTop=0.04;
MargineBot=0.08;
MargineLeft=0.10;
MargineRight=0.47;
SubplotSpac=0.06;
SubplotNumber=3;

SubplotCounter=3;
BottomTemp=MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber;
subplot('Position',[MargineLeft,BottomTemp,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(X/1000,ZC,1e5*movmean(squeeze(ConversionConventionalTimeAvrWBar(:,YPOS,:)),3,1)');
set(gca,'fontsize',16);
shading flat;
colormap(CustomMap);
MyColorbar=colorbar('Location','south','Position',[MargineLeft+0.13,BottomTemp-0.03,1-MargineLeft-0.02-0.13,0.02]);
caxis([-6 6]);
MyColorbar.Ticks=-6:2:6;
MyColorbar.TickLabelInterpreter='latex';
text(10,-3300,'$\langle C \rangle$ $[10^{-5} W. m^{-3}]$','Interpreter','latex','Fontsize',18);
set(gca,'XTick',[0:100:600]);
set(gca,'XTickLabel','');
set(gca,'YTick',[-3000:500:0]);
text(30,-250,'$a$','fontsize',24);
MyYLabel=ylabel('Depth [m]','fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.13, 0.5, 0]);
set(gca,'Color','Black');
AxesLineX=xlim;
AxesLineY=ylim;
hold on;
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(1),AxesLineY(1)],'Color','black');
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(2),AxesLineY(2)],'Color','black');
line([AxesLineX(1),AxesLineX(1)],[AxesLineY(1),AxesLineY(2)],'Color','black');
line([AxesLineX(2),AxesLineX(2)],[AxesLineY(1),AxesLineY(2)],'Color','black');
FIG.Color='white';
set(gca,'layer','top');
grid on;
grid off;
set(gca,'FontWeight','bold');


SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot(X/1000,ConversionTimeVarientTimeAvrDepthIntWBar(:,YPOS),'color',[0 113/255 188/255],'LineWidth',2);
set(gca,'fontsize',16);
hold on;
plot(X/1000,ConversionConventionalTimeAvrDepthIntWBar(:,YPOS),'color',[216/255 82/255 24/255],'LineWidth',2);
axis([0 600 -.012 0.045]);
set(gca,'XTick',[0:100:600]);
set(gca,'XTickLabel','');
set(gca,'YTick',[-0.01:0.01:0.04]);
text(30,0.04,'$c$','fontsize',24);
MyYLabel=ylabel('C [$W.m^{-2}$]','fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.13, 0.5, 0]);
legend('TVBD','CBD','fontsize',18);
set(gca,'FontWeight','bold');

SubplotCounter=1;
BottomTemp=MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber;
subplot('Position',[MargineLeft,BottomTemp,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(X/1000,Y/1000,1e2*movmean(movmean(ConversionConventionalTimeAvrDepthIntWBar,2,1),2,2)');
set(gca,'fontsize',16);
shading flat;
xlim([0 600]);
MyColorbar=colorbar('Location','north','AxisLocation','in','Position',[MargineLeft+0.13,BottomTemp+0.285,1-MargineLeft-0.02-0.13,0.02]);
caxis([-6 +6]);
MyColorbar.Ticks=-6:2:6;
MyColorbar.TickLabelInterpreter='latex';
text(10,56,'$\langle \bar{C} \rangle$ [$10^{-2}$ $W.m^{-3}$]','Interpreter','latex','Fontsize',18);

set(gca,'XTick',[0:100:600]);
text(30,95,'$e$','fontsize',24);
MyYLabel=ylabel('Y [km]','fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.13, 0.5, 0]);
xlabel('X [km]','fontsize',18);
set(gca,'layer','top');
grid on;
grid off;
set(gca,'FontWeight','bold');

MargineLeft=0.55;
MargineRight=0.02;

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(X/1000,ZC,1e5*movmean(squeeze(ConversionTimeVarientTimeAvrWBar(:,YPOS,:)),3,1)');
set(gca,'fontsize',16);
shading flat;
colormap(CustomMap);
caxis([-6 +6]);
set(gca,'XTick',[0:100:600]);
set(gca,'XTickLabel','');
set(gca,'YTick',[-3000:500:0]);
set(gca,'YTickLabel','');
text(30,-250,'$b$','fontsize',24);
set(gca,'Color','Black');
AxesLineX=xlim;
AxesLineY=ylim;
hold on;
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(1),AxesLineY(1)],'Color','black');
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(2),AxesLineY(2)],'Color','black');
line([AxesLineX(1),AxesLineX(1)],[AxesLineY(1),AxesLineY(2)],'Color','black');
line([AxesLineX(2),AxesLineX(2)],[AxesLineY(1),AxesLineY(2)],'Color','black');
FIG.Color='white';
set(gca,'layer','top');
grid on;
grid off;
set(gca,'FontWeight','bold');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot(X/1000,ConversionTimeVarient1TimeAvrDepthIntWBar(:,YPOS),':','color',[0 113/255 188/255],'LineWidth',2);
hold on;
plot(X/1000,ConversionTemporalTimeAvrDepthInt(:,YPOS),'--','color',[0 113/255 188/255],'LineWidth',2);
axis([0 600 -0.012 0.045]);
set(gca,'fontsize',16);
set(gca,'XTick',[0:100:600]);
set(gca,'XTickLabel','');
set(gca,'YTick',[-0.01:0.01:0.04]);
set(gca,'YTickLabel','');
text(30,0.04,'$d$','fontsize',24);
legend('$\rho'' g W$','IW$x$BTH','fontsize',18);
box on;
set(gca,'FontWeight','bold');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
pcolor(X/1000,Y/1000,1e2*movmean(movmean(ConversionTimeVarientTimeAvrDepthIntWBar,2,1),2,2)');
caxis([-6 +6]);
xlim([0 600]);
shading flat;
set(gca,'fontsize',16);
set(gca,'XTick',[0:100:600]);
set(gca,'YTickLabel','');
text(30,95,'$f$','fontsize',24);
xlabel('X [km]','fontsize',18);
set(gca,'layer','top');
grid on;
grid off;
set(gca,'FontWeight','bold');
fig = gcf;
fig.InvertHardcopy = 'off';
savefig(FIG,'IdleRige-Conversion');
saveas(FIG,'IdleRige-Conversion','epsc');