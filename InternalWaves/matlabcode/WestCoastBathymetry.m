close all;
clear all;
clc

FigureSize=[1900,900];
fig=figure('Position',[1 1 FigureSize(1) FigureSize(2)]);
movegui('center');
subplot('position',[0.05,0.10,0.40,0.80]);

AX=[-122.30,-121.70,36.55,37.00];
WestCoastGeometryPlotter(AX);
hold on;
ContourColor={[0.8,0.8,0.8];[0.6,0.6,0.6];[0.4,0.4,0.4];[0.2,0.2,0.2]};
ContourDepth=[-25;-50;-75;-200];
if size(ContourDepth,1)~=size(ContourColor,1)
    disp('Error in Contour depths and colors');
    return;
end
WestCoastBathymetryPlotter(ContourDepth,ContourColor);

annotation(fig,'line',[0.31421 0.33473],[0.23011 0.34888],'Color',[0,0,0.7],'LineWidth',5);

subplot('position',[0.50,0.60,0.40,0.30]);
%Plotting Walter Bathymetry
WalterBathymetry();
annotation(fig,'textbox',[0.05,0.84,0.02,0.05],'String','a)','fontsize',18,'EdgeColor','none');
annotation(fig,'textbox',[0.88,0.84,0.02,0.05],'String','b)','fontsize',18,'EdgeColor','none');
set(gca,'fontsize',16);
set(gca,'FontWeight','bold');
saveas(fig,'Bathymetry.png');


