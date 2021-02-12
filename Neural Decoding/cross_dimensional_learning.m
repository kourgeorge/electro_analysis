%%   1.  Create strings listing where the toolbox and the tutoral data directories are and add the toolbox to Matlab's path

toolbox_dir = 'lib/ndt.1.0.4/';

raster_dir = '/Users/gkour/Box/phd/Electro_Rats/Rasters_100_augmented';


addpath(toolbox_dir)
add_ndt_paths_and_init_rand_generator



%%  2.   Bin the data using one 400 ms bin that starts 100 ms after the stimulus onset
event = 'Bin';
binSize = 150;
step_size = 50;

event_raster_dir = fullfile(raster_dir,event);

save_prefix_name = [event,'_Binned_',num2str(binSize),'ms_bins_',num2str(sampleWindow),'ms_sampled.mat'];
%save_prefix_name = 'save_prefix_name';
binned_data_file_name = create_binned_data_from_raster_data(event_raster_dir, save_prefix_name, binSize, step_size);%, start_time, end_time);

% augmented_binned_data_file_name = AugmentData(binned_data_file_name, label)

%%  3.  Create a classifier and a feature proprocessor object

the_classifier = max_correlation_coefficient_CL;
the_feature_preprocessors{1} = zscore_normalize_FP;  


%%  4. Let's first train the classifier to discriminate between objects at the upper location, and test the classifier with objects shown at the lower location


%%  4a.  create labels for which exact stimuli (ID plus position) belong in the training set, and which stimuli belong in the test set


% the_training_label_names = [{{'right_R_food', 'right_NR_food'}},...
%                             {{'right_R_water', 'right_NR_water'}}];          
% the_test_label_names = [{{'left_R_food', 'left_NR_food'}},...
%                             {{'left_R_water', 'left_NR_water'}}];
                       
the_training_label_names = [{{'left_R_food', 'left_NR_food'}},...
                            {{'left_R_water', 'left_NR_water'}}];
the_test_label_names= [{{'right_R_food', 'right_NR_food'}},...
                            {{'right_R_water', 'right_NR_water'}}];
                        
% the_training_label_names = [{{'right_R_food', 'left_R_food'}},...
%                             {{'left_R_water', 'right_R_water'}}];
% the_test_label_names = [{{'right_NR_food', 'left_NR_food'}},...
%                             {{'left_NR_water', 'right_NR_water'}}];


% the_training_label_names = [{{'right_NR_food', 'left_NR_food'}},...
%                             {{'left_NR_water', 'right_NR_water'}}];
% the_test_label_names = [{{'right_R_food', 'left_R_food'}},...
%                             {{'left_R_water', 'right_R_water'}}];
                        
% %y1
the_training_label_names = [{{'right_R_food', 'left_R_food'}},...
                           {{'right_NR_food', 'left_NR_food'}}];
the_test_label_names = [{{'right_R_water','left_R_water'}},...
                           {{'right_NR_water', 'left_NR_water'}}];
                        
%y2
% the_training_label_names = [{{'right_R_water','left_R_water'}},...
%                             {{'right_NR_water','left_NR_water'}}];
% the_test_label_names = [{{'right_R_food','left_R_food'}},...
%                             {{'right_NR_food','left_NR_food'}}];
%y3
the_training_label_names = [{{'right_R_food','right_R_water'}},...
                          {{'right_NR_food','right_NR_water'}}];
                      
the_test_label_names = [{{'left_R_food','left_R_water'}},...
                           {{'left_NR_food','left_NR_water'}}];

%y4
%the_training_label_names = [{{'left_R_food','left_R_water'}},...
%                            {{'left_NR_food','left_NR_water'}}];
%the_test_label_names = [{{'right_R_food','right_R_water'}},...
%                           {{'right_NR_food','right_NR_water'}}];


                        
%%  4b.  creata a generalization datasource that produces training data at the upper location, and test data at the lower location
num_cv_splits = 10;
 
toDecode = 'combination';  % use the combined ID and position labels

%if using augmeneted data need to provide the augmented file.
ds = generalization_DS(binned_data_file_name, toDecode , num_cv_splits, the_training_label_names, the_test_label_names);

