function lfparoundevents()
%set environment parameters
datafolder = '../data';
outputfolder = '../output';
error_line_color = 'g';


experimentsdays =[{'rat2_1104'},{'rat2_1204'},{'rat2_2504'},{'rat2_2604'},{'rat2_2704'}];

num_days = length(experimentsdays);
for i=1:length(experimentsdays)
    interval_len = 1000;
    electro_data_file = fullfile(datafolder,[experimentsdays{i},'dat.mat']);
    event_dat_file = fullfile(datafolder,[experimentsdays{i},'Events.nevevents.mat']);
    eval(['load ',electro_data_file]);
    eval(['load ',event_dat_file]);
    
    event = Abeam_entrance;
    [S_event, time] = getavglfpactivityaroundevent(lfp,timeVector,interval_len, event(:,2));
    subplot(num_days,3,3*(i-1)+1)
    plot_graph(time, S_event, error_line_color, size(event,1))
    
    event = Bbeam_entrance;
    [S_event, time] = getavglfpactivityaroundevent(lfp,timeVector,interval_len, event(:,2));
    subplot(num_days,3,3*(i-1)+2)
    plot_graph(time, S_event, error_line_color, size(event,1))
    
    event = NP;
    [S_event, time] = getavglfpactivityaroundevent(lfp,timeVector,interval_len, event(:,2));
    subplot(num_days,3,3*(i-1)+3)
    plot_graph(time, S_event, error_line_color, size(event,1))
    
end

suptitle('Average LFP activity for each day, for A-Beam, B-Beam and NP');

end

function plot_graph(time, S_event, error_line_color, num_events)
y = S_event;
plot(time,y(:,1))
hold on
plot(time, y(:,1) + y(:,2), error_line_color, time, y(:,1) - y(:,2), error_line_color,  'LineWidth', 0.01)
hold off
ax = gca;
ax.YLim = [-150 150];
line([0 0],ax.YLim,'Color','black', 'LineWidth', 0.1, 'LineStyle',':');
string = ['events count: ',num2str(num_events)];
title(string);
end