%This program has been written by Sorush Omidvar under supervision of 
%Dr. Woodson in Cobia lab at UGA in May 2017 to
%calculate wave energy flux from SUNTANS netcdf files.
%Modification is applied on Feb 2018

%Notation which is used in this program is based on the article
%"Energetics of Barotropic and Baroclinic Tides in the Monterey Bay Area"
%in 2011
%----Attention---- the conversionrate formulation is updated to "Model
%Estimates of M2 Internal Tide Generation over Mid-Atlantic Ridge
%Topography" by Zilbermann 2008

% function EnergyFluxCalculator(DataPath,CaseNumber,OutputAddress,KnuH,KappaH,g,...
%     InterpRes,XEndIndex,DiurnalTideOmega,...
%     SemiDiurnalTideOmega,WindTauMax,TimeStartIndex,TimeEndIndex,...
%     SapeloFlag)
clear all;
close all;
clc

CaseNumber='90394';
%DataPath='D:\suntans-9th-90394\InternalWaves\data\Result_0000.nc';
DataPath='D:\Result_0000.nc';
OutputAddress='C:\';
KnuH=1;
KappaH=0;
g=9.8;
InterpRes=1;
XEndIndex=Inf;
%TimeStartIndex=1009;
TimeStartIndex=1;
TimeEndIndex=Inf;

AnalysisSpeed=1;
FPSMovie=30;

ModelTimeOffset=0;
WindLag=21;

WindTauMax=0;
WindOmega=2*pi/(24*3600);
DiurnalTideOmega=2*pi()/23.93/3600;
SemiDiurnalTideOmega=2*pi()/12.4/3600;
SapeloFlag=0;

    
    Rho0=1025;%Setting the reference density    
    CountTimeIndex=TimeEndIndex-TimeStartIndex;
    disp('Reading the NETCDF')
    X=ncread(DataPath,'xv',1,XEndIndex);
    Time=ncread(DataPath,'time',TimeStartIndex,CountTimeIndex);
    ZC=-ncread(DataPath,'z_r');%I changed ZC and ZE sign to make it compatible with formulas
    Eta=ncread(DataPath,'eta',[1,TimeStartIndex],[XEndIndex,CountTimeIndex]);
    [Eta,~]=DataXTruncator(Eta,X);
    disp('Eta is done')
    Density=1000*ncread(DataPath,'rho',[1,1,TimeStartIndex],[XEndIndex,Inf,CountTimeIndex])+1000;
    [Density,~]=DataXTruncator(Density,X);
    disp('Density is done')
    Q=ncread(DataPath,'q',[1,1,TimeStartIndex],[XEndIndex,Inf,CountTimeIndex]).*Rho0;%Scaling the non-hydrostatic pressure
    [Q,~]=DataXTruncator(Q,X);
    disp('Q is done')
    UC=ncread(DataPath,'uc',[1,1,TimeStartIndex],[XEndIndex,Inf,CountTimeIndex]);
    [UC,~]=DataXTruncator(UC,X);
    disp('UC is done')
    W=ncread(DataPath,'w',[1,1,TimeStartIndex],[XEndIndex,Inf,CountTimeIndex]);
    W=movsum(W,2,2)/2;%Averaging the w over two horizontal edge to get the center value
    W(:,1,:)=[];%disregarding the first layer becaue for cell i movsum is summing i-1 and i
    [W,X]=DataXTruncator(W,X);
    disp('W is done')
    
    disp('NETCDF reading is compeleted')

    XXT=repmat(X,1,size(Time,1));%Repeating the X array in 3D for later used
    XXZT=repmat(X,1,size(ZC,1),size(Time,1));%Repeating the X array in 2D for later used
    XXTDiff=DiffCustom(XXT,1);%Calculating the derrivative of X in X direction and repeat it for 2D
    XXZTDiff=DiffCustom(XXZT,1);%Calculating the derrivative of X in X direction and repeat it for 3D
    
    Z3D=permute(repmat(ZC,1,size(X,1),size(Time,1)),[2,1,3]);
    Temp=permute(repmat(Eta,1,1,size(ZC,1)),[1,3,2]);
    Z3D(:,1,:)=Z3D(:,1,:)+Temp(:,1,:);
    Z3DDiff=-DiffCustom(Z3D,2);%dz should always be positive, the negative sign is to make it positive!
        
    HTotal=UC*0+Z3D;%To enforce the nan values
    HTotal=squeeze(nanmax(HTotal,[],2)-nanmin(HTotal,[],2));
    UH=squeeze(nansum(UC.*Z3DDiff,2))./HTotal;
    UPrime=UC-permute(repmat(UH,1,1,size(ZC,1)),[1 3 2]);

    RhoB=squeeze(Density(end,:,:))-Rho0;
    RhoPrime=Density-Rho0-permute(repmat(RhoB,1,1,size(X,1)),[3,1,2]);
    
