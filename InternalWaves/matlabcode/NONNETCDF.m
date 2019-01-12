close all;
clear all;
clc

OutPut=20;
ZSize=300;
XSize=200;
TotalTimeSize=29864;
TimeProcessStartIndex=1045;
TimeSTR=1;
XProcessStartIndex=10;    
XProcessEndIndex=180;
g=9.8;
%DataPath='D:\VM\Test\iwaves\data';
DataPath='D:\data';
InterpRes=50;
Rho0=1000;

Salinity=nan(XSize,ZSize,floor(TotalTimeSize/OutPut)-TimeProcessStartIndex+1);
U=nan(XSize,ZSize,floor(TotalTimeSize/OutPut)-TimeProcessStartIndex+1);
W=nan(XSize,ZSize,floor(TotalTimeSize/OutPut)-TimeProcessStartIndex+1);
Eta=nan(XSize,floor(TotalTimeSize/OutPut)-TimeProcessStartIndex+1);

[~,~,Time] = plotsliceMultiCore('Time',DataPath,OutPut);
Time=Time(TimeProcessStartIndex:end);
for k=1:floor(TotalTimeSize/OutPut)-TimeProcessStartIndex+1
    [~,~,Eta(:,k)] = plotsliceMultiCore('h',DataPath,k);
    [~,~,Temp] = plotsliceMultiCore('s',DataPath,k);
    Salinity(:,:,k)=Temp';
    [~,~,Temp] = plotsliceMultiCore('u',DataPath,k);
    U(:,:,k)=Temp';      
    [X,Z,Temp] = plotsliceMultiCore('w',DataPath,k);
    W(:,:,k)=Temp';
end
clear Temp;
Z=Z';
ZC=squeeze(Z(1,:))';
Density=Salinity*Rho0+Rho0;
clear Salinity;

X=X(1,XProcessStartIndex:XProcessEndIndex);
X=X';
Z=Z(XProcessStartIndex:XProcessEndIndex,:);
Time=Time(1:TimeSTR:end);
Eta=Eta(XProcessStartIndex:XProcessEndIndex,1:TimeSTR:end);
U=U(XProcessStartIndex:XProcessEndIndex,:,1:TimeSTR:end);
W=W(XProcessStartIndex:XProcessEndIndex,:,1:TimeSTR:end);
Density=Density(XProcessStartIndex:XProcessEndIndex,:,1:TimeSTR:end);

[IsopycnalDislocation,ConversionTimeVarient,ConversionTimeVarient1,...
        ConversionTemporal,ConversionConventional,RhoBConventional,...
        RhoBTimeVarient,RhoPrimeConventional,RhoPrimeTimeVarient]=...
        ConversionCalculator(InterpRes,X,ZC,Eta,Density,W,Time,Rho0,g);

figure;
[xx,zz]=meshgrid(X,ZC);
ConversionTimeVarientTimeAvr=trapz(Time,ConversionTimeVarient,3)/(Time(end)-Time(1));
ConversionConventionalTimeAvr=trapz(Time,ConversionConventional,3)/(Time(end)-Time(1));

ConversionTemporalTimeAvr=trapz(Time,ConversionTemporal,3)/(Time(end)-Time(1));
ConversionTimeVarient1TimeAvr=trapz(Time,ConversionTimeVarient1,3)/(Time(end)-Time(1));
subplot(1,2,1)
pcolor(xx',zz',ConversionTimeVarientTimeAvr);
shading flat;
colorbar;
caxis([-1e-6 10e-6]);

subplot(1,2,2)
pcolor(xx',zz',ConversionConventionalTimeAvr);
shading flat;
colorbar;
caxis([-1e-6 10e-6]);

