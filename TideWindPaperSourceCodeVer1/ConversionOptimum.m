clear;
close all;


for i=[110481:110481]
	clearvars -except i
	
	tic
	g=9.8;
	Rho0=1000;%Setting the reference density
	InterpRes=100;
	ntout=20;
	Nkmax=297;
	NETCDFWriter=0;

	Omega=2*pi/(12.4*3600);%M2 Tide
	%Omega=7.29347e-5;%K1 Tide
	TidalCycle=27;
	TimeStr=1;
	TimeProcessStartIndex=nan;
	TimeProcessEndIndex=nan;
	XProcessStartIndex=1;    
	XProcessEndIndex=3286;
	XStr=1;
	TimeStartIndex=1;
	CountTimeIndex=Inf;
	ZMaxIndex=Inf;

	DataPathRead=strcat('/scratch/omidvar/work-directory_0801/Paper2/suntans-triangular-',num2str(i),'/iwaves/data/')
	DataPathWrite='/scratch/omidvar/work-directory_0801/';
	
	if isfile(strcat(DataPathWrite,'Result-',num2str(i),'.mat'))
		continue;
	else 
		fid = fopen(strcat(DataPathWrite,'Result-',num2str(i),'.mat'),'w');
		fid=fclose(fid);
	end
	
	[U,V,W,Density,q,Eta,Time,X,ZC]=NONNETCDFReader(DataPathRead,...
		DataPathWrite,ntout,Nkmax,TimeProcessStartIndex,TimeProcessEndIndex,...
		TimeStr,XProcessStartIndex,XProcessEndIndex,XStr,TidalCycle,Omega,...
		NETCDFWriter,Rho0);

	disp('DATA reading is compeleted')

	Eta=movmean(Eta,2,1);
	Density=movmean(Density,2,1);
	U=movmean(U,2,1);
	V=movmean(V,2,1);
	W=movmean(W,2,1);
	q=movmean(q,2,1);

	XVector=[1:10:2251,2256:2:XProcessEndIndex];
	%XVector=[1:5:4200,4250:1:5000];

	X=X(XVector);
	Density=Density(XVector,:,:);
	U=U(XVector,:,:);
	V=V(XVector,:,:);
	W=W(XVector,:,:);
	q=q(XVector,:,:);
	Eta=Eta(XVector,:);

	RhoBConventional=trapz(Time,Density,3)/(Time(end)-Time(1));
	RhoBConventional=repmat(RhoBConventional,1,1,size(Time,1));

	DPlusZ=permute(repmat(ZC,1,size(X,1),size(Time,1)),[2,1,3])+W*0;
	Depth=nanmin(DPlusZ,[],2);
	DPlusZ=DPlusZ-repmat(Depth,1,size(ZC,1),1);

	UBar=U;
	UBar(isnan(UBar))=0;
	UBar=repmat(trapz(-ZC,UBar,2),1,size(ZC,1),1);
	UBar=UBar./-repmat(Depth,1,size(ZC,1),1);
	UBar=UBar+0*W;
	WBar=-diff(DPlusZ.*UBar,1,1)./repmat(diff(X,1,1),1,size(ZC,1),size(Time,1));
	WBar(end+1,:,:)=WBar(end,:,:);

	clear DPlusZ Depth;

	RhoPrimeConventional=Density-RhoBConventional;
	ConversionConventionalWBar=g*RhoPrimeConventional.*WBar;  

	ConversionConventionalTimeAvrWBar=trapz(Time,ConversionConventionalWBar,3)/(Time(end)-Time(1));

	ConversionConventionalTimeAvrDepthIntWBar=ConversionConventionalTimeAvrWBar;
	ConversionConventionalTimeAvrDepthIntWBar(isnan(ConversionConventionalTimeAvrDepthIntWBar))=0;
	ConversionConventionalTimeAvrDepthIntWBar=trapz(-ZC,ConversionConventionalTimeAvrDepthIntWBar,2);

	ConversionConventionalWBar=single(ConversionConventionalWBar);
	ConversionConventionalTimeAvrWBar=single(ConversionConventionalTimeAvrWBar);
	ConversionConventionalTimeAvrDepthIntWBar=single(ConversionConventionalTimeAvrDepthIntWBar);
	Density=single(Density);
	Eta=single(Eta);
	q=single(q);
	RhoBConventional=single(RhoBConventional);
	RhoPrimeConventional=single(RhoPrimeConventional);
	U=single(U);
	V=single(V);
	W=single(W);
	WBar=single(WBar);

	if ~contains(DataPathRead,'work-directory_0801')
		save('D:\Result.mat','-v7.3');
	else
		TempAddress=strfind(DataPathRead,'-');
		save(strcat(DataPathWrite,'Result-',DataPathRead(TempAddress(3)+1:TempAddress(3)+6),'.mat'),'-v7.3');
	end
	toc
