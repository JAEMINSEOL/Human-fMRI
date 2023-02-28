%% Behavioral analysis
close all; clear all; clc;

%setting data path
analysis_path='r:/ongoing/fmri_oppa/analysis';
data_save_path='r:/ongoing/fmri_oppa/analysis/navigation/behavior_ocpr';
illust_path='r:/ongoing/fmri_oppa/analysis/navigation/behavior_ocpr/illust';
trace_path='R:\ongoing\fmri_oppa\analysis\navigation\trajectory\illust\epoch2\all_trial_summed';

cd(analysis_path)

%getting subject information
load adj_subject_info.mat

analysis_path='r:/ongoing/fmri_oppa/analysis';
data_save_path='r:/ongoing/fmri_oppa/analysis/navigation/behavior_ocpr';
illust_path='r:/ongoing/fmri_oppa/analysis/navigation/behavior_ocpr/illust';

behavior_indice_mat_ocpr=nan(num_subjects,40,24);
behavior_indice_mat_control=nan(num_subjects,40,24);

for iS=1:1:num_subjects
    cd(analysis_path)
    status_string=strcat('start ',num2str(iS))
    subject_ID=adj_subject_list{iS};
    
    cd(subject_ID)
    load(strcat(subject_ID,'B_ver2.mat'))
    
    cd(data_save_path)
    behavior_indice_mat_ocpr(iS,:,1)=iS;
    behavior_indice_mat_control(iS,:,1)=iS;
    
    h=figure;
    set(h,'PaperPositionMode','auto')
    set(h, 'Position',[83 225 1638 771])
    
    %drawing polar plot
    subplot(3,6,[1 2 7 8])
    trial_color=[1 0 0; 0 0 1;0.9 0.9 0.9];
    place_color=[0.7 0.7 0.7; 1 0 0; 0 1 0; 0 0 1; 0 0 0];
    
    
    for iT=1:1:40
        behavior_indice_mat_ocpr(iS,iT,2)=iT;
        behavior_indice_mat_control(iS,iT,2)=iT;
        
        %trial_acc
        behavior_indice_mat_ocpr(iS,iT,3)=frame_num.adj_ocpr_num(iT,10);
        behavior_indice_mat_control(iS,iT,3)=frame_num.adj_control_num(iT,10);
        
        %navigation acc
        behavior_indice_mat_ocpr(iS,iT,29)=frame_num.adj_ocpr_num(iT,13);
        behavior_indice_mat_control(iS,iT,29)=frame_num.adj_control_num(iT,13);
        
        %trial_ocpr_rt
        behavior_indice_mat_ocpr(iS,iT,4)=frame_num.adj_ocpr_num(iT,12)-frame_num.adj_ocpr_num(iT,31);
        behavior_indice_mat_control(iS,iT,4)=frame_num.adj_control_num(iT,12)-frame_num.adj_control_num(iT,31);
        
        %trial_nav_rt
        behavior_indice_mat_ocpr(iS,iT,33)=frame_num.adj_ocpr_num(iT,16)-frame_num.adj_ocpr_num(iT,32);
        behavior_indice_mat_control(iS,iT,33)=frame_num.adj_control_num(iT,16)-frame_num.adj_control_num(iT,32);
        
        %trial_answer
        behavior_indice_mat_ocpr(iS,iT,5)=frame_num.adj_ocpr_num(iT,14);
        behavior_indice_mat_control(iS,iT,5)=frame_num.adj_control_num(iT,14);
        
        %trial_response & navigation answer
        behavior_indice_mat_ocpr(iS,iT,6)=frame_num.adj_ocpr_num(iT,36);
        behavior_indice_mat_control(iS,iT,6)=frame_num.adj_control_num(iT,36);
        
        %navigation response
        behavior_indice_mat_ocpr(iS,iT,34)=frame_num.adj_ocpr_num(iT,15);
        behavior_indice_mat_control(iS,iT,34)=frame_num.adj_control_num(iT,15);
        
        %trial_moved_angle
        behavior_indice_mat_ocpr(iS,iT,7)=frame_num.adj_ocpr_num(iT,23)*360./65536;
        behavior_indice_mat_control(iS,iT,7)=frame_num.adj_control_num(iT,23)*360./65536;
        
        %navigation_moved_angle
        behavior_indice_mat_ocpr(iS,iT,35)=frame_num.adj_ocpr_num(iT,28)*360./65536;
        behavior_indice_mat_control(iS,iT,35)=frame_num.adj_control_num(iT,28)*360./65536;
        
        %shortest distance
        trial_answer_ocpr=frame_num.adj_ocpr_num(iT,14);
        switch trial_answer_ocpr
            case 12
                ocpr_answer_angle1=0;
                ocpr_answer_angle2=360;
            case 3
                ocpr_answer_angle1=90;
                ocpr_answer_angle2=90;
            case 6
                ocpr_answer_angle1=180;
                ocpr_answer_angle2=180;
            case 9
                ocpr_answer_angle1=270;
                ocpr_answer_angle2=270;
            otherwise
        end
        initial_angle_ocpr=frame_num.adj_ocpr_num(iT,21)*360./65536;
        angle_criterion_ocpr=min(abs(initial_angle_ocpr-ocpr_answer_angle1),abs(initial_angle_ocpr-ocpr_answer_angle2));
        adj_angle_criterion_ocpr=min(angle_criterion_ocpr,360-angle_criterion_ocpr);
        
        %shortest distance_control
        trial_answer_control=frame_num.adj_control_num(iT,14);
        switch trial_answer_control
            case 12
                control_answer_angle1=0;
                control_answer_angle2=360;
            case 3
                control_answer_angle1=90;
                control_answer_angle2=90;
            case 6
                control_answer_angle1=180;
                control_answer_angle2=180;
            case 9
                control_answer_angle1=270;
                control_answer_angle2=270;
            otherwise
        end
        initial_angle_control=frame_num.adj_control_num(iT,21)*360./65536;
        angle_criterion_control=min(abs(initial_angle_control-control_answer_angle1),abs(initial_angle_control-control_answer_angle2));
        adj_angle_criterion_control=min(angle_criterion_control,360-angle_criterion_control);
        
        
        %trial_deviant_index
        behavior_indice_mat_ocpr(iS,iT,8)=behavior_indice_mat_ocpr(iS,iT,7)/adj_angle_criterion_ocpr;
        behavior_indice_mat_control(iS,iT,8)=behavior_indice_mat_control(iS,iT,7)/adj_angle_criterion_control;
        
        %for those with deviant index less than one, correction is made to
        %set minimum value as 1
        if behavior_indice_mat_ocpr(iS,iT,8) < 1
            behavior_indice_mat_ocpr(iS,iT,8) = 1;
        end
        
        if behavior_indice_mat_control(iS,iT,8) < 1
            behavior_indice_mat_control(iS,iT,8) = 1;
        end
        
        %trial_efficiency_index
        behavior_indice_mat_ocpr(iS,iT,9)=1/behavior_indice_mat_ocpr(iS,iT,8);
        behavior_indice_mat_control(iS,iT,9)=1/behavior_indice_mat_control(iS,iT,8);
        
       %% Navigation Efficiency Index
        %shortest distance
        navigation_answer_ocpr=frame_num.adj_ocpr_num(iT,36);
        switch navigation_answer_ocpr
            case 12
                navigation_answer_angle1=0;
                navigation_answer_angle2=360;
            case 3
                navigation_answer_angle1=90;
                navigation_answer_angle2=90;
            case 6
                navigation_answer_angle1=180;
                navigation_answer_angle2=180;
            case 9
                navigation_answer_angle1=270;
                navigation_answer_angle2=270;
            otherwise
        end
        initial_angle_navigation=frame_num.adj_ocpr_num(iT,25)*360./65536;
        angle_criterion_navigation=min(abs(initial_angle_navigation-navigation_answer_angle1),abs(initial_angle_navigation-navigation_answer_angle2));
        adj_angle_criterion_navigation=min(angle_criterion_navigation,360-angle_criterion_navigation);
        
        %shortest distance_control
        trial_answer_control=frame_num.adj_control_num(iT,36);
        switch trial_answer_control
            case 12
                control_answer_angle1=0;
                control_answer_angle2=360;
            case 3
                control_answer_angle1=90;
                control_answer_angle2=90;
            case 6
                control_answer_angle1=180;
                control_answer_angle2=180;
            case 9
                control_answer_angle1=270;
                control_answer_angle2=270;
            otherwise
        end
        initial_angle_control=frame_num.adj_control_num(iT,25)*360./65536;
        angle_criterion_control=min(abs(initial_angle_control-control_answer_angle1),abs(initial_angle_control-control_answer_angle2));
        adj_angle_criterion_control=min(angle_criterion_control,360-angle_criterion_control);
        
        
        %trial_deviant_index
        behavior_indice_mat_ocpr(iS,iT,36)=behavior_indice_mat_ocpr(iS,iT,35)/adj_angle_criterion_ocpr;
        behavior_indice_mat_control(iS,iT,36)=behavior_indice_mat_control(iS,iT,35)/adj_angle_criterion_control;
        
        %for those with deviant index less than one, correction is made to
        %set minimum value as 1
        if behavior_indice_mat_ocpr(iS,iT,36) < 1
            behavior_indice_mat_ocpr(iS,iT,36) = 1;
        end
        
        if behavior_indice_mat_control(iS,iT,36) < 1
            behavior_indice_mat_control(iS,iT,36) = 1;
        end
        
        %trial_efficiency_index
        behavior_indice_mat_ocpr(iS,iT,37)=1/behavior_indice_mat_ocpr(iS,iT,36);
        behavior_indice_mat_control(iS,iT,37)=1/behavior_indice_mat_control(iS,iT,36);
       
       %% OCPR trial_error count
        
        
        %trial_error_count
        trace_a=[frame_num.epoch2_ocpr_rotation_trace(frame_num.epoch2_ocpr_rotation_trace(:,2)==iT,1)' 0];
        trace_b=[0 frame_num.epoch2_ocpr_rotation_trace(frame_num.epoch2_ocpr_rotation_trace(:,2)==iT,1)'];
        trace_diff=trace_a-trace_b;
        trace_diff_ocpr=trace_diff(2:end-1);
        
        sign_change_ocpr=abs([sign(trace_diff_ocpr) 0]-[0 sign(trace_diff_ocpr)]);
        error_count_ocpr=max(size(find(sign_change_ocpr==2)));
        behavior_indice_mat_ocpr(iS,iT,10)= error_count_ocpr;
        
        
        %trial_error_count
        trace_a=[frame_num.epoch2_control_rotation_trace(frame_num.epoch2_control_rotation_trace(:,2)==iT,1)' 0];
        trace_b=[0 frame_num.epoch2_control_rotation_trace(frame_num.epoch2_control_rotation_trace(:,2)==iT,1)'];
        trace_diff=trace_a-trace_b;
        trace_diff_control=trace_diff(2:end-1);
        
        sign_change_control=abs([sign(trace_diff_control) 0]-[0 sign(trace_diff_control)]);
        error_count_control=max(size(find(sign_change_control==2)));
        behavior_indice_mat_control(iS,iT,10)= error_count_control;
        
        %record initial starting angle from the answer
        behavior_indice_mat_ocpr(iS,iT,24)=angle_criterion_ocpr;
        behavior_indice_mat_control(iS,iT,24)=angle_criterion_control;
        
        %record adjusted (0-180) initial starting angle from the answer
        behavior_indice_mat_ocpr(iS,iT,25)=adj_angle_criterion_ocpr;
        behavior_indice_mat_control(iS,iT,25)=adj_angle_criterion_control;
                
        
        %record initial left / right turn for each trial
        
        if ~isempty(trace_diff_ocpr)
            behavior_indice_mat_ocpr(iS,iT,26)=sign(trace_diff_ocpr(1));
        else behavior_indice_mat_ocpr(iS,iT,26) = 0;
        end
        
        if ~isempty(trace_diff_control)
            behavior_indice_mat_control(iS,iT,26)=sign(trace_diff_control(1));
        else behavior_indice_mat_control(iS,iT,26)= 0;
        end
        
        %polar plot
        %get target rotation angle
        correct_target=frame_num.adj_ocpr_num(iT,14);
        
        switch correct_target
            case 3
                rotation_alignment=-90;
                trial_place=2;
            case 6
                rotation_alignment=180;
                trial_place=3;
            case 9
                rotation_alignment=90;
                trial_place=4;
            case 12
                rotation_alignment=0;
                trial_place=1;
            otherwise
                rotation_alignment=0;
                trial_place=0;
        end
        trial_correctness=mean(frame_num.epoch2_ocpr_rotation_trace(frame_num.epoch2_ocpr_rotation_trace(:,2)==iT,3));
        if isnan(trial_correctness)
            trial_correctness=2;
            trial_place=0;
        end
        
        if  trial_correctness==0 || trial_correctness==2
            trial_place=0;
        end
        rotation_trace=frame_num.epoch2_ocpr_rotation_trace(frame_num.epoch2_ocpr_rotation_trace(:,2)==iT,1);
        rotation_trace=deg2rad(rotation_trace.*360./65536+rotation_alignment);
        
        h_fake = polar([1 2 3],11.2*[1 1 1]);hold on
        
        h=polar(rotation_trace,[1:0.5:1+0.5*(size(rotation_trace,1)-1)]');hold on
        rlim = 10; axis([-1 1 -1 1]*rlim);
        set(h_fake, 'Visible', 'Off');
        set(h,'Color',place_color(trial_place+1,:),'LineWidth',1.5);
        
        %record adjusted response angle
        behavior_indice_mat_ocpr(iS,iT,32)=frame_num.adj_ocpr_num(iT,9).*360./65536+rotation_alignment;
       
        %record initial starting angle from the answer
        epoch3_initial_angle=frame_num.adj_ocpr_num(iT,25).*360/65536;
        
        if epoch3_initial_angle < 30 || epoch3_initial_angle > 330
            epoch3_initial_direction=12;
        elseif epoch3_initial_angle < 120 && epoch3_initial_angle > 60
            epoch3_initial_direction=3;
        elseif epoch3_initial_angle < 210 && epoch3_initial_angle > 150
            epoch3_initial_direction=6;
        elseif epoch3_initial_angle < 300 && epoch3_initial_angle > 240
            epoch3_initial_direction=9;
        end
        
        %record initial starting angle from the answer
        epoch3_initial_angle_con=frame_num.adj_control_num(iT,25).*360/65536;
        
        if epoch3_initial_angle_con < 30 || epoch3_initial_angle_con > 330
            epoch3_initial_direction_con=12;
        elseif epoch3_initial_angle_con < 120 && epoch3_initial_angle_con > 60
            epoch3_initial_direction_con=3;
        elseif epoch3_initial_angle_con < 210 && epoch3_initial_angle_con > 150
            epoch3_initial_direction_con=6;
        elseif epoch3_initial_angle_con < 300 && epoch3_initial_angle_con > 240
            epoch3_initial_direction_con=9;
        end
        
        
        
        behavior_indice_mat_ocpr(iS,iT,43)=epoch3_initial_direction;
        behavior_indice_mat_control(iS,iT,43)=epoch3_initial_direction_con;
        
        
        
    end
    
    
    
    
    %% Chi-square test
    % compare % correct to binomial distributution
    binomial_p_val=1-binocdf(nansum(behavior_indice_mat_ocpr(iS,:,3)),40,0.25);
    behavior_indice_mat_ocpr(iS,:,11)=binomial_p_val;
    
    % compare % correct ocpr to % correct control
    n1=nansum(behavior_indice_mat_ocpr(iS,:,3));
    n2=nansum(behavior_indice_mat_control(iS,:,3));
    N1=40;N2=40;
    % Pooled estimate of proportion
    p0 = (n1+n2) / (N1+N2);
    
    % Expected counts under H0 (null hypothesis)
    n10 = N1 * p0;
    n20 = N2 * p0;
    
    % Chi-square test, by hand
    observed = [n1 N1-n1 n2 N2-n2];
    expected = [n10 N1-n10 n20 N2-n20];
    [h,p,stats] = chi2gof([1 2 3 4],'freq',observed,'expected',expected,'ctrs',[1 2 3 4],'nparams',2);
    behavior_indice_mat_ocpr(iS,:,12)=p;
    behavior_indice_mat_ocpr(iS,:,13)=stats.chi2stat;
    
    %t-test between ocpr and control
    rt_ocpr=behavior_indice_mat_ocpr(iS,:,4);
    rt_ocpr(isnan(rt_ocpr))=11.2;
    
    rt_control=behavior_indice_mat_control(iS,:,4);
    rt_control(isnan(rt_control))=11.2;
    
    [h, p, ci,stats]=ttest2(rt_ocpr, rt_control,'tail','both');%
    behavior_indice_mat_ocpr(iS,:,14)=p;
    behavior_indice_mat_ocpr(iS,:,15)=stats.tstat;
    
    %t_test between corr vs incorr efficiency index
    ei_exp=behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,3)==1,9);
    ei_con=behavior_indice_mat_control(iS,behavior_indice_mat_ocpr(iS,:,3)==1,9);
    ei_con=ei_con(~isnan(ei_con));
    
    
    
    [h, p, ci,stats]=ttest2(ei_exp, ei_con,'tail','both');
    behavior_indice_mat_ocpr(iS,:,16)=p;
    behavior_indice_mat_ocpr(iS,:,17)=stats.tstat;
    
    %proportion of error corrected trials
    behavior_indice_mat_ocpr(iS,:,18)=sum(sign(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,3)==1,10)-1))./sum(behavior_indice_mat_ocpr(iS,:,3)==1);
    behavior_indice_mat_ocpr(iS,:,19)=sum(sign(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,3)~=1,10)-1))./sum(behavior_indice_mat_ocpr(iS,:,3)~=1);
    
    %proportion of place 12 correct
    behavior_indice_mat_ocpr(iS,:,20)=nansum(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,5)==12,3))./10;
    
    %proportion of place 3 correct
    behavior_indice_mat_ocpr(iS,:,21)=nansum(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,5)==3,3))./10;
    
    %proportion of place 6 correct
    behavior_indice_mat_ocpr(iS,:,22)=nansum(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,5)==6,3))./10;
    
    %proportion of place 9 correct
    behavior_indice_mat_ocpr(iS,:,23)=nansum(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,5)==9,3))./10;
    
    %% Navigation place preference
    %proportion of place 12 correct
    behavior_indice_mat_ocpr(iS,:,38)=nansum(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,5)==12,29))./nansum(~isnan(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,5)==12,29)));
    
    %proportion of place 3 correct
    behavior_indice_mat_ocpr(iS,:,39)=nansum(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,5)==3,29))./nansum(~isnan(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,5)==3,29)));
    
    %proportion of place 6 correct
    behavior_indice_mat_ocpr(iS,:,40)=nansum(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,5)==6,29))./nansum(~isnan(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,5)==6,29)));
    
    %proportion of place 9 correct
    behavior_indice_mat_ocpr(iS,:,41)=nansum(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,5)==9,29))./nansum(~isnan(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,5)==9,29)));
    
    %Shifted place centered
    %proportion of place 12 correct
    behavior_indice_mat_ocpr(iS,:,44)=nansum(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,43)==12,29))./nansum(~isnan(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,43)==12,29)));
    
    %proportion of place 3 correct
    behavior_indice_mat_ocpr(iS,:,45)=nansum(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,43)==3,29))./nansum(~isnan(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,43)==3,29)));
    
    %proportion of place 6 correct
    behavior_indice_mat_ocpr(iS,:,46)=nansum(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,43)==6,29))./nansum(~isnan(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,43)==6,29)));
    
    %proportion of place 9 correct
    behavior_indice_mat_ocpr(iS,:,47)=nansum(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,43)==9,29))./nansum(~isnan(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,43)==9,29)));
    
    
    
    
    
    %proportion of left-right turns during 180 deg start
    behavior_indice_mat_ocpr(iS,:,23)=nansum(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,5)==9,3))./10;
    
    %biasedness (0 to 1) on correct 180 deg trials
    behavior_indice_mat_ocpr(iS,:,27)=sum(behavior_indice_mat_ocpr(iS,find(behavior_indice_mat_ocpr(iS,:,3)==1 & behavior_indice_mat_ocpr(iS,:,25)>=150) ,26));
    behavior_indice_mat_ocpr(iS,:,28)=abs(behavior_indice_mat_ocpr(iS,iT,27))/max(size(find(behavior_indice_mat_ocpr(iS,:,3)==1 & behavior_indice_mat_ocpr(iS,:,25)>=150)));
    
    behavior_indice_mat_control(iS,:,27)=sum(behavior_indice_mat_control(iS,find(behavior_indice_mat_control(iS,:,3)==1 & behavior_indice_mat_control(iS,:,25)>=150) ,26));
    behavior_indice_mat_control(iS,:,28)=abs(behavior_indice_mat_control(iS,iT,27))/max(size(find(behavior_indice_mat_control(iS,:,3)==1 & behavior_indice_mat_control(iS,:,25)>=150)));
    
    
    
    %     cd(trace_path)
    %     %summed trial rotation trace
    %     img_filename=strcat('epoch2_target_aligned_rotation_subj_',num2str(iS),'.tiff');
    %     im=imread(img_filename);
    %
    %
    %     subplot(3,6,[1 2 7 8])
    % %     ax=imshow(img_filename,'Border','tight');
    %     image(im);axis off; axis image
    
    
    subplot(3,6,3)
    barweb([nansum(behavior_indice_mat_ocpr(iS,:,3)==1) 40-nansum(behavior_indice_mat_ocpr(iS,:,3)==1)]./40.*100,[0 0],0.9,['corr' 'incorr'],[],[],'%',[],[],[],[],[]);
    set(gca,'YLim',[0 110]);
    
    subplot(3,6,9)
    barweb([nansum(behavior_indice_mat_ocpr(iS,:,3)==1) nansum(behavior_indice_mat_control(iS,:,3)==1)]./40.*100,[0 0],0.9,['exp' 'control'],[],[],'%',[],[],[],[],[]);
    set(gca,'YLim',[0 110]);
    
    subplot(3,6,15)
    barweb([nanmean(ei_exp) nanmean(ei_con)],[nanstd(ei_exp)./sqrt(size(ei_exp,2)) nanstd(ei_con)./sqrt(size(ei_con,2))],0.9,['exp' 'control'],[],[],'Efficiency Index',[],[],[],[],[]);
    set(gca,'YLim',[0 1.1]);
    
    subplot(3,6,[5 6])
    barweb([mean(behavior_indice_mat_ocpr(iS,:,18)) mean(behavior_indice_mat_ocpr(iS,:,19))],[0 0],0.9,['corr', 'incorr'],[],[],'Proportion of error corrected trials',[],[],[],[],[]);
    set(gca,'YLim',[0 1]);
    
    subplot(3,6,[11 12])
    barweb([mean(behavior_indice_mat_ocpr(iS,:,20)) mean(behavior_indice_mat_ocpr(iS,:,21)) mean(behavior_indice_mat_ocpr(iS,:,22)) mean(behavior_indice_mat_ocpr(iS,:,23))],[0 0 0 0],0.9,['PLC 12', 'PLC 3','PLC 6','PLC 9'],[],[],'Proportion of correct',[],[],[],[],[]);
    set(gca,'YLim',[0 1.1]);
    
    subplot(3,6,4)
    string=strcat('p-value =', num2str(mean(behavior_indice_mat_ocpr(iS,:,11))));
    text(-.3,0.75,string);
    axis off;
    
    subplot(3,6,10)
    string1=strcat('f-stat =', num2str(mean(behavior_indice_mat_ocpr(iS,:,13))));
    text(-.3,0.75,string1);
    
    string2=strcat('p-value =', num2str(mean(behavior_indice_mat_ocpr(iS,:,12))));
    text(-.3,0.35,string2);
    axis off;
    
    subplot(3,6,16)
    string1=strcat('t-stat =', num2str(mean(behavior_indice_mat_ocpr(iS,:,17))));
    text(-.3,0.75,string1);
    
    string2=strcat('p-value =', num2str(mean(behavior_indice_mat_ocpr(iS,:,16))));
    text(-.3,0.35,string2);
    axis off;
    
    subplot(3,6,17)
    barweb([nanmean(ei_exp)],[nanstd(ei_exp)./sqrt(size(ei_exp,2))],0.9,['corr'],[],[],'Efficiency Index',[],[],[],[],[]);
    set(gca,'YLim',[0 1.1]);
    
    subplot(3,6,18)
    barweb(mean(behavior_indice_mat_ocpr(iS,:,28))+0.0001,0,0.9,['corr 180 deg.'],[],[],'biasedness',[],[],[],[],[]);%+0.0001 added to avoid error when yvalue is 0
    set(gca,'YLim',[0 1.1]);
    %
    filename_ai=strcat('epoch2_analysis_summary_subj_',num2str(iS),'_',num2str(iT+100),'.eps');
    print('-dpsc2','-noui','-adobecset','-painters',filename_ai);
