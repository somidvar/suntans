clear all
close all
clc

dirname = 'C:\Users\omidvar\Desktop';
EMPTY = 999999;

fname = [dirname,'\profdata.dat'];

% fid = fopen(fname,'rb');
% numTotalDataPoints = fread(fid,1,'int32');
% numInterpPoints = fread(fid,1,'int32');
% Nkmax = fread(fid,1,'int32');
% nsteps = fread(fid,1,'int32');
% ntoutProfs = fread(fid,1,'int32');  
% dt = fread(fid,1,'float64');
% dz = fread(fid,Nkmax,'float64');
% dataIndices = fread(fid,numTotalDataPoints,'int32');
% dataXY = fread(fid,2*numTotalDataPoints,'float64');
% xv = reshape(fread(fid,numInterpPoints*numTotalDataPoints,'float64'),numInterpPoints,numTotalDataPoints);
% yv = reshape(fread(fid,numInterpPoints*numTotalDataPoints,'float64'),numInterpPoints,numTotalDataPoints);
% fclose(fid);
% 
% dataX = dataXY(1:2:end);
% dataY = dataXY(2:2:end);
% 
% z = getz(dz);
% 
% data = fread(fopen([dirname,'\u.dat.prof'],'rb'),'float64');
% data(find(data==EMPTY))=nan;
% fclose(fid);
% 
% nout = length(data)/(3*Nkmax*numInterpPoints*numTotalDataPoints);
% udata = reshape(data,Nkmax,numInterpPoints,numTotalDataPoints,3,nout);
% udata = squeeze(udata);
% 
% Time = ones(Nkmax,1)*[1:nout]*dt*ntoutProfs;
% Z = z*ones(1,nout);
% Tday = 86400;
% ZC=z;
% 
% U = squeeze(udata(:,:,1,:));
% V = squeeze(udata(:,:,2,:));
% W = squeeze(udata(:,:,3,:));
% Time=Time(1,:)';


FS = fread(fopen([dirname,'\fs.dat'],'rb'),'float64');
fclose(fid);
Eta=nan(1000,120);
for counter=1:1000
    Eta(counter,:)=FS(counter:1000:120000);
end

% 

HTotal=repmat(ZC,1,76);
HTotal=HTotal+U(:,:,1)*0;
HTotalDiff=diff(HTotal,1,1);
HTotalDiff(end+1,:)=HTotalDiff(end,:);
UH=U.*repmat(HTotalDiff,1,1,size(Time,1));
UH=squeeze(nansum(UH,1));
Depth=abs(nanmin(HTotal,[],1))';
Depth=repmat(Depth,1,600);
UH=UH./Depth;
pcolor(Time/3600,dataX/1000,UH);
shading flat;
colorbar;


figure;
for k=1:size(Time,1)
    pcolor(dataX/1000,ZC,U(:,:,k));
    colorbar;  
    caxis([-0.05 0.05]);
    ylabel('Depth (m)');
    xlabel('distance (km)');
    shading flat;
    title(strcat('U velocity (m/s) in Time=',num2str(Time(k)/3600,'%2.1f\n')));
    pause(0.1);
end



function z = getz(dz)
  
  N = length(dz);
  dzh = 0.5*(dz(1:end-1)+dz(2:end));
  
  z = zeros(N,1);
  z(1) = -dz(1)/2;
  z(2:N) = z(1)-cumsum(dzh);
end