end


function [U,V,W,Density,q,Eta,Time,X,ZC]=NONNETCDFReader(DataPathRead,...
    DataPathWrite,ntout,Nkmax,TimeProcessStartIndex,TimeProcessEndIndex,...
    TimeStr,XProcessStartIndex,XProcessEndIndex,XStr,TidalCycle,Omega,...
    NETCDFWriter,Rho0)
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
%   NETCDFWriter: 1 for writing data in a NETCDF
%   Rho0: Reference density 
%
% Sorush Omidvar
% University of Georgia
% Jan 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	[~,~,Time] = plotsliceMultiCore('Time',DataPathRead,ntout,nan);
    if TidalCycle~=0
        TimeProcessEndIndex=size(Time,1);
        [~,TimeProcessStartIndex]=min(abs(Time(end)-2*pi/Omega*TidalCycle-Time));
    end

    Time=Time(TimeProcessStartIndex:TimeStr:TimeProcessEndIndex);

	[~,~,UTotal] = plotsliceMultiCore('u',DataPathRead,1+TimeProcessStartIndex,size(Time,1));
	UTotal=UTotal(XProcessStartIndex:XStr:XProcessEndIndex,:,:,:);
	U=squeeze(UTotal(:,:,1,:));
	V=squeeze(UTotal(:,:,2,:));
	W=squeeze(UTotal(:,:,3,:));
	disp('Reading Velocity is succeeded')
	clear UTotal;

	[~,~,Eta] = plotsliceMultiCore('h',DataPathRead,1+TimeProcessStartIndex,size(Time,1));
	Eta=Eta(XProcessStartIndex:XStr:XProcessEndIndex,:);
	disp('Reading Eta is succeeded')
	
	[~,~,Density] = plotsliceMultiCore('s',DataPathRead,1+TimeProcessStartIndex,size(Time,1));
	Density=Rho0*Density;
	Density=Density(XProcessStartIndex:XStr:XProcessEndIndex,:,:);
	disp('Reading Density is succeeded')

	[X,Z,q] = plotsliceMultiCore('q',DataPathRead,1+TimeProcessStartIndex,size(Time,1));
	q=q(XProcessStartIndex:XStr:XProcessEndIndex,:,:);
	disp('Reading q is succeeded')

	X=X(1,XProcessStartIndex:XStr:XProcessEndIndex);
	X=X';
	ZC=squeeze(Z(:,1));%To compatiblize with NETCDF formatting
end



