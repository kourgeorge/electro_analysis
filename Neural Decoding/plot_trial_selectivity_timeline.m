function plot_trial_selectivity_timeline(byStage,fromResp)

if nargin < 1
    byStage = 1;  %stage by stage
    fromResp = 1;
elseif nargin <2
    fromResp = 1; %shows selectivity only from cells that were considered responsive in particular bin
end

if byStage
    stages = {'odor1','odor2_WR','odor2_XFR'};
else
    stages= {'All'};
end
events = {'ITI','NP','Ain','Bin','Aout'};
labels = {'ArmType','Chosen','Rewarded','NPRewarded'};
colors{1} = [75 0 130; 123 104 238; 139 0 139;218 112 214]/255;
colors{2} = [25 25 12; 15 105 225; 135 206 235;72 209 204]/255;
colors{3} = [34 139 34; 50 205 50; 60 179 113;107,142,35]/255;
colors{4} = [139 0 0; 178 34 34; 240 128 128;255 140 0]/255;
min_cells = 5;
break_length = 4;
bin_size = 50;
event_times = [];
for f = 1:length(labels)*2
    figure(f)
    hs((f-1)*2+1) = subplot(2,1,1);
    hold on;
    box off;
    grid off;
    hs((f-1)*2+2) = subplot(2,1,2);
    hold on;
    box off;
    grid off;
    
end
for s = 1:length(stages)
    if fromResp
        fname = ['~/Dropbox/documents/papers/NadineMotivation/Selectivity/TimeLine/timelines_BL4_TL10_bonferroni_',stages{s}];
    else
        fname = ['~/Dropbox/documents/papers/NadineMotivation/Selectivity/TimeLine/timelines_BL4_TL10_bonferroni_',stages{s},'_fromAll_min100'];
    end
    dat = load(fname);
    f = 0;
    for l = 1:length(labels)
        f=f+1;
        trial_time = [];
        resp.(labels{l}) = [];
        sel.(labels{l}) = [];
        NMS_Rewarded.(labels{l}) = [];
        NMS_NPRewarded.(labels{l}) = [];
        conf_resp.(labels{l}) = [];
        conf_sel.(labels{l}) = [];
        conf_NMS_Rewarded.(labels{l}) = [];
        conf_NMS_NPRewarded.(labels{l}) = [];
        time_shift = 0;
        for e = 1:length(events)
            if fromResp
                invalid_indices = find(dat.num_resp.(labels{l}).(events{e}) < min_cells);
            else
                invalid_indices = [];
            end
            resp_seg = dat.resp_timeline.(labels{l}).(events{e});
            conf_resp_seg = dat.conf_resp_timeline.(labels{l}).(events{e})*100;
            sel_seg = dat.sel_timeline.(labels{l}).(events{e});
            conf_sel_seg = dat.conf_sel_timeline.(labels{l}).(events{e})*100;
            if strcmp(labels{l},'ArmType') || strcmp(labels{l},'Chosen')
                NMS_Rewarded_seg = dat.sel_timeline.([labels{l},'_Rewarded']).(events{e});
                NMS_NPRewarded_seg = dat.sel_timeline.([labels{l},'_NPRewarded']).(events{e});
                conf_NMS_Rewarded_seg = dat.conf_sel_timeline.([labels{l},'_Rewarded']).(events{e})*100;
                conf_NMS_NPRewarded_seg = dat.conf_sel_timeline.([labels{l},'_NPRewarded']).(events{e})*100;
                NMS_Rewarded_seg(invalid_indices) = nan;
                NMS_NPRewarded_seg(invalid_indices) = nan;
                conf_NMS_Rewarded_seg(invalid_indices) = nan;
                conf_NMS_NPRewarded_seg(invalid_indices) = nan;
            end
            sel_seg(invalid_indices) = nan;
            tv = [find(dat.time_vec == dat.cut.(events{e})(1)) find(dat.time_vec == dat.cut.(events{e})(2))];
            resp_seg = resp_seg(tv(1):tv(2));
            sel_seg = sel_seg(tv(1):tv(2));
            conf_resp_seg = conf_resp_seg(tv(1):tv(2));
            conf_sel_seg = conf_sel_seg(tv(1):tv(2));
            if strcmp(labels{l},'ArmType') || strcmp(labels{l},'Chosen')
                NMS_Rewarded_seg = NMS_Rewarded_seg(tv(1):tv(2));
                NMS_NPRewarded_seg = NMS_NPRewarded_seg(tv(1):tv(2));
                conf_NMS_Rewarded_seg = conf_NMS_Rewarded_seg(tv(1):tv(2));
                conf_NMS_NPRewarded_seg = conf_NMS_NPRewarded_seg(tv(1):tv(2));
            end
            time_seg = dat.time_vec(tv(1):tv(2));
            teINX = find(time_seg == 0);
            time_seg = (1:length(time_seg))*bin_size/1000+time_shift;
            te = time_seg(teINX);
            resp.(labels{l}) = [resp.(labels{l}) resp_seg nan(1,break_length)];
            sel.(labels{l}) = [sel.(labels{l}) sel_seg nan(1,break_length)];
            conf_resp.(labels{l}) = [conf_resp.(labels{l}) conf_resp_seg nan(1,break_length)];
            conf_sel.(labels{l}) = [conf_sel.(labels{l}) conf_sel_seg nan(1,break_length)];
            if strcmp(labels{l},'ArmType') || strcmp(labels{l},'Chosen')
                NMS_Rewarded.(labels{l}) = [NMS_Rewarded.(labels{l}) NMS_Rewarded_seg nan(1,break_length)];
                NMS_NPRewarded.(labels{l}) = [NMS_NPRewarded.(labels{l}) NMS_NPRewarded_seg nan(1,break_length)];
                conf_NMS_Rewarded.(labels{l}) = [conf_NMS_Rewarded.(labels{l}) conf_NMS_Rewarded_seg nan(1,break_length)];
                conf_NMS_NPRewarded.(labels{l}) = [conf_NMS_NPRewarded.(labels{l}) conf_NMS_NPRewarded_seg nan(1,break_length)];
            end
            
            trial_time = [trial_time time_seg time_seg(end)+(1:break_length)*bin_size/1000];
            event_times = [event_times te];
            time_shift = trial_time(end);
        end
        figure(f)
                plot(hs((f-1)*2+1),trial_time,resp.(labels{l}),'color',colors{l}(s,:));