% This can be replaced by my method "EnoughLabelsRepets".
[EnoughCells,EnoughCellsINX] = cellsWithEnoughRepetitions(getLabelValues(toDecode), ...
                                    ds.the_basic_DS.the_labels, num_cv_splits);
ds.sites_to_use = EnoughCellsINX;

ds.use_unique_data_in_each_CV_split = 0;

%%  4c. run a cross-validation decoding analysis that uses the generalization datasource we created to 
%         train a classifier with data from the upper location and test the classifier with data from the lower location

the_cross_validator = standard_resample_CV(ds, the_classifier, the_feature_preprocessors);
the_cross_validator.num_resample_runs = 2;
the_cross_validator.test_only_at_training_times = 1;

DECODING_RESULTS = the_cross_validator.run_cv_decoding();


% viewing the results suggests that they are above chance  (where chance is .1429)
DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.mean_decoding_results 

save(fullfile(raster_dir,[event,'_','combination','_Results']), 'DECODING_RESULTS');


plotClassifierResults(raster_dir, event, 'combination', num_cv_splits, EnoughCellsINX)


%%  5.  Training and Testing at all locations

% 
% mkdir position_invariance_results;  % make a directory to save all the results
% num_cv_splits = 18;
%  
% id_string_names = {'car', 'couch', 'face', 'kiwi', 'flower', 'guitar', 'hand'};
% pos_string_names = {'upper', 'middle', 'lower'};
%  
% for iTrainPosition = 1:3
%     
%    tic   % print how long it to run the results for training at one position (and testing at all three positions)
%     
%    for iTestPosition = 1:3
%  
%       % create the current labels that should be in the training and test sets 
%       for iID = 1:7
%             the_training_label_names{iID} = {[id_string_names{iID} '_' pos_string_names{iTrainPosition}]};
%             the_test_label_names{iID} =  {[id_string_names{iID} '_' pos_string_names{iTestPosition}]};
%       end
%  
%       % create the generalization datasource for training and testing at the current locations
%       ds = generalization_DS(binned_data_file_name, toDecode, num_cv_splits, the_training_label_names, the_test_label_names);       
%  
%       % create the cross-validator
%       the_cross_validator = standard_resample_CV(ds, the_classifier, the_feature_preprocessors);
%       the_cross_validator.num_resample_runs = 10;
%       
%       the_cross_validator.display_progress.zero_one_loss = 0;     % let us supress all the output from the cross-validation procedure
%       the_cross_validator.display_progress.resample_run_time = 0;
%                  
%       DECODING_RESULTS = the_cross_validator.run_cv_decoding;    % run the decoding analysis
%  
%       % save the results
%       save_file_name = ['position_invariance_results/Zhang_Desimone_pos_inv_results_train_pos' num2str(iTrainPosition) '_test_pos' num2str(iTestPosition)]; 
%       save(save_file_name, 'DECODING_RESULTS')
%  
%    end
%    
%    toc
%    
% end
% 
% 
% 
% 
% 
% 
% %% 6.  plot the results
% 
% 
% position_names = {'Upper', 'Middle', 'Lower'}
% 
% 
% for iTrainPosition = 1:3
%     
%     
%     % load the results from each training and test location
%     for iTestPosition = 1:3
%         
%         load(['position_invariance_results/Zhang_Desimone_pos_inv_results_train_pos' num2str(iTrainPosition) '_test_pos' num2str(iTestPosition)]);
%         all_results(iTrainPosition, iTestPosition) = DECODING_RESULTS.ZERO_ONE_LOSS_RESULTS.mean_decoding_results;
%     
%     end
%     
%     % create a bar plot for each training lcoation
%     subplot(1, 3, iTrainPosition)
%     bar(all_results(iTrainPosition, :) .* 100);
%     
%     title(['Train ' position_names{iTrainPosition}])
%     
%     ylabel('Classification Accuracy');
%     set(gca, 'XTickLabel', position_names)
%     xlabel('Test position')
%     
%     xLims = get(gca, 'XLim');
%     line([xLims], [1/7 1/7] .* 100, 'color', [0 0 0]);    % put a line at the chance level of decoding    
%     
% end
% 
% 
% set(gcf, 'position', [247   315   950   300])
% 
% 
% 
% 
% 
