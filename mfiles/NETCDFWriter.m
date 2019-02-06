%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% File name: NETCDFWriter.m
% Description: This mfile read non-NETCDF results (.dat) including X,Z,
% Time,U,W,q,Temperature and Density. Subsequently, it will write the
% variables in a NETCDF file with the specified address.
%
% NETCDFWriter(DataPathRead,DataPathWrite,ntout,Nkmax,XSize,
% TimeProcessStartIndex,TimeProcessEndIndex,TimeStr,XProcessStartIndex,
% XProcessEndIndex,XStr)
%
% Variables:
%	DataPathRead: The location of suntans dat files
%	DataPathWrite: The location of writing netcdf file
%	ntout: How often suntans write data
%	Nkmax: Maximum vertical layer
%	TimeProcessStartIndex: NETCDF start time index
%	TimeProcessEndIndex: NETCDF end time index
%   TimeStr: How often write Time in NETCDF (see ncread help)
%	XProcessStartIndex: NETCDF start X index
%	XProcessEndIndex: NETCDF end X index
%   XStr: How often write X in NETCDF (see ncread help)
%   TidalCycle: Number of tidal cycle from the end to process. If it is
%   zero, it will use the TimeProcessStartIndex and TimeProcessEndIndex
%   Omega: Wave frequency
% 
% Sorush Omidvar
% University of Georgia
% Jan 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function NETCDFWriter(DataPathRead,DataPathWrite,ntout,Nkmax,...
TimeProcessStartIndex,TimeProcessEndIndex,TimeStr,XProcessStartIndex,XProcessEndIndex,XStr,TidalCycle,Omega)

	[~,~,Time] = plotsliceMultiCore('Time',DataPathRead,ntout);
    if TidalCycle~=0
        TimeProcessEndIndex=size(Time,1);
        [~,TimeProcessStartIndex]=min(abs(Time(end)-2*pi/Omega*TidalCycle-Time));
    end
    Time=Time(TimeProcessStartIndex:TimeStr:TimeProcessEndIndex);

    Density=nan(size(XProcessStartIndex:XStr:XProcessEndIndex,2),Nkmax,size(Time,1));
    %U=nan(size(XProcessStartIndex:XStr:XProcessEndIndex,2),Nkmax,size(Time,1));
    W=nan(size(XProcessStartIndex:XStr:XProcessEndIndex,2),Nkmax,size(Time,1));
    %q=nan(size(XProcessStartIndex:XStr:XProcessEndIndex,2),Nkmax,size(Time,1));
    Eta=nan(size(XProcessStartIndex:XStr:XProcessEndIndex,2),size(Time,1));
    for k=1:size(Time,1)
        [~,~,Temp] = plotsliceMultiCore('h',DataPathRead,1+(k-1)*TimeStr+TimeProcessStartIndex);
        Eta(:,k)=Temp(XProcessStartIndex:XStr:XProcessEndIndex);
        [~,~,Temp] = plotsliceMultiCore('s',DataPathRead,1+(k-1)*TimeStr+TimeProcessStartIndex);
        Density(:,:,k)=Temp(:,XProcessStartIndex:XStr:XProcessEndIndex)';
        %[~,~,Temp] = plotsliceMultiCore('u',DataPathRead,1+(k-1)*TimeStr+TimeProcessStartIndex);
        %U(:,:,k)=Temp(:,XProcessStartIndex:XStr:XProcessEndIndex)';
        [X,Z,Temp] = plotsliceMultiCore('w',DataPathRead,1+(k-1)*TimeStr+TimeProcessStartIndex);
        W(:,:,k)=Temp(:,XProcessStartIndex:XStr:XProcessEndIndex)';
        %[X,Z,Temp] = plotsliceMultiCore('q',DataPathRead,1+(k-1)*TimeStr+TimeProcessStartIndex);
        %q(:,:,k)=Temp(:,XProcessStartIndex:XProcessEndIndex)';
        disp(strcat(num2str(100*k/size(Time,1)),'% succeeded'))
    end
	clear Temp;
    Density=Rho0+Rho0*Density;

	X=X(1,XProcessStartIndex:XStr:XProcessEndIndex);
	X=X';
	ZC=-squeeze(Z(:,1));%To compatiblize with NETCDF formatting

	ncid = netcdf.create(strcat(DataPathWrite,'example','.nc'),'64BIT_OFFSET');

	dimidX = netcdf.defDim(ncid,'XDim',size(X,1)); 
	dimidZC = netcdf.defDim(ncid,'ZCDim',size(ZC,1)); 
	dimidTime = netcdf.defDim(ncid,'TimeDim',size(Time,1)); 

	X_ID=netcdf.defVar(ncid,'xv','single',dimidX);
	Z_ID=netcdf.defVar(ncid,'z_r','single',dimidZC);
	Time_ID=netcdf.defVar(ncid,'time','single',dimidTime);

	Eta_ID = netcdf.defVar(ncid,'eta','single',[dimidX dimidTime]);
	U_ID = netcdf.defVar(ncid,'uc','single',[dimidX dimidZC dimidTime]);
	W_ID = netcdf.defVar(ncid,'w','single',[dimidX dimidZC dimidTime]);
	%q_ID = netcdf.defVar(ncid,'q','single',[dimidX dimidZC dimidTime]);
	Density_ID = netcdf.defVar(ncid,'rho','double',[dimidX dimidZC dimidTime]);

	netcdf.endDef(ncid);

	netcdf.putVar(ncid,X_ID,X); 
	netcdf.putVar(ncid,Z_ID,ZC); 
	netcdf.putVar(ncid,Time_ID,Time); 

	netcdf.putVar(ncid,Eta_ID,Eta); 
	netcdf.putVar(ncid,U_ID,U); 
	netcdf.putVar(ncid,W_ID,W); 
	%netcdf.putVar(ncid,q_ID,q); 
	netcdf.putVar(ncid,Density_ID,Density); 

	netcdf.close(ncid)