%     This data are just for testing
%     X=[100;200];
%     Density=[0;0.8;1.8;0.2;1.8]+Rho0;
%     Density=permute(repmat(Density,1,2,3),[2,1,3]);
%     RhoB=repmat([0;0.2;0.8;1.6;1.8],1,3);
%     Time=[1;2;3];
%     ZC=[-7;-14;-21;-28;-35];
%     Eta=[100,100;200,200;300,300]';
%     InterpRes=1;
    
    disp('EPPrime calculation is started')
    [EPPrime,IsopycnalDislocation]=EPCalculator(X,ZC,Time,Density-Rho0,RhoB,InterpRes,g,SapeloFlag);
    disp('EPPrime calculation is done')

%     %Creating the output NETCDF
%     netcdf.setDefaultFormat('FORMAT_NETCDF4'); 
%     mode = netcdf.getConstant('CLOBBER');
%     NETCDFID = netcdf.create(strcat(OutputAddress,num2str(CaseNumber),'EnergyFlux.nc'),mode);
%     disp('The NETCDF file for energy flux is created')
% 
%     %Creating the dimensions for the NETCDF
%     TimeDimID= netcdf.defDim(NETCDFID,'Time',size(Time,1));
%     XDimID= netcdf.defDim(NETCDFID,'OffshoreDistance',size(X,1));
%     ZCDimID= netcdf.defDim(NETCDFID,'Depth',size(ZC,1));
%     SingleID=netcdf.defDim(NETCDFID,'Single',1);
% 
%     %Writing DiurnalTideOmega in the output NETCDF
%     WritingParameter(NETCDFID,DiurnalTideOmega,'Diurnal','NC_FLOAT',SingleID,'Diurnal Tide Omega','-','Radian/Sec');
%     WritingParameter(NETCDFID,SemiDiurnalTideOmega,'SemiDiurnal','NC_FLOAT',SingleID,'Semi-Diurnal Tide Omega','-','Radian/Sec');
%     WritingParameter(NETCDFID,WindTauMax,'Wind','NC_FLOAT',SingleID,'Wind shear stress','-','N/m^2');
%     WritingParameter(NETCDFID,Time,'Time','NC_FLOAT',TimeDimID,'Time','-','Second');
%     WritingParameter(NETCDFID,X,'X','NC_FLOAT',XDimID,'Off-shore Location of Cell Center','-','meter');
%     WritingParameter(NETCDFID,ZC,'Z','NC_FLOAT',ZCDimID,'Depth of Cell Center','-','meter');
%     WritingParameter(NETCDFID,Density,'Density','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Density of Cell Center','-','kg/m^3');
%     WritingParameter(NETCDFID,EPPrime,'APE','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Available Potential Energy(EPPrime)','12','J/m^3');
%     WritingParameter(NETCDFID,UC,'U','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Cross-shore Velocity (u)','-','m/s');
%     WritingParameter(NETCDFID,W,'W','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Vertical Velocity (w)','-','m/s');
%     WritingParameter(NETCDFID,Q,'Q','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Non-hydrostatic Pressure','-','N/m^2');
%     WritingParameter(NETCDFID,Eta,'Eta','NC_FLOAT',[XDimID,TimeDimID],'Sea surface elevation','-','m');
%     WritingParameter(NETCDFID,IsopycnalDislocation,'Dislocation','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Displacement of isopycnals at X,Z and T. Positive value are upwelling','12','m');
%     WritingParameter(NETCDFID,UH,'UH','NC_FLOAT',[XDimID,TimeDimID],'Barotropic horizontal velocity','6','m/s');
    
    ZPlusD=Z3D+UC*0;
    ZPlusD=ZPlusD-repmat(nanmin(ZPlusD,[],2),1,size(ZC,1),1);
    WBottom=permute(repmat(UH,1,1,size(ZC,1)),[1,3,2]);
    WBottom=-DiffCustom(ZPlusD.*WBottom,1)./XXZTDiff;
    clear ZPlusD;
    ConversionRate=RhoPrime.*WBottom*g-DiffCustom(Q,2)./Z3DDiff.*WBottom;
       
    WritingParameter(NETCDFID,WBottom,'WBot','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Barotropic Vertical Velocity','Kang 7','m/s');
    clear WBottom;
    WritingParameter(NETCDFID,ConversionRate,'Conversion','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Conversion rate of barotropic to baroclinic','17','Wat/m^3');
 
    ConversionRate=squeeze(sum((ConversionRate).*Z3DDiff,2));
    WritingParameter(NETCDFID,ConversionRate,'ConversionDI','NC_FLOAT',[XDimID,TimeDimID],'Time-averaged depth-integrated conversion rate of barotropic to baroclinic.The two cells above the bed was set to zero to avoid numerical issues due to buldging of isopycanls','-','Wat/m^2');

    ConversionRate=squeeze(mean(ConversionRate,2));
    WritingParameter(NETCDFID,ConversionRate,'ConversionDITA','NC_FLOAT',XDimID,'Depth-integrated time-averaged conversion rate of barotropic to baroclinic','-','Wat/m^2');
    
    EK0=0.5*Rho0*UH.^2;
    EKPrime=0.5*Rho0*(UPrime.^2+W.^2);
    EKPrime0=Rho0*permute(repmat(UH,1,1,size(ZC,1)),[1 3 2]).*UPrime;

    Advection1=UH.*EK0.*HTotal;%EK0 gets out of integral and the result is int(dz) which is H aka HTotal
    Temporary=mean(Advection1,2);
    WritingParameter(NETCDFID,Temporary,'Advection','NC_FLOAT',XDimID,'Advection of barotropic horizontal kinetic Energy (Depth integrated and time averaged)','15','Wat/m');

    PressureWork1=UH.*HTotal.*Eta*Rho0*g;
    WritingParameter(NETCDFID,PressureWork1,'PressureWork1','NC_FLOAT',[XDimID,TimeDimID],'Pressure work of surface disturbance (Depth integrated)','15','Wat/m');

    PPrime=g*cumsum(RhoPrime.*Z3DDiff,2);
    PressureWork2=UH.*squeeze(nansum(PPrime.*Z3DDiff,2));
    Temporary=mean(PressureWork2,2);
    WritingParameter(NETCDFID,Temporary,'PressureWork2','NC_FLOAT',XDimID,'Pressure work in the result of wave presence PPrime (Depth integrated and time averaged)','15','Wat/m');

    PressureWork3=UH.*squeeze(nansum(Q.*Z3DDiff,2));
    Temporary=mean(PressureWork3,2);
    WritingParameter(NETCDFID,Temporary,'PressureWork3','NC_FLOAT',XDimID,'Pressure work of non-hydrostatic pressure Q (Depth integrated and time averaged)','15','Wat/m');

    Diffusion1=-KnuH*DiffCustom(EK0,1)./XXTDiff.*HTotal;%EK0 gets out of integral and the result is int(dz) which is H aka HTotal
    Temporary=mean(Diffusion1,2);
    WritingParameter(NETCDFID,Temporary,'Diffusion1','NC_FLOAT',XDimID,'Diffusion work of barotropic kinetic energy (Depth integrated and time averaged)','15','Wat/m');

    F0Bar=Advection1+PressureWork1+PressureWork2+PressureWork3+Diffusion1;
    WritingParameter(NETCDFID,F0Bar,'F0Bar','NC_FLOAT',[XDimID,TimeDimID],'Barotropic Energy Flux (Depth integrated)','15','Wat/m');
    disp('F0Bar calculation is done')

    AdvectionPrime1=UC.*EKPrime;
    Temporary=squeeze(nansum(AdvectionPrime1.*Z3DDiff,2));
    Temporary=mean(Temporary,2);
    WritingParameter(NETCDFID,Temporary,'AdvectionPrime1','NC_FLOAT',XDimID,'Advection of the baroclinic kinetic energy (Depth integrated and time averaged)','16','Wat/m');

    AdvectionPrime2=UC.*EKPrime0;
    Temporary=squeeze(nansum(AdvectionPrime2.*Z3DDiff,2));
    Temporary=mean(Temporary,2);  
    WritingParameter(NETCDFID,Temporary,'AdvectionPrime2','NC_FLOAT',XDimID,'Advection of the barotropic-baroclinic kinetic energy (Depth integrated and time averaged)','16','Wat/m');

    AdvectionPrime3=UC.*EPPrime;
    WritingParameter(NETCDFID,AdvectionPrime3,'AdvectionPrime3','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Advection of available potential energy','16','Wat/m');

    PressureWorkPrime1=UPrime.*PPrime;
    Temporary=squeeze(nansum(PressureWorkPrime1.*Z3DDiff,2));
    Temporary=mean(Temporary,2);  
    WritingParameter(NETCDFID,Temporary,'PressureWorkPrime1','NC_FLOAT',XDimID,'Pressure work of PPrime (Depth integrated and time averaged)','16','Wat/m');

    PressureWorkPrime2=UPrime.*Q;
    Temporary=squeeze(nansum(PressureWorkPrime2.*Z3DDiff,2));
    Temporary=mean(Temporary,2);    
    WritingParameter(NETCDFID,Temporary,'PressureWorkPrime2','NC_FLOAT',XDimID,'Pressure work of non-hydrostatic pressure (Depth integrated and time averaged)','16','Wat/m');

    DiffusionPrime1=-KnuH*DiffCustom(EKPrime,1)./XXZTDiff;
    Temporary=squeeze(nansum(DiffusionPrime1.*Z3DDiff,2));
    Temporary=mean(Temporary,2);    
    WritingParameter(NETCDFID,Temporary,'DiffusionPrime1','NC_FLOAT',XDimID,'Diffusion work of baroclinic kinetic energy (Depth integrated and time averaged)','16','Wat/m');

    DiffusionPrime2=-KappaH*DiffCustom(EPPrime,1)./XXZTDiff;
    Temporary=squeeze(nansum(DiffusionPrime2.*Z3DDiff,2));
    Temporary=mean(Temporary,2);        
    WritingParameter(NETCDFID,Temporary,'DiffusionPrime2','NC_FLOAT',XDimID,'Diffusion work of available potential energy (Depth integrated and time averaged)','16','Wat/m');

    FPrimeBar=AdvectionPrime1+AdvectionPrime2+AdvectionPrime3+PressureWorkPrime1+PressureWorkPrime2+DiffusionPrime1+DiffusionPrime2;
    WritingParameter(NETCDFID,FPrimeBar,'FPrimeBar','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Baroclinic energy flux','16','Wat/m');
    disp('F0PrimeBar is saved in the NETCDF')

    netcdf.close(NETCDFID);
    
    if(SapeloFlag)
        import java.lang.System
        java.lang.System.exit(0)
    end
