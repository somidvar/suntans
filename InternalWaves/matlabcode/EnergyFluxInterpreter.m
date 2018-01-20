close all;
clear
clc

%Bathymetry info from initialization.c
ABath = 40;
BBath = 0.0009;
CBath = 1500;
DBath = 35;

XLimitIndex=30;
InterPolationResolution=10;
ScenarioNumber=99;
DataPath=strcat('F:\6th-Processed\','10001-EnergyFlux.nc');

X=ncread(DataPath,'X',1,XLimitIndex);
Time=ncread(DataPath,'Time');
Z=ncread(DataPath,'Z');

ConversionRate=nan(ScenarioNumber,size(X,1));
FPrimeBar=nan(ScenarioNumber,size(X,1));
F0Bar=nan(ScenarioNumber,size(X,1));

BackgroundDensity=nan(ScenarioNumber,size(Z,1));
WindStress=zeros(ScenarioNumber,1);
DiurnalAmplitude=zeros(ScenarioNumber,1);
SemidiurnalAmplitude=zeros(ScenarioNumber,1);
PycnoclineDepthIndex=nan(ScenarioNumber,1);
BathymetryAtPycnoclineIndex=nan(ScenarioNumber,1);
BathymetrySlopeAtPycnocline=nan(ScenarioNumber,1);
BruntVaisalaMax=nan(ScenarioNumber,1);


%Reading wind stress, tidal amplitude and energy flux info
for counter=10001:1:10099
    DataPath=strcat('F:\6th-Processed\',num2str(counter),'-EnergyFlux.nc');
    if counter==10004 || counter==10008 || counter==10012 || counter==10016
        FPrimeBar(counter-10000,:)=zeros(size(X,1),1);
        F0Bar(counter-10000,:)=zeros(size(X,1),1);
        ConversionRate(counter-10000,:)=zeros(size(X,1),1);
        continue;
    end
    WindStress(counter-10000)=ncread(DataPath,'Wind');
    DiurnalAmplitude(counter-10000)=ncread(DataPath,'Diurnal');
    SemidiurnalAmplitude(counter-10000)=ncread(DataPath,'SemiDiurnal');
    PycnoclineDepthIndex(counter-10000)=ncread(DataPath,'PycnoclineIndex');
    BathymetryAtPycnoclineIndex(counter-10000)=ncread(DataPath,'BathymetryXPycnoclineIndex');
    BruntVaisalaMax(counter-10000)=ncread(DataPath,'BruntVaisalaMax');
    
    Temporary=ncread(DataPath,'FPrimeBar',[1,1],[size(X,1),Inf]);
    FPrimeBar(counter-10000,:)=nanmean(Temporary,2);
    
    Temporary=ncread(DataPath,'F0Bar',[1,1],[size(X,1),Inf]);
    F0Bar(counter-10000,:)=nanmean(Temporary,2);
    
    Temporary=ncread(DataPath,'Conversion',[1,1],[size(X,1),Inf]);
    ConversionRate(counter-10000,:,:)=nanmean(Temporary,2);
    %Calculating the slope of Bathymetry at the pycnocline    
    Bathymetry= ABath*(tanh(-BBath*(-X + CBath))) + DBath;
    Temporary=diff(Bathymetry,1,1)./diff(X);
    BathymetrySlopeAtPycnocline(counter-10000)=Temporary(BathymetryAtPycnoclineIndex(counter-10000));
end
XGradient=repmat(X,1,ScenarioNumber);
XGradient=XGradient';
XGradient=diff(XGradient,1,2);

FPrimeBarGradient=diff(FPrimeBar,1,2)./XGradient;
FPrimeBarGradient(:,end+1)=FPrimeBarGradient(:,end);

F0BarGradient=diff(F0Bar,1,2)./XGradient;
F0BarGradient(:,end+1)=F0BarGradient(:,end);

XInterp=linspace(X(1),X(end),InterPolationResolution*size(X,1));
BathymetryInterp=ABath*(tanh(-BBath*(-XInterp + CBath))) + DBath;

fig=figure('units','normalized','outerposition',[0 0 1 1]);
set(fig,'defaultAxesColorOrder',[0,0,0;0.7,0.7,0.7]);
for SubPlotCounter=1:4
    subplot(2,2,SubPlotCounter);
    BaseScenarioNumber=7;
    
    if DiurnalAmplitude(BaseScenarioNumber+SubPlotCounter)~=0
        ScenarioSituation='wD';
    else
        ScenarioSituation='nD';
    end
    
    if SemidiurnalAmplitude(BaseScenarioNumber+SubPlotCounter)~=0
        ScenarioSituation=strcat(ScenarioSituation,'wS');
    else
        ScenarioSituation=strcat(ScenarioSituation,'nS');
    end
    
    if WindStress(BaseScenarioNumber+SubPlotCounter)~=0
        ScenarioSituation=strcat(ScenarioSituation,'wW');
    else
        ScenarioSituation=strcat(ScenarioSituation,'nW');
    end
    
    yyaxis left;
    Result=F0BarGradient(BaseScenarioNumber+SubPlotCounter,:);
    plot(X/1000,sign(Result).*log(abs(Result)),'-blue');
    ylabel('Energy log(wat/m)');
    hold on;

    Result=FPrimeBarGradient(BaseScenarioNumber+SubPlotCounter,:);
    plot(X/1000,sign(Result).*log(abs(Result)),'-red');

    Result=ConversionRate(BaseScenarioNumber+SubPlotCounter,:);
    plot(X/1000,sign(Result).*log(abs(Result)),'-magenta');
       
    yyaxis right;
    plot(XInterp/1000,-BathymetryInterp,'Color',[0.7 0.7 0.7]);
    ylabel('Depth (m)');

    grid minor;
    xlabel('Offshore Distance (Km)');
    hold off;
    QutationChar=char(39);
    legend('Grad(FBT)','Grad(FBC)','Conversion','Bathymetry');
    title(strcat('Energy Budget:',ScenarioSituation," "," ",'Scenario#',num2str(BaseScenarioNumber+SubPlotCounter)));
end

fig=figure('units','normalized','outerposition',[0 0 1 1]);
subplot(1,3,1)
Result=[ConversionRate(9,:);ConversionRate(29,:);ConversionRate(49,:);ConversionRate(69,:);ConversionRate(89,:)]';
ScenarioNumber=['10009';'10029';'10049';'10069';'10089'];
boxplot([Result(:,1),Result(:,2),Result(:,3),Result(:,4),Result(:,5)],ScenarioNumber);
grid minor;
ylabel('Conversion Rate [wat/m^2]');
title('Cases With Diurnal tide and 15m Pycno');

subplot(1,3,2)
Result=[ConversionRate(10,:);ConversionRate(30,:);ConversionRate(50,:);ConversionRate(70,:);ConversionRate(90,:)]';
ScenarioNumber=['10010';'10030';'10050';'10070';'10090'];
boxplot([Result(:,1),Result(:,2),Result(:,3),Result(:,4),Result(:,5)],ScenarioNumber);
grid minor;
ylabel('Conversion Rate [wat/m^2]');
title('Cases With Semidiurnal tide and 15m Pycno');

subplot(1,3,3)
Result=[ConversionRate(11,:);ConversionRate(31,:);ConversionRate(51,:);ConversionRate(71,:);ConversionRate(91,:)]';
ScenarioNumber=['10011';'10031';'10051';'10071';'10091'];
boxplot([Result(:,1),Result(:,2),Result(:,3),Result(:,4),Result(:,5)],ScenarioNumber);
grid minor;
ylabel('Conversion Rate [wat/m^2]');
title('Cases With Semidiurnal-Diurnal tide and 15m Pycno');



fig=figure('units','normalized','outerposition',[0 0 1 1]);
subplot(1,3,1)
Result=[FPrimeBarGradient(9,:);FPrimeBarGradient(29,:);FPrimeBarGradient(49,:);FPrimeBarGradient(69,:);FPrimeBarGradient(89,:)]';
ScenarioNumber=['10009';'10029';'10049';'10069';'10089'];
boxplot([Result(:,1),Result(:,2),Result(:,3),Result(:,4),Result(:,5)],ScenarioNumber);
grid minor;
ylabel('Grad(FBC) [wat/m^2]');
title('Cases With Diurnal tide and 15m Pycno');

subplot(1,3,2)
Result=[FPrimeBarGradient(10,:);FPrimeBarGradient(30,:);FPrimeBarGradient(50,:);FPrimeBarGradient(70,:);FPrimeBarGradient(90,:)]';
ScenarioNumber=['10010';'10030';'10050';'10070';'10090'];
boxplot([Result(:,1),Result(:,2),Result(:,3),Result(:,4),Result(:,5)],ScenarioNumber);
grid minor;
ylabel('Grad(FBC) [wat/m^2]');
title('Cases With Semidiurnal tide and 15m Pycno');

subplot(1,3,3)
Result=[FPrimeBarGradient(11,:);FPrimeBarGradient(31,:);FPrimeBarGradient(51,:);FPrimeBarGradient(71,:);FPrimeBarGradient(91,:)]';
ScenarioNumber=['10011';'10031';'10051';'10071';'10091'];
boxplot([Result(:,1),Result(:,2),Result(:,3),Result(:,4),Result(:,5)],ScenarioNumber);
grid minor;
ylabel('Grad(FBC) [wat/m^2]');
title('Cases With Semidiurnal-Diurnal tide and 15m Pycno');


fig=figure('units','normalized','outerposition',[0 0 1 1]);
subplot(1,3,1)
Result=[F0BarGradient(9,:);F0BarGradient(29,:);F0BarGradient(49,:);F0BarGradient(69,:);F0BarGradient(89,:)]';
ScenarioNumber=['10009';'10029';'10049';'10069';'10089'];
boxplot([Result(:,1),Result(:,2),Result(:,3),Result(:,4),Result(:,5)],ScenarioNumber);
grid minor;
ylabel('Grad(FBT) [wat/m^2]');
title('Cases With Diurnal tide and 15m Pycno');

subplot(1,3,2)
Result=[F0BarGradient(10,:);F0BarGradient(30,:);F0BarGradient(50,:);F0BarGradient(70,:);F0BarGradient(90,:)]';
ScenarioNumber=['10010';'10030';'10050';'10070';'10090'];
boxplot([Result(:,1),Result(:,2),Result(:,3),Result(:,4),Result(:,5)],ScenarioNumber);
grid minor;
ylabel('Grad(FBT) [wat/m^2]');
title('Cases With Semidiurnal tide and 15m Pycno');

subplot(1,3,3)
Result=[F0BarGradient(11,:);F0BarGradient(31,:);F0BarGradient(51,:);F0BarGradient(71,:);F0BarGradient(91,:)]';
ScenarioNumber=['10011';'10031';'10051';'10071';'10091'];
boxplot([Result(:,1),Result(:,2),Result(:,3),Result(:,4),Result(:,5)],ScenarioNumber);
grid minor;
ylabel('Grad(FBT) [wat/m^2]');
title('Cases With Semidiurnal-Diurnal tide and 15m Pycno');
