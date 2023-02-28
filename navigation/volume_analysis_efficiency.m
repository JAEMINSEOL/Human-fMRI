clear all;clc;close all;

cd r:/ongoing/fmri_oppa/analysis/navigation
load('volume_perf_analysis_updated.mat');

cd('R:\ongoing\fmri_oppa\analysis\TS_analysis\behavior_index')
load('behavior_index_mat_201406.mat','behavior_index_mat')

cd r:/ongoing/fmri_oppa/analysis/navigation/volume_ei

% adj_data_mat=data_mat(~ismember(1:size(data_mat,1),[2 10]),:); 
adj_data_mat=data_mat;
adj_data_mat(:,6)=behavior_index_mat(:,13)./behavior_index_mat(:,15);


figure;%2nd epoch-lh hipp
scatter(adj_data_mat(:,3),adj_data_mat(:,6),'r','filled');hold on;
[B1,BINT1,R1,RINT1,ols_STATS1] = regress(adj_data_mat(:,6),[ones(16,1) adj_data_mat(:,3)]);
[robust_b_2L robust_stats_2L] = robustfit(adj_data_mat(:,3),adj_data_mat(:,6));
sse = robust_stats_2L.dfe * robust_stats_2L.robust_s^2;
phat = robust_b_2L(1)+robust_b_2L(2)*adj_data_mat(:,3);
ssr = norm(phat-mean(phat))^2;
r_robust_2L = sqrt(1 - sse / (sse + ssr));
plot(adj_data_mat(:,3),robust_b_2L(1)+robust_b_2L(2)*adj_data_mat(:,3),'r-','LineWidth',3)


scatter(adj_data_mat(:,4),adj_data_mat(:,6),'b','filled');hold on;
[B2,BINT1,R1,RINT1,ols_STATS1] = regress(adj_data_mat(:,6),[ones(16,1) adj_data_mat(:,4)]);
[robust_b_2R robust_stats_2R] = robustfit(adj_data_mat(:,4),adj_data_mat(:,6));
sse = robust_stats_2R.dfe * robust_stats_2R.robust_s^2;
phat = robust_b_2R(1)+robust_b_2R(2)*adj_data_mat(:,4);
ssr = norm(phat-mean(phat))^2;
r_robust_2R = sqrt(1 - sse / (sse + ssr));

plot(adj_data_mat(:,4),robust_b_2R(1)+robust_b_2R(2)*adj_data_mat(:,4),'b-','LineWidth',3)
title(strcat('p=',num2str(robust_stats_2L.p(2)),'r=',num2str(r_robust_2L),'p=',num2str(robust_stats_2R.p(2)),'r=',num2str(r_robust_2R)));
figurename='phase2_perf_by_left(red)_right(blue)_HPC.eps';
print('-dpsc2','-noui','-adobecset','-painters',figurename);



figure;%2nd epoch-total hipp
scatter(adj_data_mat(:,5),adj_data_mat(:,6),'k','filled');hold on;
[B3,BINT1,R1,RINT1,ols_STATS1] = regress(adj_data_mat(:,6),[ones(16,1) adj_data_mat(:,5)]);
[robust_b_2B robust_stats_2B] = robustfit(adj_data_mat(:,5),adj_data_mat(:,6));
plot(adj_data_mat(:,5),robust_b_2B(1)+robust_b_2B(2)*adj_data_mat(:,5),'k-','LineWidth',5)

sse = robust_stats_2B.dfe * robust_stats_2B.robust_s^2;
phat = robust_b_2B(1)+robust_b_2B(2)*adj_data_mat(:,5);
ssr = norm(phat-mean(phat))^2;
r_robust_2B = sqrt(1 - sse / (sse + ssr));



title(strcat('p=',num2str(robust_stats_2B.p(2)),'r=',num2str(r_robust_2B)));
figurename='phase2_perf_by_bilateral_HPC_ei.eps';
print('-dpsc2','-noui','-adobecset','-painters',figurename);





xlswrite('volume_perf_analysis_ei.xls',data_mat)
save('volume_perf_analysis_updated_ei.mat')

