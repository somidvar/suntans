clear all;
close all
clc

XBathymetry=0:10:10000;
XBathymetry=XBathymetry';
Bathymetry=nan(size(XBathymetry,1),1);
%Real values from Walter Paper for Monterey Bay
%X=[41.5162440000000,171.480150000000,301.444050000000,366.426000000000,420.577620000000,474.729240000000,528.880900000000,583.032500000000,637.184140000000,675.090250000000,707.581200000000,767.148000000000,848.375440000000,913.357400000000,1005.41520000000,1124.54880000000,1297.83390000000,1606.49820000000,1920.57760000000,2180.50550000000,2505.41520000000,2884.47640000000,3274.36830000000,3761.73280000000,4232.85200000000,4758.12300000000,5256.31760000000,5694.94600000000,6128.15900000000,6620.93900000000,7037.90600000000,7416.96740000000,7725.63170000000];
%Y=[-5.43629360000000,-7.53667970000000,-10.0077220000000,-13.2200775000000,-16.4942100000000,-19.7683400000000,-22.9189190000000,-26.0077230000000,-29.3436300000000,-33.1737440000000,-37.4362950000000,-41.0810800000000,-44.7258700000000,-48.3088800000000,-51.9536670000000,-54.7335900000000,-57.0810800000000,-59.1196900000000,-60.7258700000000,-62.5173760000000,-64,-65.6061800000000,-67.4594600000000,-69.3745200000000,-71.2278000000000,-73.2046360000000,-74.6254800000000,-75.9227800000000,-76.6640900000000,-77.7142900000000,-78.2702700000000,-78.8262560000000,-79.1969150000000];

for i=1:size(XBathymetry,1)
    if XBathymetry(i)<50
        Bathymetry(i)=-5;
    elseif XBathymetry(i)<1080
        p1 = 5e-11;
        p2 = -3e-8;
        p3 = -7e-5;
        p4 = .0032;
        p5 = -5;
        Bathymetry(i)=p1*XBathymetry(i).^4+p2*XBathymetry(i).^3+p3*XBathymetry(i).^2+p4*XBathymetry(i)+p5;
    elseif XBathymetry(i)<7280
        p1 = 4e-7;
        p2 = -0.0069;
        p3 = -45.97;
        Bathymetry(i)=p1*XBathymetry(i).^2+p2*XBathymetry(i)+p3;
    else
        Bathymetry(i)=-75;
    end
end
FigureSize=[1200,700];
fig=figure('Position',[1 1 FigureSize(1) FigureSize(2)],'units','pixels','Resize','off');
set(fig,'defaultAxesColorOrder',[[0,0,0]; [0,0,1]]);
yyaxis left;
Slope=diff(Bathymetry)./diff(XBathymetry);
Slope(end+1)=Slope(end);
plot(XBathymetry/1000,Bathymetry,'LineWidth',4,'color','black');
ylabel('Depth (m)');
hold on
yyaxis right;
plot(XBathymetry/1000,-Slope,'LineWidth',2,'color','blue');
hold off;
xlabel('Offshore Distance (km)');
ylabel('Bottom slope (m/m)');
grid minor;
title('Bathymetry and Bathymetry Slope');
set(gca,'fontsize',18);
set(gca,'FontWeight','bold');
saveas(fig,'Bathymetry.png');


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

% Front=10*tanh(0.0005*(X-4000));
% Front(Front>0)=0;
% 
% Brown=[153,76,0]/255;
% LightBlue=[51, 153, 255]/255;
% LightRed=[255,51,51]/255;
% LightOrange=[255,153,51]/255;
% LightYellow=[255,255,51]/255;
% BathymetryBaseline=-80*ones(size(Bathymetry,1),1);
% bathy=figure('rend','painters','pos',[10 10 800 500]);
% 
% fill([X'/1000 flip(X'/1000)], [Bathymetry',(BathymetryBaseline+80)'],LightBlue,'LineStyle','none');
% hold on;
% fill([X'/1000 flip(X'/1000)], [Front',(BathymetryBaseline+80)'],LightYellow,'LineStyle','none');
% fill([flip(X'/1000) X'/1000], [BathymetryBaseline',Bathymetry'],Brown,'LineStyle','none');
% set(gca,'fontsize',18);
% set(gca,'FontWeight','bold');
% xlabel('Offshore Distance (Km)');
% ylabel('Depth (m)');
% title('Bathymetry','FontSize',23);
% annotation('arrow',[0.15,0.23],[0.85,0.85],'LineWidth',3);
% annotation('arrow',[0.15,0.23],[0.65,0.65],'LineWidth',3);
% annotation('arrow',[0.15,0.23],[0.45,0.45],'LineWidth',3);
% annotation('arrow',[0.15,0.23],[0.25,0.25],'LineWidth',3);
% 
% annotation('arrow',[0.55,0.63],[0.30,0.33],'LineWidth',4);
% annotation('arrow',[0.55,0.63],[0.45,0.47],'LineWidth',4);
% annotation('arrow',[0.55,0.63],[0.6,0.6],'LineWidth',4);
% annotation('arrow',[0.55,0.63],[0.75,0.74],'LineWidth',4);
% annotation('arrow',[0.55,0.63],[0.88,0.85],'LineWidth',4);
% set(gca,'xdir','reverse')
% grid;
% saveas(bathy,'Bathymetry.png');

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