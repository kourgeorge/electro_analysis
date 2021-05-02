function plot_population(ds)
%PLOT_POPULATION Plot the neural population firinf rate.
%   Detailed explanation goes here

[all_XTr all_YTr all_XTe all_YTe] = ds.get_data;

for bin=[6]%1:length(all_XTr)
    
    for rep=1:length(all_XTr{bin})
        
        %XTr = all_XTr{bin}{rep}';
        %XTe = all_XTe{bin}{rep}';
        
        XTr = [all_XTr{bin}{1}';all_XTr{bin}{2}'];
        XTe = [all_XTe{bin}{1}';all_XTe{bin}{2}'];
        YTr = [all_YTr;all_YTr];
        YTe = [all_YTe;all_YTe]; 
        
        [num_vec, population_size] = size(XTr);
%         YTr = all_YTr;
%         YTe = all_YTe; 

        dim=get_dimensionality(XTr)
        dim2=get_dimensionality(XTe)
        
        %x_dm = DR_pca([XTr;XTe]);
        %x_t = x_dm(1:end-length(YTe),:);
        %x_e = x_dm(end-length(YTe)+1:end,:);
        
        
        [COEFF, SCORE] = pca(XTr);
        x_t = SCORE(:,1:2);
        x_e = XTe*COEFF;
        x_e= x_e(:,1:2);
        x_dm = [x_t;x_e];
        


        figure;
        gscatter(x_t(:,1),x_t(:,2),YTr, 'br','oo')
        hold on 
        gscatter(x_e(:,1),x_e(:,2),YTe,'br','xx')
        
        %%%%%%%MC%%%%%%%
        MC = max_correlation_coefficient_CL;
        MC = MC.train(x_t', YTr);

     
        scatter(MC.templates(1,1), MC.templates(1,2),'r', 'filled');
        scatter(MC.templates(2,1), MC.templates(2,2),'b', 'filled'); 
        
               %%%%SVM%%%% 
        SVM =libsvm_CL;
        SVM.kernel = 'linear';
        SVM = SVM.train(x_t', YTr);
        h = plot_svm_boundry(SVM, 0.8*min(x_dm(:,1)),0.8*max(x_dm(:,1)), 'g--');
        ylim([min(x_dm(:,2)), max(x_dm(:,2))])
        h.DisplayName = 'Train SVM';
        
        SVM2 =libsvm_CL;
        SVM2.kernel = 'linear';
        SVM2 = SVM2.train(x_e', YTe);
        h = plot_svm_boundry(SVM2, 0.8*min(x_dm(:,1)),0.8*max(x_dm(:,1)), 'c--');
        ylim([min(x_dm(:,2)), max(x_dm(:,2))])
        h.DisplayName = 'Test SVM';
          
        
%         %%%%%%%LDA%%%%%%%
%         MdlLinear = fitcdiscr(x_t,YTr);
%         K = MdlLinear.Coeffs(1,2).Const;  
%         L = MdlLinear.Coeffs(1,2).Linear;
%         f = @(x1,x2) K + L(1)*x1 + L(2)*x2;
%         h2 = fimplicit(f,[min(x_t(:,1)) max(x_t(:,1)) min(x_t(:,2)) max(x_t(:,2))]);
%         h2.Color = 'r';
%         h2.LineWidth = 2;
%         h2.DisplayName = 'Boundary between Versicolor & Virginica';

        
        
        
%         mdl = fitcsvm(x_t,YTr,'KernelFunction', 'linear');
%         y_hat_svm_m = predict(mdl,x_e);
%         x_p = linspace(min(x_t(:,1)),max(x_t(:,1)));
%         f = @(x_p) -(x_p*mdl.Beta(1) + mdl.Bias)/mdl.Beta(2);
%         y_p = f(x_p);
%         plot(x_p,y_p,'r--','LineWidth',2,'DisplayName','Boundary')

        [y_hat_mc, ~] = MC.test(x_e');
        [y_hat_svm, ~] = SVM.test(x_e');
        acc_MC = mean(y_hat_mc==YTe);
        acc_SVM = mean(y_hat_svm==YTe);

        hold off
        title(['Population size: ', num2str(population_size), '; N=', num2str(num_vec), ...
            ' ; bin', num2str(bin),' ; MC/SVM', num2str(acc_MC), '/', num2str(acc_SVM)])

    end
end

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

function x_dr = DR_pca(x)
    [COEFF, SCORE] = pca(x);
    x_dr = SCORE(:,1:2);
end

function dim = get_dimensionality(x)

[coeff,score,latent,tsquared,explained,mu] = pca(x);

dim = find(cumsum(explained)>95,1);

end