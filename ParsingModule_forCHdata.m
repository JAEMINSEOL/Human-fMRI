%% 

TimeStamp_MR=table;
for i=1:numel(timestamp.adj_timeframe)
TimeStamp_MR.time(i)=str2double(timestamp.adj_timeframe{i})';
end
TimeStamp_MR.EXP_trials=frame_num.rev_ocpr;
TimeStamp_MR.CTRL_trials=frame_num.rev_control;

i=1; j=1;
CoordTable_all=table;
RotationTable_all = table;
warning off
for n=1:size(log_data,1)
    f9=strfind(log_data{n},'coordinate');
    if ~isempty(f9)
        CoordTable_all.time(i) = str2num(log_data{n}(2:8));
        CoordTable_all.X(i)=str2num(log_data{n}(strfind(log_data{n},'X=')+2:strfind(log_data{n},'Y')-1));
        CoordTable_all.Y(i)=str2num(log_data{n}(strfind(log_data{n},'Y=')+2:strfind(log_data{n},'Z')-1));
        i=i+1;
    end
    
    f8=strfind(log_data{n},'rotation');
    if ~isempty(f8)
        RotationTable_all.time(j) = str2num(log_data{n}(2:8));
        RotationTable_all.Rot(j)=str2num(log_data{n}(strfind(log_data{n},'Y=')+2:strfind(log_data{n},'Z')-1));
        RotationTable_all.Deg(j) = RotationTable_all.Rot(j)*(360/65536);
        j=j+1;
    end
end

TimeStamp_MR.X = CoordTable_all.X(...
    knnsearch(CoordTable_all.time,TimeStamp_MR.time));
TimeStamp_MR.Y = CoordTable_all.Y(...
    knnsearch(CoordTable_all.time,TimeStamp_MR.time));
TimeStamp_MR.Deg = RotationTable_all.Deg(...
    knnsearch(RotationTable_all.time,TimeStamp_MR.time));
%
TrialInfo_EXP=table();
TrialInfo_EXP.trial(1:40) = [1:40];
TrialInfo_EXP.correct_answer=frame_num.adj_ocpr_num(:,14);
TrialInfo_EXP.choice_phase2=frame_num.adj_ocpr_num(:,36);
TrialInfo_EXP.choice_phase3=frame_num.adj_ocpr_num(:,15);

TrialInfo_EXP.correct_phase2=frame_num.adj_ocpr_num(:,10);
TrialInfo_EXP.correct_phase3=frame_num.adj_ocpr_num(:,13);
TrialInfo_EXP.correct_phase3(isnan(TrialInfo_EXP.choice_phase3))=nan;

TrialInfo_EXP.trial_start=frame_num.adj_ocpr_num(:,30);
TrialInfo_EXP.phase1_ObjRecog=frame_num.adj_ocpr_num(:,8);
TrialInfo_EXP.phase1_end=frame_num.adj_ocpr_num(:,31);
TrialInfo_EXP.phase2_start=frame_num.adj_ocpr_num(:,31);
TrialInfo_EXP.phase2_end=frame_num.adj_ocpr_num(:,12);
TrialInfo_EXP.phase3_start=frame_num.adj_ocpr_num(:,32);
TrialInfo_EXP.phase3_end=frame_num.adj_ocpr_num(:,16);

%
TrialInfo_CTRL=table();
TrialInfo_CTRL.trial(1:40) = [1:40];
TrialInfo_CTRL.correct_answer=frame_num.adj_control_num(:,14);
TrialInfo_CTRL.choice_phase2=TrialInfo_CTRL.correct_answer;
TrialInfo_CTRL.choice_phase3=frame_num.adj_control_num(:,15);

TrialInfo_CTRL.correct_phase2=frame_num.adj_control_num(:,10);
TrialInfo_CTRL.correct_phase3=frame_num.adj_control_num(:,13);
TrialInfo_CTRL.correct_phase3(isnan(TrialInfo_CTRL.choice_phase3))=nan;

TrialInfo_CTRL.trial_start=frame_num.adj_control_num(:,30);
TrialInfo_CTRL.phase1_ObjRecog=frame_num.adj_control_num(:,8);
TrialInfo_CTRL.phase1_end=frame_num.adj_control_num(:,31);
TrialInfo_CTRL.phase2_start=frame_num.adj_control_num(:,31);
TrialInfo_CTRL.phase2_end=frame_num.adj_control_num(:,12);
TrialInfo_CTRL.phase3_start=frame_num.adj_control_num(:,32);
TrialInfo_CTRL.phase3_end=frame_num.adj_control_num(:,16);

%
writetable(TrialInfo_EXP, [Root 'TrialInfo_EXP.xlsx'],'writemode','overwrite')
writetable(TrialInfo_CTRL, [Root 'TrialInfo_CTRL.xlsx'],'writemode','overwrite')
writetable(TimeStamp_MR, [Root 'TimeStamp_MR.xlsx'],'writemode','overwrite')