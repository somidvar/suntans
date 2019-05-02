%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% File name: TidalPhaseSeparator.m
% Description: This mfile read NOAA data, separate the different
% constituents and calculate their initial phase using the t_tide ver 1.3.
% The input data is .CSV with the 5 column formatting from NOAA website
% Date, Time, Predicted, Preliminary, Verified with 1 hour interval. The
% imported data should be in GMT timming with metric unit. 
%
% [InitialPhase,TideSeparated,TideName,TideAmp,TidePhase,Time]=
% TidalPhaseSeparator(FileAddress,SNRThreshold,Latitude)
%
% Variables:
%	InitialPhase: The phase of each components at the start time in degree
%	TideSeparated: matrix consists of different tidal constituents
%	TideName: Name of each constutuents
%	TideAmp: Amplitude of each constutuents
%	TidePhase: Phase of each constutuents
%	Time: Time in the format of datenum
%	Tide: Verified tide from NOAA
%	FileAddressReader: Address of NOAA CSV file should be *.csv
%	SNRThreshold: SNR cuttoff
%   Latitude: Latitude of the location in degree and north is positive
%   T_TideResults.csv: the output of T_Tide1.3
%
% Sorush Omidvar
% University of Georgia
% April 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [InitialPhase,TideSeparated,TideName,TideAmp,TidePhase,Time,Tide]=TidalPhaseSeparator(FileAddressReader,SNRThreshold,Latitude)
    close all;
    clc
    FileAddressWriter=strfind(FileAddressReader,'\');
    FileAddressWriter=strcat(FileAddressReader(1:FileAddressWriter(end)),'T_TideResults.csv');
    Results=table2array(readtable(FileAddressReader));
    for k=1:size(Results,1)
        Temp=strsplit(Results{k,1},'/');
        Year=Temp{1};
        Month=Temp{2};
        Day=Temp{3};
        Time(k)=datenum(strcat(Year,'/',Month,'/',Day,{' '},Results{k,2}));
        Tide(k)=str2num(Results{k,5});
    end
    [Name,Frequency,tidecon,~]=t_tide(Tide,'start time',Time(1),'latitude',Latitude,'output',FileAddressWriter);
    Temporary=table2cell(readtable(FileAddressWriter,'HeaderLines',14));
    for counter=1:size(Temporary,1)
        SNR(counter)=Temporary{counter,7};
    end
    TidePhase=[];
    TideAmp=[];
    TideName=[''];
    SNRNew=[];
    for counter=1:size(Temporary,1)
        if SNR(counter)>SNRThreshold
            TidePhase(end+1)=tidecon(counter,3);
            TideAmp(end+1)=tidecon(counter,1);
            TideName(end+1,:)=Name(counter,:);
            SNRNew(end+1)=SNR(counter);
        end
    end
    [~,SortedVector]=sort(SNRNew,'descend');
    TidePhase=TidePhase(SortedVector);
    TideAmp=TideAmp(SortedVector);
    TideName=TideName(SortedVector,:);
    SNRNew=SNRNew(SortedVector);
    TideSeparated=[];
    TideSeparated(:,end+1)=t_predic(Time,Name,Frequency,tidecon,'synthesis',SNRNew(1)-100);
    for counter=2:size(SNRNew,2)
        TideSeparated(:,end+1)=t_predic(Time,Name,Frequency,tidecon,'synthesis',SNRNew(counter)-100);
    end
    for i=2:size(SNRNew,2)
        for j=i:size(SNRNew,2)
            TideSeparated(:,j)=TideSeparated(:,j)-TideSeparated(:,i-1);
        end
    end
    InitialPhase=asind(TideSeparated(1,:));
end