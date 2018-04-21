%This code is plotting the SUNTANS results for several case scenarios with
%similar names. This code is written by Sorush Omidvar in July 2016 at UGA.
%This vesion is modified in Jan 2018.
close all;
clear all;
clc

CaseNumber=70047;
format compact;
disp(strcat('Case Number= ',num2str(CaseNumber)))

CurrentLocation=pwd;
if contains(CurrentLocation,'lustre1')
    SapeloFlag=1;
else
    SapeloFlag=0;
end
clear CurrentLocation;

if SapeloFlag
    DataPath=strcat('/lustre1/omidvar/work-directory_0801/9th/suntans-9th-',num2str(CaseNumber),'/InternalWaves/data/Result_0000.nc');
    OutputAddress='/lustre1/omidvar/work-directory_0801/9th-New/';
else
    DataPath=strcat('F:\9th\suntans-9th-',num2str(CaseNumber),'\InternalWaves\data\Result_0000.nc');
    OutputAddress='F:\';
end

if exist(DataPath,'file')==0
    disp('There is no NETCDF file to process')
    return;
end

KnuH=1;
KappaH=0;
g=9.8;
InterpolationEnhancement=10;%Resolution of interpolation in energy flux calculation 
XEndIndex=Inf;% The data trim after this X point
TimeStartIndex=1009;%This is 27 cycles of M2 and 14 cycles of K1 and wind
TimeEndIndex=3025;%This is 27 cycles of M2 and 14 cycles of K1 and wind

AnalysisSpeed=1;
FPSMovie=15;

WindTauMax=0;
WindOmega=2*pi/(24*3600);
DiurnalTideOmega=2*pi()/23.93/3600;
SemiDiurnalTideOmega=2*pi()/12.4/3600;

%WavePlotter(AnalysisSpeed,FPSMovie,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,WindTauMax,DataPath,OutputAddress,CaseNumber);
EnergyFluxCalculator(DataPath,CaseNumber,OutputAddress,...
    KnuH,KappaH,g,InterpolationEnhancement,XEndIndex,...
    DiurnalTideOmega,SemiDiurnalTideOmega,WindTauMax,TimeStartIndex,...
    TimeEndIndex,SapeloFlag);