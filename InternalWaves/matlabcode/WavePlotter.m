%This code is plotting the SUNTANS results for several case scenarios with similar names
%Code written by Sorush Omidvar in July 2016 at UGA
function WavePlotter(AnalysisSpeed,FPSMovie,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,TauMax,DataPath,CurrentPath,CaseName)
    %Reading time and setting some 5 basic variables
    Time=ncread(DataPath,'time');
    %Reading Density
    X=ncread(DataPath,'xv');
    Z=ncread(DataPath,'z_r');
    Z=-Z;
    [XX,ZZ]=meshgrid(Z,X);
    
    Results=1000*ncread(DataPath,'rho')+1000;
    DiagramTitle=sprintf('Density (Kg/m^3)');
    MovieName=strcat(CaseName,'-Density');
    YLabel='Depth (m)';
    WavePlotterExtension(FPSMovie,AnalysisSpeed,Time,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,TauMax,XX,X,ZZ,YLabel,Results,DiagramTitle,MovieName,CurrentPath);    
    
%     DiagramTitle=sprintf('Density (Kg/m^3) Anamoly');
%     MovieName=strcat(CaseName,'-Density Anamoly');
%     %Removing the background Density
%     BenchMark=Results(:,:,1);
%     Results=Results-repmat(BenchMark,1,1,size(Results,3));
%     WavePlotterExtension(FPSMovie,AnalysisSpeed,Time,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,TauMax,XX,X,ZZ,YLabel,Results,DiagramTitle,MovieName,CurrentPath);
    
%     %Reading Salinity
%     Results=ncread(DataPath,'salt');
%     DiagramTitle=sprintf('Salinity (PSU)');
%     MovieName=strcat(CaseName,'-Salinity');
%     YLabel='Depth (m)';
%     WavePlotterExtension(FPSMovie,AnalysisSpeed,Time,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,TauMax,XX,X,ZZ,YLabel,Results,DiagramTitle,MovieName,CurrentPath);    
    
%     DiagramTitle=sprintf('Salinity (PSU) Anamoly');
%     MovieName=strcat(CaseName,'-Salinity Anamoly');
%     %Removing the background salinity
%     BenchMark=Results(:,:,1);
%     Results=Results-repmat(BenchMark,1,1,size(Results,3));
%     WavePlotterExtension(FPSMovie,AnalysisSpeed,Time,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,TauMax,XX,X,ZZ,YLabel,Results,DiagramTitle,MovieName,CurrentPath);

%     %Reading Pressure
%     Results=ncread(DataPath,'q');
%     DiagramTitle=sprintf('Non-Hydrostatic Pressure (Pa)');
%     MovieName=strcat(CaseName,'-Non Hydrostatic Pressure');
%     YLabel='Depth (m)';
%     WavePlotterExtension(FPSMovie,AnalysisSpeed,Time,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,TauMax,XX,X,ZZ,YLabel,Results,DiagramTitle,MovieName,CurrentPath);    
%     clear Results;

%     %Reading Horizontal Velocity
%     Results=ncread(DataPath,'uc');
%     DiagramTitle=sprintf('Horizontal Velocity (m/s)');
%     MovieName=strcat(CaseName,'-Horizontal Velocity');
%     YLabel='Depth (m)';    
%     WavePlotterExtension(FPSMovie,AnalysisSpeed,Time,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,TauMax,XX,X,ZZ,YLabel,Results,DiagramTitle,MovieName,CurrentPath);
    
    
%     %Reading Vertical Velocity
%     Results=ncread(DataPath,'w');
%     Z=ncread(DataPath,'z_w');
%     Z=-Z;
%     [XX,ZZ]=meshgrid(Z,X);
%     DiagramTitle=sprintf('Vertical Velocity (m/s)');
%     MovieName=strcat(CaseName,'-Vertical Velocity');   
%     YLabel='Depth (m)';    
%     WavePlotterExtension(FPSMovie,AnalysisSpeed,Time,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,TauMax,XX,X,ZZ,YLabel,Results,DiagramTitle,MovieName,CurrentPath);

    %Reading Water Level
    Results=ncread(DataPath,'eta');
    X=ncread(DataPath,'xv');
    DiagramTitle=sprintf('Water Level (m)');
    MovieName=strcat(CaseName,'-Water Level');
    YLabel='Elevation (m)';    
    WavePlotterExtension(FPSMovie,AnalysisSpeed,Time,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,TauMax,XX,X,ZZ,YLabel,Results,DiagramTitle,MovieName,CurrentPath);

