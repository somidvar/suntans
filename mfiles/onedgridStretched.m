%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% File name: onedgridStretched.m
% Description: This mfile provides one dimensional isoscele triangles grid
% with SUNTANS formatting of oned.dat
%
% Variables:
%	WestBoundary & EastBoundary: Boundary conditions based on the
%   SUNTANS guide (1 for closed and 2 for velocity-specified)
%	XOffset & YOffset: Grid offsets
%	DomainLength: Total domain length
%	L1: length of domain with maximum XStep
%	XReduction: Reduction in the XStep for a gradual transition from
%	StepMax to StepMin
%	StepMin: Minimum of XStep which is the most high resolution of the grid
%   AngleMax & AngleMin: Maximum and minimum of vertex angle for isoscele
%   triangles (we don't recommend going over 70 or lower 40 degrees)
%	W: Isoscele height based on the AngleMin 
%
% Sorush Omidvar
% University of Georgia
% Jan 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
clc;

fname = 'oned.dat';

% Boundary condition types
WestBoundary = 2;
EastBoundary = 1;

XOffset=0;
YOffset=0;
DomainLength=50000;
L1=35000;
XReduction=0.5;
StepMin=20;
AngleMax=70;
AngleMin=40;

W=tand((180-AngleMin)/2)*StepMin/2;
StepMax=round(2*W/tand((180-AngleMax)/2),1);
X1=-StepMax/2;
counter=1;
while X1(end)<DomainLength
    if X1(end)>L1
        XStep=max(StepMax-XReduction*counter,StepMin);
        counter=counter+1;
    else
        XStep=StepMax;
    end
    X1(end+1)=X1(end)+XStep;
end
X2=nan(1,size(X1,2)-1);
for counter=1:size(X2,2)
    X2(counter)=(X1(counter)+X1(counter+1))/2;
end
X=[X1,X2(end:-1:1)];
Y = [zeros(size(X2)),ones(size(X1))*W];
X=X+XOffset;
Y=Y+YOffset;
amin = StepMin*W*2;

N = length(X);
ofile = fopen(fname,'w');
fprintf(ofile,'%d\n',N);
for n=1:N,
  fprintf(ofile,'%f %f 0\n',X(n),Y(n));
end
fprintf(ofile,'%d\n',N);
for n=1:N-1,
  if(n==N/2)
    fprintf(ofile,'%d %d %d\n',n-1,n,EastBoundary);
  else
    fprintf(ofile,'%d %d 0\n',n-1,n);
  end
end
fprintf(ofile,'%d %d %d\n',N-1,0,WestBoundary);
fprintf(ofile,'0\n');
fprintf(ofile,'%f\n',amin);

fclose(ofile);


