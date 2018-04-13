close all
clc

FigureSize=[1500,600];
f=figure('Position',[1 1 FigureSize(1) FigureSize(2)],'units','pixels','Resize','off');
movegui(f,'center');

plot(Day(DOY>=153 & DOY<182),Level(DOY>=153 & DOY<182),'LineWidth',3);
grid minor
xlabel('Day of the month');
ylabel('Tidal Gauge (m)');
set(gca,'fontsize',18);
set(gca,'FontWeight','bold');
title('NOAA 9413450 Tidal Gauge')
xlabel('June 2017');
xlim([1 31]);
saveas(f,'NOAA June.png');

plot(Day(DOY>=183&DOY<213),Level(DOY>=183&DOY<213),'LineWidth',3);
grid minor
xlabel('Day of the month');
ylabel('Tidal Gauge (m)');
set(gca,'fontsize',18);
set(gca,'FontWeight','bold');
title('NOAA 9413450 Tidal Gauge')
xlabel('July 2017');
xlim([1 31]);
saveas(f,'NOAA July.png');

plot(Day(DOY>=214&DOY<244),Level(DOY>=214&DOY<244),'LineWidth',3);
grid minor
xlabel('Day of the month');
ylabel('Tidal Gauge (m)');
set(gca,'fontsize',18);
set(gca,'FontWeight','bold');
title('NOAA 9413450 Tidal Gauge')
xlabel('August 2017');
xlim([1 31]);
saveas(f,'NOAA Aug.png');