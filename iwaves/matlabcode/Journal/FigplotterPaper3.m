close all;
clear all;
clc

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');  
cd('D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\');
%%
%Figure 1- Wind record
clc;
clear all;
close all;

FIG=figure('position',[100 50 800 600]); 
MyColor=[ 0.85 0.325 0.098;...%red
    0.929 0.6941 0.1255;...%yellow
    0 0.447 0.741;...%blue
    0.47 0.67 0.19];%green

MargineTop=0.07;
MargineBot=0.12;
MargineLeft=0.12;
MargineRight=0.45;
SubplotSpac=0.18;
SubplotNumber=2;

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

SubplotCounter=2;
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

text(0.12,1.35,'$a$','Interpreter','latex','Fontsize',24);
set(gca,'FontWeight','bold');

MargineTop=0.07;
MargineBot=0.12;
MargineLeft=0.55;
MargineRight=0.05;
SubplotSpac=0.18;
SubplotNumber=2;

SubplotCounter=2;
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

MargineLeft=0.12;
MargineRight=0.05;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;

plot(Time,movmean(East,6*5),'color',0*[1 1 1],'LineWidth',1,'LineStyle','-');
plot(Time,movmean(North,6*5),'color',0.5*[1 1 1],'LineWidth',1,'LineStyle','-');
line([152 182],[0 0],'color',0.4*[1 1 1],'LineWidth',0.05);
box on;
set(gca,'fontsize',16);
axis([152 182 -4 8]);
MyYLabel=ylabel('Wind Speed $[m$ $s^{-1}]$','fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-1 LabelPos(2)];

MyYLabel=xlabel('Time [day of year]','fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1) LabelPos(2)];

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-4:4:4;
MyAxe.YAxis.MinorTickValues=-8:8;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=160:10:180;
MyAxe.XAxis.MinorTickValues=152:182;

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];

text(153.1,6.5,'$c$','Interpreter','latex','Fontsize',24);
text(170,25.5,'$b$','Interpreter','latex','Fontsize',24);
set(gca,'FontWeight','bold');

lgd=legend('East-West','North-South','Orientation','horizontal','Location','northeastoutside');
lgd.FontSize=16;
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1) LGDPositio(2)+0.07 LGDPositio(3) LGDPositio(4)];

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\WindRecords');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\WindRecords','epsc');
%%
%Fig 2-Two layered system due to XS wind
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

FIG=figure('position',[100 50 800 800]); 

CaseCell=cell(8,1);
counter=1;
for i=[240:246,82]
    Address=strcat('G:\Paper2and3\Result-',num2str(i+110000),'.mat');
    CaseCell{counter}=load(Address,'X','ZC','Density','RhoBConventional','U','UBar','ConversionConventionalTimeAvrWBar','ConversionConventionalTimeAvrDepthIntWBar');
    CaseCell{counter}.U=CaseCell{counter}.U(:,:,end-600:end);
    CaseCell{counter}.UBar=CaseCell{counter}.UBar(:,:,end-600:end);
    CaseCell{counter}.UPrime=CaseCell{counter}.U-CaseCell{counter}.UBar;
    CaseCell{counter}.Density=CaseCell{counter}.Density(:,:,end-600:end);
    CaseCell{counter}.RhoBConventional=CaseCell{counter}.RhoBConventional(:,:,1);
    load(Address,'Time','ZC','X','Eta');
    Time=Time(end-600:end);
    Eta=Eta(:,end-600:end);
    counter=counter+1;
end

WindOmega=2*pi/24/3600;
WindPeriod=24*3600;

InitialPhase=[-48,-18,12,42,72,102,126];

MargineTop=0.05;
MargineBot=0.72;
MargineLeft=0.10;
MargineRight=0.10;
SubplotSpac=0.18;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
PlotLegend=[];
for counter=1:7
    PlotLegend(counter)=plot(Time/3600,6*(1+sin(WindOmega*(Time-(360-InitialPhase(counter))*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-','color',MyColor(counter,:));
end
MyYLabel=xlabel('Time [Hour]','fontsize',16);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1) LabelPos(2)-1];

MyYLabel=ylabel('XS Wind [$m$ $s^{-1}$]','fontsize',16);
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

text(396.5,5.5,'$a$','fontsize',24,'Color','black');

yyaxis right;
PlotLegend(8)=plot(Time/3600,squeeze(Eta(10,end-600:end)),':','LineWidth',3,'color',0.4*[1 1 1]);
axis([395 425 -0.6 0.6]);
line([395 425],[0 0],'linewidth',0.5,'color',0.7*[1 1 1]);
line([410 410],[0.6 -0.6],'linewidth',0.5,'color',0.7*[1 1 1]);
line([415.3 415.3],[0.6 -0.6],'linewidth',0.5,'color',0.7*[1 1 1]);

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

legendlabel=cell(8,1);
for counter=1:7
    legendlabel{counter}=num2str(InitialPhase(counter));
end
legendlabel{8}='NW';
lgd=legend(PlotLegend,legendlabel,'Orientation','horizontal','Location','northeastoutside');
lgd.FontSize=14;
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1)-0.03 LGDPositio(2)+0.045 LGDPositio(3) LGDPositio(4)];

box on;
set(gca,'fontsize',16);

%The vertical structures
MargineTop=0.38;
MargineBot=0.10;
MargineLeft=0.10+0*0.20+0*0.01;
MargineRight=1-(MargineLeft+0.20);
SubplotSpac=0.18;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);

hold on;
for counter=1:7
    plot(squeeze(CaseCell{counter}.UPrime(200,:,315)),ZC,'LineWidth',2);
end
plot(squeeze(CaseCell{8}.UPrime(200,:,315)),ZC,':','LineWidth',3,'color',0.4*[1 1 1]);
line([0 0],[-75.5 -1],'linewidth',0.5,'color',0.5*[1 1 1]);
box on;
set(gca,'fontsize',16);
MyLabel=xlabel('$u''$ [$m$ $s^{-1}$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)+0.15 LabelPos(2)+4];
ylabel('Z $[m]$','fontsize',18);
axis([-0.1 0.2 -75 -1]);

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-60:20:-20;
MyAxe.YAxis.MinorTickValues=-75:5:0;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-0.1:0.1:0.1;
MyAxe.XAxis.MinorTickValues=-0.2:0.05:0.2;

MyAxe.YAxis.TickLength=[0.015 0.03];
MyAxe.XAxis.TickLength=[0.015 0.03];

text(0.15,-35,'$b$','fontsize',24,'Color','black');

MargineLeft=0.10+0.20*1+0.01;
MargineRight=1-(MargineLeft+0.20);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);

hold on;
for counter=1:7
    plot(squeeze(CaseCell{counter}.UPrime(200,:,378)),ZC,'LineWidth',2);
end
plot(squeeze(CaseCell{8}.UPrime(200,:,378)),ZC,':','LineWidth',3,'color',0.4*[1 1 1]);
line([0 0],[-75.5 -1],'linewidth',0.5,'color',0.5*[1 1 1]);
box on;
set(gca,'fontsize',16);
axis([-0.2 0.15 -75 -1]);

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-60:20:-20;
MyAxe.YAxis.MinorTickValues=-75:5:0;
MyAxe.YAxis.TickLabels='';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-0.1:0.1:0.1;
MyAxe.XAxis.MinorTickValues=-0.2:0.05:0.2;

MyAxe.YAxis.TickLength=[0.015 0.03];
MyAxe.XAxis.TickLength=[0.015 0.03];

text(-0.18,-35,'$c$','fontsize',24,'Color','black');

MargineLeft=0.10+0.20*2+0.01*2+0.05;
MargineRight=1-(MargineLeft+0.20);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);

hold on;
for counter=1:7
    plot(squeeze(CaseCell{counter}.UPrime(475,:,315)),ZC,'LineWidth',2);
end
plot(squeeze(CaseCell{8}.UPrime(475,:,315)),ZC,':','LineWidth',3,'color',0.4*[1 1 1]);
line([0 0],[-11.5 -1],'linewidth',0.5,'color',0.5*[1 1 1]);
box on;
set(gca,'fontsize',16);
MyLabel=xlabel('$u''$ [$m$ $s^{-1}$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)+0.04 LabelPos(2)+0.5];
axis([-0.03 0.03 -11.5 -1]);

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-9:3:-1;
MyAxe.YAxis.MinorTickValues=-11.5:0.5:-1;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-0.02:0.02:0.02;
MyAxe.XAxis.MinorTickValues=-0.05:0.005:0.05;

MyAxe.YAxis.TickLength=[0.015 0.03];
MyAxe.XAxis.TickLength=[0.015 0.03];

text(0.02,-6,'$d$','fontsize',24,'Color','black');

MargineLeft=0.10+0.20*3+0.01*3+0.05;
MargineRight=1-(MargineLeft+0.20);

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);

hold on;
for counter=1:7
    plot(squeeze(CaseCell{counter}.UPrime(475,:,378)),ZC,'LineWidth',2);
end
plot(squeeze(CaseCell{8}.UPrime(475,:,378)),ZC,':','LineWidth',3,'color',0.4*[1 1 1]);
line([0 0],[-11.5 -1],'linewidth',0.5,'color',0.5*[1 1 1]);
box on;
set(gca,'fontsize',16);
axis([-0.05 0.04 -11.5 -1]);

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-9:3:-1;
MyAxe.YAxis.MinorTickValues=-11.5:0.5:-1;
MyAxe.YAxis.TickLabels='';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-0.03:0.03:0.03;
MyAxe.XAxis.MinorTickValues=-0.05:0.01:0.04;

MyAxe.YAxis.TickLength=[0.015 0.03];
MyAxe.XAxis.TickLength=[0.015 0.03];

text(-0.04,-6,'$e$','fontsize',24,'Color','black');

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\WindTwoLayered');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\WindTwoLayered','epsc');
%%
%Figure 3- Details of Conversion at different pycnocline with various wind
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

    Address=strcat('G:\Paper2and3\Result-1100',num2str(counter),'.mat');
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
text(44.25,200,'$0$ $m$ $s^{-1}$','Fontsize',18);

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

    Address=strcat('G:\Paper2and3\Result-1100',num2str(counter),'.mat');
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
text(44.25,200,'$1.5$ $m$ $s^{-1}$','Fontsize',18);

