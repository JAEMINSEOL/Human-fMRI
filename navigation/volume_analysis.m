clear all;clc;close all;

cd r:/ongoing/navigation
load interviewdata.mat

t=0;
subject_list={};
for i=1:1:size(interview_data,1)
    if ~isempty(find(strfind(interview_data{i,7},'y')))
        t=t+1;
        subject_list{t,1}=interview_data{i,1};
    end
end
cd r:/ongoing

adj_subject_list=subject_list(~ismember(1:size(subject_list,1),[7 8 9 17]),:); 

cd r:/ongoing
data_mat=nan(size(adj_subject_list,1),5);
%1st column: acc on epoch2, 2=acc on epoch3, 3=lh hipp 4=rh hipp 5=sum of
%hipp

for i=1:1:size(adj_subject_list,1)
    sub_id=adj_subject_list{i,1};
    cd(sub_id)
    str_data=strcat(sub_id,'B.mat')
    load(str_data)
    data_mat(i,1)=nansum(frame_num.ocpr_num(:,10))/40;%2nd epoch acc
    data_mat(i,2)=nansum(frame_num.ocpr_num(:,13))/40;%3rd epoch acc
    cd fmri/freesurfer_results
    [data, hdr]=cbiReadNifti('aparc+aseg.nii');
    data_mat(i,3)=size(find(data==17),1);%lh hipp voxels
    data_mat(i,4)=size(find(data==53),1);%rh hipp voxels
    data_mat(i,5)=data_mat(i,3)+data_mat(i,4);
    clear frame_num 
    cd r:/ongoing
    
end

cd r:/ongoing/navigation
save('volume_perf_analysis.mat','subject_list','data_mat');

% adj_data_mat=data_mat(~ismember(1:size(data_mat,1),[2 10]),:); 
adj_data_mat=data_mat;

figure;%2nd epoch-lh hipp
scatter(adj_data_mat(:,3),adj_data_mat(:,1),'r','filled');hold on;
[B1,BINT1,R1,RINT1,ols_STATS1] = regress(adj_data_mat(:,1),[ones(16,1) adj_data_mat(:,3)]);
[robust_b_2L robust_stats_2L] = robustfit(adj_data_mat(:,3),adj_data_mat(:,1));
sse = robust_stats_2L.dfe * robust_stats_2L.robust_s^2;
phat = robust_b_2L(1)+robust_b_2L(2)*adj_data_mat(:,3);
ssr = norm(phat-mean(phat))^2;
r_robust_2L = sqrt(1 - sse / (sse + ssr));
plot(adj_data_mat(:,3),robust_b_2L(1)+robust_b_2L(2)*adj_data_mat(:,3),'r-','LineWidth',3)


scatter(adj_data_mat(:,4),adj_data_mat(:,1),'b','filled');hold on;
[B2,BINT1,R1,RINT1,ols_STATS1] = regress(adj_data_mat(:,1),[ones(16,1) adj_data_mat(:,4)]);
[robust_b_2R robust_stats_2R] = robustfit(adj_data_mat(:,4),adj_data_mat(:,1));
sse = robust_stats_2R.dfe * robust_stats_2R.robust_s^2;
phat = robust_b_2R(1)+robust_b_2R(2)*adj_data_mat(:,4);
ssr = norm(phat-mean(phat))^2;
r_robust_2R = sqrt(1 - sse / (sse + ssr));

plot(adj_data_mat(:,4),robust_b_2R(1)+robust_b_2R(2)*adj_data_mat(:,4),'b-','LineWidth',3)
title(strcat('p=',num2str(robust_stats_2L.p(2)),'r=',num2str(r_robust_2L),'p=',num2str(robust_stats_2R.p(2)),'r=',num2str(r_robust_2R)));
figurename='phase2_perf_by_left(red)_right(blue)_HPC.eps';
print('-dpsc2','-noui','-adobecset','-painters',figurename);



