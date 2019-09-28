%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% File name: NETCDFWriter.m
% Description: This mfile provides a stretched two-d grid considering a
% maximum and minimum angle for the isocells.
%
%
% Variables:
%	FlagPlot: If you want to see the plot of the grid or not
%	FlagBathymetry: If you want to make the bathymetry file or not
%	FlagPointsCellEdgeFilesWriter: If you want to write the Point.dat,
%	Cells.dat,Edge.dat or not
%	FlagSUNTANSCompatibility: Suntans numbering starts from 0 while matlab
%   does not recognize such numbering 
%	DomainWidth: The width is in the Y direction
%	DomainLength: The length is in the X direction
%	MaxAngle: Maximum of the vertex angle
%	MinAngle: Minimum of the vertex angle
%	MinDelX: Finest resolution in X direction
%	MaxDelX: Coarse resolution will be calculated based on the vertex angle
%	range
%	GrowthRate: How fast does the grid size grow in X
%	NorthBoundary: Northern BC: 0:computational, 1:closed;
%	2:Velocity-specified, 3:Stage-specified
%	SouthBoundary: South BC: 0:computational, 1:closed;
%	2:Velocity-specified, 3:Stage-specified
%	WestBoundary: West BC: 0:computational, 1:closed;
%	2:Velocity-specified, 3:Stage-specified
%	EastBoundary: East BC: 0:computational, 1:closed;
%	2:Velocity-specified, 3:Stage-specified
%
%
% Sorush Omidvar
% University of Georgia
% Sep 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear all;
clc

FlagPlot=true;
FlagBathymetry=true;
FlagPointsCellEdgeFilesWriter=true;
FlagSUNTANSCompatibility=true;
DestinationAdd='d:\';

DomainLength=100;
DomainWidth=380;
MaxAngle=80;
MinAngle=50;
MinDelX=20;

MaxDelX=300*tand(MaxAngle)/tand(MinAngle);
GrowthRate=1.05;

NorthBoundary=1;
SouthBoundary=1;
WestBoundary=2;
EastBoundary=1;

X=0;
StepX=MinDelX;
while X(end)<DomainLength/2
    StepX=min([StepX*GrowthRate,MaxDelX]);
    X(end+1)=X(end)+StepX;
