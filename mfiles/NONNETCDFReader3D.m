%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% File name: NONNETCDFReader3D.m
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
%	Rho0: Reference density
%	SkipFreq: How often to read the data
%	PeriodNumber: The last PeriodNumber of the data will be read
%	RemovalIndex: In order to make a structured grid for pcolor, we have to delet half of the data, you can disable it if you don't want such option
%	NT: Number of temporal steps
%	LoweringResolution: Lowering the resolution based on X
%
% Sorush Omidvar
% University of Georgia
% Sep 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear all;
clc

DataPathRead='/scratch/omidvar/work-directory_0801/IdealRidge/iwaves/data/';
Rho0=1000;
SkipFreq=1;
PeriodNumber=3;
[XV,YV,Z,XP,YP,NC,NK,TriangulationData,Time,ntout] = DataReaderAuxilary3D(DataPathRead);

NewX=sort(unique(XV));
NewX=NewX(2:2:end-1);
RemovalIndex=[];
for counter=1:size(XV,1)
    if isempty(find(NewX==XV(counter)))
        RemovalIndex(end+1)=counter;
    end
end
XV(RemovalIndex)=[];
YV(RemovalIndex)=[];

NT=size(Time,1);
LoweringResolution=[];
Temp2=length(unique(XV));
for counter=1:size(XV,1)
    Temp=mod(counter,Temp2);
    if(XV(counter)<200e3 || XV(counter)>400e3)
        if (mod(Temp,5)~=0)
            LoweringResolution(end+1)=counter;
        end
    end
end
XV(LoweringResolution)=[];
YV(LoweringResolution)=[];

X=unique(XV);
Y=unique(YV,'stable');
[Y,SortedYIndex]=sort(Y);
Time=Time(NT-149*PeriodNumber:SkipFreq:NT);

disp('Starting NETCDF writing')
if exist('IdleRidgeInfo.nc')~=0
	delete('IdleRidgeInfo.nc');
end
ncid = netcdf.create('IdleRidgeInfo.nc','NETCDF4');

dimidX = netcdf.defDim(ncid,'XDim',size(X,1)); 
dimidY = netcdf.defDim(ncid,'YDim',size(Y,1)); 
dimidZ = netcdf.defDim(ncid,'ZDim',size(Z,1)); 
dimidTime = netcdf.defDim(ncid,'TimeDim',size(Time,1)); 

X_ID=netcdf.defVar(ncid,'X','float',dimidX);
Y_ID=netcdf.defVar(ncid,'Y','float',dimidY);
Z_ID=netcdf.defVar(ncid,'Z','float',dimidZ);
Time_ID=netcdf.defVar(ncid,'Time','float',dimidTime);
U_ID = netcdf.defVar(ncid,'U','float',[dimidX dimidY dimidZ dimidTime]);
V_ID = netcdf.defVar(ncid,'V','float',[dimidX dimidY dimidZ dimidTime]);
W_ID = netcdf.defVar(ncid,'W','float',[dimidX dimidY dimidZ dimidTime]);
Density_ID = netcdf.defVar(ncid,'Density','float',[dimidX dimidY dimidZ dimidTime]);
q_ID = netcdf.defVar(ncid,'q','float',[dimidX dimidY dimidZ dimidTime]);
Eta_ID = netcdf.defVar(ncid,'Eta','float',[dimidX dimidY dimidTime]);
netcdf.endDef(ncid);

netcdf.putVar(ncid,X_ID,X); 
netcdf.putVar(ncid,Y_ID,Y); 
netcdf.putVar(ncid,Z_ID,Z); 
netcdf.putVar(ncid,Time_ID,Time); 

disp('Reading U')
U=DataReader('u',DataPathRead,NC,NK,NT,SkipFreq,PeriodNumber,XV,X,Y,SortedYIndex,RemovalIndex,LoweringResolution);
disp('Writing U')
netcdf.putVar(ncid,U_ID,U); 
clear U;

disp('Reading V')
V=DataReader('v',DataPathRead,NC,NK,NT,SkipFreq,PeriodNumber,XV,X,Y,SortedYIndex,RemovalIndex,LoweringResolution);
disp('Writing V')
netcdf.putVar(ncid,V_ID,V); 
clear V;

