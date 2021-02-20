close all;
clear all;
clc

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');  
cd 'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2';
%%
%Figure 1- Sea surface, rho', WBar and conversion at an arbitrary point
clc
close all;
clear all;
DataM2=load('G:\Paper2and3\Result-110082.mat','Eta','RhoPrimeConventional','WBar','ConversionConventionalWBar','Time','X','ZC');
DataK1=load('G:\Paper2and3\Result-110089.mat','Eta','RhoPrimeConventional','WBar','ConversionConventionalWBar','Time','X','ZC');
FIG=figure('position',[100 50 800 800]);

MyColor=[ 0.85 0.325 0.098;...%red
    0.929 0.6941 0.1255;...%yellow
    0 0.447 0.741];%blue

XIndex=474;
ZIndex=37;
TimeRange=3300;
TimeIndex=540;

MargineTop=0.05;
MargineBot=0.12;
MargineLeft=0.15;
MargineRight=0.03;
SubplotSpac=0.02;
SubplotNumber=4;

SubplotCounter=4;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
axis([373.9 433.8 -60 60]);
hold on;
box on;
plot(DataM2.Time(TimeRange:end)/3600,100*squeeze(DataM2.Eta(XIndex,TimeRange:end)),'LineWidth',2,'LineStyle','-','color',MyColor(1,:));
plot(DataK1.Time(TimeRange:end)/3600,100*squeeze(DataK1.Eta(XIndex,TimeRange:end)),'LineWidth',2,'LineStyle','-','color',MyColor(2,:));
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'XTickLabel','');
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-40:40:40;
MyAxe.YAxis.MinorTickValues=-60:10:60;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=380:10:430;
MyAxe.XAxis.MinorTickValues=375:2.5:432.5;

