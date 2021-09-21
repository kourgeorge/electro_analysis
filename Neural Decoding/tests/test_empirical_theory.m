function test_empirical_theory()
%TEST_EMPIRICAL_THEORY We compare the classifir accuracy predicted and
%actual results for the transfer and non-transfer case.
%   Detailed explanation goes here

addpath '/Users/gkour/drive/PhD/events_analysis/Neural Decoding';
close all;

compare_train_test_geometry_differences('ITI', 'ArmType', 9)
test_manifold_geometry_estimation_stability_on_neural_population('ITI', 'ArmType', 9)
compare_theory_empirical_non_transfer('Bin', 'ArmType')
compare_theory_empirical_transfer('ITI', 'ArmType', 'Rewarded')

end

function compare_train_test_geometry_differences(event, target, timebin)
% The goal of this test is to investigate the difference between the train
% and test geometries.

config = get_config();
rasters = fullfile(config.rasters_folder,'Rasters_short'); 

binSize = 150;
stepSize = 50;
numSplits = 1;

ds = get_population_DS(rasters, event, [], target, 1, 4, binSize, stepSize);
[all_XTr, all_YTr, all_XTe, all_YTe] = ds.get_data_MC;

Xt = all_XTr{timebin}{1}';
Xe = all_XTe{timebin}{1}';
X1 = [Xt(all_YTr==1,:)];
X2 = [Xt(all_YTr==2,:)];
X3 = Xe(all_YTe==1,:);
X4 = Xe(all_YTe==2,:);

geom1 = extract_geometry(X1);
geom2 = extract_geometry(X2);
geom3 = extract_geometry(X3);
geom4 = extract_geometry(X4);

SNR_AA = SNR(geom1, geom3);
SNR_AB= SNR(geom1, geom2);




end

function test_manifold_geometry_estimation_stability_on_neural_population(event, target, timebin)
%%% Check the stability of the geometry estimation by performing geometry
%%% estimation many times and calcualte the mean vs the std of the SNR.


num_times_to_repeat_each_label_per_cv_split = 10;

config = get_config();

rasters = fullfile(config.rasters_folder,'Rasters_short'); 

binSize = 150;
stepSize = 50;
numSplits = 1;

ds = get_population_DS(rasters, event, [], target, numSplits,num_times_to_repeat_each_label_per_cv_split, binSize, stepSize);

aug_factor = 3;
for rep=1:100
    [all_XTr_aug, all_YTr_aug, all_XTe_aug, all_YTe_aug] = ds.get_data_MC();
    %[all_XTr_aug, all_YTr_aug, all_XTe_aug, all_YTe_aug] = augment_ds(ds,aug_factor);
    
    Xt = all_XTr_aug{timebin}{1}'; 
    Xe = all_XTe_aug{timebin}{1}'; 
    X1 = Xt(all_YTr_aug==1,:);
    X2 = Xt(all_YTr_aug==2,:);
    
    geom1 = extract_geometry(X1);
    geom2= extract_geometry(X2);
    
     snr = SNR(geom1, geom2);
     geoms1(rep,:) = [snr.snr(5), snr.error(5), snr.signal, snr.bias, snr.dim, snr.signal_noise_overlapA, snr.signal_noise_overlapB, snr.noise_noise ];
     
     snr = SNR(geom2, geom1);
     geoms2(rep,:) = [snr.snr(5), snr.error(5), snr.signal, snr.bias, snr.dim, snr.signal_noise_overlapA, snr.signal_noise_overlapB, snr.noise_noise ];
end

mean(geoms1)
std(geoms1)

% 
% mean(geoms2)
% std(geoms2)
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

aug_factor = 3;
%[all_XTr, all_YTr, all_XTe, all_YTe] = augment_ds(ds, aug_factor);
[all_XTr, all_YTr, all_XTe, all_YTe] = ds.get_data_MC;

timebins = length(all_XTr);
m=length(all_YTe)/2;

for timebin=1:timebins
    
    acc = [];
    for rep=1:50
        
        %[all_XTr, all_YTr, all_XTe, all_YTe] = augment_ds(ds, aug_factor);
        
        [all_XTr, all_YTr, all_XTe, all_YTe] = ds.get_data_MC;
        
        Xt = all_XTr{timebin}{1}'; 
        Xe = all_XTe{timebin}{1}'; 
        X1 = [Xt(all_YTr==1,:)];
        X2 = [Xt(all_YTr==2,:)];
        X3 = Xe(all_YTe==1,:);
        X4 = Xe(all_YTe==2,:);

        geom1 = extract_geometry(X1);
        geom2 = extract_geometry(X2);
        geom3 = extract_geometry(X3);
        geom4 = extract_geometry(X4);

        snr_t_A = SNR_T(geom1, geom2, geom3);
        snr_t_B = SNR_T(geom2, geom1, geom4);

        acc(rep,:) = [1-snr_t_A.error(m), 1-snr_t_B.error(m)];
    end
    
     theoretical_acc_mat(timebin,:) = mean(acc);
     theoretical_acc(timebin) = mean([theoretical_acc_mat(timebin,1),theoretical_acc_mat(timebin,2)]);
        
    confusion_matrix= decoding_results.DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.confusion_matrix_results.confusion_matrix(:,:,timebin);
    empirical_acc_mat(timebin,:) = [confusion_matrix(1,1)/sum((confusion_matrix(:,1))),...
        confusion_matrix(2,2)/sum((confusion_matrix(:,2)))];
end

figure
hold on;
plot(1:timebins, [empirical_acc, empirical_acc_mat])
set(gca,'ColorOrderIndex',1)
plot(1:timebins, [theoretical_acc', theoretical_acc_mat], ':')

plot(1:timebins, repmat(0.5,timebins, 1) , 'k', 'LineWidth',1)
legend('empirical', 'empiricalA', 'empiricalB', 'theory','theoryA', 'theoryB')
hold off;

title(['Event: ', event, ' Tar.: ' , target ]);
subtitle(['Label rep.: ', num2str(ds.num_times_to_repeat_each_label_per_cv_split),' m: ', num2str(m), ...
    ' #Cells: ', num2str(length(ds.sites_to_use)), ' Augmentation factor: ', num2str(aug_factor)]);

ylim([0.1,0.9])
hold off;
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

    geom1 = extract_geometry(X1);
    geom2 = extract_geometry(X2);

    geom3 = extract_geometry(X3);
    geom4 = extract_geometry(X4);

    
    snr_t_A = SNR_T(geom1, geom2, geom3);
    snr_t_B = SNR_T(geom2, geom1, geom4);
    
    theoretical_acc_mat(timebin,1) = 1-snr_t_A.error(m);
    theoretical_acc_mat(timebin,2) = 1-snr_t_B.error(m);
    
    theoretical_acc(timebin) = mean([theoretical_acc_mat(timebin,1),theoretical_acc_mat(timebin,2)]);
    
    confusion_matrix= decoding_results.DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.confusion_matrix_results.confusion_matrix(:,:,timebin);
    empirical_acc_mat(timebin,:) = [confusion_matrix(1,1)/sum((confusion_matrix(:,1))),...
        confusion_matrix(2,2)/sum((confusion_matrix(:,2)))];
   
    
    
    
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