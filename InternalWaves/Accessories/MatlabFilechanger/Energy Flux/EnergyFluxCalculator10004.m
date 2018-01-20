function EnergyFluxCalculator10004(DataPath,CaseNumber,KnuH,KappaH,g,InterpolationEnhancement,XLocation,XEndIndex,DiurnalTideOmega,SemiDiurnalTideOmega,WindTauMax,TimeStartIndex,TimeEndIndex,PycnoclineDepthIndex,BathymetryXLocationAtPycnoclineIndex,SapeloFlag)

    
    CountTimeIndex=TimeEndIndex-TimeStartIndex;
    disp('Reading the NETCDF')
    InputNETCDF=DataPath;%The NETCDF file from SUNTANS
    if SapeloFlag
        OutputNETCDF=strcat('/lustre1/omidvar/work-directory_0801/6th-Processed/',num2str(CaseNumber),'-EnergyFlux.nc');%The energy
    else
        %OutputNETCDF=strcat('F:\6th-Processed\',num2str(CaseNumber),'-EnergyFlux.nc');%The energy flux calculation results
        OutputNETCDF=strcat('D:\10010-EnergyFlux.nc');%The energy flux calculation results
    end
    X=ncread(InputNETCDF,'xv',1,XEndIndex);
    Time=ncread(InputNETCDF,'time',TimeStartIndex,CountTimeIndex);
    ZC=-ncread(InputNETCDF,'z_r');%I changed ZC and ZE sign to make it compatible with formulas
    Eta=ncread(InputNETCDF,'eta',[1,TimeStartIndex],[XEndIndex,CountTimeIndex]);
    Density=1000*ncread(InputNETCDF,'rho',[1,1,TimeStartIndex],[XEndIndex,Inf,CountTimeIndex])+1000;
    Rho0=1025;%Setting the reference density
    Q=ncread(InputNETCDF,'q',[1,1,TimeStartIndex],[XEndIndex,Inf,CountTimeIndex]);
    Q=Q.*Rho0;%Scaling the non-hydrostatic pressure
    u=ncread(InputNETCDF,'uc',[1,1,TimeStartIndex],[XEndIndex,Inf,CountTimeIndex]);
    w=ncread(InputNETCDF,'w',[1,1,TimeStartIndex],[XEndIndex,Inf,CountTimeIndex]);
    w=movsum(w,2,2)/2;%Averaging the w over two horizontal edge to get the center value
    w(:,1,:)=[];%disregarding the first layer becaue for cell i movsum is summing i-1 and i
    disp('NETCDF reading is compeleted')
    %Calculating Brunt-Vaisala max at the pycnocline
    BruntVaisalaMax=diff(transpose(squeeze(Density(end,:,1))),1,1)...
        ./diff(ZC,1,1)/Rho0*g;
    BruntVaisalaMax=(-BruntVaisalaMax).^0.5;
    BruntVaisalaMax=max(BruntVaisalaMax);

    XXT=repmat(X,1,size(Time,1));%Repeating the X array in 3D for later used
    XXZT=repmat(X,1,size(ZC,1),size(Time,1));%Repeating the X array in 2D for later used
    XXTDiff=DiffCustom(XXT,1);%Calculating the derrivative of X in X direction and repeat it for 2D
    XXZTDiff=DiffCustom(XXZT,1);%Calculating the derrivative of X in X direction and repeat it for 3D
    
    Z3D=permute(repmat(ZC,1,size(X,1),size(Time,1)),[2,1,3]);
    Temp=permute(repmat(Eta,1,1,size(ZC,1)),[1,3,2]);
    Temp(:,2:end,:)=0;
    Z3D=Z3D+Temp;
    clear Temp;
    Z3DDiff=-diff(Z3D,1,2);%dz should always be positive, the negative sign is to make it positive!
    Z3DDiff(:,end+1,:)=Z3DDiff(:,end,:);    
    

    disp('EPPrime calculation is started')
    EPPrimeCell=EPCalculatorVer12(X,ZC,Time,Density,Rho0,InterpolationEnhancement,g,SapeloFlag);
    EPPrimeConv = cellfun(@(TempCellConv)reshape(TempCellConv,1,size(ZC,1),size(Time,1)),EPPrimeCell,'un',0);
    EPPrime= cell2mat(EPPrimeConv);
    clear EPPrimeCell EPPrimeConv;
    disp('EPPrime calculation is done')

    RhoB=Density(:,:,1)-Rho0;
    RhoPrime=Density-repmat(RhoB,1,1,size(Time,1))-Rho0;

    HTotal=squeeze(nanmax(Z3D,[],2)-nanmin(Z3D,[],2));
    
    UH=squeeze(nansum(u.*Z3DDiff,2))./HTotal;
    UPrime=u-permute(repmat(UH,1,1,size(ZC,1)),[1 3 2]);

    DPlusZ=permute(repmat(HTotal,1,1,size(ZC,1)),[1,3,2])+Z3D;
    DPlusZ=DPlusZ+repmat(RhoB,1,1,size(Time,1))*0;%To consider the NAN values
    DPlusZDiff=diff(DPlusZ,1,2);
    DPlusZDiff(:,end+1,:)=DPlusZDiff(:,end,:);
    WBarotropic=-DPlusZ.*permute(repmat(DiffCustom(UH,1),1,1,size(ZC,1)),[1,3,2]) ...
        -permute(repmat(UH,1,1,size(ZC,1)),[1,3,2]).*DPlusZDiff;
    WBarotropic=WBarotropic./XXZTDiff;

    %Creating the output NETCDF
    netcdf.setDefaultFormat('FORMAT_NETCDF4'); 
    mode = netcdf.getConstant('CLOBBER');
    NETCDFID = netcdf.create(OutputNETCDF,mode);
    disp('The NETCDF file for energy flux is created')

    %Creating the dimensions for the NETCDF
    TimeDimID= netcdf.defDim(NETCDFID,'Time',size(Time,1));
    XDimID= netcdf.defDim(NETCDFID,'OffshoreDistance',size(X,1));
    ZCDimID= netcdf.defDim(NETCDFID,'Depth',size(ZC,1));
    SingleID=netcdf.defDim(NETCDFID,'Single',1);

    %Writing DiurnalTideOmega in the output NETCDF
    WritingParameter(NETCDFID,DiurnalTideOmega,'Diurnal','NC_FLOAT',SingleID,'Diurnal Tide Omega','-','Radian/Sec');
    WritingParameter(NETCDFID,SemiDiurnalTideOmega,'SemiDiurnal','NC_FLOAT',SingleID,'Semi-Diurnal Tide Omega','-','Radian/Sec');
    WritingParameter(NETCDFID,WindTauMax,'Wind','NC_FLOAT',SingleID,'Wind shear stress','-','N/m^2');
    WritingParameter(NETCDFID,PycnoclineDepthIndex,'PycnoclineIndex','NC_FLOAT',SingleID,'Index of Z at which Pycnocline is located','-','Index');
    WritingParameter(NETCDFID,BathymetryXLocationAtPycnoclineIndex,'BathymetryXPycnoclineIndex','NC_FLOAT',SingleID,'Index of X at which bathymetry confront with pycnocline (offshore distance)','-','index');
    WritingParameter(NETCDFID,BruntVaisalaMax,'BruntVaisalaMax','NC_FLOAT',SingleID,'Maximum Brunt Vaisala at the pycnocline','-','1/s');
    WritingParameter(NETCDFID,Time,'Time','NC_FLOAT',TimeDimID,'Time','-','Second');
    WritingParameter(NETCDFID,X,'X','NC_FLOAT',XDimID,'Off-shore Location of Cell Center','-','meter');
    WritingParameter(NETCDFID,ZC,'Z','NC_FLOAT',ZCDimID,'Depth of Cell Center','-','meter');
    WritingParameter(NETCDFID,Density,'Density','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Density of Cell Center','-','kg/m^3');
    WritingParameter(NETCDFID,u,'U','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Cross-shore Velocity (u)','-','m/s');
    WritingParameter(NETCDFID,w,'W','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Vertical Velocity (w)','-','m/s');
    WritingParameter(NETCDFID,Q,'Q','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Non-hydrostatic Pressure','-','N/m^2');

    PPrime=g*cumsum(RhoPrime.*Z3DDiff,2);
    ConversionRate=DiffCustom(Q,2)./(-Z3DDiff).*WBarotropic ...
        +g*RhoPrime.*WBarotropic;%I used -Z3DDiff because it is (Qbottom-Qtop)/(ZBottom-Ztop) and the denumertor is negative and Z3dDiff is all positive (it is just dz)
    WritingParameter(NETCDFID,ConversionRate,'Conversion','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Conversion rate of barotropic to baroclinic (Depth integrated)','17','Wat/m^2');

    EK0=0.5*Rho0*UH.^2;
    EKPrime=0.5*Rho0*(UPrime.^2+w.^2);
    EKPrime0=Rho0*permute(repmat(UH,1,1,size(ZC,1)),[1 3 2]).*UPrime;

    Advection1=UH.*EK0.*HTotal;%it is depth integrated by itself!
    Temporary=nanmean(Advection1,2);
    WritingParameter(NETCDFID,Temporary,'Advection','NC_FLOAT',XDimID,'Advection of barotropic horizontal kinetic Energy (Depth integrated and time averaged)','15','Wat/m');

    PressureWork1=UH.*HTotal.*Eta*Rho0*g;
    WritingParameter(NETCDFID,PressureWork1,'PressureWork1','NC_FLOAT',[XDimID,TimeDimID],'Pressure work of surface disturbance (Depth integrated)','15','Wat/m');

    PressureWork2=UH.*squeeze(nansum(PPrime.*Z3DDiff,2));
    Temporary=nanmean(PressureWork2,2);
    WritingParameter(NETCDFID,Temporary,'PressureWork2','NC_FLOAT',XDimID,'Pressure work in the result of wave presence PPrime (Depth integrated and time averaged)','15','Wat/m');

    PressureWork3=UH.*squeeze(nansum(Q.*Z3DDiff,2));
    Temporary=nanmean(PressureWork3,2);
    WritingParameter(NETCDFID,Temporary,'PressureWork3','NC_FLOAT',XDimID,'Pressure work of non-hydrostatic pressure Q (Depth integrated and time averaged)','15','Wat/m');

    Diffusion1=-KnuH*DiffCustom(EK0,1)./XXTDiff.*HTotal;
    Temporary=nanmean(Diffusion1,2);
    WritingParameter(NETCDFID,Temporary,'Diffusion1','NC_FLOAT',XDimID,'Diffusion work of barotropic kinetic energy (Depth integrated and time averaged)','15','Wat/m');

    F0Bar=Advection1+PressureWork1+PressureWork2+PressureWork3+Diffusion1;
    WritingParameter(NETCDFID,F0Bar,'F0Bar','NC_FLOAT',[XDimID,TimeDimID],'Barotropic Energy Flux (Depth integrated)','15','Wat/m');
    disp('F0Bar calculation is done')

    AdvectionPrime1=u.*EKPrime;
    Temporary=squeeze(nansum(AdvectionPrime1.*Z3DDiff,2));
    Temporary=nanmean(Temporary,2);
    WritingParameter(NETCDFID,Temporary,'AdvectionPrime1','NC_FLOAT',XDimID,'Advection of the baroclinic kinetic energy (Depth integrated and time averaged)','16','Wat/m');

    AdvectionPrime2=u.*EKPrime0;
    Temporary=squeeze(nansum(AdvectionPrime2.*Z3DDiff,2));
    Temporary=nanmean(Temporary,2);  
    WritingParameter(NETCDFID,Temporary,'AdvectionPrime2','NC_FLOAT',XDimID,'Advection of the barotropic-baroclinic kinetic energy (Depth integrated and time averaged)','16','Wat/m');

    AdvectionPrime3=u.*EPPrime;
    WritingParameter(NETCDFID,AdvectionPrime3,'AdvectionPrime3','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Advection of available potential energy','16','Wat/m');

    PressureWorkPrime1=UPrime.*PPrime;
    Temporary=squeeze(nansum(PressureWorkPrime1.*Z3DDiff,2));
    Temporary=nanmean(Temporary,2);  
    WritingParameter(NETCDFID,Temporary,'PressureWorkPrime1','NC_FLOAT',XDimID,'Pressure work of PPrime (Depth integrated and time averaged)','16','Wat/m');

    PressureWorkPrime2=UPrime.*Q;
    Temporary=squeeze(nansum(PressureWorkPrime2.*Z3DDiff,2));
    Temporary=nanmean(Temporary,2);    
    WritingParameter(NETCDFID,Temporary,'PressureWorkPrime2','NC_FLOAT',XDimID,'Pressure work of non-hydrostatic pressure (Depth integrated and time averaged)','16','Wat/m');

    DiffusionPrime1=DiffCustom(EKPrime,1)./XXZTDiff;
    DiffusionPrime1=-KnuH*DiffusionPrime1;
    Temporary=squeeze(nansum(DiffusionPrime1.*Z3DDiff,2));
    Temporary=nanmean(Temporary,2);    
    WritingParameter(NETCDFID,Temporary,'DiffusionPrime1','NC_FLOAT',XDimID,'Diffusion work of baroclinic kinetic energy (Depth integrated and time averaged)','16','Wat/m');

    DiffusionPrime2=DiffCustom(EPPrime,1)./XXZTDiff;
    DiffusionPrime2=-KappaH*DiffusionPrime2;
    Temporary=squeeze(nansum(DiffusionPrime2.*Z3DDiff,2));
    Temporary=nanmean(Temporary,2);        
    WritingParameter(NETCDFID,Temporary,'DiffusionPrime2','NC_FLOAT',XDimID,'Diffusion work of available potential energy (Depth integrated and time averaged)','16','Wat/m');

    FPrimeBar=AdvectionPrime1+AdvectionPrime2+AdvectionPrime3+PressureWorkPrime1+PressureWorkPrime2+DiffusionPrime1+DiffusionPrime2;
    WritingParameter(NETCDFID,FPrimeBar,'FPrimeBar','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Baroclinic energy flux','16','Wat/m');
    disp('F0PrimeBar is saved in the NETCDF')

    netcdf.close(NETCDFID);
    
    if(SapeloFlag)
        import java.lang.System
        java.lang.System.exit(0)
    end
end
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

function EPPrimeCell=EPCalculatorVer12(X,ZC,Time,Density,RhoKnot,Accuracy,g,SapeloFlag)
    
    c = parcluster('local');
    c.NumWorkers = 24;
    parpool(c, c.NumWorkers);%Assigning the number of wrokers on SAPELO

    Z=linspace(ZC(1),ZC(end),Accuracy*size(ZC,1));
    ZStep=Z(1)-Z(2);
    RhoB=squeeze(Density(:,:,1))-RhoKnot;
    EPPrimeCell=cell(size(X,1),1);
    DensityCell=cell(size(X,1),1);

    for i=1:size(X,1)
        EPPrimeCell{i}=nan(size(ZC,1),size(Time,1));
        DensityCell{i}=squeeze(Density(i,:,:));
    end

    parfor i=1:size(X,1)
        Profile1=squeeze(DensityCell{i}(:,1));
        NotNanDepthIndexZC=find(~isnan(RhoB(i,:)));
        NotNanDepthIndexZC=NotNanDepthIndexZC(end);%Finding the deepest not-nan cell in un-interpolated profile(profile1)
        [~,NotNanDepthIndexZ]=nanmin(abs(Z-ZC(NotNanDepthIndexZC)));%Finding the closest depth to the one found in the upper line, in the interpolated profile(profile2)
        RhoBExact=interp1(ZC(1:NotNanDepthIndexZC),squeeze(RhoB(i,1:NotNanDepthIndexZC)),Z(1:NotNanDepthIndexZ),'spline');%Removing the nan part from RhoB and its interpolation
        if size(RhoBExact,2)~=size(Z,2)%making the interpolated profile2 the same size of as it should be
            RhoBExact(end+1:size(Z,2))=nan;
        end
        for k=1:size(Time,1)
            Profile2=squeeze(DensityCell{i}(:,k));
            ProfileExact2=squeeze(DensityCell{i}(:,k));
            ProfileExact2=interp1(ZC(1:NotNanDepthIndexZC),ProfileExact2(1:NotNanDepthIndexZC),Z(1:NotNanDepthIndexZ),'spline');%interpolating the profile2
            if size(ProfileExact2,1)~=size(Z,2)%making the rest of the elements nan close to the shore
                ProfileExact2(end+1:size(Z,2))=nan;
            end
            for j=1:size(ZC,1)
                if ~isnan(Profile1(j))
                    [~,TrackedDensityIndex]=nanmin(abs(ProfileExact2-Profile1(j)));
                    TrackedDensityIndex=TrackedDensityIndex(1);
                    Dislocation=ZC(j)-Z(TrackedDensityIndex);
                    Max=ZC(j);
                    Min=ZC(j)-Dislocation;
                    [~,MaxIndex]=nanmin(abs(Z-Max));
                    [~,MinIndex]=nanmin(abs(Z-Min));
                    if MaxIndex>MinIndex
                        EPPrimeCell{i}(j,k)=-g*sum(RhoBExact(MinIndex:MaxIndex))*ZStep;
                    elseif MaxIndex<MinIndex
                        EPPrimeCell{i}(j,k)=g*sum(RhoBExact(MaxIndex:MinIndex))*ZStep;%Changing the sign since the dislocation is negative!
                    elseif MaxIndex==MinIndex
                        EPPrimeCell{i}(j,k)=0;
                    end
                    RhoPrime=DensityCell{i}(j,k)-RhoB(j)-RhoKnot;
                    EPPrimeCell{i}(j,k)=EPPrimeCell{i}(j,k)+g*Dislocation*...
                        (Profile2(j)+RhoPrime);%eq 12
                end
            end
        end 
        sprintf('X=%f',i*100)
    end
end