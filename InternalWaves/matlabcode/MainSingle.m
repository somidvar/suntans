%This code is plotting the SUNTANS results for several case scenarios with
%similar names. This code is written by Sorush Omidvar in July 2016 at UGA.
%This vesion is modified in Jan 2018.
close all;
clear all;
clc

CaseNumber=10010;
format compact;
disp(strcat('Case Number= ',num2str(CaseNumber)))

SapeloFlag=0;
if SapeloFlag
    DataPath=strcat('/lustre1/omidvar/work-directory_0801/6th-New/suntans-6th-',num2str(CaseNumber),'/InternalWaves/data/Result_0000.nc');
    CurrentPath=pwd;
    CurrentPath=strcat(CurrentPath,'\');
else
    DataPath=strcat('F:\6th\suntans-6th-',num2str(CaseNumber),'\InternalWaves\data\Result_0000.nc');
end
DataPath='D:\Result_0000.nc';
CurrentPath='D:\';
if exist(DataPath,'file')==0
    disp('There is no NETCDF file to process')
    return;
end

KnuH=0.1;
g=9.8;  
KappaH=0;
DragCoeff=0.005;
InterpolationEnhancement=10;%Resolution of interpolation in energy flux calculation 
XEndIndex=50;% The data trim after this X point
XLocation=17;
TimeStartIndex=5888;%This is 27 cycles of M2 and 14 cycles of K1 and wind
TimeEndIndex=9917;%This is 27 cycles of M2 and 14 cycles of K1 and wind

AnalysisSpeed=2;
FPSMovie=5;

%Setting the wind frequency based on the cases
TauMax=0;
SemiDiurnalTideOmega=0;
DiurnalTideOmega=0;
WindOmega=2*pi/(24*3600);
PycnoclineDepthIndex=0;

%Setting the wind stress based on the cases
if floor((CaseNumber-10000)/20)==0
    WindTauMax=0e-5;
elseif floor((CaseNumber-10000)/20)==1
    WindTauMax=2e-5;
elseif floor((CaseNumber-10000)/20)==2
    WindTauMax=4e-5;
elseif floor((CaseNumber-10000)/20)==3
    WindTauMax=6e-5;
elseif floor((CaseNumber-10000)/20)==4
    WindTauMax=8e-5;
end    
%Setting the pycnocline depth based on the cases
if mod(CaseNumber-10000,20)<4
    PycnoclineDepthIndex=11;%-5 meter
    BathymetryXLocationAtPycnoclineIndex=5;
elseif mod(CaseNumber-10000,20)<8
    PycnoclineDepthIndex=22;%-10 meter
    BathymetryXLocationAtPycnoclineIndex=8;
elseif mod(CaseNumber-10000,20)<12
    PycnoclineDepthIndex=33;%-15 meter
    BathymetryXLocationAtPycnoclineIndex=9;
elseif mod(CaseNumber-10000,20)<16
    PycnoclineDepthIndex=43;%-20 meter
    BathymetryXLocationAtPycnoclineIndex=11;
elseif mod(CaseNumber-10000,20)<20
    PycnoclineDepthIndex=54;%-25 meter
    BathymetryXLocationAtPycnoclineIndex=13;
end    
%Setting the dirunal and semi-dirunal tide frequency based on the cases
if mod(CaseNumber,4)==0
    DiurnalTideOmega=0;
    SemiDiurnalTideOmega=0;
elseif mod(CaseNumber,4)==1
    DiurnalTideOmega=2*pi/(23.93*3600);
    SemiDiurnalTideOmega=0;
elseif mod(CaseNumber,4)==2
    DiurnalTideOmega=0;
    SemiDiurnalTideOmega=2*pi/(12.42*3600);
elseif mod(CaseNumber,4)==3
    DiurnalTideOmega=2*pi/(23.93*3600);
    SemiDiurnalTideOmega=2*pi/(12.42*3600);        
end
WavePlotter(AnalysisSpeed,FPSMovie,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,TauMax,DataPath,CurrentPath,CaseNumber);
% EnergyFluxCalculatorVer14(DataPath,CaseNumber,...
%     KnuH,KappaH,g,InterpolationEnhancement,XLocation,XEndIndex,...
%     DiurnalTideOmega,SemiDiurnalTideOmega,TauMax,TimeStartIndex,...
%     TimeEndIndex,PycnoclineDepthIndex,BathymetryXLocationAtPycnoclineIndex,SapeloFlag);