%     
    % correct navigation %
    behavior_indice_mat_ocpr(iS,:,30)=nansum(behavior_indice_mat_ocpr(iS,:,29)==1,2)./sum(~isnan(behavior_indice_mat_ocpr(iS,:,3))).*100;
    behavior_indice_mat_control(iS,:,30)=nansum(behavior_indice_mat_control(iS,:,29)==1,2)./sum(~isnan(behavior_indice_mat_control(iS,:,3))).*100;
    
    % average efficiency index for correct trials
    behavior_indice_mat_ocpr(iS,:,31)=nanmean(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,3)==1,9));
    behavior_indice_mat_control(iS,:,31)=nanmean(behavior_indice_mat_control(iS,behavior_indice_mat_control(iS,:,3)==1,9));
    
    % average efficiency index for correct trials
    behavior_indice_mat_ocpr(iS,:,42)=nanmean(behavior_indice_mat_ocpr(iS,behavior_indice_mat_ocpr(iS,:,29)==1,37));
    behavior_indice_mat_control(iS,:,42)=nanmean(behavior_indice_mat_control(iS,behavior_indice_mat_control(iS,:,29)==1,37));
    
    
    pause(1)
end

jmp_behavior_indice_mat_ocpr2=nanmean(behavior_indice_mat_ocpr(:,:,:),2);
jmp_behavior_indice_mat_ocpr2=squeeze(jmp_behavior_indice_mat_ocpr2);

