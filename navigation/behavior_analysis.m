clear all;clc;close all;

cd r:/ongoing/navigation
load interviewdata.mat

t=0;
subject_list={};
for i=1:1:size(interview_data,1)
if ~isempty(find(strfind(interview_data{i,6},'y')))
    t=t+1;
    subject_list{t,1}=interview_data{i,1};
end
end



cd r:/ongoing
subjects_behavior_mat=[];
%1st column: acc on epoch2, 2=acc on epoch3, 3=lh hipp 4=rh hipp 5=sum of
%hipp
adj_subject_list=subject_list(~ismember(1:size(subject_list,1),10),:); 

for i=1:1:size(adj_subject_list,1)
    sub_id=adj_subject_list{i,1};
    cd(sub_id)
    str_data=strcat(sub_id,'B.mat')
    load(str_data)
    subjects_behavior_mat=[subjects_behavior_mat; individual_subject_behavior];
    cd r:/ongoing
    
end

cd r:/ongoing/navigation


save('subjects_behavior.mat','subject_list','subjects_behavior_mat');

xlswrite('subjects_behavior.xls',subjects_behavior_mat) 