function WestCoastGeometryPlotter(AX)
    fillcolor=[0.7,0.7,0.7];
    CurrentAddress=pwd;
    %For AX, first put in [longWest, LongEast, LatSouth, LatNorth]
    bufr=.1;

    %%%%%%%%%%%%%%%%%%%%%%%%
    % Load coastline data
    %%%%%%%%%%%%%%%%%%%%%%%%
    CurrentAddress=strcat(CurrentAddress,'\');
    cd(CurrentAddress);
    load WestCoastGeometryData.mat;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Fill contenental polygon
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    idx=find(LON>=AX(1)-bufr&LON<=AX(2)+bufr & LAT>=AX(3)-bufr&LAT<=AX(4)+bufr);
    lon=LON(idx); lat=LAT(idx);
    % add remaining points
    closelat = [AX([3 3 4 4])]'; closelon = [lon(length(lon)) AX([2 2]) lon(1)]';
    fillLon=[lon;closelon]; fillLat=[lat;closelat];
    % fill 
    Hlandfill=fill(fillLon,fillLat,fillcolor); 
    set(Hlandfill,'edgecolor','none');
    hold on;
    plot(LON,LAT,'k','linewidth',1); 

    %%%%%%%%%%%%%%%%%%%%%%%%%
    % Channel Islands
    %%%%%%%%%%%%%%%%%%%%%%%%%
    if AX(3)<34
        disp('Including Channel Island fills...');
        idx=find(isnan(CILON));
        sub=[1:idx(1)-1 1]; fillLon=CILON(sub); fillLat=CILAT(sub); fill(fillLon,fillLat,fillcolor);
        sub=[idx(1)+1:idx(2)-1 idx(1)+1]; fillLon=CILON(sub); fillLat=CILAT(sub); fill(fillLon,fillLat,fillcolor);
        sub=[idx(2)+1:idx(3)-1 idx(2)+1]; fillLon=CILON(sub); fillLat=CILAT(sub); fill(fillLon,fillLat,fillcolor);
    end
    axis(AX);
    set(gca,'fontsize',18);
    set(gca,'FontWeight','bold');
    yticks([36.6;36.7;36.8;36.9;37.0]);
    yticklabels({'36.6';'36.7';'36.8';'36.9';'37.0'});   
    xticks([-122.3,-122.1,-121.9,-121.7]);
end

function WestCoastBathymetryPlotter(ContourDepth,ContourColor)
    CurrentAddress=pwd;
    CurrentAddress=strcat(CurrentAddress,'\');
    cd(CurrentAddress);
    load WestCoastBathymetryData.mat;
    for i=1:size(ContourDepth,1)
        [C,H]=contour(lon,lat,depth,[ContourDepth(i),ContourDepth(i)],'linecolor',ContourColor{i},'linestyle','--');
        %clabel(C,H,'manual','FontSize',20);
    end
    set(gca,'fontsize',18);
    set(gca,'FontWeight','bold');
end

function WalterBathymetry()
    XBathymetry=0:10:8000;
    XBathymetry=XBathymetry';
    Bathymetry=nan(size(XBathymetry,1),1);
    %Real values from Walter Paper for Monterey Bay
    %X=[41.5162440000000,171.480150000000,301.444050000000,366.426000000000,420.577620000000,474.729240000000,528.880900000000,583.032500000000,637.184140000000,675.090250000000,707.581200000000,767.148000000000,848.375440000000,913.357400000000,1005.41520000000,1124.54880000000,1297.83390000000,1606.49820000000,1920.57760000000,2180.50550000000,2505.41520000000,2884.47640000000,3274.36830000000,3761.73280000000,4232.85200000000,4758.12300000000,5256.31760000000,5694.94600000000,6128.15900000000,6620.93900000000,7037.90600000000,7416.96740000000,7725.63170000000];
    %Y=[-5.43629360000000,-7.53667970000000,-10.0077220000000,-13.2200775000000,-16.4942100000000,-19.7683400000000,-22.9189190000000,-26.0077230000000,-29.3436300000000,-33.1737440000000,-37.4362950000000,-41.0810800000000,-44.7258700000000,-48.3088800000000,-51.9536670000000,-54.7335900000000,-57.0810800000000,-59.1196900000000,-60.7258700000000,-62.5173760000000,-64,-65.6061800000000,-67.4594600000000,-69.3745200000000,-71.2278000000000,-73.2046360000000,-74.6254800000000,-75.9227800000000,-76.6640900000000,-77.7142900000000,-78.2702700000000,-78.8262560000000,-79.1969150000000];

    for i=1:size(XBathymetry,1)
        if XBathymetry(i)<50
            Bathymetry(i)=-5;
        elseif XBathymetry(i)<1080
            p1 = 5e-11;
            p2 = -3e-8;
            p3 = -7e-5;
            p4 = .0032;
            p5 = -5;
            Bathymetry(i)=p1*XBathymetry(i).^4+p2*XBathymetry(i).^3+p3*XBathymetry(i).^2+p4*XBathymetry(i)+p5;
        elseif XBathymetry(i)<7280
            p1 = 4e-7;
            p2 = -0.0069;
            p3 = -45.97;
            Bathymetry(i)=p1*XBathymetry(i).^2+p2*XBathymetry(i)+p3;
        else
            Bathymetry(i)=-75;
        end
    end
    Slope=diff(Bathymetry)./diff(XBathymetry);
    Slope(end+1)=Slope(end);
    Slope=movmean(Slope,5);

    [BathymertyFigureAxis,BathymetryCurve,BathymetrySlopeCurve] =...
        plotyy(XBathymetry/1000,Bathymetry,XBathymetry/1000,-Slope,'plot');
    set(BathymertyFigureAxis(1),'YColor',[0,0,0.7],'FontWeight','bold','fontsize',16);
    set(BathymertyFigureAxis(2),'YColor',[0.7,0,0],'FontWeight','bold','fontsize',16);

    xlabel('Offshore Distance (km)');
    ylabel(BathymertyFigureAxis(1),'Bathymetry Depth (m)');
    ylabel(BathymertyFigureAxis(2),'Bathymetry Slope (m/m)');

    BathymetryCurve.Color=[0,0,0.7];
    BathymetryCurve.LineWidth=4;

    BathymetrySlopeCurve.Color=[0.7,0,0];
    BathymetrySlopeCurve.LineWidth=3;
end