figure;%2nd epoch-total hipp
scatter(adj_data_mat(:,5),adj_data_mat(:,1),'k','filled');hold on;
[B3,BINT1,R1,RINT1,ols_STATS1] = regress(adj_data_mat(:,1),[ones(16,1) adj_data_mat(:,5)]);
[robust_b_2B robust_stats_2B] = robustfit(adj_data_mat(:,5),adj_data_mat(:,1));
plot(adj_data_mat(:,5),robust_b_2B(1)+robust_b_2B(2)*adj_data_mat(:,5),'k-','LineWidth',5)

sse = robust_stats_2B.dfe * robust_stats_2B.robust_s^2;
phat = robust_b_2B(1)+robust_b_2B(2)*adj_data_mat(:,5);
ssr = norm(phat-mean(phat))^2;
r_robust_2B = sqrt(1 - sse / (sse + ssr));



title(strcat('p=',num2str(robust_stats_2B.p(2)),'r=',num2str(r_robust_2B)));
figurename='phase2_perf_by_bilateral_HPC.eps';
print('-dpsc2','-noui','-adobecset','-painters',figurename);

%%Phase3

figure;%2nd epoch-lh hipp
scatter(adj_data_mat(:,3),adj_data_mat(:,2),'r','filled');hold on;
[B4,BINT1,R1,RINT1,ols_STATS1] = regress(adj_data_mat(:,2),[ones(16,1) adj_data_mat(:,3)]);
[robust_b_3L robust_stats_3L] = robustfit(adj_data_mat(:,3),adj_data_mat(:,2));
plot(adj_data_mat(:,3),robust_b_3L(1)+robust_b_3L(2)*adj_data_mat(:,3),'r-','LineWidth',3)

sse = robust_stats_3L.dfe * robust_stats_3L.robust_s^2;
phat = robust_b_3L(1)+robust_b_3L(2)*adj_data_mat(:,5);
ssr = norm(phat-mean(phat))^2;
r_robust_3L = sqrt(1 - sse / (sse + ssr));

scatter(adj_data_mat(:,4),adj_data_mat(:,2),'b','filled');hold on;
[B5,BINT1,R1,RINT1,ols_STATS1] = regress(adj_data_mat(:,2),[ones(16,1) adj_data_mat(:,4)]);
[robust_b_3R robust_stats_3R] = robustfit(adj_data_mat(:,4),adj_data_mat(:,2));
plot(adj_data_mat(:,4),robust_b_3R(1)+robust_b_3R(2)*adj_data_mat(:,4),'b-','LineWidth',3)

sse = robust_stats_3R.dfe * robust_stats_3R.robust_s^2;
phat = robust_b_3R(1)+robust_b_3R(2)*adj_data_mat(:,5);
ssr = norm(phat-mean(phat))^2;
r_robust_3R = sqrt(1 - sse / (sse + ssr));

title(strcat('p=',num2str(robust_stats_3L.p(2)),'r=',num2str(r_robust_3L),'p=',num2str(robust_stats_3R.p(2)),'r=',num2str(r_robust_3R)));

figurename='phase3_perf_by_left(red)_right(blue)_HPC.eps';
print('-dpsc2','-noui','-adobecset','-painters',figurename);



figure;%2nd epoch-total hipp
scatter(adj_data_mat(:,5),adj_data_mat(:,2),'k','filled');hold on;
[B6,BINT1,R1,RINT1,ols_STATS1] = regress(adj_data_mat(:,2),[ones(16,1) adj_data_mat(:,5)]);
[robust_b_3B robust_stats_3B] = robustfit(adj_data_mat(:,5),adj_data_mat(:,2));
plot(adj_data_mat(:,5),robust_b_3B(1)+robust_b_3B(2)*adj_data_mat(:,5),'k-','LineWidth',5)

sse = robust_stats_3B.dfe * robust_stats_3B.robust_s^2;
phat = robust_b_3B(1)+robust_b_3B(2)*adj_data_mat(:,5);
ssr = norm(phat-mean(phat))^2;
r_robust_3B = sqrt(1 - sse / (sse + ssr));

title(strcat('p=',num2str(robust_stats_3B.p(2)),'r=',num2str(r_robust_3B)));

figurename='phase3_perf_by_bilateral_HPC.eps';
print('-dpsc2','-noui','-adobecset','-painters',figurename);






xlswrite('volume_perf_analysis.xls',data_mat)
save('volume_perf_analysis_updated.mat')

