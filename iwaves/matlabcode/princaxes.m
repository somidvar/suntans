function dataout = princaxes(east,north,graph)

%Function Princaxes(east,north,graph)
%Function to find the rotation angles, "theta", (in radians) that would rotate the east axis into the
%axes of maxiumum and minimum variance for a time series of current or wind, etc.
%The function returns the angles, theta1 and theta2, in a two-column matrix.
%The first column returned corresponds to the axes of maximum variance, and the 2nd column to the
%axes of minimum variance.
%The input vectors must be the same length with the second vector rotated 90 degrees counterclockwise
%(orthogonal) from the first.  The input vectors must be column vectors.
%Theta is measured counterclockwise from the first vector (east) in radians.
%If the input variables are matricies, the fuction finds a theta for each column of the matricies.
%In this case, both "east" and "north" must have the same number of columns (representing different depths)
%and rows (representing different measurement times).
%If "graph" is set equal to 1, a scatter plot will be drawn of each time series with the principal
%axes superimposed
set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');

[rows,cols] = size(east);

for n = 1 : cols
    eastdum = east(:,n)-nanmean(east(:,n));%Take out the mean of the data
    northdum = north(:,n)-nanmean(north(:,n));

    M(1,n) = nanmean(eastdum.*eastdum);%The variance in east 
    M(2,n) = nanmean(eastdum.*northdum);%The covariance in east and north
    M(3,n) = nanmean(northdum.*eastdum);%The covariance in east and north
    M(4,n) = nanmean(northdum.*northdum);%The variance in north


    theta(n,1) = atan(2*M(2,n)/(M(1,n) - M(4,n)));
    theta(n,2) = theta(n,1) + pi;
    theta(n,1) = theta(n,1)/2; theta(n,2) = theta(n,2)/2;

    princdum1 = eastdum*cos(theta(n,1)) + northdum*sin(theta(n,1));%The projection of the velocity
                                                                   %onto the 1st principle axis
    princdum2 = eastdum*cos(theta(n,2)) + northdum*sin(theta(n,2));%onto the 2nd principle axis

    princ1var = nanvar(princdum1);%The variance along the 1st principle axis
    princ2var = nanvar(princdum2);%The variance along the 2nd principle axis
    %figure;plot(princdum1,princdum2,'.');axis equal
    ellipticity(n) = max([princ1var princ2var])/min([princ1var princ2var]);%This is a measure of the
    %degree of polarization or anisoptropy of the currents
    %It is the variance of the major axis over the variance of the minor axis
    [aa(n),bb(n)]=max([princ1var princ2var]);
    [cc(n),dd(n)]=min([princ1var princ2var]);
    theta(n,3) = theta(n,bb(n));
    theta(n,4) = theta(n,dd(n));

    if graph == 1
        DataH=plot(eastdum,northdum,'.','color',[0,0.5,0]);
        %axis equal
        hold on

        C = 2*((max(eastdum)^2 + max(northdum)^2)^0.5);

        if bb(n) == 1
                colurr1 = 'r'; colurr2 = 'b';
        else
                colurr1 = 'b'; colurr2 = 'r';
        end

        MinVariationDirectionH=plot([-C*cos(theta(n,1)) C*cos(theta(n,1))],[-C*sin(theta(n,1)) C*sin(theta(n,1))],colurr1,'LineWidth',3,'LineStyle',':');
        MaxVariationDirectionH=plot([-C*cos(theta(n,2)) C*cos(theta(n,2))],[-C*sin(theta(n,2)) C*sin(theta(n,2))],colurr2,'LineWidth',3,'LineStyle',':');
        xx = xlim(gca);
        yy= ylim(gca);
        plot(xx,[0 0],'black');
        plot([0 0],yy,'black');
        set(gca,'fontsize',16);
        xlabel('East-West $[m. s^{-1}]$','Fontsize',18);
        ylabel('North-South $[m. s^{-1}]$','Fontsize',18);
        axis([-12 12 -6 6]);

        AngleNotationradius=10;
        AngleNotationTheta=theta(1,1):0.01:0;
        AngleNotationX=0+AngleNotationradius*cos(AngleNotationTheta);
        AngleNotationY=0+AngleNotationradius*sin(AngleNotationTheta);
        %plot(AngleNotationX,AngleNotationY,'color','red','LineWidth',2);
        %annotation('textbox',[0.66 0.45 0.3 0.04],'String',strcat('\theta=',num2str(theta(1,1)*180/pi,2),'\circ'),'fontsize',20,'Color','red','EdgeColor','none','FontWeight','bold');

        AngleNotationradius=5;
        AngleNotationTheta=0:0.01:theta(1,2);
        AngleNotationX=0+AngleNotationradius*cos(AngleNotationTheta);
        AngleNotationY=0+AngleNotationradius*sin(AngleNotationTheta);
        plot(AngleNotationX,AngleNotationY,'color','blue','LineWidth',2);
        annotation('textbox',[0.801 0.523 0.0562 0.04],'String',strcat('\theta=',num2str(theta(1,2)*180/pi,2),'\circ'),'fontsize',20,'Color','blue','EdgeColor','none','FontWeight','bold');

        legend([MaxVariationDirectionH,MinVariationDirectionH],'$Max$','$Min$','Location','northoutside','Orientation','horizontal','FontSize',16);
        
        set(gca,'FontWeight','bold');
        hold off;
    end

end

dataout(:,1) = theta(:,3);
dataout(:,2) = theta(:,4);
dataout(:,3) = ellipticity';