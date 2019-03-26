clear all;
close all
clc

load BathymetryGridData
FigureSize=[1600,800];
f=figure('Position',[1 1 FigureSize(1) FigureSize(2)],'units','pixels','Resize','off');
movegui(f,'center');
Density(Density<1025.6229)=1025.3;
[XX,ZZ]=meshgrid(Z,X);
caxis([1025.5 1026.5]);

pcolor(ZZ/1000,XX,Density);
xlabel('Distance off-shore (Km)');
ylabel('Depth (m)');
hold on;
shading flat;
colorbar;
colormap('cool');
h = colorbar;

set( h, 'YDir', 'reverse' );   
set(gca,'layer','top');
MinDensity=min(min(min(Density)));
MaxDensity=max(max(max(Density)));
ContourLevel=round(MinDensity,1):0.2:round(MaxDensity,1);
[C,H]=contour(ZZ/1000,XX,Density,ContourLevel,'black');   
H.LineStyle='--';
%clabel(C,H,'FontSize',18,'LabelSpacing',1000)
hold off;
set(gca,'fontsize',18);
set(gca,'FontWeight','bold');
grid minor;
str1=sprintf('Density (kg/m^3) at Flood Tide');
title(str1);
  
annotation('arrow',[0.85,0.78],[0.85,0.85],'LineWidth',3);
annotation('arrow',[0.85,0.78],[0.69,0.69],'LineWidth',3);
annotation('arrow',[0.85,0.78],[0.55,0.55],'LineWidth',3);
annotation('arrow',[0.85,0.78],[0.40,0.40],'LineWidth',3);

annotation('arrow',[0.72,0.65],[0.40,0.41],'LineWidth',4);
annotation('arrow',[0.72,0.65],[0.55,0.55],'LineWidth',4);
annotation('arrow',[0.72,0.65],[0.69,0.69],'LineWidth',4);
annotation('arrow',[0.72,0.65],[0.85,0.84],'LineWidth',4);

annotation('arrow',[0.50,0.43],[0.40,0.48],'LineWidth',4);
annotation('arrow',[0.50,0.43],[0.55,0.57],'LineWidth',4);
annotation('arrow',[0.50,0.43],[0.69,0.69],'LineWidth',4);
annotation('arrow',[0.50,0.43],[0.85,0.78],'LineWidth',4);

saveas(f,'Flood Tide.png');

FigureSize=[1600,800];
f=figure('Position',[1 1 FigureSize(1) FigureSize(2)],'units','pixels','Resize','off');
movegui(f,'center');
Density(Density<1025.6229)=1025.3;
[XX,ZZ]=meshgrid(Z,X);
caxis([1025.5 1026.5]);

pcolor(ZZ/1000,XX,Density);
xlabel('Distance off-shore (Km)');
ylabel('Depth (m)');
hold on;
shading flat;
colorbar;
colormap('cool');
h = colorbar;

set( h, 'YDir', 'reverse' );   
set(gca,'layer','top');
MinDensity=min(min(min(Density)));
MaxDensity=max(max(max(Density)));
ContourLevel=round(MinDensity,1):0.2:round(MaxDensity,1);
[C,H]=contour(ZZ/1000,XX,Density,ContourLevel,'black');   
H.LineStyle='--';
%clabel(C,H,'FontSize',18,'LabelSpacing',1000)
hold off;
set(gca,'fontsize',18);
set(gca,'FontWeight','bold');
grid minor;
str1=sprintf('Density (kg/m^3) at Ebb Tide');
title(str1);
  
annotation('arrow',[0.78,0.85],[0.85,0.85],'LineWidth',3);
annotation('arrow',[0.78,0.85],[0.69,0.69],'LineWidth',3);
annotation('arrow',[0.78,0.85],[0.55,0.55],'LineWidth',3);
annotation('arrow',[0.78,0.85],[0.40,0.40],'LineWidth',3);

annotation('arrow',[0.65,0.72],[0.41,0.40],'LineWidth',4);
annotation('arrow',[0.65,0.72],[0.55,0.55],'LineWidth',4);
annotation('arrow',[0.65,0.72],[0.69,0.69],'LineWidth',4);
annotation('arrow',[0.65,0.72],[0.84,0.85],'LineWidth',4);

annotation('arrow',[0.43,0.50],[0.48,0.40],'LineWidth',4);
annotation('arrow',[0.43,0.50],[0.57,0.55],'LineWidth',4);
annotation('arrow',[0.43,0.50],[0.69,0.69],'LineWidth',4);
annotation('arrow',[0.43,0.50],[0.78,0.85],'LineWidth',4);

saveas(f,'Ebb Tide.png');

profile=figure('rend','painters','pos',[10 10 800 800]);
subplot('position',[.1 .20 .8 .65]);
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
saveas(profile,'DensityBrunt.png');


FigureSize=[1800,700];
fig=figure('Position',[1 1 FigureSize(1) FigureSize(2)],'units','pixels','Resize','off');
XStep=5;
XModel=0;
while (XModel(end)<50000)
    XModel(end+1)=XModel(end)+XStep;
    XStep=XStep+0.1;
end
XStep=diff(XModel,1);
XStep(end+1)=XStep(end);
XBathymetry(end+1)=50000;
Bathymetry(end+1)=Bathymetry(end);
plot(XBathymetry/1000,-Bathymetry,'LineWidth',4,'color','black');
hold on;
plot(XModel/1000,XStep,'LineWidth',4,'color','blue');

ylabel('(m)');
grid minor;
hold off;
xlabel('Offshore Distance (km)');
title('Model Horizontal Resolution');
legend('Water Column Depth','Cell Size','Location','southeast');
xlim([0, 50]);
set(gca,'fontsize',18);
set(gca,'FontWeight','bold');
saveas(fig,'Resolution.png');