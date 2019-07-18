function [behave, st] = load_spikes_and_behavioral_data(ss_file_struct)

folder_name = regexp(ss_file_struct.folder,'\','split');
folder_name = folder_name{end};

ss_path = [ss_file_struct.folder,'\',ss_file_struct.name];
events_path = [ss_file_struct.folder,'\',folder_name,'events_g.mat'];

behave = load(events_path);


st=Nlx2MatSpike(ss_path,[1 0 0 0 0],0,1,[]);
%save(ss_path, st);

st = st / 1e6;

end