MargineLeft=0.10+2*0.15+2*0.01;
MargineRight=1-(MargineLeft+0.15);

for counter=65:-1:59
    SubplotCounter=counter-58;
    subplot1=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
    set(gca, 'Color', 0.5*[1 1 1]);
    hold on;

    Address=strcat('G:\Paper2and3\Result-1100',num2str(counter),'.mat');
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
text(44.25,200,'$3$ $m$ $s^{-1}$','Fontsize',18);

MargineLeft=0.10+3*0.15+3*0.01;
MargineRight=1-(MargineLeft+0.15);

for counter=72:-1:66
    SubplotCounter=counter-65;
    subplot1=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
    set(gca, 'Color', 0.5*[1 1 1]);
    hold on;

    Address=strcat('G:\Paper2and3\Result-1100',num2str(counter),'.mat');
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
text(44.25,200,'$4.5$ $m$ $s^{-1}$','Fontsize',18);

MargineLeft=0.10+4*0.15+4*0.01;
MargineRight=1-(MargineLeft+0.15);

for counter=79:-1:73
    SubplotCounter=counter-72;
    subplot1=subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
    set(gca, 'Color', 0.5*[1 1 1]);
    hold on;

    Address=strcat('G:\Paper2and3\Result-1100',num2str(counter),'.mat');
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
text(44.25,200,'$6$ $m$ $s^{-1}$','Fontsize',18);

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

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\PycnoWindSpeedConversion');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\PycnoWindSpeedConversion','epsc');
%%
%Figure 4- Profiles and TimeSeries in the presence of wind K1
clear all;
close all;
FIG=figure('position',[100 300 1000 600]);

XIndex=475;
ZIndex=34;
TimeRange=3156+287;
TimeIndex=540;

CaseNumber=1;
Data=cell(4,1);
for counter=[110026 110021 110023]
    Address=strcat('G:\Paper2and3\Result-',num2str(counter),'.mat');
    Data{CaseNumber}=load(Address,'Eta','RhoPrimeConventional','U','W','WBar','ConversionConventionalTimeAvrWBar','ConversionConventionalWBar');
    Data{CaseNumber}.ConversionConventionalWBar=Data{CaseNumber}.ConversionConventionalWBar(:,:,TimeRange:end);
    Data{CaseNumber}.Eta=Data{CaseNumber}.Eta(:,TimeRange:end);
    Data{CaseNumber}.RhoPrimeConventional=Data{CaseNumber}.RhoPrimeConventional(:,:,TimeRange:end);
    Data{CaseNumber}.U=Data{CaseNumber}.U(:,:,TimeRange:end);
    Data{CaseNumber}.W=Data{CaseNumber}.W(:,:,TimeRange:end);
    Data{CaseNumber}.WBar=Data{CaseNumber}.WBar(:,:,TimeRange:end);
    CaseNumber=CaseNumber+1;
end

Address=strcat('G:\Paper2and3\Result-',num2str(110088),'.mat');
Data{CaseNumber}=load(Address,'Eta','RhoPrimeConventional','U','W','WBar','ConversionConventionalTimeAvrWBar','ConversionConventionalWBar');
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