function [x,z,data] = plotsliceMultiCore(PLOT,datadir,n,TimeSize)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% File name: plotsliceMultiCore.m
% Description: This is an amendment to plotslice for the multicore cases.
% Also the time can be obtained through 'Time' in which n is the output value set
% in suntans.dat
% [x,z,data]=plotsliceMulti(plottype,dirname,timestep);
% 
% plottype: 
%    'q': nonhydrostatic pressure
%    's': salinity
%    'u': u-velocity
%    'w': w-velocity
%    's0': background salinity
%    'h': free surface
%    'nut': eddy-viscosity
%    'kappat': scalar-diffusivity
%    'Time': Time 
%
%
% Sorush Omidvar
% University of Georgia
% Jan 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  EMPTY=999999;         % Empty cells are defined by this
  precision='float64';  % Precision for reading in data
  
  % cellcentered data contains the voronoi points and the depths
  % at those points.
  fid=strcat(datadir,'cells.dat');
  fileID = fopen(fid,'r');
  cellcentereddata=fscanf(fileID,'%f %f %d %d %d %d %d %d');
  fclose(fileID);
  for counter=1:size(cellcentereddata,1)/8
      xv(counter) = cellcentereddata(1+(counter-1)*8);
      yv(counter) = cellcentereddata(2+(counter-1)*8);
  end
  dz = load([datadir,'vertspace.dat']);
  
  % Total number of cells in the horizontal Nc and vertical Nk
  Nc = length(xv);
  Nk = length(dz);
  
  % Length and depth of domain
  L = max(xv);
  
  % Set up the Cartesian grid
  z = -cumsum(dz);
  [xs,is]=sort(xv);
  [x,z]=meshgrid(xs,z);

  % Open up file descriptors for binary files
  switch(PLOT)
   case 'q'
    file = [datadir,'q.dat'];
   case 's'
    file = [datadir,'s.dat'];    
   case 'T'
    file = [datadir,'T.dat'];    
   case {'u','w'}
    file = [datadir,'u.dat'];    
   case 's0'
    file = [datadir,'s0.dat'];    
   case 'h'
    file = [datadir,'fs.dat'];    
   case 'nut'
    file = [datadir,'nut.dat'];    
   case 'kappat'
    file = [datadir,'kappat.dat'];    
   case 'Time'
    file = [datadir,'e.dat'];    
   otherwise
    fprintf('Unrecognized plot variable.\n');
    fprintf('Use one of ''q'',''s'',''u'',''w'',''s0'',''h'',''nut'',''kappat''.\n');
    data=zeros(Nc,Nk,TimeSize);
    return;
  end

  fid = fopen(file,'rb');

  switch(PLOT)
   case {'u','v','w'}
    data = reshape(getcdata(fid,Nk*3*Nc,n,precision,TimeSize),Nc,Nk,3,TimeSize);
    data = data(is,:,:,:);
    data(find(data==EMPTY))=nan;
   case 'h'
    data = reshape(getcdata(fid,Nc,n,precision,TimeSize),Nc,TimeSize);
    data = data(is,:);
    data(data==EMPTY)=nan;
   case 'Time'
      data=fscanf(fid,'%f %f %f %f %f %f %f %f');
      data=data(1:8:end);
      data=data(1:n:end);
      if(mod(n,size(data,1))~=0)
          data(end)=[];
      end
   otherwise
    data = reshape(getcdata(fid,Nc*Nk,n,precision,TimeSize),Nc,Nk,TimeSize);
    data = data(is,:,:);
    data(find(data==EMPTY))=nan;
  end
  fclose(fid);
end


function data = getcdata(fid, arraysize, step, precision,TimeSize)

%
% GETCDATA
% DATA = GETCDATA(FID,ARRAYSIZE,STEP,PRECISION);
%   extracts binary data from the specified file descriptor.  As
%   an example, if a file contains double precision arrays of length
%   N=10, the n=10th array is extracted with:
%   
%   data = getcdata(fid,N,n,'float64');
%
% Oliver Fringer
% Stanford University
% 27 July 05
%
  tic;
  if(fid>0),
    if(precision=='float32')
      space = 4*arraysize;                    
    elseif(precision=='float64')
      space = 8*arraysize;
    end

    frewind(fid);
    fseek(fid,(step-1)*space,0);
    data = fread(fid,arraysize*TimeSize,precision);
  else
    fprintf('Error in function: getdata...undefined fid\n');
    data = zeros(arraysize,1);
  end
  
  fprintf('Read data at a rate of %.2f Mb/sec\n',space*TimeSize/1e6/toc);
end