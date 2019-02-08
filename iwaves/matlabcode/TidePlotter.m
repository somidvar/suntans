close all;
clear all;
clc

Address='D:\OneDrive - University of Georgia\Documents\UGA Courses\Wind and Tide Study\2017 NOAA Tides.xlsx';
WaterLevel='A2:A44161';
Time='H2:H44161';

WaterLevel=xlsread(Address,1,WaterLevel);
Time=xlsread(Address,1,Time);
Latitude=36.62;
if Time(1)==60
    StartTime=[2017,3,1,0,0,0];
else
    sprintf('Please correct the Start Time for T_Tide package')
    return;
end
Results=t_tide(WaterLevel,'interval',1/10,'start time',StartTime,'latitude',Latitude);
Components=Results.name;
Period=Results.freq;
Period=1./Period;
Amplitude=Results.tidecon(:,1);
Phase=Results.tidecon(:,3);
Tides=table(Components,Period,Amplitude,Phase);
Tides=sortrows(Tides,3,'descend');