jmp_behavior_indice_mat_control2= nanmean(behavior_indice_mat_control(:,:,:),2);
jmp_behavior_indice_mat_control2=squeeze(jmp_behavior_indice_mat_control2);


jmp_behavior_indice_mat=[jmp_behavior_indice_mat_ocpr2 jmp_behavior_indice_mat_control2];




% for oriana
t=0;response_angle_mat=[];
for iS=1:1:16
    
    sbj_response_angle=behavior_indice_mat_ocpr(iS,:,32);
    sbj_response_angle=sbj_response_angle(~isnan(sbj_response_angle))';
    group_var_num=ones(size(sbj_response_angle,1),1).*iS;
    response_angle_mat=[response_angle_mat; group_var_num sbj_response_angle];
end

%adjusted response angle for oriana3
response_angle_mat(sign(response_angle_mat(:,2))==-1,2)=response_angle_mat(sign(response_angle_mat(:,2))==-1,2)+360;
response_angle_mat(response_angle_mat(:,2)>360,2)=response_angle_mat(response_angle_mat(:,2)>360,2)-360;


h2=figure;
    set(h2,'PaperPositionMode','auto')
  set(h2, 'Position',[83 225 1638 771])


%     cd(trace_path)
%     %summed trial rotation trace
%     img_filename=strcat('epoch2_target_aligned_rotation_subj_',num2str(iS),'.tiff');
%     im=imread(img_filename);
%
%
%     subplot(3,6,[1 2 7 8])
% %     ax=imshow(img_filename,'Border','tight');
%     image(im);axis off; axis image

