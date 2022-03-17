load('\\jackie-analysis\e\Shay\AllDf_F_foranalysis.mat')
all = [];
for i = 1:63
curr = df_data{i}(:);
all(end+1:end+length(curr)) = curr;
end

close all;numberTotest=1000;

for i = 1:10
    p = randperm(length(all),numberTotest);
    x1 = all(p) -2*min(all(p));
    
%     my find distribution
%     pdca(i) = {fitdist(x1','Normal')};
%     pdca_gamma(i) = {fitdist(x1','Gamma')};
%     pdca_invG(i) = {fitdist(x1','InverseGaussian')};    
%     
%     x_values = min(x1):0.001:max(x1);
%     y = normpdf(x_values, pdca{i}.mu, pdca{i}.sigma);
%     figure;hold on;subplot(1,3,1);hold on;title('normal');
%     histogram(x1, 'Normalization', 'pdf', 'FaceAlpha',0.3);plot(x_values,y,'LineWidth',2);
%     x_values = min(x1):0.001:max(x1);
%     y = gampdf(x_values, pdca_gamma{i}.a, pdca_gamma{i}.b);
%     subplot(1,3,2);hold on;title('Gamma');
%     histogram(x1, 'Normalization', 'pdf', 'FaceAlpha',0.3);plot(x_values,y,'LineWidth',2);
%     y = pdf(pdca_invG{i}, x_values);
%     subplot(1,3,3);hold on;title('invG');
%     histogram(x1, 'Normalization', 'pdf', 'FaceAlpha',0.3);plot(x_values,y,'LineWidth',2);
%     logN_normal(i) = negloglik(pdca{i});logN_gamma(i) = negloglik(pdca_gamma{i});logN_invG(i) = negloglik(pdca_invG{i});
%     [~, bestSelected] = min([logN_normal(i), logN_gamma(i), logN_invG(i)]);
%     bestIndex(i, 1:3) = zeros(1,3);
%     bestIndex(i, bestSelected) = 1;

%     code for find best distribution
     F= fitmethis(x1);
end