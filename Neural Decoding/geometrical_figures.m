function geometrical_figures()

set(0, 'DefaultLineLineWidth', 3);

config = get_config();
% rasters = fullfile(config.rasters_folder,'Rasters_allocentric');
% rasters = fullfile(config.rasters_folder,'Rasters_egocentric');
rasters = fullfile(config.rasters_folder,'Rasters_short');

event = 'ITI';
binSize = 150;
stepSize = 50;

transfer = 'Rewarded';
target = 'ArmType';

%%% this for comparing with the decoding classifier
[train_label_values, test_label_values] = partition_label_values(transfer, target);
numSplits = 5;
[decoding_results_path, shuffle_dir_name] = runClassifierPVal(rasters, event, 'Combination', binSize, stepSize, numSplits, ...
  [],train_label_values,test_label_values);
plotClassifierResults(decoding_results_path, shuffle_dir_name, ['Tran.: ',transfer, ' Tar.: ', target])


num_times_to_repeat_each_label_per_cv_split = 4;
ds = get_population_DS(rasters, event, [], 'Combination', 1, num_times_to_repeat_each_label_per_cv_split, binSize, stepSize, train_label_values, test_label_values);
%ds = get_population_DS(rasters, event, [], target, 1, 20, binSize, stepSize);

[all_XTr, all_YTr, all_XTe, all_YTe] = ds.get_data_MC;

R2a=[];
R2b=[];
R2c=[];
R2d=[];
error_a = [];
error_b = [];
error_t_c = [];
error_t_d = [];
error_t = [];
signal_noise_c =  [];
signal_noise_d = [];
timebins = length(all_XTr);

m = 16;

[all_XTr_reduced, all_XTe_reduced] = dimensionality_reduce_ds(ds);

h = figure;
for timebin=1:timebins
    
    Xt = all_XTr{timebin}{1}';
    Xt_red = all_XTr_reduced{timebin}{1}';
    
    X1 = Xt(all_YTr==1,:);
    X2 = Xt(all_YTr==2,:);
    X1_red = Xt_red(all_YTr==1,:);
    X2_red = Xt_red(all_YTr==2,:);
    
    
    Xe = all_XTe{timebin}{1}';
    Xe_red = all_XTe_reduced{timebin}{1}';
    X3 = Xe(all_YTe==1,:);
    X4 = Xe(all_YTe==2,:);
    X3_red = Xe_red(all_YTe==1,:);
    X4_red = Xe_red(all_YTe==2,:);
    
    geom1 = extract_geometry(X1);
    geom2 = extract_geometry(X2);
    geom3 = extract_geometry(X3);
    geom4 = extract_geometry(X4);
    
    R2a(timebin)=sum(geom1.Ri.^2);
    R2b(timebin)=sum(geom2.Ri.^2);
    R2c(timebin)=sum(geom3.Ri.^2);
    R2d(timebin)=sum(geom4.Ri.^2);
    
    snr_A= SNR(geom1, geom2);
    snr_B= SNR(geom2, geom1);
    
    snr_c= SNR_T(geom1, geom2, geom3);
    snr_d= SNR_T(geom2, geom1, geom4);
    
  
    error_a(timebin) = snr_A.error(m);
    error_b(timebin) = snr_B.error(m);
    error_t_c(timebin) = snr_c.error(m);
    error_t_d(timebin) = snr_d.error(m);
    error_t(timebin) = mean([snr_c.error(m),snr_d.error(m)]);
    
    signal_c = snr_c.signal+snr_c.bias_v/m;
    signal_d = snr_d.signal+snr_d.bias_v/m;
    css_c = snr_c.noise_B_along_BC_v/m + snr_c.noise_A_along_AC_v/m+ snr_c.noise_C_along_AB_v;
    css_d = snr_d.noise_B_along_BC_v/m + snr_d.noise_A_along_AC_v/m+ snr_d.noise_C_along_AB_v;
    noise_c = sqrt(css_c + snr_c.noise_noise_ca/m +snr_c.noise_noise_cb/m);
    noise_d = sqrt(css_d + snr_d.noise_noise_ca/m +snr_d.noise_noise_cb/m);
    
    
    signal_noise_c = [signal_noise_c; [signal_c, noise_c]];
    signal_noise_d = [signal_noise_d; [signal_d, noise_d]];
    
    
    subplot(4,4,timebin)
    plot_geometries_2d(X1_red,X2_red,X3_red,X4_red)
    %plot_geometries_2d(X_2,X_1,X_4,X_3)
    %title(['TimeBin: ', num2str(timebin), ' signalC: ', num2str(signal_c), ' signalD: ', num2str(signal_d)])
    xlim([-5e-2, 5e-2])
    ylim([-5e-2, 5e-2])
    title(['TimeBin: ', num2str(timebin), ' Acc.: ', num2str(1-snr_c.error(m),2), ' Noise_A:', num2str(snr_c.noise_A_along_AC_v*1e4)])
    
    
    
end
suptitle(['Event: ', event, ' Tran.: ',transfer, ' Tar.: ', target])
figure;

% scatter(signal_noise_c(:,1), signal_noise_c(:,2), 50, 1:timebins, 'filled')
% xlabel('Signal')
% ylabel('Noise')
% title('SNR - geom C given geom A and B')
% colormap('winter');
% colorbar;
% figure;
% 
% scatter(signal_noise_d(:,1), signal_noise_d(:,2), 50, 1:timebins, 'filled')
% xlabel('Signal')
% ylabel('Noise')
% colormap('autumn');
% title('SNR - geom D given geom B and A')
% colorbar;


% figure;
% hold on
% plot(1:timebins, R2a)
% plot(1:timebins, R2b)
% plot(1:timebins, R2c)
% plot(1:timebins, R2d)
% legend('a','b','c', 'd')
% hold off

figure;
hold on
plot(1:timebins, 1-error_a)
plot(1:timebins, 1-error_b)
plot(1:timebins, 1-error_t_c)
plot(1:timebins, 1-error_t_d)
plot(1:timebins, 1-error_t)
legend('acc_a','acc_b','acc_t_c','acc_t_d','acc_t')
hold off

%num_times_to_repeat_each_label_per_cv_split = 10;
%ds = get_population_DS(rasters, event, [], 'Combination', 1, num_times_to_repeat_each_label_per_cv_split, binSize, stepSize, train_label_values, test_label_values);
plot_population(ds,3)

end
