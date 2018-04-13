close all;
clear all;
clc

AvgPN=10;
%The wind direction data from NOAA website is showing the end of the
%direction arrow. i.e if the wind comes from south it shows 180 and if it
%comes from west it shows 270

% FileAddress='D:\OneDrive - University of Georgia\Documents\UGA Courses\Wind Study\BirdRock.txt';
% content = fileread(FileAddress) ;
% Data= textscan(content, '%d %d %d %d %d %f %f %f %f','HeaderLines', 1) ;
% YearBR=movmean(Data{1},AvgPN);
% DayBR=movmean(Data{2},AvgPN);
% HourBR=movmean(Data{4},AvgPN);
% MinBR=movmean(Data{5},AvgPN);
% WsBR=movmean(Data{6},AvgPN);
% WdBR=movmean(Data{7},AvgPN);
% TimeBR=movmean(Data{9},AvgPN);
% 
% FileAddress='D:\OneDrive - University of Georgia\Documents\UGA Courses\Wind Study\WestBeach.txt';
% content = fileread(FileAddress) ;
% Data= textscan(content, '%d %d %d %d %d %f %f %f %f','HeaderLines', 1) ;
% YearWB=movmean(Data{1},AvgPN);
% DayWB=movmean(Data{2},AvgPN);
% HourWB=movmean(Data{4},AvgPN);
% MinWB=movmean(Data{5},AvgPN);
% WsWB=movmean(Data{6},AvgPN);
% WdWB=movmean(Data{7},AvgPN);
% TimeWB=movmean(Data{9},AvgPN);

FileAddress='D:\OneDrive - University of Georgia\Documents\UGA Courses\Wind and Tide Study\2017NOAA.txt';
content = fileread(FileAddress) ;
Data= textscan(content, '%d %d %d %d %d %d %f %f %d','HeaderLines', 1) ;
YearNOAA=movmean(Data{1},AvgPN);
TimeNOAA=movmean(Data{7},AvgPN);
WSNOAA=movmean(Data{8},AvgPN);
WDNOAA=movmean(Data{9},AvgPN);
fig=figure('units','normalized','outerposition',[0 0 1 1]);

for MonthCounter=5:7
    TimePeriodMin=30*(MonthCounter-1);
    TimePeriodMax=30*MonthCounter;
    TimePeriod=TimeNOAA(TimeNOAA>TimePeriodMin & TimeNOAA<TimePeriodMax);
    WDPeriodNOAA=WDNOAA(TimeNOAA>TimePeriodMin & TimeNOAA<TimePeriodMax);
    WSPeriodNOAA=WSNOAA(TimeNOAA>TimePeriodMin & TimeNOAA<TimePeriodMax);

    East=-1*WSPeriodNOAA.*cos(WDPeriodNOAA*pi()/180);
    North=-1*WSPeriodNOAA.*sin(WDPeriodNOAA*pi()/180);
    Theta=princaxes(East,North,0);
    Theta=Theta(1);
    C=[cos(Theta), cos(Theta+pi()/2);cos(pi()/2-Theta), cos(Theta)];
    New=C*[East';North'];
    EastNew=New(1,:)';
    NorthNew=New(2,:)';
    
    plot(TimePeriod,-EastNew,'LineWidth',2);
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
    title('NOAA 9413450 Meteorological Gauge');
    xlabel('Day of the year');
    ylabel('Shoreward Wind Speed (m/s)');

    
end
hold off;
set(gca,'fontsize',18);
set(gca,'FontWeight','bold');
saveas(fig,strcat('2017','NOAA','.png'));

% for YearCounter=2012:2017
%     Year=YearCounter;
%     for MonthCounter=3:8
%         fig=figure('units','normalized','outerposition',[0 0 1 1])
%         DayMin=(MonthCounter-1)*30;
%         DayMax=MonthCounter*30;
%         XTickLable=DayMin:DayMax;   
%         TimePeriodBR=TimeBR(DayBR>DayMin & DayBR<DayMax & YearBR==Year);
%         WindSpeed=WsBR(DayBR>DayMin & DayBR<DayMax & YearBR==Year);
%         WindDirection=WdBR(DayBR>DayMin & DayBR<DayMax & YearBR==Year);
%         East=WindSpeed.*cos(WindDirection*pi()/180);
%         North=WindSpeed.*sin(WindDirection*pi()/180);
%         Theta=princaxes(East,North,0);
%         Theta=Theta(1)
%         C=[cos(Theta), cos(Theta+pi()/2);cos(pi()/2-Theta), cos(Theta)];
%         C=transpose(C);
%         New=C*[East';North'];
%         EastNewBR=New(1,:)';
%         NorthNewBR=New(2,:)';
% 
%         TimePeriodWB=TimeWB(DayWB>DayMin & DayWB<DayMax & YearWB==Year);
%         WindSpeed=WsWB(DayWB>DayMin & DayWB<DayMax & YearWB==Year);
%         WindDirection=WdWB(DayWB>DayMin & DayWB<DayMax & YearWB==Year);
%         East=WindSpeed.*cos(WindDirection*pi()/180);
%         North=WindSpeed.*sin(WindDirection*pi()/180);
%         %Theta=princaxes(East,North,1);
%         %Theta=Theta(1);
%         %C=[cos(Theta), cos(Theta+pi()/2);cos(pi()/2-Theta), cos(Theta)];
%         %C=transpose(C);
%         New=C*[East';North'];
%         EastNewWB=New(1,:)';
%         NorthNewWB=New(2,:)';
% 
%         plot(TimePeriodWB,EastNewWB,'blue');
%         hold on;
%         plot(TimePeriodBR,EastNewBR,'red');
%         grid minor;
%         xticks(XTickLable);
%         str=strcat('Year',num2str(Year),'Month',num2str(MonthCounter));
%         legend('West Beach','Bird Rock');
%         title(str);
%         xlabel('Day of the year');
%         ylabel('PCA Wind speed (m/s)');
%         
%         saveas(fig,strcat(str,'.png'));
%         close all;
%         
%     end
% end