%     EnergyFluxInterpreter(X,Time,XLocation,CaseNumber...
%         ,Advection1,PressureWork1,PressureWork2,PressureWork3,Diffusion1,BTDissipation...
%         ,AdvectionPrime1,AdvectionPrime2,AdvectionPrime3,PressureWorkPrime1,PressureWorkPrime2,DiffusionPrime1,DiffusionPrime2,BCDissipation...
%         ,ConversionRate);


% end



function DIFF=DiffCustom(InputMatrix,DimensionDifferentiate)
    DIFF=diff(InputMatrix,1,DimensionDifferentiate);
    switch DimensionDifferentiate
        case 1
            if ndims(InputMatrix)==3
                DIFF(end+1,:,:)=DIFF(end,:,:);
            elseif ndims(InputMatrix)==2
                DIFF(end+1,:)=DIFF(end,:);
            else
                return;
            end
        case 2
            if ndims(InputMatrix)==3
                DIFF(:,end+1,:)=DIFF(:,end,:);
            elseif ndims(InputMatrix)==2
                DIFF(:,end+1)=DIFF(:,end);
            else
                return;
            end
        case 3
            DIFF(:,:,end+1)=DIFF(:,:,end);
        otherwise
            return;
    end
end

function WritingParameter(NETCDFID,ParameterName,ParameterNETCDFName,ParameterType,ParameterSize,...
    ParameterDiscription,ParameterEquationNumber,ParameterUnit)
    
    ParameterID= netcdf.defVar(NETCDFID,ParameterNETCDFName,ParameterType,ParameterSize);
    netcdf.putAtt(NETCDFID,ParameterID,'Description',ParameterDiscription);
    netcdf.putAtt(NETCDFID,ParameterID,'Equation Number',ParameterEquationNumber);
    netcdf.putAtt(NETCDFID,ParameterID,'Units',ParameterUnit);
    netcdf.putVar(NETCDFID,ParameterID,ParameterName);
    disp([ParameterNETCDFName,' is saved in the NETCDF'])
