function plot_theoretical_decoding(ds, decoding_results)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

aug_factor = 0;

transfer = isequal(class(ds),'generalization_DS'); 
    
for rep=1:50
    %[all_XTr, all_YTr, all_XTe, all_YTe] = augment_ds(ds, aug_factor); 
    [all_XTr, all_YTr, all_XTe, all_YTe] = ds.get_data_MC;
    m=100;%length(all_YTr)/2;
    timebins = length(all_XTr);
    labels = unique(all_YTr);
    
    
    for timebin=1:timebins
        
        Xt = all_XTr{timebin}{1}'; 
        Xe = all_XTe{timebin}{1}'; 
        X1 = Xt(all_YTr==labels(1),:);
        X2 = Xt(all_YTr==labels(2),:);
        X3 = Xe(all_YTe==labels(1),:);
        X4 = Xe(all_YTe==labels(2),:);

        geom1 = extract_geometry(X1);
        geom2 = extract_geometry(X2);
        geom3 = extract_geometry(X3);
        geom4 = extract_geometry(X4);

        snr_t_A = SNR_T(geom1, geom2, geom3);
        snr_t_B = SNR_T(geom2, geom1, geom4);
        
        snr_A = SNR(geom1, geom2);
        snr_B = SNR(geom2, geom1);

        acc(timebin,rep,:) = [1-snr_A.error(m), 1-snr_B.error(m)];
        acc_T(timebin, rep,:) = [1-snr_t_A.error(m), 1-snr_t_B.error(m)];
    end
end

if transfer
    acc=acc_T;
end
%acc=acc_T;

theoretical_acc_mat = mean(acc,2);
snr_A_rep = acc(:,:,1);
snr_B_rep = acc(:,:,2);
theoretical_acc_mat=squeeze(theoretical_acc_mat);
theoretical_acc = mean(theoretical_acc_mat,2);

figure;
hold on;
h=plot(1:timebins, [theoretical_acc, theoretical_acc_mat], '-', 'LineWidth',2);

h(1).Color = '#EDB120';
h(2).Color = '#0072BD';
h(3).Color = '#A2142F';

if transfer
    legend('Theory Accuracy', ['Theory recall: ', ds.the_test_label_names{labels(1)}{1}], ['Theory recall: ', ds.the_test_label_names{labels(2)}{1}],'AutoUpdate','off', 'Interpreter', 'none');
    set(gca,'ColorOrderIndex',1)
end

shadedErrorBar(1:timebins,mean([snr_A_rep,snr_B_rep]'), sem([snr_A_rep,snr_B_rep]'),{'color',h(1).Color},0.5)
shadedErrorBar(1:timebins,mean(snr_A_rep'), sem(snr_A_rep'),{'color',h(2).Color},0.5)
shadedErrorBar(1:timebins,mean(snr_B_rep'), sem(snr_B_rep'),{'color',h(3).Color},0.5)


if transfer && nargin>1
    confusion_matrix= decoding_results.DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.confusion_matrix_results.confusion_matrix;
    empirical_acc_mat = [confusion_matrix(1,1,:)./sum((confusion_matrix(:,1,:))),...
        confusion_matrix(2,2,:)./sum((confusion_matrix(:,2,:)))];

    plot(1:timebins, [squeeze(mean(empirical_acc_mat,2)), squeeze(empirical_acc_mat)'], '-', 'LineWidth',2)
    legend('Theory Accuracy', ['Theory recall', ds.the_test_label_names{labels(1)}{1}], ['Theory recall: ', ds.the_test_label_names{labels(2)}{1}],...
        'Empirical Accuracy', ['Empirical recall', ds.the_test_label_names{labels(1)}{1}], ['Empirical recall: ', ds.the_test_label_names{labels(2)}{1}],'AutoUpdate','off', 'Interpreter', 'none')
end

plot(1:timebins, repmat(0.5,timebins, 1) , 'k', 'LineWidth',1)
hold off;

event = ds.get_DS_properties.binned_site_info.event{1};
subtitle(['Event: ', event, ' Tar.: ' , ds.label, ' Label rep.: ', num2str(ds.num_times_to_repeat_each_label_per_cv_split),' m: ', num2str(m), ...
    ' #Cells: ', num2str(length(ds.sites_to_use)), ' Augmentation factor: ', num2str(aug_factor), ' Tr/Te: ',num2str(length(all_YTr)),'/',num2str(length(all_YTe))]);


end