xbin=[0:10:100];
xbin_interp=[0:0.1:100];
subplot(3,6,[1 2])
n_exp=hist(jmp_behavior_indice_mat_ocpr2(:,3).*100,xbin);
hist(jmp_behavior_indice_mat_ocpr2(:,3).*100,xbin);
xlabel('% correct (exp)');ylabel('number of subjects')
set(gca,'XLim',[0 105]);hold on;
PP = spline(xbin,n_exp);
plot(xbin,n_exp,'o',xbin_interp,ppval(PP,xbin_interp),'-');

subplot(3,6,[7 8])
n_con=hist(jmp_behavior_indice_mat_control2(:,3).*100,xbin);
hist(jmp_behavior_indice_mat_control2(:,3).*100,xbin);
xlabel('% correct (control)');ylabel('number of subjects')
set(gca,'XLim',[0 105],'XTickMode','auto');hold on;
% PP = spline(xbin,n_con);
% plot(xbin,n_con,'o',xbin_interp,ppval(PP,xbin_interp),'-');

[h p stats]=kstest2(nansum(behavior_indice_mat_ocpr(:,:,3)==1,2),nansum(behavior_indice_mat_control(:,:,3)==1,2));

subplot(3,6,[7 8])
string1=strcat('ks =', num2str(stats));
text(.8,2,string1);

