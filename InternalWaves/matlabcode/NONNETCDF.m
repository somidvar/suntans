close all;
clear all;
clc

OutPut=20;
ZSize=300;
XSize=200;
TimeSize=29864;
Salinity=nan(XSize,ZSize,floor(TimeSize/OutPut));
U=nan(XSize,ZSize,floor(TimeSize/OutPut));
W=nan(XSize,ZSize,floor(TimeSize/OutPut));
FreeSurface=nan(XSize,floor(TimeSize/OutPut));
[~,~,Time] = plotsliceMultiCore('Time','D:\VM\Test\iwaves\data',OutPut);
for k=1:floor(TimeSize/OutPut)
    [~,~,FreeSurface(:,k)] = plotsliceMultiCore('h','D:\VM\Test\iwaves\data',k);
    [~,~,Temp] = plotsliceMultiCore('s','D:\VM\Test\iwaves\data',k);
    Salinity(:,:,k)=Temp';
    [~,~,Temp] = plotsliceMultiCore('u','D:\VM\Test\iwaves\data',k);
    U(:,:,k)=Temp';
    [X,ZC,Temp] = plotsliceMultiCore('w','D:\VM\Test\iwaves\data',k);
    W(:,:,k)=Temp';
end

X=X';
ZC=ZC';
Density=Salinity*1000+1000;


