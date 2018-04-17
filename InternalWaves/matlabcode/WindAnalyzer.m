close all;
clear all;
clc

AvgPN=6;
FileAddress='D:\OneDrive - University of Georgia\Documents\UGA Courses\Wind and Tide Study\2017-BirdRock.txt';
content = fileread(FileAddress) ;
Data= textscan(content, '%f %f %f %f %f %f %f %f','HeaderLines', 1) ;
WindSpeed=Data{4};
WindDirection=Data{5};
Time=Data{8};
MonthBegins=[60,91,121,152,182,213];
MonthEnds=[90,120,151,181,212,243];

f=figure('units','normalized','outerposition',[0 0 1 1]);
for MonthCounter=3:8
    subplot(2,3,MonthCounter-2);
    polarhistogram(WindDirection(Time>=MonthBegins(MonthCounter-2) & Time<=MonthEnds(MonthCounter-2))*pi()/180);
    str=strcat('Initial',{' '},num2str(MonthCounter),{' '},'2017');
    title(str);
    set(gca,'fontsize',16);
    set(gca,'FontWeight','bold');
end
saveas(f,'InitialWind.png');

%Converting the meteorological convention to triangular convetion, if wind
%comes from south for meteo would be 180 and for tri 90. Meaning that it
%!!!!GOES!!!! to 90 not come from 90
%Averaging the wind to get it hourly
WindDirection=-WindDirection+270;
WindDirection(WindDirection>360)=WindDirection(WindDirection>360)-360;
WindDirection(WindDirection<0)=WindDirection(WindDirection<0)+360;
%Finding the East-West and South-North components
East=movmean(WindSpeed.*cosd(WindDirection),AvgPN);
North=movmean(WindSpeed.*sind(WindDirection),AvgPN);
Time=movmean(Time,AvgPN);
%Recalculating the WDNOAA
WindDirection=atan2d(North,East);

f=figure('units','normalized','outerposition',[0 0 1 1]);
for MonthCounter=3:8
    subplot(2,3,MonthCounter-2);
    polarhistogram(WindDirection(Time>=MonthBegins(MonthCounter-2) & Time<=MonthEnds(MonthCounter-2))*pi()/180);
    str=strcat('Processed',{' '},num2str(MonthCounter),{' '},'2017');
    title(str);
    set(gca,'fontsize',16);
    set(gca,'FontWeight','bold');
end
saveas(f,'ProccessedWind.png');

f=figure('units','normalized','outerposition',[0 0 1 1]);
C=princaxes(East,North,1);
xlabel('East-West');
ylabel('North-South');
str=sprintf('Max= %1.0f , Min= %1.0f & Elipse Ratio= %1.1f',atand(C(1)),atand(C(2)),C(3));
title(str);
set(gca,'fontsize',18);
set(gca,'FontWeight','bold');
saveas(f,'PCA.png');

%Now I want to rotate the wind to get the alongshore and cross-shore
%components, to do so, I rotate it 120 degrees.
C=[cosd(135),sind(135);-sind(135),cosd(135)];
RotatedWind=[East,North]*C;
EastRotated=RotatedWind(:,1);
NorthRotated=RotatedWind(:,2);
f=figure('units','normalized','outerposition',[0 0 1 1]);
for MonthCounter=3:8
    plot(Time(Time>=MonthBegins(MonthCounter-2) & Time<=MonthEnds(MonthCounter-2)),...
        NorthRotated(Time>=MonthBegins(MonthCounter-2) & Time<=MonthEnds(MonthCounter-2)),'LineWidth',3);
    hold on;
end
line([Time(1),Time(end)],[0,0],'Color','black','LineWidth',3);
xlabel('Day of Year');
ylabel('Wind Speed (m/s)');
title('Alongshore(SW) Wind Speed');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
grid minor;
saveas(f,'AlongshoreWind.png');
