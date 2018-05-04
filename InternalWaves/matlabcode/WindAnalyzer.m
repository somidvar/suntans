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
MonthNames={'Mar','Apr','May','Jun','Jul','Aug'};
f=figure('units','normalized','outerposition',[0 0 1 1]);
for MonthCounter=3:8
    subplot(2,3,MonthCounter-2);
    polarhistogram(WindDirection(Time>=MonthBegins(MonthCounter-2) & Time<=MonthEnds(MonthCounter-2))*pi()/180);
    set(gca,'fontsize',16);
    set(gca,'FontWeight','bold');
end
annotation(f,'textbox',[0.09 0.95 0.04 0.04],'String','a)','fontsize',20,'EdgeColor','none','FontWeight','bold');
annotation(f,'textbox',[0.37 0.95 0.04 0.04],'String','b)','fontsize',20,'EdgeColor','none','FontWeight','bold');
annotation(f,'textbox',[0.66 0.95 0.04 0.04],'String','c)','fontsize',20,'EdgeColor','none','FontWeight','bold');
annotation(f,'textbox',[0.09 0.47 0.04 0.04],'String','d)','fontsize',20,'EdgeColor','none','FontWeight','bold');
annotation(f,'textbox',[0.37 0.47 0.04 0.04],'String','e)','fontsize',20,'EdgeColor','none','FontWeight','bold');
annotation(f,'textbox',[0.66 0.47 0.04 0.04],'String','f)','fontsize',20,'EdgeColor','none','FontWeight','bold');
saveas(f,'D:\github\suntans\InternalWaves\matlabcode\4-a.png');

f=figure('units','normalized','outerposition',[0 0 1 1]);
C=princaxes(East,North,1);

saveas(f,'D:\github\suntans\InternalWaves\matlabcode\4-b.png');

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
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
grid minor;
saveas(f,'D:\github\suntans\InternalWaves\matlabcode\4-c.png');

f=figure('units','normalized','outerposition',[0 0 1 1]);
Fs = 1/0.16*24*365;
for MonthCounter=3:8
    Data=NorthRotated(Time>=MonthBegins(MonthCounter-2) & Time<=MonthEnds(MonthCounter-2));
    subplot(2,3,MonthCounter-2);

    [Pxx,F]=pmtm(NorthRotated,5/2,[],1/600);
    semilogx(F.*86400,sqrt(Pxx.*F));
    xlim([0.01,10]);
    grid;
    set(gca,'fontsize',18);
    set(gca,'FontWeight','bold');
end
annotation(f,'textbox',[0.13 0.88 0.04 0.04],'String','a)','fontsize',20,'EdgeColor','none','FontWeight','bold');
annotation(f,'textbox',[0.41 0.88 0.04 0.04],'String','b)','fontsize',20,'EdgeColor','none','FontWeight','bold');
annotation(f,'textbox',[0.69 0.88 0.04 0.04],'String','c)','fontsize',20,'EdgeColor','none','FontWeight','bold');
annotation(f,'textbox',[0.13 0.41 0.04 0.04],'String','d)','fontsize',20,'EdgeColor','none','FontWeight','bold');
annotation(f,'textbox',[0.41 0.41 0.04 0.04],'String','e)','fontsize',20,'EdgeColor','none','FontWeight','bold');
annotation(f,'textbox',[0.69 0.41 0.04 0.04],'String','f)','fontsize',20,'EdgeColor','none','FontWeight','bold');
saveas(f,'D:\github\suntans\InternalWaves\matlabcode\4-d.png');
