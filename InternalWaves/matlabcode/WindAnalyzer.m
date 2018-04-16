close all;
clear all;
clc

AvgPN=1;
FileAddress='D:\OneDrive - University of Georgia\Documents\UGA Courses\Wind and Tide Study\2015NOAA.txt';
content = fileread(FileAddress) ;
Data= textscan(content, '%d %d %d %d %d %d %f %f %f','HeaderLines', 1) ;
WSNOAA=Data{8};
WDNOAA=Data{9};
TimeNOAA=Data{7};

WDNOAA=-WDNOAA+270;%Converting the compass corrdinate system to polar coordinate system
WDNOAA(WDNOAA>360)=WDNOAA(WDNOAA>360)-360;
WDNOAA(WDNOAA<0)=WDNOAA(WDNOAA<0)+360;
figure
polarhistogram(WDNOAA(TimeNOAA>=180 & TimeNOAA<210)*pi()/180);
%filtering the small wind
WSNOAA(abs(WSNOAA)<0.5)=nan;
WDNOAA(abs(WSNOAA)<0.5)=nan;
TimeNOAA(abs(WSNOAA)<0.5)=nan;

%Averaging the wind to get it hourly
East=movmean(WSNOAA.*cosd(WDNOAA),AvgPN);
North=movmean(WSNOAA.*sind(WDNOAA),AvgPN);
TimeNOAA=movmean(TimeNOAA,AvgPN);
%Recalculating the WDNOAA
WDNOAA=atan2d(North,East);
WDNOAA(WDNOAA>360)=WDNOAA(WDNOAA>360)-360;
WDNOAA(WDNOAA<0)=WDNOAA(WDNOAA<0)+360;

EastRotated=nan(size(WDNOAA,1),1);
NorthRotated=nan(size(WDNOAA,1),1);
fig=figure('units','normalized','outerposition',[0 0 1 1]);
for MonthCounter=7:8
    TimePeriodMin=30*(MonthCounter-1);
    TimePeriodMax=30*MonthCounter;
    TimePeriod=TimeNOAA(TimeNOAA>TimePeriodMin & TimeNOAA<TimePeriodMax);
    WDPeriod=WDNOAA(TimeNOAA>TimePeriodMin & TimeNOAA<TimePeriodMax);
    polarhistogram(WDPeriod*pi()/180);
    
    TempEast=East(TimeNOAA>TimePeriodMin & TimeNOAA<TimePeriodMax);
    TempNorth=North(TimeNOAA>TimePeriodMin & TimeNOAA<TimePeriodMax);
    RotationAngle=120;
    C=[cosd(RotationAngle),sind(RotationAngle);-sind(RotationAngle),cosd(RotationAngle)];

    sprintf(strcat('Rotation Angle=',num2str(RotationAngle)));
    Temp=[TempEast,TempNorth]*C;
    EastRotated(TimeNOAA>TimePeriodMin & TimeNOAA<TimePeriodMax)=Temp(:,1);
    NorthRotated(TimeNOAA>TimePeriodMin & TimeNOAA<TimePeriodMax)=Temp(:,2);
    plot(TimePeriod,TempEast,'LineWidth',2);
    hold on;
    Divider=line([TimePeriod(1),TimePeriod(end)],[0,0]);
    Divider.LineWidth=2;
    Divider.Color='black';
    grid minor;
%     XTickLable=TimePeriodMin:5:TimePeriodMax;
%     xticks(XTickLable);
%     switch MonthCounter
%         case 1
%             str=strcat('Jan',{' '},num2str(YearNOAA(MonthCounter)));
%         case 2
%             str=strcat('Feb',{' '},num2str(YearNOAA(MonthCounter)));
%         case 3
%             str=strcat('Mar',{' '},num2str(YearNOAA(MonthCounter)));
%         case 4
%             str=strcat('Apr',{' '},num2str(YearNOAA(MonthCounter)));
%         case 5
%             str=strcat('May',{' '},num2str(YearNOAA(MonthCounter)));
%         case 6
%             str=strcat('Jun',{' '},num2str(YearNOAA(MonthCounter)));
%         case 7
%             str=strcat('Jul',{' '},num2str(YearNOAA(MonthCounter)));
%         case 8
%             str=strcat('Aug',{' '},num2str(YearNOAA(MonthCounter)));
%     end
%    title(str);

end
title('NOAA 9413450 Meteorological Gauge');
xlabel('Day of the year');
ylabel('Alongshore Wind Speed (m/s)');
set(gca,'fontsize',18);
set(gca,'FontWeight','bold');
hold off;
saveas(fig,strcat('2017','NOAA','.png'));

fig=figure('units','normalized','outerposition',[0 0 1 1]);
NorthRotated=Temp(:,2);
EastRotated=Temp(:,1);
Direction=atan(abs(NorthRotated./EastRotated));
Direction(NorthRotated>0 & EastRotated>0)=0+Direction(NorthRotated>0 & EastRotated>0);
Direction(NorthRotated>0 & EastRotated<0)=pi()-Direction(NorthRotated>0 & EastRotated<0);
Direction(NorthRotated<0 & EastRotated<0)=pi()+Direction(NorthRotated<0 & EastRotated<0);
Direction(NorthRotated<0 & EastRotated>0)=0-Direction(NorthRotated<0 & EastRotated>0);
polarhistogram(Direction);
