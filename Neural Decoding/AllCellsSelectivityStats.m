
% agg_results = [responsive_per1, responsive_per2, selective_per1, selective_per2...
%     ss_per lms_per nms_per]


%labels = [{'ArmType'},{'Rewarded'}];

stats_per_event_stage_rat = [];

%for event=[{'ITI'}, {'NP'}, {'Ain'}, {'Bin'}, {'Aout'}]
for event=[{'Bin'}]
    for stage=[{'odor1'}, {'odor2_W'}, {'odor2_X'}]
        for rat=[{'rat6'}, {'rat8'}, {'rat10'}, {'rat11'}]
            [~ ,agg_results] = CellsSelectivityStats(event{:}, [{'ArmType'},{'Rewarded'}], stage{:}, rat{:});
            responsivity = max([agg_results(1), agg_results(2)]);
            sel_ArmType = agg_results(3);
            sel_Rewarded = agg_results(4);
            NMS_AT_R = agg_results(7);
            [~ ,agg_results] = CellsSelectivityStats(event{:}, [{'ArmType'},{'NPRewarded'}], stage{:}, rat{:});
            responsivity = max([responsivity, agg_results(1), agg_results(2)]);
            sel_NPRewarded = agg_results(4);
            NMS_AT_NPR = agg_results(7);
            [~ ,agg_results] = CellsSelectivityStats(event{:}, [{'Chosen'},{'Rewarded'}], stage{:}, rat{:});
            responsivity = max([responsivity, agg_results(1)]);
            sel_Chosen = agg_results(3);
            NMS_CH_R=agg_results(7);
            
            stats_per_event_stage_rat = [stats_per_event_stage_rat; event,stage,rat,agg_results(8), responsivity, sel_ArmType, ...
                sel_NPRewarded, sel_Rewarded, sel_Chosen, NMS_AT_NPR, NMS_AT_R, NMS_CH_R ];
        end
    end
end

%for event=[{'ITI'}, {'NP'}, {'Ain'}, {'Bin'}, {'Aout'}]
for event=[{'Bin'}]
    means = [];
    sems = [];
    for stage=[{'odor1'}, {'odor2_W'}, {'odor2_X'}]
        event_col = stats_per_event_stage_rat(:,1);
        stage_col = stats_per_event_stage_rat(:,2);
        rows = stats_per_event_stage_rat(strcmp(event_col,event{:}) & strcmp(stage_col,stage{:}), :);
        means=[means; mean(cell2mat(rows(:,5:end)))];
        sems =[sems; sem(cell2mat(rows(:,5:end)))]; 
    end
    showStatsBars(event{:}, means, sems)
end

