clear all;close all;clc;
%% Step 1 analysis 

%coding analysis/save path for fMRI data on my PC
% analysis_path='/Volumes/R/ongoing/fmri_oppa/analysis';
% data_save_path='/Volumes/R/ongoing/fmri_oppa/analysis/TS_analysis';
% 
analysis_path='r:/ongoing/fmri_oppa/analysis';
data_save_path='r:/ongoing/fmri_oppa/analysis/TS_analysis';

% analysis_path='r:/ongoing/fmri_oppa/analysis';
% data_save_path='r:/ongoing/fmri_oppa/analysis/TS_analysis';


cd(analysis_path)

%getting subject information
cd navigation
load interviewdata.mat

t=0;
subject_list={};
for i=1:1:size(interview_data,1)
    if ~isempty(find(strfind(interview_data{i,7},'y')))
        t=t+1;
        subject_list{t,1}=interview_data{i,1};
    end
end


%excluding subjects with bad movement, etc
cd(analysis_path) 
adj_subject_list=subject_list(~ismember(1:size(subject_list,1),[7 8 9 17]),:); 
group_roi_volume=nan(16,21);

for iS=1:1:size(adj_subject_list,1)
    status_string=strcat('start ',num2str(iS))
    
    subject_ID=adj_subject_list{iS};
    
    cd(subject_ID)
    cd fmri/freesurfer_results
    [subject_roi hdr]=cbiReadNifti('aparc+aseg.nii');
    
    %left_right_bilateral_hipp
    group_roi_volume(iS,1)=size(find(subject_roi==17),1);
    group_roi_volume(iS,2)=size(find(subject_roi==53),1);
    group_roi_volume(iS,3)=group_roi_volume(iS,1)+group_roi_volume(iS,2);
    
     %left_right_bilateral_PHC
    group_roi_volume(iS,4)=size(find(subject_roi==1016),1);
    group_roi_volume(iS,5)=size(find(subject_roi==2016),1);
    group_roi_volume(iS,6)=group_roi_volume(iS,4)+group_roi_volume(iS,5);
    
     %left_right_bilateral_FA
    group_roi_volume(iS,7)=size(find(subject_roi==1007),1);
    group_roi_volume(iS,8)=size(find(subject_roi==2007),1);
    group_roi_volume(iS,9)=group_roi_volume(iS,7)+group_roi_volume(iS,8);
    
     %left_right_bilateral_LOC
    group_roi_volume(iS,10)=size(find(subject_roi==1011),1);
    group_roi_volume(iS,11)=size(find(subject_roi==2011),1);
    group_roi_volume(iS,12)=group_roi_volume(iS,10)+group_roi_volume(iS,11);
    
     %left_right_bilateral_RSC
    group_roi_volume(iS,13)=size(find(subject_roi==1010),1);
    group_roi_volume(iS,14)=size(find(subject_roi==2010),1);
    group_roi_volume(iS,15)=group_roi_volume(iS,13)+group_roi_volume(iS,14);
    
     %left_right_bilateral_IPL
    group_roi_volume(iS,16)=size(find(subject_roi==1008),1);
    group_roi_volume(iS,17)=size(find(subject_roi==2008),1);
    group_roi_volume(iS,18)=group_roi_volume(iS,16)+group_roi_volume(iS,17);
    
     %left_right_bilateral_SPL
    group_roi_volume(iS,19)=size(find(subject_roi==1029),1);
    group_roi_volume(iS,20)=size(find(subject_roi==2029),1);
    group_roi_volume(iS,21)=group_roi_volume(iS,19)+group_roi_volume(iS,20);
    

cd(analysis_path) 
        
        
        
        
end


