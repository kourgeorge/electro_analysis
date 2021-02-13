function runSelectivityTimeLine(bl,tl,stages,fromResp)

global PROJECTS_DIR
if nargin < 1
    bl = 4;
    tl = 10;
    stages = {'odor1','odor2_WR','odor2_XFR'};
    fromResp = 1;
elseif nargin < 2
    tl = 10;
    fromResp = 1;
    stages = {'odor1','odor2_WR','odor2_XFR'};
elseif nargin < 3
    fromResp = 1;
    stages = {'odor1','odor2_WR','odor2_XFR'};
elseif nargin < 4
    fromResp = 1;
end
events = {'ITI','NP','Ain','Bin','Aout'};
events = fliplr(events);
labels1 = {'ArmType','Chosen'};
labels2 = {'Rewarded','NPRewarded'};
bl = 4;
tl = 10;%6;
correction = 'bonferroni';

cut.ITI = [-0.9 1];
cut.NP = [-0.5 1];
cut.Ain = [-0.5 0.5];
cut.Bin = [-0.5 1];
cut.Aout = [-0.5 1];
save_folder = fullfile(PROJECTS_DIR, 'documents','papers','NadineMotivation','Selectivity','TimeLine');
for s = 1:length(stages)
    stage = stages{s};
    if fromResp
        save_file = fullfile(save_folder,['timelines_BL',num2str(bl),'_TL',num2str(tl),'_',correction,'_',stage,]);
    else
        save_file = fullfile(save_folder,['timelines_BL',num2str(bl),'_TL',num2str(tl),'_',correction,'_',stage,'_fromAll_min100']);
    end
    for e = 1:length(events)
        for l1 = 1:length(labels1)
%             if ~(e == 2 && l1 == 2)
%                 continue
%             else
%                 disp('')
%             end
            for l2 = 1:length(labels2)
                [time_vec,resp1,resp2,resptot,sel1,sel2,NMS] = CellsSelectivityStatsTimeLine(events{e},{labels1{l1},labels2{l2}},bl,tl,correction,stage,0,0);
                resp_timeline.(labels1{l1}).(events{e}) = mean(resp1)*100;
                resp_timeline.(labels2{l2}).(events{e}) = mean(resp2)*100;
                conf_resp_timeline.(labels1{l1}).(events{e}) = conf_z(mean(resp1),size(resp1,2));
                conf_resp_timeline.(labels2{l2}).(events{e}) = conf_z(mean(resp2),size(resp2,2));
                num_resp.(labels1{l1}).(events{e}) = sum(resp1);
                num_resp.(labels2{l2}).(events{e}) = sum(resp2);
                num_cells.(labels1{l1}).(events{e}) = size(resp1,1);
                num_cells.(labels2{l2}).(events{e}) = size(resp2,1);
                if fromResp
                    sel_timeline.(labels1{l1}).(events{e}) = sum(sel1)./sum(resp1)*100;
                    sel_timeline.(labels2{l2}).(events{e}) = sum(sel2)./sum(resp2)*100;
                    sel_timeline.([labels1{l1},'_',labels2{l2}]).(events{e}) = sum(NMS)./sum(resptot)*100;
                else
                    sel_timeline.(labels1{l1}).(events{e}) = mean(sel1)*100;
                    sel_timeline.(labels2{l2}).(events{e}) = mean(sel2)*100;
                    sel_timeline.([labels1{l1},'_',labels2{l2}]).(events{e}) = mean(NMS)*100;
                end
                conf_sel_timeline.(labels1{l1}).(events{e}) = conf_z(sel_timeline.(labels1{l1}).(events{e})/100,size(sel1,2));
                if ~isreal(conf_sel_timeline.(labels1{l1}).(events{e}))
                    error('reached unreal number')
                end
                conf_sel_timeline.(labels2{l2}).(events{e}) = conf_z(sel_timeline.(labels2{l2}).(events{e})/100,size(sel2,2));
                conf_sel_timeline.([labels1{l1},'_',labels2{l2}]).(events{e}) = conf_z(sel_timeline.([labels1{l1},'_',labels2{l2}]).(events{e})/100,size(NMS,2));
            end
        end
    end
    
    save(save_file,'resp_timeline','sel_timeline','conf_resp_timeline','conf_sel_timeline','num_resp','num_cells','correction','time_vec','cut');
end
end
function conf = conf_z(data_vec,n)
z_star = 1.96; % for 95% confidence
for b = 1:size(data_vec,2)
    p = data_vec(b);
    conf(b) = z_star*sqrt((p*(1-p)/n));
end

end