end
X=flip(DomainLength/2-X');
for counter=size(X,1)-1:-1:1
    X(end+1)=DomainLength/2-X(counter)+DomainLength/2;
end
NX=size(X,1);

DelY=tand(MaxAngle)*MinDelX/2;
Y=0:DelY:DomainWidth;
Y=Y';
if (mod(size(Y,1),2)==0)
    disp('Size of Y should be odd')
    return;
end
NY=size(Y,1);
MeanX=nan(size(X,1)-1,1);
for counter=1:size(X,1)-1
    MeanX(counter)=mean([X(counter),X(counter+1)]);
end

PointInfoX=[];
PointInfoY=[];
CellInfo=[];
for j=1:NY
    if mod(j,2)==1
        PointInfoX=[PointInfoX;X];
        PointInfoY=[PointInfoY;ones(size(X,1),1)*Y(j)];
    else 
        PointInfoX=[PointInfoX;MeanX];
        PointInfoY=[PointInfoY;ones(size(X,1)-1,1)*Y(j)];
    end
end
PointInfo=[PointInfoX,PointInfoY];

Temp=0;
for j=1:NY-1
    if mod(j,2)==1
        for i=1:size(X,1)-1
            CellInfo(end+1,:)=[Temp+i,Temp+i+1,Temp+size(X,1)+i];%Upside Triangles
        end
        Temp=Temp+size(X,1);
    else
        for i=1:size(X,1)-2
            CellInfo(end+1,:)=[Temp+i,Temp+i+1,Temp+size(X,1)+i];%Upside Triangles
        end
        Temp=Temp+size(X,1)-1;
    end
end
Temp=size(X,1);
for j=1:NY-1
    if mod(j,2)==1
        for i=1:size(X,1)-2
            CellInfo(end+1,:)=[Temp+i,Temp+i+1,Temp-size(X,1)+i+1];%Downside Triangles
        end
        Temp=Temp+size(X,1)-1;
    else
        for i=1:size(X,1)-1
            CellInfo(end+1,:)=[Temp+i,Temp+i+1,Temp-size(X,1)+i+1];%Downside Triangles
        end        
        Temp=Temp+size(X,1);
    end
end
if NY>3
    SideTriangles=(NY-3)/2+1;
elseif NY==3
    SideTriangles=1;
end
for counter=1:SideTriangles
    CellInfo(end+1,:)=[(counter-1)*(2*size(X,1)-1)+1,(counter-1)*(2*size(X,1)-1)+1+size(X,1),(counter-1)*(2*size(X,1)-1)+1+2*size(X,1)-1]; %The left side triangles
end
for counter=1:SideTriangles
    CellInfo(end+1,:)=[(counter-1)*(2*size(X,1)-1)+1+size(X,1)-1,(counter-1)*(2*size(X,1)-1)+1+2*size(X,1)-2,(counter-1)*(2*size(X,1)-1)+1+2*size(X,1)-1+size(X,1)-1]; %The right side triangles
end
for counter=1:size(CellInfo,1)
    CellInfo(counter,4)=mean([PointInfo(CellInfo(counter,1),1),PointInfo(CellInfo(counter,2),1),PointInfo(CellInfo(counter,3),1)]);
    CellInfo(counter,5)=mean([PointInfo(CellInfo(counter,1),2),PointInfo(CellInfo(counter,2),2),PointInfo(CellInfo(counter,3),2)]);
end 
CellInfo=[CellInfo(:,4:5),CellInfo(:,1:3),ones(size(CellInfo,1),3)*-1];
    
EdgeInfo=[];
for counter=1:size(CellInfo,1)
    EdgeInfo(end+1,:)=[CellInfo(counter,3),CellInfo(counter,4)];
    EdgeInfo(end+1,:)=[CellInfo(counter,4),CellInfo(counter,5)];
    EdgeInfo(end+1,:)=[CellInfo(counter,3),CellInfo(counter,5)];
end
EdgeInfo(:,3)=1;
for counter=1:size(EdgeInfo,1)
    if(EdgeInfo(counter,1)>EdgeInfo(counter,2))
        Temp=EdgeInfo(counter,1);
        EdgeInfo(counter,1)=EdgeInfo(counter,2);
        EdgeInfo(counter,2)=Temp;
    end
end
EdgeInfo=sortrows(EdgeInfo);
for counter=1:size(EdgeInfo,1)-1
    if(EdgeInfo(counter,1)==EdgeInfo(counter+1,1) && EdgeInfo(counter,2)==EdgeInfo(counter+1,2))
        EdgeInfo(counter,3)=0;
        EdgeInfo(counter+1,3)=0;
    elseif (mean([PointInfo(EdgeInfo(counter,1),1),PointInfo(EdgeInfo(counter,2),1)])==min(PointInfo(:,1)))
        EdgeInfo(counter,3)=WestBoundary;
    elseif (mean([PointInfo(EdgeInfo(counter,1),1),PointInfo(EdgeInfo(counter,2),1)])==max(PointInfo(:,1)))
        EdgeInfo(counter,3)=EastBoundary;
    elseif (mean([PointInfo(EdgeInfo(counter,1),2),PointInfo(EdgeInfo(counter,2),2)])==min(PointInfo(:,2)))
        EdgeInfo(counter,3)=SouthBoundary;
    elseif (mean([PointInfo(EdgeInfo(counter,1),2),PointInfo(EdgeInfo(counter,2),2)])==max(PointInfo(:,2)))
        EdgeInfo(counter,3)=NorthBoundary;
    end
end
RepeatedEdgeIndex=[];
for counter=1:size(EdgeInfo,1)-1
    if(EdgeInfo(counter,1)==EdgeInfo(counter+1,1) && EdgeInfo(counter,2)==EdgeInfo(counter+1,2))
        RepeatedEdgeIndex(end+1)=counter;
    end
end
EdgeInfo(RepeatedEdgeIndex,:)=[];

for counter=1:size(EdgeInfo,1)
    if(mod(counter,floor(size(EdgeInfo,1)/20))==0)
        disp(strcat('Progress at=',num2str(counter*100/size(EdgeInfo,1)),'%'))
    end
    [Cell1,~]=find(CellInfo(:,3:5)==EdgeInfo(counter,1));
    [Cell2,~]=find(CellInfo(:,3:5)==EdgeInfo(counter,2));
    Neighbours=intersect(Cell1,Cell2);
    if size(Neighbours,1)>1
        EdgeInfo(counter,4:5)=Neighbours;
        if isempty(intersect(CellInfo(Neighbours(1),6:8),Neighbours(2)))
            [~,FreeIndex]=min(CellInfo(Neighbours(1),6:8));
            CellInfo(Neighbours(1),5+FreeIndex)=Neighbours(2);
        end
        if isempty(intersect(CellInfo(Neighbours(2),6:8),Neighbours(1)))
            [~,FreeIndex]=min(CellInfo(Neighbours(2),6:8));
            CellInfo(Neighbours(2),5+FreeIndex)=Neighbours(1);
        end
    else
        EdgeInfo(counter,4:5)=[Neighbours,-1];
    end
end

if FlagPlot
    for counter=1:size(CellInfo,1)
        plot([PointInfo(CellInfo(counter,3),1),PointInfo(CellInfo(counter,4),1)],...
            [PointInfo(CellInfo(counter,3),2),PointInfo(CellInfo(counter,4),2)]);
        hold on;
        plot([PointInfo(CellInfo(counter,3),1),PointInfo(CellInfo(counter,5),1)],...
            [PointInfo(CellInfo(counter,3),2),PointInfo(CellInfo(counter,5),2)]);
        plot([PointInfo(CellInfo(counter,4),1),PointInfo(CellInfo(counter,5),1)],...
            [PointInfo(CellInfo(counter,4),2),PointInfo(CellInfo(counter,5),2)]);        
    end 
    for counter=1:size(EdgeInfo,1)
        switch EdgeInfo(counter,3)
            case 0
            MyColor=[0 0 0];%Computational Boundary
            MyLinedWidth=0.5;
            case 1
            MyColor=[1 0 0];%Closed Boundary
            MyLinedWidth=2;
            case 2
            MyColor=[0 0 1];%Velocity-Specified Boundary
            MyLinedWidth=2;
        end 
        plot([PointInfo(EdgeInfo(counter,1),1),PointInfo(EdgeInfo(counter,2),1)],...
            [PointInfo(EdgeInfo(counter,1),2),PointInfo(EdgeInfo(counter,2),2)],'color',MyColor,'LineWidth',MyLinedWidth);
        hold on;
    end
    for counter=1:size(CellInfo,1)
        text(CellInfo(counter,1),CellInfo(counter,2),num2str(counter),'FontSize',8);
    end
    for counter=1:size(PointInfo,1)
        text(PointInfo(counter,1),PointInfo(counter,2),num2str(counter),'FontSize',8,'Color','blue');
    end
%     for counter=2:2:size(EdgeInfo,1)
%         Temp1=mean([PointInfo(EdgeInfo(counter,1),1),PointInfo(EdgeInfo(counter,2),1)]);
%         Temp2=mean([PointInfo(EdgeInfo(counter,1),2),PointInfo(EdgeInfo(counter,2),2)]);
%         text(Temp1,Temp2,num2str(counter),'FontSize',10,'Color','red');
%     end    
end
%Compatibilizing with SUNTANS where Points, Edges and Cells start from 0
if FlagSUNTANSCompatibility
    for counter=1:size(EdgeInfo,1)
        EdgeInfo(counter,[1,2,4])=EdgeInfo(counter,[1,2,4])-1;
        if (EdgeInfo(counter,5)~=-1)
            EdgeInfo(counter,5)=EdgeInfo(counter,5)-1;
        end
    end
    for counter=1:size(CellInfo,1)
        CellInfo(counter,3:5)=CellInfo(counter,3:5)-1;
        if (CellInfo(counter,6)~=-1)
            CellInfo(counter,6)=CellInfo(counter,6)-1;
        end    
        if (CellInfo(counter,7)~=-1)
            CellInfo(counter,7)=CellInfo(counter,7)-1;
        end    
        if (CellInfo(counter,8)~=-1)
            CellInfo(counter,8)=CellInfo(counter,8)-1;
        end        
    end
end
if FlagBathymetry
    Ls = 30000;
    YMid=mean(PointInfo(:,2));
    YTransition=18e3;
    D0 = 3000;
    Ds = 300;  
    LsX = 30000;
    XMid=mean(PointInfo(:,1));
    XTransition=30e3;
    XL = XMid-XTransition;
    XR = XMid+XTransition;
    XFlat=5e3;
    
    DsX=nan(size(PointInfo,1),1);
    DsX(PointInfo(:,2)<=YMid)= D0 - 0.5*(D0 - Ds)*(1 + tanh(4 * (PointInfo(PointInfo(:,2)<=YMid,2) - YMid+YTransition) / Ls));
    DsX(PointInfo(:,2)>YMid)= Ds + 0.5*(D0 - Ds)*(1 + tanh(4 * (PointInfo(PointInfo(:,2)>YMid,2) -(YMid+YTransition)) / Ls));
       
    Bathymetry=DsX + 0.5*(D0 - DsX).*(1 + tanh(4 * (PointInfo(:,1) - XR) / LsX));
    Index1=find(PointInfo(:,1)<=XL+XTransition-XFlat);
    Bathymetry(Index1)= D0 - 0.5*(D0 - DsX(Index1)).*(1 + tanh(4 * (PointInfo(Index1,1) - XL) / LsX));
    XTemp=XL+XTransition-XFlat;
    Index2=find(PointInfo(:,1)>XL+XTransition-XFlat & PointInfo(:,1)<XR-XTransition+XFlat);
    Bathymetry(Index2)=D0 - 0.5*(D0 - DsX(Index2)).*(1 + tanh(4 * (XTemp - XL) / LsX));
    
    FidData=strcat(DestinationAdd,'depth.dat');
    fileID = fopen(FidData,'w');
    for counter = 1:size(PointInfo,1)
        fprintf(fileID,'%.15e%c%.15e%c%.15e\n',PointInfo(counter,1),' ',PointInfo(counter,2),' ',Bathymetry(counter));
    end
    fclose(fileID);
end

if FlagPointsCellEdgeFilesWriter
    FidData=strcat(DestinationAdd,'points.dat');
    fileID = fopen(FidData,'w');
    for counter = 1:size(PointInfo,1)
        fprintf(fileID,'%.15e%c%.15e%s\n',PointInfo(counter,1),' ',PointInfo(counter,2),' 1000');
    end
    fclose(fileID);
    
    FidData=strcat(DestinationAdd,'edges.dat');
    fileID = fopen(FidData,'w');
    for counter = 1:size(EdgeInfo,1)
        fprintf(fileID,'%d%c%d%c%d%c%d%c%d\n',EdgeInfo(counter,1),' '...
            ,EdgeInfo(counter,2),' ',EdgeInfo(counter,3),' '...
            ,EdgeInfo(counter,4),' ',EdgeInfo(counter,5));
    end
    fclose(fileID);

    FidData=strcat(DestinationAdd,'cells.dat');
    fileID = fopen(FidData,'w');
    for counter = 1:size(CellInfo,1)
        fprintf(fileID,'%.15e%c%.15e%c%d%c%d%c%d%c%d%c%d%c%d\n',...
            CellInfo(counter,1),' ',CellInfo(counter,2),' ',...
            CellInfo(counter,3),' ',CellInfo(counter,4),' ',...
            CellInfo(counter,5),' ',CellInfo(counter,6),' ',...
            CellInfo(counter,7),' ',CellInfo(counter,8));
    end
    fclose(fileID);
else
    WestSouthCorner=find(PointInfo(:,1)==min(PointInfo(:,1)) & PointInfo(:,2)==min(PointInfo(:,2)))-1;
    EastSouthCorner=find(PointInfo(:,1)==max(PointInfo(:,1)) & PointInfo(:,2)==min(PointInfo(:,2)))-1;
    WestNorthCorner=find(PointInfo(:,1)==min(PointInfo(:,1)) & PointInfo(:,2)==max(PointInfo(:,2)))-1;
    EastNorthCorner=find(PointInfo(:,1)==max(PointInfo(:,1)) & PointInfo(:,2)==max(PointInfo(:,2)))-1;

    EdgeInfoSummerized=[WestSouthCorner,EastSouthCorner,SouthBoundary;...
                        WestSouthCorner,WestNorthCorner,WestBoundary;...
                        EastSouthCorner,EastNorthCorner,EastBoundary;...
                        WestNorthCorner,EastNorthCorner,NorthBoundary];

    FidData=strcat(DestinationAdd,'oned.dat');
    fileID = fopen(FidData,'w');
    fprintf(fileID,'%d\n',size(PointInfo,1));
    for counter = 1:size(PointInfo,1)
        fprintf(fileID,'%.15e%c%.15e%s\n',PointInfo(counter,1),' ',PointInfo(counter,2),' 0');
    end
    fprintf(fileID,'%d\n',size(EdgeInfoSummerized,1));
    for counter = 1:size(EdgeInfoSummerized,1)
        fprintf(fileID,'%d%c%d%c%d\n',EdgeInfoSummerized(counter,1),' '...
            ,EdgeInfoSummerized(counter,2),' ',EdgeInfoSummerized(counter,3));
    end
    fprintf(fileID,'0\n');
    fprintf(fileID,'%f\n',0);
    fclose(fileID);
end