string2=strcat('p-value =', num2str(p));
text(.8,1,string2);



subplot(3,6,[4 5])
place_mean=mean([mean(behavior_indice_mat_ocpr(:,:,20),2) mean(behavior_indice_mat_ocpr(:,:,21),2) mean(behavior_indice_mat_ocpr(:,:,22),2) mean(behavior_indice_mat_ocpr(:,:,23),2)]);
place_ste=std([mean(behavior_indice_mat_ocpr(:,:,20),2) mean(behavior_indice_mat_ocpr(:,:,21),2) mean(behavior_indice_mat_ocpr(:,:,22),2) mean(behavior_indice_mat_ocpr(:,:,23),2)])./sqrt(10);

barweb(place_mean,place_ste,0.9,['PLC 12', 'PLC 3','PLC 6','PLC 9'],[],[],'Proportion of correct',[],[],[],[],[]);
set(gca,'YLim',[0 1.1]);

[P,anovatab,STATS]=anova1([mean(behavior_indice_mat_ocpr(:,:,20),2); mean(behavior_indice_mat_ocpr(:,:,21),2); mean(behavior_indice_mat_ocpr(:,:,22),2); mean(behavior_indice_mat_ocpr(:,:,23),2)],[repmat(1,16,1); repmat(2,16,1);repmat(3,16,1);repmat(4,16,1);],'off');
[P,anovatab]=anova_rm([mean(behavior_indice_mat_ocpr(:,:,20),2) mean(behavior_indice_mat_ocpr(:,:,21),2) mean(behavior_indice_mat_ocpr(:,:,22),2) mean(behavior_indice_mat_ocpr(:,:,23),2)]);

subplot(3,6,[4 5])
string=strcat('p-value =', num2str(P));
text(0.8,0.9,string);

xbin=[0:0.1:1];
xbin=[0.1 0.3 0.5 0.7 0.9];
xbin_interp=[0:0.001:1];
subplot(3,6,[10 11])
nb_exp=hist(mean(behavior_indice_mat_ocpr(:,:,28),2),xbin);
hist(mean(behavior_indice_mat_ocpr(:,:,28),2),xbin);
xlabel('biasedness (exp)');ylabel('number of subjects')
set(gca,'XLim',[0 1.1],'XTickMode','auto');
% PP = spline(xbin,nb_exp);
% plot(xbin,nb_exp,'o',xbin_interp,ppval(PP,xbin_interp),'-');


