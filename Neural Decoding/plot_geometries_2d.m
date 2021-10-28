function [geom1,geom2,geom3,geom4] = plot_geometries_2d(X1,X2,X3,X4)
    
set(0,'DefaultFigurePosition', [25 550 500 400]);
set(0,'DefaultAxesFontSize', 12);
set(0,'DefaultAxesFontName', 'Helvetica');
set(0,'DefaultAxesFontWeight','bold');
set(0,'DefaultAxesLineWidth',2);
set(0,'DefaultLineLineWidth',2);
set(0,'DefaultLineMarkerSize',8);

geom1 = extract_geometry(X1);
geom2 = extract_geometry(X2);
geom3 = extract_geometry(X3);
geom4 = extract_geometry(X4);

hold on;
h1=plot_gaussian_ellipsoid(geom1.centroid,cov(X1),2.0); 
h2=plot_gaussian_ellipsoid(geom2.centroid,cov(X2),2.0);
h3= plot_gaussian_ellipsoid(geom3.centroid,cov(X3),2.0);
h4= plot_gaussian_ellipsoid(geom4.centroid,cov(X4),2.0);

set(h1,'color','#0072BD');
set(h2,'color','#A2142F');


set(h3,'color','#0072BD');
set(h4,'color','#A2142F');
set(h3,'LineStyle',':');
set(h4,'LineStyle',':');


%set(gca,'proj','perspective');  
%grid on; 

scatter(X1(:,1),X1(:,2),'MarkerEdgeColor','#0072BD','Marker','o')
scatter(X2(:,1),X2(:,2),'MarkerEdgeColor','#A2142F','Marker','o')
scatter(X3(:,1),X3(:,2),'MarkerEdgeColor','#0072BD','Marker','x')
scatter(X4(:,1),X4(:,2),'MarkerEdgeColor','#A2142F','Marker','x')


axis equal; %axis tight;
hold off;
legend('A(Train)', 'B(Train)', 'A(Test)', 'B(Test)' ,'A(Train)', 'B(Train)', 'A(Test)', 'B(Test)', 'AutoUpdate','off')

signal = [geom1.centroid;geom3.centroid;geom2.centroid];
line(signal(:,1),signal(:,2),'Color','#7E2F8E','LineStyle','-', 'Marker', 'o')

end