%         shadedErrorBar(trial_time,resp.(labels{l}),conf_resp.(labels{l}),{'color',colors{l}(s,:)},1,hs((f-1)*2+1));
        ylabel('% responsive cells');
        xlabel('time, s');
                plot(hs((f-1)*2+2),trial_time,sel.(labels{l}),'color',colors{l}(s,:));
%         shadedErrorBar(trial_time,sel.(labels{l}),conf_sel.(labels{l}),{'color',colors{l}(s,:)},1,hs((f-1)*2+2));
        ylabel('% selective cells');
        xlabel('time, s');
        if s == 1
            suptitle(labels{l})
        end
        if s == 3
            legend(stages)
            plot(hs((f-1)*2+2),event_times,zeros(size(event_times)),'* b');
            plot(hs((f-1)*2+1),event_times,zeros(size(event_times)),'*b');
            
        end
        if strcmp(labels{l},'ArmType') || strcmp(labels{l},'Chosen')
            f=f+1;
            figure(f);
                        plot(hs((f-1)*2+1),trial_time,resp.(labels{l}),'color',colors{l}(s,:));
%             shadedErrorBar(trial_time,resp.(labels{l}),conf_resp.(labels{l}),{'color',colors{l}(s,:)},1,hs((f-1)*2+1));
            ylabel('% responsive cells');
            xlabel('time, s');
            box off
            grid off
                        plot(hs((f-1)*2+2),trial_time,NMS_Rewarded.(labels{l}),'color',colors{l}(s,:));
%             shadedErrorBar(trial_time,NMS_Rewarded.(labels{l}),conf_NMS_Rewarded.(labels{l}),{'color',colors{l}(s,:)},1,hs((f-1)*2+2));
            
            %         hold off;
            ylabel('% selective cells');
            xlabel('time, s');
            title(['NMS ',labels{l},' Rewarded'])
            if s == 1
                suptitle(labels{l})
            end
            if s== 3
                legend(stages)
                plot(hs((f-1)*2+1),event_times,zeros(size(event_times)),'*b');
                plot(hs((f-1)*2+2),event_times,zeros(size(event_times)),'* b');
            end
            f=f+1;
            figure(f);
                        plot(hs((f-1)*2+1),trial_time,resp.(labels{l}),'color',colors{l}(s,:));
%             shadedErrorBar(trial_time,resp.(labels{l}),conf_resp.(labels{l}),{'color',colors{l}(s,:)},1,hs((f-1)*2+1));
            
            ylabel('% responsive cells');
            xlabel('time, s');
                        plot(hs((f-1)*2+2),trial_time,NMS_NPRewarded.(labels{l}),'color',colors{l}(s,:));
%             shadedErrorBar(trial_time,NMS_NPRewarded.(labels{l}),conf_NMS_NPRewarded.(labels{l}),{'color',colors{l}(s,:)},1,hs((f-1)*2+2));
%             
            ylabel('% selective cells');
            xlabel('time, s');
            title(['NMS ',labels{l},' NPRewarded'])
            box off
            grid off
            if s==1
                suptitle(labels{l})
            end
            if s == 3
                legend(stages)
                plot(hs((f-1)*2+1),event_times,zeros(size(event_times)),'*b');
                plot(hs((f-1)*2+2),event_times,zeros(size(event_times)),'* b');
                
            end
        end
    end
end