end

function [EPPrime,IsopycnalDislocation]=EPCalculator(X,ZC,Time,Density,RhoB,InterpRes,g,SapeloFlag)   
    %To better calculate the APE, teh whole density profile is interpolated
    %at each time step for each X. The  the displacement of isopycanls was
    %calculated. After that, the resolution was reduced to the normal. This
    %process has been done to capture the small displacment of isopycanls
    %and also not to interfere with the original vertical resolution.
    
    if(SapeloFlag)
        c = parcluster('local');
        c.NumWorkers = 12;
        parpool(c, c.NumWorkers);%Assigning the number of wrokers on SAPELO
    else
        if isempty(gcp('nocreate'))
            parpool('local', 4);
        end
    end

    ZInterp=linspace(ZC(1),ZC(end),InterpRes*size(ZC,1)-InterpRes+1);
    ZInterp=ZInterp';
    
    EPPrimeCell=cell(size(X,1),1);
    DensityCell=cell(size(X,1),1);
    ZCCellNoInterp=cell(size(X,1),1);
    ZCCellInterp=cell(size(X,1),1);
    IsopycnalDislocationCell=cell(size(X,1),1);
    RhoBCell=cell(size(X,1),1);
    
    DepthX=0*squeeze(Density(:,:,1))+1;
    DepthX=cumsum(DepthX,2);
    DepthX=nanmax(DepthX,[],2);
    
    [ZCGrid,TimeGrid]=meshgrid(Time,ZC);
    [ZInterpGrid,TimeInterpGrid]=meshgrid(Time,ZInterp);
    RhoBInterp=interp2(ZCGrid,TimeGrid,RhoB,ZInterpGrid,TimeInterpGrid,'linear');%Linear gives fair result while spline,cause numerical oscillation
    
    for i=1:size(X,1)
        EPPrimeCell{i}=nan(size(ZC,1),size(Time,1));
        DensityCell{i}=squeeze(Density(i,:,:));
        ZCCellNoInterp{i}=ZC(1:DepthX(i));
        ZCCellInterp{i}=ZInterp(:);
        RhoBCell{i}=RhoBInterp(:,:);
        IsopycnalDislocationCell{i}=nan(size(ZC,1),size(Time,1));
    end  
    CreatedParallelPool = parallel.pool.DataQueue;	
    afterEach(CreatedParallelPool, @UpdateStatusDisp);	
    ProgressStatus=0;

    parfor i=1:size(X,1)
        ZCWorker=ZCCellNoInterp{i};
        ZInterpWorker=ZCCellInterp{i};
        for k=1:size(Time,1)           
            RhoProfile=squeeze(DensityCell{i}(:,k));
            RhoBInterpWorker=squeeze(RhoBCell{i}(:,k));
            for j=1:size(ZCWorker,1)
                [~,TrackedDensityIndex]=nanmin(abs(RhoProfile(j)-RhoBInterpWorker));
                TrackedDensityIndex=TrackedDensityIndex(1);
                Dislocation=ZInterpWorker((j-1)*InterpRes+1)-ZInterpWorker(TrackedDensityIndex);%if Dislocation<0 downwelling and if dislocation>0 upwelling
                
                if Dislocation==0
                    EPPrimeCell{i}(j,k)=0;
                elseif Dislocation<0%Downwelling
                    MaxBoundary=(j-1)*InterpRes+1;
                    MinBoundary=TrackedDensityIndex;
                    EPPrimeCell{i}(j,k)=-g*trapz(-ZInterpWorker(MinBoundary:MaxBoundary),...
                        RhoProfile(j)-RhoBInterpWorker(MinBoundary:MaxBoundary));
                elseif Dislocation>0%Upwelling
                    MaxBoundary=TrackedDensityIndex;
                    MinBoundary=(j-1)*InterpRes+1;
                    EPPrimeCell{i}(j,k)=+g*trapz(-ZInterpWorker(MinBoundary:MaxBoundary),...
                        RhoProfile(j)-RhoBInterpWorker(MinBoundary:MaxBoundary));
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

    EPPrimeConv = cellfun(@(TempCellConv)reshape(TempCellConv,1,size(ZC,1),size(Time,1)),EPPrimeCell,'un',0);
    EPPrime= cell2mat(EPPrimeConv);
    
    WaveAmplitudeConv= cellfun(@(TempCellConv)reshape(TempCellConv,1,size(ZC,1),size(Time,1)),IsopycnalDislocationCell,'un',0);
    IsopycnalDislocation= cell2mat(WaveAmplitudeConv);
end

function [DataTruncated,XTruncated]=DataXTruncator(Data,X)
    %This function reduce the resolution in X direction to save some space.
    %The high resolution was inforced by stability in SUNTANS.
    DataIndex=[];
    for i=1:size(X,1)
        if X(i)<8000
            continue;
        else
            if mod(i,10)~=0
                DataIndex(end+1)=i;
            end            
        end
    end
    XTruncated=X;
    XTruncated(DataIndex)=[];
    DataTruncated=Data;
    if ndims(Data)==2
        DataTruncated(DataIndex,:)=[];
    elseif ndims(Data)==3
        DataTruncated(DataIndex,:,:)=[];
    else
        disp('Error happened in DataXTruncator function');
        return;
    end
end
