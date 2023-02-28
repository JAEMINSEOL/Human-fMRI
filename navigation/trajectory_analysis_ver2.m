%% trajectory analysis
close all;clear all;clc;

%setting data path
analysis_path='r:/ongoing/fmri_oppa/analysis';
data_save_path='r:/ongoing/fmri_oppa/analysis/TS_analysis';
illust_path='r:/ongoing/fmri_oppa/analysis/navigation/trajectory/illust';

% analysis_path='/Volumes/R/ongoing/fmri_oppa/analysis';
% data_save_path='/Volumes/R/ongoing/fmri_oppa/analysis/navigation/trajectory';
% illust_path='/Volumes/R/ongoing/fmri_oppa/analysis/navigation/trajectory/illust';

cd(analysis_path)

%getting subject information
load adj_subject_info.mat
trial_color=[1 0 0; 0 0 1;0.1 0.1 0.1];
place_color=[0.7 0.7 0.7; 1 0 0; 0 1 0; 0 0 1; 0 0 0];
%setting data path
analysis_path='r:/ongoing/fmri_oppa/analysis';
data_save_path='r:/ongoing/fmri_oppa/analysis/TS_analysis';
illust_path='r:/ongoing/fmri_oppa/analysis/navigation/trajectory/illust';

for iS=1:1:num_subjects
    cd(analysis_path)
    status_string=strcat('start ',num2str(iS))
    subject_ID=adj_subject_list{iS};
    
    cd(subject_ID)
    load(strcat(subject_ID,'B_ver2.mat'))
    
    cd(illust_path)
    %     %plot trajectory in original space
    %     figure;
    %     for iT=1:1:40
    %         rotation_trace=frame_num.epoch3_ocpr_rotation_trace(frame_num.epoch3_ocpr_rotation_trace(:,2)==iT,1);
    %         rotation_trace=deg2rad(rotation_trace.*360./65536);
    %         [u v]=pol2cart(rotation_trace,linspace(1,2,size(rotation_trace,1))');
    %
    %         movement_trace=frame_num.epoch3_ocpr_movement_trace(frame_num.epoch3_ocpr_movement_trace(:,3)==iT,[1 2]);
    %         trial_correctness=mean(frame_num.epoch3_ocpr_movement_trace(frame_num.epoch3_ocpr_movement_trace(:,3)==iT,4));
    %         if isnan(trial_correctness)
    %             trial_correctness=2;
    %         end
    %         movement_trace(:,1)=movement_trace(:,1)-565;
    %         movement_trace(:,2)=movement_trace(:,2)-1080;
    %
    %         trace_size=min(size(rotation_trace,1),size(movement_trace,1));
    %         plot(movement_trace(1:1:trace_size,1),movement_trace(1:1:trace_size,2),'LineWidth',0.5,'Color','k');hold on;
    %         quiver(movement_trace(1:1:trace_size,1),movement_trace(1:1:trace_size,2),u(1:1:trace_size),v(1:1:trace_size),'Color',trial_color(trial_correctness+1,:));hold on;
    %
    %     end
    % %     filename_ai=strcat('epoch3_orig_trajectory_subj_',num2str(iS),'.eps');
    % %     print('-dpsc2','-noui','-adobecset','-painters',filename_ai);
    
    
    %plot trajectory in target_aligned space
    %     mkdir(strcat('subject_',num2str(iS)));
    %     cd(strcat('subject_',num2str(iS)));
%     figure;
    %     for iT=1:1:40
    %
    %         %get target rotation angle
    %         correct_target=frame_num.adj_ocpr_num(iT,36);
    %
    %         switch correct_target
    %             case 3
    %                rotation_alignment=0;
    %             case 6
    %                rotation_alignment=270;
    %             case 9
    %                rotation_alignment=180;
    %             case 12
    %                rotation_alignment=90;
    %             otherwise
    %                rotation_alignment=90;
    %         end
    %
    %         rotation_trace=frame_num.epoch3_ocpr_rotation_trace(frame_num.epoch3_ocpr_rotation_trace(:,2)==iT,1);
    %         rotation_trace=deg2rad(rotation_trace.*360./65536+rotation_alignment);
    %
    % %       [u v]=pol2cart(rotation_trace,linspace(1,2,size(rotation_trace,1))');
    %
    % %       movement_trace=frame_num.epoch3_ocpr_movement_trace(frame_num.epoch3_ocpr_movement_trace(:,3)==iT,[1 2]);
    %         trial_correctness=mean(frame_num.epoch3_ocpr_movement_trace(frame_num.epoch3_ocpr_movement_trace(:,3)==iT,4));
    %         if isnan(trial_correctness)
    %             trial_correctness=2;
    %         end
    % %         movement_trace(:,1)=movement_trace(:,1)-565;
    % %         movement_trace(:,2)=movement_trace(:,2)-1080;
    %
    % %         [theta radi]=cart2pol(movement_trace(:,1),movement_trace(:,2));
    % %         theta=theta+deg2rad(rotation_alignment);
    % %         [x_aligned y_aligned]=pol2cart(theta,radi);
    %
    %         % select color code for this trial
    %         switch frame_num.adj_ocpr_num(iT,36);
    %             case 3
    %                 place_for_this_trial=3;
    %             case 6
    %                 place_for_this_trial=3;
    %             case 9
    %                 place_for_this_trial=3;
    %             case 12
    %                 place_for_this_trial=3;
    %             otherwise
    %                 place_for_this_trial=1;
    %         end
    %
    %         if  trial_correctness==0 || trial_correctness==2
    %             place_for_this_trial=1;
    %         end
    %
    %           h_fake = polar([1 2 3],11.2*[1 1 1]);hold on
    %
    %         h=polar(rotation_trace,[1:0.5:1+0.5*(size(rotation_trace,1)-1)]');hold on
    %         set(h_fake, 'Visible', 'Off');
    %         set(h,'Color',trial_color(trial_correctness+1,:));
    %
    %
    % %         trace_size=min(size(rotation_trace,1),size(movement_trace,1));
    % %         plot(x_aligned(1:1:trace_size),y_aligned(1:1:trace_size),'LineWidth',0.5,'Color','k');hold on;
    % %         quiver(x_aligned(1:1:trace_size),y_aligned(1:1:trace_size),u(1:1:trace_size),v(1:1:trace_size),'Color',place_color(place_for_this_trial,:));hold on;
    % %         set(gca,'XLim',[-4000 4000],'YLim',[-4000 4000]);
    %
    % %         filename_ai=strcat('epoch3_target_aligned_trajectory_subj_',num2str(iS),'_',num2str(iT+100),'.tiff');
    % %         saveas(gcf,filename_ai);
    %         hold on;
    %     end
    %     filename_ai=strcat('epoch3_target_aligned_trajectory_subj_',num2str(iS),'.eps');
    % %     saveas(gcf,filename_ai);
    %     pause(0.5)
    %     print('-dpsc2','-noui','-adobecset','-painters',filename_ai);
    %
    
%     %epoch2 rotation trace
%     figure;
%     for iT=1:1:40
%         
%         %get target rotation angle
%         correct_target=frame_num.adj_ocpr_num(iT,14);
%         
%         switch correct_target
%             case 3
%                 rotation_alignment=-90;
%             case 6
%                 rotation_alignment=180;
%             case 9
%                 rotation_alignment=90;
%             case 12
%                 rotation_alignment=0;
%             otherwise
%                 rotation_alignment=0;
%         end
%         trial_correctness=mean(frame_num.epoch2_ocpr_rotation_trace(frame_num.epoch2_ocpr_rotation_trace(:,2)==iT,3));
%         if isnan(trial_correctness)
%             trial_correctness=2;
%         end
%         
%         rotation_trace=frame_num.epoch2_ocpr_rotation_trace(frame_num.epoch2_ocpr_rotation_trace(:,2)==iT,1);
%         rotation_trace=deg2rad(rotation_trace.*360./65536+rotation_alignment);
%         
%         h_fake = polar([1 2 3],11.2*[1 1 1]);hold on
%         
%         h=polar(rotation_trace,[1:0.5:1+0.5*(size(rotation_trace,1)-1)]');hold on
%         set(h_fake, 'Visible', 'Off');
%         set(h,'Color',trial_color(trial_correctness+1,:));
%         
%         
%         filename_ai=strcat('epoch2_target_aligned_CTRL_rotation_subj_',num2str(iS),'_',num2str(iT+100),'.tiff');
%         saveas(gcf,filename_ai);
%         hold off
%         
%     end
%     filename_ai=strcat('epoch2_target_aligned_CTRL_rotation_subj_',num2str(iS),'.tiff');
%     saveas(gcf,filename_ai);
%     %
     %epoch2 CTRL rotation trace
    figure;
    for iT=1:1:40
        
        %get target rotation angle
        correct_target=frame_num.adj_control_num(iT,14);
        
        switch correct_target
            case 3
                rotation_alignment=-90;
            case 6
                rotation_alignment=180;
            case 9
                rotation_alignment=90;
            case 12
                rotation_alignment=0;
            otherwise
                rotation_alignment=0;
        end
        trial_correctness=floor(frame_num.adj_control_num(iT,13).*mean(frame_num.epoch2_control_rotation_trace(frame_num.epoch2_control_rotation_trace(:,2)==iT,3)));
        if isnan(trial_correctness)
            trial_correctness=0;
        end
        
        test_mat(iT,1)=trial_correctness;

        
        
        rotation_trace=frame_num.epoch2_control_rotation_trace(frame_num.epoch2_control_rotation_trace(:,2)==iT,1);
        rotation_trace=deg2rad(rotation_trace.*360./65536+rotation_alignment);
        
        h_fake = polar([1 2 3],10*[1 1 1]);hold on
        
        h=polar(rotation_trace,[1:0.5:1+0.5*(size(rotation_trace,1)-1)]');hold on
        set(h_fake, 'Visible', 'Off');
        set(h,'Color',trial_color(trial_correctness+1,:));
        
        

        
    end
        filename_ai=strcat('epoch2_target_aligned_CTRL_rotation_subj_',num2str(iS),'.tiff');
    saveas(gcf,filename_ai);
        filename_ai=strcat('epoch2_target_aligned_CTRL_trajectory_subj_',num2str(iS),'.eps');
        print('-dpsc2','-noui','-adobecset','-painters',filename_ai);
    %
end




