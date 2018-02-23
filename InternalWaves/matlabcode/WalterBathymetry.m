clear all;
close all
clc

X=0:10:50000;
X=X';
Bathymetry=nan(size(X,1),1);
%Real values from Walter Paper for Monterey Bay
%X=[41.5162440000000,171.480150000000,301.444050000000,366.426000000000,420.577620000000,474.729240000000,528.880900000000,583.032500000000,637.184140000000,675.090250000000,707.581200000000,767.148000000000,848.375440000000,913.357400000000,1005.41520000000,1124.54880000000,1297.83390000000,1606.49820000000,1920.57760000000,2180.50550000000,2505.41520000000,2884.47640000000,3274.36830000000,3761.73280000000,4232.85200000000,4758.12300000000,5256.31760000000,5694.94600000000,6128.15900000000,6620.93900000000,7037.90600000000,7416.96740000000,7725.63170000000];
%Y=[-5.43629360000000,-7.53667970000000,-10.0077220000000,-13.2200775000000,-16.4942100000000,-19.7683400000000,-22.9189190000000,-26.0077230000000,-29.3436300000000,-33.1737440000000,-37.4362950000000,-41.0810800000000,-44.7258700000000,-48.3088800000000,-51.9536670000000,-54.7335900000000,-57.0810800000000,-59.1196900000000,-60.7258700000000,-62.5173760000000,-64,-65.6061800000000,-67.4594600000000,-69.3745200000000,-71.2278000000000,-73.2046360000000,-74.6254800000000,-75.9227800000000,-76.6640900000000,-77.7142900000000,-78.2702700000000,-78.8262560000000,-79.1969150000000];

for i=1:size(X,1)
    if X(i)<50
        Bathymetry(i)=-5;
    elseif X(i)<1080
        p1 = 5e-11;
        p2 = -3e-8;
        p3 = -7e-5;
        p4 = .0032;
        p5 = -5;
        Bathymetry(i)=p1*X(i).^4+p2*X(i).^3+p3*X(i).^2+p4*X(i)+p5;
    elseif X(i)<7280
        p1 = 4e-7;
        p2 = -0.0069;
        p3 = -45.97;
        Bathymetry(i)=p1*X(i).^2+p2*X(i)+p3;
    else
        Bathymetry(i)=-75;
    end
end
bathy=figure('rend','painters','pos',[10 10 800 500])
plot(X(1:1000)/1000,Bathymetry(1:1000),'LineWidth',6);
set(gca,'fontsize',18);
set(gca,'FontWeight','bold')
xlabel('Offshore Distance (Km)')
ylabel('Depth (m)');
title('Bathymetry','FontSize',23);
saveas(bathy,'Bathymetry.png');
grid;
       

profile=figure('rend','painters','pos',[10 10 800 800]);
subplot('position',[.1 .20 .8 .65]);
set(gca,'fontsize',18);
set(gca,'FontWeight','bold');
DataPath='F:\7th\suntans-7th-70001\InternalWaves\data\Result_0000.nc';
Z=-ncread(DataPath,'z_r');
RhoB=1000+1000*ncread(DataPath,'rho',[1,1,1],[Inf,Inf,1]);
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