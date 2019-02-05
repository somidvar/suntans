for counter=1:1
    close all;
    clearvars -except counter;
    clc;
    DataPathRead=strcat('D:\Suntan-VMTest\case',num2str(counter),'\iwaves\data');
   % if counter<7
    %    RhoBTypeString='linear';
    %else
        RhoBTypeString='power';
    %end
    APECalculatorCopy(DataPathRead,counter,RhoBTypeString);
    load(strcat('D:\',num2str(counter)));
    
    
    H1Fig=figure;
    [xx,zz]=meshgrid(X,ZC);
    ConversionTimeVarientTimeAvr=trapz(Time,ConversionTimeVarient,3)/(Time(end)-Time(1));
    ConversionConventionalTimeAvr=trapz(Time,ConversionConventional,3)/(Time(end)-Time(1));
    ConversionTemporalTimeAvr=trapz(Time,ConversionTemporal,3)/(Time(end)-Time(1));
    ConversionTimeVarient1TimeAvr=trapz(Time,ConversionTimeVarient1,3)/(Time(end)-Time(1));

    pcolor(xx',zz',ConversionConventionalTimeAvr-ConversionTimeVarientTimeAvr);
    shading flat;
    colorbar;
    caxis([-1e-6 1e-6]);
    title(strcat('Conventional Minus TimeVariant-',num2str(counter)));
    savefig(H1Fig,strcat('D:\',num2str(counter),'-pcolor'));

    ConversionTimeVarientTimeAvrDepthInt=ConversionTimeVarientTimeAvr;
    ConversionConventionalTimeAvrDepthInt=ConversionConventionalTimeAvr;
    ConversionTemporalTimeAvrDepthInt=ConversionTemporalTimeAvr;
    ConversionTimeVarient1TimeAvrDepthInt=ConversionTimeVarient1TimeAvr;
    for i=1:size(X,1)
        for j=1:size(ZC,1)
            if isnan(ConversionTimeVarientTimeAvrDepthInt(i,j))
                ConversionTimeVarientTimeAvrDepthInt(i,j)=0;
                ConversionConventionalTimeAvrDepthInt(i,j)=0;
                ConversionTemporalTimeAvrDepthInt(i,j)=0;
                ConversionTimeVarient1TimeAvrDepthInt(i,j)=0;
            end
        end
    end
    ConversionTimeVarientTimeAvrDepthInt=trapz(abs(ZC),ConversionTimeVarientTimeAvrDepthInt,2);
    ConversionConventionalTimeAvrDepthInt=trapz(abs(ZC),ConversionConventionalTimeAvrDepthInt,2);
    ConversionTemporalTimeAvrDepthInt=trapz(abs(ZC),ConversionTemporalTimeAvrDepthInt,2);
    ConversionTimeVarient1TimeAvrDepthInt=trapz(abs(ZC),ConversionTimeVarient1TimeAvrDepthInt,2);

    H2Fig=figure;hold on;
    plot(X,ConversionTimeVarientTimeAvrDepthInt);
    plot(X,ConversionConventionalTimeAvrDepthInt);
    legend('Time Varient','Conventional');
    title(strcat('TimeAvrDepthInt-',num2str(counter)));
    savefig(H2Fig,strcat('D:\',num2str(counter),'-total'));

    H3Fig=figure;hold on;
    plot(X,ConversionTimeVarientTimeAvrDepthInt);
    plot(X,ConversionConventionalTimeAvrDepthInt);
    plot(X,ConversionTemporalTimeAvrDepthInt);
    plot(X,ConversionTimeVarient1TimeAvrDepthInt);
    legend('Time Varient','Conventional','Temporal','RhoPrimeGW');
    title(strcat('TimeAvrDepthInt-',num2str(counter)));
    savefig(H3Fig,strcat('D:\',num2str(counter),'-details'));
end