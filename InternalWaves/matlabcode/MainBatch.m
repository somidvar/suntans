%This code is plotting the SUNTANS results for several case scenarios with
%similar names. This code is written by Sorush Omidvar in July 2016 at UGA.
%This vesion is modified in Aug 2016.
for CaseNumber=70001:1:70047
    clearvars -except CaseNumber;
    close all;
    clc;
    
    format compact;
    disp(strcat('Case Number= ',num2str(CaseNumber)))
    
    SapeloFlag=0;
    if SapeloFlag
        Prefix='/lustre1/omidvar/work-directory_0801/7th/suntans-7th-';
        OutputAddress='/lustre1/omidvar/work-directory_0801/7th-New';
        CaseName=num2str(CaseNumber);
        DataPath=strcat(Prefix,CaseName);
        DataPath=strcat(DataPath,'/InternalWaves/data/Result_0000.nc');
    else
        Prefix='F:\7th\suntans-7th-';
        OutputAddress='D:\7th\';
        CaseName=num2str(CaseNumber);
        DataPath=strcat(Prefix,CaseName);
        DataPath=strcat(DataPath,'\InternalWaves\data\Result_0000.nc');
    end

    if exist(DataPath,'file')==0
		disp('There is no NETCDF file to process')
        continue;
    end
    
    KnuH=1;
    g=9.8;  
    KappaH=0;
    DragCoeff=0.001;
    InterpolationEnhancement=10;%Resolution of interpolation in energy flux calculation 
    XEndIndex=2000;% The data trim after this X point
    TimeStartIndex=5888/2;%This is 27 cycles of M2 and 14 cycles of K1 and wind
    TimeEndIndex=floor(9917/2);%This is 27 cycles of M2 and 14 cycles of K1 and wind
    
    AnalysisSpeed=2;
    FPSMovie=15;
    
    %Setting the wind frequency based on the cases
    WindOmega=2*pi/(24*3600);
    
    %Setting the wind stress based on the cases
    if floor((CaseNumber-70000)/12)==0
        WindTauMax=0e-5;
    elseif floor((CaseNumber-70000)/12)==1
        WindTauMax=2.5e-5;
    elseif floor((CaseNumber-70000)/12)==2
        WindTauMax=5e-5;
    elseif floor((CaseNumber-70000)/12)==3
        WindTauMax=7.5e-5;
    end    
    %Setting the pycnocline depth based on the cases
    if mod(CaseNumber-70000,12)<4
        PycnoclineDepthIndex=20;%-10 meter
        BathymetryXLocationAtPycnoclineIndex=14;
    elseif mod(CaseNumber-70000,20)<8
        PycnoclineDepthIndex=30;%-15 meter
        BathymetryXLocationAtPycnoclineIndex=20;
    elseif mod(CaseNumber-70000,20)<12
        PycnoclineDepthIndex=40;%-20 meter
        BathymetryXLocationAtPycnoclineIndex=24;
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
    WavePlotter(AnalysisSpeed,FPSMovie,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,WindTauMax*1e4,DataPath,OutputAddress,num2str(CaseNumber));
%     EnergyFluxCalculator(DataPath,CaseNumber,OutputAddress,...
%         KnuH,KappaH,g,InterpolationEnhancement,XEndIndex,...
%         DiurnalTideOmega,SemiDiurnalTideOmega,WindTauMax,TimeStartIndex,...
%         TimeEndIndex,PycnoclineDepthIndex,BathymetryXLocationAtPycnoclineIndex,SapeloFlag);
end