MyAxe.YAxis.TickLength=[0.01 0.03];
MyAxe.XAxis.TickLength=[0.01 0.03];
line([373.9,433.8],[0 0],'LineStyle',':','color','black');
MyYLabel=ylabel({'$\eta$ $[cm]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[368 LabelPos(2)];
text(375,-45,'$a$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
axis([373.9 433.8 -0.2 0.2]);
hold on;
box on;
plot(DataM2.Time(TimeRange:end)/3600,squeeze(DataM2.RhoPrimeConventional(XIndex,ZIndex,TimeRange:end)),'LineWidth',2,'LineStyle','-','color',MyColor(1,:));
plot(DataK1.Time(TimeRange:end)/3600,squeeze(DataK1.RhoPrimeConventional(XIndex,ZIndex,TimeRange:end)),'LineWidth',2,'LineStyle','-','color',MyColor(2,:));
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'XTickLabel','');
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.1:0.1:0.1;
MyAxe.YAxis.MinorTickValues=-0.2:0.05:0.2;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=380:10:430;
MyAxe.XAxis.MinorTickValues=375:2.5:432.5;

MyAxe.YAxis.TickLength=[0.01 0.03];
MyAxe.XAxis.TickLength=[0.01 0.03];
line([373.9,433.8],[0 0],'LineStyle',':','color','black');

MyYLabel=ylabel({'$\rho''$ $[kg.m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[368 LabelPos(2)];
text(375,-0.15,'$b$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
axis([373.9 433.8 -1.5 1.5]);
hold on;
box on;
plot(DataM2.Time(TimeRange:end)/3600,1000*squeeze(DataM2.WBar(XIndex,ZIndex,TimeRange:end)),'LineWidth',2,'LineStyle','-','color',MyColor(1,:));
plot(DataK1.Time(TimeRange:end)/3600,1000*squeeze(DataK1.WBar(XIndex,ZIndex,TimeRange:end)),'LineWidth',2,'LineStyle','-','color',MyColor(2,:));
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'XTickLabel','');
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-1:1:1
MyAxe.YAxis.MinorTickValues=-1.5:0.25:1.5;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=380:10:430;
MyAxe.XAxis.MinorTickValues=375:2.5:432.5;

MyAxe.YAxis.TickLength=[0.01 0.03];
MyAxe.XAxis.TickLength=[0.01 0.03];
line([373.9,433.8],[0 0],'LineStyle',':','color','black');

MyYLabel=ylabel({'$W$ $[mm.s^{-1}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[368 LabelPos(2)];
text(375,1,'$c$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
axis([373.9 433.8 -0.8 1.5]);
hold on;
box on;
plot(DataM2.Time(TimeRange:end)/3600,1000*squeeze(DataM2.ConversionConventionalWBar(XIndex,ZIndex,TimeRange:end)),'LineWidth',2,'LineStyle','-','color',MyColor(1,:));
plot(DataK1.Time(TimeRange:end)/3600,1000*squeeze(DataK1.ConversionConventionalWBar(XIndex,ZIndex,TimeRange:end)),'LineWidth',2,'LineStyle','-','color',MyColor(2,:));
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-1:1:1;
MyAxe.YAxis.MinorTickValues=-2:0.25:2;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=380:10:430;
MyAxe.XAxis.MinorTickValues=375:2.5:432.5;

MyAxe.YAxis.TickLength=[0.01 0.03];
MyAxe.XAxis.TickLength=[0.01 0.03];
line([373.9,433.8],[0 0],'LineStyle',':','color','black');

MyYLabel=ylabel({'C $[W. m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[368 LabelPos(2)];
text(375,1,'$d$','fontsize',24,'Color','black','BackgroundColor','none');

MyYLabel=xlabel('$Time$ $[hr]$','fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1) LabelPos(2)-0.35];
lgd=legend('$M_2$','$K_1$','Orientation','horizontal','Location','northoutside');
lgd.FontSize=18;
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1) LGDPositio(2)+0.685 LGDPositio(3) LGDPositio(4)];

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\ConversionSample');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\ConversionSample','epsc');
%%
%Figure 2- Bathymetry and Map
clear all;
close all;

FIG=figure('position',[100 50 800 800]);
MargineTop=0.05;
MargineBot=0.40;
MargineLeft=0.12;
MargineRight=0.55;
SubplotSpac=0.0;
SubplotNumber=1;

MyColor=[ 0.85 0.325 0.098;...%red
    0.929 0.6941 0.1255;...%yellow
    0 0.447 0.741];%blue

SubplotCounter=1;
subplot1=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
set(gca, 'Color', 0.5*[1 1 1]);
hold on;

lat=ncread('D:\Paper2Results\monterey_13_navd88_2012.nc','lat');
lon=ncread('D:\Paper2Results\monterey_13_navd88_2012.nc','lon');
Bathymetry=ncread('D:\Paper2Results\monterey_13_navd88_2012.nc','Band1');
lat=lat(8500:10:16000);
lon=lon(3000:10:7500);
Bathymetry=Bathymetry(3000:10:7500,8500:10:16000);
%Bathymetry from NOAA website https://data.noaa.gov/metaview/page?xml=NOAA/NESDIS/NGDC/MGG/DEM/iso/xml/3544.xml&view=getDataView&header=none#
%Monterey, California 1/3 arc-second NAVD 88 Coastal Digital Elevation Model
Bathymetry(Bathymetry>=1)=nan;
pcolor(lon,lat,Bathymetry'/1000);
set(gca,'FontWeight','bold');
shading flat;
MyColorbar=colorbar('Location','eastoutside');
MyColorbar.FontSize=16;
MyColorbar.FontWeight='bold';
MyColorbar.TickLabelInterpreter='latex';
POS=MyColorbar.Position;
MyColorbar.Position=[0.46 0.415 0.02375 0.51875];
caxis([-1.6 0]);
set(MyColorbar,'XTick',[-1.500:.500:0]);

text(-121.92,37.08,'Elevation $[km]$','Fontsize',18);
colormap(subplot1,jet);
axis equal;

set(gca, 'YAxisLocation', 'left');
set(gca, 'TickDir', 'out');
set(gca,'FontWeight','bold');
set(gca,'fontsize',16);
ylabel('Latitude [$^\circ N$]','fontsize',18);
xlabel('Longtitude [$^\circ W$]','fontsize',18);
axis([-122.13,-121.78,36.5,37.05]);
MyAxe=gca;
MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-122.10:0.025:-121.7;
MyAxe.XAxis.TickValues=-122.1:0.2:-121.7;

MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.MinorTickValues=36.5:0.05:37;
MyAxe.YAxis.TickValues=36.6:0.3:37;

set(gca,'TickLength',[0.02,0.03]);
hold on;
box on;

line([-121.95,-121.95],[36.6,36.7],'Color','black','LineWidth',2,'LineStyle','--');
line([-121.8,-121.8],[36.6,36.7],'Color','black','LineWidth',2,'LineStyle','--');
line([-121.8,-121.95],[36.7,36.7],'Color','black','LineWidth',2,'LineStyle','--');
line([-121.8,-121.95],[36.6,36.6],'Color','black','LineWidth',2,'LineStyle','--');

contour(lon,lat,Bathymetry',[-25 -50 -75 -100 -250 -500 -750 -1000],'Color',[0 0 0],'Linewidth',0.5);
text(-122.11,37.01,'$a$','fontsize',24);

MargineTop=0.10;
MargineBot=0.40;
MargineLeft=0.55;
MargineRight=0.12;
SubplotSpac=0.05;
SubplotNumber=2;

SubplotCounter=2;
subplot2=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
set(gca, 'Color', 0.5*[1 1 1]);

hold on;
pcolor(lon,lat,Bathymetry'*0);shading flat;
colormap(subplot2,'bone');
axis equal;
caxis([-1500 0]);
set(gca, 'YAxisLocation', 'right');
set(gca, 'XAxisLocation', 'top');
set(gca, 'TickDir', 'out');
set(gca,'FontWeight','bold');
set(gca,'fontsize',16);
ylabel('Latitude [$^\circ N$]','fontsize',18);
xlabel('Longtitude [$^\circ W$]','fontsize',18);
axis([-121.95,-121.80,36.6,36.7]);
text(-121.942,36.688,'$b$','fontsize',24);
contour(lon,lat,Bathymetry',[-5 -10 -25 -50 -75],'Color',[0 0 0],'Linewidth',0.5);

MyAxe=gca;
MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-121.94:0.01:-121.82;
MyAxe.XAxis.TickValues=-121.92:0.05:-121.82;

MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.MinorTickValues=36.6:0.01:36.7;
MyAxe.YAxis.TickValues=36.6:0.05:36.7;

set(gca,'TickLength',[0.02,0.03]);
box on;
line([-121.95 -121.95],[36.6 36.7],'color','black','Linewidth',0.5);
line([-121.95 -121.80],[36.7 36.7],'color','black','Linewidth',0.5);
AX1=gca;
AX1.LineWidth=0.8;
annotation('arrow',[0.65125 0.69],[0.724 0.88875],'Color',[0.851 0.3255 0.098],'LineWidth',3,'HeadSize',15);
annotation('line',[0.69125 0.8775],[0.8875 0.61375],'LineWidth',2,'LineStyle','--');
annotation('line',[0.65125 0.62],[0.72875 0.6075],'LineWidth',2,'LineStyle','--');

MargineTop=0.12;
MargineBot=0.40;
MargineLeft=0.62;
MargineRight=0.12;
SubplotNumber=2;

SubplotCounter=1;
subplot2=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
RightMargine=5000;
DomainLength=50000;
XFine=0:10:DomainLength;
XFine=XFine';
Bathymetry=nan(size(XFine,1),1);
for i=1:size(XFine,1)
	if(XFine(i)>DomainLength-(1+RightMargine))
		Bathymetry(i)=5;
    elseif(XFine(i)>DomainLength-(300+RightMargine))
		p1 = -1.4433e-05;
		p2 = -0.012306;
		p3 = -4.8887;
		Bathymetry(i)=-(p1*(DomainLength-XFine(i)-RightMargine)^2+p2*(DomainLength-XFine(i)-RightMargine)^1+p3);
    elseif(XFine(i)>DomainLength-(825+RightMargine))
		p1 = 8.5851e-08;
		p2 = -0.00016189;
		p3 = 0.031162;
		p4 = -7.1766;
		Bathymetry(i)=-(p1*(DomainLength-XFine(i)-RightMargine)^3+p2* (DomainLength-XFine(i)-RightMargine)^2+p3*(DomainLength-XFine(i)-RightMargine)^1+p4);
    elseif(XFine(i)>DomainLength-(1303+RightMargine))
		p1 = -1.0463e-07;
		p2 = 0.00039446;
		p3 = -0.50792;
		p4 = 166.49;
		Bathymetry(i)=-(p1*(DomainLength-XFine(i)-RightMargine)^3+p2*(DomainLength-XFine(i)-RightMargine)^2+p3*(DomainLength-XFine(i)-RightMargine)^1+p4);
    elseif(XFine(i)>DomainLength-(5400+RightMargine))
		p1 = 3.9769e-07;
		p2 = -0.0069956;
		p3 = -48.817;
		Bathymetry(i)=-(p1*(DomainLength-XFine(i)-RightMargine)^2+p2*(DomainLength-XFine(i)-RightMargine)^1+p3);
	else
		Bathymetry(i)=75;
    end
end
left_color = [0 0 0];
right_color = [0.5 0.5 0.5];
set(FIG,'defaultAxesColorOrder',[left_color; right_color]);

plot(45.2-XFine/1000,-Bathymetry,'Color',[0 0 0],'LineStyle','-','LineWidth',2);
%set(gca, 'XDir','reverse')
ylabel('z $[m]$','fontsize',18);
text(5.3,-8.4,'$c$','fontsize',24);
xlim([0 6]);
set(gca,'YTick',[-75:20:-5]);
hold on;
yyaxis right
BathymetryDiff=diff(Bathymetry)./diff(XFine);
BathymetryDiff(end+1)=BathymetryDiff(end);
BathymetryDiff([4417,4418,4370])=[];
XFine([4417,4418,4370])=[];
plot(45.2-XFine/1000,-movmean(BathymetryDiff,20),'Color',right_color,'LineStyle','-','LineWidth',2);

ylim([0 0.075]);
MyAxe=gca;
MyAxe.YAxis(2).MinorTick='on';
MyAxe.YAxis(2).MinorTickValues=0.0:0.005:0.07;
MyAxe.YAxis(2).TickValues=0.02:0.03:0.06;

MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-75:5:0;
MyAxe.YAxis(1).TickValues=-75:20:0;

MyAxe.XAxis(1).MinorTick='on';
MyAxe.XAxis(1).MinorTickValues=0:1:5;
MyAxe.XAxis(1).TickValues=0:5:5;

set(gca,'TickLength',[0.02,0.03]);

set(gca,'fontsize',16);
xlabel('Offshore distance $[km]$','fontsize',18);
ylabel('Slope $[m.m^{-1}]$','fontsize',18);
set(gca,'FontWeight','bold');

FIG.Color='white';
fig = gcf;
fig.InvertHardcopy = 'off';

MargineTop=0.70;
MargineBot=0.1;
MargineLeft=0.10;
MargineRight=0.12;
SubplotSpac=0.10;
SubplotNumber=1;
SubplotCounter=1;
subplot2=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);

[InitialPhase,TideSeparated,TideName,TideAmp,TidePhase,TideFrequency,Time,Tide]=TidalPhaseSeparator('D:\Paper2Results\TideJun2018Monterey.csv',100,36.5);
Time=Time-datenum(2018,0,0);
Tide=Tide-mean(Tide);%converting the tide to mean sea level
Predict=TideSeparated(:,1)+TideSeparated(:,3);

plot(Time, Tide,'LineWidth',2,'Linestyle','-','color','black');
hold on;
plot(Time,Predict,'LineWidth',2,'Linestyle',':','color',MyColor(3,:));

MyAxe=gca;
MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=152:182;
MyAxe.XAxis.TickValues=152:5:182;

set(gca,'TickLength',[0.02,0.03]);

axis([152 182 -1.3 1.3]);
set(gca,'FontWeight','bold');
set(gca,'fontsize',16);
ylabel({'SSH [$m$]'},'fontsize',18);
xlabel('Day of year','fontsize',18);
lgd=legend('Total','$M_2+K_1$','Location','northoutside','Orientation','horizontal');
lgd.FontSize=16;
text(152.5,0.8,'$d$','Interpreter','latex','Fontsize',24);

saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\Monterey');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\Monterey','png');
%%
%Figure 3- Bathymetry and RhoB
clear all;
close all;

load('G:\Paper2and3\Result-110080.mat','X','RhoBConventional','Density','ZC','ConversionConventionalTimeAvrDepthIntWBar','ConversionConventionalTimeAvrWBar');

FIG=figure('position',[100 100 1000 800]);
MargineTop=0.10;
MargineBot=0.10;
MargineLeft=0.09;
MargineRight=0.60;
SubplotSpac=0.02;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
set(gca,'FontWeight','bold');
x1 = squeeze(nanmean(RhoBConventional(200,:,:),3)+1000);
y1 = ZC;
x2=movmean(sqrt(abs(-9.8/1000*diff(squeeze(RhoBConventional(5,:,1)))./diff(ZC)')),5);
y2=ZC(1:end-1);
line(x1,y1,'Color','black','LineStyle','-','LineWidth',2);
ylim([-75 0]);
ax1 = gca; % current axes
ax1.XLim=([1024.5 1025.5]);
set(ax1,'XTick',[1024.6:0.1:1025.4]);
MyTickLabel=get(ax1,'XTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:4:end,:)=MyTickLabel(1:4:end,:);
set(ax1,'XTickLabel',FinalTickLabel);
ax1.XColor = [0 0 0];
ax1.YColor = 'black';
set(gca,'fontsize',16);

ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,'XAxisLocation','top','YAxisLocation','right','Color','none');
ax2.XLim=([-0.005 0.045]);
set(ax2,'XTick',[0:0.005:0.04]);
MyTickLabel=get(ax2,'XTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:2:end,:)=MyTickLabel(1:2:end,:);
set(ax2,'XTickLabel',FinalTickLabel);
ax2.XColor=[0.4 0.4 0.4];
set(gca,'YTickLabel','');
line(x2,y2,'Parent',ax2,'Color',[0.5 0.5 0.5],'LineStyle','-','LineWidth',2);
ylim([-75 0]);
set(gca,'fontsize',16);
MyYLabel=ylabel('z $[m]$','fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.25, 0.5, 0]);
text(0.013,-82,'$\rho_b$ $[kg.m^{-3}]$','Interpreter','latex','Fontsize',18);
text(0.018,7,'$N$ $[s^{-1}]$','Color',[0.5 0.5 0.5],'Interpreter','latex','Fontsize',18);
text(0.002,-4,'$a$','fontsize',24);

line(0,0,'Color','black','LineStyle','-','LineWidth',2);
set(gca,'FontWeight','bold');

MargineTop=0.10;
MargineBot=0.10;
MargineLeft=0.50;
MargineRight=0.05;
SubplotSpac=0.01;
SubplotNumber=2;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);

MapColorNumber=80;
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

pcolor(X/1000,ZC,10000*ConversionConventionalTimeAvrWBar');
shading flat;caxis([-2 2]);
MyColorbar=colorbar('Location','northoutside');
POS=MyColorbar.Position;
MyColorbar.Position=[POS(1)+0.25 POS(2)+0.07 POS(3)-0.25 POS(4)];
colormap(CustomMap);
set(gca,'fontsize',16);
MyColorbar.TickLabelInterpreter='latex';
text(0,5,'$\langle$C$\rangle$ [$10^{-4}$ $W.m^{-3}$]','Interpreter','latex','Fontsize',18);
MyYLabel=ylabel('z $[m]$','fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.11, 0.5, 0]);
set(gca, 'Color', 'Black');
text(2,-11,'$b$','fontsize',24,'Color','black');
set(gca,'layer','top')
ylim([-75,-1]);
set(gca,'YTick',[-75:20:-5]);
AxesLineX=xlim;
AxesLineY=ylim;
hold on;
set(gca,'XTick',[0:10:50]);
set(gca,'XTickLabel',{'','','','','','',''});
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(1),AxesLineY(1)],'Color','black');
line([AxesLineX(1),AxesLineX(2)],[AxesLineY(2),AxesLineY(2)],'Color','black');
line([AxesLineX(1),AxesLineX(1)],[AxesLineY(1),AxesLineY(2)],'Color','black');
line([AxesLineX(2),AxesLineX(2)],[AxesLineY(1),AxesLineY(2)],'Color','black');

FIG.Color='white';
fig = gcf;
fig.InvertHardcopy = 'off';

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot(X/1000,1000*movmean(ConversionConventionalTimeAvrDepthIntWBar,10),'LineWidth',2,'color','black');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
ylim([-0.1 1.1]);
set(gca,'YTick',[0:0.1:1]);
MyTickLabel=get(gca,'YTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:2:end,:)=MyTickLabel(1:2:end,:);
set(gca,'YTickLabel',FinalTickLabel);
MyLabel=ylabel('$\langle\ \overline{C} \rangle$ [$10^{-3}$ $W.m^{-2}$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-0.1 LabelPos(2)];
MyLabel=xlabel('Offshore distance [$km$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.05];
box on;
text(3.1,0.95,'$c$','fontsize',24,'Color','black');
set(gca,'XTick',[0:10:50]);
xlim([0 50]);
box on;

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\Model');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\Model','epsc');
%%
%Figure 4- Details of Conversion
clear all;
close all;

FIG=figure('position',[100 50 800 800]);
MargineTop=0.08;
MargineBot=0.12;
MargineLeft=0.12;
MargineRight=0.52;
SubplotSpac=0.02;
SubplotNumber=4;

SubplotCounter=4;
subplot1=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);

Address='G:\Paper2and3\Result-110045.mat';
load(Address,'ZC','X','ConversionConventionalTimeAvrWBar');
Depth=ConversionConventionalTimeAvrWBar*0+repmat(ZC,1,size(X,1))';
Depth=nanmin(Depth,[],2);

hold on;
line([44 45],[-1 -1],'Color',[0.85098 0.3255 0.09804],'LineWidth',2);
line([44 45],[-60 -60],'Color',[0.85098 0.3255 0.09804],'LineWidth',2);
line([44 44],[-1 -60],'Color',[0.85098 0.3255 0.09804],'LineWidth',2);
line([45 45],[-1 -60],'Color',[0.85098 0.3255 0.09804],'LineWidth',2);

plot(X/1000,Depth,'LineWidth',2);
xlim([39.5 46]);
ylim([-80 0]);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-80:5:0;
MyAxe.YAxis(1).TickValues=-50:25:0;
MyAxe.TickLength=[0.02 0.02];

MyAxe.XAxis(1).MinorTickValues=38:4:46;
MyAxe.XAxis(1).TickValues=38:1:46;
%set(gca,'XTickLabel','');
MyAxe.XAxisLocation='top';
box on;

MapColorNumber=10;
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
text(39.85,-10,'$a$','Fontsize',18);

FIG.Color='white';
fig = gcf;
fig.InvertHardcopy = 'off';

FigureName={'$d$','$c$','$b$'};
for counter=3:-1:1
    SubplotCounter=counter;
    subplot1=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
    set(gca, 'Color', 0.5*[1 1 1]);
    hold on;

    Address=strcat('G:\Paper2and3\Result-1100',num2str(45+(3-counter)),'.mat');
    load(Address,'ZC','X','ConversionConventionalTimeAvrWBar');

    pcolor(X/1000,ZC,1e4*movmean(ConversionConventionalTimeAvrWBar,2,1)');
    shading flat;
    caxis([-8 8]);
    colormap(CustomMap);
    
    xlim([44 45]);
    ylim([-60 0]);
    
    set(gca,'layer','top');
    MyAxe=gca;
    MyAxe.YAxis(1).MinorTick='on';
    MyAxe.YAxis(1).MinorTickValues=-80:5:0;
    MyAxe.YAxis(1).TickValues=-50:25:0;
    
    MyAxe.XAxis.MinorTick='on';
    MyAxe.XAxis.TickValues=44:0.5:45;
    MyAxe.XAxis.MinorTickValues=44:0.25:45;
       
    set(gca,'fontsize',16);
    set(gca,'FontWeight','bold');
    if counter~=1
        set(gca,'XTickLabel','');
    end
    MyAxe.TickLength=[0.03 0.03];
    box on;
    text(44.05,-7.5,FigureName{counter},'Fontsize',18);
end

MargineTop=0.08;
MargineBot=0.12;
MargineLeft=0.52;
MargineRight=0.12;
SubplotSpac=0.02;
SubplotNumber=4;

FigureName={'$h$','$g$','$f$','$e$'};
for counter=4:-1:1
    SubplotCounter=counter;
    subplot1=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
    set(gca, 'Color', 0.5*[1 1 1]);
    hold on;

    Address=strcat('G:\Paper2and3\Result-1100',num2str(48+(4-counter)),'.mat');
    load(Address,'ZC','X','ConversionConventionalTimeAvrWBar');

    pcolor(X/1000,ZC,1e4*movmean(ConversionConventionalTimeAvrWBar,2,1)');
    shading flat;
    caxis([-8 8]);
    colormap(CustomMap);
    
    xlim([44 45]);
    ylim([-60 0]);
    
    set(gca,'layer','top');
    MyAxe=gca;
    MyAxe.YAxis.MinorTick='on';
    MyAxe.YAxis.MinorTickValues=-80:5:0;
    MyAxe.YAxis.TickValues=-50:25:0;
    
    MyAxe.YAxisLocation='left';
    MyAxe.XAxis.MinorTick='on';
    MyAxe.XAxis.TickValues=44:0.5:45;
    MyAxe.XAxis.MinorTickValues=44:0.25:45;
    
    set(gca,'fontsize',16);
    set(gca,'FontWeight','bold');
    if counter~=1
        set(gca,'XTickLabel','');
    end
    MyAxe.TickLength=[0.03 0.03];
    set(gca,'YTickLabel','');
    box on;
    text(44.05,-7.5,FigureName{counter},'Fontsize',18);
end
MyColorbar=colorbar('Location','eastoutside');
MyColorbar.FontSize=18;
MyColorbar.FontWeight='bold';
MyColorbar.TickLabelInterpreter='latex';
POS=MyColorbar.Position;
MyColorbar.Position=[POS(1)+0.065 POS(2) POS(3) POS(4)+0.615];
MyColorbar.Label.String='$\langle C \rangle$ $[10^{-4}$ $W.m^{-3}]$';
MyColorbar.Label.Interpreter='latex';
%MyColorbar.Label.Rotation=0;
MyColorbarLabelPos=get(MyColorbar,'Position');
MyColorbar.Label.Position=[MyColorbarLabelPos(1)+2 MyColorbarLabelPos(2)];

MyLabel=xlabel('X [$km$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-0.55 LabelPos(2)-7];

MyLabel=ylabel('Z [$m$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-1.3 LabelPos(2)+100];

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\PycnoBlockLocationConversion');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\PycnoBlockLocationConversion','epsc');
%%
%Figure 5- The vertical profile showing the effect of pycnolicne on the conversion
%clear all;
clc
close all;
FIG=figure('position',[100 300 1000 600]);

XIndex=[476,473,473,471,467,464];
ZIndex=[15,25,47,52,57,75];

MyColor=[0.47 0.67 0.19;...
    0.49 0.18 0.56;...
    0.64 0.08 0.18;...
    0.30 0.75 0.93;...
    1.00 0.07 0.51;...
    0.50 0.50 0.50];

TimeRange=3600;
TimeIndex=3800;
Address=strcat('G:\Paper2and3\Result-',num2str(110080),'.mat');%M2 at 5m
M25=load(Address,'X','ZC','Time','Eta','WBar','RhoPrimeConventional','ConversionConventionalTimeAvrDepthIntWBar','ConversionConventionalTimeAvrWBar','ConversionConventionalWBar');
M25.Time(1:TimeRange)=[];
M25.Eta(:,1:TimeRange)=[];
M25.WBar(:,:,1:TimeRange)=[];
M25.RhoPrimeConventional(:,:,1:TimeRange)=[];
M25.ConversionConventionalWBar(:,:,1:TimeRange)=[];

Address=strcat('G:\Paper2and3\Result-',num2str(110081),'.mat');%M2 at 7.5m
M275=load(Address,'X','ZC','Time','Eta','WBar','RhoPrimeConventional','ConversionConventionalTimeAvrDepthIntWBar','ConversionConventionalTimeAvrWBar','ConversionConventionalWBar');
M275.Time(1:TimeRange)=[];
M275.Eta(:,1:TimeRange)=[];
M275.WBar(:,:,1:TimeRange)=[];
M275.RhoPrimeConventional(:,:,1:TimeRange)=[];
M275.ConversionConventionalWBar(:,:,1:TimeRange)=[];

Address=strcat('G:\Paper2and3\Result-',num2str(110082),'.mat');%M2 at 10m
M210=load(Address,'X','ZC','Time','Eta','WBar','RhoPrimeConventional','ConversionConventionalTimeAvrDepthIntWBar','ConversionConventionalTimeAvrWBar','ConversionConventionalWBar');
M210.Time(1:TimeRange)=[];
M210.Eta(:,1:TimeRange)=[];
M210.WBar(:,:,1:TimeRange)=[];
M210.RhoPrimeConventional(:,:,1:TimeRange)=[];
M210.ConversionConventionalWBar(:,:,1:TimeRange)=[];

Address=strcat('G:\Paper2and3\Result-',num2str(110083),'.mat');%M2 at 12.5m
M2125=load(Address,'X','ZC','Time','Eta','WBar','RhoPrimeConventional','ConversionConventionalTimeAvrDepthIntWBar','ConversionConventionalTimeAvrWBar','ConversionConventionalWBar');
M2125.Time(1:TimeRange)=[];
M2125.Eta(:,1:TimeRange)=[];
M2125.WBar(:,:,1:TimeRange)=[];
M2125.RhoPrimeConventional(:,:,1:TimeRange)=[];
M2125.ConversionConventionalWBar(:,:,1:TimeRange)=[];

Address=strcat('G:\Paper2and3\Result-',num2str(110084),'.mat');%M2 at 15 m
M215=load(Address,'X','ZC','Time','Eta','WBar','RhoPrimeConventional','ConversionConventionalTimeAvrDepthIntWBar','ConversionConventionalTimeAvrWBar','ConversionConventionalWBar');
M215.Time(1:TimeRange)=[];
M215.Eta(:,1:TimeRange)=[];
M215.WBar(:,:,1:TimeRange)=[];
M215.RhoPrimeConventional(:,:,1:TimeRange)=[];
M215.ConversionConventionalWBar(:,:,1:TimeRange)=[];

Address=strcat('G:\Paper2and3\Result-',num2str(110086),'.mat');%M2 at 20 m
M220=load(Address,'X','ZC','Time','Eta','WBar','RhoPrimeConventional','ConversionConventionalTimeAvrDepthIntWBar','ConversionConventionalTimeAvrWBar','ConversionConventionalWBar');
M220.Time(1:TimeRange)=[];
M220.Eta(:,1:TimeRange)=[];
M220.WBar(:,:,1:TimeRange)=[];
M220.RhoPrimeConventional(:,:,1:TimeRange)=[];
M220.ConversionConventionalWBar(:,:,1:TimeRange)=[];

TimeRange=1;
TimeIndex=200;

MargineTop=0.07;
MargineBot=0.15;
MargineLeft=0.12;
MargineRight=0.61;
SubplotSpac=0.02;
SubplotNumber=4;

SubplotCounter=4;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
Marker=M25.Time(TimeRange:10:TimeIndex);

plot(Marker/3600,100*squeeze(M25.Eta(XIndex(1),TimeRange:10:TimeIndex)),'-.','Color',MyColor(1,:),'LineWidth',2,'MarkerIndices',1:5:length(Marker));
plot(Marker/3600,100*squeeze(M275.Eta(XIndex(2),TimeRange:10:TimeIndex)),'-.','Color',MyColor(2,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(Marker/3600,100*squeeze(M210.Eta(XIndex(3),TimeRange:10:TimeIndex)),'-.','Color',MyColor(3,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(Marker/3600,100*squeeze(M2125.Eta(XIndex(4),TimeRange:10:TimeIndex)),'-.','Color',MyColor(4,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(Marker/3600,100*squeeze(M215.Eta(XIndex(5),TimeRange:10:TimeIndex)),'-.','Color',MyColor(5,:),'LineWidth',2,'MarkerIndices',3:5:length(Marker));
plot(Marker/3600,100*squeeze(M220.Eta(XIndex(6),TimeRange:10:TimeIndex)),'-.','Color',MyColor(6,:),'LineWidth',2,'MarkerIndices',4:5:length(Marker));
line([M220.Time(TimeRange)/3600 M220.Time(TimeIndex)/3600],[0 0],'LineWidth',1,'LineStyle',':','Color','black');

scatter(M25.Time(TimeRange+134)/3600,25,100,'p','filled','MarkerEdgeColor','black','MarkerFaceColor','black');

axis([399 415 -60 60]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-50:50:50;
MyAxe.YAxis.MinorTickValues=-90:10:90;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=400:10:410;
MyAxe.XAxis.MinorTickValues=399:432;

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];

set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$\eta$';'$[cm]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[396 LabelPos(2)];
text(400,-40,'$a$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'XTickLabel','');

plot(Marker/3600,1000*squeeze(M25.WBar(XIndex(1),ZIndex(1),TimeRange:10:TimeIndex)),'-.','Color',MyColor(1,:),'LineWidth',2,'MarkerIndices',1:5:length(Marker));
plot(Marker/3600,1000*squeeze(M275.WBar(XIndex(2),ZIndex(2),TimeRange:10:TimeIndex)),'-.','Color',MyColor(2,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(Marker/3600,1000*squeeze(M210.WBar(XIndex(3),ZIndex(3),TimeRange:10:TimeIndex)),'-.','Color',MyColor(3,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(Marker/3600,1000*squeeze(M2125.WBar(XIndex(4),ZIndex(4),TimeRange:10:TimeIndex)),'-.','Color',MyColor(4,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(Marker/3600,1000*squeeze(M215.WBar(XIndex(5),ZIndex(5),TimeRange:10:TimeIndex)),'-.','Color',MyColor(5,:),'LineWidth',2,'MarkerIndices',3:5:length(Marker));
plot(Marker/3600,1000*squeeze(M220.WBar(XIndex(6),ZIndex(6),TimeRange:10:TimeIndex)),'-.','Color',MyColor(6,:),'LineWidth',2,'MarkerIndices',4:5:length(Marker));
line([M220.Time(TimeRange)/3600 M220.Time(TimeIndex)/3600],[0 0],'LineWidth',1,'LineStyle',':','Color','black');

axis([399 415 -1.8 1.8]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-1.4:1.4:1.4;
MyAxe.YAxis.MinorTickValues=-1.8:0.2:1.8;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=400:10:410;
MyAxe.XAxis.MinorTickValues=399:432;

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];

set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$W$';'$[mm.s^{-1}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[396 LabelPos(2)];
text(400,-1.2,'$b$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

plot(Marker/3600,detrend(squeeze(M25.RhoPrimeConventional(XIndex(1),ZIndex(1),TimeRange:10:TimeIndex)),0),'-.','Color',MyColor(1,:),'LineWidth',2,'MarkerIndices',1:5:length(Marker));
plot(Marker/3600,detrend(squeeze(M275.RhoPrimeConventional(XIndex(2),ZIndex(2),TimeRange:10:TimeIndex)),0),'-.','Color',MyColor(2,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(Marker/3600,detrend(squeeze(M210.RhoPrimeConventional(XIndex(3),ZIndex(3),TimeRange:10:TimeIndex)),0),'-.','Color',MyColor(3,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(Marker/3600,detrend(squeeze(M2125.RhoPrimeConventional(XIndex(4),ZIndex(4),TimeRange:10:TimeIndex)),0),'-.','Color',MyColor(4,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(Marker/3600,detrend(squeeze(M215.RhoPrimeConventional(XIndex(5),ZIndex(5),TimeRange:10:TimeIndex)),0),'-.','Color',MyColor(5,:),'LineWidth',2,'MarkerIndices',3:5:length(Marker));
plot(Marker/3600,detrend(squeeze(M220.RhoPrimeConventional(XIndex(6),ZIndex(6),TimeRange:10:TimeIndex)),0),'-.','Color',MyColor(6,:),'LineWidth',2,'MarkerIndices',4:5:length(Marker));
line([M220.Time(TimeRange)/3600 M220.Time(TimeIndex)/3600],[0 0],'LineWidth',1,'LineStyle',':','Color','black');

axis([399 415 -0.2 0.2]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.14:0.14:0.14;
MyAxe.YAxis.MinorTickValues=-0.18:0.02:0.18;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=400:10:410;
MyAxe.XAxis.MinorTickValues=399:432;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$\rho''$';'$[kg.m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[396 LabelPos(2)];
text(400,-0.14,'$c$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

plot(Marker/3600,1000*squeeze(M25.ConversionConventionalWBar(XIndex(1),ZIndex(1),TimeRange:10:TimeIndex)),'-.','Color',MyColor(1,:),'LineWidth',2,'MarkerIndices',1:5:length(Marker));
plot(Marker/3600,1000*squeeze(M275.ConversionConventionalWBar(XIndex(2),ZIndex(2),TimeRange:10:TimeIndex)),'-.','Color',MyColor(2,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(Marker/3600,1000*squeeze(M210.ConversionConventionalWBar(XIndex(3),ZIndex(3),TimeRange:10:TimeIndex)),'-.','Color',MyColor(3,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(Marker/3600,1000*squeeze(M2125.ConversionConventionalWBar(XIndex(4),ZIndex(4),TimeRange:10:TimeIndex)),'-.','Color',MyColor(4,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(Marker/3600,1000*squeeze(M215.ConversionConventionalWBar(XIndex(5),ZIndex(5),TimeRange:10:TimeIndex)),'-.','Color',MyColor(5,:),'LineWidth',2,'MarkerIndices',3:5:length(Marker));
plot(Marker/3600,1000*squeeze(M220.ConversionConventionalWBar(XIndex(6),ZIndex(6),TimeRange:10:TimeIndex)),'-.','Color',MyColor(6,:),'LineWidth',2,'MarkerIndices',4:5:length(Marker));
line([M220.Time(TimeRange)/3600 M220.Time(TimeIndex)/3600],[0 0],'LineWidth',1,'LineStyle',':','Color','black');

axis([399 415 -0.8 1.8]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-1:1:1;
MyAxe.YAxis.MinorTickValues=-1.4:0.2:1.8;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=400:10:410;
MyAxe.XAxis.MinorTickValues=399:432; 
MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$Time$ $[hr]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.2];

MyYLabel=ylabel({'$C$';'$[mW.m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[396 LabelPos(2)];
text(400,1.2,'$d$','fontsize',24,'Color','black','BackgroundColor','none');

MargineTop=0.07;
MargineBot=0.15;
MargineLeft=0.44;
MargineRight=0.40;
SubplotSpac=0.00;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(1000*squeeze(M25.WBar(XIndex(1),:,TimeRange+134)+0*M25.RhoPrimeConventional(XIndex(1),:,TimeRange+134)),M25.ZC/10.75,'-.','Color',MyColor(1,:),'LineWidth',2,'MarkerIndices',1:5:length(Marker));
plot(1000*squeeze(M275.WBar(XIndex(2),:,TimeRange+134)+0*M275.RhoPrimeConventional(XIndex(2),:,TimeRange+134)),M25.ZC/13.75,'-.','Color',MyColor(2,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(1000*squeeze(M210.WBar(XIndex(3),:,TimeRange+134)+0*M210.RhoPrimeConventional(XIndex(3),:,TimeRange+134)),M25.ZC/13.75,'-.','Color',MyColor(3,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(1000*squeeze(M2125.WBar(XIndex(4),:,TimeRange+134)+0*M2125.RhoPrimeConventional(XIndex(4),:,TimeRange+134)),M25.ZC/16,'-.','Color',MyColor(4,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(1000*squeeze(M215.WBar(XIndex(5),:,TimeRange+134)+0*M215.RhoPrimeConventional(XIndex(5),:,TimeRange+134)),M25.ZC/21,'-.','Color',MyColor(5,:),'LineWidth',2,'MarkerIndices',3:5:length(Marker));
plot(1000*squeeze(M220.WBar(XIndex(6),:,TimeRange+134)+0*M220.RhoPrimeConventional(XIndex(6),:,TimeRange+134)),M25.ZC/25,'-.','Color',MyColor(6,:),'LineWidth',2,'MarkerIndices',4:5:length(Marker));
line([0 0],[-24 -1],'LineWidth',1,'LineStyle',':','Color','black');

axis([-0 1.6 -1 0]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-0.9:0.3:-0.3];
MyAxe.YAxis.MinorTickValues=-1:0.05:0;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=0:1:1;
MyAxe.XAxis.MinorTickValues=0:0.2:1.6;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$W$ $[mm.s^{-1}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.02];

lgd=legend('$5m$','$7.5m$','$10m$','$12.5m$','$15m$','$20m$','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1)+0.2 LGDPositio(2)+0.055 LGDPositio(3) LGDPositio(4)];
text(1.05,-0.05,'$e$','fontsize',24,'Color','black','BackgroundColor','none');

MargineTop=0.07;
MargineBot=0.15;
MargineLeft=0.61;
MargineRight=0.23;
SubplotSpac=0.00;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(squeeze(M25.RhoPrimeConventional(XIndex(1),:,TimeRange+134)),M25.ZC/10.75,'-.','Color',MyColor(1,:),'LineWidth',2,'MarkerIndices',1:5:length(Marker));
plot(squeeze(M275.RhoPrimeConventional(XIndex(2),:,TimeRange+134)),M25.ZC/13.75,'-.','Color',MyColor(2,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(squeeze(M210.RhoPrimeConventional(XIndex(3),:,TimeRange+134)),M25.ZC/13.75,'-.','Color',MyColor(3,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(squeeze(M2125.RhoPrimeConventional(XIndex(4),:,TimeRange+134)),M25.ZC/16,'-.','Color',MyColor(4,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(squeeze(M215.RhoPrimeConventional(XIndex(5),:,TimeRange+134)),M25.ZC/21,'-.','Color',MyColor(5,:),'LineWidth',2,'MarkerIndices',3:5:length(Marker));
plot(squeeze(M220.RhoPrimeConventional(XIndex(6),:,TimeRange+134)),M25.ZC/25,'-.','Color',MyColor(6,:),'LineWidth',2,'MarkerIndices',4:5:length(Marker));
line([0 0],[-24 -1],'LineWidth',1,'LineStyle',':','Color','black');

axis([-0.05 0.2 -1 0]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-0.9:0.3:-0.3];
MyAxe.YAxis.MinorTickValues=-1:0.05:0;
MyAxe.YAxis.TickLabels='';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=0:0.1:0.1;
MyAxe.XAxis.MinorTickValues=-0.2:0.025:0.2;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$\rho''$ $[kg.m^{-3}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.02];
text(0.15,-0.05,'$f$','fontsize',24,'Color','black');

MargineTop=0.07;
MargineBot=0.15;
MargineLeft=0.78;
MargineRight=0.06;
SubplotSpac=0.00;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(1000*squeeze(M25.ConversionConventionalWBar(XIndex(1),:,TimeRange+134)),M25.ZC/10.75,'-.','Color',MyColor(1,:),'LineWidth',2,'MarkerIndices',1:5:length(Marker));
plot(1000*squeeze(M275.ConversionConventionalWBar(XIndex(2),:,TimeRange+134)),M25.ZC/13.75,'-.','Color',MyColor(2,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(1000*squeeze(M210.ConversionConventionalWBar(XIndex(3),:,TimeRange+134)),M25.ZC/13.75,'-.','Color',MyColor(3,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(1000*squeeze(M2125.ConversionConventionalWBar(XIndex(4),:,TimeRange+134)),M25.ZC/16,'-.','Color',MyColor(4,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(1000*squeeze(M215.ConversionConventionalWBar(XIndex(5),:,TimeRange+134)),M25.ZC/21,'-.','Color',MyColor(5,:),'LineWidth',2,'MarkerIndices',3:5:length(Marker));
plot(1000*squeeze(M220.ConversionConventionalWBar(XIndex(6),:,TimeRange+134)),M25.ZC/25,'-.','Color',MyColor(6,:),'LineWidth',2,'MarkerIndices',4:5:length(Marker));
line([0 0],[-24 -1],'LineWidth',1,'LineStyle',':','Color','black');


axis([-0.5 2 -1 0]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-0.9:0.3:-0.3];
MyAxe.YAxis.MinorTickValues=-1:0.05:0;
MyAxe.YAxis.TickLabels='';
MyAxe.YAxisLocation='right';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-0:1.5:1.5;
MyAxe.XAxis.MinorTickValues=-0.5:0.25:2;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$z/H$'},'fontsize',20);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)+0.01 LabelPos(2)];

MyLabel=xlabel('$C$ $[mW.m^{-3}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.02];
text(1.5,-0.05,'$g$','fontsize',24,'Color','black');

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\VerticalStructurePycnocline');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\VerticalStructurePycnocline','epsc');
%%
%Figure 6- Dimesionless numbers at different pycno
%clear all;
close all;
FIG=figure('position',[100 100 600 600]);
counter=1;
RhoBConventionalCell=cell(14,1);
ConversionConventionalTimeAvrWBarCell=cell(14,1);
ConversionConventionalTimeAvrDepthIntWBarCell=cell(14,1);
UCell=cell(14,1);
XCell=cell(14,1);
for j=[80,87]%M2 then K1
    for i=0:6
        Address=strcat('G:\Paper2and3\Result-',num2str(j+i+110000),'.mat');
        load(Address,'X','ZC','Time','U','RhoBConventional','ConversionConventionalTimeAvrWBar','ConversionConventionalTimeAvrDepthIntWBar');
        
        Dx=diff(X,1);
        Dx(end+1)=Dx(end);
        ConversionStartPoint=cumsum(Dx.*ConversionConventionalTimeAvrDepthIntWBar);
        ConversionStartPoint=ConversionStartPoint/ConversionStartPoint(end);
        ConversionStartPoint=find(ConversionStartPoint<0,1,'last');
        
        RhoBConventionalCell{counter}=RhoBConventional(ConversionStartPoint:end,:,1);
        ConversionConventionalTimeAvrWBarCell{counter}=ConversionConventionalTimeAvrWBar(ConversionStartPoint:end,:);
        ConversionConventionalTimeAvrDepthIntWBarCell{counter}=ConversionConventionalTimeAvrDepthIntWBar(ConversionStartPoint:end);
        XCell{counter}=X(ConversionStartPoint:end);
        UCell{counter}=U(ConversionStartPoint:end,:,:);
        
        counter=counter+1;
    end
end

counter=1;
TotalConversion=nan(14,1);
Gamma1Avg=nan(14,1);
for j=[80,87]%M2 then K1
    for i=0:6
        X=XCell{counter};
        RhoBConventional=RhoBConventionalCell{counter};
        ConversionConventionalTimeAvrDepthIntWBar=ConversionConventionalTimeAvrDepthIntWBarCell{counter};        

        Topo=RhoBConventional*0+repmat(ZC,1,size(X,1))';
        Topo=nanmin(Topo,[],2);

        N=sqrt(abs(diff(RhoBConventional,1,2)./diff(repmat(ZC,1,size(X,1))',1,2)*9.8/1000));
        N(:,end+1)=N(:,end);
        N(isnan(N))=0;
        N=trapz(ZC,N,2)./Topo;

        Topo=diff(Topo)./diff(X);
        Topo(end+1)=Topo(end);
        Topo=movmean(Topo,5);
        if j==80
            Omega=2*pi/12.4/3600;
        elseif j==87
            Omega=2*pi/23.9/3600;
        end
        f=0.725e-4;
        IWEpsilon=sqrt(Omega^2-f^2)./sqrt(N.^2-Omega^2);
        IWEpsilon(~isreal(IWEpsilon))=nan;
        Epsilon=Topo./IWEpsilon;
        Epsilon(isnan(Epsilon))=0;
        Gamma1Avg(counter)=trapz(X,Epsilon.*ConversionConventionalTimeAvrDepthIntWBar)/trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        TotalConversion(counter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        
        counter=counter+1;
    end
end
disp(Gamma1Avg);

Gamma2=nan(14,1);
Gamma2Counter=1;
for j=[80,87]
    for i=0:6
        ConversionConventionalTimeAvrDepthIntWBar=ConversionConventionalTimeAvrDepthIntWBarCell{Gamma2Counter};
        U=UCell{Gamma2Counter};
        X=XCell{Gamma2Counter};
        
        Depth=repmat(ZC,1,size(X,1))'+squeeze(U(:,:,1))*0;
        Depth=nanmin(Depth,[],2);
        Slope=diff(Depth)./diff(X);
        Slope=movmean(Slope,5);

        [~,XIndex]=max(movmean(ConversionConventionalTimeAvrDepthIntWBar,5));
        U0=max(nanmean(U(XIndex,:,:),2));
        d=-Depth(XIndex);
        h0=75-d;
        Kb=Slope(XIndex)/h0;
        if j==80
            Gamma2(Gamma2Counter)=U0*Kb/(2*3.1415/12.4/3600);      
        elseif j==87
            Gamma2(Gamma2Counter)=U0*Kb/(2*3.1415/23.9/3600);
        end
        Gamma2Counter=Gamma2Counter+1;
    end
end

disp(Gamma2);

MargineTop=0.05;
MargineBot=0.16;
MargineLeft=0.16;
MargineRight=0.1;
SubplotSpac=0.06;
SubplotNumber=2;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;

MyColor=[0.85 0.325 0.098;...
    0.929 0.6941 0.1255];
MyStyle={'-p','-s'};

Gamma1AvgVec=Gamma1Avg(1:7);
plot(5:2.5:20,Gamma1AvgVec,MyStyle{1},'MarkerFaceColor',MyColor(1,:),'Color',MyColor(1,:),'LineWidth',2,'MarkerSize',12);
ylim([5 8]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=5:0.5:8;
MyAxe.YAxis(1).TickValues=5.5:2:7.5;

yyaxis right;

Gamma1AvgVec=Gamma1Avg(8:14);
plot(5:2.5:20,Gamma1AvgVec,MyStyle{2},'MarkerFaceColor',MyColor(2,:),'Color',MyColor(2,:),'LineWidth',2,'MarkerSize',12);
ylim([65 100]);
MyAxe=gca;
MyAxe.YAxis(2).MinorTick='on';
MyAxe.YAxis(2).MinorTickValues=65:5:100;
MyAxe.YAxis(2).TickValues=70:20:90;

MyAxe=gca;
MyAxe.YAxis(1).Color=MyColor(1,:);
MyAxe.YAxis(2).Color=MyColor(2,:);

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
box on;
xlim([4 21])
set(gca,'XTick',0:2.5:20);
set(gca,'XTickLabel','');
set(gca,'TickLength',[0.015,0.015]);

MyLabel=ylabel('$\Gamma_1$','fontsize',18,'color','black');
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-21.5 LabelPos(2)];
text(5,95,'$a$','fontsize',24,'Color','black');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;

plot(5:2.5:20,Gamma2(1:7),MyStyle{1},'MarkerFaceColor',MyColor(1,:),'Color',MyColor(1,:),'LineWidth',2,'MarkerSize',12);
plot(5:2.5:20,Gamma2(8:14),MyStyle{2},'MarkerFaceColor',MyColor(2,:),'Color',MyColor(2,:),'LineWidth',2,'MarkerSize',12);
ylim([0.08 0.22]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=0.08:0.01:0.22
MyAxe.YAxis(1).TickValues=0.12:0.06:0.18

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
box on;
xlim([4 21])
set(gca,'XTick',0:2.5:20);
set(gca,'TickLength',[0.015,0.015]);

MyLabel=ylabel('$\Gamma_2$','fontsize',18,'color','black');
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-0.2 LabelPos(2)];

MyLabel=xlabel('Pycnocline Depth [m]','fontsize',18,'color','black');
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.01];
text(5,0.2,'$b$','fontsize',24,'Color','black');

lgd=legend('$M_2$','$K_1$','Interpreter','latex','FontSize',16,'Location','north','Orientation','horizontal');
POS=lgd.Position;
lgd.Position=[POS(1) POS(2)+0.07 POS(3) POS(4)];
lgd.FontSize=13;

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\DimensionlessNumber');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\DimensionlessNumber','epsc');
%%
%Figure 7- Conversion at different pycno and with different initial phase
clear all;
close all;

FIG=figure('position',[100 100 600 600]);

counter=1;
TotalConversion=nan(21,1);
for j=[80,87,45]%M2 then K1 then M2K1
    for i=0:6
        Address=strcat('G:\Paper2and3\Result-',num2str(j+i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        TotalConversion(counter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        
        counter=counter+1;
    end
end

MargineTop=0.05;
MargineBot=0.16;
MargineLeft=0.16;
MargineRight=0.1;
SubplotSpac=0.02;
SubplotNumber=2;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;

MyColor=[ 0.85 0.325 0.098;...
    0.929 0.6941 0.1255;...
    0 0.447 0.741];
MyStyle={'-p','-s','-d'};

for counter=1:3
    plot(5:2.5:20,TotalConversion((counter-1)*7+1:counter*7),MyStyle{counter},'MarkerFaceColor',MyColor(counter,:),'Color',MyColor(counter,:),'LineWidth',2,'MarkerSize',10);
end
ylim([0 1.7]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=0:0.1:1.6;
MyAxe.YAxis(1).TickValues=0:0.4:1.6;

MyLabel=ylabel('$\widehat{\langle\overline{C}\rangle}$ $[W.m^{-1}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-2.3 LabelPos(2) -1];

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
box on;
[lgd,objh]=legend('$M_2$','$K_1$','$M_2K_1$','Interpreter','latex','FontSize',16,'Location','north','Orientation','horizontal');
%objhl = findobj(objh, 'type', 'line'); %// objects of legend of type line
%set(objhl, 'Markersize', 8); %// set marker size as desired
POS=lgd.Position;
lgd.Position=[POS(1) POS(2)+0.0 POS(3) POS(4)];
lgd.FontSize=13;
xlim([4 21.2])
set(gca,'XTick',0:2.5:20);
set(gca,'XTickLabel','');
set(gca,'TickLength',[0.015,0.015]);
text(4.6,1.5,'$a$','fontsize',24,'Color','black');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;

CaseValue(:,1)=TotalConversion(15:21);%M2K1
CaseValue(:,2)=TotalConversion(1:7);%M2
CaseValue(:,3)=TotalConversion(8:14);%k1
CaseValue(:,4)=CaseValue(:,1)-CaseValue(:,2)-CaseValue(:,3);

bar([5:2.5:20],CaseValue);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
ylim([-0.3 1.8]);
lgd=legend('$M_2+K_1$','$M_2$','$K_1$','NT','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1) LGDPositio(2)-0.01 LGDPositio(3) LGDPositio(4)];
MyAxe=gca;
MyAxe.XAxisLocation='bottom';
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-0.5:0.1:1.8;
MyAxe.YAxis(1).TickValues=-0.5:0.5:1.8;
MyLabel=ylabel('$\widehat{\langle\overline{C}\rangle}$ $[W.m^{-1}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-.2 LabelPos(2) -1];
MyLabel=xlabel('Pycnocline Depth [$m$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.2];
box on;
text(4.6,1.50,'$b$','fontsize',24,'Color','black');
set(gca,'XTick',[5:2.5:20]);
set(gca,'TickLength',[0.015,0.015]);
xlim([4 21.227]);
box on;

text(5+0.1,0.75,num2str(CaseValue(1,2)/CaseValue(1,1)*100,3),'fontsize',14,'Color',[0.85 0.33 0.1]);
text(7.5+0.1,0.75,num2str(CaseValue(2,2)/CaseValue(2,1)*100,2),'fontsize',14,'Color',[0.85 0.33 0.1]);
text(10+0.1,0.75,num2str(CaseValue(3,2)/CaseValue(3,1)*100,2),'fontsize',14,'Color',[0.85 0.33 0.1]);
text(12.5+0.1,0.75,num2str(CaseValue(4,2)/CaseValue(4,1)*100,2),'fontsize',14,'Color',[0.85 0.33 0.1]);
text(15+0.1,0.75,num2str(CaseValue(5,2)/CaseValue(5,1)*100,2),'fontsize',14,'Color',[0.85 0.33 0.1]);
text(17.5+0.1,0.75,num2str(CaseValue(6,2)/CaseValue(6,1)*100,2),'fontsize',14,'Color',[0.85 0.33 0.1]);
text(20+0.1,0.75,num2str(CaseValue(7,2)/CaseValue(7,1)*100,2),'fontsize',14,'Color',[0.85 0.33 0.1]);

text(5+0.1,0.55,num2str(CaseValue(1,3)/CaseValue(1,1)*100,2),'fontsize',14,'Color',[0.93 0.69 0.13]);
text(7.5+0.1,0.55,num2str(CaseValue(2,3)/CaseValue(2,1)*100,2),'fontsize',14,'Color',[0.93 0.69 0.13]);
text(10+0.1,0.55,num2str(CaseValue(3,3)/CaseValue(3,1)*100,2),'fontsize',14,'Color',[0.93 0.69 0.13]);
text(12.5+0.1,0.55,num2str(CaseValue(4,3)/CaseValue(4,1)*100,2),'fontsize',14,'Color',[0.93 0.69 0.13]);
text(15+0.1,0.55,num2str(CaseValue(5,3)/CaseValue(5,1)*100,2),'fontsize',14,'Color',[0.93 0.69 0.13]);
text(17.5+0.1,0.55,num2str(CaseValue(6,3)/CaseValue(6,1)*100,2),'fontsize',14,'Color',[0.93 0.69 0.13]);
text(20+0.1,0.55,num2str(CaseValue(7,3)/CaseValue(7,1)*100,2),'fontsize',14,'Color',[0.93 0.69 0.13]);

text(5+0.1,0.35,num2str(CaseValue(1,4)/CaseValue(1,1)*100,2),'fontsize',14,'Color',[0.49 0.18 0.56]);
text(7.5+0.1,0.35,num2str(CaseValue(2,4)/CaseValue(2,1)*100,2),'fontsize',14,'Color',[0.49 0.18 0.56]);
text(10+0.1,0.35,num2str(CaseValue(3,4)/CaseValue(3,1)*100,2),'fontsize',14,'Color',[0.49 0.18 0.56]);
text(12.5+0.1,0.35,num2str(CaseValue(4,4)/CaseValue(4,1)*100,2),'fontsize',14,'Color',[0.49 0.18 0.56]);
text(15+0.1,0.35,num2str(CaseValue(5,4)/CaseValue(5,1)*100,1),'fontsize',14,'Color',[0.49 0.18 0.56]);
text(17.5+0.1,0.35,num2str(CaseValue(6,4)/CaseValue(6,1)*100,2),'fontsize',14,'Color',[0.49 0.18 0.56]);
text(20+0.1,0.35,num2str(CaseValue(7,4)/CaseValue(7,1)*100,2),'fontsize',14,'Color',[0.49 0.18 0.56]);

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\ConversionContribution');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\ConversionContribution','epsc');
%%
%Figure 8- Conversion Frequencies in the system
clear
close all;
clc

MyColor=[0.47 0.67 0.19;...
    0.49 0.18 0.56;...
    0.64 0.08 0.18;...
    0.30 0.75 0.93;...
    1.00 0.07 0.51;...
    0.72 0.27 1.00;...
    0.50 0.50 0.50];

FIG=figure('position',[100 50 800 800]);
MargineTop=0.08;
MargineBot=0.15;
MargineLeft=0.15;
MargineRight=0.1;
SubplotSpac=0.06;
SubplotNumber=3;

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
for i=45:51 %M2K1
    Address=strcat('G:\Paper2and3\Result-',num2str(i+110000),'.mat');
    load(Address,'X','ZC','Time','ConversionConventionalTimeAvrDepthIntWBar','ConversionConventionalTimeAvrWBar','ConversionConventionalWBar');
    [~,XIndex]=max(ConversionConventionalTimeAvrDepthIntWBar);
    [~,ZIndex]=max(squeeze(ConversionConventionalTimeAvrWBar(XIndex,:)));
    
    Data=squeeze(ConversionConventionalWBar(XIndex,ZIndex,:));
    Fs=12*24;
    L=size(Data,1);
    Y = fft(Data);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    Period=1./f*24;
    semilogx(Period,1000*P1(1:end),'-.','Color',MyColor(i-44,:),'Linewidth',2);
    axis([4 30 0 1]);
    set(gca,'FontWeight','bold');
    set(gca,'fontsize',18);
    hold on;
end
axis([3.7 30 0 1]);
MyAxe=gca;
MyAxe.XAxis.TickValues=[4.13 4.92 6.2 8.17 12.4 25.8];
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.MinorTickValues=0:0.1:0.9;
MyAxe.YAxis.TickValues=0:0.3:0.9;
text(4,0.85,'$a$','Interpreter','latex','Fontsize',24);

lgd=legend('$5m$','$7.5m$','$10m$','$12.5m$','$15m$','$17.5m$','$20m$','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1)+0.04 LGDPositio(2)+0.055 LGDPositio(3) LGDPositio(4)];

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
for i=87:93 %K1
    Address=strcat('G:\Paper2and3\Result-',num2str(i+110000),'.mat');
    load(Address,'X','ZC','Time','ConversionConventionalTimeAvrDepthIntWBar','ConversionConventionalTimeAvrWBar','ConversionConventionalWBar');
    [~,XIndex]=max(ConversionConventionalTimeAvrDepthIntWBar);
    [~,ZIndex]=max(squeeze(ConversionConventionalTimeAvrWBar(XIndex,:)));
    
    Data=squeeze(ConversionConventionalWBar(XIndex,ZIndex,:));
    Fs=12*24;
    L=size(Data,1);
    Y = fft(Data);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    Period=1./f*24;
    semilogx(Period,1000*P1(1:end),'-.','Color',MyColor(i-86,:),'Linewidth',2);
    axis([4 30 0 0.4]);
    set(gca,'FontWeight','bold');
    set(gca,'fontsize',18);
    hold on;
end
axis([3.7 30 0 0.39]);
MyAxe=gca;
MyAxe.XAxis.TickValues=[7.97, 11.95 23.90];
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.MinorTickValues=0:0.05:0.4;
MyAxe.YAxis.TickValues=0:0.1:0.4;
text(4,0.32,'$b$','Interpreter','latex','Fontsize',24);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
for i=80:86 %M2
    Address=strcat('G:\Paper2and3\Result-',num2str(i+110000),'.mat');
    load(Address,'X','ZC','Time','ConversionConventionalTimeAvrDepthIntWBar','ConversionConventionalTimeAvrWBar','ConversionConventionalWBar');
    [~,XIndex]=max(ConversionConventionalTimeAvrDepthIntWBar);
    [~,ZIndex]=max(squeeze(ConversionConventionalTimeAvrWBar(XIndex,:)));
    
    Data=squeeze(ConversionConventionalWBar(XIndex,ZIndex,:));
    Fs=12*24;
    L=size(Data,1);
    Y = fft(Data);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(L/2))/L;
    Period=1./f*24;
    semilogx(Period,1000*P1(1:end),'-.','Color',MyColor(i-79,:),'Linewidth',2);
    axis([4 30 0 2]);
    set(gca,'FontWeight','bold');
    set(gca,'fontsize',18);
    hold on;
end
axis([3.7 30 0 1.1]);
MyAxe=gca;
MyAxe.XAxis.TickValues=[4.13 6.2 12.4];
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.MinorTickValues=0:0.1:1.1;
MyAxe.YAxis.TickValues=0:0.3:1.1;

MyYLabel=xlabel('Period $[Hour]$','fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1) LabelPos(2)-0.2];

MyYLabel=ylabel('C $[W.m^{-3}]$','fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.3 LabelPos(2)+1.3];
text(4,0.92,'$c$','Interpreter','latex','Fontsize',24);

text(31,3.3,'$M_2K_1$','Interpreter','latex','Fontsize',18);
text(31,1.9,'$K_1$','Interpreter','latex','Fontsize',18);
text(31,0.6,'$M_2$','Interpreter','latex','Fontsize',18);

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\FourierDecomposition');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\FourierDecomposition','epsc');
%%
%Figure 9- The vertical profile showing the effect of tidal constituents on the conversion
%clear all;
close all;
FIG=figure('position',[100 300 1000 600]);

XIndex=474;
ZIndex=36;
TimeRange=3600;
TimeIndex=4000;

MyColor=[ 0.85 0.325 0.098;...%red
    0.929 0.6941 0.1255;...%yellow
    0 0.447 0.741];%blue
% 
Address=strcat('G:\Paper2and3\Result-',num2str(110047),'.mat');%M2K1 at 10m
M2K1=load(Address,'X','ZC','Time','Eta','WBar','RhoPrimeConventional','ConversionConventionalTimeAvrDepthIntWBar','ConversionConventionalTimeAvrWBar','ConversionConventionalWBar');

Address=strcat('G:\Paper2and3\Result-',num2str(110082),'.mat');%M2 at 10m
M2=load(Address,'X','ZC','Time','Eta','WBar','RhoPrimeConventional','ConversionConventionalTimeAvrDepthIntWBar','ConversionConventionalTimeAvrWBar','ConversionConventionalWBar');

Address=strcat('G:\Paper2and3\Result-',num2str(110089),'.mat');%K1 at 10 m
K1=load(Address,'X','ZC','Time','Eta','WBar','RhoPrimeConventional','ConversionConventionalTimeAvrDepthIntWBar','ConversionConventionalTimeAvrWBar','ConversionConventionalWBar');

% 
MargineTop=0.07;
MargineBot=0.15;
MargineLeft=0.12;
MargineRight=0.6;
SubplotSpac=0.02;
SubplotNumber=4;

SubplotCounter=4;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
plot(M2K1.Time(TimeRange:TimeIndex)/3600,100*squeeze(M2K1.Eta(XIndex,TimeRange:TimeIndex)),'Color',MyColor(3,:),'LineWidth',2);
plot(M2.Time(TimeRange:TimeIndex)/3600,100*squeeze(M2.Eta(XIndex,TimeRange:TimeIndex)),'Color',MyColor(1,:),'LineWidth',2);
plot(K1.Time(TimeRange:TimeIndex)/3600,100*squeeze(K1.Eta(XIndex,TimeRange:TimeIndex)),'Color',MyColor(2,:),'LineWidth',2);
line([M2K1.Time(TimeRange)/3600 M2K1.Time(TimeIndex)/3600],[0 0],'LineWidth',1,'LineStyle',':','Color','black');

axis([399 432 -90 90]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-50:50:50;
MyAxe.YAxis.MinorTickValues=-90:10:90;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=405:10:425;
MyAxe.XAxis.MinorTickValues=399:432;

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];

set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$\eta$';'$[cm]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[392 LabelPos(2)];
text(400,70,'$a$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'XTickLabel','');

plot(M2K1.Time(TimeRange:TimeIndex)/3600,1000*squeeze(M2K1.WBar(XIndex,ZIndex,TimeRange:TimeIndex)),'Color',MyColor(3,:),'LineWidth',2);
plot(M2.Time(TimeRange:TimeIndex)/3600,1000*squeeze(M2.WBar(XIndex,ZIndex,TimeRange:TimeIndex)),'Color',MyColor(1,:),'LineWidth',2);
plot(K1.Time(TimeRange:TimeIndex)/3600,1000*squeeze(K1.WBar(XIndex,ZIndex,TimeRange:TimeIndex)),'Color',MyColor(2,:),'LineWidth',2);
line([M2K1.Time(TimeRange)/3600 M2K1.Time(TimeIndex)/3600],[0 0],'LineWidth',1,'LineStyle',':','Color','black');

axis([399 432 -1.8 1.8]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-1.4:1.4:1.4;
MyAxe.YAxis.MinorTickValues=-1.8:0.2:1.8;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=405:10:425;
MyAxe.XAxis.MinorTickValues=399:432;

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];

set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$W$';'$[mm.s^{-1}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[392 LabelPos(2)];
text(400,1.2,'$b$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

plot(M2K1.Time(TimeRange:TimeIndex)/3600,squeeze(M2K1.RhoPrimeConventional(XIndex,ZIndex,TimeRange:TimeIndex)),'Color',MyColor(3,:),'LineWidth',2);
plot(M2.Time(TimeRange:TimeIndex)/3600,squeeze(M2.RhoPrimeConventional(XIndex,ZIndex,TimeRange:TimeIndex)),'Color',MyColor(1,:),'LineWidth',2);
plot(K1.Time(TimeRange:TimeIndex)/3600,squeeze(K1.RhoPrimeConventional(XIndex,ZIndex,TimeRange:TimeIndex)),'Color',MyColor(2,:),'LineWidth',2);
line([M2K1.Time(TimeRange)/3600 M2K1.Time(TimeIndex)/3600],[0 0],'LineWidth',1,'LineStyle',':','Color','black');

axis([399 432 -0.2 0.2]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.14:0.14:0.14;
MyAxe.YAxis.MinorTickValues=-0.18:0.02:0.18;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=405:10:425;
MyAxe.XAxis.MinorTickValues=399:432;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$\rho''$';'$[kg.m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[392 LabelPos(2)];
text(400,-0.14,'$c$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

plot(M2K1.Time(TimeRange:TimeIndex)/3600,1000*squeeze(M2K1.ConversionConventionalWBar(XIndex,ZIndex,TimeRange:TimeIndex)),'Color',MyColor(3,:),'LineWidth',2);
plot(M2.Time(TimeRange:TimeIndex)/3600,1000*squeeze(M2.ConversionConventionalWBar(XIndex,ZIndex,TimeRange:TimeIndex)),'Color',MyColor(1,:),'LineWidth',2);
plot(K1.Time(TimeRange:TimeIndex)/3600,1000*squeeze(K1.ConversionConventionalWBar(XIndex,ZIndex,TimeRange:TimeIndex)),'Color',MyColor(2,:),'LineWidth',2);
line([M2K1.Time(TimeRange)/3600 M2K1.Time(TimeIndex)/3600],[0 0],'LineWidth',1,'LineStyle',':','Color','black');

scatter(M2.Time(TimeRange+134)/3600,1.208,100,'p','filled','MarkerEdgeColor',MyColor(1,:),'MarkerFaceColor',MyColor(1,:));
scatter(K1.Time(TimeRange+215)/3600,0.534,100,'p','filled','MarkerEdgeColor',MyColor(2,:),'MarkerFaceColor',MyColor(2,:));
scatter(M2K1.Time(TimeRange+215)/3600,1.204,100,'p','filled','MarkerEdgeColor',MyColor(3,:),'MarkerFaceColor',MyColor(3,:));

axis([399 432 -1.4 1.4]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-1:1:1;
MyAxe.YAxis.MinorTickValues=-1.4:0.2:1.4;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=405:10:425;
MyAxe.XAxis.MinorTickValues=399:432; 
MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$Time$ $[hr]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.1];

MyYLabel=ylabel({'$C$';'$[mW.m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[392 LabelPos(2)];
text(400,-1,'$d$','fontsize',24,'Color','black','BackgroundColor','none');

MargineTop=0.07;
MargineBot=0.15;
MargineLeft=0.44;
MargineRight=0.40;
SubplotSpac=0.00;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(1000*squeeze(M2K1.WBar(XIndex,:,TimeRange+215)),M2K1.ZC,'Color',MyColor(3,:),'LineWidth',2);
plot(1000*squeeze(M2.WBar(XIndex,:,TimeRange+134)),M2.ZC,'Color',MyColor(1,:),'LineWidth',2);
plot(1000*squeeze(K1.WBar(XIndex,:,TimeRange+215)),K1.ZC,'Color',MyColor(2,:),'LineWidth',2);
line([0 0],[-12 -1],'LineWidth',1,'LineStyle',':','Color','black');

axis([-1.6 1.6 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-1:1:1;
MyAxe.XAxis.MinorTickValues=-1.6:0.2:1.6;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$W$ $[mm.s^{-1}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];

lgd=legend('$M_2K_1$','$M_2$','$K_1$','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1)+0.08 LGDPositio(2)+0.055 LGDPositio(3) LGDPositio(4)];
text(-1.4,-1.7,'$e$','fontsize',24,'Color','black','BackgroundColor','none');

MargineTop=0.07;
MargineBot=0.15;
MargineLeft=0.61;
MargineRight=0.23;
SubplotSpac=0.00;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(squeeze(M2K1.RhoPrimeConventional(XIndex,:,TimeRange+215)),M2K1.ZC,'Color',MyColor(3,:),'LineWidth',2);
plot(squeeze(M2.RhoPrimeConventional(XIndex,:,TimeRange+134)),M2.ZC,'Color',MyColor(1,:),'LineWidth',2);
plot(squeeze(K1.RhoPrimeConventional(XIndex,:,TimeRange+215)),K1.ZC,'Color',MyColor(2,:),'LineWidth',2);
line([0 0],[-12 -1],'LineWidth',1,'LineStyle',':','Color','black');

axis([-0.2 0.2 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;
MyAxe.YAxis.TickLabels='';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-0.1:0.1:0.1;
MyAxe.XAxis.MinorTickValues=-0.2:0.05:0.2;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$\rho''$ $[kg.m^{-3}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];
text(-0.16,-1.7,'$f$','fontsize',24,'Color','black');

MargineTop=0.07;
MargineBot=0.15;
MargineLeft=0.78;
MargineRight=0.06;
SubplotSpac=0.00;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(1000*squeeze(M2K1.ConversionConventionalWBar(XIndex,:,TimeRange+215)),M2K1.ZC,'Color',MyColor(3,:),'LineWidth',2);
plot(1000*squeeze(M2.ConversionConventionalWBar(XIndex,:,TimeRange+134)),M2.ZC,'Color',MyColor(1,:),'LineWidth',2);
plot(1000*squeeze(K1.ConversionConventionalWBar(XIndex,:,TimeRange+215)),K1.ZC,'Color',MyColor(2,:),'LineWidth',2);
line([0 0],[-12 -1],'LineWidth',1,'LineStyle',':','Color','black');


axis([-0.5 2 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;
MyAxe.YAxis.TickLabels='';
MyAxe.YAxisLocation='right';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-0:1.5:1.5;
MyAxe.XAxis.MinorTickValues=-0.5:0.25:2;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$z$ $[m]$'},'fontsize',20);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)+0.01 LabelPos(2)];

MyLabel=xlabel('$C$ $[mW.m^{-3}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];
text(1.5,-1.7,'$g$','fontsize',24,'Color','black');

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\VerticalStructureTidalConstituent');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\VerticalStructureTidalConstituent','epsc');
%%
%Figure 10- Conversion at different pycno and with different initial phase
%clear all;
close all;
FIG=figure('position',[100 100 500 400]);

MargineTop=0.10;
MargineBot=0.20;
MargineLeft=0.20;
MargineRight=0.05;
SubplotSpac=0.01;
SubplotNumber=1;

MyColor=[ 0.85 0.325 0.098;...%red
    0.929 0.6941 0.1255;...%yellow
    0 0.447 0.741];%blue

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
StyleCounter=1;
MyStyle={'--d',':d','-.d'};
for j=[0,94,101]
    CaseNumber=[];
    CaseValue=[];
    for i=0+j:1:6+j
        Address=strcat('G:\Paper2and3\Result-',num2str(i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([-54:30:96,124],CaseValue,MyStyle{StyleCounter},'LineWidth',1.5,'MarkerSize',8,'color',MyColor(3,:));
    StyleCounter=StyleCounter+1;
end
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
lgd=legend('7.5m','15m','20m','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1) LGDPositio(2)+0.08 LGDPositio(3) LGDPositio(4)];
ylim([0.52 1.3]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=0.5:0.05:1.4;
MyAxe.YAxis(1).TickValues=0.6:0.3:1.4;
xlim([-65 135]);
set(gca,'XTick',[-54:30:96,124]);
xlabel('$\overbrace{M_2,K_1}$ [$^\circ$]','fontsize',18);
box on;
lgd.FontSize=14;
MyLabel=ylabel('$\widehat{\langle\overline{C} \rangle}$ [$W.m^{-1}$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-10 LabelPos(2) -1];
MyAxe.YAxis.TickLength=[0.03 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\ConversionTidalLag');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\ConversionTidalLag','epsc');