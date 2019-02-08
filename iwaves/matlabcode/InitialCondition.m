close all;
clear all;
clc

FigureSize=[1900,900];
fig=figure('Position',[1 1 FigureSize(1) FigureSize(2)]);
movegui('center');

cd('D:\github\suntans\InternalWaves\matlabcode')
load InitialConditionData.mat

subplot('position',[0.05,0.55,0.50,0.40]);
[XX,ZZ]=meshgrid(Z,X/1000);
pcolor(ZZ,XX,RhoB);
colormap('cool');
h = colorbar;
set( h, 'YDir','reverse');
shading flat;
hold on;
contour(ZZ,XX,RhoB,5,'black','LineStyle','--');
xlabel('Distance off-shore (Km)');
ylabel('Depth (m)');
set(gca,'fontsize',18);
set(gca,'FontWeight','bold');

subplot('position',[0.65,0.50,0.30,0.40]);
set(gca,'fontsize',18);
set(gca,'FontWeight','bold');
RhoB=squeeze(RhoB(end,:));
RhoB=RhoB';
x1 = Z;
y1 = RhoB;
line(y1,x1,'Color','blue','LineWidth',6);
ax1 = gca; % current axes
ax1.XColor = 'blue';
ax1.YColor = 'none';
ax1_pos = ax1.Position; % position of first axes
xlabel('Density (kg/m^3)');
ax2 = axes('Position',ax1_pos,'XAxisLocation','top','YAxisLocation','left','Color','none');

BruntVaisala=(-diff(RhoB,1,1)./diff(Z)*9.8/1025).^0.5;
BruntVaisala(end+1)=BruntVaisala(end);
x2 = Z;
y2 = BruntVaisala;
line(y2,x2,'Parent',ax2,'Color','black','LineWidth',6);
grid;
ylabel('Depth (m)');
xlabel('Brunt Vaisala Frequency (Rad/s)');
set(gca,'fontsize',18);
set(gca,'FontWeight','bold');

subplot('position',[0.05,0.10,0.465,0.44]);
load BathymetryGridData.mat;
load InitialConditionData.mat;
XBathymetry(end+1)=X(end);
Bathymetry(end+1)=Bathymetry(end);
CellSize=diff(X,1);
CellSize(end+1)=CellSize(end);

[BathymertyFigureAxis,BathymetryCurve,CellsizeCurve] =...
    plotyy(XBathymetry/1000,Bathymetry,X/1000,CellSize,'plot');
set(BathymertyFigureAxis(1),'YColor',[0.5,0.5,0.5],'FontWeight','bold','fontsize',16,'Ylim',[-100,0],'YTick',[-100,-80,-60,-40,-20,0]);
set(BathymertyFigureAxis(2),'YColor',[0,0,0],'FontWeight','bold','fontsize',16,'Ylim',[0,100],'YDir','reverse','YTick',[0,20,40,60,80,100]);

xlabel('Offshore Distance (km)');
ylabel(BathymertyFigureAxis(1),'Bathymetry Depth (m)');
ylabel(BathymertyFigureAxis(2),'Cell Size (m)');

BathymetryCurve.Color=[0.5,0.5,0.5];
BathymetryCurve.LineWidth=4;
grid minor;

CellsizeCurve.Color=[0,0,0];
CellsizeCurve.LineWidth=2;
CellsizeCurve.LineStyle=':';

annotation(fig,'textbox',[0.01 0.92 0.04 0.04],'String','a)','fontsize',20,'EdgeColor','none','FontWeight','bold');
annotation(fig,'textbox',[0.60 0.92 0.04 0.04],'String','b)','fontsize',20,'EdgeColor','none','FontWeight','bold');
annotation(fig,'textbox',[0.01 0.52 0.04 0.04],'String','c)','fontsize',20,'EdgeColor','none','FontWeight','bold');

saveas(fig,'D:\github\suntans\InternalWaves\matlabcode\3.png');


