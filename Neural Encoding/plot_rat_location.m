
eventsfile = '.\rat6_mpfc_21.6events_g.mat';
load(eventsfile)
locationfile = '.\VT1.nvt';
[Timestamps, x,y, Header] = Nlx2MatVT(locationfile, [1 1 1 0 0 0], 1, 1, []);

sensors_locations = [-2,0; 2,0; 0,-2; 0,2 ] ; 

for i = 1:length(Timestamps)
    for j=1:length(sensors_locations)
         d(i,j) = calc_dist([x(i),y(i)],sensors_locations(j));
    end
end

num_events = size(Abeam_entrance,2);

distance = zeros(num_events, 11);

