close all;
clc;

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');  
cd 'C:\suntans\plots';
%%
%Figure 1- Monterey Bay map, bathymetry and density stratificiation
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

lat=ncread('C:\GitHub\monterey_13_navd88_2012.nc','lat');
lon=ncread('C:\GitHub\monterey_13_navd88_2012.nc','lon');
Bathymetry=ncread('C:\GitHub\monterey_13_navd88_2012.nc','Band1');
lat=lat(8500:10:16000);
lon=lon(3000:10:7500);
Bathymetry=Bathymetry(3000:10:7500,8500:10:16000);
%Bathymetry from NOAA website https://data.noaa.gov/metaview/page?xml=NOAA/NESDIS/NGDC/MGG/DEM/iso/xml/3544.xml&view=getDataView&header=none#
%Monterey, California 1/3 arc-second NAVD 88 Coastal Digital Elevation Model
Bathymetry(Bathymetry>=1)=nan;
pcolor(lon,lat,Bathymetry');
set(gca,'FontWeight','bold');
shading flat;
MyColorbar=colorbar('Location','eastoutside');
MyColorbar.FontSize=16;
MyColorbar.FontWeight='bold';
MyColorbar.TickLabelInterpreter='latex';
POS=MyColorbar.Position;
MyColorbar.Position=[0.46 0.415 0.02375 0.51875];
caxis([-1600 0]);
set(MyColorbar,'XTick',[-1500:500:0]);

text(-121.92,37.08,'Elevation $[m]$','Fontsize',18);
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

%line([-121.8,-121.95],[36.6,36.6],'Color','black','LineWidth',2,'LineStyle','--');
annotation('arrow',[0.3356 0.3586],[0.5326 0.607],'LineWidth',3,'LineStyle',':');
annotation('line',[0.330316742081448 0.119909502262443],[0.526613816534541 0.297848244620612],'LineWidth',2,'LineStyle','--');
annotation('line',[0.356334841628959 0.44683257918552],[0.601491506228766 0.298980747451869],'LineWidth',2,'LineStyle','--');

contour(lon,lat,Bathymetry',[-25 -50 -75 -100 -250 -500 -750 -1000],'Color',[0 0 0],'Linewidth',0.5);
text(-122.11,37.01,'$(a)$','fontsize',24);

MargineTop=0.70;
MargineBot=0.10;
SubplotNumber=1;
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
text(4.9,-11.3,'$(b)$','fontsize',24);
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
MyAxe.XAxis(1).TickValues=1:4:5;

set(gca,'TickLength',[0.03,0.03]);

set(gca,'fontsize',16);
xlabel('Offshore distance $[km]$','fontsize',18);
ylabel('Slope $[m.m^{-1}]$','fontsize',18);
set(gca,'FontWeight','bold');


MargineTop=0.11;
MargineBot=0.11;
MargineLeft=0.65;
MargineRight=0.05;
SubplotSpac=0.0;
SubplotNumber=1;
SubplotCounter=1;

subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
set(gca,'FontWeight','bold');
load('C:\suntans\Result-12080.mat','Density','Time','ZC');
RhoBConventional=trapz(Time,squeeze(Density(1,:,:)),2)/(Time(end)-Time(1))+1000;
x1 = RhoBConventional;
y1 = ZC;
x2=movmean(sqrt(abs(-9.8/1000*diff(RhoBConventional)./diff(ZC))),4);
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
text(-0.003,-4,'$(c)$','fontsize',24);

line(0,0,'Color','black','LineStyle','-','LineWidth',2);
set(gca,'FontWeight','bold');


FIG.Color='white';
fig = gcf;
fig.InvertHardcopy = 'off';

saveas(FIG,'C:\suntans\plots\Monterey');
saveas(FIG,'C:\suntans\plots\Monterey','png');
%%
%Figure 2- Monterey Bay wind and tide
clc;
clear all;
close all;

FIG=figure('position',[100 50 800 800]); 
MyColor=[ 0.85 0.325 0.098;...%red
    0.929 0.6941 0.1255;...%yellow
    0 0.447 0.741;...%blue
    0.47 0.67 0.19];%green

MargineTop=0.05;
MargineBot=0.7;
MargineLeft=0.12;
MargineRight=0.45;
SubplotSpac=0;
SubplotNumber=1;

FileAddressReader='C:\GitHUb\suntans\TideWindPaperSourceCodeVer2\WindJun2017BeachWeather.csv';
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

Theta=-5;
JacobianMatrix=[cosd(Theta) sind(Theta);...
    -sind(Theta) cosd(Theta)];

MajorRotated=nan(size(Time,1),1);
MinorRotated=nan(size(Time,1),1);
for counter=1:length(Time)
    RotatedValues=JacobianMatrix*[East(counter);North(counter)];
    MajorRotated(counter)=RotatedValues(1);
    MinorRotated(counter)=RotatedValues(2);
end

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
Fs=6*24;
L=size(East,1);
Y = fft(East);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
semilogx(f(4:end),P1(4:end),'Linewidth',2,'color',MyColor(4,:)) 
hold on;
line([1,1],[0,1.5],'Color','black','Linestyle','--','Linewidth',2);
hold off;

set(gca,'fontsize',16);
MyYLabel=xlabel('Frequency $[cpd]$','fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-2 LabelPos(2)-0.15];

MyYLabel=ylabel('Amplitude $[m$ $s^{-1}]$','fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)+0.005 LabelPos(2)];

axis([0.1 10 -0.02 1.5]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=0:1;
MyAxe.YAxis.MinorTickValues=0:0.1:1.5;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=[0.5,1,2,4,6];
MyAxe.XAxis.MinorTickValues=[0.1:0.1:0.9,1:1:10];

MyAxe.YAxis.TickLength=[0.03 0.03];
MyAxe.XAxis.TickLength=[0.03 0.03];

text(0.12,1.35,'$(a)$','Interpreter','latex','Fontsize',24);
set(gca,'FontWeight','bold');

MargineTop=0.02;
MargineBot=0.6;
MargineLeft=0.65;
MargineRight=0.10;
SubplotSpac=0;
SubplotNumber=1;

SubplotCounter=1;
MyHistogram=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
polarhistogram(WindDirectionTri*pi()/180,'facecolor',MyColor(4,:));
rticks([250 500 750 1000 1250 1500]);
rticklabels({'','500','','1000','','1500'});

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
AX=gca;
AX.ThetaTick=[0:90:270];
AX.ThetaTickLabel={'East','North','West','South'};
AX.GridAlpha=0.5;

MargineTop=0.45;
MargineBot=0.10;
MargineLeft=0.12;
MargineRight=0.05;
SubplotSpac=0.02;
SubplotNumber=2;

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;

plot(Time,movmean(East,6*5),'color',0*[1 1 1],'LineWidth',1,'LineStyle','-');
plot(Time,movmean(North,6*5),'color',0.5*[1 1 1],'LineWidth',1,'LineStyle','-');
line([152 182],[0 0],'color',0.4*[1 1 1],'LineWidth',0.05);
box on;
set(gca,'fontsize',16);
axis([152 182 -4 10]);
MyYLabel=ylabel('Wind Speed $[m$ $s^{-1}]$','fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-1 LabelPos(2)];

LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1) LabelPos(2)];

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=0:6:6;
MyAxe.YAxis.MinorTickValues=-10:10;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=152:5:182;
MyAxe.XAxis.MinorTickValues=152:1:182;
MyAxe.XAxis.TickLabels='';

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];

lgd=legend('East-West','North-South','Location','northeast','Orientation','horizontal');
lgd.FontSize=16;

text(169.5,34.5,'$(b)$','Interpreter','latex','Fontsize',24);
text(152.6,7.8,'$(c)$','Interpreter','latex','Fontsize',24);
set(gca,'FontWeight','bold');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;

[~,TideSeparated,TideName,TideAmp,TidePhase,TideFrequency,Time,Tide]=TidalPhaseSeparator('C:\GitHUb\suntans\TideWindPaperSourceCodeVer2\TideJun2018Monterey.csv',100,36.5);
Time=Time-datenum(2018,0,0);
Tide=Tide-mean(Tide);%converting the tide to mean sea level
Predict=TideSeparated(:,1)+TideSeparated(:,3);

plot(Time, Tide,'LineWidth',2,'Linestyle','-','color','black');
hold on;
box on;
plot(Time,Predict,'LineWidth',2,'Linestyle',':','color',MyColor(3,:));

MyAxe=gca;
MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=152:182;
MyAxe.XAxis.TickValues=152:5:182;

set(gca,'TickLength',[0.02,0.03]);

axis([152 182 -1.3 1.5]);
set(gca,'FontWeight','bold');
set(gca,'fontsize',16);
MyYLabel=ylabel({'SSH [$m$]'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-1 LabelPos(2)];

MyYLabel=xlabel('Day of year','fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1) LabelPos(2)-0.2];

lgd=legend('Total','$M_2+K_1$','Location','northeast','Orientation','horizontal');
lgd.FontSize=16;
text(152.6,1,'$(d)$','Interpreter','latex','Fontsize',24);

savefig(FIG,'C:\suntans\plots\WindTideRecords');
saveas(FIG,'C:\suntans\plots\WindTideRecords','epsc');
%%
%Figure 3- Water Column Stability
clear all;
close all;
FIG=figure('position',[100 300 600 600]);

Data=cell(6,1);
Address='C:\suntans\Result-12000.mat';
load(Address,'X','ZC','Time');

CaseNumber=1;
for counter=12021:1:12032
    Address=strcat('C:\suntans\Result-',num2str(counter),'.mat');
    load(Address,'Density','U');
    
    N=-9.8/1024*diff(Density,1,2)./diff(permute(repmat(ZC,1,size(X,1),size(Time,1)),[2,1,3]),1,2);
    N(:,end+1,:)=N(:,end,:);
    ShearVelocity=diff(U,1,2)./diff(permute(repmat(ZC,1,size(X,1),size(Time,1)),[2,1,3]),1,2);
    ShearVelocity(:,end+1,:)=ShearVelocity(:,end,:);
    Ri=N./ShearVelocity.^2;
    Ri=min(Ri,[],3);
    if CaseNumber==1
        K1Ri=Ri;
    else
        K1Ri=min(K1Ri,Ri);
    end
    CaseNumber=CaseNumber+1
end

CaseNumber=1;
for counter=12007:1:12013
    Address=strcat('C:\suntans\Result-',num2str(counter),'.mat');
    load(Address,'Density','U');
    
    N=-9.8/1024*diff(Density,1,2)./diff(permute(repmat(ZC,1,size(X,1),size(Time,1)),[2,1,3]),1,2);
    N(:,end+1,:)=N(:,end,:);
    ShearVelocity=diff(U,1,2)./diff(permute(repmat(ZC,1,size(X,1),size(Time,1)),[2,1,3]),1,2);
    ShearVelocity(:,end+1,:)=ShearVelocity(:,end,:);
    Ri=N./ShearVelocity.^2;
    Ri=min(Ri,[],3);
    if CaseNumber==1
        M2Ri=Ri;
    else
        M2Ri=min(M2Ri,Ri);
    end
    CaseNumber=CaseNumber+1
end

CaseNumber=1;
for counter=12159:1:12170
    Address=strcat('C:\suntans\Result-',num2str(counter),'.mat');
    load(Address,'Density','U');
    
    N=-9.8/1024*diff(Density,1,2)./diff(permute(repmat(ZC,1,size(X,1),size(Time,1)),[2,1,3]),1,2);
    N(:,end+1,:)=N(:,end,:);
    ShearVelocity=diff(U,1,2)./diff(permute(repmat(ZC,1,size(X,1),size(Time,1)),[2,1,3]),1,2);
    ShearVelocity(:,end+1,:)=ShearVelocity(:,end,:);
    Ri=N./ShearVelocity.^2;
    Ri=min(Ri,[],3);
    if CaseNumber==1
        M2K1Ri=Ri;
    else
        M2K1Ri=min(M2K1Ri,Ri);
    end
    CaseNumber=CaseNumber+1
end

%Stability of Water Column
MargineTop=0.05;
MargineBot=0.15;
MargineLeft=0.15;
MargineRight=0.2;
SubplotSpac=0.02;
SubplotNumber=3;

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);

hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
pcolor(X/1000,ZC,K1Ri');
axis([35 50 -75 -1]);
shading flat;
caxis([0 0.25]);



colormap(bone);
set(gca, 'Color',0.8*[1 1 1]);
FIG.Color='white';

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-60:15:-15;
MyAxe.YAxis.MinorTickValues=-75:5:0;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=40:5:45;
MyAxe.XAxis.MinorTickValues=30:2.5:50;
MyAxe.XAxis.TickLabels='';

MyAxe.YAxis.TickLength=[0.01 0.02];
MyAxe.XAxis.TickLength=[0.01 0.02];

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'layer','top')

text(47.5,-65,'$(a)$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
pcolor(X/1000,ZC,M2Ri');
axis([35 50 -75 -1]);
shading flat;
caxis([0 0.25]);
colormap(bone);

set(gca, 'Color',0.8*[1 1 1]);
FIG.Color='white';

MyColorbar=colorbar('Location','eastoutside');
MyColorbar.FontSize=18;
MyColorbar.FontWeight='bold';
MyColorbar.TickLabelInterpreter='latex';
POS=MyColorbar.Position;
MyColorbar.Position=[POS(1)+0.1 POS(2)-0.273 POS(3) POS(4)+0.545];
MyColorbar.Label.String='$Ri$';
MyColorbar.Label.Interpreter='latex';

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-60:15:-15;
MyAxe.YAxis.MinorTickValues=-75:5:0;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=40:5:45;
MyAxe.XAxis.MinorTickValues=30:2.5:50;
MyAxe.XAxis.TickLabels='';

MyAxe.YAxis.TickLength=[0.01 0.02];
MyAxe.XAxis.TickLength=[0.01 0.02];

MyYLabel=ylabel('$z$ $[m]$','fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.7 LabelPos(2)];

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'layer','top');

text(47.5,-65,'$(b)$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
pcolor(X/1000,ZC,M2K1Ri');
axis([35 50 -75 -1]);
shading flat;
caxis([0 0.25]);
colormap(bone);

set(gca, 'Color',0.8*[1 1 1]);
FIG.Color='white';

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-60:15:-15;
MyAxe.YAxis.MinorTickValues=-75:5:0;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=40:5:45;
MyAxe.XAxis.MinorTickValues=30:2.5:50;

MyAxe.YAxis.TickLength=[0.01 0.02];
MyAxe.XAxis.TickLength=[0.01 0.02];

MyYLabel=xlabel('$X$ $[km]$','fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1) LabelPos(2)-1.5];


set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'layer','top');

text(47.5,-65,'$(c)$','fontsize',24,'Color','black','BackgroundColor','none');

FIG = gcf;
FIG.InvertHardcopy = 'off';

savefig(FIG,'C:\suntans\plots\StabilityMixing');
saveas(FIG,'C:\suntans\plots\StabilityMixing','epsc');
%%
%Figure 4- The vertical profile showing the effect of pycnolicne on the conversion
clear all;
clc
close all;
FIG=figure('position',[100 300 1000 600]);

XIndex=[476,473,473,471,467,464];

ZIndex=[8,13,24,26,29,38];

MyColor=[0.47 0.67 0.19;...
    0.49 0.18 0.56;...
    0.64 0.08 0.18;...
    0.30 0.75 0.93;...
    1.00 0.07 0.51;...
    0.50 0.50 0.50];

TimeRange=3600;
TimeIndex=3800;

Address=strcat('C:\suntans\Result-',num2str(12082),'.mat');%M2 at 10m
M210=load(Address,'Eta','WBar','RhoPrimeConventional','ConversionConventionalTimeAvrDepthIntWBar','ConversionConventionalTimeAvrWBar','ConversionConventionalWBar');
load(Address,'X','ZC','Time');
Time(1:TimeRange)=[];
M210.Eta(:,1:TimeRange)=[];
M210.WBar(:,:,1:TimeRange)=[];
M210.RhoPrimeConventional(:,:,1:TimeRange)=[];
M210.ConversionConventionalWBar(:,:,1:TimeRange)=[];
[~,M210.XIndex]=max(M210.ConversionConventionalTimeAvrDepthIntWBar);
[~,M210.ZIndex]=max(M210.ConversionConventionalTimeAvrWBar(M210.XIndex,:));

Address=strcat('C:\suntans\Result-',num2str(12084),'.mat');%M2 at 15 m
M215=load(Address,'Eta','WBar','RhoPrimeConventional','ConversionConventionalTimeAvrDepthIntWBar','ConversionConventionalTimeAvrWBar','ConversionConventionalWBar');
M215.Eta(:,1:TimeRange)=[];
M215.WBar(:,:,1:TimeRange)=[];
M215.RhoPrimeConventional(:,:,1:TimeRange)=[];
M215.ConversionConventionalWBar(:,:,1:TimeRange)=[];
[~,M215.XIndex]=max(M215.ConversionConventionalTimeAvrDepthIntWBar);
[~,M215.ZIndex]=max(M215.ConversionConventionalTimeAvrWBar(M215.XIndex,:));

Address=strcat('C:\suntans\Result-',num2str(12086),'.mat');%M2 at 20 m
M220=load(Address,'Eta','WBar','RhoPrimeConventional','ConversionConventionalTimeAvrDepthIntWBar','ConversionConventionalTimeAvrWBar','ConversionConventionalWBar');
M220.Eta(:,1:TimeRange)=[];
M220.WBar(:,:,1:TimeRange)=[];
M220.RhoPrimeConventional(:,:,1:TimeRange)=[];
M220.ConversionConventionalWBar(:,:,1:TimeRange)=[];
[~,M220.XIndex]=max(M220.ConversionConventionalTimeAvrDepthIntWBar);
[~,M220.ZIndex]=max(M220.ConversionConventionalTimeAvrWBar(M220.XIndex,:));



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
Marker=Time(TimeRange:10:TimeIndex);

plot(Marker/3600,100*squeeze(M210.Eta(M210.XIndex,TimeRange:10:TimeIndex)),'-.','Color',MyColor(1,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(Marker/3600,100*squeeze(M215.Eta(M215.XIndex,TimeRange:10:TimeIndex)),'-.','Color',MyColor(2,:),'LineWidth',2,'MarkerIndices',3:5:length(Marker));
plot(Marker/3600,100*squeeze(M220.Eta(M220.XIndex,TimeRange:10:TimeIndex)),'-.','Color',MyColor(3,:),'LineWidth',2,'MarkerIndices',4:5:length(Marker));
line([Time(TimeRange)/3600 Time(TimeIndex)/3600],[0 0],'LineWidth',1,'LineStyle',':','Color','black');

% scatter(Time(TimeRange+134)/3600,25,100,'p','filled','MarkerEdgeColor','black','MarkerFaceColor','black');
line([Time(TimeRange+134)/3600,Time(TimeRange+134)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);

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
text(400,-40,'$(a)$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'XTickLabel','');

plot(Marker/3600,1000*squeeze(M210.WBar(M210.XIndex,M210.ZIndex,TimeRange:10:TimeIndex)),'-.','Color',MyColor(1,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(Marker/3600,1000*squeeze(M215.WBar(M215.XIndex,M215.ZIndex,TimeRange:10:TimeIndex)),'-.','Color',MyColor(2,:),'LineWidth',2,'MarkerIndices',3:5:length(Marker));
plot(Marker/3600,1000*squeeze(M220.WBar(M220.XIndex,M220.ZIndex,TimeRange:10:TimeIndex)),'-.','Color',MyColor(3,:),'LineWidth',2,'MarkerIndices',4:5:length(Marker));
line([Time(TimeRange)/3600 Time(TimeIndex)/3600],[0 0],'LineWidth',1,'LineStyle',':','Color','black');
line([Time(TimeRange+134)/3600,Time(TimeRange+134)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);

axis([399 415 -1.8 1.8]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-1.5:1.5:1.5;
MyAxe.YAxis.MinorTickValues=-1.8:0.3:1.8;

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
text(400,1,'$(b)$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

plot(Marker/3600,squeeze(M210.RhoPrimeConventional(M210.XIndex,M210.ZIndex,TimeRange:10:TimeIndex)),'-.','Color',MyColor(1,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(Marker/3600,squeeze(M215.RhoPrimeConventional(M215.XIndex,M215.ZIndex,TimeRange:10:TimeIndex)),'-.','Color',MyColor(2,:),'LineWidth',2,'MarkerIndices',3:5:length(Marker));
plot(Marker/3600,squeeze(M220.RhoPrimeConventional(M220.XIndex,M220.ZIndex,TimeRange:10:TimeIndex)),'-.','Color',MyColor(3,:),'LineWidth',2,'MarkerIndices',4:5:length(Marker));
line([Time(TimeRange)/3600 Time(TimeIndex)/3600],[0 0],'LineWidth',1,'LineStyle',':','Color','black');
line([Time(TimeRange+134)/3600,Time(TimeRange+134)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);

axis([399 415 -0.25 0.25]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.15:0.15:0.2;
MyAxe.YAxis.MinorTickValues=-0.2:0.05:0.25;

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
text(400,-0.12,'$(c)$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

plot(Marker/3600,1000*squeeze(M210.ConversionConventionalWBar(M210.XIndex,M210.ZIndex,TimeRange:10:TimeIndex)),'-.','Color',MyColor(1,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(Marker/3600,1000*squeeze(M215.ConversionConventionalWBar(M215.XIndex,M215.ZIndex,TimeRange:10:TimeIndex)),'-.','Color',MyColor(2,:),'LineWidth',2,'MarkerIndices',3:5:length(Marker));
plot(Marker/3600,1000*squeeze(M220.ConversionConventionalWBar(M220.XIndex,M220.ZIndex,TimeRange:10:TimeIndex)),'-.','Color',MyColor(3,:),'LineWidth',2,'MarkerIndices',4:5:length(Marker));
line([Time(TimeRange)/3600 Time(TimeIndex)/3600],[0 0],'LineWidth',1,'LineStyle',':','Color','black');
line([Time(TimeRange+134)/3600,Time(TimeRange+134)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);

axis([399 415 -1 2.5]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-1.5:1.5:1.5;
MyAxe.YAxis.MinorTickValues=-1:0.5:2.5;

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
text(400,1.6,'$(d)$','fontsize',24,'Color','black','BackgroundColor','none');

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

plot(1000*squeeze(M210.WBar(M210.XIndex,:,TimeRange+134)),ZC,'-.','Color',MyColor(1,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(1000*squeeze(M215.WBar(M215.XIndex,:,TimeRange+134)),ZC,'-.','Color',MyColor(2,:),'LineWidth',2,'MarkerIndices',3:5:length(Marker));
plot(1000*squeeze(M220.WBar(M220.XIndex,:,TimeRange+134)),ZC,'-.','Color',MyColor(3,:),'LineWidth',2,'MarkerIndices',4:5:length(Marker));
% line([0 0],[-24 -1],'LineWidth',1,'LineStyle',':','Color','black');

axis([-0 1.6 -25 0]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-20:5:-5;
MyAxe.YAxis.MinorTickValues=-30:2.5:0;

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

lgd=legend('$10m$','$15m$','$20m$','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1)+0 LGDPositio(2)+0.055 LGDPositio(3) LGDPositio(4)];
text(1.05,-2,'$(e)$','fontsize',24,'Color','black','BackgroundColor','none');

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

plot(squeeze(M210.RhoPrimeConventional(M210.XIndex,:,TimeRange+134)),ZC,'-.','Color',MyColor(1,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(squeeze(M215.RhoPrimeConventional(M215.XIndex,:,TimeRange+134)),ZC,'-.','Color',MyColor(2,:),'LineWidth',2,'MarkerIndices',3:5:length(Marker));
plot(squeeze(M220.RhoPrimeConventional(M220.XIndex,:,TimeRange+134)),ZC,'-.','Color',MyColor(3,:),'LineWidth',2,'MarkerIndices',4:5:length(Marker));
line([0 0],[-24 -1],'LineWidth',1,'LineStyle',':','Color','black');

axis([-0.05 0.2 -25 0]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-20:5:-5;
MyAxe.YAxis.MinorTickValues=-30:2.5:0;
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
text(0.12,-2,'$(f)$','fontsize',24,'Color','black');

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

plot(1000*squeeze(M210.ConversionConventionalWBar(M210.XIndex,:,TimeRange+134)),ZC,'-.','Color',MyColor(1,:),'LineWidth',2,'MarkerIndices',2:5:length(Marker));
plot(1000*squeeze(M215.ConversionConventionalWBar(M215.XIndex,:,TimeRange+134)),ZC,'-.','Color',MyColor(2,:),'LineWidth',2,'MarkerIndices',3:5:length(Marker));
plot(1000*squeeze(M220.ConversionConventionalWBar(M220.XIndex,:,TimeRange+134)),ZC,'-.','Color',MyColor(3,:),'LineWidth',2,'MarkerIndices',4:5:length(Marker));
line([0 0],[-24 -1],'LineWidth',1,'LineStyle',':','Color','black');


axis([-0.5 2 -25 0]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-20:5:-5;
MyAxe.YAxis.MinorTickValues=-30:2.5:0;
MyAxe.YAxis.TickLabels='';
MyAxe.YAxisLocation='right';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-0:1.5:1.5;
MyAxe.XAxis.MinorTickValues=-0.5:0.25:2;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel('$z$ $[m]$','fontsize',20);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)+0.01 LabelPos(2)];

MyLabel=xlabel('$C$ $[mW.m^{-3}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.02];
text(1.2,-2,'$(g)$','fontsize',24,'Color','black');

savefig(FIG,'C:\suntans\plots\VerticalStructurePycnocline');
saveas(FIG,'C:\suntans\plots\VerticalStructurePycnocline','epsc');
%%
%Figure 5- Details of Conversion at different pycnocline with various wind
%speed
clear all;
clc;
close all;

FIG=figure('position',[100 50 800 800]);
MargineTop=0.08;
MargineBot=0.12;

MargineLeft=0.10+0*0.15+0*0.01;
MargineRight=1-(MargineLeft+0.15);

SubplotSpac=0.01;
SubplotNumber=7;

MapColorNumber=25;
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

FIG.Color='white';
fig = gcf;
fig.InvertHardcopy = 'off';

FigureName={'$05.0$ $m$','$07.5$ $m$','$10.0$ $m$','$12.5$ $m$','$15.0$ $m$','$17.5$ $m$','$20.0$ $m$'};
for counter=51:-1:45
    SubplotCounter=counter-44;
    subplot1=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
    set(gca, 'Color', 0.5*[1 1 1]);
    hold on;

    Address=strcat('C:\suntans\Result-120',num2str(counter),'.mat');
    load(Address,'ZC','X','ConversionConventionalTimeAvrWBar','ConversionConventionalTimeAvrDepthIntWBar');
    ConversionConventionalTimeAvrDepthIntWBar=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    
    pcolor(X/1000,ZC,1e4*movmean(ConversionConventionalTimeAvrWBar,2,1)');
    shading flat;
    caxis([-8 8]);
    colormap(CustomMap);
    
    xlim([44 45]);
    ylim([-30 -1]);
    
    set(gca,'layer','top');
    MyAxe=gca;
    MyAxe.YAxis.MinorTick='on';
    MyAxe.YAxis.MinorTickValues=-30:5:0;
    MyAxe.YAxis.TickValues=-25:20:-5;
    
    MyAxe.XAxis.MinorTick='on';
    MyAxe.XAxis.TickValues=44.25:0.5:44.75;
    MyAxe.XAxis.MinorTickValues=44:0.25:45;
    
    set(gca,'fontsize',16);
    set(gca,'FontWeight','bold');
    if counter~=45
        set(gca,'XTickLabel','');
    end
    MyAxe.TickLength=[0.04 0.04];
    box on;
    text(44.05,-7.5,FigureName{counter-44},'Fontsize',16);
    text(44.05,-25,num2str(round(ConversionConventionalTimeAvrDepthIntWBar,3)),'Fontsize',14);
end
text(44.25,200,'$0$ $m.s^{-1}$','Fontsize',18);

MyLabel=ylabel('Z [$m$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)+100];

MargineLeft=0.10+1*0.15+1*0.01;
MargineRight=1-(MargineLeft+0.15);

for counter=58:-1:52
    SubplotCounter=counter-51;
    subplot1=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
    set(gca, 'Color', 0.5*[1 1 1]);
    hold on;

    Address=strcat('C:\suntans\Result-120',num2str(counter),'.mat');
    load(Address,'ZC','X','ConversionConventionalTimeAvrWBar','ConversionConventionalTimeAvrDepthIntWBar');
    ConversionConventionalTimeAvrDepthIntWBar=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    
    pcolor(X/1000,ZC,1e4*movmean(ConversionConventionalTimeAvrWBar,2,1)');
    shading flat;
    caxis([-8 8]);
    colormap(CustomMap);
    
    xlim([44 45]);
    ylim([-30 -1]);
    
    set(gca,'layer','top');
    MyAxe=gca;
    MyAxe.YAxis.MinorTick='on';
    MyAxe.YAxis.MinorTickValues=-30:5:0;
    MyAxe.YAxis.TickValues=-25:20:-5;
    
    MyAxe.YAxisLocation='left';
    MyAxe.XAxis.MinorTick='on';
    MyAxe.XAxis.TickValues=44.25:0.5:44.75;
    MyAxe.XAxis.MinorTickValues=44:0.25:45;
    
    set(gca,'fontsize',16);
    set(gca,'FontWeight','bold');
    if counter~=52
        set(gca,'XTickLabel','');
    end
    MyAxe.TickLength=[0.03 0.03];
    set(gca,'YTickLabel','');
    box on;
    text(44.05,-25,num2str(round(ConversionConventionalTimeAvrDepthIntWBar,3)),'Fontsize',14);
end
text(44.25,200,'$1.5$ $m.s^{-1}$','Fontsize',18);

MargineLeft=0.10+2*0.15+2*0.01;
MargineRight=1-(MargineLeft+0.15);

for counter=65:-1:59
    SubplotCounter=counter-58;
    subplot1=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
    set(gca, 'Color', 0.5*[1 1 1]);
    hold on;

    Address=strcat('C:\suntans\Result-120',num2str(counter),'.mat');
    load(Address,'ZC','X','ConversionConventionalTimeAvrWBar','ConversionConventionalTimeAvrDepthIntWBar');
    ConversionConventionalTimeAvrDepthIntWBar=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    
    pcolor(X/1000,ZC,1e4*movmean(ConversionConventionalTimeAvrWBar,2,1)');
    shading flat;
    caxis([-8 8]);
    colormap(CustomMap);
    
    xlim([44 45]);
    ylim([-30 -1]);
    
    set(gca,'layer','top');
    MyAxe=gca;
    MyAxe.YAxis.MinorTick='on';
    MyAxe.YAxis.MinorTickValues=-30:5:0;
    MyAxe.YAxis.TickValues=-25:20:-5;
    
    MyAxe.YAxisLocation='left';
    MyAxe.XAxis.MinorTick='on';
    MyAxe.XAxis.TickValues=44.25:0.5:44.75;
    MyAxe.XAxis.MinorTickValues=44:0.25:45;
    
    set(gca,'fontsize',16);
    set(gca,'FontWeight','bold');
    if counter~=59
        set(gca,'XTickLabel','');
    end
    MyAxe.TickLength=[0.03 0.03];
    set(gca,'YTickLabel','');
    box on;
    text(44.05,-25,num2str(round(ConversionConventionalTimeAvrDepthIntWBar,3)),'Fontsize',14);
end
text(44.25,200,'$3$ $m.s^{-1}$','Fontsize',18);

MargineLeft=0.10+3*0.15+3*0.01;
MargineRight=1-(MargineLeft+0.15);

for counter=72:-1:66
    SubplotCounter=counter-65;
    subplot1=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
    set(gca, 'Color', 0.5*[1 1 1]);
    hold on;

    Address=strcat('C:\suntans\Result-120',num2str(counter),'.mat');
    load(Address,'ZC','X','ConversionConventionalTimeAvrWBar','ConversionConventionalTimeAvrDepthIntWBar');
    ConversionConventionalTimeAvrDepthIntWBar=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    
    pcolor(X/1000,ZC,1e4*movmean(ConversionConventionalTimeAvrWBar,2,1)');
    shading flat;
    caxis([-8 8]);
    colormap(CustomMap);
    
    xlim([44 45]);
    ylim([-30 -1]);
    
    set(gca,'layer','top');
    MyAxe=gca;
    MyAxe.YAxis.MinorTick='on';
    MyAxe.YAxis.MinorTickValues=-30:5:0;
    MyAxe.YAxis.TickValues=-25:20:-5;
    
    MyAxe.YAxisLocation='left';
    MyAxe.XAxis.MinorTick='on';
    MyAxe.XAxis.TickValues=44.25:0.5:44.75;
    MyAxe.XAxis.MinorTickValues=44:0.25:45;
    
    set(gca,'fontsize',16);
    set(gca,'FontWeight','bold');
    if counter~=66
        set(gca,'XTickLabel','');
    end
    MyAxe.TickLength=[0.03 0.03];
    set(gca,'YTickLabel','');
    box on;
    text(44.05,-25,num2str(round(ConversionConventionalTimeAvrDepthIntWBar,3)),'Fontsize',14);
end
text(44.25,200,'$4.5$ $m.s^{-1}$','Fontsize',18);

MargineLeft=0.10+4*0.15+4*0.01;
MargineRight=1-(MargineLeft+0.15);

for counter=79:-1:73
    SubplotCounter=counter-72;
    subplot1=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
    set(gca, 'Color', 0.5*[1 1 1]);
    hold on;

    Address=strcat('C:\suntans\Result-120',num2str(counter),'.mat');
    load(Address,'ZC','X','ConversionConventionalTimeAvrWBar','ConversionConventionalTimeAvrDepthIntWBar');
    ConversionConventionalTimeAvrDepthIntWBar=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    
    pcolor(X/1000,ZC,1e4*movmean(ConversionConventionalTimeAvrWBar,2,1)');
    shading flat;
    caxis([-8 8]);
    colormap(CustomMap);
    
    xlim([44 45]);
    ylim([-30 -1]);
    
    set(gca,'layer','top');
    MyAxe=gca;
    MyAxe.YAxis.MinorTick='on';
    MyAxe.YAxis.MinorTickValues=-30:5:0;
    MyAxe.YAxis.TickValues=-25:20:-5;
    
    MyAxe.YAxisLocation='left';
    MyAxe.XAxis.MinorTick='on';
    MyAxe.XAxis.TickValues=44.25:0.5:44.75;
    MyAxe.XAxis.MinorTickValues=44:0.25:45;
    
    set(gca,'fontsize',16);
    set(gca,'FontWeight','bold');
    if counter~=73
        set(gca,'XTickLabel','');
    end
    MyAxe.TickLength=[0.03 0.03];
    set(gca,'YTickLabel','');
    box on;
    text(44.05,-25,num2str(round(ConversionConventionalTimeAvrDepthIntWBar,3)),'Fontsize',14);
end
text(44.25,200,'$6$ $m.s^{-1}$','Fontsize',18);

MyColorbar=colorbar('Location','eastoutside');
MyColorbar.FontSize=18;
MyColorbar.FontWeight='bold';
MyColorbar.TickLabelInterpreter='latex';
POS=MyColorbar.Position;
MyColorbar.Position=[POS(1)+0.055 POS(2) POS(3) POS(4)+0.693];
MyColorbar.Label.String='$\langle C \rangle$ [$10^{-4}$ $W.m^{-3}$]';
MyColorbar.Label.Interpreter='latex';
%MyColorbar.Label.Rotation=0;
MyColorbarLabelPos=get(MyColorbar,'Position');
MyColorbar.Label.Position=[MyColorbarLabelPos(1)+5 MyColorbarLabelPos(2)];

MyLabel=xlabel('X [$km$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-2 LabelPos(2)-10];

savefig(FIG,'C:\suntans\plots\PycnoWindSpeedConversion');
saveas(FIG,'C:\suntans\plots\PycnoWindSpeedConversion','epsc');
%%
%Figure 6- Dimesionless numbers at different pycno
clear all;
close all;
FIG=figure('position',[100 100 600 300]);
counter=1;
DensityCell=cell(14,1);
ConversionConventionalTimeAvrWBarCell=cell(14,1);
ConversionConventionalTimeAvrDepthIntWBarCell=cell(14,1);
UCell=cell(14,1);
XCell=cell(14,1);
for j=80%M2
    for i=0:6
        Address=strcat('C:\suntans\Result-',num2str(j+i+12000),'.mat');
        load(Address,'X','ZC','Time','U','Density','ConversionConventionalTimeAvrWBar','ConversionConventionalTimeAvrDepthIntWBar');
        
        Dx=diff(X,1);
        Dx(end+1)=Dx(end);
        ConversionStartPoint=cumsum(Dx.*ConversionConventionalTimeAvrDepthIntWBar);
        ConversionStartPoint=ConversionStartPoint/ConversionStartPoint(end);
        ConversionStartPoint=find(ConversionStartPoint<0,1,'last');        
        ConversionStartPoint=find(X>44000,1,'first');
        
        DensityCell{counter}=Density(ConversionStartPoint:end,:,:);
        ConversionConventionalTimeAvrWBarCell{counter}=ConversionConventionalTimeAvrWBar(ConversionStartPoint:end,:);
        ConversionConventionalTimeAvrDepthIntWBarCell{counter}=ConversionConventionalTimeAvrDepthIntWBar(ConversionStartPoint:end);
        XCell{counter}=X(ConversionStartPoint:end);
        UCell{counter}=U(ConversionStartPoint:end,:,:);
        
        counter=counter+1;
    end
end
X=X(ConversionStartPoint:end);

counter=1;
TotalConversion=nan(7,1);
Gamma1Avg=nan(7,1);
for j=80%M2
    for i=0:6
        Topo=DensityCell{counter}*0+permute(repmat(ZC,1,size(X,1),size(Time,1)),[2,1,3]);
        Topo=nanmin(Topo,[],2);
        Topo=squeeze(Topo(:,:,1));

        N=sqrt(abs(diff(DensityCell{counter},1,2)./diff(permute(repmat(ZC,1,size(X,1),size(Time,1)),[2,1,3]),1,2)*9.8/1000));
        N=mean(N,3);
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
        f=0.867e-4;
        IWEpsilon=sqrt(Omega^2-f^2)./sqrt(N.^2-Omega^2);
        IWEpsilon(~isreal(IWEpsilon))=nan;
        Epsilon=Topo./IWEpsilon;
        Epsilon(isnan(Epsilon))=0;
        Gamma1Avg(counter)=trapz(X,Epsilon.*ConversionConventionalTimeAvrDepthIntWBarCell{counter})/trapz(X,ConversionConventionalTimeAvrDepthIntWBarCell{counter});
        TotalConversion(counter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBarCell{counter});
        
        counter=counter+1;
    end
end
disp('Gamma1')
disp(Gamma1Avg);

Gamma2=nan(7,1);
Gamma2Counter=1;
for j=80
    for i=0:6      
        Depth=repmat(ZC,1,size(X,1))'+squeeze(UCell{Gamma2Counter}(:,:,1))*0;
        Depth=nanmin(Depth,[],2);
        Slope=diff(Depth)./diff(X);
        Slope=movmean(Slope,5);

        [~,XIndex]=max(movmean(ConversionConventionalTimeAvrDepthIntWBarCell{Gamma2Counter},5));
        U0=max(nanmean(UCell{Gamma2Counter}(XIndex,:,:),2));
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
disp('Gamma2')
disp(Gamma2);

MargineTop=0.05;
MargineBot=0.23;
MargineLeft=0.14;
MargineRight=0.17;
SubplotSpac=0.06;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;

MyColor=[0 0 0;...
    0.5 0.5 0.5];
MyStyle={'-p','-s'};

Gamma1AvgVec=Gamma1Avg(1:7);
plot(5:2.5:20,Gamma1AvgVec,MyStyle{1},'MarkerFaceColor',MyColor(1,:),'Color',MyColor(1,:),'LineWidth',2,'MarkerSize',12);
ylim([6 8.5]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=6:0.5:9;
MyAxe.YAxis(1).TickValues=7:1:8;


set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
box on;
xlim([4 21])
set(gca,'XTick',0:2.5:20);
set(gca,'TickLength',[0.015,0.015]);

MyLabel=ylabel('$\Gamma_1$','fontsize',18,'color','black');
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-1.2 LabelPos(2)];

yyaxis right;
hold on;

plot(5:2.5:20,Gamma2(1:7),MyStyle{2},'MarkerFaceColor',MyColor(2,:),'Color',MyColor(2,:),'LineWidth',2,'MarkerSize',12);
ylim([0.13 0.19]);
MyAxe=gca;
MyAxe.YAxis(2).MinorTick='on';
MyAxe.YAxis(2).TickValues=0.14:0.02:0.18;
MyAxe.YAxis(2).MinorTickValues=0.14:0.01:0.18;
MyAxe.YAxis(2).Color=0.5*[1 1 1];

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
box on;
xlim([4 21])
set(gca,'XTick',0:2.5:20);
set(gca,'TickLength',[0.015,0.015]);

MyLabel=ylabel('$\Gamma_2$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)+0.5 LabelPos(2)];

MyLabel=xlabel('Pycnocline Depth [m]','fontsize',18,'color','black');
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.05];

savefig(FIG,'C:\suntans\plots\DimensionlessNumber');
saveas(FIG,'C:\suntans\plots\DimensionlessNumber','epsc');
%%
%Figure 7- Sea surface, rho', WBar and conversion at an arbitrary point
clc
close all;
clear all;
DataM2=load('C:\suntans\Result-12082.mat','Eta','RhoPrimeConventional','WBar','ConversionConventionalWBar','Time','X','ZC');
DataK1=load('C:\suntans\Result-12089.mat','Eta','RhoPrimeConventional','WBar','ConversionConventionalWBar','Time','X','ZC');
DataM2K1=load('C:\suntans\Result-12047.mat','Eta','RhoPrimeConventional','WBar','ConversionConventionalWBar','Time','X','ZC');
FIG=figure('position',[100 50 800 800]);

MyColor=[ 0.85 0.325 0.098;...%red
    0.929 0.6941 0.1255;...%yellow
    0 0.447 0.741];%blue

XIndex=474;
%ZIndex=37;
ZIndex=18;
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
axis([373.9 433.8 -90 90]);
hold on;
box on;

plot(DataK1.Time(TimeRange:end)/3600,100*squeeze(DataK1.Eta(XIndex,TimeRange:end)),'LineWidth',2,'LineStyle','-','color',MyColor(1,:));
plot(DataM2K1.Time(TimeRange:end)/3600,100*squeeze(DataM2K1.Eta(XIndex,TimeRange:end)),'LineWidth',2,'LineStyle','-','color',MyColor(2,:));
plot(DataM2.Time(TimeRange:end)/3600,100*squeeze(DataM2.Eta(XIndex,TimeRange:end)),'LineWidth',2,'LineStyle','-','color',MyColor(3,:));
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'XTickLabel','');
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-60:60:60;
MyAxe.YAxis.MinorTickValues=-80:20:80;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=380:10:430;
MyAxe.XAxis.MinorTickValues=375:2.5:432.5;

MyAxe.YAxis.TickLength=[0.01 0.03];
MyAxe.XAxis.TickLength=[0.01 0.03];
line([373.9,433.8],[0 0],'LineStyle',':','color','black');
MyYLabel=ylabel({'$\eta$ $[cm]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[368 LabelPos(2)];
text(375,-65,'$(a)$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
axis([373.9 433.8 -0.2 0.2]);
hold on;
box on;

plot(DataK1.Time(TimeRange:end)/3600,squeeze(DataK1.RhoPrimeConventional(XIndex,ZIndex,TimeRange:end)),'LineWidth',2,'LineStyle','-','color',MyColor(1,:));
plot(DataM2K1.Time(TimeRange:end)/3600,squeeze(DataM2K1.RhoPrimeConventional(XIndex,ZIndex,TimeRange:end)),'LineWidth',2,'LineStyle','-','color',MyColor(2,:));
plot(DataM2.Time(TimeRange:end)/3600,squeeze(DataM2.RhoPrimeConventional(XIndex,ZIndex,TimeRange:end)),'LineWidth',2,'LineStyle','-','color',MyColor(3,:));
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
text(375,-0.15,'$(b)$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
axis([373.9 433.8 -1.75 1.75]);
hold on;
box on;

plot(DataK1.Time(TimeRange:end)/3600,1000*squeeze(DataK1.WBar(XIndex,ZIndex,TimeRange:end)),'LineWidth',2,'LineStyle','-','color',MyColor(1,:));
plot(DataM2K1.Time(TimeRange:end)/3600,1000*squeeze(DataM2K1.WBar(XIndex,ZIndex,TimeRange:end)),'LineWidth',2,'LineStyle','-','color',MyColor(2,:));
plot(DataM2.Time(TimeRange:end)/3600,1000*squeeze(DataM2.WBar(XIndex,ZIndex,TimeRange:end)),'LineWidth',2,'LineStyle','-','color',MyColor(3,:));
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'XTickLabel','');
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-1:1:1
MyAxe.YAxis.MinorTickValues=-1.75:0.25:1.75;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=380:10:430;
MyAxe.XAxis.MinorTickValues=375:2.5:432.5;

MyAxe.YAxis.TickLength=[0.01 0.03];
MyAxe.XAxis.TickLength=[0.01 0.03];
line([373.9,433.8],[0 0],'LineStyle',':','color','black');

MyYLabel=ylabel({'$W$ $[mm.s^{-1}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[368 LabelPos(2)];
text(375,1,'$(c)$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
axis([373.9 433.8 -1.2 2]);
hold on;
box on;

plot(DataK1.Time(TimeRange:end)/3600,1000*squeeze(DataK1.ConversionConventionalWBar(XIndex,ZIndex,TimeRange:end)),'LineWidth',2,'LineStyle','-','color',MyColor(1,:));
plot(DataM2K1.Time(TimeRange:end)/3600,1000*squeeze(DataM2K1.ConversionConventionalWBar(XIndex,ZIndex,TimeRange:end)),'LineWidth',2,'LineStyle','-','color',MyColor(2,:));
plot(DataM2.Time(TimeRange:end)/3600,1000*squeeze(DataM2.ConversionConventionalWBar(XIndex,ZIndex,TimeRange:end)),'LineWidth',2,'LineStyle','-','color',MyColor(3,:));
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-1.5:1.5:1.5;
MyAxe.YAxis.MinorTickValues=-2:0.25:2;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=380:10:430;
MyAxe.XAxis.MinorTickValues=375:2.5:432.5;

MyAxe.YAxis.TickLength=[0.01 0.03];
MyAxe.XAxis.TickLength=[0.01 0.03];
line([373.9,433.8],[0 0],'LineStyle',':','color','black');

MyYLabel=ylabel({'C $[mW. m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[368 LabelPos(2)];
text(375,1.4,'$(d)$','fontsize',24,'Color','black','BackgroundColor','none');

MyYLabel=xlabel('$Time$ $[hr]$','fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1) LabelPos(2)-0.35];
lgd=legend('$K_1$','$M_2K_1$','$M_2$','Orientation','horizontal','Location','northoutside');
lgd.FontSize=18;
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1) LGDPositio(2)+0.685 LGDPositio(3) LGDPositio(4)];

savefig(FIG,'C:\suntans\plots\ConversionSample');
saveas(FIG,'C:\suntans\plots\ConversionSample','epsc');
%%
%Figure 8- Nonlinear wind lag for M2, K1 and M2K1
clear all;
clc;
close all;
FIG=figure('position',[100 100 650 600]);

MyColor=[ 0.85 0.325 0.098;...%red
    0.929 0.6941 0.1255;...%yellow
    0 0.447 0.741;...%blue
    0.49 0.18 0.56;...%purple
    0.47 0.67 0.19;...%green
    0.56 0.81 0.91];%light blue

RowCounter=1;
ColumnCounter=1;
K1=nan(6,1);
for j=88:93
    Address=strcat('C:\compressed\Result-',num2str(j+12000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    K1(RowCounter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    RowCounter=RowCounter+1;
end

RowCounter=1;
ColumnCounter=1;
M2=nan(6,1);
for j=81:86
    Address=strcat('C:\compressed\Result-',num2str(j+12000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    M2(RowCounter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    RowCounter=RowCounter+1;
end

RowCounter=1;
ColumnCounter=1;
K1Wind6=nan(6,12);
for j=[21:32,259:270,197:208,321:332,383:394,445:456]%7.5, 10, 12.5, 15, 17.5, 20
    Address=strcat('C:\compressed\Result-',num2str(j+12000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    K1Wind6(RowCounter,ColumnCounter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    ColumnCounter=ColumnCounter+1;
    if ColumnCounter==13
        RowCounter=RowCounter+1;
        ColumnCounter=1;
    end
end

RowCounter=1;
ColumnCounter=1;
M2Wind6=nan(6,7);
for j=[7:13,240:246,178:184,302:308,364:370,426:432]%7.5, 10, 12.5, 15, 17.5, 20
    Address=strcat('C:\compressed\Result-',num2str(j+12000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    M2Wind6(RowCounter,ColumnCounter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    ColumnCounter=ColumnCounter+1;
    if ColumnCounter==8
        RowCounter=RowCounter+1;
        ColumnCounter=1;
    end
end

RowCounter=1;
ColumnCounter=1;
M2K1Wind6=nan(6,12);
for j=[159:170,283:294,221:232,345:356,407:418,469:480]%7.5, 10, 12.5, 15, 17.5, 20
    Address=strcat('C:\compressed\Result-',num2str(j+12000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    M2K1Wind6(RowCounter,ColumnCounter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    ColumnCounter=ColumnCounter+1;
    if ColumnCounter==13
        RowCounter=RowCounter+1;
        ColumnCounter=1;
    end
end

RowCounter=1;
ColumnCounter=1;
M2K1=nan(6,1);
for j=[46:51]%7.5, 10, 12.5, 15, 17.5, 20
    Address=strcat('C:\compressed\Result-',num2str(j+12000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    M2K1(RowCounter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    RowCounter=RowCounter+1;
end

RowCounter=1;
ColumnCounter=1;
Wind6=nan(6,1);
for j=[483:488]%7.5, 10, 12.5, 15, 17.5, 20
    Address=strcat('C:\compressed\Result-',num2str(j+12000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    Wind6(RowCounter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    RowCounter=RowCounter+1;
end

MargineTop=0.07;
MargineBot=0.13;
MargineLeft=0.18;
MargineRight=0.05;
SubplotSpac=0.01;
SubplotNumber=3;

SubplotCounter=3;%K1
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
MyBar=bar(7.5:2.5:20,[Wind6,K1]);
MyBar(1).FaceColor=MyColor(4,:);
MyBar(1).EdgeColor=MyColor(4,:);
MyBar(2).FaceColor=MyColor(1,:);
MyBar(2).EdgeColor=MyColor(1,:);

MaxK1WindError=max(K1Wind6,[],2)-K1-Wind6;
MinK1WindError=min(K1Wind6,[],2)-K1-Wind6;
errorbar([7.5:2.5:20]+1,(MaxK1WindError+MinK1WindError)/2,...
    (MaxK1WindError-MinK1WindError)/2,'LineStyle','none','LineWidth',2,'CapSize',10,'Color',MyColor(6,:));
scatter([7.5:2.5:20]+1,mean([MinK1WindError,MaxK1WindError],2),'filled','MarkerFaceColor',MyColor(6,:),'MarkerEdgeColor','none');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
box on;

axis([6.2 21.5 -1 1]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-1.8:0.1:1.4;
MyAxe.YAxis(1).TickValues=-0.6:0.6:0.6;

MyAxe.XAxis.TickValues=7.5:2.5:20;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.01 0.04];
MyAxe.XAxis.TickLength=[0.01 0.04];
text(6.5,-0.6,'$(a)$','fontsize',24,'Color','black','background','none');

text(7,0.8,num2str(Wind6(1),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(7,0.6,num2str(K1(1),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(8.2,MaxK1WindError(1)+0.20,num2str(MaxK1WindError(1),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));
text(8.0,MinK1WindError(1)-0.25,num2str(MinK1WindError(1),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));
 
text(9.54,0.8,num2str(Wind6(2),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(9.54,0.6,num2str(K1(2),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(10.67,MaxK1WindError(2)+0.20,num2str(MaxK1WindError(2),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));
text(10.47,MinK1WindError(2)-0.25,num2str(MinK1WindError(2),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));

text(11.91,0.8,num2str(Wind6(3),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(11.91,0.6,num2str(K1(3),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(13.17,MaxK1WindError(3)+0.20,num2str(MaxK1WindError(3),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));
text(12.97,MinK1WindError(3)-0.25,num2str(MinK1WindError(3),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));

text(14.44,0.8,num2str(Wind6(4),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(14.44,0.6,num2str(K1(4),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(15.67,MaxK1WindError(4)+0.20,num2str(MaxK1WindError(4),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));
text(15.47,MinK1WindError(4)-0.25,num2str(MinK1WindError(4),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));

text(16.94,0.8,num2str(Wind6(5),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(16.94,0.6,num2str(K1(5),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(18.13,MaxK1WindError(5)+0.20,num2str(MaxK1WindError(5),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));
text(17.93,MinK1WindError(5)-0.25,num2str(MinK1WindError(5),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));

text(19.44,0.8,num2str(Wind6(6),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(19.44,0.6,num2str(K1(6),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(20.63,MaxK1WindError(6)+0.20,num2str(MaxK1WindError(6),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));
text(20.43,MinK1WindError(6)-0.25,num2str(MinK1WindError(6),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));

SubplotCounter=2;%M2
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
MyBar=bar(7.5:2.5:20,[Wind6,M2]);
MyBar(1).FaceColor=MyColor(4,:);
MyBar(1).EdgeColor=MyColor(4,:);
MyBar(2).FaceColor=MyColor(3,:);
MyBar(2).EdgeColor=MyColor(3,:);

MaxM2WindError=max(M2Wind6,[],2)-M2-Wind6;
MinM2WindError=min(M2Wind6,[],2)-M2-Wind6;
errorbar([7.5:2.5:20]+1,(MaxM2WindError+MinM2WindError)/2,...
    (MaxM2WindError-MinM2WindError)/2,'LineStyle','none','LineWidth',2,'CapSize',10,'Color',MyColor(6,:));
%scatter([7.5:2.5:20]+1,mean([MinM2WindError,MaxM2WindError],2),'filled','MarkerFaceColor',MyColor(6,:),'MarkerEdgeColor','none');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
box on;

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([6.2 21.5 -0.4 1.4]);
box on;

MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-0.4:0.1:1.5;
MyAxe.YAxis(1).TickValues=0:0.5:1;

MyAxe.XAxis.TickValues=7.5:2.5:20;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.01 0.04];
MyAxe.XAxis.TickLength=[0.01 0.04];

text(6.5,1.1,'$(b)$','fontsize',24,'Color','black','background','none');

text(6.6,0.6,num2str(Wind6(1),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(6.6,0.4,num2str(M2(1),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(8.2,MaxM2WindError(1)+0.12,num2str(MaxM2WindError(1),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(8.2,MinM2WindError(1)-0.12,num2str(MinM2WindError(1),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
 
text(9.10,0.6,num2str(Wind6(2),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(9.10,0.4,num2str(M2(2),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(10.67,MaxM2WindError(2)+0.12,num2str(MaxM2WindError(2),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(10.67,MinM2WindError(2)-0.12,num2str(MinM2WindError(2),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));

text(11.6,0.6,num2str(Wind6(3),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(11.6,0.4,num2str(M2(3),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(13.17,MaxM2WindError(3)+0.08,num2str(MaxM2WindError(3),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(13.17,MinM2WindError(3)-0.08,num2str(MinM2WindError(3),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));

text(14.1,0.6,num2str(Wind6(4),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(14.1,0.4,num2str(M2(4),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(15.67,MaxM2WindError(4)+0.12,num2str(MaxM2WindError(4),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(15.67,MinM2WindError(4)-0.12,num2str(MinM2WindError(4),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));

text(16.6,0.6,num2str(Wind6(5),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(16.6,0.4,num2str(M2(5),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(18.13,MaxM2WindError(5)+0.12,num2str(MaxM2WindError(5),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(18.13,MinM2WindError(5)-0.12,num2str(MinM2WindError(5),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));

text(19.1,0.6,num2str(Wind6(6),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(19.1,0.4,num2str(M2(6),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(20.4,MaxM2WindError(6)+0.12,num2str(MaxM2WindError(6),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(20.4,MinM2WindError(6)-0.12,num2str(MinM2WindError(6),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));


SubplotCounter=1;%M2K1
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
bar(7.5:2.5:20,[M2,K1,M2K1,Wind6,M2K1-M2-K1]);
MaxM2K1WindError=max(M2K1Wind6,[],2)-M2K1-Wind6;
MinM2K1WindError=min(M2K1Wind6,[],2)-M2K1-Wind6;
errorbar([7.5:2.5:20]+1.2,(MaxM2K1WindError+MinM2K1WindError)/2,...
    (MaxM2K1WindError-MinM2K1WindError)/2,'LineStyle','none','LineWidth',2,'CapSize',10,'Color',MyColor(6,:));
scatter([7.5:2.5:20]+1.2,mean([MinM2K1WindError,MaxM2K1WindError],2),'filled','MarkerFaceColor',MyColor(6,:),'MarkerEdgeColor','none');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
box on;

axis([6.2 21.5 -1.8 1.6]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-1.8:0.1:1.5;
MyAxe.YAxis(1).TickValues=-1:1:1;

MyAxe.XAxis.TickValues=7.5:2.5:20;

MyAxe.YAxis.TickLength=[0.01 0.04];
MyAxe.XAxis.TickLength=[0.01 0.04];

MyLabel=ylabel('$\widehat{\overline{\langle C \rangle}}$[$W.m^{-1}$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-0.8 LabelPos(2)+3.5];

MyLabel=xlabel('Pycnocline Depth [$m$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.1];

text(6.5,1.15,'$(c)$','fontsize',24,'Color','black','background','none');

text(6.5,-0.2,num2str(M2(1),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(6.5,-0.5,num2str(K1(1),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(6.5,-0.8,num2str(M2K1(1),'%1.2f'),'fontsize',12,'Color',MyColor(2,:));
text(6.5,-1.1,num2str(Wind6(1),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(6.3,-1.4,num2str(M2K1(1)-M2(1)-K1(1),'%1.2f'),'fontsize',12,'Color',MyColor(5,:));
text(8,MaxM2K1WindError(1)+0.20,num2str(MaxM2K1WindError(1),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(8,MinM2K1WindError(1)-0.25,num2str(MinM2K1WindError(1),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));

text(9.3,-0.2,num2str(M2(2),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(9.3,-0.5,num2str(K1(2),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(9.3,-0.8,num2str(M2K1(2),'%1.2f'),'fontsize',12,'Color',MyColor(2,:));
text(9.3,-1.1,num2str(Wind6(2),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(9.1,-1.4,num2str(M2K1(2)-M2(2)-K1(2),'%1.2f'),'fontsize',12,'Color',MyColor(5,:));
text(10.5,MaxM2K1WindError(2)+0.20,num2str(MaxM2K1WindError(2),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(10.5,MinM2K1WindError(2)-0.25,num2str(MinM2K1WindError(2),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));

text(11.9,-0.2,num2str(M2(3),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(11.9,-0.5,num2str(K1(3),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(11.9,-0.8,num2str(M2K1(3),'%1.2f'),'fontsize',12,'Color',MyColor(2,:));
text(11.9,-1.1,num2str(Wind6(3),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(11.7,-1.4,num2str(M2K1(3)-M2(3)-K1(3),'%1.2f'),'fontsize',12,'Color',MyColor(5,:));
text(13.1,MaxM2K1WindError(3)+0.20,num2str(MaxM2K1WindError(3),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(13.1,MinM2K1WindError(3)-0.25,num2str(MinM2K1WindError(3),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));

text(14.4,-0.2,num2str(M2(4),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(14.4,-0.5,num2str(K1(4),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(14.4,-0.8,num2str(M2K1(4),'%1.2f'),'fontsize',12,'Color',MyColor(2,:));
text(14.4,-1.1,num2str(Wind6(4),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(14.2,-1.4,num2str(M2K1(4)-M2(4)-K1(4),'%1.2f'),'fontsize',12,'Color',MyColor(5,:));
text(15.6,MaxM2K1WindError(4)+0.20,num2str(MaxM2K1WindError(4),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(15.6,MinM2K1WindError(4)-0.25,num2str(MinM2K1WindError(4),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));

text(16.7,-0.2,num2str(M2(5),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(16.7,-0.5,num2str(K1(5),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(16.7,-0.8,num2str(M2K1(5),'%1.2f'),'fontsize',12,'Color',MyColor(2,:));
text(16.7,-1.1,num2str(Wind6(5),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(16.7,-1.4,num2str(M2K1(5)-M2(5)-K1(5),'%1.2f'),'fontsize',12,'Color',MyColor(5,:));
text(18,MaxM2K1WindError(5)+0.20,num2str(MaxM2K1WindError(5),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(18,MinM2K1WindError(5)-0.25,num2str(MinM2K1WindError(5),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));

text(19,-0.2,num2str(M2(6),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(19,-0.5,num2str(K1(6),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(19,-0.8,num2str(M2K1(6),'%1.2f'),'fontsize',12,'Color',MyColor(2,:));
text(19,-1.1,num2str(Wind6(6),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(19,-1.4,num2str(M2K1(6)-M2(6)-K1(6),'%1.2f'),'fontsize',12,'Color',MyColor(5,:));
text(20.5,MaxM2K1WindError(6)+0.2,num2str(MaxM2K1WindError(6),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(20.3,MinM2K1WindError(6)-0.25,num2str(MinM2K1WindError(6),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));

lgd=legend('$M_2$','$K_1$','$M_2K_1$','Wind','$NTT$','$NTW$','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1)+0.03 LGDPositio(2)+0.6 LGDPositio(3) LGDPositio(4)];
lgd.FontSize=12;

savefig(FIG,'C:\suntans\plots\M2K1WindNonlinear');
saveas(FIG,'C:\suntans\plots\M2K1WindNonlinear','epsc');
%%
%Figure 9- Conversion Frequencies in the system
clear all;
close all;
clc

MyColor=[ 0.85 0.325 0.098;...%red
    0.929 0.6941 0.1255;...%yellow
    0 0.447 0.741];%blue

FIG=figure('position',[100 50 800 400]);
MargineTop=0.1;
MargineBot=0.25;
MargineLeft=0.15;
MargineRight=0.05;
SubplotSpac=0.06;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
colorCounter=1;
for i=[90,48,83]%K1,M2K1 and K1
    Address=strcat('C:\suntans\Result-',num2str(i+12000),'.mat');
    load(Address,'ZC','Time','ConversionConventionalTimeAvrDepthIntWBar','ConversionConventionalTimeAvrWBar','ConversionConventionalWBar');
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
    semilogx(Period,1000*P1(1:end),'-.','Color',MyColor(colorCounter,:),'Linewidth',2);
    axis([4 30 0 1]);
    set(gca,'FontWeight','bold');
    set(gca,'fontsize',18);
    hold on;
    colorCounter=colorCounter+1;
end
axis([3.7 30 0 1.4]);
MyAxe=gca;
MyAxe.XAxis.TickValues=[4.13 4.92 6.2 8.17 12.4 25.8];
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.MinorTickValues=0:0.2:1.4;
MyAxe.YAxis.TickValues=0:0.4:1.2;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];

lgd=legend('$K_1$','$M_2K_1$','$M_2$','Orientation','horizontal','Location','northout');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1) LGDPositio(2)+0.08 LGDPositio(3) LGDPositio(4)];

text(15,1.20,'$\frac{T_{K_1}T_{M_2}}{T_{K_1}-T_{M_2}}=25.8$ hr','fontsize',16,'Color','black','BackgroundColor','none');
text(15,1.00,'$\frac{T_{K_1}T_{M_2}}{T_{K_1}+T_{M_2}}=8.17$ hr','fontsize',16,'Color','black','BackgroundColor','none');

text(15,0.80,'$\frac{T_{K_1}}{2}=11.95$ hr','fontsize',16,'Color','black','BackgroundColor','none');
text(15,0.60,'$\frac{T_{K_1}}{3}=7.97$ hr','fontsize',16,'Color','black','BackgroundColor','none');

text(15,0.40,'$\frac{T_{M_2}}{2}=6.2$ hr','fontsize',16,'Color','black','BackgroundColor','none');
text(15,0.20,'$\frac{T_{M_2}}{3}=4.13$ hr','fontsize',16,'Color','black','BackgroundColor','none');

MyYLabel=xlabel('Period $[Hour]$','fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1) LabelPos(2)-0.1];

MyYLabel=ylabel('C $[mW.m^{-3}]$','fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.25 LabelPos(2)];

savefig(FIG,'C:\suntans\plots\FourierDecomposition');
saveas(FIG,'C:\suntans\plots\FourierDecomposition','epsc');
%%
%Figure 10- Conversion at different pycno and with different initial phase
clear all;
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
MyStyle={'--d',':p','-.o'};
for j=[0,94,101]
    CaseNumber=[];
    CaseValue=[];
    for i=0+j:1:6+j
        Address=strcat('C:\suntans\Result-',num2str(i+12000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([-54:30:96,124],CaseValue,MyStyle{StyleCounter},'LineWidth',1.5,'MarkerSize',8,'color',MyColor(2,:));
    StyleCounter=StyleCounter+1;
end
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
lgd=legend('7.5m','15m','20m','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1) LGDPositio(2)+0.08 LGDPositio(3) LGDPositio(4)];
ylim([0.5 1.6]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=0.5:0.1:1.5;
MyAxe.YAxis(1).TickValues=1:0.5:1.5;
xlim([-65 135]);
set(gca,'XTick',[-54:30:96,124]);
xlabel('$\phi_{M_2,K_1}$ [$^\circ$]','fontsize',18);
box on;
lgd.FontSize=14;
MyLabel=ylabel('$\widehat{\langle\overline{C} \rangle}$ [$W.m^{-1}$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-10 LabelPos(2) -1];
MyAxe.YAxis.TickLength=[0.03 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];

savefig(FIG,'C:\suntans\plots\ConversionTidalLag');
saveas(FIG,'C:\suntans\plots\ConversionTidalLag','epsc');
%%
%Fig 11-Two layered system due to XS wind
close all;
clear all;
clc

MyColor=[0.00 0.45 0.74;...
        0.85 0.33 0.10;...
        0.93 0.63 0.13;...
        0.49 0.18 0.56;...
        0.47 0.67 0.19;...
        0.30 0.75 0.93;...
        0.64 0.08 0.18];

FIG=figure('position',[100 50 600 800]); 

CaseCell=cell(4,1);
counter=1;
Address=strcat('C:\suntans\Result-12082.mat');
load(Address,'X','ZC','Time','Eta');
for i=[242,244,246,82]
    Address=strcat('C:\suntans\Result-',num2str(i+12000),'.mat');
    CaseCell{counter}=load(Address,'U');
    Depth=repmat(ZC,1,size(X,1))'+CaseCell{counter}.U(:,:,1)*0;
    Depth=-repmat(nanmin(Depth,[],2),1,size(ZC,1),size(Time,1));
    UBar=CaseCell{counter}.U;
    UBar(isnan(UBar))=0;
    UBar=repmat(trapz(-ZC,UBar,2),1,size(ZC,1),1);
    CaseCell{counter}.UBar=UBar./Depth;
    
    CaseCell{counter}.U=CaseCell{counter}.U(:,:,end-600:end);
    CaseCell{counter}.UBar=CaseCell{counter}.UBar(:,:,end-600:end);
    CaseCell{counter}.UPrime=CaseCell{counter}.U-CaseCell{counter}.UBar;
    counter=counter+1;
end
Time=Time(end-600:end);
Eta=Eta(:,end-600:end);
    
WindOmega=2*pi/24/3600;
WindPeriod=24*3600;

InitialPhase=[12,72,126];

MargineTop=0.05;
MargineBot=0.72;
MargineLeft=0.15;
MargineRight=0.13;
SubplotSpac=0.18;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
PlotLegend=[];
for counter=1:3
    PlotLegend(counter)=plot(Time/3600,6*(1+sin(WindOmega*(Time-(360-InitialPhase(counter))*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-','color',MyColor(counter,:));
end
MyYLabel=xlabel('Time [Hour]','fontsize',16);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1) LabelPos(2)-1];

MyYLabel=ylabel('XS Wind [$m.$ $s^{-1}$]','fontsize',16);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)+14.5 LabelPos(2)];
axis([395 425 -0.4 6.3]);
line([395 425],[0 0],'linewidth',0.5,'color',0.7*[1 1 1]);

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=0:3:6;
MyAxe.YAxis.MinorTickValues=0:0.5:6;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=400:10:420;
MyAxe.XAxis.MinorTickValues=395:425;

MyAxe.YAxis.TickLength=[0.015 0.03];
MyAxe.XAxis.TickLength=[0.015 0.03];

text(396,5.5,'$(a)$','fontsize',24,'Color','black');

yyaxis right;
PlotLegend(4)=plot(Time/3600,squeeze(Eta(10,end-600:end)),':','LineWidth',3,'color',0.4*[1 1 1]);
axis([395 425 -0.6 0.6]);
line([395 425],[0 0],'linewidth',0.5,'color',0.7*[1 1 1]);
line([410 410],[0.6 -0.6],'linewidth',3,'color',0.4*[1 1 1]);
line([415.3 415.3],[0.6 -0.6],'linewidth',3,'color',0.4*[1 1 1]);

MyAxe=gca;
MyAxe.YAxis(2).MinorTick='on';
MyAxe.YAxis(2).TickValues=-0.4:0.4:0.4;
MyAxe.YAxis(2).MinorTickValues=-0.5:0.1:0.5;

MyAxe.YAxis(2).TickLength=[0.015 0.03];
MyAxe.XAxis.TickLength=[0.015 0.03];
MyAxe.YAxis(2).Color=0.4*[1 1 1];

MyYLabel=ylabel('SSH [$m$]','fontsize',16);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)+0.75 LabelPos(2)];

legendlabel=cell(4,1);
for counter=1:3
    legendlabel{counter}=num2str(InitialPhase(counter));
end
legendlabel{4}='NW';
lgd=legend(PlotLegend,'$12^\circ$','$72^\circ$','$126^\circ$','NW','Orientation','horizontal','Location','northeastoutside');
lgd.FontSize=14;
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1)-0.06 LGDPositio(2)+0.045 LGDPositio(3) LGDPositio(4)];

box on;
set(gca,'fontsize',16);

%The vertical structures
MargineTop=0.38;
MargineBot=0.10;
MargineLeft=0.15+0*0.20+0*0.01;
MargineRight=1-(MargineLeft+0.35);
SubplotSpac=0.18;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);

hold on;
for counter=1:3
    plot(squeeze(CaseCell{counter}.UPrime(475,:,315)),ZC,'LineWidth',2);
end
plot(squeeze(CaseCell{4}.UPrime(475,:,315)),ZC,':','LineWidth',3,'color',0.4*[1 1 1]);
line([0 0],[-11.5 -1],'linewidth',0.5,'color',0.5*[1 1 1]);
box on;
set(gca,'fontsize',16);
MyLabel=xlabel('$u''$ [$m.$ $s^{-1}$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-0.055 LabelPos(2)+0.5];

MyLabel=ylabel('$z$ [$m$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-0.005 LabelPos(2)];
axis([-0.015 0.015 -11.5 -1]);

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-9:3:-1;
MyAxe.YAxis.MinorTickValues=-11.5:0.5:-1;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-0.01:0.01:0.01;
MyAxe.XAxis.MinorTickValues=-0.05:0.005:0.05;

MyAxe.YAxis.TickLength=[0.015 0.03];
MyAxe.XAxis.TickLength=[0.015 0.03];

text(0.006,-11,'$(b)$','fontsize',24,'Color','black');

MargineLeft=0.15+0.35*1+0.01*1+0.01;
MargineRight=1-(MargineLeft+0.35);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);

hold on;
for counter=1:3
    plot(squeeze(CaseCell{counter}.UPrime(475,:,378)),ZC,'LineWidth',2);
end
plot(squeeze(CaseCell{4}.UPrime(475,:,378)),ZC,':','LineWidth',3,'color',0.4*[1 1 1]);
line([0 0],[-11.5 -1],'linewidth',0.5,'color',0.5*[1 1 1]);
box on;
set(gca,'fontsize',16);
axis([-0.02 0.02 -11.5 -1]);

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-9:3:-1;
MyAxe.YAxis.MinorTickValues=-11.5:0.5:-1;
MyAxe.YAxis.TickLabels='';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-0.01:0.01:0.01;
MyAxe.XAxis.MinorTickValues=-0.02:0.005:0.02;

MyAxe.YAxis.TickLength=[0.015 0.03];
MyAxe.XAxis.TickLength=[0.015 0.03];

text(0.008,-11,'$(c)$','fontsize',24,'Color','black');
MyLabel=xlabel('$u''$ [$m.$ $s^{-1}$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-0.02 LabelPos(2)-0.12];

savefig(FIG,'C:\suntans\plots\WindTwoLayered');
saveas(FIG,'C:\suntans\plots\WindTwoLayered','epsc');
%%
%Figure 12- Profiles and TimeSeries in the presence of wind
clear all;
close all;
FIG=figure('position',[100 300 1000 600]);

MyColor=[0.49 0.18 0.56;...%purple
    0.30 0.75 0.93;...%light blue
    0.47 0.67 0.19;...%green
    1.00 0.00 1.00];%pink

TimeIndex1=517;
TimeIndex2=589;
TimeIndex4=661;
TimeIndex5=733;

XIndex=475;
ZIndex=17;
TimeRange=3156;
TimeIndex=540;

Address=strcat('C:\suntans\Result-',num2str(12483),'.mat');
load(Address,'WBar','Eta','RhoPrimeConventional','Density','U','W','ConversionConventionalWBar');
W=W(:,:,TimeRange:end);
WBar=WBar(:,:,TimeRange:end);
ConversionConventionalWBar=ConversionConventionalWBar(:,:,TimeRange:end);
Eta=Eta(:,TimeRange:end);
RhoPrimeConventional=RhoPrimeConventional(:,:,TimeRange:end);
U=U(:,:,TimeRange:end);

load(Address,'X','ZC','Time');
Time=Time(TimeRange:end);
Depth=repmat(ZC,1,size(X,1))'+squeeze(U(:,:,1))*0;
Depth=nanmin(Depth,[],2);

UBar=U;
UBar(isnan(UBar))=0;
UBar=-repmat(trapz(-ZC,UBar,2),1,size(ZC,1),1)./repmat(Depth,1,size(ZC,1),size(Time,1));
Uprime=U-UBar;
% RhoPrimeConventional=RhoPrimeConventional-repmat(nanmean(RhoPrimeConventional,3),1,1,size(Time,1)); 

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
PhaseLag=312;

plot(Time/3600,6*(1+sin(WindOmega*(Time-(360-PhaseLag)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-','color','black');

scatter(Time(TimeIndex1)/3600,0,100,'p','filled','MarkerEdgeColor',MyColor(1,:),'MarkerFaceColor',MyColor(1,:));
scatter(Time(TimeIndex2)/3600,3.04,100,'p','filled','MarkerEdgeColor',MyColor(2,:),'MarkerFaceColor',MyColor(2,:));
% scatter(Time(TimeIndex3)/3600,4.6,100,'p','filled','MarkerEdgeColor',[0.93 0.69 0.13],'MarkerFaceColor',[0.93 0.69 0.13]);
scatter(Time(TimeIndex4)/3600,6,100,'p','filled','MarkerEdgeColor',MyColor(3,:),'MarkerFaceColor',MyColor(3,:));
scatter(Time(TimeIndex5)/3600,3,100,'p','filled','MarkerEdgeColor',MyColor(4,:),'MarkerFaceColor',MyColor(4,:));

axis([372 432 -0.5 6.5]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=0:03:6;
MyAxe.YAxis.MinorTickValues=0:1:6;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=385:20:425;
MyAxe.XAxis.MinorTickValues=370:2.5:432;

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'XS Wind';'$[m$ $s^{-1}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-8 LabelPos(2)];
text(15.8*24,5.2,'$(a)$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=4;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(Time/3600,1000*squeeze(Eta(XIndex,:)),'LineWidth',2,'LineStyle','-','color','black');
line([372 432],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);


line([Time(TimeIndex1)/3600, Time(TimeIndex1)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);
line([Time(TimeIndex2)/3600, Time(TimeIndex2)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);
line([Time(TimeIndex4)/3600, Time(TimeIndex4)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);
line([Time(TimeIndex5)/3600, Time(TimeIndex5)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);


axis([372 432 -1 3]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0:2:2;
MyAxe.YAxis.MinorTickValues=-1:0.5:4;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=385:20:425;
MyAxe.XAxis.MinorTickValues=370:2.5:432;

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$\eta$';'$[mm]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-8 LabelPos(2)];
text(15.8*24,2,'$(b)$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'XTickLabel','');

plot(Time/3600,1e3*squeeze(WBar(XIndex,ZIndex,:)),'-','LineWidth',2,'color','black');
line([372 432],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

line([Time(TimeIndex1)/3600, Time(TimeIndex1)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);
line([Time(TimeIndex2)/3600, Time(TimeIndex2)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);
% line([Time(TimeIndex3)/3600, Time(TimeIndex3)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);
line([Time(TimeIndex4)/3600, Time(TimeIndex4)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);
line([Time(TimeIndex5)/3600, Time(TimeIndex5)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);

axis([372 432 -0.014 0.014]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.01:0.01:0.01;
MyAxe.YAxis.MinorTickValues=-0.015:0.015:0.015;
 
MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=385:20:425;
MyAxe.XAxis.MinorTickValues=370:2.5:432;

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$W$';'$[mm$ $s^{-1}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.5 LabelPos(2)];
text(15.8*24,-0.007,'$(c)$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

plot(Time/3600,squeeze(RhoPrimeConventional(XIndex,ZIndex,:)),'LineWidth',2,'color','black');
line([372 432],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

line([Time(TimeIndex1)/3600, Time(TimeIndex1)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);
line([Time(TimeIndex2)/3600, Time(TimeIndex2)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);
% line([Time(TimeIndex3)/3600, Time(TimeIndex3)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);
line([Time(TimeIndex4)/3600, Time(TimeIndex4)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);
line([Time(TimeIndex5)/3600, Time(TimeIndex5)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);

axis([372 432 -0.2 0.2]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.15:0.15:0.15;
MyAxe.YAxis.MinorTickValues=-0.15:0.05:0.15;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=385:20:425;
MyAxe.XAxis.MinorTickValues=370:2.5:432;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$\rho''$';'$[kg.m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.2 LabelPos(2)];
text(15.8*24,-0.1,'$(d)$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

plot(Time/3600,10^3*squeeze(ConversionConventionalWBar(XIndex,ZIndex,:)),'LineWidth',2,'color','black');
line([372 432],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

line([Time(TimeIndex1)/3600, Time(TimeIndex1)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);
line([Time(TimeIndex2)/3600, Time(TimeIndex2)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);
line([Time(TimeIndex4)/3600, Time(TimeIndex4)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);
line([Time(TimeIndex5)/3600, Time(TimeIndex5)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);

axis([372 432 -0.015 0.015]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.01:0.01:0.01;
MyAxe.YAxis.MinorTickValues=-0.015:0.005:0.015;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=385:20:425;
MyAxe.XAxis.MinorTickValues=370:2.5:432;

MyAxe.YAxis.TickLength=[0.025 0.03];
MyAxe.XAxis.TickLength=[0.025 0.03];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('Time [$hour$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.008];

MyYLabel=ylabel({'$C$';'$[mW.m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.1 LabelPos(2)];
text(15.8*24,-0.01,'$(e)$','fontsize',24,'Color','black','BackgroundColor','none');

MargineLeft=0.41;
MargineRight=0.43;
SubplotSpac=0.00;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(squeeze(RhoPrimeConventional(XIndex,:,TimeIndex1)),ZC,'LineWidth',2,'color',MyColor(1,:));
plot(squeeze(RhoPrimeConventional(XIndex,:,TimeIndex2)),ZC,'LineWidth',2,'color',MyColor(2,:));
plot(squeeze(RhoPrimeConventional(XIndex,:,TimeIndex4)),ZC,'LineWidth',2,'color',MyColor(3,:));
plot(squeeze(RhoPrimeConventional(XIndex,:,TimeIndex5)),ZC,'LineWidth',2,'color',MyColor(4,:));

line([0 0],[-12 -1],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([-0.2 0.2 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;
MyAxe.YAxis.TickLabels='';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-0.15:0.15:0.15;
MyAxe.XAxis.MinorTickValues=-0.2:0.05:0.25;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$\rho''$ $[kg.m^{-3}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];

text(-0.15,-1.7,'$(f)$','fontsize',24,'Color','black','BackgroundColor','none');

MargineLeft=0.58;
MargineRight=0.26;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(100*squeeze(U(XIndex,:,TimeIndex1)),ZC,'LineWidth',2,'color',MyColor(1,:));
plot(100*squeeze(U(XIndex,:,TimeIndex2)),ZC,'LineWidth',2,'color',MyColor(2,:));
plot(100*squeeze(U(XIndex,:,TimeIndex4)),ZC,'LineWidth',2,'color',MyColor(3,:));
plot(100*squeeze(U(XIndex,:,TimeIndex5)),ZC,'LineWidth',2,'color',MyColor(4,:));

line([0 0],[-12 -1],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([-1 1 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;
MyAxe.YAxis.TickLabels='';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-0.5:0.5:0.5;
MyAxe.XAxis.MinorTickValues=-2:0.5:2;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$u$ $[cm$ $s^{-1}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];
text(0.35,-1.7,'$(g)$','fontsize',24,'Color','black','BackgroundColor','white');

MargineLeft=0.75;
MargineRight=0.09;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(1000*squeeze(W(XIndex,:,TimeIndex1)),ZC,'LineWidth',2,'color',MyColor(1,:));
plot(1000*squeeze(W(XIndex,:,TimeIndex2)),ZC,'LineWidth',2,'color',MyColor(2,:));
plot(1000*squeeze(W(XIndex,:,TimeIndex4)),ZC,'LineWidth',2,'color',MyColor(3,:));
plot(1000*squeeze(W(XIndex,:,TimeIndex5)),ZC,'LineWidth',2,'color',MyColor(4,:));

line([0 0],[-12 -1],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([-0.2 0.2 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;
MyAxe.YAxisLocation='right';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-0.1:0.1:0.1;
MyAxe.XAxis.MinorTickValues=-0.2:0.05:0.2;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$z$ $[m]$'},'fontsize',20);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)+0.03 LabelPos(2)];

MyLabel=xlabel('$w$ $[mm$ $s^{-1}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];
text(0.05,-1.7,'$(h)$','fontsize',24,'Color','black');

savefig(FIG,'C:\suntans\plots\WindStructureDetails');
saveas(FIG,'C:\suntans\plots\WindStructureDetails','epsc');
%%
%Figure 13- Profiles and TimeSeries in the presence of wind K1
clear all;
close all;
FIG=figure('position',[100 300 1000 600]);

TimeRange=3156+287;
TimeRange=86+1;
TimeIndex=2518;

Data=cell(4,1);
CaseNumber=4;
Address=strcat('C:\suntans\Result-',num2str(12090),'.mat');
Data{CaseNumber}=load(Address,'Eta','RhoPrimeConventional','U','Density','WBar','ConversionConventionalTimeAvrWBar','ConversionConventionalWBar','ConversionConventionalTimeAvrDepthIntWBar');
Data{CaseNumber}.Density=Data{CaseNumber}.Density(:,:,TimeRange-86:end-86);
Data{CaseNumber}.WBar=Data{CaseNumber}.WBar(:,:,TimeRange-86:end-86);
Data{CaseNumber}.ConversionConventionalWBar=Data{CaseNumber}.ConversionConventionalWBar(:,:,TimeRange-86:end-86);
Data{CaseNumber}.Eta=Data{CaseNumber}.Eta(:,TimeRange-86:end-86);
Data{CaseNumber}.RhoPrimeConventional=Data{CaseNumber}.RhoPrimeConventional(:,:,TimeRange-86:end-86);
Data{CaseNumber}.U=Data{CaseNumber}.U(:,:,TimeRange-86:end-86);

load(Address,'X','ZC','Time');
Time=Time(TimeRange:end);
Depth=repmat(ZC,1,size(X,1))'+squeeze(Data{4}.U(:,:,1))*0;
Depth=nanmin(Depth,[],2);

CaseNumber=1;
for counter=[12198 12202 12206]
    Address=strcat('C:\suntans\Result-',num2str(counter),'.mat');
    Data{CaseNumber}=load(Address,'Eta','RhoPrimeConventional','U','Density','WBar','ConversionConventionalTimeAvrWBar','ConversionConventionalWBar','ConversionConventionalTimeAvrDepthIntWBar');
       
    Data{CaseNumber}.ConversionConventionalWBar=Data{CaseNumber}.ConversionConventionalWBar(:,:,TimeRange:end);
    Data{CaseNumber}.Eta=Data{CaseNumber}.Eta(:,TimeRange:end);
    Data{CaseNumber}.RhoPrimeConventional=Data{CaseNumber}.RhoPrimeConventional(:,:,TimeRange:end);
    Data{CaseNumber}.U=Data{CaseNumber}.U(:,:,TimeRange:end);
    Data{CaseNumber}.Density=Data{CaseNumber}.Density(:,:,TimeRange:end);
    Data{CaseNumber}.WBar=Data{CaseNumber}.WBar(:,:,TimeRange:end);
    CaseNumber=CaseNumber+1;
end


for counter=1:4
    Data{counter}.UBar=Data{counter}.U;
    Data{counter}.UBar(isnan(Data{counter}.UBar))=0;
    Data{counter}.UBar=-repmat(trapz(-ZC,Data{counter}.UBar,2),1,size(ZC,1),1)./repmat(Depth,1,size(ZC,1),size(Time,1));
    Data{counter}.Uprime=Data{counter}.U-Data{counter}.UBar;
end


for counter=1:4
    Data{counter}.UBar=Data{counter}.U;
    Data{counter}.UBar(isnan(Data{counter}.UBar))=0;
    Data{counter}.UBar=-repmat(trapz(-ZC,Data{counter}.UBar,2),1,size(ZC,1),1)./repmat(Depth,1,size(ZC,1),size(Time,1));
    Data{counter}.Uprime=Data{counter}.U-Data{counter}.UBar;
end

[~,XIndex]=max(Data{4}.ConversionConventionalTimeAvrDepthIntWBar);
[~,ZIndex]=max(squeeze(Data{4}.ConversionConventionalTimeAvrWBar(XIndex,:)));
ZIndex=21;
Data{1}.PhaseLag=-18;
Data{2}.PhaseLag=102;
Data{3}.PhaseLag=222;

MargineTop=0.07;
MargineBot=0.15;
MargineLeft=0.12;
MargineRight=0.5;
SubplotSpac=0.02;
SubplotNumber=4;

SubplotCounter=4;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
WindPeriod=24*3600;
WindOmega=2*pi/WindPeriod;

plot(Time/3600,6*(1+sin(WindOmega*(Time-(360-Data{1}.PhaseLag)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-');
plot(Time/3600,6*(1+sin(WindOmega*(Time-(360-Data{2}.PhaseLag)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-');
plot(Time/3600,6*(1+sin(WindOmega*(Time-(360-Data{3}.PhaseLag)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-');
line([Time(TimeIndex)/3600 Time(TimeIndex)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);

axis([290 340 -0.5 6.5]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=0:03:6;
MyAxe.YAxis.MinorTickValues=0:1:6;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=300:10:330;
MyAxe.XAxis.MinorTickValues=290:2.5:340;

MyAxe.YAxis.TickLength=[0.03 0.03];
MyAxe.XAxis.TickLength=[0.03 0.03];
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'Wind';'$[m$ $s^{-1}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[283 LabelPos(2)];
text(292,1.5,'$(a)$','fontsize',24,'Color','black','BackgroundColor','white');

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(Time/3600,1e3*squeeze(Data{1}.WBar(XIndex,ZIndex,:)),'LineWidth',2,'LineStyle','-');
plot(Time/3600,1e3*squeeze(Data{2}.WBar(XIndex,ZIndex,:)),'LineWidth',2,'LineStyle','-');
plot(Time/3600,1e3*squeeze(Data{3}.WBar(XIndex,ZIndex,:)),'LineWidth',2,'LineStyle','-');
plot(Time/3600,1e3*squeeze(Data{4}.WBar(XIndex,ZIndex,:)),'LineWidth',2,'LineStyle','-');
line([0 500],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

scatter(Time(288)/3600,0.22,200,'p','filled','MarkerEdgeColor',[0.49 0.18 0.56],'MarkerFaceColor',[0.49 0.18 0.56]);
line([Time(TimeIndex)/3600 Time(TimeIndex)/3600],[-1 1],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);

axis([290 340 -0.9 0.9]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.6:0.6:0.6;
MyAxe.YAxis.MinorTickValues=-0.9:0.3:0.9;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=300:10:330;
MyAxe.XAxis.MinorTickValues=290:2.5:340;

MyAxe.YAxis.TickLength=[0.03 0.03];
MyAxe.XAxis.TickLength=[0.03 0.03];
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
 
MyYLabel=ylabel({'$W$';'$[mm$ $s^{-1}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[283 LabelPos(2)];
text(292,-0.5,'$(b)$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

plot(Time/3600,squeeze(Data{1}.RhoPrimeConventional(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/3600,squeeze(Data{2}.RhoPrimeConventional(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/3600,squeeze(Data{3}.RhoPrimeConventional(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/3600,squeeze(Data{4}.RhoPrimeConventional(XIndex,ZIndex,:)),'LineWidth',2);
line([0 500],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);
line([Time(TimeIndex)/3600 Time(TimeIndex)/3600],[-1 1],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);

axis([290 340 -0.25 0.3]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.20:0.20:0.20;
MyAxe.YAxis.MinorTickValues=-0.3:0.1:0.3;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=300:10:330;
MyAxe.XAxis.MinorTickValues=290:2.5:340;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.03 0.03];
MyAxe.XAxis.TickLength=[0.03 0.03];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$\rho''$';'$[kg.m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[283 LabelPos(2)];
text(292,-0.13,'$(c)$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

plot(Time/3600,10^3*squeeze(Data{1}.ConversionConventionalWBar(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/3600,10^3*squeeze(Data{2}.ConversionConventionalWBar(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/3600,10^3*squeeze(Data{3}.ConversionConventionalWBar(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/3600,10^3*squeeze(Data{4}.ConversionConventionalWBar(XIndex,ZIndex,:)),'LineWidth',2);
line([0 500],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);
line([Time(TimeIndex)/3600 Time(TimeIndex)/3600],[-2 2],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);

axis([290 340 -0.8 1.4]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-1:1:1;
MyAxe.YAxis.MinorTickValues=-0.9:0.3:1.5;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=300:10:330;
MyAxe.XAxis.MinorTickValues=290:2.5:340;

MyAxe.YAxis.TickLength=[0.03 0.03];
MyAxe.XAxis.TickLength=[0.03 0.03];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$Time$ $[Hour]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.4];

MyYLabel=ylabel({'$C$';'$[mW.m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[283 LabelPos(2)];
text(292,-0.4,'$(d)$','fontsize',24,'Color','black','BackgroundColor','none');


MargineLeft=0.52;
MargineRight=0.30;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(squeeze(Data{1}.RhoPrimeConventional(XIndex,:,TimeIndex)),ZC,'LineWidth',2);
plot(squeeze(Data{2}.RhoPrimeConventional(XIndex,:,TimeIndex)),ZC,'LineWidth',2);
plot(squeeze(Data{3}.RhoPrimeConventional(XIndex,:,TimeIndex)),ZC,'LineWidth',2);
plot(squeeze(Data{4}.RhoPrimeConventional(XIndex,:,TimeIndex)),ZC,'LineWidth',2);
line([0 0],[-15 -1],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([-0.05 0.22 -14 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-12:3:-3;
MyAxe.YAxis.MinorTickValues=-15:1:0;
MyAxe.YAxis.TickLabels='';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=0:0.2:0.2;
MyAxe.XAxis.MinorTickValues=0:0.05:0.3;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$\rho''$ $[kg.m^{-3}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];

lgd=legend('$-18^\circ$','$102^\circ$','$222^\circ$','NW','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1)+0.02 LGDPositio(2)+0.055 LGDPositio(3) LGDPositio(4)];
text(0.15,-2,'$(e)$','fontsize',24,'Color','black','BackgroundColor','none');

MargineLeft=0.72;
MargineRight=0.10;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(100*squeeze(Data{1}.Uprime(XIndex,:,TimeIndex)),ZC,'LineWidth',2);
plot(100*squeeze(Data{2}.Uprime(XIndex,:,TimeIndex)),ZC,'LineWidth',2);
plot(100*squeeze(Data{3}.Uprime(XIndex,:,TimeIndex)),ZC,'LineWidth',2);
plot(100*squeeze(Data{4}.Uprime(XIndex,:,TimeIndex)),ZC,'LineWidth',2);
line([0 0],[-15 -1],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([-1 1 -14 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-12:3:-3;
MyAxe.YAxis.MinorTickValues=-15:1:0;
MyAxe.YAxisLocation='right';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-0.5:1:0.5;
MyAxe.XAxis.MinorTickValues=-1:0.25:1;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$u''$ $[cm$ $s^{-1}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];

MyLabel=ylabel('$z$ $[m]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];

text(-0.7,-2,'$(f)$','fontsize',24,'Color','black');

savefig(FIG,'C:\suntans\plots\WindStructureK1');
saveas(FIG,'C:\suntans\plots\WindStructureK1','epsc');
%%
%Figure 14- Profiles and TimeSeries in the presence of wind M2
clear all;
close all;
FIG=figure('position',[100 300 1000 600]);

XIndex=474;
ZIndex=11;
TimeRange=3156+230;
TimeIndex=540;

TimeIndex=435;
CaseNumber=1;
Data=cell(4,1);
for counter=[12008 12010 12012 12081]
    Address=strcat('C:\suntans\Result-',num2str(counter),'.mat');
    Data{CaseNumber}=load(Address,'W','WBar','Eta','RhoPrimeConventional','U','ConversionConventionalWBar','ConversionConventionalTimeAvrWBar');
    Data{CaseNumber}.W=Data{CaseNumber}.W(:,:,TimeRange:end);
    Data{CaseNumber}.WBar=Data{CaseNumber}.WBar(:,:,TimeRange:end);
    Data{CaseNumber}.ConversionConventionalWBar=Data{CaseNumber}.ConversionConventionalWBar(:,:,TimeRange:end);
    Data{CaseNumber}.Eta=Data{CaseNumber}.Eta(:,TimeRange:end);
    Data{CaseNumber}.RhoPrimeConventional=Data{CaseNumber}.RhoPrimeConventional(:,:,TimeRange:end);
    Data{CaseNumber}.U=Data{CaseNumber}.U(:,:,TimeRange:end);
    CaseNumber=CaseNumber+1;
end

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

Data{1}.PhaseLag=-18;
Data{2}.PhaseLag=42;
Data{3}.PhaseLag=102;

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
WindPeriod=24*3600;
WindOmega=2*pi/WindPeriod;
DataPhaseLag=0;

plot(Time/3600,6*(1+sin(WindOmega*(Time-(360-Data{1}.PhaseLag)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-');
plot(Time/3600,6*(1+sin(WindOmega*(Time-(360-Data{2}.PhaseLag)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-');
plot(Time/3600,6*(1+sin(WindOmega*(Time-(360-Data{3}.PhaseLag)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-');

line([Time(TimeIndex)/3600,Time(TimeIndex)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);
% scatter(Time(387)/3600,6,150,'p','filled','MarkerEdgeColor',[0 0.45 0.74],'MarkerFaceColor',[0 0.45 0.74]);
% scatter(Time(411)/3600,6,150,'p','filled','MarkerEdgeColor',[0.93 0.69 0.13],'MarkerFaceColor',[0.93 0.69 0.13]);
% scatter(Time(435)/3600,6,150,'p','filled','MarkerEdgeColor',[0.85 0.33 0.10],'MarkerFaceColor',[0.85 0.33 0.10]);

axis([385 434 -0.5 6.5]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=0:03:6;
MyAxe.YAxis.MinorTickValues=0:1:6;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=395:15:425;
MyAxe.XAxis.MinorTickValues=385:2.5:434;

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'Wind';'$[m$ $s^{-1}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[375 LabelPos(2)];
text(424.9,4.5,'$(a)$','fontsize',24,'Color','black','BackgroundColor','white');

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(Time/3600,1e3*squeeze(Data{1}.WBar(XIndex,ZIndex,:)),'LineWidth',2,'LineStyle','-');
plot(Time/3600,1e3*squeeze(Data{2}.WBar(XIndex,ZIndex,:)),'LineWidth',2,'LineStyle','-');
plot(Time/3600,1e3*squeeze(Data{3}.WBar(XIndex,ZIndex,:)),'LineWidth',2,'LineStyle','-');
plot(Time/3600,1e3*squeeze(Data{4}.WBar(XIndex,ZIndex,:)),'LineWidth',2,'LineStyle','-');

line([385 434],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);
% scatter(Time(TimeIndex)/3600,-0.75,150,'p','filled','MarkerEdgeColor',[0.49 0.18 0.56],'MarkerFaceColor',[0.49 0.18 0.56]);
line([Time(TimeIndex)/3600,Time(TimeIndex)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);

axis([385 434 -1 1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.60:0.60:0.60;
MyAxe.YAxis.MinorTickValues=-0.90:0.30:0.90;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=395:15:425;
MyAxe.XAxis.MinorTickValues=385:2.5:434;

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$W$';'$[mm$ $s^{-1}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[375 LabelPos(2)];
text(424.9,0.5,'$(b)$','fontsize',24,'Color','black','BackgroundColor','white');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

plot(Time/3600,squeeze(Data{1}.RhoPrimeConventional(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/3600,squeeze(Data{2}.RhoPrimeConventional(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/3600,squeeze(Data{3}.RhoPrimeConventional(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/3600,squeeze(Data{4}.RhoPrimeConventional(XIndex,ZIndex,:)),'LineWidth',2);
line([385 434],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);
line([Time(TimeIndex)/3600,Time(TimeIndex)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);

axis([385 434 -0.25 0.3]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.2:0.20:0.20;
MyAxe.YAxis.MinorTickValues=-0.25:0.05:0.35;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=395:15:425;
MyAxe.XAxis.MinorTickValues=385:2.5:435;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$\rho''$';'$[kg.m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[375 LabelPos(2)];
text(424.9,0.17,'$(c)$','fontsize',24,'Color','black','BackgroundColor','white');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

plot(Time/3600,10^3*squeeze(Data{1}.ConversionConventionalWBar(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/3600,10^3*squeeze(Data{2}.ConversionConventionalWBar(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/3600,10^3*squeeze(Data{3}.ConversionConventionalWBar(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/3600,10^3*squeeze(Data{4}.ConversionConventionalWBar(XIndex,ZIndex,:)),'LineWidth',2);
line([385 434],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);
line([Time(TimeIndex)/3600,Time(TimeIndex)/3600],[-100 100],'LineWidth',3,'LineStyle','-','Color',0.4*[1 1 1]);

axis([385 434 -1.2 1.6]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-1:1:1;
MyAxe.YAxis.MinorTickValues=-1:0.25:2;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=395:15:425;
MyAxe.XAxis.MinorTickValues=385:2.5:434;

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$Time$ [Hour]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.6];

MyYLabel=ylabel({'$C$';'$[mW.m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[375 LabelPos(2)];
text(424.9,0.8,'$(d)$','fontsize',24,'Color','black','BackgroundColor','white');

MargineLeft=0.41;
MargineRight=0.43;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(squeeze(Data{1}.RhoPrimeConventional(XIndex,:,TimeIndex)),ZC,'LineWidth',2);
plot(squeeze(Data{2}.RhoPrimeConventional(XIndex,:,TimeIndex)),ZC,'LineWidth',2);
plot(squeeze(Data{3}.RhoPrimeConventional(XIndex,:,TimeIndex)),ZC,'LineWidth',2);
plot(squeeze(Data{4}.RhoPrimeConventional(XIndex,:,TimeIndex)),ZC,'LineWidth',2);
line([0 0],[-12 -1],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([-0.25 0.1 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;
MyAxe.YAxis.TickLabels='';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-0.15:0.15:0.15;
MyAxe.XAxis.MinorTickValues=-0.25:0.05:0.15;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$\rho''$ $[kg.m^{-3}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];

lgd=legend('$12^\circ$','$-48^\circ$','$-18^\circ$','NW','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1)+0.08 LGDPositio(2)+0.055 LGDPositio(3) LGDPositio(4)];
text(-0.2,-11,'$(e)$','fontsize',24,'Color','black','BackgroundColor','none');

MargineLeft=0.58;
MargineRight=0.26;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(100*squeeze(Data{1}.Uprime(XIndex,:,TimeIndex)),ZC,'LineWidth',2);
plot(100*squeeze(Data{2}.Uprime(XIndex,:,TimeIndex)),ZC,'LineWidth',2);
plot(100*squeeze(Data{3}.Uprime(XIndex,:,TimeIndex)),ZC,'LineWidth',2);
plot(100*squeeze(Data{4}.Uprime(XIndex,:,TimeIndex)),ZC,'LineWidth',2);
line([0 0],[-12 -1],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([-1.5 1.5 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.25:-1;
MyAxe.YAxis.TickLabels='';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-1:1:1;
MyAxe.XAxis.MinorTickValues=-3:0.5:2.5;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$u''$ $[cm$ $s^{-1}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];
text(0.4,-11,'$(f)$','fontsize',24,'Color','black');

MargineLeft=0.75;
MargineRight=0.09;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(1000*squeeze(Data{1}.W(XIndex,:,TimeIndex)),ZC,'LineWidth',2);
plot(1000*squeeze(Data{2}.W(XIndex,:,TimeIndex)),ZC,'LineWidth',2);
plot(1000*squeeze(Data{3}.W(XIndex,:,TimeIndex)),ZC,'LineWidth',2);
plot(1000*squeeze(Data{4}.W(XIndex,:,TimeIndex)),ZC,'LineWidth',2);
line([0 0],[-12 -1],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([-1.3 0 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;
MyAxe.YAxisLocation='right';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-1:1:0;
MyAxe.XAxis.MinorTickValues=-2.5:0.25:0;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$z$ $[m]$'},'fontsize',20);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)+0.01 LabelPos(2)];

MyLabel=xlabel('$w$ $[mm$ $s^{-1}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];
text(-0.4,-11,'$(g)$','fontsize',24,'Color','black');

savefig(FIG,'C:\suntans\plots\WindStructureM2');
saveas(FIG,'C:\suntans\plots\WindStructureM2','epsc');
%%
%Figure 15- Special tidal flow with 20 hours period
clear all;
clc;
close all;
FIG=figure('position',[100 100 600 400]);

MyColor=[ 0.85 0.325 0.098;...%red
    0.929 0.6941 0.1255;...%yellow
    0 0.447 0.741;...%blue
    0.49 0.18 0.56;...%purple
    0.30 0.75 0.93;...%light blue
    0.47 0.67 0.19];%green

RowCounter=1;
TideEspecialWind6=nan(12,1);
for j=489:500
    Address=strcat('C:\compressed\Result-',num2str(j+12000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    TideEspecialWind6(RowCounter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    RowCounter=RowCounter+1;
end

RowCounter=1;
K1Wind6=nan(12,1);
for j=197:208
    Address=strcat('C:\compressed\Result-',num2str(j+12000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    K1Wind6(RowCounter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    RowCounter=RowCounter+1;
end

RowCounter=1;
M2Wind6=nan(7,1);
for j=178:184
    Address=strcat('C:\compressed\Result-',num2str(j+12000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    M2Wind6(RowCounter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    RowCounter=RowCounter+1;
end

MargineTop=0.10;
MargineBot=0.25;
MargineLeft=0.18;
MargineRight=0.05;
SubplotSpac=0.05;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
PlotLgd=[];
PlotLgd(1)=plot(([-48:30:282]+48)/330,TideEspecialWind6,'-d','color',MyColor(6,:),'LineWidth',2,'MarkerSize',10);
PlotLgd(2)=plot(([-48:30:282]+48)/330,K1Wind6,'-s','color',MyColor(1,:),'LineWidth',2,'MarkerSize',10);
PlotLgd(3)=plot(([-48:30:126,126]+48)/174,M2Wind6,'-^','color',MyColor(3,:),'LineWidth',2,'MarkerSize',10);
line([0 1],[0 0],'linewidth',0.5,'color',0.7*[1 1 1]);

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
box on;

axis([0 1 0 1.5]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-1:0.1:1.5;
MyAxe.YAxis(1).TickValues=-0:0.6:1.2;

MyAxe.XAxis(1).MinorTick='on';
MyAxe.XAxis.TickValues=0.3:0.3:0.9;
MyAxe.XAxis(1).MinorTickValues=0:0.05:1;


MyAxe.YAxis.TickLength=[0.02 0.04];
MyAxe.XAxis.TickLength=[0.02 0.04];

lgd=legend(PlotLgd,'$20.0$ $H$','$23.9$ $H$','$12.4$ $H$','orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1) LGDPositio(2)+0.08 LGDPositio(3) LGDPositio(4)];
lgd.FontSize=12;

MyLabel=ylabel('$\widehat{\overline{\langle C \rangle}}$[$W.m^{-1}$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-0.03 LabelPos(2)];

MyLabel=xlabel('Normalized Wind-Tide Phase Lag $\frac{\phi_{wind,tide}}{360^\circ}$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.1];

savefig(FIG,'C:\suntans\plots\SpecialTideWindNonlinear');
saveas(FIG,'C:\suntans\plots\SpecialTideWindNonlinear','epsc');
%%
%Figure 16- Looking at the UPrime Time series and cyclic pattern of
%wind-tide phase lag
close all;
clear all;
clc;

FIG=figure('position',[100 50 1000 600]); 

CaseCell=cell(5,1);
counter=1;
for i=[48:7:76]
    Address=strcat('C:\suntans\Result-',num2str(i+12000),'.mat');
    CaseCell{counter}=load(Address,'X','ZC','WBar','ConversionConventionalWBar','RhoPrimeConventional','ConversionConventionalTimeAvrWBar','ConversionConventionalTimeAvrDepthIntWBar');
    CaseCell{counter}.WBar=CaseCell{counter}.WBar(:,:,end-600:end-150); 
    CaseCell{counter}.ConversionConventionalWBar=CaseCell{counter}.ConversionConventionalWBar(:,:,end-600:end-150);
    CaseCell{counter}.RhoPrimeConventional=CaseCell{counter}.RhoPrimeConventional(:,:,end-600:end-150);
    load(Address,'Time','ZC','X');
    Time=Time(end-600:end-150);
    counter=counter+1;
end

WindOmega=2*pi/24/3600;
WindPeriod=24*3600;

Speed=[0,1.5,3,4.5,6];
MyColor=[0.40 0.40 0.40;...%gray
    0.30 0.75 0.93;...%light blue
    0.47 0.67 0.19;%green
    0.49 0.18 0.56;...%purple
    0.64 0.08 0.18]%burgendy

MargineTop=0.07;
MargineBot=0.15;
MargineLeft=0.12;
MargineRight=0.5;
SubplotSpac=0.02;
SubplotNumber=4;
ZIndex=13;
XIndex=475;

SubplotCounter=4;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
MyAxe=gca;
MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=390:10:410;
MyAxe.XAxis.MinorTickValues=-384:421;
MyAxe.XAxis.TickLabels='';
MyAxe.XAxis.TickLength=[0.015 0.03];

counter=1
plot(Time(1:450)/3600,Speed(counter)*(1+sin(WindOmega*(Time(1:450)-(360-157)*WindPeriod/360)))/2,'LineWidth',3,'LineStyle',':','color',MyColor(counter,:));
for counter=2:5
    plot(Time(1:450)/3600,Speed(counter)*(1+sin(WindOmega*(Time(1:450)-(360-157)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-','color',MyColor(counter,:),'Marker', 'none');
end
axis([384 421 -0.4 6.4]);
set(gca,'fontsize',16);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=0:3:6;
MyAxe.YAxis.MinorTickValues=0:1:6;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=390:10:410;
MyAxe.XAxis.MinorTickValues=-384:421;
MyAxe.XAxis.TickLabels='';

MyAxe.YAxis.TickLength=[0.015 0.03];
MyAxe.YAxis.Color='black';
MyAxe.XAxis.TickLength=[0.015 0.03];

MyLabel=ylabel({'XS Wind'; '[$m.s^{-1}$]'},'fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[378.5 LabelPos(2)];

text(385,5,'$(a)$','fontsize',24,'Color','black');
lgd=legend('No Wind','$1.5 \frac{m}{s}$','$3 \frac{m}{s}$','$4.5 \frac{m}{s}$','$6 \frac{m}{s}$'...
    ,'Orientation','horizontal','Location','northoutside');
lgd.FontSize=14;
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1)+0.25 LGDPositio(2)+0.05 LGDPositio(3) LGDPositio(4)];

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
plot(Time(1:450)/3600,1000*squeeze(CaseCell{1}.WBar(XIndex,ZIndex,1:450)),'LineWidth',3,'LineStyle',':','color',MyColor(1,:));
for counter=2:5
    plot(Time(1:450)/3600,1000*squeeze(CaseCell{counter}.WBar(XIndex,ZIndex,1:450)),'LineWidth',2,'LineStyle','-','Color',MyColor(counter,:));
end
line([384 421],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);
axis([384 421 -0.6 0.6]);
set(gca,'fontsize',16);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.4:0.4:0.4;
MyAxe.YAxis.MinorTickValues=-0.6:0.1:0.6;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=390:10:410;
MyAxe.XAxis.MinorTickValues=-384:421;
MyAxe.XAxis.TickLabels='';

MyAxe.YAxis.TickLength=[0.015 0.03];
MyAxe.XAxis.TickLength=[0.015 0.03];

MyLabel=ylabel({'$W$';'[$mm.s^{-1}$]'},'fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[378.5 LabelPos(2)];

text(385,-0.4,'$(b)$','fontsize',24,'Color','black');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
plot(Time(1:450)/3600,squeeze(CaseCell{1}.RhoPrimeConventional(XIndex,ZIndex,1:450)),'LineWidth',3,'LineStyle',':','color',MyColor(1,:));
for counter=2:5
    plot(Time(1:450)/3600,squeeze(CaseCell{counter}.RhoPrimeConventional(XIndex,ZIndex,1:450)),'LineWidth',2,'LineStyle','-','color',MyColor(counter,:));
end
line([384 421],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);
axis([384 421 -0.2 0.25]);
set(gca,'fontsize',16);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=0:0.2:0.2;
MyAxe.YAxis.MinorTickValues=-0.2:0.05:0.35;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=390:10:410;
MyAxe.XAxis.MinorTickValues=-384:421;
MyAxe.XAxis.TickLabels='';

MyAxe.YAxis.TickLength=[0.015 0.03];
MyAxe.XAxis.TickLength=[0.015 0.03];

MyLabel=ylabel({'$\rho''$';'[$kg.m^{-3}$]'},'fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[378.5 LabelPos(2)];

text(385,-0.10,'$(c)$','fontsize',24,'Color','black');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
plot(Time(1:450)/3600,1000*squeeze(CaseCell{1}.ConversionConventionalWBar(XIndex,ZIndex,1:450)),'LineWidth',3,'LineStyle',':','color',MyColor(1,:));
for counter=2:5
    plot(Time(1:450)/3600,1000*squeeze(CaseCell{counter}.ConversionConventionalWBar(XIndex,ZIndex,1:450)),'LineWidth',2,'LineStyle','-','color',MyColor(counter,:));
end
line([384 421],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);
axis([384 421 -0.5 1]);
set(gca,'fontsize',16);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=0:0.8:0.8;
MyAxe.YAxis.MinorTickValues=-0.4:0.2:1;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=390:10:410;
MyAxe.XAxis.MinorTickValues=-384:421;

MyAxe.YAxis.TickLength=[0.015 0.03];
MyAxe.XAxis.TickLength=[0.015 0.03];

MyLabel=ylabel({'$C$';'[$mW.m^{-3}$]'},'fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[378.5 LabelPos(2)];

text(385,0.7,'$(d)$','fontsize',24,'Color','black');

MyLabel=xlabel('Time [Hour]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.3];

MargineLeft=0.52;
MargineRight=0.30;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

counter=1
plot(squeeze(CaseCell{counter}.RhoPrimeConventional(XIndex,:,180)),ZC,'LineWidth',3,'LineStyle',':','color',MyColor(1,:));
for counter=2:5
    plot(squeeze(CaseCell{counter}.RhoPrimeConventional(XIndex,:,180)),ZC,'LineWidth',2,'LineStyle','-','color',MyColor(counter,:));
end
line([0 0],[-12 -1],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([-0.05 0.25 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;
MyAxe.YAxis.TickLabels='';
MyAxe.YAxisLocation='right';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=0:0.2:0.2;
MyAxe.XAxis.MinorTickValues=0:0.05:25;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$\rho''$ $[kg.$ $m^{-3}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];
text(0.15,-1.7,'$(e)$','fontsize',24,'Color','black');

MargineLeft=0.72;
MargineRight=0.10;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

counter=1
plot(1000*squeeze(CaseCell{counter}.ConversionConventionalWBar(XIndex,:,180)),ZC,'LineWidth',3,'LineStyle',':','color',MyColor(1,:));
for counter=2:5
    plot(1000*squeeze(CaseCell{counter}.ConversionConventionalWBar(XIndex,:,180)),ZC,'LineWidth',2,'LineStyle','-','color',MyColor(counter,:));
end
line([0 0],[-12 -1],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([-0.1 0.8 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;
MyAxe.YAxisLocation='right';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=0:0.5:0.5;
MyAxe.XAxis.MinorTickValues=0:0.1:0.8;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$z$ $[m]$'},'fontsize',20);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)+0.01 LabelPos(2)];

MyLabel=xlabel('$C$ $[mW.$ $m^{-3}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];
text(0.5,-1.7,'$(f)$','fontsize',24,'Color','black');

savefig(FIG,'C:\suntans\plots\WindSpeedM2K1');
saveas(FIG,'C:\suntans\plots\WindSpeedM2K1','epsc');
%%
%Figure 17- Conversion at different wind lag
clear all;
clc;
close all;
FIG=figure('position',[100 100 800 800]);

MargineTop=0.10;
MargineBot=0.14;
MargineLeft=0.12;
MargineRight=0.64;
SubplotSpac=0.02;
SubplotNumber=3;

MyColor=[0.47 0.67 0.19;...%green
    0.64 0.08 0.18];%burgendy

%left
SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('C:\compressed\Result-12000.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%M2K1 7.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    if j==0
        PlotColor=MyColor(1,:);
    else
        PlotColor=MyColor(2,:);
    end
    for i=147:158%M2K1 7.5 m and 3 to 6 wind
        Address=strcat('C:\compressed\Result-',num2str(j*12+i+12000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot(-48:30:282,CaseValue-Baseline,'-s','color',PlotColor,'LineWidth',2,'MarkerSize',6);
end

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-48 282 -0.3 0.6]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-0.4:0.1:1;
MyAxe.YAxis(1).TickValues=-0:0.4:1;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-48:30:282;
MyAxe.XAxis.TickValues=-48+30:90:282;

MyAxe.YAxis.TickLength=[0.03 0.04];
MyAxe.XAxis.TickLength=[0.03 0.04];

set(gca,'XTickLabel','');
line([-48,282],[0 0],'LineStyle',':','color','black');
lgd=legend('$3$ $m.s^{-1}$','$6$ $m.s^{-1}$','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1)+0.32 LGDPositio(2)+0.09 LGDPositio(3) LGDPositio(4)];
lgd.FontSize=14;
box on;
text(76,0.1,num2str(Baseline,'%2.2g'),'fontsize',18,'Color','black','background','none');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('C:\compressed\Result-12094.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%M2K1 12.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    if j==0
        PlotColor=MyColor(1,:);
    else
        PlotColor=MyColor(2,:);
    end    
    for i=209:220%M2K1 12.5 m and 3 to 6 wind
        Address=strcat('C:\compressed\Result-',num2str(j*12+i+12000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot(-48:30:282,CaseValue-Baseline,'-s','color',PlotColor,'LineWidth',2,'MarkerSize',6);
end

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-48 282 -0.6 0.5]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-1.2:0.1:1;
MyAxe.YAxis(1).TickValues=-0.4:0.4:0.4;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-48:30:282;
MyAxe.XAxis.TickValues=-48+30:90:282;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.03 0.04];
MyAxe.XAxis.TickLength=[0.03 0.04];

line([-48,282],[0 0],'LineStyle',':','color','black');
box on;
text(76,0.1,num2str(Baseline,'%2.2g'),'fontsize',18,'Color','black','background','none');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('C:\compressed\Result-12101.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%M2K1 17.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    if j==0
        PlotColor=MyColor(1,:);
    else
        PlotColor=MyColor(2,:);
    end    
    for i=395:406%M2K1 17.5 m and 3 to 6 wind
        Address=strcat('C:\compressed\Result-',num2str(j*12+i+12000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot(-48:30:282,CaseValue-Baseline,'-s','color',PlotColor,'LineWidth',2,'MarkerSize',6);
end

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-48 282 -0.3 0.6]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-1.2:0.1:1;
MyAxe.YAxis(1).TickValues=-0.4:0.4:0.4;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-48:30:282;
MyAxe.XAxis.TickValues=-48+30:90:282;

MyAxe.YAxis.TickLength=[0.03 0.04];
MyAxe.XAxis.TickLength=[0.03 0.04];

line([-48,282],[0 0],'LineStyle',':','color','black');
box on;
text(76,0.1,num2str(Baseline,'%2.2g'),'fontsize',18,'Color','black','background','none');

%Middle
MargineLeft=0.42;
MargineRight=0.34;
SubplotNumber=3;

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('C:\compressed\Result-12088.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%K1 7.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,-1]
    CaseNumber=[];
    CaseValue=[];
    if j==0
        PlotColor=MyColor(1,:);
    else
        PlotColor=MyColor(2,:);
    end     
    for i=33:44%K1 7.5 m and 3 to 6 wind
        Address=strcat('C:\compressed\Result-',num2str(j*12+i+12000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot(-48:30:282,CaseValue-Baseline,'-s','color',PlotColor,'LineWidth',2,'MarkerSize',6);
end

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-48 282 -0.2 0.5]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-1:0.1:1.2;
MyAxe.YAxis(1).TickValues=-0.4:0.4:0.4;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-48:30:282;
MyAxe.XAxis.TickValues=-48+30:90:282;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.03 0.04];
MyAxe.XAxis.TickLength=[0.03 0.04];

line([-48,282],[0 0],'LineStyle',':','color','black');
box on;
text(76,0.1,num2str(Baseline,'%2.2g'),'fontsize',18,'Color','black','background','none');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('C:\compressed\Result-12090.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%K1 12.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    if j==0
        PlotColor=MyColor(1,:);
    else
        PlotColor=MyColor(2,:);
    end     
    for i=185:196%K1 12.5 m and 3 to 6 wind
        Address=strcat('C:\compressed\Result-',num2str(j*12+i+12000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot(-48:30:282,CaseValue-Baseline,'-s','color',PlotColor,'LineWidth',2,'MarkerSize',6);
end

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-48 282 -0.3 0.7]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-1.4:0.1:1.4;
MyAxe.YAxis(1).TickValues=-0.4:0.4:0.4;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-48:30:282;
MyAxe.XAxis.TickValues=-48+30:90:282;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.03 0.04];
MyAxe.XAxis.TickLength=[0.03 0.04];

line([-48,282],[0 0],'LineStyle',':','color','black');
box on;
text(76,0.1,num2str(Baseline,'%2.2g'),'fontsize',18,'Color','black','background','none');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('C:\compressed\Result-12092.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%K1 17.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    if j==0
        PlotColor=MyColor(1,:);
    else
        PlotColor=MyColor(2,:);
    end     
    for i=371:382%K1 17.5 m and 3 to 6 wind
        Address=strcat('C:\compressed\Result-',num2str(j*12+i+12000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot(-48:30:282,CaseValue-Baseline,'-s','color',PlotColor,'LineWidth',2,'MarkerSize',6);
end

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-49 282 -0.3 0.8]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-1:0.1:1.2;
MyAxe.YAxis(1).TickValues=-0:0.5:0.5;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-48:30:282;
MyAxe.XAxis.TickValues=-48+30:90:282;

MyAxe.YAxis.TickLength=[0.03 0.04];
MyAxe.XAxis.TickLength=[0.03 0.04];

line([-48,282],[0 0],'LineStyle',':','color','black');
box on;
text(76,0.25,num2str(Baseline,'%2.2g'),'fontsize',18,'Color','black','background','none');

MyLabel=ylabel('$\widehat{\langle\overline{C} \rangle}$ Difference [$W.m^{-1}$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-430 LabelPos(2)+1.2];

MyLabel=xlabel('$\phi_{Wind, Tide}$ [$^\circ$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.15];

%Right
MargineLeft=0.72;
MargineRight=0.10;
SubplotNumber=3;

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('C:\compressed\Result-12081.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%M2 7.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,-1]
    CaseNumber=[];
    CaseValue=[];
    if j==0
        PlotColor=MyColor(1,:);
    else
        PlotColor=MyColor(2,:);
    end     
    for i=14:20%M2 7.5 m and 3 to 6 wind
        Address=strcat('C:\compressed\Result-',num2str(j*7+i+12000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([-48:30:102,126],CaseValue-Baseline,'-s','color',PlotColor,'LineWidth',2,'MarkerSize',6);
end

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-48 126 -0.05 0.25]);

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.MinorTickValues=-0.1:0.05:0.5;
MyAxe.YAxis.TickValues=0:0.2:0.4;

line([-48,250],[0 0],'LineStyle',':','color','black');

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-48:30:126;
MyAxe.XAxis.TickValues=-48+30:60:126;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.03 0.04];
MyAxe.XAxis.TickLength=[0.03 0.04];

box on;
text(20,0.05,num2str(Baseline,'%2.2g'),'fontsize',18,'Color','black','background','none');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('C:\compressed\Result-12083.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%M2 12.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    if j==0
        PlotColor=MyColor(1,:);
    else
        PlotColor=MyColor(2,:);
    end     
    for i=171:177%M2 12.5 m and 3 to 6 wind
        Address=strcat('C:\compressed\Result-',num2str(j*7+i+12000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([-48:30:102,126],CaseValue-Baseline,'-s','color',PlotColor,'LineWidth',2,'MarkerSize',6);
end

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-48 126 -0.02 0.18]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.MinorTickValues=-0.02:0.01:0.18;
MyAxe.YAxis.TickValues=0:0.1:0.16;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-48:30:126;
MyAxe.XAxis.TickValues=-48+30:60:126;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.03 0.04];
MyAxe.XAxis.TickLength=[0.03 0.04];

line([-48,126],[0 0],'LineStyle',':','color','black');
box on;
text(20,0.02,num2str(Baseline,'%2.2g'),'fontsize',18,'Color','black','background','none');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('C:\compressed\Result-12085.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%M2 17.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    if j==0
        PlotColor=MyColor(1,:);
    else
        PlotColor=MyColor(2,:);
    end     
    for i=357:363%M2 17.5 m and 3 to 6 wind
        Address=strcat('C:\compressed\Result-',num2str(j*7+i+12000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([-48:30:102,126],CaseValue-Baseline,'-s','color',PlotColor,'LineWidth',2,'MarkerSize',6);
end

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-48 126 -0.04 0.30]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.MinorTickValues=0:0.025:0.3;
MyAxe.YAxis.TickValues=0:0.1:0.2;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-48:30:126;
MyAxe.XAxis.TickValues=-48+30:60:126;

MyAxe.YAxis.TickLength=[0.03 0.04];
MyAxe.XAxis.TickLength=[0.03 0.04];

line([-48,126],[0 0],'LineStyle',':','color','black');
box on;
text(20,0.03,num2str(Baseline,'%2.2g'),'fontsize',18,'Color','black','background','none');

text(130,0.85,'$7.50$ $m$','fontsize',18,'Color','black','background','none');
text(130,0.50,'$12.5$ $m$','fontsize',18,'Color','black','background','none');
text(130,0.11,'$17.5$ $m$','fontsize',18,'Color','black','background','none');

text(-546,1.06,'$M_2K_1$','fontsize',18,'Color','black','background','none');
text(-233,1.06,'$K_1$','fontsize',18,'Color','black','background','none');
text(26,1.06,'$M_2$','fontsize',18,'Color','black','background','none');

text(-525,1,'$(a)$','fontsize',18,'Color','black','background','none');
text(-525,0.63,'$(b)$','fontsize',18,'Color','black','background','none');
text(-525,0.26,'$(c)$','fontsize',18,'Color','black','background','none');

text(-243,1,'$(d)$','fontsize',18,'Color','black','background','none');
text(-243,0.63,'$(e)$','fontsize',18,'Color','black','background','none');
text(-243,0.26,'$(f)$','fontsize',18,'Color','black','background','none');

text(-30,1,'$(g)$','fontsize',18,'Color','black','background','none');
text(-30,0.63,'$(h)$','fontsize',18,'Color','black','background','none');
text(-30,0.26,'$(i)$','fontsize',18,'Color','black','background','none');


savefig(FIG,'C:\suntans\plots\ConversionWindLag');
saveas(FIG,'C:\suntans\plots\ConversionWindLag','epsc');