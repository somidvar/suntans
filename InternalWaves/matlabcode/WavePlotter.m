%This code is plotting the SUNTANS results for several case scenarios with similar names
%Code written by Sorush Omidvar in July 2016 at UGA
function WavePlotter(AnalysisSpeed,FPSMovie,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,TauMax,DataPath,OutputAddress,CaseNumber,ModelTimeOffset,WindLag)
    Time=ncread(DataPath,'time');
    X=ncread(DataPath,'xv');   
    Z=ncread(DataPath,'z_r');
    Z=-Z;
    
%     Results=1000*ncread(DataPath,'rho')+1000;
%     [Results,XTruncated]=DataXTruncator(Results,X);
%     [XX,ZZ]=meshgrid(Z,XTruncated);  
%     DiagramTitle=sprintf('Density (Kg/m^3)');
%     MovieName=strcat(CaseNumber,'-Density');
%     YLabel='Depth (m)';
%     WavePlotterExtension(FPSMovie,AnalysisSpeed,Time,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,TauMax,ModelTimeOffset,WindLag,XX,XTruncated,ZZ,YLabel,Results,DiagramTitle,MovieName,OutputAddress);    
    
%     DiagramTitle=sprintf('Density (Kg/m^3) Anamoly');
%     MovieName=strcat(CaseName,'-Density Anamoly');
%     %Removing the background Density
%     BenchMark=Results(:,:,1);
%     Results=Results-repmat(BenchMark,1,1,size(Results,3));
%     WavePlotterExtension(FPSMovie,AnalysisSpeed,Time,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,TauMax,ModelTimeOffset,WindLag,XX,XTruncated,ZZ,YLabel,Results,DiagramTitle,MovieName,OutputAddress);
    
%     %Reading Salinity
%     Results=ncread(DataPath,'salt');
%     [Results,XTruncated]=DataXTruncator(Results,X);
%     [XX,ZZ]=meshgrid(Z,XTruncated);  
%     DiagramTitle=sprintf('Salinity (PSU)');
%     MovieName=strcat(CaseNumber,'-Salinity');
%     YLabel='Depth (m)';
%     WavePlotterExtension(FPSMovie,AnalysisSpeed,Time,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,TauMax,ModelTimeOffset,WindLag,XX,XTruncated,ZZ,YLabel,Results,DiagramTitle,MovieName,OutputAddress);    
    
%     %Reading Pressure
%     Results=ncread(DataPath,'q');
%     [Results,XTruncated]=DataXTruncator(Results,X);
%     [XX,ZZ]=meshgrid(Z,XTruncated); 
%     DiagramTitle=sprintf('Non-Hydrostatic Pressure (Pa)');
%     MovieName=strcat(CaseName,'-Non Hydrostatic Pressure');
%     YLabel='Depth (m)';
%     WavePlotterExtension(FPSMovie,AnalysisSpeed,Time,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,TauMax,ModelTimeOffset,WindLag,XX,XTruncated,ZZ,YLabel,Results,DiagramTitle,MovieName,OutputAddress);    
%     clear Results;

%     %Reading Horizontal Velocity
%     Results=ncread(DataPath,'uc');
%     [Results,XTruncated]=DataXTruncator(Results,X);
%     [XX,ZZ]=meshgrid(Z,XTruncated); 
%     DiagramTitle=sprintf('Horizontal Velocity (m/s)');
%     MovieName=strcat(CaseNumber,'-Horizontal Velocity');
%     YLabel='Depth (m)';    
%     WavePlotterExtension(FPSMovie,AnalysisSpeed,Time,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,TauMax,ModelTimeOffset,WindLag,XX,XTruncated,ZZ,YLabel,Results,DiagramTitle,MovieName,OutputAddress);
%         
%     %Reading Vertical Velocity
%     Results=ncread(DataPath,'w');
%     [Results,XTruncated]=DataXTruncator(Results,X);
%     Z=ncread(DataPath,'z_w');
%     Z=-Z;
%     [XX,ZZ]=meshgrid(Z,XTruncated); 
%     DiagramTitle=sprintf('Vertical Velocity (m/s)');
%     MovieName=strcat(CaseNumber,'-Vertical Velocity');   
%     YLabel='Depth (m)';    
%     WavePlotterExtension(FPSMovie,AnalysisSpeed,Time,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,TauMax,ModelTimeOffset,WindLag,XX,XTruncated,ZZ,YLabel,Results,DiagramTitle,MovieName,OutputAddress);

    %Reading Water Level
    Results=ncread(DataPath,'eta');
    [Results,XTruncated]=DataXTruncator(Results,X);
    [XX,ZZ]=meshgrid(Z,XTruncated);
    DiagramTitle=sprintf('Water Level (m)');
    MovieName=strcat(CaseNumber,'-Water Level');
    YLabel='Elevation (m)';    
    WavePlotterExtension(FPSMovie,AnalysisSpeed,Time,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,TauMax,ModelTimeOffset,WindLag,XX,XTruncated,ZZ,YLabel,Results,DiagramTitle,MovieName,OutputAddress);
end

