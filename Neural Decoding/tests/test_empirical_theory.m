function test_empirical_theory()
%TEST_EMPIRICAL_THEORY We compare the classifir accuracy predicted and
%actual results for the transfer and non-transfer case.
% We expect that when the population are 
%   Detailed explanation goes here
%close all;

addpath '/Users/gkour/drive/PhD/events_analysis/Neural Decoding';

%compare_theory_empirical_non_transfer('Bin', 'ArmType')
%compare_theory_empirical_non_transfer('ITI', 'ArmType')

compare_theory_empirical_transfer('ITI', 'ArmType', 'Rewarded')
end



function compare_theory_empirical_non_transfer(event, target)
config = get_config();

rasters = fullfile(config.rasters_folder,'Rasters_short'); 

binSize = 150;
stepSize = 50;
numSplits = 5;


[decoding_results_path, shuffle_dir_name, ds] = runClassifierPVal(rasters, event, target, binSize, stepSize, numSplits,[]);
plotClassifierResults(decoding_results_path, shuffle_dir_name,[])
decoding_results = load(decoding_results_path);

empirical_acc = decoding_results.DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.mean_decoding_results;

%ds = get_population_DS(rasters, event, [], target, 1, 4, binSize, stepSize);
%[all_XTr, all_YTr_aug, all_XTe_aug, all_YTe_aug] = ds.get_data_MC;
%[X,Y] = augment_pseudo_population(all_XTr{1}{1}', all_YTr, 3);


[all_XTr_aug, all_YTr_aug, all_XTe_aug, all_YTe_aug] = augment_ds(ds,3);
timebins = length(all_XTr_aug);

plot_population(ds,6)
m=length(all_YTe_aug)/2;

for timebin=1:timebins
    
    Xt = all_XTr_aug{timebin}{1}'; 
    Xe = all_XTe_aug{timebin}{1}'; 
    X1 = [Xt(all_YTr_aug==1,:);Xe(all_YTe_aug==1,:)];
    X2 = [Xt(all_YTr_aug==2,:);Xe(all_YTe_aug==2,:)];

    [geom1.centroid, geom1.D, geom1.U, geom1.Ri, geom1.N] = extract_geometry(X1);
    [geom2.centroid, geom2.D, geom2.U, geom2.Ri, geom2.N] = extract_geometry(X2);
    
    [snr, error_A, signal, bias, dim,signal_noise_overlapA, signal_noise_overlapB, noise_noise ] = SNR(geom1, geom2);
    [snr, error_B, signal, bias, dim,signal_noise_overlapA, signal_noise_overlapB, noise_noise ] = SNR(geom2, geom1);
    
    theoretical_acc_1(timebin) = 1-error_A(m);
    theoretical_acc_2(timebin) = 1-error_B(m);
    theoretical_acc(timebin) = mean([theoretical_acc_1(timebin),theoretical_acc_2(timebin)]);
    
end

figure
hold on;
plot(1:timebins, [theoretical_acc_1',theoretical_acc_2',theoretical_acc'])
plot(1:timebins, empirical_acc)
legend('theor1','theor2','theor','empirical')
hold off;
%assert( isclose(theoretical_acc,empirical_acc))
end

function compare_theory_empirical_transfer(event, target, transfer)
config = get_config();

rasters = fullfile(config.rasters_folder,'Rasters_short'); 

binSize = 150;
stepSize = 50;
numSplits = 10;

[train_label_values, test_label_values] = partition_label_values(transfer, target);
[decoding_results_path, shuffle_dir_name, ds] = runClassifierPVal(rasters, event, 'Combination', binSize, stepSize, numSplits, ...
  [],train_label_values,test_label_values);
plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Tran.: ',transfer, ' Tar.: ', target])
decoding_results = load(decoding_results_path);
empirical_acc = decoding_results.DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.mean_decoding_results;

aug_factor = 3;

[all_XTr_aug, all_YTr_aug, all_XTe_aug, all_YTe_aug] = augment_ds(ds,aug_factor);

%[all_XTr_aug, all_YTr_aug, all_XTe_aug, all_YTe_aug] = ds.get_data_MC();

timebins = length(empirical_acc);

%plot_population(ds,6)


for timebin=1:timebins
    
    Xt = all_XTr_aug{timebin}{1}'; 
    Xe = all_XTe_aug{timebin}{1}'; 
    X1 = Xt(all_YTr_aug==1,:);
    X2 = Xt(all_YTr_aug==2,:);
    X3 = Xe(all_YTe_aug==1,:);
    X4 = Xe(all_YTe_aug==2,:);
    
    m = size(X1,1);

    [geom1.centroid, geom1.D, geom1.U, geom1.Ri, geom1.N] = extract_geometry(X1);
    [geom2.centroid, geom2.D, geom2.U, geom2.Ri, geom2.N] = extract_geometry(X2);

    [geom3.centroid, geom3.D, geom3.U, geom3.Ri, geom3.N] = extract_geometry(X3);
    [geom4.centroid, geom4.D, geom4.U, geom4.Ri, geom4.N] = extract_geometry(X4);

    
    [snr, error_A] = SNR_T(geom1, geom2, geom3);
    [snr, error_B] = SNR_T(geom2, geom1, geom4);
    
    theoretical_acc_mat(timebin,1) = 1-error_A(m);
    theoretical_acc_mat(timebin,2) = 1-error_B(m);
    
    theoretical_acc(timebin) = mean([theoretical_acc_mat(timebin,1),theoretical_acc_mat(timebin,2)]);
    
    confusion_matrix= decoding_results.DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.confusion_matrix_results.confusion_matrix(:,:,timebin);
    empirical_acc_mat(timebin,1) = confusion_matrix(1,1)/sum((confusion_matrix(:,1)));
    empirical_acc_mat(timebin,2) = confusion_matrix(2,2)/sum((confusion_matrix(:,2)));
   
    
    
    
end

figure
hold on;
plot(1:timebins, [empirical_acc, empirical_acc_mat])
set(gca,'ColorOrderIndex',1)
plot(1:timebins, [theoretical_acc', theoretical_acc_mat], ':')

plot(1:timebins, repmat(0.5,timebins, 1) , 'k', 'LineWidth',1)
legend('empirical', 'empiricalA', 'empiricalB', 'theory','theoryA', 'theoryB')
hold off;

title(['Event: ', event, ' Tran.: ', transfer, ' Tar.: ' , target ]);
subtitle(['Label rep.: ', num2str(ds.num_times_to_repeat_each_label_per_cv_split),' m: ', num2str(m), ...
    ' #Cells: ', num2str(length(ds.sites_to_use)), ' Augmentation factor: ', num2str(aug_factor)]);
%assert( isclose(theoretical_acc,empirical_acc))

end


function res = isclose(a,b)
% is a close to b.
    res = all(abs(a-b)./b<0.2);
end