disp('Reading W')
W=DataReader('w',DataPathRead,NC,NK,NT,SkipFreq,PeriodNumber,XV,X,Y,SortedYIndex,RemovalIndex,LoweringResolution);
disp('Writing W')
netcdf.putVar(ncid,W_ID,W); 
clear W;

disp('Reading Density')
Density=Rho0*DataReader('s',DataPathRead,NC,NK,NT,SkipFreq,PeriodNumber,XV,X,Y,SortedYIndex,RemovalIndex,LoweringResolution);
disp('Writing Density')
netcdf.putVar(ncid,Density_ID,Density); 
clear Density;

disp('Reading q')
q=DataReader('q',DataPathRead,NC,NK,NT,SkipFreq,PeriodNumber,XV,X,Y,SortedYIndex,RemovalIndex,LoweringResolution);
disp('Writing q')
netcdf.putVar(ncid,q_ID,q); 
clear q;

disp('Reading Eta')
Eta=DataReader('h',DataPathRead,NC,NK,NT,SkipFreq,PeriodNumber,XV,X,Y,SortedYIndex,RemovalIndex,LoweringResolution);
disp('Writing Eta')
netcdf.putVar(ncid,Eta_ID,Eta);
clear Eta;

netcdf.close(ncid);

function Data= DataReader(Parameter,DataPathRead,NC,NK,NT,SkipFreq,PeriodNumber,XV,X,Y,SortedYIndex,RemovalIndex,LoweringResolution)
	Iteration=NT-149*PeriodNumber:SkipFreq:NT;
	IterationNumber=length(Iteration);
	
	if (Parameter=='h')
		Data=nan(length(XV),IterationNumber);
		ProgressCounter=1;
		for k=Iteration
			Temp = DataReader3D(Parameter,DataPathRead,k,NC,NK);
			Temp=single(Temp);
			Temp(RemovalIndex)=[];
			Temp(LoweringResolution)=[];
			Data(:,k-Iteration(1)+1)=Temp;  
			%if mod(k,7)==0
				disp(strcat('Progress=',num2str(ProgressCounter/IterationNumber*100),' %'))
			%end
			ProgressCounter=ProgressCounter+1;
		end	
		disp(strcat('Reformatting of',{' '},Parameter))
		Data=reshape(Data,[size(X,1),size(Y,1),size(Data,2)]);
		Data=Data(:,SortedYIndex,:);
		Data=Data(:,:,1:SkipFreq:end);
	else
		Data=nan(length(XV),NK,IterationNumber);
		disp(strcat('Reading of',{' '},Parameter))
		ProgressCounter=1;
		for k=Iteration
			Temp = DataReader3D(Parameter,DataPathRead,k,NC,NK);
			Temp=single(Temp');
			Temp(RemovalIndex,:)=[];
			Temp(LoweringResolution,:)=[];
			Data(:,:,k-Iteration(1)+1)=Temp;
			%if mod(k,7)==0
				disp(strcat('Progress=',num2str(ProgressCounter/IterationNumber*100),' %'))
			%end
			ProgressCounter=ProgressCounter+1;
		end
		disp(strcat('Reformatting of',{' '},Parameter))
		Data=reshape(Data,[size(X,1),size(Y,1),NK,size(Data,3)]);
		Data=Data(:,SortedYIndex,:,:);
		Data=Data(:,:,:,1:SkipFreq:end);
	end
end

function [data] = DataReader3D(Parameter,datadir,TimeStamp,Nc,Nk)

	EMPTY=999999;         % Empty cells are defined by this
	precision='float64';  % Precision for reading in data
    
	% Open up file descriptors for binary files
	switch(Parameter)
		case 'q'
		file = [datadir,'q.dat'];
		case 's'
		file = [datadir,'s.dat'];    
		case 'T'
		file = [datadir,'T.dat'];    
		case {'u','v','w'}
		file = [datadir,'u.dat'];    
		case 's0'
		file = [datadir,'s0.dat'];    
		case 'h'
		file = [datadir,'fs.dat'];    
		case 'nut'
		file = [datadir,'nut.dat'];    
		case 'kappat'
		file = [datadir,'kappat.dat']; 
		otherwise
		fprintf('Unrecognized plot variable.\n');
		fprintf('Use one of ''q'',''s'',''u'',''v'',''w'',''s0'',''h'',''nut'',''kappat''.\n');
		data=zeros(Nk,Nc);
		return;
	end
	fid = fopen(file,'r');
	switch(Parameter)
		case {'u','v','w'}
		data = reshape(getcdata(fid,Nk*3*Nc,TimeStamp,precision),Nc,Nk,3);
		if(Parameter=='u')
		data = squeeze(data(:,:,1));
		elseif(Parameter=='v')
		data = squeeze(data(:,:,2));      
		else
		data = squeeze(data(:,:,3));      
		end
		data = data(:,:)';
		data(find(data==EMPTY))=nan;
		case 'h'
		data = getcdata(fid,Nc,TimeStamp,precision);
		data = data(:);
		data(data==EMPTY)=nan;
		otherwise
		data = reshape(getcdata(fid,Nc*Nk,TimeStamp,precision),Nc,Nk);
		data = data(:,:)';
		data(find(data==EMPTY))=nan;
	end
	fclose(fid);
end
function data = getcdata(fid, arraysize, step, precision)
	tic;
	if(fid>0),
		if(precision=='float32'),
			space = 4*arraysize;                    
		elseif(precision=='float64')
			space = 8*arraysize;
		end

		frewind(fid);
		fseek(fid,(step-1)*space,0);
		data = fread(fid,arraysize,precision);
	else
		fprintf('Error in function: getdata...undefined fid\n');
		data = zeros(arraysize,1);
	end
	fprintf('Read data at a rate of %.2f Mb/sec\n',space/1e6/toc);
end

function [XV,YV,Z,XP,YP,NC,NK,TriangulationData,Time,ntout] = DataReaderAuxilary3D(datadir)
    fid = fopen(strcat(datadir,'suntans.dat'));
    tline = fgetl(fid);
    while ischar(tline)
        if contains(tline,'ntout')
            temp1=strfind(tline,' ');
            temp1=temp1(1);
            temp2=strfind(tline,'#');
            if (temp1<=0 || temp2<=1)
                disp('Error in suntans.dat')
                return;
            end
            tline=tline(temp1:temp2-1);
            ntout=str2double(tline);
        end    
        tline = fgetl(fid);
    end
    fclose(fid);
	% cellcentered data contains the voronoi points and the depths
	% at those points.
	fid=strcat(datadir,'cells.dat');
	fileID = fopen(fid,'r');
	cellcentereddata=fscanf(fileID,'%f %f %d %d %d %d %d %d');
	fclose(fileID);
    XV=nan(length(cellcentereddata)/8,1);
    YV=nan(length(cellcentereddata)/8,1);
    TriangulationData=nan(length(cellcentereddata)/8,3);
	for counter=1:size(cellcentereddata,1)/8
		XV(counter) = cellcentereddata(1+(counter-1)*8);
		YV(counter) = cellcentereddata(2+(counter-1)*8);
        TriangulationData(counter,:)=cellcentereddata(3+(counter-1)*8:5+(counter-1)*8);
    end
    TriangulationData=TriangulationData+1;%Conveting SUNTANS format to MATLAB format
    
	fid=strcat(datadir,'points.dat');
	fileID = fopen(fid,'r');
	PointData=fscanf(fileID,'%f %f %d');
    XP=nan(length(PointData)/3,1);
    YP=nan(length(PointData)/3,1);
	fclose(fileID);
	for counter=1:length(PointData)/3
		XP(counter) = PointData(1+(counter-1)*3);
		YP(counter) = PointData(2+(counter-1)*3);
    end
    %Depth of each layer stored in z
	dz = load([datadir,'vertspace.dat']);
    Z = -cumsum(dz);
    
	% Total number of cells in the horizontal Nc and vertical Nk
	NC = length(XV);
	NK = length(Z);
    %Reading time
    file = [datadir,'e.dat'];
	fid = fopen(file,'r');
    Time=fscanf(fid,'%f %f %f %f %f %f %f %f');
    fclose(fid);
    Time=Time(1:8:end);
    %Picking the ntout and adding the last time step
    Temp=Time(end);
    Time=Time(1:ntout:end);
end