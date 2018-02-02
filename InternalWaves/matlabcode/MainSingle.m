%This code is plotting the SUNTANS results for several case scenarios with
%similar names. This code is written by Sorush Omidvar in July 2016 at UGA.
%This vesion is modified in Jan 2018.
close all;
clear all;
clc

CaseNumber=70010;
format compact;
disp(strcat('Case Number= ',num2str(CaseNumber)))

SapeloFlag=0;
if SapeloFlag
    DataPath=strcat('/lustre1/omidvar/work-directory_0801/7th/suntans-7th-',num2str(CaseNumber),'/InternalWaves/data/Result_0000.nc');
    OutputAddress='/lustre1/omidvar/work-directory_0801/7th-New/'
else
    DataPath=strcat('F:\7th\suntans-7th-',num2str(CaseNumber),'\InternalWaves\data\Result_0000.nc');
    OutputAddress='F:\';
    DataPath='F:\7th\suntans-7th-70001\InternalWaves\data\Result_0000.nc';
end

if exist(DataPath,'file')==0
    disp('There is no NETCDF file to process')
    return;
end

KnuH=1;
KappaH=0;
g=9.8;
InterpolationEnhancement=10;%Resolution of interpolation in energy flux calculation 
XEndIndex=250;% The data trim after this X point
TimeStartIndex=5888/2;%This is 27 cycles of M2 and 14 cycles of K1 and wind
TimeEndIndex=floor(9917/2);%This is 27 cycles of M2 and 14 cycles of K1 and wind

AnalysisSpeed=1;
FPSMovie=15;

%Setting the wind frequency based on the cases
WindTauMax=0;
SemiDiurnalTideOmega=0;
DiurnalTideOmega=0;
WindOmega=2*pi/(24*3600);

PycnoclineDepthIndex=20;BathymetryXLocationAtPycnoclineIndex=14;%for Pycno=10
%PycnoclineDepthIndex=30;BathymetryXLocationAtPycnoclineIndex=20;%for Pycno=10
%PycnoclineDepthIndex=40;BathymetryXLocationAtPycnoclineIndex=24;%for Pycno=10

WavePlotter(AnalysisSpeed,FPSMovie,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,WindTauMax,DataPath,OutputAddress,CaseNumber);
EnergyFluxCalculator(DataPath,CaseNumber,OutputAddress,...
    KnuH,KappaH,g,InterpolationEnhancement,XEndIndex,...
    DiurnalTideOmega,SemiDiurnalTideOmega,WindTauMax,TimeStartIndex,...
    TimeEndIndex,PycnoclineDepthIndex,BathymetryXLocationAtPycnoclineIndex,SapeloFlag);