subplot(3,6,[16 17])
nb_con=hist(mean(behavior_indice_mat_control(:,:,28),2),xbin);
hist(mean(behavior_indice_mat_control(:,:,28),2),xbin);
xlabel('biasedness (con)');ylabel('number of subjects')
set(gca,'XLim',[0 1.1],'XTickMode','auto');
% PP = spline(xbin,nb_con);
% plot(xbin,nb_con,'o',xbin_interp,ppval(PP,xbin_interp),'-');



[B6,BINT1,R1,RINT1,ols_STATS1] = regress(jmp_behavior_indice_mat_ocpr2(:,3).*100,[ones(16,1) nanmean(behavior_indice_mat_ocpr(:,:,30),2)]);
scatter(nanmean(behavior_indice_mat_ocpr(:,:,30),2),jmp_behavior_indice_mat_ocpr2(:,3).*100,'k','filled');hold on;
% plot(subject_efficiency_index,robust_b_ei(1)+robust_b_ei(2)*subject_efficiency_index,'k-','LineWidth',5)
plot(nanmean(behavior_indice_mat_ocpr(:,:,30),2),B6(1)+B6(2)*nanmean(behavior_indice_mat_ocpr(:,:,30),2),'k-','LineWidth',2)
title(strcat('p=',num2str(ols_STATS1(3)),'r=',num2str(sqrt(ols_STATS1(1)))))
xlabel('Navigation accuracy (%)');ylabel('Accuracy for object-place search (%)')
set(gca,'XLim',[60 105],'XTickMode','auto');



filename_ai=strcat('epoch2_analysis_summary_whole_subject.eps');
% saveas(gcf,filename_ai);
print('-dpsc2','-noui','-adobecset','-painters',filename_ai);



h3=figure;
set(h3,'PaperPositionMode','auto')
set(h3, 'Position',[83 225 1638 771])


xbin=[0:0.05:1];
xbin_interp=[0:0.001:1];
subplot(4,6,[1 2])
nb_exp=hist(nanmean(behavior_indice_mat_ocpr(:,:,31),2),xbin);
hist(nanmean(behavior_indice_mat_ocpr(:,:,31),2),xbin);
xlabel('Efficiency index');ylabel('number of subjects')
set(gca,'XLim',[0 1.1],'XTickMode','auto');hold on;
% PP = spline(xbin,nb_exp);
% plot(xbin,nb_exp,'o',xbin_interp,ppval(PP,xbin_interp),'-');
[h p stats]=kstest2(nanmean(behavior_indice_mat_ocpr(:,:,31),2),nanmean(behavior_indice_mat_control(:,:,31),2));

title(strcat('p= ',num2str(p), ', ks= ', num2str(stats)));

xbin=[0:0.05:1];
xbin_interp=[0:0.001:1];
subplot(4,6,[7 8])
nb_con=hist(nanmean(behavior_indice_mat_control(:,:,31),2),xbin);
hist(nanmean(behavior_indice_mat_control(:,:,31),2),xbin);
xlabel('Efficiency index (CON)');ylabel('number of subjects')
set(gca,'XLim',[0 1.1],'XTickMode','auto');hold on;
% PP = spline(xbin,nb_exp);
% plot(xbin,nb_exp,'o',xbin_interp,ppval(PP,xbin_interp),'-');


%accuracy across subjects per objects
subplot(4,6,[3 4])
[B6,BINT1,R1,RINT1,ols_STATS1] = regress(jmp_behavior_indice_mat_ocpr2(:,3).*100,[ones(16,1) nanmean(behavior_indice_mat_ocpr(:,:,31),2)]);
scatter(nanmean(behavior_indice_mat_ocpr(:,:,31),2),jmp_behavior_indice_mat_ocpr2(:,3).*100,'k','filled');hold on;
% plot(subject_efficiency_index,robust_b_ei(1)+robust_b_ei(2)*subject_efficiency_index,'k-','LineWidth',5)
plot(nanmean(behavior_indice_mat_ocpr(:,:,31),2),B6(1)+B6(2)*nanmean(behavior_indice_mat_ocpr(:,:,31),2),'k-','LineWidth',2)
title(strcat('p=',num2str(ols_STATS1(3)),'r=',num2str(sqrt(ols_STATS1(1)))))
xlabel('Efficiency Index (EXP)');ylabel('Accuracy for object-place search (%)')

%%accuracy across subjects per objects
%binomial threshold
binomial_thresh1=binoinv(0.95,16,0.25)./16.*100;
binomial_thresh2=binoinv(0.99,16,0.25)./16.*100;
binomial_thresh3=binoinv(0.999,16,0.25)./16.*100;

subplot(4,6,13)
avg_obj_exp=nanmean(behavior_indice_mat_ocpr(:,:,3).*100,1);
ste_obj_exp=nanstd(behavior_indice_mat_ocpr(:,:,3).*100)/sqrt(16);
barweb(avg_obj_exp(nanmean(behavior_indice_mat_ocpr(:,:,5),1)==12),ste_obj_exp(nanmean(behavior_indice_mat_ocpr(:,:,5),1)==12),0.7,[],[],[],'Proportion of correct',[],[],[],[],[]);
xlabel('Objects at N');ylabel('Average accuracy (%)')
set(gca,'YLim',[0 100],'YTickMode','auto');hold on;
x_lim=get(gca,'XLim')
line(x_lim, [binomial_thresh1 binomial_thresh1],'Color','k');
line(x_lim, [binomial_thresh2 binomial_thresh2],'Color','k');
line(x_lim, [binomial_thresh3 binomial_thresh3],'Color','k');

subplot(4,6,14)
barweb(avg_obj_exp(nanmean(behavior_indice_mat_ocpr(:,:,5),1)==3),ste_obj_exp(nanmean(behavior_indice_mat_ocpr(:,:,5),1)==3),0.7,[],[],[],'Proportion of correct',[],[],[],[],[]);
xlabel('Objects at E');ylabel('Average accuracy (%)');
set(gca,'YLim',[0 100],'YTickMode','auto');hold on;
x_lim=get(gca,'XLim')
line(x_lim, [binomial_thresh1 binomial_thresh1],'Color','k');
line(x_lim, [binomial_thresh2 binomial_thresh2],'Color','k');
line(x_lim, [binomial_thresh3 binomial_thresh3],'Color','k');


