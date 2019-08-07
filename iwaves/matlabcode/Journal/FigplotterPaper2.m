close all;
clear all;
clc

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');  
cd D:\;
%%
%Figure 1- Sea surface, rho', WBar and conversion at an arbitrary point
close all;
clear all;
load('F:\Sorush\Paper2\Results-110080.mat','Eta','RhoPrimeConventional','WBar','ConversionConventionalWBar','Time');

MargineTop=0.05;
MargineBot=0.12;
MargineLeft=0.15;
MargineRight=0.15;
SubplotSpac=0.02;
SubplotNumber=2;

XPOS=469;
ZPOS=35;
omega=2*pi/12.4/3600;
FIG=figure('position',[400 50 800 600]);

left_color = [0 0 0];
right_color = [0 0.45 .74];
set(FIG,'defaultAxesColorOrder',[left_color; right_color]);
SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot(Time*omega/2/pi,squeeze(Eta(XPOS,:)),'Color',left_color,'LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([31 35 -0.55 0.55]);
set(gca,'XTick',[31:0.125:35]);
set(gca,'XTickLabel','');
set(gca,'YTick',[-0.5:0.1:0.5]);
MyTickLabel=get(gca,'YTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:5:end,:)=MyTickLabel(1:5:end,:);
set(gca,'YTickLabel',FinalTickLabel);
text(0.1,0.4,'$a$','fontsize',24);
MyYLabel=ylabel({'$\eta$';'$[m]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.10, 0.5, 0]);

hold on;
yyaxis right;
plot(Time*omega/2/pi,1e4*squeeze(ConversionConventionalWBar(XPOS,ZPOS,:)),'LineWidth',2,'Color',right_color);
axis([31 35 -5.1 5.3]);
set(gca,'XTickLabel','');
set(gca,'YTick',[-5:1:5]);
MyTickLabel=get(gca,'YTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:5:end,:)=MyTickLabel(1:5:end,:);
set(gca,'YTickLabel',FinalTickLabel);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
text(0.1,0.70,'$d$','fontsize',24);
MyYLabel=ylabel({'$C$';'$[10^{-6}$ $W.m^{-3}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [1.10, 0.5, 0]);
hold off;

left_color = [0 0 0];
right_color = [0 0.45 .74];
set(FIG,'defaultAxesColorOrder',[left_color; right_color]);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot(Time*omega/2/pi,squeeze(RhoPrimeConventional(XPOS,ZPOS,:)),'LineWidth',2,'Color',left_color);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([31 35 -0.12 0.12]);
set(gca,'YTick',[-0.1:0.025:0.1]);
MyTickLabel=get(gca,'YTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:4:end,:)=MyTickLabel(1:4:end,:);
set(gca,'YTickLabel',FinalTickLabel);
text(0.1,3.5,'$b$','fontsize',24);
MyYLabel=ylabel({'$\rho''$';'$[10^{-3}$ $kg.m^{-3}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.10, 0.5, 0]);

hold on;
yyaxis right;
plot(Time*omega/2/pi,1e4*squeeze(WBar(XPOS,ZPOS,:)),'LineWidth',2,'Color',right_color);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([31 35 -8 8]);
set(gca,'YTick',[-8.99:1:8.99]);
MyTickLabel=get(gca,'YTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:4:end,:)=MyTickLabel(1:5:end,:);
set(gca,'YTickLabel',FinalTickLabel);
text(0.1,0.45,'$c$','fontsize',24,'BackgroundColor', 'white');
MyYLabel=ylabel({'$W$';'$[10^{-4}$ $m.s^{-1}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [1.1, 0.5, 0]);
set(gca,'XTick',[31:0.125:35]);
MyTickLabel=get(gca,'XTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:8:end,:)=MyTickLabel(1:8:end,:);
set(gca,'XTickLabel',FinalTickLabel);
set(gca,'xaxisLocation','bottom');
MyYLabel=xlabel('t/T $[cycle^{-1}]$','fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [0.5, -0.16,0 ]);
hold off;

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\ConversionSample');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\ConversionSample','epsc');
%%
%Figure 2- Bathymetry and Map
clear all;
close all;

FIG=figure('position',[100 50 800 600]);
MargineTop=0.05;
MargineBot=0.12;
MargineLeft=0.12;
MargineRight=0.55;
SubplotSpac=0.0;
SubplotNumber=1;

SubplotCounter=1;
subplot1=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
set(gca, 'Color', 0.5*[1 1 1]);
hold on;

lat=ncread('D:\Paper2Results\monterey_13_navd88_2012.nc','lat');
lon=ncread('D:\Paper2Results\monterey_13_navd88_2012.nc','lon');
Bathymetry=ncread('D:\Paper2Results\monterey_13_navd88_2012.nc','Band1');
lat=lat(9500:10:16000);
lon=lon(3500:10:7500);
Bathymetry=Bathymetry(3500:10:7500,9500:10:16000);
%Bathymetry from NOAA website https://data.noaa.gov/metaview/page?xml=NOAA/NESDIS/NGDC/MGG/DEM/iso/xml/3544.xml&view=getDataView&header=none#
%Monterey, California 1/3 arc-second NAVD 88 Coastal Digital Elevation Model
Bathymetry(Bathymetry>=1)=nan;
pcolor(lon,lat,Bathymetry');
set(gca,'FontWeight','bold');
shading flat;
MyColorbar=colorbar('Location','northoutside');
MyColorbar.FontSize=18;
MyColorbar.FontWeight='bold';
MyColorbar.TickLabelInterpreter='latex';
text(-122,37.1,'Elevation $[m]$','Fontsize',18);
colormap(subplot1,jet);
axis equal;
caxis([-1500 0]);
set(gca, 'YAxisLocation', 'left');
set(gca, 'TickDir', 'out');
set(gca,'FontWeight','bold');
set(gca,'fontsize',16);
ylabel('Latitude [$Deg$]','fontsize',18);
xlabel('Longtitude [$Deg$]','fontsize',18);
axis([-122.05,-121.78,36.59,37]);
set(gca,'XTick',[-122.05:0.025:-121.75]);
MyTickLabel=get(gca,'XTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:4:end,:)=MyTickLabel(1:4:end,:);
set(gca,'XTickLabel',FinalTickLabel);

set(gca,'YTick',[36.6:0.025:37]);
MyTickLabel=get(gca,'YTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:4:end,:)=MyTickLabel(1:4:end,:);
set(gca,'YTickLabel',FinalTickLabel);
hold on;

line([-121.95,-121.95],[36.6,36.7],'Color','black','LineWidth',2,'LineStyle','--');
line([-121.8,-121.8],[36.6,36.7],'Color','black','LineWidth',2,'LineStyle','--');
line([-121.8,-121.95],[36.7,36.7],'Color','black','LineWidth',2,'LineStyle','--');
line([-121.8,-121.95],[36.6,36.6],'Color','black','LineWidth',2,'LineStyle','--');

contour(lon,lat,Bathymetry',[-25 -50 -75 -100 -250 -500 -750 -1000],'Color',[0 0 0],'Linewidth',0.5);
text(-122.04,36.98,'$a$','fontsize',24);

annotation('line',[0.425 0.505],[0.32167 0.8783],'LineWidth',2,'LineStyle','--');
annotation('line',[0.425 0.505],[0.1567 0.555],'LineWidth',2,'LineStyle','--');

MargineTop=0.12;
MargineBot=0.12;
MargineLeft=0.45;
MargineRight=0.07;
SubplotSpac=0.10;
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
ylabel('Latitude [$Deg$]','fontsize',18);
xlabel('Longtitude [$Deg$]','fontsize',18);
axis([-121.95,-121.80,36.6,36.7]);
text(-121.942,36.688,'$b$','fontsize',24);
contour(lon,lat,Bathymetry',[-5 -10 -25 -50 -75],'Color',[0 0 0],'Linewidth',0.5);
set(gca,'XTick',[-121.92,-121.87,-121.82]);
set(gca,'XTickLabel',{'-121.92','-121.87','-121.82'});
box on;


MargineTop=0.12;
MargineBot=0.12;
MargineLeft=0.55;
MargineRight=0.12;
SubplotSpac=0.10;
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
right_color = [0 0.45 .74];
set(FIG,'defaultAxesColorOrder',[left_color; right_color]);

plot(45.2-XFine/1000,-Bathymetry,'Color',[0 0 0],'LineStyle','-','LineWidth',2);
set(gca, 'XDir','reverse')
ylabel('Z $[m]$','fontsize',18);
text(5.6,-8.4,'$c$','fontsize',24);
xlim([0 6]);
set(gca,'YTick',[-75:20:-5]);
hold on;
yyaxis right
BathymetryDiff=diff(Bathymetry)./diff(XFine);
BathymetryDiff(end+1)=BathymetryDiff(end);
BathymetryDiff([4417,4418,4370])=[];
XFine([4417,4418,4370])=[];
plot(45.2-XFine/1000,-movmean(BathymetryDiff,20),'Color',[0 0.45 0.74],'LineStyle','-','LineWidth',2);
set(gca,'YTick',[0.01:0.02:0.08]);
set(gca,'fontsize',16);
xlabel('Offshore distance $[km]$','fontsize',18);
ylabel('Slope $[m.m^{-1}]$','fontsize',18);
set(gca,'FontWeight','bold');

FIG.Color='white';
fig = gcf;
fig.InvertHardcopy = 'off';
savefig(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\Monterey');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\Monterey','png');
%%
%Figure 3- Wind and tide Record
clear all;
close all;

FIG=figure('position',[100 50 1200 950]); 
FileAddressReader='D:\Paper2Results\WindJun2017BeachWeather.csv';
FileAddressWriter=strfind(FileAddressReader,'\');
FileAddressWriter=strcat(FileAddressReader(1:FileAddressWriter(end)),'Wind.txt');
Results=table2cell(readtable(FileAddressReader));
Time=nan(size(Results,1),1);
WindSpeed=nan(size(Results,1),1);
WindDirectionMet=nan(size(Results,1),1);
for k=1:size(Results,1)
   Time(k)=Results{k,2}+mod(Results{k,3},100)/60/24+floor(Results{k,3}/100)/24;
   WindSpeed(k)=Results{k,4};
   WindDirectionMet(k)=Results{k,5};
end

%Converting the meteorological convention to triangular convetion, if wind
%comes from south in meteorology convention, its angle would be 180;
%however, for triangular convention, it would be 90. Meaning that it 
%GOES to 90 not come from 90
%Averaging the wind to get it hourly
WindDirectionTri=-WindDirectionMet+270;
clear WindDirectionMet;
WindDirectionTri(WindDirectionTri>360)=WindDirectionTri(WindDirectionTri>360)-360;
WindDirectionTri(WindDirectionTri<0)=WindDirectionTri(WindDirectionTri<0)+360;
%Finding the East-West and South-North components
East=WindSpeed.*cosd(WindDirectionTri);
North=WindSpeed.*sind(WindDirectionTri);
%Recalculating the WDNOAA
 
MargineTop=0.07;
MargineBot=0.08;
MargineLeft=0.10;
MargineRight=0.55;
SubplotSpac=0.10;
SubplotNumber=3;

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot(Time,movmean(WindSpeed,6),'Linewidth',2);
set(gca,'fontsize',16);
axis([152 182 0 7]);
MyYLabel=ylabel('Wind Speed $[m.s^{-1}]$','fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.15, 0.5, 0]);
xlabel('Time [day of year]','fontsize',18);
set(gca,'XTick',[152:1:182]);
MyTickLabel=get(gca,'XTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:5:end,:)=MyTickLabel(1:5:end,:);
set(gca,'XTickLabel',FinalTickLabel);
text(153.1,6.5,'$a$','Interpreter','latex','Fontsize',24);
set(gca,'FontWeight','bold');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
Fs=6*24;
L=size(East,1);
Y = fft(East);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
semilogx(f(4:end),P1(4:end),'Linewidth',2) 
hold on;
line([1,1],[0,1.5],'Color','black','Linestyle','--','Linewidth',2);
hold off;
xlim([0.1 10]);
set(gca,'fontsize',16);
xlabel('Frequency $[cpd]$','fontsize',18);
MyYLabel=ylabel('Amplitude $[m.s^{-1}]$','fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.15, 0.5, 0]);
text(0.12,1.35,'$b$','Interpreter','latex','Fontsize',24);
set(gca,'FontWeight','bold');

MargineTop=0.07;
MargineBot=0.08;
MargineLeft=0.55;
MargineRight=0.10;
SubplotSpac=0.10;
SubplotNumber=3;

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
polarhistogram(WindDirectionTri*pi()/180);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
AX=gca;
AX.ThetaTick=[0:90:270];
AX.ThetaTickLabel={'East','North','West','South'};
%annotation('textbox',[0.89517 0.91895 0.0407 0.0516],'String',{'N'},'LineStyle','none','Interpreter','latex','FontSize',36,'FitBoxToText','off');
%annotation('arrow',[0.915 0.915],[0.84 0.921],'LineWidth',5,'Headsize',25);

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
C=princaxes(East,North,1);
text(-8.95,30,'$c$','Interpreter','latex','Fontsize',24);
text(-8.95,4.5,'$d$','Interpreter','latex','Fontsize',24);

%     Fs=6;
%     order=1;
%     fcutlow=1/24.5;
%     fcuthigh=1/23.5;
%     [b,a]=butter(order,[fcutlow,fcuthigh]/(Fs/2),'bandpass');
%     Filtered=filter(b,a,movmean(East-mean(East),20));
%     plot(Time,movmean(East-mean(East),20));
%     hold on;
%     plot(Time,Filtered);
%     set(gca,'fontsize',18);
%     set(gca,'FontWeight','bold');
MargineTop=0.07;
MargineBot=0.08;
MargineLeft=0.10;
MargineRight=0.55;
SubplotSpac=0.10;
SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
[InitialPhase,TideSeparated,TideName,TideAmp,TidePhase,TideFrequency,Time,Tide]=TidalPhaseSeparator('D:\Paper2Results\TideJun2018Monterey.csv',100,36.5);
Time=Time-datenum(2018,0,0);
Tide=Tide-mean(Tide);%converting the tide to mean sea level
Predict=TideSeparated(:,1)+TideSeparated(:,3);

plot(Time,Predict,'LineWidth',2,'Linestyle','-');
hold on;
plot(Time, Tide,'LineWidth',2,'Linestyle',':');
set(gca,'XTick',[152:1:182]);
MyTickLabel=get(gca,'XTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:5:end,:)=MyTickLabel(1:5:end,:);
set(gca,'XTickLabel',FinalTickLabel);
axis([152 182 -1.3 1.3]);
set(gca,'FontWeight','bold');
set(gca,'fontsize',16);
ylabel({'Sea Surface Height [$m$]'},'fontsize',18);
xlabel('Day of year','fontsize',18);
lgd=legend('$M_2+K_1$','Total','Location','northoutside','Orientation','horizontal');
lgd.FontSize=16;
text(153,1,'$e$','Interpreter','latex','Fontsize',24);

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\TideWindRecords');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\TideWindRecords','epsc');
%%
%Figure 4- Bathymetry and RhoB
clear all;
close all;

load('F:\Sorush\Paper2\Results-110080.mat','X','RhoBConventional','Density','ZC','ConversionConventionalTimeAvrDepthIntWBar','ConversionConventionalTimeAvrWBar');

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
x1 = squeeze(Density(1,:,1)+1000);
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
ax2.XLim=([0 0.045]);
set(ax2,'XTick',[0:0.005:0.04]);
MyTickLabel=get(ax2,'XTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:2:end,:)=MyTickLabel(1:2:end,:);
set(ax2,'XTickLabel',FinalTickLabel);
ax2.XColor=[0 0.45 .74];
set(gca,'YTickLabel','');
line(x2,y2,'Parent',ax2,'Color',[0 0.45 0.74],'LineStyle','-','LineWidth',2);
ylim([-75 0]);
set(gca,'fontsize',16);
MyYLabel=ylabel('Z $[m]$','fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.25, 0.5, 0]);
text(0.013,-82,'$\rho_b$ $[kg.m^{-3}]$','Interpreter','latex','Fontsize',18);
text(0.018,7,'$N$ $[s^{-1}]$','Color',[0 0.45 0.74],'Interpreter','latex','Fontsize',18);
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
MyYLabel=ylabel('Z $[m]$','fontsize',18);
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
plot(X/1000,1000*movmean(ConversionConventionalTimeAvrDepthIntWBar,10),'LineWidth',2);
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
MyLabel.Position=[LabelPos(1)-0.1 LabelPos(2) -1];
MyLabel=xlabel('Offshore distance [$km$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.2 -1];
box on;
text(3.1,0.95,'$c$','fontsize',24,'Color','black');
set(gca,'XTick',[0:10:50]);
xlim([0 50]);
box on;

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\DensityBathymetry');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\DensityBathymetry','epsc');
%%
%Figure 5- Conversion at different pycno
clear all;
close all;
FIG=figure('position',[100 100 600 600]);

MargineTop=0.10;
MargineBot=0.15;
MargineLeft=0.16;
MargineRight=0.05;
SubplotSpac=0.02;
SubplotNumber=2;
SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
NonLinear=[];
for j=[0,5,6]
    CaseNumber=[];
    CaseValue=[];
    for i=45+j*7:1:51+j*7
        Address=strcat('F:\Sorush\Paper2\Results-',num2str(i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    NonLinear(end+1:end+size(CaseValue,2))=CaseValue;
    plot([5:2.5:20],CaseValue,'-x','LineWidth',2,'MarkerSize',14);
end
NonLinear=NonLinear(1:7)-NonLinear(8:14)-NonLinear(15:21);
plot([5:2.5:20],NonLinear,'-x','LineWidth',2,'MarkerSize',14);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
MyLabel=ylabel('$\widehat{\langle\overline{C} \rangle}$ [$W.m^{-1}$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-3.2 LabelPos(2) -1];
lgd=legend('$M_2+K_1$','$M_2$','$K_1$','Non-Linear','Orientation','horizontal','Location','northoutside');
set(gca, 'XAxisLocation', 'bottom');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1) LGDPositio(2)+0.1 LGDPositio(3) LGDPositio(4)];
lgd.FontSize=14;
set(gca,'YTick',[-0.3:0.15:1.4]);
MyTickLabel=get(gca,'YTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:2:end,:)=MyTickLabel(1:2:end,:);
set(gca,'YTickLabel',FinalTickLabel);
ylim([-0.3 1.4]);
text(3.1,1.25,'$a$','fontsize',24,'Color','black');
xlim([2.5 21.227]);
set(gca,'XTick',[5:2.5:20]);
set(gca,'XTickLabel',{'','','','','','',''});
box on;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
CaseCounter=1;
CatCounter=1;
CaseNumber=nan(6,4);
CaseValue=nan(6,4);
for j=0:6
    CaseCounter=1;
    for i=[45+j,80+j,87+j]
        Address=strcat('F:\Sorush\Paper2\Results-',num2str(i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(CatCounter,CaseCounter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(CatCounter,CaseCounter)=i;
        CaseCounter=CaseCounter+1;
    end
    CatCounter=CatCounter+1;
end
CaseValue(:,4)=CaseValue(:,1)-CaseValue(:,2)-CaseValue(:,3);
CaseValue=CaseValue./repmat(CaseValue(:,1),1,4);
bar([5:2.5:20],CaseValue);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
ylim([-0.55 1.1]);
set(gca,'YTick',[-0.5:0.125:1]);
MyTickLabel=get(gca,'YTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:2:end,:)=MyTickLabel(1:2:end,:);
set(gca,'YTickLabel',FinalTickLabel);
MyLabel=ylabel('$\widehat{\langle\overline{C}\rangle}$ constituent share [$\%$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-1.4 LabelPos(2) -1];
MyLabel=xlabel('Pycnocline Depth [$m$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.2 -1];
box on;
text(3.1,0.95,'$b$','fontsize',24,'Color','black');
set(gca,'XTick',[5:2.5:20]);
xlim([2.5 21.227]);
box on;

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\ConversionPycnocline');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\ConversionPycnocline','epsc');

%%
%Figure 6- Conversion at different tidal phase lag
clear all;
close all;
FIG=figure('position',[100 100 600 600]);

MargineTop=0.08;
MargineBot=0.15;
MargineLeft=0.15;
MargineRight=0.05;
SubplotSpac=0.01;
SubplotNumber=2;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
for j=[0,94,101]
    CaseNumber=[];
    CaseValue=[];
    for i=0+j:1:6+j
        Address=strcat('F:\Sorush\Paper2\Results-',num2str(i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([-54:30:96,124],CaseValue,'-x','LineWidth',2,'MarkerSize',14);
end
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
lgd=legend('7.5','12.5','17.5','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1) LGDPositio(2)+0.1 LGDPositio(3) LGDPositio(4)];
ylim([0.5 1.3]);
set(gca,'YTick',[0.6:0.1:1.3]);
MyTickLabel=get(gca,'YTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:2:end,:)=MyTickLabel(1:2:end,:);
set(gca,'YTickLabel',FinalTickLabel);
xlim([-54 124]);
set(gca,'XTick',[-54:30:96,124]);
set(gca,'XTickLabel','');
box on;
lgd.FontSize=14;
MyLabel=ylabel('$\widehat{\langle\overline{C} \rangle}$ [$W.m^{-1}$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-4 LabelPos(2) -1];
text(-48,1.15,'$a$','fontsize',24,'Color','black');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
for j=[0,94,101]
    CaseNumber=[];
    CaseValue=[];
    for i=0+j:1:6+j
        Address=strcat('F:\Sorush\Paper2\Results-',num2str(i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([-54:30:96,124],CaseValue/max(CaseValue)*100,'-x','LineWidth',2,'MarkerSize',14);
end
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
xlabel('$\overbrace{M_2,K_1}$ [$Deg$]','fontsize',18);
ylim([97 100]);
set(gca,'YTick',[97:0.5:100]);
MyTickLabel=get(gca,'YTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:2:end,:)=MyTickLabel(1:2:end,:);
set(gca,'YTickLabel',FinalTickLabel);
xlim([-54 124]);
set(gca,'XTick',[-54:30:96,124]);
box on;
lgd.FontSize=14;
MyLabel=ylabel('$\widehat{\langle\overline{C} \rangle} . \widehat{\langle\overline{C} \rangle}_{max}^{-1}$ [$\%$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-1 LabelPos(2) -1];
text(-48,99.75,'$b$','fontsize',24,'Color','black');

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\ConversionTidalPhaseLag');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\ConversionTidaPhaseLag','epsc');
%%
%Figure 7- Conversion at different wind stress
clear all;
close all;
FIG=figure('position',[100 100 800 600]);

MargineTop=0.03;
MargineBot=0.13;
MargineLeft=0.13;
MargineRight=0.14;
SubplotSpac=0.012;
SubplotNumber=3;

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
for j=0:6
    CaseNumber=[];
    CaseValue=[];
    for i=[45+j:7:73+j]
        Address=strcat('F:\Sorush\Paper2\Results-',num2str(i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([0:1.5:6],CaseValue,'-x','LineWidth',2,'MarkerSize',14);
end
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
lgd=legend('5','7.5','10','12.5','15','17.5','20','Orientation','vertical','Location','eastoutside');
POS=lgd.Position;
lgd.Position=[POS(1)+0.12 POS(2)+0.012 POS(3) POS(4)];
set(gca,'XTick',0:1.5:6);
set(gca,'XTickLabel','');
ylim([0.2 1.4]);
set(gca,'YTick',[0.3:0.1:1.4]);
MyTickLabel=get(gca,'YTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:3:end,:)=MyTickLabel(1:3:end,:);
set(gca,'YTickLabel',FinalTickLabel);
box on;
lgd.FontSize=13;
MyLabel=ylabel('$\widehat{\langle\overline{C} \rangle}$ [$W.m^{-1}$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-0.2 LabelPos(2)-1.2 -1];

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
for j=0:6
    CaseNumber=[];
    CaseValue=[];
    for i=[7+j,14+j,81]
        Address=strcat('F:\Sorush\Paper2\Results-',num2str(i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([6,3,0],CaseValue,'-o','LineWidth',2,'MarkerSize',10);
end
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
lgd=legend('-48','-18','12','42','72','102','126','Orientation','vertical','Location','eastoutside');
POS=lgd.Position;
lgd.Position=[POS(1)+0.12 POS(2)+0.003 POS(3) POS(4)];
set(gca,'XTick',0:1.5:6);
set(gca,'XTickLabel','');
ylim([0.6 1.1]);
set(gca,'YTick',[0.7:0.1:1]);
MyTickLabel=get(gca,'YTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:2:end,:)=MyTickLabel(1:2:end,:);
set(gca,'YTickLabel',FinalTickLabel);
box on;
lgd.FontSize=14;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
for j=0:6
    CaseNumber=[];
    CaseValue=[];
    for i=[21+j,33+j,88]
        Address=strcat('F:\Sorush\Paper2\Results-',num2str(i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([6,3,0],CaseValue,'-s','LineWidth',2,'MarkerSize',14);
end
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
lgd=legend('-48','-18','12','42','72','102','126','Orientation','vertical','Location','eastoutside');
POS=lgd.Position;
lgd.Position=[POS(1)+0.12 POS(2)+0.003 POS(3) POS(4)];
set(gca,'XTick',0:1.5:6);
ylim([-0.6 1.2]);
set(gca,'YTick',[-0.5:0.2:1.2]);
MyTickLabel=get(gca,'YTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:2:end,:)=MyTickLabel(1:2:end,:);
set(gca,'YTickLabel',FinalTickLabel);
MyLabel=xlabel('Wind Speed [$m.s^{-1}$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.18 -1];
box on;
lgd.FontSize=14;

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\ConversionWindStress');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\ConversionWindStress','epsc');

%%
%Figure 8- Conversion at different wind lag
clear all;
close all;
FIG=figure('position',[100 100 600 600]);

MargineTop=0.08;
MargineBot=0.16;
MargineLeft=0.15;
MargineRight=0.05;
SubplotSpac=0.02;
SubplotNumber=2;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
for j=[0,7]
    CaseNumber=[];
    CaseValue=[];
    for i=[7+j:1:13+j]
        Address=strcat('F:\Sorush\Paper2\Results-',num2str(i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot(90-[-48:30:102,126],CaseValue,'-x','LineWidth',2,'MarkerSize',14);
end
load('F:\Sorush\Paper2\Results-110081.mat','X','ConversionConventionalTimeAvrDepthIntWBar');
line([-100 250],[trapz(X,ConversionConventionalTimeAvrDepthIntWBar),trapz(X,ConversionConventionalTimeAvrDepthIntWBar)],'Color','black','LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
lgd=legend('6','3','0','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1) LGDPositio(2)+0.05 LGDPositio(3) LGDPositio(4)];
xlim([-100 250]);
set(gca,'XTick',[-100:25:250]);
set(gca,'XTickLabel','');
ylim([0.6 1.1]);
set(gca,'YTick',[0.6:0.05:1.2]);
MyTickLabel=get(gca,'YTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:2:end,:)=MyTickLabel(1:2:end,:);
set(gca,'YTickLabel',FinalTickLabel);
box on;
lgd.FontSize=14;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
for j=[0,12]
    CaseNumber=[];
    CaseValue=[];
    for i=[21+j:1:32+j]
        Address=strcat('F:\Sorush\Paper2\Results-',num2str(i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([-48:30:282]-36,CaseValue,'-x','LineWidth',2,'MarkerSize',14);
end
load('F:\Sorush\Paper2\Results-110088.mat','X','ConversionConventionalTimeAvrDepthIntWBar');
line([-100 250],[trapz(X,ConversionConventionalTimeAvrDepthIntWBar),trapz(X,ConversionConventionalTimeAvrDepthIntWBar)],'Color','black','LineWidth',2);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'XTick',[-100:25:250]);
MyTickLabel=get(gca,'XTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:2:end,:)=MyTickLabel(1:2:end,:);
set(gca,'XTickLabel',FinalTickLabel);
xlim([-100 250]);
ylim([-0.75 1.25]);
set(gca,'YTick',[-0.50:0.25:1.25]);
MyTickLabel=get(gca,'YTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:2:end,:)=MyTickLabel(1:2:end,:);
set(gca,'YTickLabel',FinalTickLabel);
box on;
lgd.FontSize=14;
MyLabel=ylabel('$\widehat{\langle\overline{C} \rangle}$ [$W.m^{-1}$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)+1.2 -1];
MyLabel=xlabel('$\overbrace{Wind, Tide}$ [$Deg$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.07 -1];


savefig(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\ConversionWindLag');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\ConversionWindLag','epsc');