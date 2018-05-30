%This code is plotting the SUNTANS results for several case scenarios with
%similar names. This code is written by Sorush Omidvar in July 2016 at UGA.
%This vesion is modified in Jan 2018.
close all;
clear all;
clc

CaseNumber='90402';
format compact;
disp(strcat('Case Number= ',CaseNumber))

CurrentLocation=pwd;
if contains(CurrentLocation,'lustre1')
    SapeloFlag=1;
else
    SapeloFlag=0;
end
clear CurrentLocation;

if SapeloFlag
    DataPath=strcat('/lustre1/omidvar/work-directory_0801/9th/suntans-9th-',CaseNumber,'/InternalWaves/data/Result_0000.nc');
    OutputAddress='/lustre1/omidvar/work-directory_0801/9th-New/';
else
    DataPath=strcat('D:\suntans-9th-',CaseNumber,'\InternalWaves\data\Result_0000.nc');
    OutputAddress='D:\';
end

if exist(DataPath,'file')==0
    disp('There is no NETCDF file to process')
    return;
end

KnuH=1;
KappaH=0;
g=9.8;
InterpRes=5;
XEndIndex=Inf;
TimeStartIndex=1009;
TimeEndIndex=Inf;

AnalysisSpeed=1;
FPSMovie=30;

ModelTimeOffset=0;
WindLag=21;

WindTauMax=0;
WindOmega=2*pi/(24*3600);
DiurnalTideOmega=2*pi()/23.93/3600;
SemiDiurnalTideOmega=2*pi()/12.4/3600;

WavePlotter(AnalysisSpeed,FPSMovie,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,WindTauMax,DataPath,OutputAddress,CaseNumber,ModelTimeOffset,WindLag);
%EnergyFluxCalculator(DataPath,CaseNumber,OutputAddress,...
%     KnuH,KappaH,g,InterpRes,XEndIndex,...
%     DiurnalTideOmega,SemiDiurnalTideOmega,WindTauMax,TimeStartIndex,...
%     TimeEndIndex,SapeloFlag);