subplot(4,6,15)
barweb(avg_obj_exp(nanmean(behavior_indice_mat_ocpr(:,:,5),1)==6),ste_obj_exp(nanmean(behavior_indice_mat_ocpr(:,:,5),1)==6),0.7,[],[],[],'Proportion of correct',[],[],[],[],[]);
xlabel('Objects at S');ylabel('Average accuracy (%)');
set(gca,'YLim',[0 100],'YTickMode','auto');hold on;
x_lim=get(gca,'XLim')
line(x_lim, [binomial_thresh1 binomial_thresh1],'Color','k');
line(x_lim, [binomial_thresh2 binomial_thresh2],'Color','k');
line(x_lim, [binomial_thresh3 binomial_thresh3],'Color','k');


subplot(4,6,16)
barweb(avg_obj_exp(nanmean(behavior_indice_mat_ocpr(:,:,5),1)==9),ste_obj_exp(nanmean(behavior_indice_mat_ocpr(:,:,5),1)==9),0.7,[],[],[],'Proportion of correct',[],[],[],[],[]);
xlabel('Objects at W');ylabel('Average accuracy (%)');
set(gca,'YLim',[0 100],'YTickMode','auto');hold on;
x_lim=get(gca,'XLim')
line(x_lim, [binomial_thresh1 binomial_thresh1],'Color','k');
line(x_lim, [binomial_thresh2 binomial_thresh2],'Color','k');
line(x_lim, [binomial_thresh3 binomial_thresh3],'Color','k');


%efficiency across subjects per objects
subplot(4,6,19)
object_ei_correctness_mask=nan(16,40);
object_ei_correctness_mask(find(behavior_indice_mat_ocpr(:,:,3)==1))=1;
object_EI=object_ei_correctness_mask.*behavior_indice_mat_ocpr(:,:,9);
avg_ei_obj_exp=nanmean(object_EI,1);
ste_ei_obj_exp=nanstd(object_EI)./sqrt(16-sum(isnan(object_EI),1));
barweb(avg_ei_obj_exp(nanmean(behavior_indice_mat_ocpr(:,:,5),1)==12),ste_ei_obj_exp(nanmean(behavior_indice_mat_ocpr(:,:,5),1)==12),0.7,[],[],[],'Proportion of correct',[],[],[],[],[]);
xlabel('Objects at N');ylabel('Average E.I. (%)')
set(gca,'YLim',[0 1.1],'YTickMode','auto');hold on;

subplot(4,6,20)
barweb(avg_ei_obj_exp(nanmean(behavior_indice_mat_ocpr(:,:,5),1)==3),ste_ei_obj_exp(nanmean(behavior_indice_mat_ocpr(:,:,5),1)==3),0.7,[],[],[],'Proportion of correct',[],[],[],[],[]);
xlabel('Objects at E');ylabel('Average E.I. (%)')
set(gca,'YLim',[0 1.1],'YTickMode','auto');hold on;

subplot(4,6,21)
barweb(avg_ei_obj_exp(nanmean(behavior_indice_mat_ocpr(:,:,5),1)==6),ste_ei_obj_exp(nanmean(behavior_indice_mat_ocpr(:,:,5),1)==6),0.7,[],[],[],'Proportion of correct',[],[],[],[],[]);
xlabel('Objects at S');ylabel('Average E.I. (%)')
set(gca,'YLim',[0 1.1],'YTickMode','auto');hold on;

subplot(4,6,22)
barweb(avg_ei_obj_exp(nanmean(behavior_indice_mat_ocpr(:,:,5),1)==9),ste_ei_obj_exp(nanmean(behavior_indice_mat_ocpr(:,:,5),1)==9),0.7,[],[],[],'Proportion of correct',[],[],[],[],[]);
xlabel('Objects at W');ylabel('Average E.I. (%)')
set(gca,'YLim',[0 1.1],'YTickMode','auto');hold on;

subplot(4,6,[17 18 23 24])
scatter(avg_ei_obj_exp,avg_obj_exp)
[R,P]=corrcoef(avg_ei_obj_exp,avg_obj_exp) 
xlabel('Average E.I.');ylabel('Average accuracy (%)')
[B,STATS] = robustfit(avg_ei_obj_exp,avg_obj_exp)

filename_ai=strcat('epoch2_analysis_summary2_whole_subject.eps');
% saveas(gcf,filename_ai); 
print('-dpsc2','-noui','-adobecset','-painters',filename_ai);

% h4=figure;
% 
% cluster{1}=[1 10];
% cluster{2}=[3 4 5 7 9 16];
% cluster{3}=[2 6 11 12 13 14 15];
% cluster{4}=[8];
% 
% scatter3(nansum(behavior_indice_mat_ocpr2(cluster{1},:,3)==1,2)./40.*100,nanmean(behavior_indice_mat_ocpr2(cluster{1},:,31),2),nanmean(behavior_indice_mat_ocpr2(cluster{1},:,28),2),50,[0 0 1],'filled');
% hold on
% scatter3(nansum(behavior_indice_mat_ocpr2(cluster{2},:,3)==1,2)./40.*100,nanmean(behavior_indice_mat_ocpr2(cluster{2},:,31),2),nanmean(behavior_indice_mat_ocpr2(cluster{2},:,28),2),50,[0 1 0],'filled');
% hold on
% scatter3(nansum(behavior_indice_mat_ocpr2(cluster{3},:,3)==1,2)./40.*100,nanmean(behavior_indice_mat_ocpr2(cluster{3},:,31),2),nanmean(behavior_indice_mat_ocpr2(cluster{3},:,28),2),50,[1 0 0],'filled');
% hold on
% scatter3(nansum(behavior_indice_mat_ocpr2(cluster{4},:,3)==1,2)./40.*100,nanmean(behavior_indice_mat_ocpr2(cluster{4},:,31),2),nanmean(behavior_indice_mat_ocpr2(cluster{4},:,28),2),50,[0 0 0],'filled');
% hold on
% 
% 
% view(9.5, 44);drawnow;
% xlabel('Proportion of correct trials (%)');ylabel('Efficiency Index (0-1)');zlabel('Biasedness (0-1)');
% 
% [az ab]=view(gca)

h4=figure;
set(h4,'PaperPositionMode','auto')
set(gcf, 'Position',[83 225 1638 771])

