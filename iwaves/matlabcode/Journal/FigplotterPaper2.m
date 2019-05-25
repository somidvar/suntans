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
load('D:\Paper2Results\Results-110080.mat','Eta','RhoPrimeConventional','WBar','ConversionConventionalWBar','Time');

MargineTop=0.05;
MargineBot=0.07;
MargineLeft=0.15;
MargineRight=0.15;
SubplotSpac=0.17;
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
set(gca,'XTick',[31:0.25:35]);
set(gca,'XTickLabel','');
set(gca,'YTick',[-0.5:0.1:0.5]);
set(gca,'YTickLabel',{'-0.5',' ',' ',' ',' ','0',' ',' ',' ',' ','0.5'});
text(0.1,0.4,'$a$','fontsize',24);
MyYLabel=ylabel({'$\eta$';'$[m]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.10, 0.5, 0]);

hold on;
yyaxis right;
plot(Time*omega/2/pi,1e4*squeeze(ConversionConventionalWBar(XPOS,ZPOS,:)),'LineWidth',2,'Color',right_color);
set(gca,'XTick',[31:0.25:35]);
set(gca,'XTickLabel',{'31',' ',' ',' ','32',' ',' ',' ','33',' ',' ',' ','34',' ',' ',' ','35'});
set(gca,'YTick',[-5:1:5]);
set(gca,'YTickLabel',{'-5',' ',' ',' ',' ','0',' ',' ',' ',' ','5'});
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([31 35 -5.1 5.3]);
MyYLabel=xlabel('t/T $[cycle^{-1}]$','fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [0.5, -0.17,0 ]);
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
set(gca,'XTick',[31:0.125:35]);
set(gca,'XTickLabel','');
set(gca,'YTick',[-0.1:0.025:0.1]);
set(gca,'YTickLabel',{'-0.1',' ',' ',' ','0',' ',' ',' ','0.1'});
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
set(gca,'YTickLabel',{'-8',' ',' ',' ','-4',' ',' ',' ','0','','','','4','','','','8'});
text(0.1,0.45,'$c$','fontsize',24,'BackgroundColor', 'white');
MyYLabel=ylabel({'$\overline{w}$';'$[10^{-4}$ $m.s^{-1}]$'},'fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [1.1, 0.5, 0]);
set(gca,'XTick',[31:0.125:35]);
set(gca,'XTickLabel',{'31',' ',' ',' ','32',' ',' ',' ','33',' ',' ',' ','34',' ',' ',' ','35'});
set(gca,'xaxisLocation','top')
hold off;

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\ConversionSample');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\ConversionSample','epsc');
%%
%Figure 2- Brock's image
clear all;
close all;

FIG=figure('position',[100 100 800 800]);

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\Monterey');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\Monterey','epsc');

%%
%Figure 3- Tidal constituents
clear all;
close all;

FIG=figure('position',[100 100 800 800]);
[InitialPhase,TideSeparated,TideName,TideAmp,TidePhase,TideFrequency,Time,Tide]=TidalPhaseSeparator('D:\Paper2Results\TideJun2018Monterey.csv',100,36.5);
Time=Time-datenum(2018,0,0);
Tide=Tide-mean(Tide);%converting the tide to mean sea level
Predict=TideSeparated(:,1)+TideSeparated(:,3);

plot(Time,Predict,'LineWidth',2,'Linestyle','-');
hold on;
plot(Time, Tide,'LineWidth',2,'Linestyle',':');
set(gca,'XTick',[152:1:182]);
set(gca,'XTickLabel',{'152',' ',' ',' ',' ','157',' ',' ',' ',' ','162',' ',' ',' ',' ','167',' ',' ',' ',' ','172',' ',' ',' ',' ','177',' ',' ',' ',' ','182'});
axis([152 182 -1.3 1.3]);
set(gca,'FontWeight','bold');
set(gca,'fontsize',16);
ylabel({'Sea Surface Height [m]'},'fontsize',18);
xlabel('Day of year','fontsize',18);
lgd=legend('$M_2+K_1$','Total','Position',[0.7 0.87 0.1 0.05],'Orientation','horizontal');
lgd.FontSize=16;

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\TidalRecords');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\TidalRecords','epsc');
%%
%Figure 4- Wind Record
clear all;
close all;

FIG=figure('position',[100 50 1200 950]); 
FileAddressReader='D:\Paper2Results\WindJun2017BeachWeather.csv'
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
SubplotNumber=2;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
plot(Time,movmean(WindSpeed,6),'Linewidth',2);
set(gca,'fontsize',16);
axis([152 182 0 7]);
MyYLabel=ylabel('Wind Speed $[m.s^{-1}]$','fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.15, 0.5, 0]);
xlabel('Time [day of year]','fontsize',18);
set(gca,'XTick',[152:1:182]);
set(gca,'XTickLabel',{'152',' ',' ',' ',' ','157',' ',' ',' ',' ','162',' ',' ',' ',' ','167',' ',' ',' ',' ','172',' ',' ',' ',' ','177',' ',' ',' ',' ','182'});
text(153.1,6.5,'$a$','Interpreter','latex','Fontsize',24);
set(gca,'FontWeight','bold');

SubplotCounter=1;
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
SubplotNumber=2;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
polarhistogram(WindDirectionTri*pi()/180);
set(gca,'fontsize',16);
%set(gca,'FontWeight','bold');
annotation('textbox',[0.89517 0.91895 0.0407 0.0516],'String',{'N'},'LineStyle','none','Interpreter','latex','FontSize',36,'FitBoxToText','off');
annotation('arrow',[0.915 0.915],[0.84 0.921],'LineWidth',5,'Headsize',25);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
C=princaxes(East,North,1);
text(-8.95,34.2,'$c$','Interpreter','latex','Fontsize',24);
text(-8.95,8.1,'$d$','Interpreter','latex','Fontsize',24);

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

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\WindRecords');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\WindRecords','epsc');
%%
%Figure 5- Bathymetry and RhoB
clear all;
close all;

load('D:\Paper2Results\Results-110080.mat','X','RhoBConventional','Density','ZC','W');

FIG=figure('position',[100 100 1000 800]);
MargineTop=0.10;
MargineBot=0.10;
MargineLeft=0.07;
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
ax1.XTick=1024.6:0.4:1025.4;
ax1.XColor = [0 0 0];
ax1.YColor = 'black';
set(gca,'fontsize',16);

ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,'XAxisLocation','top','YAxisLocation','right','Color','none');
ax2.XColor=[0 0.45 .74];
ax2.XLim=([0 0.045]);
set(gca,'YTickLabel','');
line(x2,y2,'Parent',ax2,'Color',[0 0.45 0.74],'LineStyle','-','LineWidth',2);
ylim([-75 0]);
set(gca,'fontsize',16);

