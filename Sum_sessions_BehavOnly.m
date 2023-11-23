clearvars
SessionTable = readtable(['D:\Human fMRI project\SessionTable_B_ori.xlsx']);
FileList = SessionTable.ID;
SessionTable_new=table;
Bad_perf = {'CL130107_1','CL130114_2','CL130121_2','CL130220_1','CL130227_1', 'CL121227_1', 'CL130130_1'};
Good_perf = setdiff(FileList,Bad_perf);

suf = '_B_ori';
suf='';
c{1} = [172 63 25]/255; c{2} = [167 172 25]/255; 

ROOT.Programs = 'X:\E-Phys Analysis\fMRI_oppa\analysis_JM';
ROOT.Raw = 'Y:\EPhysRawData\fmri_oppa';
ROOT.Save = 'X:\E-Phys Analysis\fMRI_oppa\behavior data' ;
%% re-write old trial info tables
% for fi = 7:16
%     filename=FileList{fi};
%     filefolder1= 'Y:\EPhysRawData\fmri_oppa\';
%     filefolder2= 'X:\E-Phys Analysis\fMRI_oppa\behavior data\';
% 
%     Trial_exp = readtable([filefolder2 filename '\TrialInfo_EXP' suf '.xlsx' ]);
%     Trial_ctrl = readtable([filefolder2 filename '\TrialInfo_CTRL' suf '.xlsx' ]);
%     timestamp = readtable([filefolder2 filename '\Timestamp_MR.xlsx' ]);
% 
% %     Trial_exp.timeout_phase2 = double(isnan(Trial_exp.correct_phase2));
%     Trial_exp = movevars(Trial_exp, "timeout_phase2", "Before", "correct_phase3");
%     Trial_exp.correct_phase2 = double(Trial_exp.correct_answer==Trial_exp.choice_phase2);
%     Trial_exp.correct_phase3 = double(Trial_exp.choice_phase2==Trial_exp.choice_phase3);
% 
% %     Trial_ctrl.timeout_phase2 = double(isnan(Trial_ctrl.correct_phase2));
%     Trial_ctrl = movevars(Trial_ctrl, "timeout_phase2", "Before", "correct_phase3");
%     Trial_ctrl.correct_phase2 = double(Trial_ctrl.correct_answer==Trial_ctrl.choice_phase2);
%     Trial_ctrl.correct_phase3 = double(Trial_ctrl.choice_phase2==Trial_ctrl.choice_phase3);
% 
%     writetable(Trial_exp, [filefolder2 filename '\TrialInfo_EXP.xlsx' ], 'writemode','replacefile');
%     writetable(Trial_ctrl, [filefolder2 filename '\TrialInfo_CTRL.xlsx' ], 'writemode','replacefile');
%     writetable(timestamp, [filefolder2 filename '\Timestamp_MR.xlsx' ], 'writemode','replacefile');
% 
% end
% temp = readtable([filefolder2 filename '\TrialInfo_EXP'  '.xlsx' ])
 %%
clear Trial_exp Trial_ctrl timestamp
SessionTable_new=table;
for fi = 1:numel(FileList)
    filename=FileList{fi};
    filename0=filename(1:10);
    filefolder= 'X:\E-Phys Analysis\fMRI_oppa\behavior data\';

    Trial_exp.(filename) = readtable([filefolder '\TrialInfo_EXP_' filename0 '.xlsx' ]);
    Trial_ctrl.(filename)  = readtable([filefolder '\TrialInfo_CTRL_' filename0 '.xlsx' ]);
    timestamp.(filename) = readtable([filefolder filename '\Timestamp_MR.xlsx' ]);
    SessionTable_temp=table;

    
    UDK_log_parsing_JM_A_ver1

    

trial_exp_extend = table;
r=1;
for t=1:size(Trial_exp.(filename),1)
    temp=table;
    if Trial_exp.(filename).phase2_start(t)>Trial_exp.(filename).phase2_end(t)
        Trial_exp.(filename).phase2_end(t)=Trial_exp.(filename).phase3_start(t)-0.3;
Trial_exp.(filename).timeout_phase2(t)=1;
    end
temp.trial(1:3) = Trial_exp.(filename).trial(t);
temp.phase(1:3) = [1:3];
temp.start(1) = Trial_exp.(filename).trial_start(t); temp.response(1) = Trial_exp.(filename).trial_start(t);

end

Trial_exp.(filename)(isnan(Trial_exp.(filename).correct_answer),:)=[];

    SessionTable_temp.ID = filename;
    SessionTable_temp.NovDetect=corr;

        SessionTable_temp.AccP2_Remove = sum(Trial_exp.(filename).correct_phase2 & ~Trial_exp.(filename).timeout_phase2)/sum(~Trial_exp.(filename).timeout_phase2);
    SessionTable_temp.AccP2_NaN = mean(Trial_exp.(filename).correct_phase2 & ~Trial_exp.(filename).timeout_phase2);

    SessionTable_temp.AccP2_all = mean(Trial_exp.(filename).correct_phase2);
        SessionTable_temp.NumTimeout = sum(Trial_exp.(filename).timeout_phase2);

    SessionTable_temp.AccP3_Remove = sum(Trial_exp.(filename).correct_phase3 & ~Trial_exp.(filename).timeout_phase2)/sum(~Trial_exp.(filename).timeout_phase2);
    SessionTable_temp.AccP3 = mean(Trial_exp.(filename).correct_phase3);


        SessionTable_temp.RTP1 = nanmean(Trial_exp.(filename).phase1_response-Trial_exp.(filename).trial_start);
    SessionTable_temp.RTP2 = nanmean(Trial_exp.(filename).phase2_response-Trial_exp.(filename).phase2_start);
    SessionTable_temp.RTP3 = nanmean(Trial_exp.(filename).phase3_response-Trial_exp.(filename).phase3_start);

%         SessionTable_temp.AccP2_Nan = nanmean(Trial_exp.(filename).correct_phase2);
%     SessionTable_temp.AccP3_Nan = nanmean(Trial_exp.(filename).correct_phase3);


    SessionTable_temp.RTP1 = nanmean(Trial_exp.(filename).phase1_response-Trial_exp.(filename).trial_start);
    SessionTable_temp.RTP2 = nanmean(Trial_exp.(filename).phase2_end-Trial_exp.(filename).phase2_start);
    SessionTable_temp.RTP3 = nanmean(Trial_exp.(filename).phase3_end-Trial_exp.(filename).phase3_start);
    SessionTable_temp.ei = nanmean(Trial_exp.(filename).ei);

    SessionTable_new = [SessionTable_new; SessionTable_temp];
end

writetable(SessionTable_new,['D:\Human fMRI project\SessionTable_behav' '.xlsx'],'writemode','replacefile')