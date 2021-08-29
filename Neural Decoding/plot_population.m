function plot_population(ds, bins)
%PLOT_POPULATION Plot the neural population firinf rate.
%   Detailed explanation goes here
%addpath('Users/gkour/drive/PhD/events_analysis/Neural Decoding/lib/drtoolbox')

% default for plots
set(0,'DefaultFigurePosition', [25 550 500 400]);
set(0,'DefaultAxesFontSize', 12);
set(0,'DefaultAxesFontName', 'Helvetica');
set(0,'DefaultAxesFontWeight','bold');
set(0,'DefaultAxesLineWidth',2);
set(0,'DefaultLineLineWidth',2);
set(0,'DefaultLineMarkerSize',8);
% Turn grid lines on by default
% set(0,'defaultAxesXGrid', 'on')
% set(0,'defaultAxesYGrid', 'on')
% set(0,'defaultAxesZGrid', 'on')


[all_XTr, all_YTr, all_XTe, all_YTe] = ds.get_data_MC;

for bin=bins
    
    for rep=1%:length(all_XTr{bin})
        
        
        XTr = all_XTr{bin}{1}';
        XTe = all_XTe{bin}{1}';
        YTr = all_YTr;
        YTe = all_YTe; 
        
        [num_vec, population_size] = size(XTr); 
        
        
        YX = [[YTr;YTe],[XTr;XTe]];
       
        X = [XTr;XTe];
        method = 'PCA';
        [XTr_XTe_reduced, mapping] = compute_mapping(X, method, 2);
        
        
        XTr_reduced = XTr_XTe_reduced(1:end-length(YTe),:);
        XTe_reduced = XTr_XTe_reduced(end-length(YTe)+1:end,:);
        
        
        %%%Plot the population in 2d%%%%%
        figure;
        gscatter(XTr_reduced(:,1),XTr_reduced(:,2),YTr, 'br','oo')
        hold on 
        gscatter(XTe_reduced(:,1),XTe_reduced(:,2),YTe, 'br','xx')
        
        %%%%%%%MC%%%%%%%
        MC = max_correlation_coefficient_CL;
        MC = MC.train(XTr_reduced', YTr);
        scatter(MC.templates(1,1), MC.templates(2,1),'r', 'filled');
        scatter(MC.templates(1,2), MC.templates(2,2),'b', 'filled'); 
        
        %%%%%%%SVM%%%%%%% 
        %%% Plot training hyperplane%%%
        SVM =libsvm_CL;
        SVM.kernel = 'linear';
        SVM = SVM.train(XTr_reduced', YTr);
        h = plot_svm_boundry(SVM, 0.8*min(XTr_XTe_reduced(:,1)),0.8*max(XTr_XTe_reduced(:,1)), 'g--');
        ylim([min(XTr_XTe_reduced(:,2)), max(XTr_XTe_reduced(:,2))])
        h.DisplayName = 'Train SVM';
        
        %%% Plot training hyperplane%%%
        SVM2 =libsvm_CL;
        SVM2.kernel = 'linear';
        SVM2 = SVM2.train(XTe_reduced', YTe);
        h = plot_svm_boundry(SVM2, 0.8*min(XTr_XTe_reduced(:,1)),0.8*max(XTr_XTe_reduced(:,1)), 'c--');
        ylim([min(XTr_XTe_reduced(:,2)), max(XTr_XTe_reduced(:,2))])
        h.DisplayName = 'Test SVM';

        %Calculate generatlization accuracy on reduced data %%%%%
        [y_hat_mc, ~] = MC.test(XTe_reduced');
        [y_hat_svm, ~] = SVM.test(XTe_reduced');
        acc_MC = mean(y_hat_mc==YTe);
        acc_SVM = mean(y_hat_svm==YTe);        
        title(['Population size: ', num2str(population_size), '; N=', num2str(num_vec), ...
            ' ; bin', num2str(bin),' ; MC/SVM:', num2str(acc_MC), '/', num2str(acc_SVM), ' ', ])
        
                
        legend('Train, label1','Train, label2','Test, label1','Test, label2','M label1', 'M labels2', 'Train boundary', 'Test boundary')
        hold off
       
        
        
        %%% Plot confusion matrix %%%%
        figure;
        subplot(2,2,1)
        y_pred_tr_te=SVM.test(XTe_reduced');
        C = confusionmat(YTe,y_pred_tr_te);
        heatmap(C)
        title('confusion of test data (reduced) on train SVM')
        
        subplot(2,2,2)
        y_pred_te_tr=SVM2.test(XTr_reduced');
        C = confusionmat(YTr,y_pred_te_tr);
        heatmap(C)
        title('confusion of train data (reduced) on test SVM')
        
        subplot(2,2,3)
        SVM = train_svm(XTr',YTr);
        y_pred=SVM.test(XTe');
        C = confusionmat(YTe,y_pred);
        heatmap(C)
        title('confusion of test data on train SVM')
        
        subplot(2,2,4)
        SVM = train_svm(XTe',YTe);
        y_pred=SVM.test(XTr');
        C = confusionmat(YTe,y_pred);
        heatmap(C)
        title('confusion of train data on test SVM')

    end
end

end


function model = train_svm(X,y)

SVM =libsvm_CL;
SVM.kernel = 'linear';
model = SVM.train(X, y);

end

function h = plot_svm_boundry(SVM, lim1,lim2,line)
w = SVM.model.SVs' * SVM.model.sv_coef;
b = -SVM.model.rho;

x_p = linspace(lim1,lim2);
f = @(x_p) (-1/w(2))*(w(1)*x_p + b);
y_p = f(x_p);
h = plot(x_p,y_p,line,'LineWidth',2,'DisplayName','Boundary');
end


function x_dr = DR_tsne(x)
    x_dr = tsne(x,'Algorithm','barneshut','NumPCAComponents',3);
end


function dim = get_dimensionality(x)

[coeff,score,latent,tsquared,explained,mu] = pca(x);

dim = find(cumsum(explained)>95,1);

end
