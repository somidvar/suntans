%This program has been written by Sorush Omidvar under supervision of 
%Dr. Woodson in Cobia lab at UGA in May 2017 to
%calculate wave energy flux from SUNTANS netcdf files.

%Notation which is used in this program is based on the article
%"Energetics of Barotropic and Baroclinic Tides in the Monterey Bay Area"
%in 2011

function EnergyFluxCalculator(DataPath,CaseNumber,OutputAddress,KnuH,KappaH,g,...
    InterpolationEnhancement,XEndIndex,DiurnalTideOmega,...
    SemiDiurnalTideOmega,WindTauMax,TimeStartIndex,TimeEndIndex,...
    PycnoclineDepthIndex,BathymetryXLocationAtPycnoclineIndex,SapeloFlag)

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
    Rho0=1025;%Setting the reference density
    RhoB=1000*ncread(DataPath,'rho',[1,1,1],[XEndIndex,Inf,1])+1000-Rho0;
    [RhoB,~]=DataXTruncator(RhoB,X);
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
    Temp(:,2:end,:)=0;
    Z3D=Z3D+Temp;
    clear Temp;
    Z3DDiff=-diff(Z3D,1,2);%dz should always be positive, the negative sign is to make it positive!
    Z3DDiff(:,end+1,:)=Z3DDiff(:,end,:);    
    

    disp('EPPrime calculation is started')
    EPPrimeCell=EPCalculator(X,ZC,Time,Density,Rho0,RhoB,InterpolationEnhancement,g,SapeloFlag);
    EPPrimeConv = cellfun(@(TempCellConv)reshape(TempCellConv,1,size(ZC,1),size(Time,1)),EPPrimeCell,'un',0);
    EPPrime= cell2mat(EPPrimeConv);
    clear EPPrimeCell EPPrimeConv;
    disp('EPPrime calculation is done')

    RhoPrime=Density-repmat(RhoB,1,1,size(Time,1))-Rho0;

    HTotal=squeeze(nanmax(Z3D,[],2)-nanmin(Z3D,[],2));
    
    UH=squeeze(nansum(UC.*Z3DDiff,2))./HTotal;
    UPrime=UC-permute(repmat(UH,1,1,size(ZC,1)),[1 3 2]);

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
    NETCDFID = netcdf.create(strcat(OutputAddress,num2str(CaseNumber),'EnergyFlux.nc'),mode);
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
    WritingParameter(NETCDFID,Time,'Time','NC_FLOAT',TimeDimID,'Time','-','Second');
    WritingParameter(NETCDFID,X,'X','NC_FLOAT',XDimID,'Off-shore Location of Cell Center','-','meter');
    WritingParameter(NETCDFID,ZC,'Z','NC_FLOAT',ZCDimID,'Depth of Cell Center','-','meter');
    WritingParameter(NETCDFID,Density,'Density','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Density of Cell Center','-','kg/m^3');
    WritingParameter(NETCDFID,UC,'U','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Cross-shore Velocity (u)','-','m/s');
    WritingParameter(NETCDFID,W,'W','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Vertical Velocity (w)','-','m/s');
    WritingParameter(NETCDFID,Q,'Q','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Non-hydrostatic Pressure','-','N/m^2');

    PPrime=g*cumsum(RhoPrime.*Z3DDiff,2);
    ConversionRate=DiffCustom(Q,2)./(-Z3DDiff).*WBarotropic ...
        +g*RhoPrime.*WBarotropic;%I used -Z3DDiff because it is (Qbottom-Qtop)/(ZBottom-Ztop) and the denumertor is negative and Z3dDiff is all positive (it is just dz)
    WritingParameter(NETCDFID,ConversionRate,'Conversion','NC_FLOAT',[XDimID,ZCDimID,TimeDimID],'Conversion rate of barotropic to baroclinic (Depth integrated)','17','Wat/m^2');

    EK0=0.5*Rho0*UH.^2;
    EKPrime=0.5*Rho0*(UPrime.^2+W.^2);
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

    AdvectionPrime1=UC.*EKPrime;
    Temporary=squeeze(nansum(AdvectionPrime1.*Z3DDiff,2));
    Temporary=nanmean(Temporary,2);
    WritingParameter(NETCDFID,Temporary,'AdvectionPrime1','NC_FLOAT',XDimID,'Advection of the baroclinic kinetic energy (Depth integrated and time averaged)','16','Wat/m');

    AdvectionPrime2=UC.*EKPrime0;
    Temporary=squeeze(nansum(AdvectionPrime2.*Z3DDiff,2));
    Temporary=nanmean(Temporary,2);  
    WritingParameter(NETCDFID,Temporary,'AdvectionPrime2','NC_FLOAT',XDimID,'Advection of the barotropic-baroclinic kinetic energy (Depth integrated and time averaged)','16','Wat/m');

    AdvectionPrime3=UC.*EPPrime;
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
%     EnergyFluxInterpreter(X,Time,XLocation,CaseNumber...
%         ,Advection1,PressureWork1,PressureWork2,PressureWork3,Diffusion1,BTDissipation...
%         ,AdvectionPrime1,AdvectionPrime2,AdvectionPrime3,PressureWorkPrime1,PressureWorkPrime2,DiffusionPrime1,DiffusionPrime2,BCDissipation...
%         ,ConversionRate);
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

