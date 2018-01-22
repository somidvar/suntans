clear all;
close all;
clc


X=0:10:80000;
Bathymetry=nan(size(X,2),1);
ABath = 800;
BBath = 0.0009;
CBath = 22000;
DBath = 350;
for i=1:size(X,2)
    if(X(i)>20000)
        Bathymetry(i)=ABath*(tanh(0.1*(-BBath*(-X(i) + CBath)))) + DBath;		
    else
        Bathymetry(i)=200;
    end
end
plot(X,-Bathymetry);