end

function WavePlotterExtension(FPSMovie,AnalysisSpeed,Time,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,TauMax,XX,X,ZZ,YLabel,Results,DiagramTitle,MovieName,CurrentPath)
    close all;
    %Making the figure as big as possible based on the monitor resolution
    FigureSize=[1900,850];
    f=figure('Position',[1 1 FigureSize(1) FigureSize(2)],'units','pixels','Resize','off');
    movegui(f,'center');
    MovieData(1:ceil(size(Time,1)/AnalysisSpeed)) = struct('cdata', [],'colormap', []);
    CounterMovie=0;
    tau=nan(size(Time,1),3);
    tau(:,1)= sin(DiurnalTideOmega*Time);
    tau(:,2)= sin(SemiDiurnalTideOmega*Time);
    tau(:,3)= TauMax*(sin(3*pi/2+WindOmega*Time)+1)/2;

    %Changing the color map for pcolor function to make the negative and
    %positive values clearer by putting zero in the middle of the scale.
    %in CustomMap array the 3rd dimensions are as follow: red, green, blue.
    MapColorNumber=30;
    %Using MapColorBrightnessThreshold to distinct the colors from white
    MapColorBrightnessThreshold=0.75;
    MapColors=linspace(0,MapColorBrightnessThreshold,MapColorNumber-1);
    %Adding white color to the map
    MapColors(end+1)=1;
    CustomMap=zeros(2*MapColorNumber+1,3);
    CustomMap(1,:)=[0.1 0.1 0.1];
    CustomMap(2:MapColorNumber+1,1)=MapColors;
    CustomMap(2:MapColorNumber+1,2)=MapColors;
    CustomMap(2:MapColorNumber+1,3)=1;
    CustomMap(MapColorNumber+2:end-1,3)=fliplr(MapColors(1:end-1));
    CustomMap(MapColorNumber+2:end-1,2)=fliplr(MapColors(1:end-1));
    CustomMap(MapColorNumber+2:end-1,1)=1;
    CustomMap(end,:)=[0.1 0.1 0.1]; 
    
    %Making the scale symmetric
    ResultsMax=max(max(max(Results)));
    ResultsMin=min(min(min(Results)));
    ResultsLimits=max(abs(ResultsMax),abs(ResultsMin));
    if strcmp(DiagramTitle,'Non-Hydrostatic Pressure (Pa)')
        ResultsLimits=ResultsLimits/10;
    end
    if strcmp(DiagramTitle,'Density (Kg/m^3) Anamoly')|| ...
    strcmp(DiagramTitle,'Salinity (PSU) Anamoly') || ...
    strcmp(DiagramTitle,'Horizontal Velocity (m/s)') || ...
    strcmp(DiagramTitle,'Vertical Velocity (m/s)')|| ...
    strcmp(DiagramTitle,'Non-Hydrostatic Pressure (Pa)')
        ResultsMax=+1.1*ResultsLimits;
        ResultsMin=-1.1*ResultsLimits;
        if ResultsMax==ResultsMin
            ResultsMax=ResultsMax+0.01;
            ResultsMin=ResultsMin-0.01;
        end
    end    
    clear ResultsLimits;
    
    if strcmp(DiagramTitle,'Water Level (m)')
        for counter=1:AnalysisSpeed:size(Time,1)
            subplot('position',[.06 .85 .90 .1]);
            hold on;
            rectangle('position',[0 -1 Time(counter)/3600 2],'FaceColor','red', 'EdgeColor','red');
            plot(Time/3600,tau(:,1),'--blue','LineWidth',1.5);
            plot(Time/3600,tau(:,2),'-.green','LineWidth',1.5);
            plot(Time/3600,tau(:,3),':black','LineWidth',1.5);
            legend('Diurnal Tide','Semi-Dirunal Tide','Dirunal Wind','Location','eastoutside','Orientation','vertical');
            grid on;
            set(gca,'layer','top');
            set(gca,'XTick',0:12:Time(end)/3600);
            grid minor;
            hold off;
            xlabel('Time (Hour)');
            ylim([-1 1]);
            xlim([min(Time)/3600 max(Time)/3600]);
            
            subplot('position',[.06 .10 .9 .65]);
            plot(X/1000,Results(:,counter));
            grid on;
            grid minor;
            set(gca,'layer','top');
            xlabel('Distance off-shore (Km)');
            ylabel(YLabel);
            str2=sprintf(' at time %.2f hour',Time(counter)/3600);
            Title=strcat(DiagramTitle,str2);
            title(Title);
            ylim([ResultsMin ResultsMax]);
            CounterMovie=CounterMovie+1;
            MovieData(CounterMovie)=getframe(gcf);
        end    
    else
        for counter=1:AnalysisSpeed:size(Time,1)
            subplot('position',[.06 .85 .91 .1]);
            hold on;
            rectangle('position',[0 -1 Time(counter)/3600 2],'FaceColor','red', 'EdgeColor','red');
            plot(Time/3600,tau(:,1),'--blue','LineWidth',1.5);
            plot(Time/3600,tau(:,2),'-.green','LineWidth',1.5);
            plot(Time/3600,tau(:,3),':black','LineWidth',1.5);
            legend('K1 Tide','M2 Tide','Dirunal Wind','Location','eastoutside','Orientation','vertical');
            
            grid on;
            set(gca,'layer','top');
            set(gca,'XTick',0:12:Time(end)/3600);
            grid minor;
            hold off;
            ylim([-1 1]);
            xlim([min(Time)/3600 max(Time)/3600]);
            
            subplot('position',[.06 .1 .9 .65]);
            Temporary=Results(:,:,counter);
            if strcmp(DiagramTitle,'Density (Kg/m^3) Anamoly')|| ...
            strcmp(DiagramTitle,'Salinity (PSU) Anamoly') || ...
            strcmp(DiagramTitle,'Horizontal Velocity (m/s)') || ...
            strcmp(DiagramTitle,'Vertical Velocity (m/s)')|| ...
            strcmp(DiagramTitle,'Non-Hydrostatic Pressure (Pa)')            
                Temporary(isnan(Temporary))=10000;
            end
            pcolor(ZZ/1000,XX,Temporary);
            colorbar;
            hold on;
            if strcmp(DiagramTitle,'Density (Kg/m^3)')
                colormap('cool');
                h = colorbar;
                set( h, 'YDir', 'reverse' );                
                contour(ZZ/1000,XX,Results(:,:,counter),'k');
            elseif strcmp(DiagramTitle,'Salinity (PSU)')
                colormap('Autumn');
                colormap(flipud(colormap));
                h = colorbar;
                set( h, 'YDir', 'reverse' );
                contour(ZZ/1000,XX,Results(:,:,counter),'k');
            else
                colormap(CustomMap);
            end
            caxis([ResultsMin ResultsMax]);
            grid on;
            set(gca,'layer','top');
            grid minor;
            shading flat;
            xlabel('Distance off-shore (Km)');
            ylabel(YLabel);
            str2=sprintf(' at time %.2f hour',Time(counter)/3600);
            Title=strcat(DiagramTitle,str2);
            title(Title);
            CounterMovie=CounterMovie+1;
            MovieData(CounterMovie)=getframe(gcf);
        end        
    end
    %Creating movie using the MPEG-4 to conserve quality and make it smaller 
    ResultVideoWriter=VideoWriter(strcat(CurrentPath,MovieName),'MPEG-4');
    ResultVideoWriter.FrameRate=FPSMovie;
    open(ResultVideoWriter);
    for counter=1:size(MovieData,2)
        writeVideo(ResultVideoWriter,MovieData(counter).cdata);
    end
    close(ResultVideoWriter);
end