MyYLabel=ylabel('Z $[m]$','fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [-0.21, 0.5, 0]);
text(0.013,-82,'$\rho_b$ $[kg.m^{-3}]$','Interpreter','latex','Fontsize',18);
text(0.018,7,'$N$ $[s^{-1}]$','Color',[0 0.45 0.74],'Interpreter','latex','Fontsize',18);
set(gca,'XTick',[0.01:0.010:0.049]);
text(0.002,-4,'$a$','fontsize',24);

line(0,0,'Color','black','LineStyle','-','LineWidth',2);
set(gca,'FontWeight','bold');

MargineTop=0.10;
MargineBot=0.10;
MargineLeft=0.50;
MargineRight=0.05;
SubplotSpac=0.15;
SubplotNumber=2;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);

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

pcolor(X/1000,ZC,100000*squeeze(W(:,:,3685))');
shading flat;colorbar;caxis([-5 5]);
colormap(CustomMap);
MyColorbar= colorbar;
set(gca,'fontsize',16);
MyColorbar.TickLabelInterpreter='latex';
text(41,5,'w $[10^{-5} m.s^{-1}]$','Interpreter','latex','Fontsize',18);
ylabel('Z $[m]$','fontsize',18);
MyYLabel=xlabel('X $[km]$','fontsize',18);
set(MyYLabel, 'Units', 'Normalized', 'Position', [0.08, -0.15, 0]);
set(gca, 'Color', 'Black');
text(2,-11,'$b$','fontsize',24,'Color','black');
ylim([-75,-1]);
set(gca,'YTick',[-75:20:-5]);
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
annotation('rectangle',[0.794 0.57625 0.06 0.32125],'Color',[0.65 0.65 0.65],'LineWidth',3,'LineStyle',':');
annotation('line',[0.795 0.5],[0.57625 0.42375],'Color',[0.65 0.65 0.65],'LineWidth',3);
annotation('line',[0.856 0.898],[0.575 0.4225],'Color',[0.65 0.65 0.65],'LineWidth',3);

MargineTop=0.10;
MargineBot=0.10;
MargineLeft=0.50;
MargineRight=0.10;
SubplotSpac=0.15;
SubplotNumber=2;
SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
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

plot(XFine/1000,-Bathymetry,'Color',[0 0 0],'LineStyle','-','LineWidth',2);
ylabel('Z $[m]$','fontsize',18);
text(39.8,-8.4,'$c$','fontsize',24);
xlim([39.6 45.05]);
set(gca,'YTick',[-75:20:-5]);
hold on;
yyaxis right
BathymetryDiff=diff(Bathymetry)./diff(XFine);
BathymetryDiff(end+1)=BathymetryDiff(end);
BathymetryDiff([4417,4418,4370])=[];
XFine([4417,4418,4370])=[];
plot(XFine/1000,-movmean(BathymetryDiff,20),'Color',[0 0.45 0.74],'LineStyle','-','LineWidth',2);
set(gca,'YTick',[0.01:0.02:0.08]);
set(gca,'fontsize',16);
xlabel('X $[km]$','fontsize',18);
ylabel('Slope $[m.m^{-1}]$','fontsize',18);
set(gca,'FontWeight','bold');

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\DensityBathymetry');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\UGA Courses\Latex\Paper2\DensityBathymetry','epsc');

%%
%Figure 6- Different conversion rate shapes
clear all;
close all;
names=[];
for i=45:7:79
    Address=strcat('D:\Paper2Results\Results-',num2str(i+110000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    plot(X/1000,movmean(ConversionConventionalTimeAvrDepthIntWBar,5));
    xlim([43.5 45.5]);
    hold on;
    names{end+1}=num2str(i);
end
legend(names);