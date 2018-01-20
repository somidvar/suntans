clear
close all;
clc

ScenarioNumber=99;
DataPath='F:\6th\suntans-6th-10001\InternalWaves\data\Result_0000.nc';
X=ncread(DataPath,'xv');
Time=ncread(DataPath,'time');
Z=ncread(DataPath,'z_r');

PycnoclineDepth=nan(ScenarioNumber,1);
PycnoclineDepthIndex=nan(ScenarioNumber,1);
BathymetryAtPycnoclineIndex=nan(ScenarioNumber,1);
XStartIndex=nan(ScenarioNumber,1);
WaveLength=nan(ScenarioNumber,1);
for counter=10001:1:10099
    if mod(counter-10000,20)<=3
        PycnoclineDepth(counter-10000)=-5;
        PycnoclineDepthIndex(counter-10000)=11;
        XStartIndex(counter-10000)=5;
    elseif mod(counter-10000,20)<=7
        PycnoclineDepth(counter-10000)=-10;
        PycnoclineDepthIndex(counter-10000)=22;
        XStartIndex(counter-10000)=8;
    elseif mod(counter-10000,20)<=11
        PycnoclineDepth(counter-10000)=-15;
        PycnoclineDepthIndex(counter-10000)=33;
        XStartIndex(counter-10000)=10;
    elseif mod(counter-10000,20)<=15
        PycnoclineDepth(counter-10000)=-20;
        PycnoclineDepthIndex(counter-10000)=43;
        XStartIndex(counter-10000)=12;
    elseif mod(counter-10000,20)<=19
        PycnoclineDepth(counter-10000)=-25;
        PycnoclineDepthIndex(counter-10000)=54;
        XStartIndex(counter-10000)=13;
    end
end

for counter=10001:1:10099
    TemporaryString=strcat('Scenario:',num2str(counter));
    disp(TemporaryString);
    DataPath=strcat('F:\6th\suntans-6th-',num2str(counter),'\InternalWaves\data\Result_0000.nc');
    if counter==10004 || counter==10008 || counter==10012 || counter==10016
        continue;
    end
    Density=1000+1000*squeeze(ncread(DataPath,'rho',...
        [XStartIndex(counter-10000)+10,PycnoclineDepthIndex(counter-10000),8000],...
        [550,1,1]));
    Density=squeeze(Density);
    Density=detrend(Density);
    Fs=10;
    Y=fft(Density);
    Y=abs(Y/size(Density,1));
    Y=Y(1:size(Density,1)/2+1);
    Y(2:end-1)=2*Y(2:end-1);
    Frequency=Fs*(0:(size(Density,1)/2))/size(Density,1);
    h=figure;
    plot(Frequency,Y);
    temporary=num2str(counter-10000);
    title(strcat('Single-Sided Amplitude Spectrum of case=',temporary));
    xlabel('f (Hz)')
    [~,MaxFrequncyIndex]=max(Y);
    WaveLength(counter-10000)=1/Frequency(MaxFrequncyIndex);
    disp(strcat('The wave length is=',num2str(1/Frequency(MaxFrequncyIndex)),' km'))
    savefig(h,temporary,'compact');
    close all;
end
