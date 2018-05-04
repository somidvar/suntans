close all;
clear all;
clc

load InitialConditionData.mat
[XX,ZZ]=meshgrid(Z,X(1:160)/1000);
FigureSize=[1600,800];
f=figure('Position',[1 1 FigureSize(1) FigureSize(2)],'units','pixels','Resize','off');
movegui(f,'center');

pcolor(ZZ,XX,RhoB(1:160,:));
shading flat;
colormap(cool);
h = colorbar;
set( h, 'YDir', 'reverse' );  
xlabel('Offshore Distance (km)');
ylabel('Depth (m)');


annotation('arrow',[0.85,0.78],[0.85,0.85],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.85,0.78],[0.70,0.70],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.85,0.78],[0.55,0.55],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.85,0.78],[0.37,0.37],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);

annotation('arrow',[0.65,0.58],[0.85,0.85],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.65,0.58],[0.70,0.70],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.65,0.58],[0.55,0.55],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.65,0.58],[0.40,0.41],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);

annotation('arrow',[0.48,0.42],[0.86,0.87],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.48,0.42],[0.72,0.74],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.48,0.42],[0.59,0.62],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.48,0.42],[0.45,0.51],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);

annotation('arrow',[0.36,0.31],[0.88,0.90],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.35,0.30],[0.79,0.825],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.33,0.29],[0.70,0.76],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
set(gca,'fontsize',18);
set(gca,'FontWeight','bold');
annotation(f,'textbox',[0.08,0.84,0.1,0.1],'String','a)','fontsize',20,'FontWeight','bold','EdgeColor','none');
saveas(f,'FloodTide.png');

FigureSize=[1600,800];
f=figure('Position',[1 1 FigureSize(1) FigureSize(2)],'units','pixels','Resize','off');
movegui(f,'center');

pcolor(ZZ,XX,RhoB(1:160,:));
shading flat;
colormap(cool);
h = colorbar;
set( h, 'YDir', 'reverse' );  
xlabel('Offshore Distance (km)');
ylabel('Depth (m)');

annotation('arrow',[0.78,0.85],[0.85,0.85],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.78,0.85],[0.70,0.70],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.78,0.85],[0.55,0.55],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.78,0.85],[0.37,0.37],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);

annotation('arrow',[0.58,0.65],[0.85,0.85],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.58,0.65],[0.70,0.70],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.58,0.65],[0.55,0.55],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.58,0.65],[0.41,0.40],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);

annotation('arrow',[0.42,0.48],[0.87,0.86],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.42,0.48],[0.74,0.72],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.42,0.48],[0.62,0.59],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.42,0.48],[0.51,0.45],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);

annotation('arrow',[0.31,0.36],[0.90,0.88],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.30,0.35],[0.825,0.79],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);
annotation('arrow',[0.29,0.33],[0.76,0.70],'LineWidth',8,'HeadStyle','vback1','HeadWidth',30);


set(gca,'fontsize',18);
set(gca,'FontWeight','bold');
annotation(f,'textbox',[0.08,0.84,0.1,0.1],'String','b)','fontsize',20,'FontWeight','bold','EdgeColor','none');
saveas(f,'EbbTide.png');
