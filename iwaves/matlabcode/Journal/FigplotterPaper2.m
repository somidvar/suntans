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
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-0.5:0.1:0.5;
MyAxe.YAxis(1).TickValues=-0.5:0.5:0.5;
text(0.1,0.4,'$a$','fontsize',24);
MyYLabel=ylabel({'$\eta$';'$[m]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.10, 0.5, 0]);

hold on;
yyaxis right;
plot(Time*omega/2/pi,1e4*squeeze(ConversionConventionalWBar(XPOS,ZPOS,:)),'LineWidth',2,'Color',right_color);
axis([31 35 -5.1 5.3]);
set(gca,'XTickLabel','');
MyAxe=gca;
MyAxe.YAxis(2).MinorTick='on';
MyAxe.YAxis(2).MinorTickValues=-5:1:5;
MyAxe.YAxis(2).TickValues=-5:5:5;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
text(0.1,0.70,'$d$','fontsize',24);
MyYLabel=ylabel({'$C$';'$[10^{-6}$ $W.m^{-3}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [1.10, 0.5, 0]);
text(31.1,4,'$a$','fontsize',24,'BackgroundColor','white');
hold off;

left_color = [0 0 0];
right_color = [0 0.45 .74];
set(FIG,'defaultAxesColorOrder',[left_color; right_color]);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot(Time*omega/2/pi,squeeze(RhoPrimeConventional(XPOS,ZPOS,:)),'LineWidth',2,'Color',left_color);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([31 35 -0.07 0.05]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-0.07:0.01:0.05;
MyAxe.YAxis(1).TickValues=-0.06:0.03:0.05;
text(0.1,3.5,'$b$','fontsize',24);
MyYLabel=ylabel({'$\rho''$';'$[10^{-3}$ $kg.m^{-3}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.10, 0.5, 0]);

hold on;
yyaxis right;
plot(Time*omega/2/pi,1e4*squeeze(WBar(XPOS,ZPOS,:)),'LineWidth',2,'Color',right_color);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([31 35 -9 9]);
MyAxe=gca;
MyAxe.YAxis(2).MinorTick='on';
MyAxe.YAxis(2).MinorTickValues=-9:1:9;
MyAxe.YAxis(2).TickValues=-8:4:8;
text(0.1,0.45,'$c$','fontsize',24,'BackgroundColor', 'white');
MyYLabel=ylabel({'$W_{BT}$';'$[10^{-4}$ $m.s^{-1}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [1.1, 0.5, 0]);
set(gca,'XTick',[31:0.125:35]);
MyTickLabel=get(gca,'XTickLabel');
FinalTickLabel=strings(size(MyTickLabel,1),1);
FinalTickLabel(1:8:end,:)=MyTickLabel(1:8:end,:);
set(gca,'XTickLabel',FinalTickLabel);
set(gca,'xaxisLocation','bottom');
MyYLabel=xlabel('t/T $[cycle^{-1}]$','fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [0.5, -0.16,0 ]);
text(31.1,7,'$b$','fontsize',24,'BackgroundColor','white');
hold off;

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\ConversionSample');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\ConversionSample','epsc');
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
ylabel('Latitude [$^\circ N$]','fontsize',18);
xlabel('Longtitude [$^\circ W$]','fontsize',18);
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
box on;
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
set(gca,'XTick',[-121.92,-121.87,-121.82]);
set(gca,'XTickLabel',{'-121.92','-121.87','-121.82'});
set(gca,'TickLength',[0.02,0.03]);
AX1=gca;
AX1.LineWidth=0.8;
annotation('arrow',[0.61625 0.67],[0.619 0.8367],'Color',[0.851 0.3255 0.098],'LineWidth',3,'HeadSize',15);
annotation('textbox',[0.54625 0.581666666666667 0.05025 0.04],'String',{'HMS'},'FitBoxToText','off','EdgeColor','non');
annotation('ellipse',[0.59875 0.605 0.01 0.01],'FaceColor',[0 0 0]);
annotation('line',[0.67 0.8775],[0.835 0.455],'LineWidth',2,'LineStyle','--');
annotation('line',[0.61375 0.55125],[0.61833 0.4467],'LineWidth',2,'LineStyle','--');

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
plot(45.2-XFine/1000,-movmean(BathymetryDiff,20),'Color',[0 0.45 0.74],'LineStyle','-','LineWidth',2);
set(gca,'YTick',[0.01:0.02:0.08]);
set(gca,'fontsize',16);
xlabel('Offshore distance $[km]$','fontsize',18);
ylabel('Slope $[m.m^{-1}]$','fontsize',18);
set(gca,'FontWeight','bold');

FIG.Color='white';
fig = gcf;
fig.InvertHardcopy = 'off';
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\Monterey');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\Monterey','png');
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
text(0.12,1.35,'$c$','Interpreter','latex','Fontsize',24);
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
text(-8.95,30,'$b$','Interpreter','latex','Fontsize',24);
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
MargineRight=0.10;
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
text(152.5,1,'$e$','Interpreter','latex','Fontsize',24);

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\TideWindRecords');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\TideWindRecords','epsc');
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
ax2.XColor=[0 0.45 .74];
set(gca,'YTickLabel','');
line(x2,y2,'Parent',ax2,'Color',[0 0.45 0.74],'LineStyle','-','LineWidth',2);
ylim([-75 0]);
set(gca,'fontsize',16);
MyYLabel=ylabel('z $[m]$','fontsize',18);
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

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\DensityBathymetry');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\DensityBathymetry','epsc');
%%
%Figure 5- Conversion at different pycno and with different initial phase
%clear all;
close all;
FIG=figure('position',[100 100 600 600]);

% counter=1;
% TotalConversion=[];
% EpsilonAvg=[];
% for j=[80,87,45]
%     for i=0:6
%         Address=strcat('G:\Paper2-NewSet\Result-',num2str(j+i+110000),'.mat');
%         load(Address,'X','ZC','RhoBConventional','ConversionConventionalTimeAvrWBar','ConversionConventionalTimeAvrDepthIntWBar');
% 
%         Dx=diff(X,1);
%         Dx(end+1)=Dx(end);
%         ConversionStartPoint=cumsum(Dx.*ConversionConventionalTimeAvrDepthIntWBar);
%         ConversionStartPoint=ConversionStartPoint/ConversionStartPoint(end);
%         ConversionStartPoint=find(ConversionStartPoint<0,1,'last');
% 
%         RhoBConventional=squeeze(RhoBConventional(ConversionStartPoint:end,:,1));
%         X=X(ConversionStartPoint:end);
%         ConversionConventionalTimeAvrDepthIntWBar=ConversionConventionalTimeAvrDepthIntWBar(ConversionStartPoint:end);
%         ConversionConventionalTimeAvrWBar=ConversionConventionalTimeAvrWBar(ConversionStartPoint:end,:);
% 
%         Topo=RhoBConventional*0+repmat(ZC,1,size(X,1))';
%         Topo=nanmin(Topo,[],2);
% 
%         N=sqrt(abs(diff(RhoBConventional,1,2)./diff(repmat(ZC,1,size(X,1))',1,2)*9.8/1000));
%         N(:,end+1)=N(:,end);
%         N(isnan(N))=0;
%         N=trapz(ZC,N,2)./Topo;
% 
%         Topo=diff(Topo)./diff(X);
%         Topo(end+1)=Topo(end);
%         Topo=movmean(Topo,5);
% 
%         Omega=2*pi/12.4/3600;
%         f=0.8e-4;
%         IWEpsilon=sqrt(Omega^2-f^2)./sqrt(N.^2-Omega^2);
%         IWEpsilon(~isreal(IWEpsilon))=nan;
%         Epsilon=Topo./IWEpsilon;
%         Epsilon(isnan(Epsilon))=0;
%         EpsilonAvg(end+1)=trapz(X,Epsilon.*ConversionConventionalTimeAvrDepthIntWBar)/trapz(X,ConversionConventionalTimeAvrDepthIntWBar)
%         TotalConversion(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar)
%     end
% end
% 
% Address=strcat('G:\Paper2-NewSet\Result-',num2str(110086),'.mat');
% load(Address,'X','ZC','ConversionConventionalTimeAvrWBar');
% Depth=repmat(ZC,1,size(X,1))'+ConversionConventionalTimeAvrWBar*0;
% Depth=nanmin(Depth,[],2);
% Slope=diff(Depth)./diff(X);
% Epsion2=[];
% Epsilon2Counter=1;
% for j=[0,35,42]
%     for i=1:7
%         Address=strcat('G:\Paper2-NewSet\Result-',num2str(j+i+110044),'.mat');load(Address,'X','ZC','Time','U','ConversionConventionalTimeAvrDepthIntWBar');
%         [~,XIndex]=max(movmean(ConversionConventionalTimeAvrDepthIntWBar,2));
%         U0=max(nanmean(U(XIndex,:,:),2));
%         d=-Depth(XIndex);
%         h0=75-d;
%         Kb=Slope(XIndex)/h0;
%         if j==0
%             Epsion2(Epsilon2Counter)=U0*Kb/(2*3.1415/23.9/3600)
%         elseif j==35
%             Epsion2(Epsilon2Counter)=U0*Kb/(2*3.1415/12.4/3600)            
%         else
%             Epsion2(Epsilon2Counter)=U0*Kb/(2*3.1415/23.9/3600)
%         end
%         Epsilon2Counter=Epsilon2Counter+1;
%     end
% end

MargineTop=0.05;
MargineBot=0.44;
MargineLeft=0.16;
MargineRight=0.12;
SubplotSpac=0.06;
SubplotNumber=2;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;

MyColor=[0.929 0.6941 0.1255;...
    0.85 0.325 0.098;...
    0 0.447 0.741];
MyStyle={'-p','-s','-d'};

for counter=1:3
    plot(5:2.5:20,EpsilonAvg((counter-1)*7+1:counter*7),MyStyle{counter},'MarkerFaceColor',MyColor(2,:),'Color',MyColor(2,:),'LineWidth',2);
end
ylim([5.2 8.3]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=5.5:0.25:8.5;
MyAxe.YAxis(1).TickValues=5.5:0.5:8.5;

MyLabel=ylabel('$\Gamma_1$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-2.7 LabelPos(2)];

yyaxis right
for counter=[2,3,1]
    plot(5:2.5:20,Epsion2((counter-1)*7+1:counter*7),MyStyle{counter},'MarkerFaceColor',MyColor(3,:),'Color',MyColor(3,:),'LineWidth',2);
end

MyLabel=ylabel('$\Gamma_2$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)+2.2 LabelPos(2)+0.1];
ylim([0 0.6]);
MyAxe=gca;
MyAxe.YAxis(2).MinorTick='on';
MyAxe.YAxis(2).MinorTickValues=0:0.05:0.6;
MyAxe.YAxis(2).TickValues=0:0.3:0.6;

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
box on;
xlim([4 21.2])
set(gca,'XTick',0:2.5:20);
set(gca,'XTickLabel','');

MyAxe=gca;
MyAxe.YAxis(1).Color=MyColor(2,:);
MyAxe.YAxis(2).Color=MyColor(3,:);
text(4.3,0.5,'$a$','fontsize',24,'Color','black');


SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;

plot(nan,nan,'--p','MarkerEdgeColor','black','MarkerFaceColor','black','Color','white');
plot(nan,nan,'--s','MarkerEdgeColor','black','MarkerFaceColor','black','Color','white');
plot(nan,nan,'--d','MarkerEdgeColor','black','MarkerFaceColor','black','Color','white');

hold on;
for counter=1:3
    plot(5:2.5:20,TotalConversion((counter-1)*7+1:counter*7),MyStyle{counter},'MarkerFaceColor','black','Color','black','LineWidth',2);
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
[lgd,objh]=legend('$M_2$','$K_1$','$M_2K_1$','Interpreter','latex','FontSize',16,'Location','northoutside','Orientation','horizontal');
objhl = findobj(objh, 'type', 'line'); %// objects of legend of type line
set(objhl, 'Markersize', 8); %// set marker size as desired
POS=lgd.Position;
lgd.Position=[LGDPositio(1) LGDPositio(2)+0.287 LGDPositio(3) LGDPositio(4)];
lgd.FontSize=13;
xlim([4 21.2])
set(gca,'XTick',0:2.5:20);
set(gca,'XTickLabel','');
text(4.3,1.4,'$b$','fontsize',24,'Color','black');

MargineTop=0.57;
MargineBot=0.12;
MargineLeft=0.16;
MargineRight=0.12;
SubplotSpac=0.05;
SubplotNumber=1;

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
        Address=strcat('G:\Paper2-NewSet\Result-',num2str(i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(CatCounter,CaseCounter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(CatCounter,CaseCounter)=i;
        CaseCounter=CaseCounter+1;
    end
    CatCounter=CatCounter+1;
end
CaseValue(:,4)=CaseValue(:,1)-CaseValue(:,2)-CaseValue(:,3);
bar([5:2.5:20],CaseValue);
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
ylim([-0.3 1.8]);
lgd=legend('$M_2+K_1$','$M_2$','$K_1$','NTT','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1) LGDPositio(2)-0.01 LGDPositio(3) LGDPositio(4)];
MyAxe=gca;
MyAxe.XAxisLocation='bottom';
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-0.5:0.1:1.5;
MyAxe.YAxis(1).TickValues=-0.5:0.5:1.5;
MyLabel=ylabel('$\widehat{\langle\overline{C}\rangle}$ $[W.m^{-1}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-.2 LabelPos(2) -1];
MyLabel=xlabel('Pycnocline Depth [$m$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.05];
box on;
text(4.3,1.50,'$c$','fontsize',24,'Color','black');
set(gca,'XTick',[5:2.5:20]);
xlim([4 21.227]);
box on;

text(5+0.1,1.1,num2str(CaseValue(1,2)/CaseValue(1,1)*100,3),'fontsize',14,'Color',[0.85 0.33 0.1]);
text(7.5+0.1,1.1,num2str(CaseValue(2,2)/CaseValue(2,1)*100,2),'fontsize',14,'Color',[0.85 0.33 0.1]);
text(10+0.1,1.1,num2str(CaseValue(3,2)/CaseValue(3,1)*100,2),'fontsize',14,'Color',[0.85 0.33 0.1]);
text(12.5+0.1,1.1,num2str(CaseValue(4,2)/CaseValue(4,1)*100,2),'fontsize',14,'Color',[0.85 0.33 0.1]);
text(15+0.1,1.1,num2str(CaseValue(5,2)/CaseValue(5,1)*100,2),'fontsize',14,'Color',[0.85 0.33 0.1]);
text(17.5+0.1,1.1,num2str(CaseValue(6,2)/CaseValue(6,1)*100,2),'fontsize',14,'Color',[0.85 0.33 0.1]);
text(20+0.1,1.1,num2str(CaseValue(7,2)/CaseValue(7,1)*100,2),'fontsize',14,'Color',[0.85 0.33 0.1]);

text(5+0.1,0.8,num2str(CaseValue(1,3)/CaseValue(1,1)*100,2),'fontsize',14,'Color',[0.93 0.69 0.13]);
text(7.5+0.1,0.8,num2str(CaseValue(2,3)/CaseValue(2,1)*100,2),'fontsize',14,'Color',[0.93 0.69 0.13]);
text(10+0.1,0.8,num2str(CaseValue(3,3)/CaseValue(3,1)*100,2),'fontsize',14,'Color',[0.93 0.69 0.13]);
text(12.5+0.1,0.8,num2str(CaseValue(4,3)/CaseValue(4,1)*100,2),'fontsize',14,'Color',[0.93 0.69 0.13]);
text(15+0.1,0.8,num2str(CaseValue(5,3)/CaseValue(5,1)*100,2),'fontsize',14,'Color',[0.93 0.69 0.13]);
text(17.5+0.1,0.8,num2str(CaseValue(6,3)/CaseValue(6,1)*100,2),'fontsize',14,'Color',[0.93 0.69 0.13]);
text(20+0.1,0.8,num2str(CaseValue(7,3)/CaseValue(7,1)*100,2),'fontsize',14,'Color',[0.93 0.69 0.13]);

text(5+0.1,0.5,num2str(CaseValue(1,4)/CaseValue(1,1)*100,2),'fontsize',14,'Color',[0.49 0.18 0.56]);
text(7.5+0.1,0.5,num2str(CaseValue(2,4)/CaseValue(2,1)*100,2),'fontsize',14,'Color',[0.49 0.18 0.56]);
text(10+0.1,0.5,num2str(CaseValue(3,4)/CaseValue(3,1)*100,2),'fontsize',14,'Color',[0.49 0.18 0.56]);
text(12.5+0.1,0.5,num2str(CaseValue(4,4)/CaseValue(4,1)*100,2),'fontsize',14,'Color',[0.49 0.18 0.56]);
text(15+0.1,0.5,num2str(CaseValue(5,4)/CaseValue(5,1)*100,1),'fontsize',14,'Color',[0.49 0.18 0.56]);
text(17.5+0.1,0.5,num2str(CaseValue(6,4)/CaseValue(6,1)*100,2),'fontsize',14,'Color',[0.49 0.18 0.56]);
text(20+0.1,0.5,num2str(CaseValue(7,4)/CaseValue(7,1)*100,2),'fontsize',14,'Color',[0.49 0.18 0.56]);

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\ConversionPycnoDepth');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\ConversionPycnoDepth','epsc');
%%
%Figure 6- Details of Conversion
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

Address='F:\Sorush\Paper2\Results-110045.mat';
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

    Address=strcat('F:\Sorush\Paper2\Results-1100',num2str(45+(3-counter)),'.mat');
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

    Address=strcat('F:\Sorush\Paper2\Results-1100',num2str(48+(4-counter)),'.mat');
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

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\PycnoDetailedConversion');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\PycnoDetailedConversion','epsc');
%%
%Figure 7- Conversion at different pycno and with different initial phase
clear all;
close all;
FIG=figure('position',[100 100 600 500]);

MargineTop=0.08;
MargineBot=0.2;
MargineLeft=0.16;
MargineRight=0.05;
SubplotSpac=0;
SubplotNumber=1;
SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
StyleCounter=1;
MyStyle={'--h',':p','-.s'};
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
    plot([-54:30:96,124],CaseValue,MyStyle{StyleCounter},'LineWidth',2,'MarkerSize',14,'MarkerSize',8);
    StyleCounter=StyleCounter+1;
end
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
lgd=legend('7.5 m','12.5 m','17.5 m','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1) LGDPositio(2)+0.07 LGDPositio(3) LGDPositio(4)];
ylim([0.52 1.3]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=0.5:0.05:1.4;
MyAxe.YAxis(1).TickValues=0.6:0.3:1.4;
xlim([-54 124]);
set(gca,'XTick',[-54:30:96,124]);
xlabel('$\overbrace{M_2,K_1}$ [$^\circ$]','fontsize',18);
box on;
lgd.FontSize=14;
MyLabel=ylabel('$\widehat{\langle\overline{C} \rangle}$ [$W.m^{-1}$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-4 LabelPos(2) -1];

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\ConversionTidalLag');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\ConversionTidalLag','epsc');
%%
%Figure 8- Profiles and TimeSeries in the presence of wind
% clear all;
%close all;
FIG=figure('position',[100 300 1000 600]);

XIndex=475;
ZIndex=29;
TimeRange=3156+287;
TimeIndex=540;

CaseNumber=1;
Data=cell(4,1);
for counter=[110026 110021 110023]
    Address=strcat('G:\Paper2-NewSet\Result-',num2str(counter),'.mat');
    Data{CaseNumber}=load(Address,'WBar','Eta','RhoPrimeConventional','U','W','ConversionConventionalWBar');
    Data{CaseNumber}.W=Data{CaseNumber}.W(:,:,TimeRange:end);
    Data{CaseNumber}.WBar=Data{CaseNumber}.WBar(:,:,TimeRange:end);
    Data{CaseNumber}.ConversionConventionalWBar=Data{CaseNumber}.ConversionConventionalWBar(:,:,TimeRange:end);
    Data{CaseNumber}.Eta=Data{CaseNumber}.Eta(:,TimeRange:end);
    Data{CaseNumber}.RhoPrimeConventional=Data{CaseNumber}.RhoPrimeConventional(:,:,TimeRange:end);
    Data{CaseNumber}.U=Data{CaseNumber}.U(:,:,TimeRange:end);
    CaseNumber=CaseNumber+1;
end

Address=strcat('G:\Paper2-NewSet\Result-',num2str(110088),'.mat');
Data{CaseNumber}=load(Address,'WBar','Eta','RhoPrimeConventional','U','W','ConversionConventionalWBar');
Data{CaseNumber}.W=Data{CaseNumber}.W(:,:,TimeRange-86:end-86);
Data{CaseNumber}.WBar=Data{CaseNumber}.WBar(:,:,TimeRange-86:end-86);
Data{CaseNumber}.ConversionConventionalWBar=Data{CaseNumber}.ConversionConventionalWBar(:,:,TimeRange-86:end-86);
Data{CaseNumber}.Eta=Data{CaseNumber}.Eta(:,TimeRange-86:end-86);
Data{CaseNumber}.RhoPrimeConventional=Data{CaseNumber}.RhoPrimeConventional(:,:,TimeRange-86:end-86);
Data{CaseNumber}.U=Data{CaseNumber}.U(:,:,TimeRange-86:end-86);
CaseNumber=CaseNumber+1;

load(Address,'X','ZC','Time');
Time=Time(TimeRange:end);
Depth=repmat(ZC,1,size(X,1))'+squeeze(Data{1}.U(:,:,1))*0;
Depth=nanmin(Depth,[],2);

for counter=1:4
    Data{counter}.UBar=Data{counter}.U;
    Data{counter}.UBar(isnan(Data{counter}.UBar))=0;
    Data{counter}.UBar=-repmat(trapz(-ZC,Data{counter}.UBar,2),1,size(ZC,1),1)./repmat(Depth,1,size(ZC,1),size(Time,1));
    Data{counter}.Uprime=Data{counter}.U-Data{counter}.UBar;
end

for counter=1:4
    Data{counter}.RhoPrimeConventional=Data{counter}.RhoPrimeConventional-repmat(nanmean(Data{counter}.RhoPrimeConventional,3),1,1,size(Time,1)); 
end

Data{1}.PhaseLag=102;
Data{2}.PhaseLag=312;
Data{3}.PhaseLag=12;

MargineTop=0.07;
MargineBot=0.15;
MargineLeft=0.12;
MargineRight=0.6;
SubplotSpac=0.02;
SubplotNumber=5;

SubplotCounter=5;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
WindPeriod=24*3600;
WindOmega=2*pi/WindPeriod;
DataPhaseLag=0;

plot(Time/23.9/3600,6*(1+sin(WindOmega*(Time-(360-Data{1}.PhaseLag)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-');
plot(Time/23.9/3600,6*(1+sin(WindOmega*(Time-(360-Data{2}.PhaseLag)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-');
plot(Time/23.9/3600,6*(1+sin(WindOmega*(Time-(360-Data{3}.PhaseLag)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-');

scatter(Time(257)/3600/23.9,6,100,'p','filled','MarkerEdgeColor',[0 0.45 0.74],'MarkerFaceColor',[0 0.45 0.74]);
scatter(Time(377)/3600/23.9,6,100,'p','filled','MarkerEdgeColor',[0.85 0.33 0.1],'MarkerFaceColor',[0.85 0.33 0.10]);
scatter(Time(329)/3600/23.9,6,100,'p','filled','MarkerEdgeColor',[0.93 0.69 0.13],'MarkerFaceColor',[0.93 0.69 0.13]);

axis([16.12 18.12 -0.5 6.5]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=0:03:6;
MyAxe.YAxis.MinorTickValues=0:1:6;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=16.5:0.5:18;
MyAxe.XAxis.MinorTickValues=16:0.25:18;

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$Wind$';'$[m.s^{-1}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.25 LabelPos(2)];
text(16.2,0.8,'$a$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=4;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(Time/23.9/3600,100*squeeze(Data{1}.Eta(XIndex,:)),'LineWidth',2,'LineStyle','-');
plot(Time/23.9/3600,100*squeeze(Data{2}.Eta(XIndex,:)),'LineWidth',2,'LineStyle','--');
plot(Time/23.9/3600,100*squeeze(Data{3}.Eta(XIndex,:)),'LineWidth',2,'LineStyle','-.');
plot(Time/23.9/3600,100*squeeze(Data{4}.Eta(XIndex,:)),'LineWidth',2,'LineStyle',':');
line([16.12 18.12],[0 0],'LineWidth',1,'LineStyle',':','Color','black');

scatter(Time(288)/3600/23.9,0,100,'p','filled','MarkerEdgeColor',[0.49 0.18 0.56],'MarkerFaceColor',[0.49 0.18 0.56]);

axis([16.12 18.12 -50 50]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-40:40:40;
MyAxe.YAxis.MinorTickValues=-40:20:40;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=16.5:0.5:18;
MyAxe.XAxis.MinorTickValues=16:0.25:18;

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$\eta$';'$[cm]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.13 LabelPos(2)];
text(16.2,-32,'$b$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'XTickLabel','');

plot(Time/23.9/3600,1e3*squeeze(Data{1}.WBar(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/23.9/3600,1e3*squeeze(Data{2}.WBar(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/23.9/3600,1e3*squeeze(Data{3}.WBar(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/23.9/3600,1e3*squeeze(Data{4}.WBar(XIndex,ZIndex,:)),'LineWidth',2);
line([16.12 18.12],[0 0],'LineWidth',1,'LineStyle',':','Color','black');

axis([16.12 18.12 -0.40 0.40]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.3:0.3:0.3;
MyAxe.YAxis.MinorTickValues=-0.4:0.10:0.4;
 
MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=16.5:0.5:18;
MyAxe.XAxis.MinorTickValues=16:0.25:18;

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$W_{BT}$';'$[mm.s^{-1}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.07 LabelPos(2)];
text(16.2,-0.27,'$c$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

plot(Time/23.9/3600,squeeze(Data{1}.RhoPrimeConventional(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/23.9/3600,squeeze(Data{2}.RhoPrimeConventional(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/23.9/3600,squeeze(Data{3}.RhoPrimeConventional(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/23.9/3600,squeeze(Data{4}.RhoPrimeConventional(XIndex,ZIndex,:)),'LineWidth',2);
line([16.12 18.12],[0 0],'LineWidth',1,'LineStyle',':','Color','black');

axis([16.12 18.12 -0.25 0.25]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.20:0.20:0.20;
MyAxe.YAxis.MinorTickValues=-0.25:0.05:0.25;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=16.5:0.5:18;
MyAxe.XAxis.MinorTickValues=16:0.25:18;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$\rho''$';'$[kg.m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.06 LabelPos(2)];
text(16.2,-0.18,'$d$','fontsize',24,'Color','black','BackgroundColor','none');


SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

plot(Time/23.9/3600,10^3*squeeze(Data{1}.ConversionConventionalWBar(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/23.9/3600,10^3*squeeze(Data{2}.ConversionConventionalWBar(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/23.9/3600,10^3*squeeze(Data{3}.ConversionConventionalWBar(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/23.9/3600,10^3*squeeze(Data{4}.ConversionConventionalWBar(XIndex,ZIndex,:)),'LineWidth',2);
line([16.12 18.12],[0 0],'LineWidth',1,'LineStyle',':','Color','black');

axis([16.12 18.12 -0.4 0.8]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.2:0.4:0.6;
MyAxe.YAxis.MinorTickValues=-0.4:0.2:0.8;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=16.5:0.5:18;
MyAxe.XAxis.MinorTickValues=16:0.25:18;

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$\frac{t}{T}$','fontsize',28);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.1];

MyYLabel=ylabel({'$C$';'$[mW.m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.06 LabelPos(2)];
text(16.2,0.6,'$e$','fontsize',24,'Color','black','BackgroundColor','none');


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

plot(1000*squeeze(Data{1}.W(XIndex,:,257)),ZC,'LineWidth',2);
plot(1000*squeeze(Data{2}.W(XIndex,:,377)),ZC,'LineWidth',2);
plot(1000*squeeze(Data{3}.W(XIndex,:,329)),ZC,'LineWidth',2);
plot(1000*squeeze(Data{4}.W(XIndex,:,288)),ZC,'LineWidth',2);
line([0 0],[-12 -1],'LineWidth',1,'LineStyle',':','Color','black');

axis([-1.3 0.3 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-1:1:1;
MyAxe.XAxis.MinorTickValues=-1.25:0.25:0.5;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$w$ $[cm.s^{-1}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];

lgd=legend('$66^\circ$','$-84^\circ$','$-24^\circ$','No Wind','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1)+0.08 LGDPositio(2)+0.055 LGDPositio(3) LGDPositio(4)];
text(-1.2,-1.7,'$f$','fontsize',24,'Color','black','BackgroundColor','none');

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

plot(100*squeeze(Data{1}.Uprime(XIndex,:,257)),ZC,'LineWidth',2);
plot(100*squeeze(Data{2}.Uprime(XIndex,:,377)),ZC,'LineWidth',2);
plot(100*squeeze(Data{3}.Uprime(XIndex,:,329)),ZC,'LineWidth',2);
plot(100*squeeze(Data{4}.Uprime(XIndex,:,288)),ZC,'LineWidth',2);
line([0 0],[-12 -1],'LineWidth',1,'LineStyle',':','Color','black');

axis([-2.3 2.3 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;
MyAxe.YAxis.TickLabels='';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-1:1:1;
MyAxe.XAxis.MinorTickValues=-2:0.5:2;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$u''$ $[cm.s^{-1}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];
text(-1.9,-1.7,'$g$','fontsize',24,'Color','black');

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

plot(1000*squeeze(nanmean(Data{1}.ConversionConventionalWBar(XIndex,:,:),3)),ZC,'LineWidth',2);
plot(1000*squeeze(nanmean(Data{2}.ConversionConventionalWBar(XIndex,:,:),3)),ZC,'LineWidth',2);
plot(1000*squeeze(nanmean(Data{3}.ConversionConventionalWBar(XIndex,:,:),3)),ZC,'LineWidth',2);
plot(1000*squeeze(nanmean(Data{4}.ConversionConventionalWBar(XIndex,:,:),3)),ZC,'LineWidth',2);
line([0 0],[-12 -1],'LineWidth',1,'LineStyle',':','Color','black');

axis([-0.5 0.5 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;
MyAxe.YAxis.TickLabels='';
MyAxe.YAxisLocation='right'

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-0.4:0.4:0.4;
MyAxe.XAxis.MinorTickValues=-0.5:0.1:0.5;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$z$ $[m]$'},'fontsize',20);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)+0.1 LabelPos(2)];

MyLabel=xlabel('$\overline{C}$ $[mW.m^{-3}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];
text(-0.4,-1.7,'$h$','fontsize',24,'Color','black');

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\WindStructureK1');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\WindStructureK1','epsc');

%%
%Figure 9- Profiles and TimeSeries in the presence of wind
% clear all;
close all;
FIG=figure('position',[100 300 1000 600]);

XIndex=475;
ZIndex=21;
TimeRange=3156+230;
TimeIndex=540;

% CaseNumber=1;
% Data=cell(4,1);
% for counter=[110016 110014 110015 110081]
%     Address=strcat('G:\Paper2-NewSet\Result-',num2str(counter),'.mat');
%     Data{CaseNumber}=load(Address,'WBar','Eta','RhoPrimeConventional','U','W','ConversionConventionalWBar');
%     Data{CaseNumber}.W=Data{CaseNumber}.W(:,:,TimeRange:end);
%     Data{CaseNumber}.WBar=Data{CaseNumber}.WBar(:,:,TimeRange:end);
%     Data{CaseNumber}.ConversionConventionalWBar=Data{CaseNumber}.ConversionConventionalWBar(:,:,TimeRange:end);
%     Data{CaseNumber}.Eta=Data{CaseNumber}.Eta(:,TimeRange:end);
%     Data{CaseNumber}.RhoPrimeConventional=Data{CaseNumber}.RhoPrimeConventional(:,:,TimeRange:end);
%     Data{CaseNumber}.U=Data{CaseNumber}.U(:,:,TimeRange:end);
%     CaseNumber=CaseNumber+1;
% end
% 
% load(Address,'X','ZC','Time');
% Time=Time(TimeRange:end);
% Depth=repmat(ZC,1,size(X,1))'+squeeze(Data{1}.U(:,:,1))*0;
% Depth=nanmin(Depth,[],2);
% 
% for counter=1:4
%     Data{counter}.UBar=Data{counter}.U;
%     Data{counter}.UBar(isnan(Data{counter}.UBar))=0;
%     Data{counter}.UBar=-repmat(trapz(-ZC,Data{counter}.UBar,2),1,size(ZC,1),1)./repmat(Depth,1,size(ZC,1),size(Time,1));
%     Data{counter}.Uprime=Data{counter}.U-Data{counter}.UBar;
% end
% 
% for counter=1:4
%     Data{counter}.RhoPrimeConventional=Data{counter}.RhoPrimeConventional-repmat(nanmean(Data{counter}.RhoPrimeConventional,3),1,1,size(Time,1)); 
% end
% 
% Data{1}.PhaseLag=12;
% Data{2}.PhaseLag=342;
% Data{3}.PhaseLag=312;

MargineTop=0.07;
MargineBot=0.15;
MargineLeft=0.12;
MargineRight=0.6;
SubplotSpac=0.02;
SubplotNumber=5;

SubplotCounter=5;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
WindPeriod=24*3600;
WindOmega=2*pi/WindPeriod;
DataPhaseLag=0;

plot(Time/12.4/3600,6*(1+sin(WindOmega*(Time-(360-Data{1}.PhaseLag)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-');
plot(Time/12.4/3600,6*(1+sin(WindOmega*(Time-(360-Data{2}.PhaseLag)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-');
plot(Time/12.4/3600,6*(1+sin(WindOmega*(Time-(360-Data{3}.PhaseLag)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-');

scatter(Time(387)/3600/12.4,6,100,'p','filled','MarkerEdgeColor',[0 0.45 0.74],'MarkerFaceColor',[0 0.45 0.74]);
scatter(Time(411)/3600/12.4,6,100,'p','filled','MarkerEdgeColor',[0.85 0.33 0.1],'MarkerFaceColor',[0.85 0.33 0.10]);
scatter(Time(435)/3600/12.4,6,100,'p','filled','MarkerEdgeColor',[0.93 0.69 0.13],'MarkerFaceColor',[0.93 0.69 0.13]);

axis([31 35 -0.5 6.5]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=0:03:6;
MyAxe.YAxis.MinorTickValues=0:1:6;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=31:1:35;
MyAxe.XAxis.MinorTickValues=31:0.25:35;

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$Wind$';'$[m.s^{-1}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.25 LabelPos(2)];
text(31.2,0.8,'$a$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=4;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(Time/12.4/3600,100*squeeze(Data{1}.Eta(XIndex,:)),'LineWidth',2,'LineStyle','-');
plot(Time/12.4/3600,100*squeeze(Data{2}.Eta(XIndex,:)),'LineWidth',2,'LineStyle','--');
plot(Time/12.4/3600,100*squeeze(Data{3}.Eta(XIndex,:)),'LineWidth',2,'LineStyle','-.');
plot(Time/12.4/3600,100*squeeze(Data{4}.Eta(XIndex,:)),'LineWidth',2,'LineStyle',':');
line([31 35],[0 0],'LineWidth',1,'LineStyle',':','Color','black');
scatter(Time(412)/3600/12.4,0,100,'p','filled','MarkerEdgeColor',[0.49 0.18 0.56],'MarkerFaceColor',[0.49 0.18 0.56]);

axis([31 35 -60 60]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-50:50:50;
MyAxe.YAxis.MinorTickValues=-50:10:50;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=31:1:35;
MyAxe.XAxis.MinorTickValues=31:0.25:35;

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$\eta$';'$[cm]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.13 LabelPos(2)];
text(31.2,-32,'$b$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'XTickLabel','');

plot(Time/12.4/3600,1e3*squeeze(Data{1}.WBar(XIndex,ZIndex,:)),'--','LineWidth',2);
plot(Time/12.4/3600,1e3*squeeze(Data{2}.WBar(XIndex,ZIndex,:)),':','LineWidth',2);
plot(Time/12.4/3600,1e3*squeeze(Data{3}.WBar(XIndex,ZIndex,:)),'-.','LineWidth',2);
plot(Time/12.4/3600,1e3*squeeze(Data{4}.WBar(XIndex,ZIndex,:)),':','LineWidth',2);
line([31 35],[0 0],'LineWidth',1,'LineStyle',':','Color','black');

axis([31 35 -0.8 0.8]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.6:0.6:0.6;
MyAxe.YAxis.MinorTickValues=-1.2:0.20:1.2;
 
MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=31:1:35;
MyAxe.XAxis.MinorTickValues=31:0.25:35;

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$W_{BT}$';'$[mm.s^{-1}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.07 LabelPos(2)];
text(31.15,-0.5,'$c$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

plot(Time/12.4/3600,squeeze(Data{1}.RhoPrimeConventional(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/12.4/3600,squeeze(Data{2}.RhoPrimeConventional(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/12.4/3600,squeeze(Data{3}.RhoPrimeConventional(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/12.4/3600,squeeze(Data{4}.RhoPrimeConventional(XIndex,ZIndex,:)),'LineWidth',2);
line([31 35],[0 0],'LineWidth',1,'LineStyle',':','Color','black');

axis([31 35 -0.25 0.25]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.20:0.20:0.20;
MyAxe.YAxis.MinorTickValues=-0.25:0.05:0.25;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=31:1:35;
MyAxe.XAxis.MinorTickValues=31:0.25:35;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$\rho''$';'$[kg.m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.08 LabelPos(2)];
text(31.2,-0.15,'$d$','fontsize',24,'Color','black','BackgroundColor','none');


SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

plot(Time/12.4/3600,10^3*squeeze(Data{1}.ConversionConventionalWBar(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/12.4/3600,10^3*squeeze(Data{2}.ConversionConventionalWBar(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/12.4/3600,10^3*squeeze(Data{3}.ConversionConventionalWBar(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/12.4/3600,10^3*squeeze(Data{4}.ConversionConventionalWBar(XIndex,ZIndex,:)),'LineWidth',2);
line([31 35],[0 0],'LineWidth',1,'LineStyle',':','Color','black');

axis([31 35 -0.7 1.4]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.6:0.6:1.2;
MyAxe.YAxis.MinorTickValues=-0.6:0.3:1.2;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=31:1:35;
MyAxe.XAxis.MinorTickValues=31:0.25:35;

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$\frac{t}{T}$','fontsize',28);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.1];

MyYLabel=ylabel({'$C$';'$[mW.m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.03 LabelPos(2)];
text(31.2,1,'$e$','fontsize',24,'Color','black','BackgroundColor','none');


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

plot(1000*squeeze(Data{1}.W(XIndex,:,387)),ZC,'LineWidth',2);
plot(1000*squeeze(Data{2}.W(XIndex,:,411)),ZC,'LineWidth',2);
plot(1000*squeeze(Data{3}.W(XIndex,:,435)),ZC,'LineWidth',2);
plot(1000*squeeze(Data{4}.W(XIndex,:,412)),ZC,'LineWidth',2);
line([0 0],[-12 -1],'LineWidth',1,'LineStyle',':','Color','black');

axis([-1.8 0.3 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-1:1:1;
MyAxe.XAxis.MinorTickValues=-1.8:0.2:0.2;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$w$ $[cm.s^{-1}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];

lgd=legend('$-78^\circ$','$-108^\circ$','$-138^\circ$','No Wind','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1)+0.08 LGDPositio(2)+0.055 LGDPositio(3) LGDPositio(4)];
text(-1.6,-1.7,'$f$','fontsize',24,'Color','black','BackgroundColor','none');

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

plot(100*squeeze(Data{1}.Uprime(XIndex,:,387)),ZC,'LineWidth',2);
plot(100*squeeze(Data{2}.Uprime(XIndex,:,411)),ZC,'LineWidth',2);
plot(100*squeeze(Data{3}.Uprime(XIndex,:,435)),ZC,'LineWidth',2);
plot(100*squeeze(Data{4}.Uprime(XIndex,:,412)),ZC,'LineWidth',2);
line([0 0],[-12 -1],'LineWidth',1,'LineStyle',':','Color','black');

axis([-2.3 2.3 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;
MyAxe.YAxis.TickLabels='';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-1:1:1;
MyAxe.XAxis.MinorTickValues=-2:0.5:2;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$u''$ $[cm.s^{-1}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];
text(-1.9,-1.7,'$g$','fontsize',24,'Color','black');

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

plot(1000*squeeze(nanmean(Data{1}.ConversionConventionalWBar(XIndex,:,:),3)),ZC,'LineWidth',2);
plot(1000*squeeze(nanmean(Data{2}.ConversionConventionalWBar(XIndex,:,:),3)),ZC,'LineWidth',2);
plot(1000*squeeze(nanmean(Data{3}.ConversionConventionalWBar(XIndex,:,:),3)),ZC,'LineWidth',2);
plot(1000*squeeze(nanmean(Data{4}.ConversionConventionalWBar(XIndex,:,:),3)),ZC,'LineWidth',2);
line([0 0],[-12 -1],'LineWidth',1,'LineStyle',':','Color','black');

axis([-0.5 0.5 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;
MyAxe.YAxis.TickLabels='';
MyAxe.YAxisLocation='right'

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-0.4:0.4:0.4;
MyAxe.XAxis.MinorTickValues=-0.5:0.1:0.5;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$z$ $[m]$'},'fontsize',20);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)+0.1 LabelPos(2)];

MyLabel=xlabel('$\overline{C}$ $[mW.m^{-3}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];
text(-0.4,-1.7,'$h$','fontsize',24,'Color','black');

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\WindStructureM2');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\WindStructureM2','epsc');
%%
%Figure 10- Conversion at different wind lag
clear all;
clc
close all;
FIG=figure('position',[100 100 800 800]);

MargineTop=0.06;
MargineBot=0.14;
MargineLeft=0.12;
MargineRight=0.64;
SubplotSpac=0.02;
SubplotNumber=3;

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('G:\Paper2-NewSet\Result-110000.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%M2K1 7.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    for i=147:158%M2K1 7.5 m and 3 to 6 wind
        Address=strcat('G:\Paper2-NewSet\Result-',num2str(j*12+i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([-48:30:282]-36,100*(CaseValue-Baseline)/Baseline,'-s','LineWidth',2,'MarkerSize',6);
end
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-90 250 -63 160]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-60:10:160;
MyAxe.YAxis(1).TickValues=-50:50:160;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-84:30:250;
MyAxe.XAxis.TickValues=-54:90:250;
set(gca,'XTickLabel','');
line([-90,250],[0 0],'LineStyle',':','color','black');
lgd=legend('$3$ $m.s^{-1}$','$6$ $m.s^{-1}$','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1)+0.05 LGDPositio(2)-0.88 LGDPositio(3) LGDPositio(4)];
lgd.FontSize=14;
text(66,140,'$a$','fontsize',24,'Color','black','background','none');
box on;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('G:\Paper2-NewSet\Result-110094.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%M2K1 12.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    for i=209:220%M2K1 12.5 m and 3 to 6 wind
        Address=strcat('G:\Paper2-NewSet\Result-',num2str(j*12+i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([-48:30:282]-36,100*(CaseValue-Baseline)/Baseline,'-s','LineWidth',2,'MarkerSize',6);
end
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-90 250 -120 80]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-120:10:80;
MyAxe.YAxis(1).TickValues=-100:50:80;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-84:30:250;
MyAxe.XAxis.TickValues=-54:90:250;
set(gca,'XTickLabel','');

line([-90,250],[0 0],'LineStyle',':','color','black');
text(66,55,'$b$','fontsize',24,'Color','black','background','none');
box on;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('G:\Paper2-NewSet\Result-110101.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%M2K1 17.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    for i=395:406%M2K1 17.5 m and 3 to 6 wind
        Address=strcat('G:\Paper2-NewSet\Result-',num2str(j*12+i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([-48:30:282]-36,100*(CaseValue-Baseline)/Baseline,'-s','LineWidth',2,'MarkerSize',6);
end
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-90 250 -90 90]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-90:10:90;
MyAxe.YAxis(1).TickValues=-50:50:50;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-84:30:250;
MyAxe.XAxis.TickValues=-54:90:250;
line([-90,250],[0 0],'LineStyle',':','color','black');
text(66,75,'$c$','fontsize',24,'Color','black','background','none');
box on;

MyLabel=ylabel('Conversion Rate Variation [$\%$]','fontsize',18);
MyLabel=ylabel('$\frac{\langle \widehat{\overline{C}}\rangle}{\langle \widehat{\overline{C_{Base}}}\rangle}$ [$\%$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-20 LabelPos(2)+1250];

MyLabel=xlabel('$\overbrace{Wind, Tide}$ [$^\circ$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)+100 LabelPos(2)-100];

%Middle
MargineLeft=0.42;
MargineRight=0.34;
SubplotNumber=3;

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('G:\Paper2-NewSet\Result-110088.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%K1 7.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,-1]
    CaseNumber=[];
    CaseValue=[];
    for i=33:44%K1 7.5 m and 3 to 6 wind
        Address=strcat('G:\Paper2-NewSet\Result-',num2str(j*12+i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([-48:30:282]-36,100*(CaseValue-Baseline)/Baseline,'-s','LineWidth',2,'MarkerSize',6);
end
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-90 250 -400 500]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-400:50:500;
MyAxe.YAxis(1).TickValues=-300:300:300;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-84:30:250;
MyAxe.XAxis.TickValues=-54:90:250;
set(gca,'XTickLabel','');
line([-90,250],[0 0],'LineStyle',':','color','black');
text(66,420,'$d$','fontsize',24,'Color','black','background','none');
box on;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('G:\Paper2-NewSet\Result-110090.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%K1 12.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    for i=185:196%K1 12.5 m and 3 to 6 wind
        Address=strcat('G:\Paper2-NewSet\Result-',num2str(j*12+i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([-48:30:282]-36,100*(CaseValue-Baseline)/Baseline,'-s','LineWidth',2,'MarkerSize',6);
end
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-90 250 -600 600]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-600:50:600;
MyAxe.YAxis(1).TickValues=-300:300:300;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-84:30:250;
MyAxe.XAxis.TickValues=-54:90:250;
set(gca,'XTickLabel','');

line([-90,250],[0 0],'LineStyle',':','color','black');
text(66,480,'$e$','fontsize',24,'Color','black','background','none');
box on;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('G:\Paper2-NewSet\Result-110092.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%K1 17.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    for i=371:382%K1 17.5 m and 3 to 6 wind
        Address=strcat('G:\Paper2-NewSet\Result-',num2str(j*12+i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([-48:30:282]-36,100*(CaseValue-Baseline)/Baseline,'-s','LineWidth',2,'MarkerSize',6);
end
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-90 250 -800 900]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-800:100:900;
MyAxe.YAxis(1).TickValues=-600:600:600;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-84:30:250;
MyAxe.XAxis.TickValues=-54:90:250;
line([-90,250],[0 0],'LineStyle',':','color','black');
text(66,750,'$f$','fontsize',24,'Color','black','background','none');
box on;

MyLabel=ylabel('Conversion Rate Variation [$\%$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-430 LabelPos(2)+2000];

MyLabel=xlabel('$\overbrace{Wind, Tide}$ [$^\circ$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-170];

%Right
MargineLeft=0.72;
MargineRight=0.10;
SubplotNumber=3;

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('G:\Paper2-NewSet\Result-110081.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%M2 7.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,-1]
    CaseNumber=[];
    CaseValue=[];
    for i=14:20%M2 7.5 m and 3 to 6 wind
        Address=strcat('G:\Paper2-NewSet\Result-',num2str(j*7+i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([-48:30:126,126]-90,100*(CaseValue-Baseline)/Baseline,'-s','LineWidth',2,'MarkerSize',6);%ISSSSSSSSSSSSSSSSSSUUUUE
end
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-138 36 -10 80]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.MinorTickValues=-10:10:80;
MyAxe.YAxis.TickValues=0:50:70;
line([-90,250],[0 0],'LineStyle',':','color','black');
MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-138:30:30;
MyAxe.XAxis.TickValues=-138+30:60:30;
set(gca,'XTickLabel','');
text(-108,73,'$g$','fontsize',24,'Color','black','background','none');
box on;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('G:\Paper2-NewSet\Result-110083.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%M2 12.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    for i=171:177%M2 12.5 m and 3 to 6 wind
        Address=strcat('G:\Paper2-NewSet\Result-',num2str(j*7+i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([-48:30:126,126]-90,100*(CaseValue-Baseline)/Baseline,'-s','LineWidth',2,'MarkerSize',6);
end
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-138 36 -1 16]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.MinorTickValues=-1:1:16;
MyAxe.YAxis.TickValues=0:5:16;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-138:30:30;
MyAxe.XAxis.TickValues=-138+30:60:30;
set(gca,'XTickLabel','');
line([-138,36],[0 0],'LineStyle',':','color','black');
text(-108,14,'$h$','fontsize',24,'Color','black','background','none');
box on;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('G:\Paper2-NewSet\Result-110085.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%M2 17.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    for i=357:363%M2 17.5 m and 3 to 6 wind
        Address=strcat('G:\Paper2-NewSet\Result-',num2str(j*7+i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([-48:30:126,126]-90,100*(CaseValue-Baseline)/Baseline,'-s','LineWidth',2,'MarkerSize',6);
end
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-138 36 -4 7]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.MinorTickValues=-4:1:7;
MyAxe.YAxis.TickValues=-3:3:6;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-138:30:30;
MyAxe.XAxis.TickValues=-138+30:60:30;
line([-138,36],[0 0],'LineStyle',':','color','black');
text(-108,6,'$i$','fontsize',24,'Color','black','background','none');
box on;

text(40,25.10,'$7.50$ $m$','fontsize',18,'Color','black','background','none');
text(40,13.33,'$12.5$ $m$','fontsize',18,'Color','black','background','none');
text(40,1.570,'$17.5$ $m$','fontsize',18,'Color','black','background','none');

text(-636,31.76,'$M_2K_1$','fontsize',18,'Color','black','background','none');
text(-323,31.76,'$K_1$','fontsize',18,'Color','black','background','none');
text(-64,31.76,'$M_2$','fontsize',18,'Color','black','background','none');

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\ConversionWindLag');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\ConversionWindLag','epsc');
%%
%Figure 11- Conversion at different wind stress
clc;
clear all;
close all;
FIG=figure('position',[100 100 800 600]);

MargineTop=0.06;
MargineBot=0.15;
MargineLeft=0.15;
MargineRight=0.13;
SubplotSpac=0.02;
SubplotNumber=3;

SubplotCounter=3;%M2K1
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
CaseValue3=[];
for i=158:62:468
    Address=strcat('G:\Paper2-NewSet\Result-',num2str(i+110000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    CaseValue3(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
end

CaseValue6=[];
for i=170:62:480
    Address=strcat('G:\Paper2-NewSet\Result-',num2str(i+110000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    CaseValue6(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
end

CaseValue0=[];
for i=46:1:51
    Address=strcat('G:\Paper2-NewSet\Result-',num2str(i+110000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    CaseValue0(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
end
plot([7.5:2.5:20],100*(CaseValue3-CaseValue0)./CaseValue0,'-s','LineWidth',2,'MarkerSize',8);
plot([7.5:2.5:20],100*(CaseValue6-CaseValue0)./CaseValue0,'-s','LineWidth',2,'MarkerSize',8);
line([7,20.5],[0 0],'LineStyle',':','color','black');

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
lgd=legend('$3$ $m.s^{-1}$','$6$ $m.s^{-1}$','Orientation','horizontal','Location','northoutside');
POS=lgd.Position;
lgd.Position=[POS(1) POS(2)+0.05 POS(3) POS(4)];
set(gca,'XTick',7.5:2.5:20);
set(gca,'XTickLabel','');
axis([7 20.5 -20 160]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-20:10:160;
MyAxe.YAxis(1).TickValues=0:50:150;
box on;
lgd.FontSize=13;
text(0.2,1.2,'$a$','fontsize',24,'Color','black','BackgroundColor','white');

SubplotCounter=2;%just K1
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;

CaseValue3=[];
for i=[44,196:62:444]
    Address=strcat('G:\Paper2-NewSet\Result-',num2str(i+110000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    CaseValue3(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
end

CaseValue6=[];
for i=[32,208:62:456]
    Address=strcat('G:\Paper2-NewSet\Result-',num2str(i+110000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    CaseValue6(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
end

CaseValue0=[];
for i=88:1:93
    Address=strcat('G:\Paper2-NewSet\Result-',num2str(i+110000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    CaseValue0(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
end
plot([7.5:2.5:20],100*(CaseValue3-CaseValue0)./CaseValue0,'-s','LineWidth',2,'MarkerSize',8);
plot([7.5:2.5:20],100*(CaseValue6-CaseValue0)./CaseValue0,'-s','LineWidth',2,'MarkerSize',8);

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'XTick',7.5:2.5:20);
set(gca,'XTickLabel','');
axis([7 20.5 50 800]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=50:50:800;
MyAxe.YAxis(1).TickValues=100:300:700;
box on;
lgd.FontSize=13;
text(0.2,1.2,'$a$','fontsize',24,'Color','black','BackgroundColor','white');

SubplotCounter=1;%Just M2
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
CaseValue3=[];
for i=[14,171:62:419]
    Address=strcat('G:\Paper2-NewSet\Result-',num2str(i+110000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    CaseValue3(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
end

CaseValue6=[];
for i=[7,178:62:426]
    Address=strcat('G:\Paper2-NewSet\Result-',num2str(i+110000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    CaseValue6(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
end

CaseValue0=[];
for i=81:1:86
    Address=strcat('G:\Paper2-NewSet\Result-',num2str(i+110000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    CaseValue0(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
end
plot([7.5:2.5:20],100*(CaseValue3-CaseValue0)./CaseValue0,'-s','LineWidth',2,'MarkerSize',8);
plot([7.5:2.5:20],100*(CaseValue6-CaseValue0)./CaseValue0,'-s','LineWidth',2,'MarkerSize',8);
line([7,20.5],[0 0],'LineStyle',':','color','black');

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'XTick',7.5:2.5:20);
axis([7 20.5 -20 80]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-20:10:80;
MyAxe.YAxis(1).TickValues=-20:40:70;
box on;
lgd.FontSize=13;
text(0.2,1.2,'$a$','fontsize',24,'Color','black','BackgroundColor','white');
MyLabel=xlabel('Pycnocline Depth[$m$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-16];

MyLabel=ylabel('Conversion Rate Variation [$\%$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-0.7 LabelPos(2)+100];


text(21,244,'$M_2K_1$','fontsize',18,'Color','black','background','none');
text(21,135,'$K_1$','fontsize',18,'Color','black','background','none');
text(21,1.44,'$M_2$','fontsize',18,'Color','black','background','none');


savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\AllConversionCases');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper2\AllConversionCases','epsc');
%%
%Figure 11
%clear all;
close all;
clc

XIndex=475;
ZIndex=29;
TimeRange=3156+287;
TimeIndex=540;

% Data=cell(7,1);
% counter=1;
% for i=80:86
%     Address=strcat('F:\Sorush\Paper2\Results-',num2str(i+110000),'.mat');
%     Data{counter}=load(Address,'ConversionConventionalTimeAvrWBar','RhoPrimeConventional','X','ZC','Time');
%     Data{counter}.RhoPrimeConventional=Data{counter}.RhoPrimeConventional(:,:,TimeRange:end);
%     counter=counter+1;
% end


load(Address,'X','ZC','Time');

FIG=figure('position',[100 100 800 600]);
% MargineTop=0.06;
% MargineBot=0.10;
% MargineLeft=0.13;
% MargineRight=0.03;
% SubplotSpac=0.02;
% SubplotNumber=3;
for i=1:7
    subplot(4,2,i)
    pcolor(460:490,ZC(1:117),movmean(Data{i}.ConversionConventionalTimeAvrWBar(460:490,1:117)',2,2));shading flat;
    caxis(5e-4*[-1 1]);
end
figure;
hold on;
plot(squeeze(Data{i}.RhoPrimeConventional(475,17,:)));
plot(squeeze(Data{i}.RhoPrimeConventional(475,25,:)));
plot(squeeze(Data{i}.RhoPrimeConventional(475,33,:)));
plot(squeeze(Data{i}.RhoPrimeConventional(473,41,:)));
plot(squeeze(Data{i}.RhoPrimeConventional(470,49,:)));
plot(squeeze(Data{i}.RhoPrimeConventional(469,57,:)));
plot(squeeze(Data{i}.RhoPrimeConventional(467,65,:)));
