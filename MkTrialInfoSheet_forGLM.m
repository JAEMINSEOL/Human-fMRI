clearvars
SessionTable=table;
FileList = {'CL121121_1','CL121122_1','CL121128_1','CL121227_1','CL130107_1','CL130109_1','CL130114_2','CL130116_2',...
    'CL130121_2','CL130122_1','CL130130_1','CL130219_1','CL130220_1','CL130225_2','CL130226_1','CL130227_1'};
Bad_perf = {'CL130107_1','CL130114_2','CL130121_2','CL130220_1','CL130227_1', 'CL121227_1', 'CL130130_1'};
Good_perf = setdiff(FileList,Bad_perf);

suf = 'B_ori';
c{1} = [172 63 25]/255; c{2} = [167 172 25]/255; 
ROOT = 'D:\Human fMRI project\processed data';
%%
for fi = 1:numel(FileList)
    filename=FileList{fi};
    filefolder= 'Y:\EPhysRawData\fmri_oppa_analysis\';

    Trial_exp.(filename) = readtable([filefolder filename '\TrialInfo_EXP_' suf '.xlsx' ]);
    Trial_ctrl.(filename) = readtable([filefolder filename '\TrialInfo_CTRL_' suf '.xlsx' ]);
    timestamp.(filename) = readtable([filefolder filename '\Timestamp_MR.xlsx' ]);
    SessionTable_temp=table;

trial_info = table;
r=1;
for t=1:size(Trial_exp.(filename),1)

    if Trial_exp.(filename).phase2_start(t)>Trial_exp.(filename).phase2_end(t)
        Trial_exp.(filename).phase2_end(t)=nan;
Trial_exp.(filename).correct_phase2(t)=nan;
    end

    temp=table;

    if t>1
        if  Trial_ctrl.(filename).trial_start(t) - Trial_exp.(filename).phase3_end(t-1)>20
            r=r+1;
        end
    end

    temp.run(1:6)=r;
temp.trial(1:6) = Trial_exp.(filename).trial(t);
temp.experiment(1:6) = [0 0 0 1 1 1]';
temp.phase(1:6) = [1 2 3 1 2 3]';

temp.correct_answer = nan(6,1);
temp.choice = nan(6,1);
temp.correctness = nan(6,1);

temp.start(1) = Trial_ctrl.(filename).trial_start(t);
temp.response(1) = Trial_ctrl.(filename).phase1_ObjRecog(t);
temp.end(1) = Trial_ctrl.(filename).phase1_end(t);

temp.correct_answer(2) = Trial_ctrl.(filename).correct_answer(t);
temp.choice(2) = Trial_ctrl.(filename).choice_phase2(t);
temp.correctness(2) = Trial_ctrl.(filename).correct_phase2(t);
temp.start(2) = Trial_ctrl.(filename).phase2_start(t);
temp.response(2) = Trial_ctrl.(filename).phase2_end(t);
temp.end(2) = Trial_ctrl.(filename).phase3_start(t);

temp.correct_answer(3) = Trial_ctrl.(filename).choice_phase2(t);
temp.choice(3) = Trial_ctrl.(filename).choice_phase3(t);
temp.correctness(3) = Trial_ctrl.(filename).correct_phase3(t);
temp.start(3) = Trial_ctrl.(filename).phase3_start(t);
temp.response(3) = Trial_ctrl.(filename).phase3_end(t);
temp.end(3) = Trial_ctrl.(filename).phase3_end(t);

temp.start(4) = Trial_exp.(filename).trial_start(t);
temp.response(4) = Trial_exp.(filename).phase1_ObjRecog(t);
temp.end(4) = Trial_exp.(filename).phase1_end(t);

temp.correct_answer(5) = Trial_exp.(filename).correct_answer(t);
temp.choice(5) = Trial_exp.(filename).choice_phase2(t);
temp.correctness(5) = Trial_exp.(filename).correct_phase2(t);
temp.start(5) = Trial_exp.(filename).phase2_start(t);
temp.response(5) = Trial_exp.(filename).phase2_end(t);
temp.end(5) = Trial_exp.(filename).phase3_start(t);

temp.correct_answer(6) = Trial_exp.(filename).choice_phase2(t);
temp.choice(6) = Trial_exp.(filename).choice_phase3(t);
temp.correctness(6) = Trial_exp.(filename).correct_phase3(t);
temp.start(6) = Trial_exp.(filename).phase3_start(t);
temp.response(6) = Trial_exp.(filename).phase3_end(t);
temp.end(6) = Trial_exp.(filename).phase3_end(t);

temp.RT = temp.response - temp.start;

trial_info = [trial_info;temp];
end

writetable(trial_info,[ROOT '\TrialInfo_' filename '.xlsx' ],'writemode','overwrite');

end