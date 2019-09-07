function [behave, st] = load_spikes_and_behavioral_data(ss_path)

folder_name = regexp(ss_path,'\','split');
folder_name = folder_name{end-1};
folder_path = fileparts(ss_path);

events_path = [folder_path,'\',folder_name,'events_g.mat'];

behave = load(events_path);


st=Nlx2MatSpike(ss_path,[1 0 0 0 0],0,1,[]);

st = st / 1e6;

end