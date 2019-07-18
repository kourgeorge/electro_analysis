function  times= TimesDistancesFromEvent(timestamps, rat_x, rat_y, eventtime, bin_size, num_bin_around_event)
%DISTANCEFROMEVENT Summary of this function goes here
%   Detailed explanation goes here


rat_x(rat_x==0) = NaN;
rat_y(rat_y==0) = NaN;

% calculate the distance of the rat from the sensor location in all times
event_index = find(timestamps==eventtime);
event_location_x = rat_x(event_index);
event_location_y = rat_y(event_index);

d = sqrt((rat_x-event_location_x).^2+(rat_y-event_location_y).^2);

%make all distance before the event negative
%d(1:event_index) = -1* d(1:event_index);


times = [];
for bin_num=-num_bin_around_event:num_bin_around_event
    distance = bin_num*bin_size;
    last_time_in_distance = get_last_time_in_distance(event_index, d, distance);
    times = [times, last_time_in_distance];
end

end


function time_index = get_last_time_in_distance(event_index, d, distance)

eps = 0.001;
if d(event_index)> eps
    disp('The vector d and the event_index are not alligned');
end
 masked_d = d;
if distance<0
    masked_d(event_index:end) = NaN;
    distance = -distance;
    time_index = find(masked_d>=distance, 1, 'last');
else   
    masked_d(1:event_index) = Nan;
    time_index = find(masked_d>=distance, 1, 'first');
end



end