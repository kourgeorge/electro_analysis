function runXtractLFP
rat{1}='RAT1';
rat{2}='RAT2';
rat{3}='RAT3';
rat{4}='RAT4';
rat{5}='RAT5';

% for r=1:length(rat)
for r=2:length(rat)
    clear dates Ch;
    
    switch rat{r}
        case 'RAT1'
            dates{1}='rat1_0605';
            Ch{1}=[29 32];
            
            
        case 'RAT2'
            dates{1}='rat2_0605';
            Ch{1}=31;
            dates{2}='rat2_0905';
            Ch{2}=32;
             dates{3}='rat2_0805';
            Ch{3}=32 ;
            dates{2}='rat2_0605(2)';
            Ch{2}=32;
           
            
        case 'RAT3'
            dates{1}='rat3_0605';
            Ch{1}=29;
            dates{2}='rat3_0905';
            Ch{2}=29 ;
             dates{3}='rat3_0805';
            Ch{3}=29 ;
            
        case 'RAT4'
            dates{1}='rat4_0605';
            Ch{1}=31;
            dates{2}='rat4_0905';
            Ch{2}=31;
            dates{3}='rat4_0805';
            Ch{3}=31;
            
        case 'RAT5'
            dates{1}='rat5_0605';
            Ch{1}=29;
            dates{2}='rat5_0805';
            Ch{2}=29;
            dates{3}='rat5_0905';
            Ch{3}=29;
            dates{4}='rat5_0905(2)';
            Ch{4}=29;
            
    end
    
    for d=1:length(dates)
        datestr=fullfile('c:/users/user/desktop/flavia/experiment/march2016/RECORDING',rat{r},dates{d});
        disp(['processing day ',num2str(d),' of ',num2str(length(dates)),' on rat ',num2str(r),' of ',num2str(length(rat))]);
        XtractLFP(datestr,Ch{d});
    end
    
end







