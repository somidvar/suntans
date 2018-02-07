close all;
clear all;
clc

CaseNumber=70046;
DiurnalTideOmega=0.0000e+000;
SemiDiurnalTideOmega=1.4053e-004;
WindTauMax=7.5E-05;
PycnoclineDepthIndex=40;
BathymetryXLocationAtPycnoclineIndex=24;
format compact;
disp(strcat('Case Number= ',num2str(CaseNumber)))

SapeloFlag=1;
if SapeloFlag
    DataPath=strcat('/lustre1/omidvar/work-directory_0801/7th/suntans-7th-',num2str(CaseNumber),'/InternalWaves/data/Result_0000.nc');
    OutputAddress='/lustre1/omidvar/work-directory_0801/7th-New/'
else
    DataPath=strcat('F:\7th\suntans-7th-',num2str(CaseNumber),'\InternalWaves\data\Result_0000.nc');
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
XEndIndex=2000;% The data trim after this X point
TimeStartIndex=5888/2;%This is 27 cycles of M2 and 14 cycles of K1 and wind
TimeEndIndex=floor(9917/2);%This is 27 cycles of M2 and 14 cycles of K1 and wind

AnalysisSpeed=1;
FPSMovie=15;

%PycnoclineDepthIndex=20;BathymetryXLocationAtPycnoclineIndex=14;%for Pycno=10
%PycnoclineDepthIndex=30;BathymetryXLocationAtPycnoclineIndex=20;%for Pycno=10
%PycnoclineDepthIndex=40;BathymetryXLocationAtPycnoclineIndex=24;%for Pycno=10

%WavePlotter(AnalysisSpeed,FPSMovie,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,WindTauMax,DataPath,OutputAddress,CaseNumber);EnergyFluxCalculator70046(DataPath,CaseNumber,OutputAddress,KnuH,KappaH,g,InterpolationEnhancement,XEndIndex,DiurnalTideOmega,SemiDiurnalTideOmega,WindTauMax,TimeStartIndex,TimeEndIndex,PycnoclineDepthIndex,BathymetryXLocationAtPycnoclineIndex,SapeloFlag);
