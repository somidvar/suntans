%Finding the amplitude at different depth from z=ZC(1) to ZC(SpecificZ)
%and x=X(1) to X(SpecificX)
format compact;
clear all
close all
clc

tic

XLimit=50;% We just want to see the waves at this offshore distance
ZLimit=100; %After this depth the data are nan
InterpolationMagnification=10;
InputNETCDF='F:\6th\suntans-6th-10028\InternalWaves\data\Result_0000.nc';
Density=1000*ncread(InputNETCDF,'rho',[1,1,1],[XLimit,ZLimit,Inf])+1000;
X=ncread(InputNETCDF,'xv',1,XLimit);
Time=ncread(InputNETCDF,'time');
ZC=-ncread(InputNETCDF,'z_r',1,ZLimit);
%Depth Interpolation
ZCInterp=ZC(1);
for j=1:size(ZC)-1
    ZCInterp(end:end+9)=linspace(ZC(j),ZC(j+1),InterpolationMagnification);
end
ZCInterp=ZCInterp';
%Density matrix interpolation
[TempX,TempZC,TempTime]=meshgrid(ZC,X,Time);
[TempXInterp,TempZCInterp,TempTimeInterp]=meshgrid(ZCInterp,X,Time);
DensityInterp=interp3(TempX,TempZC,TempTime,Density,TempXInterp,TempZCInterp,TempTimeInterp);%I did not use spline because it does not work with NAN and add some complexity to the algorithem
clear TempX TempZC TempTime TempXInterp TempZCInterp TempTimeInterp
%finding the depth at which the density is closeset to the initial value
DensityReference=squeeze(Density(:,:,1));
IsoDensityDepth=nan(size(X,1),size(ZC,1),size(Time,1));
for i=1:size(X,1)
    for k=1:size(Time,1)
        for j=1:size(ZC,1)
            if(isnan(DensityInterp(i,j,k)))
                continue;
            end
            DensityVariation=DensityInterp(i,:,k)-DensityReference(i,j);
            DensityVariation=abs(DensityVariation);
            [~, MinIndex]=min(DensityVariation);
            IsoDensityDepth(i,j,k)=ZCInterp(MinIndex);
        end
    end
end
%Finding the amplitude of waves at each depth
Amplitude=nan(size(X,1),size(ZC,1));
for i=1:size(X,1)
    for j=1:size(ZC,1)
        Amplitude(i,j)=max(IsoDensityDepth(i,j,:))-min(IsoDensityDepth(i,j,:));
    end
end
Amplitude(Amplitude==0)=nan;
[XTemp, ZTemp]=meshgrid(ZC,X);
pcolor(XTemp,ZTemp,Amplitude);
xlabel('Depth (m)');
ylabel('Off-shore distance(m)');
title('Wave Amplitude (m)');
shading flat;
colorbar;
camorbit(90,180);
set(gca,'XAxisLocation','top');
set(gca,'YAxisLocation','right');


toc
