%This code is plotting the SUNTANS results for several case scenarios with
%similar names. This code is written by Sorush Omidvar in July 2016 at UGA.
%This vesion is modified in Aug 2016.
SerieVersion=90000;
for CaseNumber=SerieVersion:1:SerieVersion+400
    clearvars -except CaseNumber SerieVersion;
    close all;
    clc;

    
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
        Prefix='/lustre1/omidvar/work-directory_0801/9th/suntans-9th-';
        OutputAddress='/lustre1/omidvar/work-directory_0801/9th-New';
        CaseName=num2str(CaseNumber);
        DataPath=strcat(Prefix,CaseName);
        DataPath=strcat(DataPath,'/InternalWaves/data/Result_0000.nc');
    else
        Prefix='F:\9th\suntans-9th-';
        OutputAddress='F:\Plots\';
        CaseName=num2str(CaseNumber);
        DataPath=strcat(Prefix,CaseName);
        DataPath=strcat(DataPath,'\InternalWaves\data\Result_0000.nc');
    end
    
    if exist(DataPath,'file')==0
		disp('There is no NETCDF file to process')
        continue;
    end
    
    KnuH=1;
    KappaH=0;
    g=9.8;
    InterpRes=5;%Resolution of interpolation in energy flux calculation 
    XEndIndex=Inf;% The data trim after this X point
    TimeStartIndex=1009;%This is 27 cycles of M2 and 14 cycles of K1 and wind
    TimeEndIndex=Inf;%This is 27 cycles of M2 and 14 cycles of K1 and wind

    AnalysisSpeed=1;
    FPSMovie=30;
    
    %Setting the wind frequency based on the cases
    WindOmega=2*pi/(24*3600);
    
    %Setting the wind stress based on the cases
    if floor(mod((CaseNumber-SerieVersion),196)/28)==0
        WindTauMax=0;
    else
        WindTauMax=1;
    end       
    %Setting the dirunal and semi-dirunal tide frequency based on the cases
    if mod(CaseNumber-SerieVersion,4)==0
        DiurnalTideOmega=0;
        SemiDiurnalTideOmega=0;
    elseif mod(CaseNumber-SerieVersion,4)==1
        DiurnalTideOmega=2*pi/(23.93*3600);
        SemiDiurnalTideOmega=0;
    elseif mod(CaseNumber-SerieVersion,4)==2
        DiurnalTideOmega=0;
        SemiDiurnalTideOmega=2*pi/(12.42*3600);
    elseif mod(CaseNumber-SerieVersion,4)==3
        DiurnalTideOmega=2*pi/(23.93*3600);
        SemiDiurnalTideOmega=2*pi/(12.42*3600);        
    end
    
    if floor((CaseNumber-SerieVersion)/196)==0
        ModelTimeOffset=-1;
        WindLag=15;
    elseif floor((CaseNumber-SerieVersion)/196)==1
        ModelTimeOffset=2;
        WindLag=18;
    elseif floor((CaseNumber-SerieVersion)/196)==2
        ModelTimeOffset=5;
        WindLag=21;
    elseif floor((CaseNumber-SerieVersion)/196)==3
        ModelTimeOffset=8;
        WindLag=24;
    elseif floor((CaseNumber-SerieVersion)/196)==4
        ModelTimeOffset=11;
        WindLag=27;
    end
    WavePlotter(AnalysisSpeed,FPSMovie,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,WindTauMax,DataPath,OutputAddress,num2str(CaseNumber),ModelTimeOffset,WindLag);
%     EnergyFluxCalculator(DataPath,CaseNumber,OutputAddress,...
%         KnuH,KappaH,g,InterpolationEnhancement,XEndIndex,...
%         DiurnalTideOmega,SemiDiurnalTideOmega,WindTauMax,TimeStartIndex,...
%         TimeEndIndex,SapeloFlag);
end