global PROJECTS_DIR;

projectsFolder=fullfile('c:','users','user','desktop','flavia','experiment','march2016','RECORDING');
cd(projectsFolder);
rfolders=dir('RAT*');
for r=1:length(rfolders)
    ratname=rfolders(r).name;
    eval(['cd ',ratname,';']);
    suspectdays=dir([ratname,'_*']);
    days=[];
    for s=1:length(suspectdays)
        if suspectdays(s).isdir
            days=[days s];
        end
    end
    for d=days
        
        
        fldrstr=suspectdays(d).name;
        ev_file=fullfile(projectsFolder,ratname,fldrstr,'Events.nev');
        extractEvents(ev_file);
    end
end
