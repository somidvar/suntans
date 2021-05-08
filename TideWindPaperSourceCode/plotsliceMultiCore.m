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
function [x,z,data] = plotsliceMultiCore(PLOT,datadir,n)

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
    data=zeros(Nk,Nc);
    return;
  end

  fid = fopen(file,'rb');

  switch(PLOT)
   case {'u','w'}
    data = reshape(getcdata(fid,Nk*3*Nc,n,precision),Nc,Nk,3);
    if(PLOT=='u')
      data = squeeze(data(:,:,1));
    else
      data = squeeze(data(:,:,3));      
    end
    data = data(is,:)';
    data(find(data==EMPTY))=nan;
   case 'h'
    data = getcdata(fid,Nc,n,precision);
    data = data(is);
    data(data==EMPTY)=nan;
   case 'Time'
      data=fscanf(fid,'%f %f %f %f %f %f %f %f');
      data=data(1:8:end);
      data=data(1:n:end);
      if(mod(n,size(data,1))~=0)
          data(end)=[];
      end
   otherwise
    data = reshape(getcdata(fid,Nc*Nk,n,precision),Nc,Nk);
    data = data(is,:)';
    data(find(data==EMPTY))=nan;
  end
  fclose(fid);
end
