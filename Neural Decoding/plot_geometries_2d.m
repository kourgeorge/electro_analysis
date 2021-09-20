function plot_geometries_2d(X1,X2,X3,X4)
    

geom1 = extract_geometry(X1);
geom2 = extract_geometry(X2);
geom3 = extract_geometry(X3);
geom4 = extract_geometry(X4);

hold on;
h1=plot_gaussian_ellipsoid(geom1.centroid,cov(X1)); 
h2=plot_gaussian_ellipsoid(geom2.centroid,cov(X2));
h3= plot_gaussian_ellipsoid(geom3.centroid,cov(X3));
h4= plot_gaussian_ellipsoid(geom4.centroid,cov(X4));

set(h1,'color','#0072BD');
set(h2,'color','#A2142F');

set(h3,'color','#0072BD');
set(h3,'LineStyle','-.');
set(h4,'color','#A2142F');
set(h4,'LineStyle','-.');


signal = [geom1.centroid;geom3.centroid;geom2.centroid];
line(signal(:,1),signal(:,2),'Color','#7E2F8E','LineStyle','-', 'Marker', 'o')
str = {'A simple plot','from 1 to 10'};

%set(gca,'proj','perspective');  
%grid on; 
axis equal; %axis tight;
hold off;

%legend('A', 'B', 'C', 'D')

end
