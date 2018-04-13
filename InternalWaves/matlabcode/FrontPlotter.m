close all;
clear all
clc

Address='F:\8th\8th-Processed\80005EnergyFlux.nc';
FigureSize=[1600,800];
f=figure('Position',[1 1 FigureSize(1) FigureSize(2)],'units','pixels','Resize','off');
movegui(f,'center');

k=37;
    Density1=ncread(Address,'Density',[1,1,k],[100,Inf,1]);
    X=ncread(Address,'X',1,100);
    Z=ncread(Address,'Z');
    Time=ncread(Address,'Time');
    [XX,ZZ]=meshgrid(Z,X);

    pcolor(ZZ/1000,XX,Density1);
    xlabel('Distance off-shore (Km)');
    ylabel('Depth (m)');
    hold on;
    shading flat;
    colorbar;
    colormap('cool');
    h = colorbar;

    set( h, 'YDir', 'reverse' );   
    set(gca,'layer','top');
    MinDensity=min(min(min(Density1)));
    MaxDensity=max(max(max(Density1)));
    ContourLevel=round(MinDensity,1):0.2:round(MaxDensity,1);
    [C,H]=contour(ZZ/1000,XX,Density1,ContourLevel,'black');   
    H.LineStyle='--';
    %clabel(C,H,'FontSize',18,'LabelSpacing',1000)
    hold off;
    set(gca,'fontsize',18);
    set(gca,'FontWeight','bold');
    grid minor;
    str1=sprintf('Density (kg/m^3) at Flood Time',k);
    title(str1);
    saveas(f,'Flood Time.png');


FigureSize=[1600,800];
f=figure('Position',[1 1 FigureSize(1) FigureSize(2)],'units','pixels','Resize','off');
movegui(f,'center');
k=80;
    Density2=ncread(Address,'Density',[1,1,k],[100,Inf,1]);
    Density2(Density2<1025.6229)=1025.3;
    X=ncread(Address,'X',1,100);
    Z=ncread(Address,'Z');
    Time=ncread(Address,'Time');
    [XX,ZZ]=meshgrid(Z,X);
    caxis([1025.5 1026.5]);

    pcolor(ZZ/1000,XX,Density2);
    xlabel('Distance off-shore (Km)');
    ylabel('Depth (m)');
    hold on;
    shading flat;
    colorbar;
    colormap('cool');
    h = colorbar;
    
    set( h, 'YDir', 'reverse' );   
    set(gca,'layer','top');
    MinDensity=min(min(min(Density2)));
    MaxDensity=max(max(max(Density2)));
    ContourLevel=round(MinDensity,1):0.2:round(MaxDensity,1);
    [C,H]=contour(ZZ/1000,XX,Density2,ContourLevel,'black');   
    H.LineStyle='--';
    %clabel(C,H,'FontSize',18,'LabelSpacing',1000)
    hold off;
    set(gca,'fontsize',18);
    set(gca,'FontWeight','bold');
    grid minor;
    str1=sprintf('Density (kg/m^3)',k);
    title(str1);
    saveas(f,'Ebb Time.png');
    
    
FigureSize=[1600,800];
f=figure('Position',[1 1 FigureSize(1) FigureSize(2)],'units','pixels','Resize','off');
movegui(f,'center');
k=77;    

    Density3=Density2-Density1;
    X=ncread(Address,'X',1,100);
    Z=ncread(Address,'Z');
    Time=ncread(Address,'Time');
    [XX,ZZ]=meshgrid(Z,X);

    pcolor(ZZ/1000,XX,Density3);
    xlabel('Distance off-shore (Km)');
    ylabel('Depth (m)');
    hold on;
    shading flat;
    colorbar;
    colormap('cool');
    h = colorbar;

    set( h, 'YDir', 'reverse' );   
    set(gca,'layer','top');
    MinDensity=min(min(min(Density3)));
    MaxDensity=max(max(max(Density3)));
    ContourLevel=round(MinDensity,1):0.05:round(MaxDensity,1);
    [C,H]=contour(ZZ/1000,XX,Density3,ContourLevel,'black');   
    H.LineStyle='--';
    %clabel(C,H,'FontSize',18,'LabelSpacing',1000)
    hold off;
    set(gca,'fontsize',18);
    set(gca,'FontWeight','bold');
    grid minor;
    str1=sprintf('Density Difference (Kg/m^3)',k);
    title(str1);
    saveas(f,'Difference.png');