ConversionTimeVarientTimeAvrDepthInt=ConversionTimeVarientTimeAvr;
ConversionConventionalTimeAvrDepthInt=ConversionConventionalTimeAvr;
ConversionTemporalTimeAvrDepthInt=ConversionTemporalTimeAvr;
ConversionTimeVarient1TimeAvrDepthInt=ConversionTimeVarient1TimeAvr;
for i=1:size(X,1)
    for j=1:size(ZC,1)
        if isnan(ConversionTimeVarientTimeAvrDepthInt(i,j))
            ConversionTimeVarientTimeAvrDepthInt(i,j)=0;
            ConversionConventionalTimeAvrDepthInt(i,j)=0;
            ConversionTemporalTimeAvrDepthInt(i,j)=0;
            ConversionTimeVarient1TimeAvrDepthInt(i,j)=0;
        end
    end
end
ConversionTimeVarientTimeAvrDepthInt=trapz(abs(ZC),ConversionTimeVarientTimeAvrDepthInt,2);
ConversionConventionalTimeAvrDepthInt=trapz(abs(ZC),ConversionConventionalTimeAvrDepthInt,2);
ConversionTemporalTimeAvrDepthInt=trapz(abs(ZC),ConversionTemporalTimeAvrDepthInt,2);
ConversionTimeVarient1TimeAvrDepthInt=trapz(abs(ZC),ConversionTimeVarient1TimeAvrDepthInt,2);

figure;
plot(X,ConversionTimeVarientTimeAvrDepthInt);
hold on
plot(X,ConversionConventionalTimeAvrDepthInt);

figure;hold on;
plot(X,ConversionTimeVarientTimeAvrDepthInt);
plot(X,ConversionConventionalTimeAvrDepthInt);
plot(X,ConversionTemporalTimeAvrDepthInt);
plot(X,ConversionTimeVarient1TimeAvrDepthInt);
legend('Time Varient','Conventional','Temporal','RhoPrimeGW');

function [IsopycnalDislocation,ConversionTimeVarient,ConversionTimeVarient1,...
        ConversionTemporal,ConversionConventional,RhoBConventional...
        ,RhoBTimeVarient,RhoPrimeConventional,RhoPrimeTimeVarient]=...
        ConversionCalculator(InterpRes,X,ZC,Eta,Density,W,Time,Rho0,g)

    ZCTemp=permute(repmat(ZC,1,size(X,1),size(Time,1)),[2,1,3])+Density*0;
    DepthTemp=repmat(nanmin(ZCTemp,[],2),1,size(ZC,1),1);
    Epsilon=permute(repmat(squeeze(Eta(1,:)),size(X,1),1,size(ZC,1)),[1,3,2]);
    Epsilon=Epsilon.*(1-ZCTemp./DepthTemp);  
    
    RhoBConventional=trapz(Time,Density,3)/(Time(end)-Time(1))-Rho0;
    RhoBConventional=repmat(RhoBConventional,1,1,size(Time,1));   
    RhoPrimeConventional=Density-Rho0-RhoBConventional;
    
    RhoBTimeVarient=nan(size(X,1),size(ZC,1),size(Time,1));
    for i=1:size(X,1)
        RhoBConvLocal=squeeze(RhoBConventional(i,:,1))';
        LastJIndex=find(RhoBConvLocal*0==0,1,'last');
        for j=1:LastJIndex
            if(RhoBConvLocal(j)-RhoBConvLocal(1)>0.001)%Finding the mixed layer depth
                FirstJIndex=j;
                break;
            end
        end
        F = @(RhoBCoe,RhoData)RhoBCoe(1)*RhoData.^RhoBCoe(2)+RhoBCoe(3);%The fitted profile is Density=a*ZC^b+c
        ZZZ0=[0.024*1000,0.0187,0];%Initial guess is based on the initial conditions
        options = optimoptions('lsqcurvefit','Display','off');
        [RhoBCoeff,~,~,~,~] = lsqcurvefit(F,ZZZ0,-ZC(FirstJIndex:LastJIndex),RhoBConvLocal(FirstJIndex:LastJIndex)...
            ,[],[],options); 
        RhoBFittedA=RhoBCoeff(1);
        RhoBFittedB=RhoBCoeff(2);
        RhoBFittedC=RhoBCoeff(3);
        for j=1:size(ZC,1)
            for k=1:size(Time,1)
                if(j<FirstJIndex)
                    RhoBTimeVarient(i,j,k)=RhoBConvLocal(j);
                elseif(~isnan(Epsilon(i,j,k)))
                    RhoBTimeVarient(i,j,k)=RhoBFittedA*(-ZC(j)+Epsilon(i,j,k))^RhoBFittedB+RhoBFittedC;
                else
                    RhoBTimeVarient(i,j,k)=RhoBFittedA*(-ZC(j)+Epsilon(i,LastJIndex,k))^RhoBFittedB+RhoBFittedC;
                end
            end
        end
    end
     
        
    disp('EPPrime calculation is started')
    [IsopycnalDislocation,ConversionTemporal]=EPCalculator(X,ZC,Time,Density-Rho0,RhoBTimeVarient,InterpRes,g);
    disp('EPPrime calculation is done')      

    RhoPrimeTimeVarient=Density-Rho0-RhoBTimeVarient;
    ConversionTimeVarient1=RhoPrimeTimeVarient.*W*g;
    ConversionTimeVarient=ConversionTimeVarient1+ConversionTemporal; 
    ConversionConventional=RhoPrimeConventional*g.*W;  
    disp('Done')