function EnergyFluxInterpreter(X,Time,XLocation,CaseNumber...
    ,Advection1,PressureWork1,PressureWork2,PressureWork3,Diffusion1,BTDissipation...
    ,AdvectionPrime1,AdvectionPrime2,AdvectionPrime3,PressureWorkPrime1,PressureWorkPrime2,DiffusionPrime1,DiffusionPrime2,BCDissipation...
    ,ConversionRate)
    close all;
    
    FIG=figure('units','normalized','outerposition',[0 0 1 1]);
    subplot(2,6,1);
    pcolor(X/1000,Time/3600,Advection1');
    shading flat;
    colorbar;
    set(gca,'layer','top');
    grid on;
    xlabel('X (km)');
    ylabel('Time (hour)');
    title('A 1 (Wat/m)');

    subplot(2,6,2);
    pcolor(X/1000,Time/3600,PressureWork1');
    shading flat;
    colorbar;
    set(gca,'layer','top');
    grid on;
    xlabel('X (km)');
    title('PW 1 (Wat/m)');

    subplot(2,6,3);
    pcolor(X/1000,Time/3600,PressureWork2');
    shading flat;
    colorbar;
    set(gca,'layer','top');
    grid on;
    xlabel('X (km)');
    title('PW 2 (Wat/m)');

    subplot(2,6,4);
    pcolor(X/1000,Time/3600,PressureWork3');
    shading flat;
    colorbar;
    set(gca,'layer','top');
    grid on;
    xlabel('X (km)');
    title('PW 3 (Wat/m)');

    subplot(2,6,5);
    pcolor(X/1000,Time/3600,Diffusion1');
    shading flat;
    colorbar;
    set(gca,'layer','top');
    grid on;
    xlabel('X (km)');
    title('D 1 (Wat/m)');

    %Now plotting the prime terms
    subplot(2,6,7);
    pcolor(X/1000,Time/3600,AdvectionPrime1');
    shading flat;
    colorbar;
    set(gca,'layer','top');
    grid on;
    xlabel('X (km)');
    ylabel('Time (hour)');
    title('AP 1 (Wat/m)');

    subplot(2,6,8);
    pcolor(X/1000,Time/3600,AdvectionPrime2');
    shading flat;
    colorbar;
    set(gca,'layer','top');
    grid on;
    xlabel('X (km)');
    title('AP 2 (Wat/m)');

    subplot(2,6,9);
    pcolor(X/1000,Time/3600,AdvectionPrime3');
    shading flat;
    colorbar;
    set(gca,'layer','top');
    grid on;
    xlabel('X (km)');
    title('AP 3 (Wat/m)');

    subplot(2,6,10);
    pcolor(X/1000,Time/3600,PressureWorkPrime1');
    shading flat;
    colorbar;
    set(gca,'layer','top');
    grid on;
    xlabel('X (km)');
    title('PWP 1 (Wat/m)');

    subplot(2,6,11);
    pcolor(X/1000,Time/3600,PressureWorkPrime2');
    shading flat;
    colorbar;
    set(gca,'layer','top');
    grid on;
    xlabel('X (km)');
    title('PWP 2 (Wat/m)');

    subplot(2,6,12);
    pcolor(X/1000,Time/3600,DiffusionPrime1');
    shading flat;
    colorbar;
    set(gca,'layer','top');
    grid on;
    xlabel('X (km)');
    title('DP 1 (Wat/m)');
    saveas(FIG,[num2str(CaseNumber),'-Detailed Energy Flux.png']);

    FIG=figure;
    pcolor(X/1000,Time/3600,ConversionRate');
    shading flat;
    colorbar;
    set(gca,'layer','top');
    grid on;
    xlabel('off-shore distance (km)');
    ylabel('Time (hour)');
    title('Depth-Integrated Conversion rate (Wat/m^2)');
    saveas(FIG,[num2str(CaseNumber),'-Conversion Rate.png']);

    FIG=figure;
    plot(Time/3600,Advection1(XLocation,:),Time/3600,PressureWork1(XLocation,:),Time/3600,PressureWork2(XLocation,:),...
        Time/3600,PressureWork3(XLocation,:),Time/3600,Diffusion1(XLocation,:));
    grid minor;
    legend('BT Advection','BT Pressure Work 1','BT Pressure Work 2','BT Pressure Work 3','BT Diffusion');
    xlabel('Time (hour)');
    ylabel('Wat/m');
    title('Baratropic Depth-Integrated Energy Flux Components at X=1700 m');
    saveas(FIG,[num2str(CaseNumber),'-Barotropic Energy Flux.png']);

    FIG=figure;
    plot(Time/3600,AdvectionPrime1(XLocation,:),Time/3600,AdvectionPrime2(XLocation,:),Time/3600,AdvectionPrime3(XLocation,:),...
        Time/3600,PressureWorkPrime1(XLocation,:),Time/3600,PressureWorkPrime2(XLocation,:), Time/3600,DiffusionPrime1(XLocation,:)...
        ,Time/3600,DiffusionPrime2(XLocation,:));
    grid minor;
    legend('BC Advection 1','BC Advection 2','BC Advection 3','BC Pressure Work 1','BC Pressure Work 2',...
    'BC Diffusion 1','BC Diffusion 2');
    xlabel('Time (hour)');
    ylabel('Wat/m');
    title('Baroclinic Depth-Integrated Energy Flux Components at X=1700 m');
    saveas(FIG,[num2str(CaseNumber),'-Baroclinic Energy Flux.png']);

    AD1=abs(mean(Advection1(XLocation,:)));
    PW1=abs(mean(PressureWork1(XLocation,:)));
    PW2=abs(mean(PressureWork2(XLocation,:)));
    PW3=abs(mean(PressureWork3(XLocation,:)));
    DI1=abs(mean(Diffusion1(XLocation,:)));

    FIG=figure;
    BTFluxCategory=categorical({'BT Advection','BT Pressurework 1','BT Pressurework 2',...
        'BT Pressurework 3','BT Diffusion 1'});
    bar(BTFluxCategory,[AD1,PW1,PW2,PW3,DI1]);
    ylabel('Wat/m');
    title('Barotropic Depth-Integrated Time-averaged Energy Flux at X=1700 m');
    saveas(FIG,[num2str(CaseNumber),'-Barotropic Energy Flux Contribution.png']);

    ADP1=abs(mean(AdvectionPrime1(XLocation,:)));
    ADP2=abs(mean(AdvectionPrime2(XLocation,:)));
    ADP3=abs(mean(AdvectionPrime3(XLocation,:)));
    PWP1=abs(mean(PressureWorkPrime1(XLocation,:)));
    PWP2=abs(mean(PressureWorkPrime2(XLocation,:)));
    DIP1=abs(mean(DiffusionPrime1(XLocation,:)));
    DIP2=abs(mean(DiffusionPrime2(XLocation,:)));

    FIG=figure;
    BTFluxCategory=categorical({'BC Advection 1','BC Advection 2','BC Advection 3',...
        'BC Pressurework 1','BC Pressurework 2','BC Diffusion 1','BC Diffusion 2'});
    bar(BTFluxCategory,[ADP1,ADP2,ADP3,PWP1,PWP2,DIP1,DIP2]);
    ylabel('Wat/m');
    title('Baroclinic Depth-Integrated Time-averaged Energy Flux at X=1700 m');
    saveas(FIG,[num2str(CaseNumber),'-Baroclinic Energy Flux Contribution.png']);

    FIG=figure;
    hold on;
    plot(Time/3600,squeeze(BCDissipation(XLocation,:)),'red');
    plot(Time/3600,squeeze(BTDissipation(XLocation,:)),'blue');
    plot(Time/3600,squeeze(BTDissipation(XLocation,:)+BCDissipation(XLocation,:)));
    grid minor;
    xlabel('Time (hour)','FontWeight','bold');
    ylabel('Dissipation (Wat/m^2)','FontWeight','bold');
    title('Barotropic & Baroclinic & Total Dissipation','FontWeight','bold','fontsize',16);
    legend('Baroclinic Dissipation','Barotropic Dissipation','Total Dissipation');
    saveas(FIG,[num2str(CaseNumber),'-Dissipation.png']);
end

function EPPrimeCell=EPCalculator(X,ZC,Time,Density,RhoKnot,RhoB,Accuracy,g,SapeloFlag)
    
    if(SapeloFlag)
        c = parcluster('local');
        c.NumWorkers = 24;
        parpool(c, c.NumWorkers);%Assigning the number of wrokers on SAPELO
    else
        if isempty(gcp('nocreate'))
            parpool('local', 4);
        end
        CreatedParallelPool = parallel.pool.DataQueue;
        afterEach(CreatedParallelPool, @UpdateStatusDisp);
        ProgressStatus=0;
    end

    Z=linspace(ZC(1),ZC(end),Accuracy*size(ZC,1));
    ZStep=Z(1)-Z(2);
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
        if SapeloFlag
            sprintf('X=%f',i*100)
        else
            send(CreatedParallelPool,i);
        end
    end
    function UpdateStatusDisp(~)
        ProgressString=num2str(ProgressStatus/size(X,1)*100,'%2.2f');
        disp(strcat('Progress Percentage=',ProgressString))
        ProgressStatus= ProgressStatus + 1;
    end
end

function [DataTruncated,XTruncated]=DataXTruncator(Data,X)
    %This function reduce the resolution in X direction to save some space.
    %The high resolution was inforced by stability in SUNTANS.
    DataIndex=[];
    for i=1:size(X,1)
        if X(i)<5000
            continue;
        elseif (X(i)>5000 && X(i)<10000)
            if mod(X(i)-5000,100)~=10%make it each 100 meter
                DataIndex(end+1)=i;
            end
        else
            if mod(X(i)-10000,500)~=10%make it each 100 meter
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
