close all
clear all
clc

AvgPN=10;
FileAddress='D:\OneDrive - University of Georgia\Documents\UGA Courses\Wind and Tide Study\2017NOAA.txt';
content = fileread(FileAddress) ;
Data= textscan(content, '%d %d %d %d %d %d %f %f %d','HeaderLines', 1) ;
YearNOAA=movmean(Data{1},AvgPN);
TimeNOAA=movmean(Data{7},AvgPN);
WSNOAA=movmean(Data{8},AvgPN);
WDNOAA=movmean(Data{9},AvgPN);

subplot(1,3,1)
MonthCounter=6;
    TimePeriodMin=30*(MonthCounter-1);
    TimePeriodMax=30*MonthCounter;
    TimePeriod=TimeNOAA(TimeNOAA>TimePeriodMin & TimeNOAA<TimePeriodMax);
    WDPeriodNOAA=WDNOAA(TimeNOAA>TimePeriodMin & TimeNOAA<TimePeriodMax);
    WSPeriodNOAA=WSNOAA(TimeNOAA>TimePeriodMin & TimeNOAA<TimePeriodMax);

    East=-1*WSPeriodNOAA.*cos(WDPeriodNOAA*pi()/180);
    North=-1*WSPeriodNOAA.*sin(WDPeriodNOAA*pi()/180);
    Theta=princaxes(East,North,1);
    Phi=Theta(1);
    C=[cos(Phi), cos(Phi+pi()/2);cos(pi()/2-Phi), cos(Phi)];
    grid minor;
    title('Jun 2017');
    xlabel(strcat('X:',num2str(Theta(1)*180/pi())));
    ylabel(strcat('Y:',num2str(90+Theta(1)*180/pi())));
    set(gca,'fontsize',18);
    set(gca,'FontWeight','bold');
    
subplot(1,3,2)    
MonthCounter=7;    
    TimePeriodMin=30*(MonthCounter-1);
    TimePeriodMax=30*MonthCounter;
    TimePeriod=TimeNOAA(TimeNOAA>TimePeriodMin & TimeNOAA<TimePeriodMax);
    WDPeriodNOAA=WDNOAA(TimeNOAA>TimePeriodMin & TimeNOAA<TimePeriodMax);
    WSPeriodNOAA=WSNOAA(TimeNOAA>TimePeriodMin & TimeNOAA<TimePeriodMax);

    East=-1*WSPeriodNOAA.*cos(WDPeriodNOAA*pi()/180);
    North=-1*WSPeriodNOAA.*sin(WDPeriodNOAA*pi()/180);
    Theta=princaxes(East,North,1);
    hold on;
    Phi=Theta(1);
    C=[cos(Phi), cos(Phi+pi()/2);cos(pi()/2-Phi), cos(Phi)];
    grid minor;
    title('Jul 2017');
    xlabel(strcat('X:',num2str(Theta(1)*180/pi())));
    ylabel(strcat('Y:',num2str(90+Theta(1)*180/pi())));
    set(gca,'fontsize',18);
    set(gca,'FontWeight','bold');
    
subplot(1,3,3)
MonthCounter=8;    
    TimePeriodMin=30*(MonthCounter-1);
    TimePeriodMax=30*MonthCounter;
    TimePeriod=TimeNOAA(TimeNOAA>TimePeriodMin & TimeNOAA<TimePeriodMax);
    WDPeriodNOAA=WDNOAA(TimeNOAA>TimePeriodMin & TimeNOAA<TimePeriodMax);
    WSPeriodNOAA=WSNOAA(TimeNOAA>TimePeriodMin & TimeNOAA<TimePeriodMax);

    East=-1*WSPeriodNOAA.*cos(WDPeriodNOAA*pi()/180);
    North=-1*WSPeriodNOAA.*sin(WDPeriodNOAA*pi()/180);
    Theta=princaxes(East,North,1);
    Phi=Theta(1);
    C=[cos(Phi), cos(Phi+pi()/2);cos(pi()/2-Phi), cos(Phi)];
    grid minor;
    title('Aug 2017');
    xlabel(strcat('X:',num2str(Theta(1)*180/pi())));
    ylabel(strcat('Y:',num2str(90+Theta(1)*180/pi())));
    set(gca,'fontsize',18);
    set(gca,'FontWeight','bold');