end



function [IsopycnalDislocation,ConversionTemporal]=EPCalculator(X,ZC,Time,Density,RhoB,InterpRes,g)   
    %To better calculate the APE, teh whole density profile is interpolated
    %at each time step for each X. The  the displacement of isopycanls was
    %calculated. After that, the resolution was reduced to the normal. This
    %process has been done to capture the small displacment of isopycanls
    %and also not to interfere with the original vertical resolution.

    %EPPrimeCell=cell(size(X,1),1);
    DensityCell=cell(size(X,1),1);
    ZCCell=cell(size(X,1),1);
    IsopycnalDislocationCell=cell(size(X,1),1);
    ConversionTemporalCell=cell(size(X,1),1);
    RhoBCell=cell(size(X,1),1);
    RhoBDiffTTempCell=cell(size(X,1),1);
       
    RhoBDiffTTemp=diff(RhoB,1,3)./permute(repmat(diff(Time),1,size(X,1),size(ZC,1)),[2,3,1]);
    RhoBDiffTTemp(:,:,end+1)=RhoBDiffTTemp(:,:,end);
    for i=1:size(X,1)
        %EPPrimeCell{i}=nan(size(ZC,1),size(Time,1));
        DensityCell{i}=squeeze(Density(i,:,:));
        ZCCell{i}=ZC;
        RhoBCell{i}=squeeze(RhoB(i,:,:));
        ConversionTemporalCell{i}=nan(size(ZC,1),size(Time,1));
        IsopycnalDislocationCell{i}=nan(size(ZC,1),size(Time,1));
        RhoBDiffTTempCell{i}=squeeze(RhoBDiffTTemp(i,:,:));
    end  
    CreatedParallelPool = parallel.pool.DataQueue;	
    afterEach(CreatedParallelPool, @UpdateStatusDisp);	
    ProgressStatus=0;
    disp('For the sake of numerical, the top 5 meters are dissmissed')
    RangeLimit=8;
    parfor i=1:size(X,1)
        ZCWorker=ZCCell{i};
        for k=1:size(Time,1)           
            RhoWorker=squeeze(DensityCell{i}(:,k));
            RhoBWorker=squeeze(RhoBCell{i}(:,k));
            RhoBDiffTTempWorker=RhoBDiffTTempCell{i}(:,k);
            
            LastJIndex=find(RhoWorker*0==0,1,'last');
            RhoWorker=RhoWorker(1:LastJIndex);
            RhoBWorker=RhoBWorker(1:end);%RhoB is extended to the full ZC so that the bottom layers can be calculated more precisely
            RhoBDiffTTempWorker=RhoBDiffTTempWorker(1:end);
            ZCWorker=ZCWorker(1:end);
            for j=RangeLimit:LastJIndex%Sometimes the value of the Rho at top and bottom cells cannot be find in Rhob
                if (abs(RhoWorker(j)-RhoBWorker(j))<0.001)%sometimes the density is constant with depth, to avoid numerical fluctation of Rho in finding the equivalant in RhoB this criteria was enforced
                    Dislocation=0;
                    ConversionTemporalCell{i}(j,k)=0;
                    %EPPrimeCell{i}(j,k)=0;
                elseif (RhoWorker(j)<RhoBWorker(1) || RhoWorker(j)>RhoBWorker(end))%The density profile does not have this value
                    Dislocation=0;
                    ConversionTemporalCell{i}(j,k)=0;
                else
                    [RhoBWorkerUnique,RhoBWorkerUniqueIndex]=unique(RhoBWorker);
                    Dislocation=ZCWorker(j)-interp1(RhoBWorkerUnique,ZCWorker(RhoBWorkerUniqueIndex),RhoWorker(j),'linear');%if Dislocation<0 downwelling and if dislocation>0 upwelling                                  
                    if Dislocation<0%Downwelling
                        TopBoundary=interp1(RhoBWorkerUnique,ZCWorker(RhoBWorkerUniqueIndex),RhoWorker(j),'linear');
                        BotBoundary=ZCWorker(j);
                        ZCInterp=linspace(TopBoundary,BotBoundary,InterpRes);
                        %EPPrimeCell{i}(j,k)=-g*trapz(-ZCInterp,RhoWorker(j)-RhoBInterp);
                        RhoBDiffTTempInterp=interp1(ZCWorker,RhoBDiffTTempWorker,ZCInterp,'linear');
                        ConversionTemporalCell{i}(j,k)=+g*trapz(-ZCInterp,RhoBDiffTTempInterp);                    
                    elseif Dislocation>0%Upwelling
                        TopBoundary=ZCWorker(j);
                        BotBoundary=interp1(RhoBWorkerUnique,ZCWorker(RhoBWorkerUniqueIndex),RhoWorker(j),'linear');
                        ZCInterp=linspace(TopBoundary,BotBoundary,InterpRes);
                        %EPPrimeCell{i}(j,k)=+g*trapz(-ZCInterp,RhoWorker(j)-RhoBInterp);
                        RhoBDiffTTempInterp=interp1(ZCWorker,RhoBDiffTTempWorker,ZCInterp,'linear');
                        ConversionTemporalCell{i}(j,k)=-g*trapz(-ZCInterp,RhoBDiffTTempInterp);
                    end
                    if(isnan(Dislocation))
                        disp('Error!!! Error in dislocation calculation. The density could not be found')
                    end
                end
                IsopycnalDislocationCell{i}(j,k)=Dislocation;
            end
        end 
        send(CreatedParallelPool,i);
    end
    function UpdateStatusDisp(~)	
        ProgressString=num2str(ProgressStatus/size(X,1)*100,'%2.1f');	
        disp(strcat('Progress Percentage=',ProgressString))	
        ProgressStatus= ProgressStatus + 1;	
    end
  
    IsopycnalDislocationConv= cellfun(@(TempCellConv)reshape(TempCellConv,1,size(ZC,1),size(Time,1)),IsopycnalDislocationCell,'un',0);
    IsopycnalDislocation= cell2mat(IsopycnalDislocationConv);
     
    ConversionTemporalCellConv= cellfun(@(TempCellConv)reshape(TempCellConv,1,size(ZC,1),size(Time,1)),ConversionTemporalCell,'un',0);
    ConversionTemporal= cell2mat(ConversionTemporalCellConv);
end