plot(Time/3600,6*(1+sin(WindOmega*(Time-(360-Data{1}.PhaseLag)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-');
plot(Time/3600,6*(1+sin(WindOmega*(Time-(360-Data{2}.PhaseLag)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-');
plot(Time/3600,6*(1+sin(WindOmega*(Time-(360-Data{3}.PhaseLag)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-');

scatter(Time(257)/3600,6,200,'p','filled','MarkerEdgeColor',[0 0.45 0.74],'MarkerFaceColor',[0 0.45 0.74]);
scatter(Time(377)/3600,6,200,'p','filled','MarkerEdgeColor',[0.85 0.33 0.1],'MarkerFaceColor',[0.85 0.33 0.10]);
scatter(Time(329)/3600,6,200,'p','filled','MarkerEdgeColor',[0.93 0.69 0.13],'MarkerFaceColor',[0.93 0.69 0.13]);

axis([386 433 -0.5 6.5]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=0:03:6;
MyAxe.YAxis.MinorTickValues=0:1:6;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=400:15:430;
MyAxe.XAxis.MinorTickValues=390:5:430;

MyAxe.YAxis.TickLength=[0.03 0.03];
MyAxe.XAxis.TickLength=[0.03 0.03];
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'Wind';'$[m$ $s^{-1}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-4.5 LabelPos(2)];
text(388.5,0.8,'$a$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=4;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(Time/3600,1e3*squeeze(Data{1}.WBar(XIndex,ZIndex,:)),'LineWidth',2,'LineStyle','-');
plot(Time/3600,1e3*squeeze(Data{2}.WBar(XIndex,ZIndex,:)),'LineWidth',2,'LineStyle','-');
plot(Time/3600,1e3*squeeze(Data{3}.WBar(XIndex,ZIndex,:)),'LineWidth',2,'LineStyle','-');
plot(Time/3600,1e3*squeeze(Data{4}.WBar(XIndex,ZIndex,:)),'LineWidth',2,'LineStyle','-');
line([386 433],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

scatter(Time(288)/3600,0.362,200,'p','filled','MarkerEdgeColor',[0.49 0.18 0.56],'MarkerFaceColor',[0.49 0.18 0.56]);
% 
axis([386 433 -0.5 0.5]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.3:0.3:0.3;
MyAxe.YAxis.MinorTickValues=-0.5:0.1:0.5;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=400:15:430;
MyAxe.XAxis.MinorTickValues=390:5:430;

MyAxe.YAxis.TickLength=[0.03 0.03];
MyAxe.XAxis.TickLength=[0.03 0.03];
set(gca,'XTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
 
MyYLabel=ylabel({'$W$';'$[mm$ $s^{-1}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.13 LabelPos(2)];
text(388.5,-0.3,'$b$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

plot(Time/3600,1000*squeeze(Data{1}.W(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/3600,1000*squeeze(Data{2}.W(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/3600,1000*squeeze(Data{3}.W(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/3600,1000*squeeze(Data{4}.W(XIndex,ZIndex,:)),'LineWidth',2);
line([386 433],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([386 433 -0.65 0.55]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.40:0.40:0.40;
MyAxe.YAxis.MinorTickValues=-0.60:0.10:0.50;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=400:15:430;
MyAxe.XAxis.MinorTickValues=390:5:430;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.03 0.03];
MyAxe.XAxis.TickLength=[0.03 0.03];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$w$';'$[mm$ $s^{-1}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.06 LabelPos(2)];
text(388.5,0.35,'$c$','fontsize',24,'Color','black','BackgroundColor','none');

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
line([386 433],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([386 433 -0.3 0.3]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.20:0.20:0.20;
MyAxe.YAxis.MinorTickValues=-0.25:0.05:0.25;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=400:15:430;
MyAxe.XAxis.MinorTickValues=390:5:430;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.03 0.03];
MyAxe.XAxis.TickLength=[0.03 0.03];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$\rho''$';'$[kg.m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.06 LabelPos(2)];
text(388.5,-0.2,'$d$','fontsize',24,'Color','black','BackgroundColor','none');

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
line([386 433],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([386 433 -0.8 0.8]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.5:0.5:0.5;
MyAxe.YAxis.MinorTickValues=-0.8:0.1:0.8;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=400:15:430;
MyAxe.XAxis.MinorTickValues=390:5:430;

MyAxe.YAxis.TickLength=[0.03 0.03];
MyAxe.XAxis.TickLength=[0.03 0.03];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$Time$ $[Hour]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.4];

MyYLabel=ylabel({'$C$';'$[mW.m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.06 LabelPos(2)];
text(389,-0.5,'$e$','fontsize',24,'Color','black','BackgroundColor','none');

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

plot(squeeze(Data{1}.RhoPrimeConventional(XIndex,:,257)),ZC,'LineWidth',2);
plot(squeeze(Data{2}.RhoPrimeConventional(XIndex,:,377)),ZC,'LineWidth',2);
plot(squeeze(Data{3}.RhoPrimeConventional(XIndex,:,329)),ZC,'LineWidth',2);
plot(squeeze(Data{4}.RhoPrimeConventional(XIndex,:,288)),ZC,'LineWidth',2);
line([0 0],[-12 -1],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([-0.45 0.15 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-0.3:0.3:0;
MyAxe.XAxis.MinorTickValues=-0.45:0.05:0.1;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$\rho''$ $[kg.m^{-3}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];

lgd=legend('$102^\circ$','$-48^\circ$','$12^\circ$','NW','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1)+0.08 LGDPositio(2)+0.055 LGDPositio(3) LGDPositio(4)];
text(-0.40,-1.7,'$f$','fontsize',24,'Color','black','BackgroundColor','none');

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
line([0 0],[-12 -1],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

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

MyLabel=xlabel('$u''$ $[cm$ $s^{-1}]$','fontsize',18);
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

plot(1000*squeeze(Data{1}.W(XIndex,:,257)),ZC,'LineWidth',2);
plot(1000*squeeze(Data{2}.W(XIndex,:,377)),ZC,'LineWidth',2);
plot(1000*squeeze(Data{3}.W(XIndex,:,329)),ZC,'LineWidth',2);
plot(1000*squeeze(Data{4}.W(XIndex,:,288)),ZC,'LineWidth',2);
line([0 0],[-12 -1],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([-1.25 0.25 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;
MyAxe.YAxis.TickLabels='';
MyAxe.YAxisLocation='right';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-1:1:0;
MyAxe.XAxis.MinorTickValues=-1.5:0.125:5;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$z$ $[m]$'},'fontsize',20);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)+0.1 LabelPos(2)];

MyLabel=xlabel('$w$ $[mm$ $s^{-1}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];
text(-1.1,-1.7,'$h$','fontsize',24,'Color','black');

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\WindStructureK1');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\WindStructureK1','epsc');
%%
%Figure 5- Profiles and TimeSeries in the presence of wind M2
clear all;
close all;
FIG=figure('position',[100 300 1000 600]);

XIndex=475;
ZIndex=21;
TimeRange=3156+230;
TimeIndex=540;

CaseNumber=1;
Data=cell(4,1);
for counter=[110009 110007 110008 110081]
    Address=strcat('G:\Paper2and3\Result-',num2str(counter),'.mat');
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

Data{1}.PhaseLag=12;
Data{2}.PhaseLag=312;
Data{3}.PhaseLag=342;

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

plot(Time/3600,6*(1+sin(WindOmega*(Time-(360-Data{1}.PhaseLag)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-');
plot(Time/3600,6*(1+sin(WindOmega*(Time-(360-Data{2}.PhaseLag)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-');
plot(Time/3600,6*(1+sin(WindOmega*(Time-(360-Data{3}.PhaseLag)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-');

scatter(Time(387)/3600,6,150,'p','filled','MarkerEdgeColor',[0 0.45 0.74],'MarkerFaceColor',[0 0.45 0.74]);
scatter(Time(411)/3600,6,150,'p','filled','MarkerEdgeColor',[0.93 0.69 0.13],'MarkerFaceColor',[0.93 0.69 0.13]);
scatter(Time(435)/3600,6,150,'p','filled','MarkerEdgeColor',[0.85 0.33 0.10],'MarkerFaceColor',[0.85 0.33 0.10]);

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
MyYLabel.Position=[LabelPos(1)-6.5 LabelPos(2)];
text(390,0.8,'$a$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=4;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(Time/3600,1e3*squeeze(Data{1}.WBar(XIndex,ZIndex,:)),'LineWidth',2,'LineStyle','-');
plot(Time/3600,1e3*squeeze(Data{2}.WBar(XIndex,ZIndex,:)),'LineWidth',2,'LineStyle','-');
plot(Time/3600,1e3*squeeze(Data{3}.WBar(XIndex,ZIndex,:)),'LineWidth',2,'LineStyle','-');
plot(Time/3600,1e3*squeeze(Data{4}.WBar(XIndex,ZIndex,:)),'LineWidth',2,'LineStyle','-');

line([385 434],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);
scatter(Time(412)/3600,-0.6,150,'p','filled','MarkerEdgeColor',[0.49 0.18 0.56],'MarkerFaceColor',[0.49 0.18 0.56]);

axis([385 434 -0.70 0.70]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.40:0.40:0.40;
MyAxe.YAxis.MinorTickValues=-0.60:0.10:0.60;

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
MyYLabel.Position=[LabelPos(1)-2.5 LabelPos(2)];
text(390,0.35,'$b$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

plot(Time/3600,1000*squeeze(Data{1}.W(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/3600,1000*squeeze(Data{2}.W(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/3600,1000*squeeze(Data{3}.W(XIndex,ZIndex,:)),'LineWidth',2);
plot(Time/3600,1000*squeeze(Data{4}.W(XIndex,ZIndex,:)),'LineWidth',2);
line([385 434],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([385 434 -0.8 0.7]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.5:0.5:0.5;
MyAxe.YAxis.MinorTickValues=-0.7:0.1:0.7;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=395:15:425;
MyAxe.XAxis.MinorTickValues=385:2.5:434;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.02 0.03];
MyAxe.XAxis.TickLength=[0.02 0.03];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$w$';'$[mm$ $s^{-1}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-2 LabelPos(2)];
text(390,0.5,'$c$','fontsize',24,'Color','black','BackgroundColor','none');

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

axis([385 434 -0.21 0.37]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0:0.20:0.20;
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
MyYLabel.Position=[LabelPos(1)-3.2 LabelPos(2)];
text(390,0.25,'$d$','fontsize',24,'Color','black','BackgroundColor','none');

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

axis([385 434 -1 2]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.5:1:1.5;
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
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.8];

MyYLabel=ylabel({'$C$';'$[mW.m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-1.5 LabelPos(2)];
text(390,-0.4,'$e$','fontsize',24,'Color','black','BackgroundColor','none');

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

plot(squeeze(Data{1}.RhoPrimeConventional(XIndex,:,387)),ZC,'LineWidth',2);
plot(squeeze(Data{2}.RhoPrimeConventional(XIndex,:,411)),ZC,'LineWidth',2);
plot(squeeze(Data{3}.RhoPrimeConventional(XIndex,:,435)),ZC,'LineWidth',2);
plot(squeeze(Data{4}.RhoPrimeConventional(XIndex,:,412)),ZC,'LineWidth',2);
line([0 0],[-12 -1],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([-0.3 0.1 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-0.2:0.2:0;
MyAxe.XAxis.MinorTickValues=-0.25:0.05:0.1;

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
text(-0.22,-1.7,'$f$','fontsize',24,'Color','black','BackgroundColor','none');

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
line([0 0],[-12 -1],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([-3 2.5 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;
MyAxe.YAxis.TickLabels='';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-2:2:0;
MyAxe.XAxis.MinorTickValues=-3:0.5:2.5;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$u''$ $[cm$ $s^{-1}]$','fontsize',18);
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

plot(1000*squeeze(Data{1}.W(XIndex,:,387)),ZC,'LineWidth',2);
plot(1000*squeeze(Data{2}.W(XIndex,:,411)),ZC,'LineWidth',2);
plot(1000*squeeze(Data{3}.W(XIndex,:,435)),ZC,'LineWidth',2);
plot(1000*squeeze(Data{4}.W(XIndex,:,412)),ZC,'LineWidth',2);
line([0 0],[-12 -1],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([-2.5 0.1 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;
MyAxe.YAxis.TickLabels='';
MyAxe.YAxisLocation='right';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-2:1:0;
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
text(-2,-1.7,'$h$','fontsize',24,'Color','black');

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\WindStructureM2');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\WindStructureM2','epsc');
%%
%Figure 6- Profiles and TimeSeries in the presence of wind
clear all;
close all;
FIG=figure('position',[100 300 1000 600]);

MyColor=[0 0.447 0.741;...%blue
    0.85 0.325 0.098;...%red
    0.929 0.6941 0.1255;...%yellow
    0.49 0.18 0.56];%purple

TimeIndex1=208+303;
TimeIndex2=281+303;
TimeIndex3=306+303;
TimeIndex4=353+303;

XIndex=475;
ZIndex=33;
TimeRange=3156;
TimeIndex=540;

Address=strcat('G:\Paper2and3\Result-',num2str(110483),'.mat');
load(Address,'WBar','Eta','RhoPrimeConventional','U','W','ConversionConventionalWBar');
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
RhoPrimeConventional=RhoPrimeConventional-repmat(nanmean(RhoPrimeConventional,3),1,1,size(Time,1)); 

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
PhaseLag=342;

plot(Time/3600,6*(1+sin(WindOmega*(Time-(360-PhaseLag)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-','color','black');

scatter(Time(TimeIndex1)/3600,0,100,'p','filled','MarkerEdgeColor',[0 0.45 0.74],'MarkerFaceColor',[0 0.45 0.74]);
scatter(Time(TimeIndex2)/3600,3.04,100,'p','filled','MarkerEdgeColor',[0.85 0.33 0.1],'MarkerFaceColor',[0.85 0.33 0.10]);
scatter(Time(TimeIndex3)/3600,4.6,100,'p','filled','MarkerEdgeColor',[0.93 0.69 0.13],'MarkerFaceColor',[0.93 0.69 0.13]);
scatter(Time(TimeIndex4)/3600,6,100,'p','filled','MarkerEdgeColor',[0.49 0.18 0.56],'MarkerFaceColor',[0.49 0.18 0.56]);

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
text(15.8*24,5.2,'$a$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=4;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

plot(Time/3600,1000*squeeze(Eta(XIndex,:)),'LineWidth',2,'LineStyle','-','color','black');
line([372 432],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([372 432 -1 4.5]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-4:4:4;
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
text(15.8*24,3,'$b$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'XTickLabel','');

plot(Time/3600,1e3*squeeze(WBar(XIndex,ZIndex,:)),'-','LineWidth',2,'color','black');
line([372 432],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([372 432 -0.05 0.05]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.03:0.03:0.03;
MyAxe.YAxis.MinorTickValues=-0.04:0.01:0.04;
 
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
text(15.8*24,-0.025,'$c$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

plot(Time/3600,squeeze(RhoPrimeConventional(XIndex,ZIndex,:)),'LineWidth',2,'color','black');
line([372 432],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([372 432 -0.35 0.3]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.25:0.25:0.25;
MyAxe.YAxis.MinorTickValues=-0.35:0.05:0.3;

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
text(15.8*24,-0.25,'$d$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

plot(Time/3600,10^3*squeeze(ConversionConventionalWBar(XIndex,ZIndex,:)),'LineWidth',2,'color','black');
line([372 432],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([372 432 -0.07 0.09]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.05:0.05:0.05;
MyAxe.YAxis.MinorTickValues=-0.07:0.01:0.09;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=385:20:425;
MyAxe.XAxis.MinorTickValues=370:2.5:432;

MyAxe.YAxis.TickLength=[0.025 0.03];
MyAxe.XAxis.TickLength=[0.025 0.03];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('Time [$hour$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.04];

MyYLabel=ylabel({'$C$';'$[mW.m^{-3}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.1 LabelPos(2)];
text(15.8*24,-0.04,'$e$','fontsize',24,'Color','black','BackgroundColor','none');


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

plot(squeeze(RhoPrimeConventional(XIndex,:,TimeIndex1)),ZC,'LineWidth',2);
plot(squeeze(RhoPrimeConventional(XIndex,:,TimeIndex2)),ZC,'LineWidth',2);
plot(squeeze(RhoPrimeConventional(XIndex,:,TimeIndex3)),ZC,'LineWidth',2);
plot(squeeze(RhoPrimeConventional(XIndex,:,TimeIndex4)),ZC,'LineWidth',2);

line([0 0],[-12 -1],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([-0.15 0.3 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=0:0.2:0.2;
MyAxe.XAxis.MinorTickValues=-0.50:0.10:0.25;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$\rho''$ $[kg.m^{-3}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];

text(-0.12,-1.7,'$f$','fontsize',24,'Color','black','BackgroundColor','none');

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

plot(100*squeeze(Uprime(XIndex,:,TimeIndex1)),ZC,'LineWidth',2);
plot(100*squeeze(Uprime(XIndex,:,TimeIndex2)),ZC,'LineWidth',2);
plot(100*squeeze(Uprime(XIndex,:,TimeIndex3)),ZC,'LineWidth',2);
plot(100*squeeze(Uprime(XIndex,:,TimeIndex4)),ZC,'LineWidth',2);

plot(1000*squeeze(UBar(XIndex,:,TimeIndex1)),ZC,'--','LineWidth',2,'Color',MyColor(1,:));
plot(1000*squeeze(UBar(XIndex,:,TimeIndex2)),ZC,'--','LineWidth',2,'Color',MyColor(2,:));
plot(1000*squeeze(UBar(XIndex,:,TimeIndex3)),ZC,'--','LineWidth',2,'Color',MyColor(3,:));
plot(1000*squeeze(UBar(XIndex,:,TimeIndex4)),ZC,'--','LineWidth',2,'Color',MyColor(4,:));

line([0 0],[-12 -1],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([-2 2 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;
MyAxe.YAxis.TickLabels='';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-1.5:1.5:1.5;
MyAxe.XAxis.MinorTickValues=-2:0.5:2;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyLabel=xlabel('$u''$, $10U$ $[cm$ $s^{-1}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];
text(-1.7,-1.7,'$g$','fontsize',24,'Color','black');

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

plot(1000*squeeze(W(XIndex,:,TimeIndex1)),ZC,'LineWidth',2);
plot(1000*squeeze(W(XIndex,:,TimeIndex2)),ZC,'LineWidth',2);
plot(1000*squeeze(W(XIndex,:,TimeIndex3)),ZC,'LineWidth',2);
plot(1000*squeeze(W(XIndex,:,TimeIndex4)),ZC,'LineWidth',2);

line([0 0],[-12 -1],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);

axis([-0.6 0.3 -12 -1]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=[-11,-9:3:-1];
MyAxe.YAxis.MinorTickValues=-12:0.5:-1;
MyAxe.YAxis.TickLabels='';
MyAxe.YAxisLocation='right';

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=-0.4:0.4:0.1;
MyAxe.XAxis.MinorTickValues=-0.6:0.1:0.3;

MyAxe.YAxis.TickLength=[0.02 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$z$ $[m]$'},'fontsize',20);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)+0.1 LabelPos(2)];

MyLabel=xlabel('$w$ $[mm$ $s^{-1}]$','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.5];
text(-0.5,-1.7,'$h$','fontsize',24,'Color','black');

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\WindStructureDetails');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\WindStructureDetails','epsc');
%%
%Figure 7- Horizontal and vertical velocity for wind case
clear all;
close all;
FIG=figure('position',[100 300 1000 600]);

TimeIndex1=208+303;
TimeIndex2=281+303;
TimeIndex3=306+303;
TimeIndex4=353+303;

XIndex=475;
ZIndex=33;
TimeRange=3156;
TimeIndex=540;

Address=strcat('G:\Paper2and3\Result-',num2str(110483),'.mat');
load(Address,'WBar','Eta','RhoPrimeConventional','U','W','ConversionConventionalWBar');
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
RhoPrimeConventional=RhoPrimeConventional-repmat(nanmean(RhoPrimeConventional,3),1,1,size(Time,1)); 

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

MargineTop=0.07;
MargineBot=0.15;
MargineLeft=0.10;
MargineRight=1-(MargineLeft+0.37);
SubplotSpac=0.01;
SubplotNumber=4;

SubplotCounter=4;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'layer','top')

pcolor(X(200:end)/1000,ZC,100*squeeze(U(200:end,:,TimeIndex1))');
shading flat;
caxis([-3 3]);
axis([42 45.2 -70 -1]);
colormap(CustomMap);

FIG.Color='white';
fig = gcf;
fig.InvertHardcopy = 'off';
set(gca, 'Color', 0.5*[1 1 1]);

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-60:20:-1;
MyAxe.YAxis.MinorTickValues=-70:5:-1;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=43:45;
MyAxe.XAxis.MinorTickValues=42:0.2:45.2;

MyAxe.YAxis.TickLength=[0.015 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'XTickLabel','');
set(gca,'YAxisLocation','Right');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

text(44.9,-55,'$a$','fontsize',24,'Color','black','BackgroundColor','none');


SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'layer','top')

pcolor(X(200:end)/1000,ZC,100*squeeze(U(200:end,:,TimeIndex2))');
shading flat;
caxis([-3 3]);
axis([42 45.2 -70 -1]);
colormap(CustomMap);

FIG.Color='white';
fig = gcf;
fig.InvertHardcopy = 'off';
set(gca, 'Color', 0.5*[1 1 1]);

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-60:20:-1;
MyAxe.YAxis.MinorTickValues=-70:5:-1;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=43:45;
MyAxe.XAxis.MinorTickValues=42:0.2:45.2;

MyAxe.YAxis.TickLength=[0.015 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'XTickLabel','');
set(gca,'YAxisLocation','Right');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

text(44.9,-55,'$b$','fontsize',24,'Color','black','BackgroundColor','none');


SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'layer','top')

pcolor(X(200:end)/1000,ZC,100*squeeze(U(200:end,:,TimeIndex3))');
shading flat;
caxis([-3 3]);
axis([42 45.2 -70 -1]);
colormap(CustomMap);

FIG.Color='white';
fig = gcf;
fig.InvertHardcopy = 'off';
set(gca, 'Color', 0.5*[1 1 1]);

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-60:20:-1;
MyAxe.YAxis.MinorTickValues=-70:5:-1;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=43:45;
MyAxe.XAxis.MinorTickValues=42:0.2:45.2;

MyAxe.YAxis.TickLength=[0.015 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'XTickLabel','');
set(gca,'YAxisLocation','Right');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

text(44.9,-55,'$c$','fontsize',24,'Color','black','BackgroundColor','none');


SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'layer','top')

pcolor(X(200:end)/1000,ZC,100*squeeze(U(200:end,:,TimeIndex4))');
shading flat;
caxis([-3 3]);
axis([42 45.2 -70 -1]);
colormap(CustomMap);

FIG.Color='white';
fig = gcf;
fig.InvertHardcopy = 'off';
set(gca, 'Color', 0.5*[1 1 1]);

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-60:20:-1;
MyAxe.YAxis.MinorTickValues=-70:5:-1;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=43:45;
MyAxe.XAxis.MinorTickValues=42:0.2:45.2;

MyAxe.YAxis.TickLength=[0.015 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'YAxisLocation','Right');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

text(44.9,-55,'$d$','fontsize',24,'Color','black','BackgroundColor','none');

MyColorbar=colorbar('Location','westoutside');
MyColorbar.FontSize=14;
MyColorbar.FontWeight='bold';
MyColorbar.TickLabelInterpreter='latex';
POS=MyColorbar.Position;
MyColorbar.Position=[POS(1)-0.06 POS(2) POS(3) POS(4)+0.595];
MyColorbar.Label.String='$u$ [$cm$ $s^{-1}$]';
MyColorbar.Label.Rotation=0;
POS=MyColorbar.Label.Position;
MyColorbar.Label.FontSize=18;
MyColorbar.Label.Position=[POS(1)+3.8 POS(2)+3. POS(3)];
MyColorbar.Label.Interpreter='latex';


MargineLeft=0.1+0.05+0.37;%Right Column
MargineRight=1-(MargineLeft+0.37);
SubplotNumber=4;

SubplotCounter=4;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'layer','top')

pcolor(X(200:end)/1000,ZC,10000*squeeze(W(200:end,:,TimeIndex1))');
shading flat;
caxis([-6 6]);
axis([42 45.2 -70 -1]);
colormap(CustomMap);

FIG.Color='white';
fig = gcf;
fig.InvertHardcopy = 'off';
set(gca, 'Color', 0.5*[1 1 1]);

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-60:20:-1;
MyAxe.YAxis.MinorTickValues=-70:5:-1;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=43:45;
MyAxe.XAxis.MinorTickValues=42:0.2:45.2;

MyAxe.YAxis.TickLength=[0.015 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'XTickLabel','');
set(gca,'YTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

text(44.9,-55,'$e$','fontsize',24,'Color','black','BackgroundColor','none');


SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'layer','top')

pcolor(X(200:end)/1000,ZC,10000*squeeze(W(200:end,:,TimeIndex2))');
shading flat;
caxis([-6 6]);
axis([42 45.2 -70 -1]);
colormap(CustomMap);

FIG.Color='white';
fig = gcf;
fig.InvertHardcopy = 'off';
set(gca, 'Color', 0.5*[1 1 1]);

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-60:20:-1;
MyAxe.YAxis.MinorTickValues=-70:5:-1;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=43:45;
MyAxe.XAxis.MinorTickValues=42:0.2:45.2;

MyAxe.YAxis.TickLength=[0.015 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'XTickLabel','');
set(gca,'YTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

text(44.9,-55,'$f$','fontsize',24,'Color','black','BackgroundColor','none');


SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'layer','top')

pcolor(X(200:end)/1000,ZC,10000*squeeze(W(200:end,:,TimeIndex3))');
shading flat;
caxis([-6 6]);
axis([42 45.2 -70 -1]);
colormap(CustomMap);

FIG.Color='white';
fig = gcf;
fig.InvertHardcopy = 'off';
set(gca, 'Color', 0.5*[1 1 1]);

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-60:20:-1;
MyAxe.YAxis.MinorTickValues=-70:5:-1;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=43:45;
MyAxe.XAxis.MinorTickValues=42:0.2:45.2;

MyAxe.YAxis.TickLength=[0.015 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'XTickLabel','');
set(gca,'YTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

text(44.9,-55,'$g$','fontsize',24,'Color','black','BackgroundColor','none');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'layer','top')

pcolor(X(200:end)/1000,ZC,10000*squeeze(W(200:end,:,TimeIndex4))');
shading flat;
caxis([-6 6]);
axis([42 45.2 -70 -1]);
colormap(CustomMap);

FIG.Color='white';
fig = gcf;
fig.InvertHardcopy = 'off';
set(gca, 'Color', 0.5*[1 1 1]);

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-60:20:-1;
MyAxe.YAxis.MinorTickValues=-70:5:-1;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=43:45;
MyAxe.XAxis.MinorTickValues=42:0.2:45.2;

MyAxe.YAxis.TickLength=[0.015 0.02];
MyAxe.XAxis.TickLength=[0.02 0.02];
set(gca,'YTickLabel','');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

text(44.9,-55,'$h$','fontsize',24,'Color','black','BackgroundColor','none');

MyColorbar=colorbar('Location','eastoutside');
MyColorbar.FontSize=14;
MyColorbar.FontWeight='bold';
MyColorbar.TickLabelInterpreter='latex';
POS=MyColorbar.Position;
MyColorbar.Position=[POS(1)+0.06 POS(2) POS(3) POS(4)+0.595];
MyColorbar.Label.String='$w$ [$10^{-4}$ $m$ $s^{-1}$]';
MyColorbar.Label.Rotation=0;
POS=MyColorbar.Label.Position;
MyColorbar.Label.FontSize=18;
MyColorbar.Label.Position=[POS(1)-4.6 POS(2)+6.8 POS(3)];
MyColorbar.Label.Interpreter='latex';

MyYLabel=xlabel('$X$ [$km$]','fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-2 LabelPos(2)];

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\WindStructureVelocity');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\WindStructureVelocity','epsc');
%%
%Figure 8- Conversion at different wind lag
clear all;
clc;
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
load('G:\Paper2and3\Result-110000.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%M2K1 7.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    for i=147:158%M2K1 7.5 m and 3 to 6 wind
        Address=strcat('G:\Paper2and3\Result-',num2str(j*12+i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot(-48:30:282,CaseValue-Baseline,'-s','LineWidth',2,'MarkerSize',6);
end

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-48 282 -0.4 1]);
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
lgd=legend('$3$ $m$ $s^{-1}$','$6$ $m$ $s^{-1}$','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1)+0.05 LGDPositio(2)-0.88 LGDPositio(3) LGDPositio(4)];
lgd.FontSize=14;
text(102,0.9,'$a$','fontsize',24,'Color','black','background','none');
box on;
text(76,0.1,num2str(Baseline,'%2.2g'),'fontsize',18,'Color','black','background','none');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('G:\Paper2and3\Result-110094.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%M2K1 12.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    for i=209:220%M2K1 12.5 m and 3 to 6 wind
        Address=strcat('G:\Paper2and3\Result-',num2str(j*12+i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot(-48:30:282,CaseValue-Baseline,'-s','LineWidth',2,'MarkerSize',6);
end

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-48 282 -1.2 1]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-1.2:0.1:1;
MyAxe.YAxis(1).TickValues=-0.8:0.8:0.8;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-48:30:282;
MyAxe.XAxis.TickValues=-48+30:90:282;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.03 0.04];
MyAxe.XAxis.TickLength=[0.03 0.04];

line([-48,282],[0 0],'LineStyle',':','color','black');
text(102,0.8,'$b$','fontsize',24,'Color','black','background','none');
box on;
text(76,0.1,num2str(Baseline,'%2.2g'),'fontsize',18,'Color','black','background','none');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('G:\Paper2and3\Result-110101.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%M2K1 17.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    for i=395:406%M2K1 17.5 m and 3 to 6 wind
        Address=strcat('G:\Paper2and3\Result-',num2str(j*12+i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot(-48:30:282,CaseValue-Baseline,'-s','LineWidth',2,'MarkerSize',6);
end

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-48 282 -1.2 1]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-1.2:0.1:1;
MyAxe.YAxis(1).TickValues=-0.8:0.8:0.8;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-48:30:282;
MyAxe.XAxis.TickValues=-48+30:90:282;

MyAxe.YAxis.TickLength=[0.03 0.04];
MyAxe.XAxis.TickLength=[0.03 0.04];

line([-48,282],[0 0],'LineStyle',':','color','black');
text(102,0.8,'$c$','fontsize',24,'Color','black','background','none');
box on;
text(76,0.1,num2str(Baseline,'%2.2g'),'fontsize',18,'Color','black','background','none');

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
load('G:\Paper2and3\Result-110088.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%K1 7.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,-1]
    CaseNumber=[];
    CaseValue=[];
    for i=33:44%K1 7.5 m and 3 to 6 wind
        Address=strcat('G:\Paper2and3\Result-',num2str(j*12+i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot(-48:30:282,CaseValue-Baseline,'-s','LineWidth',2,'MarkerSize',6);
end

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-48 282 -0.9 1.2]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-1:0.1:1.2;
MyAxe.YAxis(1).TickValues=-0.8:0.8:0.8;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-48:30:282;
MyAxe.XAxis.TickValues=-48+30:90:282;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.03 0.04];
MyAxe.XAxis.TickLength=[0.03 0.04];

line([-48,282],[0 0],'LineStyle',':','color','black');
text(102,1,'$d$','fontsize',24,'Color','black','background','none');
box on;
text(76,0.1,num2str(Baseline,'%2.2g'),'fontsize',18,'Color','black','background','none');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('G:\Paper2and3\Result-110090.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%K1 12.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    for i=185:196%K1 12.5 m and 3 to 6 wind
        Address=strcat('G:\Paper2and3\Result-',num2str(j*12+i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot(-48:30:282,CaseValue-Baseline,'-s','LineWidth',2,'MarkerSize',6);
end

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-48 282 -1.4 1.4]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-1.4:0.1:1.4;
MyAxe.YAxis(1).TickValues=-0.8:0.8:0.8;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-48:30:282;
MyAxe.XAxis.TickValues=-48+30:90:282;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.03 0.04];
MyAxe.XAxis.TickLength=[0.03 0.04];

line([-48,82],[0 0],'LineStyle',':','color','black');
text(102,1.2,'$e$','fontsize',24,'Color','black','background','none');
box on;
text(76,0.1,num2str(Baseline,'%2.2g'),'fontsize',18,'Color','black','background','none');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('G:\Paper2and3\Result-110092.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%K1 17.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    for i=371:382%K1 17.5 m and 3 to 6 wind
        Address=strcat('G:\Paper2and3\Result-',num2str(j*12+i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot(-48:30:282,CaseValue-Baseline,'-s','LineWidth',2,'MarkerSize',6);
end

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-49 282 -1 1.2]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-1:0.1:1.2;
MyAxe.YAxis(1).TickValues=-0.8:0.8:0.8;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-48:30:282;
MyAxe.XAxis.TickValues=-48+30:90:282;

MyAxe.YAxis.TickLength=[0.03 0.04];
MyAxe.XAxis.TickLength=[0.03 0.04];

line([-48,282],[0 0],'LineStyle',':','color','black');
text(102,1,'$f$','fontsize',24,'Color','black','background','none');
box on;
text(76,0.1,num2str(Baseline,'%2.2g'),'fontsize',18,'Color','black','background','none');

MyLabel=ylabel('$\widehat{\langle\overline{C} \rangle}$ Difference [$W.m^{-1}$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-430 LabelPos(2)+2.2];

MyLabel=xlabel('$\overbrace{Wind, Tide}$ [$^\circ$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.2];

%Right
MargineLeft=0.72;
MargineRight=0.10;
SubplotNumber=3;

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('G:\Paper2and3\Result-110081.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%M2 7.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,-1]
    CaseNumber=[];
    CaseValue=[];
    for i=14:20%M2 7.5 m and 3 to 6 wind
        Address=strcat('G:\Paper2and3\Result-',num2str(j*7+i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([-48:30:102,126],CaseValue-Baseline,'-s','LineWidth',2,'MarkerSize',6);
end

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-48 126 -0.05 0.5]);

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

text(-18,0.45,'$g$','fontsize',24,'Color','black','background','none');
box on;
text(20,0.2,num2str(Baseline,'%2.2g'),'fontsize',18,'Color','black','background','none');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('G:\Paper2and3\Result-110083.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%M2 12.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    for i=171:177%M2 12.5 m and 3 to 6 wind
        Address=strcat('G:\Paper2and3\Result-',num2str(j*7+i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([-48:30:102,126],CaseValue-Baseline,'-s','LineWidth',2,'MarkerSize',6);
end

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-48 126 -0.02 0.18]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.MinorTickValues=-0.02:0.01:0.18;
MyAxe.YAxis.TickValues=0:0.08:0.16;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-48:30:126;
MyAxe.XAxis.TickValues=-48+30:60:126;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.03 0.04];
MyAxe.XAxis.TickLength=[0.03 0.04];

line([-48,126],[0 0],'LineStyle',':','color','black');
text(-18,0.16,'$h$','fontsize',24,'Color','black','background','none');
box on;
text(20,0.06,num2str(Baseline,'%2.2g'),'fontsize',18,'Color','black','background','none');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
load('G:\Paper2and3\Result-110085.mat','X','ConversionConventionalTimeAvrDepthIntWBar');%M2 17.5 meter
Baseline=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
for j=[0,1]
    CaseNumber=[];
    CaseValue=[];
    for i=357:363%M2 17.5 m and 3 to 6 wind
        Address=strcat('G:\Paper2and3\Result-',num2str(j*7+i+110000),'.mat');
        load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
        CaseValue(end+1)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
        hold on;
        CaseNumber(end+1)=i;
    end
    plot([-48:30:102,126],CaseValue-Baseline,'-s','LineWidth',2,'MarkerSize',6);
end

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
axis([-48 126 -0.04 0.08]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.MinorTickValues=-0.04:0.01:0.08;
MyAxe.YAxis.TickValues=-0.05:0.05:0.05;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.MinorTickValues=-48:30:126;
MyAxe.XAxis.TickValues=-48+30:60:126;

MyAxe.YAxis.TickLength=[0.03 0.04];
MyAxe.XAxis.TickLength=[0.03 0.04];

line([-48,126],[0 0],'LineStyle',':','color','black');
text(-18,0.065,'$i$','fontsize',24,'Color','black','background','none');
box on;
text(20,0.005,num2str(Baseline,'%2.2g'),'fontsize',18,'Color','black','background','none');

text(130,0.28,'$7.50$ $m$','fontsize',18,'Color','black','background','none');
text(130,0.146,'$12.5$ $m$','fontsize',18,'Color','black','background','none');
text(130,0.022,'$17.5$ $m$','fontsize',18,'Color','black','background','none');

text(-546,0.348,'$M_2K_1$','fontsize',18,'Color','black','background','none');
text(-233,0.348,'$K_1$','fontsize',18,'Color','black','background','none');
text(26,0.348,'$M_2$','fontsize',18,'Color','black','background','none');

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\ConversionWindLag');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\ConversionWindLag','epsc');
%%
%Figure 9- Nonlinear wind lag for M2, K1 and M2K1
%clear all;
clc;
close all;
FIG=figure('position',[100 100 600 600]);

MyColor=[ 0.85 0.325 0.098;...%red
    0.929 0.6941 0.1255;...%yellow
    0 0.447 0.741;...%blue
    0.49 0.18 0.56;...%purple
    0.47 0.67 0.19;...%green
    0.30 0.75 0.93];%light blue

RowCounter=1;
ColumnCounter=1;
K1=nan(6,1);
for j=88:93
    Address=strcat('G:\Paper2and3\Result-',num2str(j+110000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    K1(RowCounter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    RowCounter=RowCounter+1;
end

RowCounter=1;
ColumnCounter=1;
M2=nan(6,1);
for j=81:86
    Address=strcat('G:\Paper2and3\Result-',num2str(j+110000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    M2(RowCounter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    RowCounter=RowCounter+1;
end

RowCounter=1;
ColumnCounter=1;
K1Wind6=nan(6,12);
for j=[21:32,259:270,197:208,321:332,383:394,445:456]%7.5, 10, 12.5, 15, 17.5, 20
    Address=strcat('G:\Paper2and3\Result-',num2str(j+110000),'.mat');
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
    Address=strcat('G:\Paper2and3\Result-',num2str(j+110000),'.mat');
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
    Address=strcat('G:\Paper2and3\Result-',num2str(j+110000),'.mat');
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
    Address=strcat('G:\Paper2and3\Result-',num2str(j+110000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    M2K1(RowCounter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    RowCounter=RowCounter+1;
end

RowCounter=1;
ColumnCounter=1;
Wind6=nan(6,1);
for j=[483:488]%7.5, 10, 12.5, 15, 17.5, 20
    Address=strcat('G:\Paper2and3\Result-',num2str(j+110000),'.mat');
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

axis([6.2 21.5 -1.9 1.4]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-1.8:0.2:1.4;
MyAxe.YAxis(1).TickValues=-1:1:1;

MyAxe.XAxis.TickValues=7.5:2.5:20;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.01 0.04];
MyAxe.XAxis.TickLength=[0.01 0.04];
text(7,-1.2,'$a$','fontsize',24,'Color','black','background','none');

text(7,0.8,num2str(Wind6(1),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(7,0.5,num2str(K1(1),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(8.2,MaxK1WindError(1)+0.20,num2str(MaxK1WindError(1),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));
text(8.0,MinK1WindError(1)-0.25,num2str(MinK1WindError(1),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));
 
text(9.54,0.8,num2str(Wind6(2),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(9.54,0.5,num2str(K1(2),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(10.67,MaxK1WindError(2)+0.20,num2str(MaxK1WindError(2),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));
text(10.47,MinK1WindError(2)-0.25,num2str(MinK1WindError(2),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));

text(11.91,0.8,num2str(Wind6(3),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(11.91,0.5,num2str(K1(3),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(13.17,MaxK1WindError(3)+0.20,num2str(MaxK1WindError(3),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));
text(12.97,MinK1WindError(3)-0.25,num2str(MinK1WindError(3),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));

text(14.44,0.8,num2str(Wind6(4),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(14.44,0.5,num2str(K1(4),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(15.67,MaxK1WindError(4)+0.20,num2str(MaxK1WindError(4),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));
text(15.47,MinK1WindError(4)-0.25,num2str(MinK1WindError(4),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));

text(16.94,0.8,num2str(Wind6(5),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(16.94,0.5,num2str(K1(5),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(18.13,MaxK1WindError(5)+0.20,num2str(MaxK1WindError(5),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));
text(17.93,MinK1WindError(5)-0.25,num2str(MinK1WindError(5),'%1.1f'),'fontsize',12,'Color',MyColor(6,:));

text(19.44,0.8,num2str(Wind6(6),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(19.44,0.5,num2str(K1(6),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
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
axis([6.2 21.5 -0.4 1.2]);
box on;

MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-0.4:0.1:1.3;
MyAxe.YAxis(1).TickValues=0:0.5:1;

MyAxe.XAxis.TickValues=7.5:2.5:20;
set(gca,'XTickLabel','');

MyAxe.YAxis.TickLength=[0.01 0.04];
MyAxe.XAxis.TickLength=[0.01 0.04];

text(7,1,'$b$','fontsize',24,'Color','black','background','none');

text(6.6,0.55,num2str(Wind6(1),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(6.6,0.4,num2str(M2(1),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(8.2,MaxM2WindError(1)+0.12,num2str(MaxM2WindError(1),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(8.2,MinM2WindError(1)-0.12,num2str(MinM2WindError(1),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
 
text(9.10,0.55,num2str(Wind6(2),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(9.10,0.4,num2str(M2(2),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(10.67,MaxM2WindError(2)+0.12,num2str(MaxM2WindError(2),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(10.67,MinM2WindError(2)-0.12,num2str(MinM2WindError(2),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));

text(11.6,0.55,num2str(Wind6(3),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(11.6,0.4,num2str(M2(3),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(13.17,MaxM2WindError(3)+0.08,num2str(MaxM2WindError(3),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(13.17,MinM2WindError(3)-0.08,num2str(MinM2WindError(3),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));

text(14.1,0.55,num2str(Wind6(4),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(14.1,0.4,num2str(M2(4),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(15.67,MaxM2WindError(4)+0.12,num2str(MaxM2WindError(4),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(15.67,MinM2WindError(4)-0.12,num2str(MinM2WindError(4),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));

text(16.6,0.55,num2str(Wind6(5),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(16.6,0.4,num2str(M2(5),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(18.13,MaxM2WindError(5)+0.12,num2str(MaxM2WindError(5),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(18.13,MinM2WindError(5)-0.12,num2str(MinM2WindError(5),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));

text(19.1,0.55,num2str(Wind6(6),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
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
    (MaxM2K1WindError-MinM2K1WindError)/2,'LineStyle','none','LineWidth',2,'CapSize',10);
scatter([7.5:2.5:20]+1.2,mean([MinM2K1WindError,MaxM2K1WindError],2),'filled','MarkerFaceColor',MyColor(6,:),'MarkerEdgeColor','none');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
box on;

axis([6.2 21.5 -1.8 1.5]);
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

text(7,1.2,'$c$','fontsize',24,'Color','black','background','none');

text(6.5,-0.2,num2str(M2(1),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(6.5,-0.5,num2str(K1(1),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(6.5,-0.8,num2str(M2K1(1),'%1.2f'),'fontsize',12,'Color',MyColor(2,:));
text(6.5,-1.1,num2str(Wind6(1),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(6.3,-1.4,num2str(M2K1(1)-M2(1)-K1(1),'%1.2f'),'fontsize',12,'Color',MyColor(5,:));
text(7.9,MaxM2K1WindError(1)+0.20,num2str(MaxM2K1WindError(1),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(7.9,MinM2K1WindError(1)-0.25,num2str(MinM2K1WindError(1),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));

text(9.3,-0.2,num2str(M2(2),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(9.3,-0.5,num2str(K1(2),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(9.3,-0.8,num2str(M2K1(2),'%1.2f'),'fontsize',12,'Color',MyColor(2,:));
text(9.3,-1.1,num2str(Wind6(2),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(9.1,-1.4,num2str(M2K1(2)-M2(2)-K1(2),'%1.2f'),'fontsize',12,'Color',MyColor(5,:));
text(10.4,MaxM2K1WindError(2)+0.20,num2str(MaxM2K1WindError(2),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(10.4,MinM2K1WindError(2)-0.25,num2str(MinM2K1WindError(2),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));

text(11.9,-0.2,num2str(M2(3),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(11.9,-0.5,num2str(K1(3),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(11.9,-0.8,num2str(M2K1(3),'%1.2f'),'fontsize',12,'Color',MyColor(2,:));
text(11.9,-1.1,num2str(Wind6(3),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(11.7,-1.4,num2str(M2K1(3)-M2(3)-K1(3),'%1.2f'),'fontsize',12,'Color',MyColor(5,:));
text(12.9,MaxM2K1WindError(3)+0.20,num2str(MaxM2K1WindError(3),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(12.9,MinM2K1WindError(3)-0.25,num2str(MinM2K1WindError(3),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));

text(14.4,-0.2,num2str(M2(4),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(14.4,-0.5,num2str(K1(4),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(14.4,-0.8,num2str(M2K1(4),'%1.2f'),'fontsize',12,'Color',MyColor(2,:));
text(14.4,-1.1,num2str(Wind6(4),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(14.2,-1.4,num2str(M2K1(4)-M2(4)-K1(4),'%1.2f'),'fontsize',12,'Color',MyColor(5,:));
text(15.4,MaxM2K1WindError(4)+0.20,num2str(MaxM2K1WindError(4),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(15.4,MinM2K1WindError(4)-0.25,num2str(MinM2K1WindError(4),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));

text(16.7,-0.2,num2str(M2(5),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(16.7,-0.5,num2str(K1(5),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(16.7,-0.8,num2str(M2K1(5),'%1.2f'),'fontsize',12,'Color',MyColor(2,:));
text(16.7,-1.1,num2str(Wind6(5),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(16.7,-1.4,num2str(M2K1(5)-M2(5)-K1(5),'%1.2f'),'fontsize',12,'Color',MyColor(5,:));
text(17.9,MaxM2K1WindError(5)+0.20,num2str(MaxM2K1WindError(5),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(17.9,MinM2K1WindError(5)-0.25,num2str(MinM2K1WindError(5),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));

text(19,-0.2,num2str(M2(6),'%1.2f'),'fontsize',12,'Color',MyColor(3,:));
text(19,-0.5,num2str(K1(6),'%1.2f'),'fontsize',12,'Color',MyColor(1,:));
text(19,-0.8,num2str(M2K1(6),'%1.2f'),'fontsize',12,'Color',MyColor(2,:));
text(19,-1.1,num2str(Wind6(6),'%1.2f'),'fontsize',12,'Color',MyColor(4,:));
text(19,-1.4,num2str(M2K1(6)-M2(6)-K1(6),'%1.2f'),'fontsize',12,'Color',MyColor(5,:));
text(20.3,MaxM2K1WindError(6)+0.2,num2str(MaxM2K1WindError(6),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));
text(20.1,MinM2K1WindError(6)-0.25,num2str(MinM2K1WindError(6),'%1.2f'),'fontsize',12,'Color',MyColor(6,:));

lgd=legend('$M_2$','$K_1$','$M_2K_1$','Wind','NTT','NTW','Orientation','horizontal','Location','northoutside');
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1)+0.07 LGDPositio(2)+0.6 LGDPositio(3) LGDPositio(4)];
lgd.FontSize=12;

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\M2K1WindNonlinear');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\M2K1WindNonlinear','epsc');
%%
%Figure 10- Special tidal flow with 20 hours period
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
    Address=strcat('G:\Paper2and3\Result-',num2str(j+110000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    TideEspecialWind6(RowCounter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    RowCounter=RowCounter+1;
end

RowCounter=1;
K1Wind6=nan(12,1);
for j=197:208
    Address=strcat('G:\Paper2and3\Result-',num2str(j+110000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    K1Wind6(RowCounter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    RowCounter=RowCounter+1;
end

RowCounter=1;
M2Wind6=nan(7,1);
for j=178:184
    Address=strcat('G:\Paper2and3\Result-',num2str(j+110000),'.mat');
    load(Address,'X','ConversionConventionalTimeAvrDepthIntWBar');
    M2Wind6(RowCounter)=trapz(X,ConversionConventionalTimeAvrDepthIntWBar);
    RowCounter=RowCounter+1;
end

MargineTop=0.10;
MargineBot=0.2;
MargineLeft=0.18;
MargineRight=0.05;
SubplotSpac=0.05;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
PlotLgd=[];
PlotLgd(1)=plot(([-48:30:282]+48)/330,TideEspecialWind6,'-d','LineWidth',2,'MarkerSize',10);
PlotLgd(2)=plot(([-48:30:282]+48)/330,K1Wind6,'-s','LineWidth',2,'MarkerSize',10);
PlotLgd(3)=plot(([-48:30:126,126]+48)/174,M2Wind6,'-^','LineWidth',2,'MarkerSize',10);
line([0 1],[0 0],'linewidth',0.5,'color',0.7*[1 1 1]);

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
box on;

axis([0 1 -1 1.5]);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).MinorTickValues=-1:0.1:1.5;
MyAxe.YAxis(1).TickValues=-0.8:0.8:0.8;

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

MyLabel=xlabel('Normalized Phase Lag','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.1];

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\SpecialTideWindNonlinear');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\SpecialTideWindNonlinear','epsc');
%%
%Figure 11- Water Column Stability
clear all;
close all;
FIG=figure('position',[100 300 1000 600]);

CaseNumber=1;
Data=cell(2,1);
for counter=[110021 110025]
    Address=strcat('G:\Paper2and3\Result-',num2str(counter),'.mat');
    Data{CaseNumber}=load(Address,'Density','U');
    load(Address,'X','ZC','Time');
    Data{CaseNumber}.N=-9.8/1024*diff(Data{CaseNumber}.Density,1,2)./diff(permute(repmat(ZC,1,742,4019),[2,1,3]),1,2);
    Data{CaseNumber}.N(:,end+1,:)=Data{CaseNumber}.N(:,end,:);
    Data{CaseNumber}.ShearVelocity=diff(Data{CaseNumber}.U,1,2)./diff(permute(repmat(ZC,1,742,4019),[2,1,3]),1,2);
    Data{CaseNumber}.ShearVelocity(:,end+1,:)=Data{CaseNumber}.ShearVelocity(:,end,:);
    Data{CaseNumber}.Ri=Data{CaseNumber}.N./Data{CaseNumber}.ShearVelocity.^2;
    CaseNumber=CaseNumber+1;
end

MargineTop=0.06;
MargineBot=0.70;
MargineLeft=0.12;
MargineRight=0.1;
SubplotSpac=0.02;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
WindPeriod=24*3600;
WindOmega=2*pi/WindPeriod;

PlotLgd=[];
for counter=110021:2:110032
    Address=strcat('G:\Paper2and3\Result-',num2str(counter),'.mat');
    load(Address,'ZC','X','ConversionConventionalTimeAvrDepthIntWBar','ConversionConventionalTimeAvrWBar');
    ConversionConventionalTimeAvrDepthIntWBar=movmean(ConversionConventionalTimeAvrDepthIntWBar,2);
    FittingFunction=fit(X,ConversionConventionalTimeAvrDepthIntWBar,'smoothingspline'); 
    ConversionConventionalTimeAvrDepthIntWBar=FittingFunction(X);
    PlotLgd(end+1)=plot(X/1000,1000*ConversionConventionalTimeAvrDepthIntWBar,'LineWidth',2,'LineStyle','-');
end 

axis([44 45.1 -3.2 3.2]);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-2:2:2;
MyAxe.YAxis.MinorTickValues=-3:0.5:3;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=44.2:0.4:45;
MyAxe.XAxis.MinorTickValues=44:0.1:45.1;

MyAxe.YAxis.TickLength=[0.015 0.015];
MyAxe.XAxis.TickLength=[0.015 0.015];
set(gca,'fontsize',14);
set(gca,'FontWeight','bold');

MyYLabel=ylabel({'$\overline{\langle C \rangle}$';'$[mW.m^{-2}]$'},'fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-0.02 LabelPos(2)];
text(44.03,2,'$a$','fontsize',24,'Color','black','BackgroundColor','none');

yyaxis right;

Depth=repmat(ZC,1,size(X,1))'+ConversionConventionalTimeAvrWBar*0;
Depth=nanmin(Depth,[],2);

plot(X/1000,Depth,'LineWidth',2,'LineStyle',':','Color',0.5*[1 1 1]);

axis([44 45.1 -55 0]);

MyAxe=gca;
MyAxe.YAxis(2).MinorTick='on';
MyAxe.YAxis(2).TickValues=-45:15:-15;
MyAxe.YAxis(2).MinorTickValues=-55:5:0;
MyAxe.YAxis(2).Color=0.5*[1 1 1];

MyAxe.YAxis(2).TickLength=[0.015 0.015];

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');

MyYLabel=ylabel('$z$ $[m]$','fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)+0.02 LabelPos(2)];

MyYLabel=xlabel('$X$ $[km]$','fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1) LabelPos(2)];

lgd=legend(PlotLgd,'$-48^\circ$','$12^\circ$','$72^\circ$',...
    '$132^\circ$','$192^\circ$','$252^\circ$',...
    'Orientation','horizontal','Location','northoutside');
lgd.FontSize=14;
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1) LGDPositio(2)+0.05 LGDPositio(3) LGDPositio(4)];

%Stability of Water Column
MargineTop=0.41;
MargineBot=0.12;
MargineLeft=0.12;
MargineRight=1-(MargineLeft+0.37);
SubplotSpac=0.02;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
ResultRi=min(Data{1}.Ri,[],3);
pcolor(X/1000,ZC,ResultRi');
axis([30 50 -75 -1]);
shading flat;
caxis([0 0.25]);

set(gca, 'Color',0.8*[1 1 1]);
FIG.Color='white';
colormap(bone);

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-60:15:-15;
MyAxe.YAxis.MinorTickValues=-75:5:0;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=35:5:45;
MyAxe.XAxis.MinorTickValues=30:2.5:50;

MyAxe.YAxis.TickLength=[0.03 0.03];
MyAxe.XAxis.TickLength=[0.03 0.03];

MyAxe.XAxis.Color=[0 0.45 0.74];
MyAxe.YAxis.Color=[0 0.45 0.74];

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'layer','top')

text(48,-65,'$b$','fontsize',24,'Color','black','BackgroundColor','none');

MyYLabel=ylabel('$z$ $[m]$','fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)-2 LabelPos(2)];

MyYLabel=xlabel('$X$ $[km]$','fontsize',18);
LabelPos=MyYLabel.Position;
MyYLabel.Position=[LabelPos(1)+10 LabelPos(2)-1.5];

MargineLeft=0.12+0.37*1+0.02;
MargineRight=1-(MargineLeft+0.37);
SubplotSpac=0.02;
SubplotNumber=1;

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
ResultRi=min(Data{2}.Ri,[],3);
pcolor(X/1000,ZC,ResultRi');
axis([30 50 -75 -1]);
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
MyColorbar.Position=[POS(1)+0.06 POS(2) POS(3) POS(4)];
MyColorbar.Label.String='$Ri$';
MyColorbar.Label.Interpreter='latex';

MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-60:15:-15;
MyAxe.YAxis.MinorTickValues=-75:5:0;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=35:5:45;
MyAxe.XAxis.MinorTickValues=30:2.5:50;
MyAxe.YAxis.TickValues='';

MyAxe.YAxis.TickLength=[0.03 0.03];
MyAxe.XAxis.TickLength=[0.03 0.03];

MyAxe.XAxis.Color=[0 0.45 0.74];
MyAxe.YAxis.Color=[0 0.45 0.74];

set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
set(gca,'layer','top');

text(48,-65,'$c$','fontsize',24,'Color','black','BackgroundColor','none');

FIG = gcf;
FIG.InvertHardcopy = 'off';

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\StabilityMixing');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\StabilityMixing','epsc');
%%
%Figure 12- Looking at the UPrime Time series and cyclic pattern of
%wind-tide phase lag
close all;
%clear all;
clc;

FIG=figure('position',[100 50 800 800]); 

% CaseCell=cell(5,1);
% counter=1;
% for i=[48:7:76]
%     Address=strcat('G:\Paper2and3\Result-',num2str(i+110000),'.mat');
%     CaseCell{counter}=load(Address,'X','ZC','WBar','ConversionConventionalWBar','RhoPrimeConventional','U','UBar','ConversionConventionalTimeAvrWBar','ConversionConventionalTimeAvrDepthIntWBar');
%     CaseCell{counter}.U=CaseCell{counter}.U(:,:,end-600:end-150);
%     CaseCell{counter}.UBar=CaseCell{counter}.UBar(:,:,end-600:end-150);
%     CaseCell{counter}.UPrime=CaseCell{counter}.U-CaseCell{counter}.UBar;
%     CaseCell{counter}.WBar=CaseCell{counter}.WBar(:,:,end-600:end-150); 
%     CaseCell{counter}.ConversionConventionalWBar=CaseCell{counter}.ConversionConventionalWBar(:,:,end-600:end-150);
%     CaseCell{counter}.RhoPrimeConventional=CaseCell{counter}.RhoPrimeConventional(:,:,end-600:end-150);
%     load(Address,'Time','ZC','X','Eta');
%     Time=Time(end-600:end-150);
%     Eta=Eta(:,end-600:end-150);
%     counter=counter+1;
% end

WindOmega=2*pi/24/3600;
WindPeriod=24*3600;

Speed=[0,1.5,3,4.5,6];
MyColor=[0.40 0.40 0.40;...%gray
    0 0.447 0.741;...%blue
    0.49 0.18 0.56;...%purple
    0.929 0.6941 0.1255;...%yellow
    0.85 0.32 0.10];%red

MargineTop=0.05;
MargineBot=0.10;
MargineLeft=0.15;
MargineRight=0.12;
SubplotSpac=0.005;
SubplotNumber=6;

SubplotCounter=6;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;

yyaxis right;
plot(Time(1:450)/3600,squeeze(Eta(10,1:450)),'LineWidth',3,'LineStyle',':','color',MyColor(1,:));

axis([384 421 -0.9 0.9]);
set(gca,'fontsize',16);
MyAxe=gca;
MyAxe.YAxis(2).MinorTick='on';
MyAxe.YAxis(2).TickValues=-0.5:0.5:0.5;
MyAxe.YAxis(2).MinorTickValues=-0.9:0.1:0.9;
MyAxe.YAxis(2).Color=0.4*[1 1 1];

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=390:10:410;
MyAxe.XAxis.MinorTickValues=-384:421;
MyAxe.XAxis.TickLabels='';

MyAxe.YAxis(2).TickLength=[0.015 0.03];
MyAxe.XAxis.TickLength=[0.015 0.03];

MyLabel=ylabel('SSH [$m$]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)];

yyaxis left;
for counter=2:5
    plot(Time(1:450)/3600,Speed(counter)*(1+sin(WindOmega*(Time(1:450)-(360-157)*WindPeriod/360)))/2,'LineWidth',2,'LineStyle','-','color',MyColor(counter,:),'Marker', 'none');
end
axis([384 421 -0.4 6.4]);
set(gca,'fontsize',16);
MyAxe=gca;
MyAxe.YAxis(1).MinorTick='on';
MyAxe.YAxis(1).TickValues=0:3:6;
MyAxe.YAxis(1).MinorTickValues=0:1:6;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=390:10:410;
MyAxe.XAxis.MinorTickValues=-384:421;
MyAxe.XAxis.TickLabels='';

MyAxe.YAxis(1).TickLength=[0.015 0.03];
MyAxe.YAxis(1).Color='black';
MyAxe.XAxis.TickLength=[0.015 0.03];

MyLabel=ylabel({'XS Wind'; '[$m$ $s^{-1}$]'},'fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-2.2 LabelPos(2)];

text(385,0.5,'$a$','fontsize',24,'Color','black');

SubplotCounter=5;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
plot(Time(1:450)/3600,1000*squeeze(CaseCell{1}.WBar(475,25,1:450)),'LineWidth',3,'LineStyle',':','color',MyColor(1,:));
for counter=2:5
    plot(Time(1:450)/3600,1000*squeeze(CaseCell{counter}.WBar(475,25,1:450)),'LineWidth',2,'LineStyle','-','Color',MyColor(counter,:));
end
line([384 421],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);
axis([384 421 -1.5 1.2]);
set(gca,'fontsize',16);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-1:1:1;
MyAxe.YAxis.MinorTickValues=-1.5:0.25:1.2;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=390:10:410;
MyAxe.XAxis.MinorTickValues=-384:421;
MyAxe.XAxis.TickLabels='';

MyAxe.YAxis.TickLength=[0.015 0.03];
MyAxe.XAxis.TickLength=[0.015 0.03];

MyLabel=ylabel({'$W$';'[$mm$ $s^{-1}$]'},'fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-1.7 LabelPos(2)];

text(385,-0.9,'$b$','fontsize',24,'Color','black');

SubplotCounter=4;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
PlotLegend=[];
plot(Time(1:450)/3600,squeeze(CaseCell{1}.UBar(475,25,1:450)),'LineWidth',3,'LineStyle',':','color',MyColor(1,:));
for counter=2:5
    plot(Time(1:450)/3600,squeeze(CaseCell{counter}.UBar(475,25,1:450)),'LineWidth',2,'LineStyle','-','color',MyColor(counter,:));
end
line([384 421],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);
axis([384 421 -0.05 0.04]);
set(gca,'fontsize',16);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.03:0.03:0.03;
MyAxe.YAxis.MinorTickValues=-0.05:0.01:0.04;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=390:10:410;
MyAxe.XAxis.MinorTickValues=-384:421;
MyAxe.XAxis.TickLabels='';

MyAxe.YAxis.TickLength=[0.015 0.03];
MyAxe.XAxis.TickLength=[0.015 0.03];

MyLabel=ylabel({'$U$';'[$m$ $s^{-1}$]'},'fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)];

text(385,-0.03,'$c$','fontsize',24,'Color','black');

SubplotCounter=3;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
PlotLegend=[];
plot(Time(1:450)/3600,squeeze(CaseCell{1}.UPrime(475,25,1:450)),'LineWidth',3,'LineStyle',':','color',MyColor(1,:));
for counter=2:5
    plot(Time(1:450)/3600,squeeze(CaseCell{counter}.UPrime(475,25,1:450)),'LineWidth',2,'LineStyle','-','color',MyColor(counter,:));
end
line([384 421],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);
axis([384 421 -0.01 0.01]);
set(gca,'fontsize',16);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0.008:0.008:0.008;
MyAxe.YAxis.MinorTickValues=-0.008:0.004:0.008;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=390:10:410;
MyAxe.XAxis.MinorTickValues=-384:421;
MyAxe.XAxis.TickLabels='';

MyAxe.YAxis.TickLength=[0.015 0.03];
MyAxe.XAxis.TickLength=[0.015 0.03];

MyLabel=ylabel({'$u''$'; '[$m$ $s^{-1}$]'},'fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)];

text(385,-0.006,'$d$','fontsize',24,'Color','black');

SubplotCounter=2;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
plot(Time(1:450)/3600,squeeze(CaseCell{1}.RhoPrimeConventional(475,25,1:450)),'LineWidth',3,'LineStyle',':','color',MyColor(1,:));
for counter=2:5
    plot(Time(1:450)/3600,squeeze(CaseCell{counter}.RhoPrimeConventional(475,25,1:450)),'LineWidth',2,'LineStyle','-','color',MyColor(counter,:));
end
line([384 421],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);
axis([384 421 -0.1 0.25]);
set(gca,'fontsize',16);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=-0:0.2:0.2;
MyAxe.YAxis.MinorTickValues=-0.1:0.05:0.25;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=390:10:410;
MyAxe.XAxis.MinorTickValues=-384:421;
MyAxe.XAxis.TickLabels='';

MyAxe.YAxis.TickLength=[0.015 0.03];
MyAxe.XAxis.TickLength=[0.015 0.03];

MyLabel=ylabel({'$\rho''$';'[$kg.m^{-3}$]'},'fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-0.8 LabelPos(2)];

lgd=legend('$0 \frac{m}{s}$','$1.5 \frac{m}{s}$','$3 \frac{m}{s}$','$4.5 \frac{m}{s}$','$6 \frac{m}{s}$'...
    ,'Orientation','horizontal','Location','northoutside');
lgd.FontSize=14;
LGDPositio=lgd.Position;
lgd.Position=[LGDPositio(1) LGDPositio(2)+0.61 LGDPositio(3) LGDPositio(4)];

text(385,-0.05,'$e$','fontsize',24,'Color','black');

SubplotCounter=1;
subplot('Position',[MargineLeft,MargineBot+(SubplotCounter-1)*SubplotSpac+(SubplotCounter-1)*(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber,1-MargineLeft-MargineRight,(1-(MargineBot+MargineTop+(SubplotNumber-1)*SubplotSpac))/SubplotNumber]);
hold on;
box on;
plot(Time(1:450)/3600,1000*squeeze(CaseCell{1}.ConversionConventionalWBar(475,25,1:450)),'LineWidth',3,'LineStyle',':','color',MyColor(1,:));
for counter=2:5
    plot(Time(1:450)/3600,1000*squeeze(CaseCell{counter}.ConversionConventionalWBar(475,25,1:450)),'LineWidth',2,'LineStyle','-','color',MyColor(counter,:));
end
line([384 421],[0 0],'LineWidth',0.5,'LineStyle','-','Color',0.7*[1 1 1]);
axis([384 421 -1 1.7]);
set(gca,'fontsize',16);
MyAxe=gca;
MyAxe.YAxis.MinorTick='on';
MyAxe.YAxis.TickValues=0:1:1;
MyAxe.YAxis.MinorTickValues=-0.5:0.5:1.5;

MyAxe.XAxis.MinorTick='on';
MyAxe.XAxis.TickValues=390:10:410;
MyAxe.XAxis.MinorTickValues=-384:421;

MyAxe.YAxis.TickLength=[0.015 0.03];
MyAxe.XAxis.TickLength=[0.015 0.03];

MyLabel=ylabel({'$C$';'[$mW.m^{-3}$]'},'fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1)-1.8 LabelPos(2)];

text(385,-0.5,'$f$','fontsize',24,'Color','black');

MyLabel=xlabel('Time [Hour]','fontsize',18);
LabelPos=MyLabel.Position;
MyLabel.Position=[LabelPos(1) LabelPos(2)-0.01];

savefig(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\WindSpeedM2K1');
saveas(FIG,'D:\OneDrive - University of Georgia\Documents\Educational\Latex\Paper3\WindSpeedM2K1','epsc');