function WavePlotterExtension(FPSMovie,AnalysisSpeed,Time,DiurnalTideOmega,SemiDiurnalTideOmega,WindOmega,TauMax,ModelTimeOffset,WindLag,XX,X,ZZ,YLabel,Results,DiagramTitle,MovieName,OutputAddress)
    close all;
    %Making the figure as big as possible based on the monitor resolution
    FigureSize=[1900,850];
    f=figure('Position',[1 1 FigureSize(1) FigureSize(2)],'units','pixels','Resize','off');
    movegui(f,'center');
    %Creating movie using the MPEG-4 to conserve quality and make it smaller 
    ResultVideoWriter=VideoWriter(strcat(OutputAddress,MovieName),'MPEG-4');
    ResultVideoWriter.FrameRate=FPSMovie;
    open(ResultVideoWriter);
    
    tau=nan(size(Time,1),3);
    tau(:,1)= sin(DiurnalTideOmega*Time);
    tau(:,2)= sin(SemiDiurnalTideOmega*Time);
    tau(:,3)= TauMax*(sin(WindOmega*Time+WindLag/24*2*pi)+1)/2;

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
            rectangle('position',[ModelTimeOffset -1 Time(counter)/3600 2],'FaceColor','red', 'EdgeColor','red');
            plot(Time/3600+ModelTimeOffset,tau(:,1),'--blue','LineWidth',1.5);
            plot(Time/3600+ModelTimeOffset,tau(:,2),'-.green','LineWidth',1.5);
            plot(Time/3600+ModelTimeOffset,tau(:,3),':black','LineWidth',1.5);
            legend('Diurnal Tide','Semi-Dirunal Tide','Dirunal Wind','Location','eastoutside','Orientation','vertical');
            grid on;
            set(gca,'layer','top');
            set(gca,'XTick',24:24:Time(end)/3600+ModelTimeOffset);
            grid minor;
            hold off;
            ylim([-1 1]);
            xlim([min(Time)/3600+ModelTimeOffset,max(Time)/3600+ModelTimeOffset]);
			set(gca,'fontsize',16);
			set(gca,'FontWeight','bold');
            
            subplot('position',[.06 .10 .9 .65]);
            plot(X/1000,Results(:,counter));
            grid on;
            grid minor;
            set(gca,'layer','top');
            xlabel('Distance off-shore (Km)');
            ylabel(YLabel);
            if ModelTimeOffset>0
                str2=sprintf('at %2.0f day and %3.1f hour (time offset=+%2.0f)',floor((Time(counter)/3600+ModelTimeOffset)/24),mod((Time(counter)/3600+ModelTimeOffset),24),ModelTimeOffset);
            else
                str2=sprintf('at %2.0f day and %3.1f hour (time offset=%2.0f)',floor((Time(counter)/3600+ModelTimeOffset)/24),mod((Time(counter)/3600+ModelTimeOffset),24),ModelTimeOffset);
            end
            Title=strcat(DiagramTitle,str2);
            title(Title);
            ylim([ResultsMin ResultsMax]);
			set(gca,'fontsize',18);
			set(gca,'FontWeight','bold');
            MovieTemporary=getframe(gcf);
            writeVideo(ResultVideoWriter,MovieTemporary.cdata);
        end    
    else
        for counter=1:AnalysisSpeed:50
            subplot('position',[.06 .85 .91 .1]);
            hold on;
            rectangle('position',[ModelTimeOffset -1 Time(counter)/3600 2],'FaceColor','red', 'EdgeColor','red');
            plot(Time/3600+ModelTimeOffset,tau(:,1),'--blue','LineWidth',1.5);
            plot(Time/3600+ModelTimeOffset,tau(:,2),'-.green','LineWidth',1.5);
            plot(Time/3600+ModelTimeOffset,tau(:,3),':black','LineWidth',1.5);
            legend('K1 Tide','M2 Tide','Dirunal Wind','Location','eastoutside','Orientation','vertical');
            
            grid on;
            set(gca,'layer','top');
            set(gca,'XTick',24:24:Time(end)/3600+ModelTimeOffset);
            grid minor;
            hold off;
            ylim([-1 1]);
            xlim([min(Time)/3600+ModelTimeOffset,max(Time)/3600+ModelTimeOffset]);
			set(gca,'fontsize',16);
			set(gca,'FontWeight','bold');
            
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
            if ModelTimeOffset>0
                str2=sprintf('at %2.0f day and %3.1f hours (time offset=+%2.0f)',floor((Time(counter)/3600+ModelTimeOffset)/24),mod((Time(counter)/3600+ModelTimeOffset),24),ModelTimeOffset);
            else
                str2=sprintf('at %2.0f day and %3.1f hours (time offset=%2.0f)',floor((Time(counter)/3600+ModelTimeOffset)/24),mod((Time(counter)/3600+ModelTimeOffset),24),ModelTimeOffset);
            end
            Title=strcat(DiagramTitle,str2);
            title(Title);
			set(gca,'fontsize',18);
			set(gca,'FontWeight','bold');
            MovieTemporary=getframe(gcf);
            writeVideo(ResultVideoWriter,MovieTemporary.cdata);
        end        
    end
    close(ResultVideoWriter);
end

function [DataTruncated,XTruncated]=DataXTruncator(Data,X)
    %This function reduce the resolution in X direction to save some space.
    %The high resolution was inforced by stability in SUNTANS.
    DataIndex=[];
    for i=1:size(X,1)
        if X(i)<8000
            continue;
        else
            if mod(i,10)~=0
                DataIndex(end+1)=i;
            end            
        end
    end
    XTruncated=X;
    XTruncated(DataIndex)=[];
    DataTruncated=Data;
    if ndims(Data)==2
        DataTruncated(DataIndex,:)=[];
    elseif ndims(Data)==3
        DataTruncated(DataIndex,:,:)=[];
    else
        disp('Error happened in DataXTruncator function');
        return;
    end
end