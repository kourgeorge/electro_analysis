function dimensionality()
%DIMENSIONALITY Investigate the dimensionality of the neural data.

raster_folder = '/Users/gkour/Box/phd/Electro_Rats/Rasters_100ms_8';

[X_stage1] = create_stage_pseudo_population(raster_folder, 40, 'odor1_WR');
[X_stage2] = create_stage_pseudo_population(raster_folder, 40, 'odor2_WR');
[X_stage3] = create_stage_pseudo_population(raster_folder, 40, 'odor2_XFR');

[Adata_stage1,~] = get_ICA_components_learning2(X_stage1,40);
[Adata_stage2,~] = get_ICA_components_learning2(X_stage2,40);
[Adata_stage3,~] = get_ICA_components_learning2(X_stage3,40);

[coeff,score1,latent,~,explained1] = pca(Adata_stage1,'Economy', false );
[coeff,score2,latent,~,explained2] = pca(Adata_stage2,'Economy', false );
[coeff,score3,latent,~,explained3] = pca(Adata_stage3,'Economy', false );

explained1 = cumsum(explained1);
explained2 = cumsum(explained2);
explained3 = cumsum(explained3);

figure;
hold on;
scatter(score3(:,1),score3(:,2))
scatter(score1(:,1),score1(:,2))
scatter(score2(:,1),score2(:,2))
hold off;

plot([explained1,explained2,explained3])
legend('stage1', 'stage2', 'stage3')
title("Explained PCA variance vs. num LC for each stage.")


label = 'CorrectArm2';
% [X_LDA_stage1, labels1] = create_stage_labeled_pseudo_population(raster_folder, 20, 'odor1_WR', 'CorrectArm1');
% [X_LDA_stage2, labels2] = create_stage_labeled_pseudo_population(raster_folder, 20, 'odor2_WR', 'CorrectArm1');
% [X_LDA_stage3, labels3] = create_stage_labeled_pseudo_population(raster_folder, 20, 'odor2_XFR', label);
% 
% [Adata_LDA_stage1,~] = get_ICA_components_learning2(X_LDA_stage1,20);
% [Adata_LDA_stage2,~] = get_ICA_components_learning2(X_LDA_stage2,20);
% [Adata_LDA_stage3,~] = get_ICA_components_learning2(X_LDA_stage3,20);
% 
% explained1=LDA_explained(Adata_LDA_stage1, labels1);
% explained2=LDA_explained(Adata_LDA_stage2, labels2);
% explained3=LDA_explained(Adata_LDA_stage3, labels3);
plot([explained1,explained2,explained3])
legend('stage1', 'stage2', 'stage3')
title(["explained LDA variance vs. num LC on label ",label])

end


function [pseudo_population] = create_stage_pseudo_population(raster_folder, num_cells, stage)

stage_rasters = get_rasters(raster_folder,'All', stage);
map = EnoughRepeats(stage_rasters);

pseudo_population = [];

k = find([map{:,2}]>=num_cells, 1, 'last');
trials = map{k,1};
cells = map{k,3};
cells = cells(randperm(num_cells));
    for i=1:num_cells
        celli = cells(i);
        pseudo_population = [pseudo_population, stage_rasters(celli).raster_data.BinnedRaster(1:trials,:)];
      
    end
end


function [pseudo_population, labels] = create_stage_labeled_pseudo_population(raster_folder, num_label_repeats, stage, label)

stage_rasters = get_rasters(raster_folder,'All', stage);

pseudo_population = [];
labels = []; 
cells = EnoughLabelsRepeats(stage_rasters, label, num_label_repeats);
num_cells = length(cells);
%cells = cells(randperm(num_cells));
for curr_label = getLabelValues(label)
    pseudo_population_value = [];
    for i=cells'
        celli = stage_rasters(i);
        trials_indx = find(celli.raster_labels.(label)==curr_label, num_label_repeats, 'first');
        pseudo_population_value = [pseudo_population_value, celli.raster_data.BinnedRaster(trials_indx,:)];
    end
    pseudo_population = [pseudo_population;pseudo_population_value];
    labels = [labels; repmat(curr_label,size(pseudo_population_value,1),1)];
end
end

function numTrialsToCells = EnoughRepeats(cells)

cell_num_trials = [];
numTrialsToCells = [];
map = [];
    for i=1:length(cells)
        cell_num_trials=[cell_num_trials,size(cells(i).raster_data.BinnedRaster,1)];
    end
    [B,I] = sort(cell_num_trials, 'desc');
    
    for M=unique(B)
        m_ind = find(cell_num_trials>=M);
        numTrialsToCells = [numTrialsToCells; M, numel(m_ind), {m_ind}];
    end
    
end



function rows_indx = EnoughLabelsRepeats(cells, label, trials_per_value)
%%% numTrialsToCells is a table [M,N,CellsM].
%%% M - Number of trials.
%%% N - number of cells having at least N trials per .
%%% CellsM - the indices of the cells having at least N trials. 

cell_num_trials = [];
numTrialsToCells = [];
label_values = getLabelValues(label);
label_count_cell = [];
    for i=1:length(cells)
        celli = cells(i);
        counts = histc(int8(celli.raster_labels.(label)), label_values);
        label_count_cell = [label_count_cell;counts'];
        %cell_num_trials=[cell_num_trials,size(cells(i).raster_data.BinnedRaster,1)];    
    end
    
    rows_indx = rows_larger(label_count_cell,trials_per_value);
    
end

function indx = rows_larger(mat, n)
indx = [];
for i=1:size(mat,1)
    if all(mat(i,:)>n)
        indx = [indx;i];
    end
end
end

function explained = LDA_explained(data,labels)

Mdl = fitcdiscr(data,labels,'DiscrimType','linear');

% try
%         Mdl = fitcdiscr(data,labels,'DiscrimType','linear');
%     catch
%         Mdl = fitcdiscr(data,labels,'DiscrimType','pseudolinear');
% end

eigen_values = flipud(eig(Mdl.Sigma));
explained = cumsum(eigen_values/sum(eigen_values)*100);

end

