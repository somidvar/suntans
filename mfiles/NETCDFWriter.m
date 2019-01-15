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
%	XSize: Number of Cells in X direction
%	TimeProcessStartIndex: NETCDF start time index
%	TimeProcessEndIndex: NETCDF end time index
%   TimeStr: How often write Time in NETCDF (see ncread help)
%	XProcessStartIndex: NETCDF start X index
%	XProcessEndIndex: NETCDF end X index
%   XStr: How often write X in NETCDF (see ncread help)
% 
% Sorush Omidvar
% University of Georgia
% Jan 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function NETCDFWriter(DataPathRead,DataPathWrite,ntout,Nkmax,XSize,...
TimeProcessStartIndex,TimeProcessEndIndex,TimeStr,XProcessStartIndex,XProcessEndIndex,XStr)

	[~,~,Time] = plotsliceMultiCore('Time',DataPathRead,ntout);
	Time=Time(TimeProcessStartIndex:TimeProcessEndIndex);

	Salinity=nan(XSize,Nkmax,size(Time,1));
	U=nan(XSize,Nkmax,size(Time,1));
	W=nan(XSize,Nkmax,size(Time,1));
	q=nan(XSize,Nkmax,size(Time,1));
	Eta=nan(XSize,size(Time,1));
	for k=1:size(Time,1)
		[~,~,Eta(:,k)] = plotsliceMultiCore('h',DataPathRead,k+TimeProcessStartIndex);
		[~,~,Temp] = plotsliceMultiCore('s',DataPathRead,k+TimeProcessStartIndex);
		Salinity(:,:,k)=Temp';
		[~,~,Temp] = plotsliceMultiCore('u',DataPathRead,k+TimeProcessStartIndex);
		U(:,:,k)=Temp';  
		[~,~,Temp] = plotsliceMultiCore('w',DataPathRead,k+TimeProcessStartIndex);
		W(:,:,k)=Temp';
		[X,Z,Temp] = plotsliceMultiCore('q',DataPathRead,k+TimeProcessStartIndex);
		q(:,:,k)=Temp';
	end
	clear Temp;
	Density=Salinity;
	clear Salinity;

	X=X(1,XProcessStartIndex:XStr:XProcessEndIndex);
	X=X';
	Z=-squeeze(Z(:,1));%To compatiblize with NETCDF formatting
	Time=Time(1:TimeStr:end);
	Eta=Eta(XProcessStartIndex:XStr:XProcessEndIndex,1:TimeStr:end);
	U=U(XProcessStartIndex:XStr:XProcessEndIndex,:,1:TimeStr:end);
	W=W(XProcessStartIndex:XStr:XProcessEndIndex,:,1:TimeStr:end);
	q=q(XProcessStartIndex:XStr:XProcessEndIndex,:,1:TimeStr:end);
	Density=Density(XProcessStartIndex:XStr:XProcessEndIndex,:,1:TimeStr:end);

	ncid = netcdf.create(strcat(DataPathWrite,'example','.nc'),'64BIT_OFFSET');

	dimidX = netcdf.defDim(ncid,'XDim',size(X,1)); 
	dimidZC = netcdf.defDim(ncid,'ZCDim',size(Z,1)); 
	dimidTime = netcdf.defDim(ncid,'TimeDim',size(Time,1)); 

	X_ID=netcdf.defVar(ncid,'xv','double',dimidX);
	Z_ID=netcdf.defVar(ncid,'z_r','double',dimidZC);
	Time_ID=netcdf.defVar(ncid,'time','double',dimidTime);

	Eta_ID = netcdf.defVar(ncid,'eta','double',[dimidX dimidTime]);
	U_ID = netcdf.defVar(ncid,'uc','double',[dimidX dimidZC dimidTime]);
	W_ID = netcdf.defVar(ncid,'w','double',[dimidX dimidZC dimidTime]);
	q_ID = netcdf.defVar(ncid,'q','double',[dimidX dimidZC dimidTime]);
	Density_ID = netcdf.defVar(ncid,'rho','double',[dimidX dimidZC dimidTime]);

	netcdf.endDef(ncid);

	netcdf.putVar(ncid,X_ID,X); 
	netcdf.putVar(ncid,Z_ID,Z); 
	netcdf.putVar(ncid,Time_ID,Time); 

	netcdf.putVar(ncid,Eta_ID,Eta); 
	netcdf.putVar(ncid,U_ID,U); 
	netcdf.putVar(ncid,W_ID,W); 
	netcdf.putVar(ncid,q_ID,q); 
	netcdf.putVar(ncid,Density_ID,Density); 

	netcdf.close(ncid)