xbin=[0:10:100];
xbin_interp=[0:0.1:100];
subplot(4,6,[1 2])
n_exp=hist(jmp_behavior_indice_mat_ocpr2(:,29).*100,xbin);
hist(jmp_behavior_indice_mat_ocpr2(:,29).*100,xbin);
xlabel('% navigation correct (exp)');ylabel('number of subjects')
set(gca,'XLim',[0 105]);hold on;

%t-test result
[h p stats]=kstest2(nansum(behavior_indice_mat_ocpr(:,:,29)==1,2),nansum(behavior_indice_mat_control(:,:,29)==1,2));

title(strcat('p=',num2str(p),'ks=',num2str(stats)));

subplot(4,6,[7 8])
n_con=hist(jmp_behavior_indice_mat_control2(:,29).*100,xbin);
hist(jmp_behavior_indice_mat_control2(:,29).*100,xbin);
xlabel('% correct (control)');ylabel('number of subjects')
set(gca,'XLim',[0 105],'XTickMode','auto');hold on;

subplot(4,6,[3 4])
xbin=[0:0.05:1];
n_exp=hist(jmp_behavior_indice_mat_ocpr2(:,42),xbin);
hist(jmp_behavior_indice_mat_ocpr2(:,42),xbin);
xlabel('Correct trial EI (exp)');ylabel('number of subjects')
set(gca,'XLim',[0 1.1]);hold on;

[h p stats]=kstest2(nanmean(behavior_indice_mat_ocpr(:,:,42),2),nanmean(behavior_indice_mat_control(:,:,42),2));

title(strcat('p= ',num2str(p), ', ks= ', num2str(stats)));

subplot(4,6,[9 10])
n_con=hist(jmp_behavior_indice_mat_control2(:,42),xbin);
hist(jmp_behavior_indice_mat_control2(:,42),xbin);
xlabel('Correct trial EI (control)');ylabel('number of subjects')
set(gca,'XLim',[0 1.1],'XTickMode','auto');hold on;

%target place NESW
subplot(4,6,13)
place_mean=mean([nanmean(behavior_indice_mat_ocpr(:,:,38),2) nanmean(behavior_indice_mat_ocpr(:,:,39),2) nanmean(behavior_indice_mat_ocpr(:,:,40),2) nanmean(behavior_indice_mat_ocpr(:,:,41),2)]);
place_ste=std([nanmean(behavior_indice_mat_ocpr(:,:,38),2) nanmean(behavior_indice_mat_ocpr(:,:,39),2) nanmean(behavior_indice_mat_ocpr(:,:,40),2) nanmean(behavior_indice_mat_ocpr(:,:,41),2)])./sqrt(10);
barweb(place_mean,place_ste,0.9,['N', 'E','S','W'],[],[],'Proportion of correct',[],[],[],[],[]);
[P_targetplace,anovatab,STATS_targetplace]=anova1([mean(behavior_indice_mat_ocpr(:,:,38),2); mean(behavior_indice_mat_ocpr(:,:,39),2); mean(behavior_indice_mat_ocpr(:,:,40),2); mean(behavior_indice_mat_ocpr(:,:,41),2)],[repmat(1,16,1); repmat(2,16,1);repmat(3,16,1);repmat(4,16,1);],'off')
title(strcat('p=',num2str(P_targetplace)));

%shifted place NESW
subplot(4,6,14)
place_mean=mean([nanmean(behavior_indice_mat_ocpr(:,:,44),2) nanmean(behavior_indice_mat_ocpr(:,:,45),2) nanmean(behavior_indice_mat_ocpr(:,:,46),2) nanmean(behavior_indice_mat_ocpr(:,:,47),2)]);
place_ste=std([nanmean(behavior_indice_mat_ocpr(:,:,44),2) nanmean(behavior_indice_mat_ocpr(:,:,45),2) nanmean(behavior_indice_mat_ocpr(:,:,46),2) nanmean(behavior_indice_mat_ocpr(:,:,47),2)])./sqrt(10);
barweb(place_mean,place_ste,0.9,['N', 'E','S','W'],[],[],'Proportion of correct',[],[],[],[],[]);
[P_shiftplace,anovatab,STATS_shiftplace]=anova1([mean(behavior_indice_mat_ocpr(:,:,44),2); mean(behavior_indice_mat_ocpr(:,:,45),2); mean(behavior_indice_mat_ocpr(:,:,46),2); mean(behavior_indice_mat_ocpr(:,:,47),2)],[repmat(1,16,1); repmat(2,16,1);repmat(3,16,1);repmat(4,16,1);],'off');
title(strcat('p=',num2str(P_shiftplace)));

subplot(4,6,15)
scatter(jmp_behavior_indice_mat_ocpr2(:,42),jmp_behavior_indice_mat_ocpr2(:,29).*100,'o')
[r p]=corrcoef(jmp_behavior_indice_mat_ocpr2(:,42),jmp_behavior_indice_mat_ocpr2(:,29).*100);
title(strcat('p=',num2str(p(2)),'r=',num2str(r(2))));
xlabel('Efficiency Index (EXP)');ylabel('Accuracy for navigation (%)')

subplot(4,6,16)
scatter(jmp_behavior_indice_mat_control2(:,42),jmp_behavior_indice_mat_control2(:,29).*100,'o')
xlabel('Efficiency Index (EXP)');ylabel('Accuracy for CON navigation (%)')

subplot(4,6,21)
scatter(jmp_behavior_indice_mat_ocpr2(:,42),jmp_behavior_indice_mat_ocpr2(:,3).*100,'o')
[r p]=corrcoef(jmp_behavior_indice_mat_ocpr2(:,42),jmp_behavior_indice_mat_ocpr2(:,3).*100);
title(strcat('p=',num2str(p(2)),'r=',num2str(r(2))));
xlabel('Efficiency Index (EXP)');ylabel('Accuracy for object-place search (%)')

subplot(4,6,22)
scatter(jmp_behavior_indice_mat_ocpr2(:,42),jmp_behavior_indice_mat_ocpr2(:,31),'o')
[r p]=corrcoef(jmp_behavior_indice_mat_ocpr2(:,42),jmp_behavior_indice_mat_ocpr2(:,31));
title(strcat('p=',num2str(p(2)),'r=',num2str(r(2))));
xlabel('Navigation Efficiency Index (EXP)');ylabel('OCPR Efficiency Index (EXP)')


filename_ai=strcat('epoch3_analysis_summary3_whole_subject.eps');
% saveas(gcf,filename_ai); 
print('-dpsc2','-noui','-adobecset','-painters',filename_ai);


save('behavior_indices_ocpr_ver3.mat')


