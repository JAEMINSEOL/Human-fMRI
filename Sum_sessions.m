
SessionTable=table;
FileList = {'CL121121_1','CL121122_1','CL121128_1','CL121227_1','CL130107_1','CL130109_1','CL130114_2','CL130116_2',...
    'CL130121_2','CL130122_1','CL130130_1','CL130219_1','CL130220_1','CL130225_2','CL130226_1','CL130227_1'};
for fi = 1:numel(FileList)
    filename=FileList{fi};
    filefolder= 'Y:\EPhysRawData\fmri_oppa_analysis\';

    Trial_exp = readtable([filefolder filename '\TrialInfo_EXP.xlsx' ]);
    Trial_ctrl = readtable([filefolder filename '\TrialInfo_CTRL.xlsx' ]);
    timestamp = readtable([filefolder filename '\Timestamp_MR.xlsx' ]);

    MRsig = load([filefolder filename '\MR_all.mat']);
    seg = load([filefolder filename '\MR_seg.mat']);

    sig = MRsig.X;
    seg = seg.Xnew;

    lHPC = []; rHPC = [];
    for t=1:size(sig,4)
        sigt = sig(:,:,:,t);
        roi = seg==17;
        lHPC(t,1) = nanmean(sigt(roi));

        roi = seg==53;
        rHPC(t,1) = nanmean(sigt(roi));
    end

    timestamp.L_HPC = lHPC;
    timestamp.R_HPC = rHPC;

    %%
    timestamp.EXP_phase=zeros(size(timestamp,1),1);
    timestamp.CTRL_phase=zeros(size(timestamp,1),1);
    timestamp.correct_P2=zeros(size(timestamp,1),1);
    timestamp.correct_P3=zeros(size(timestamp,1),1);
    for i=1:size(Trial_exp,1)
        timestamp.EXP_phase(timestamp.time>Trial_exp.trial_start(i) & timestamp.time<Trial_exp.phase1_end(i))=1;
        timestamp.EXP_phase(timestamp.time>Trial_exp.phase2_start(i) & timestamp.time<Trial_exp.phase2_end(i))=2;
        timestamp.EXP_phase(timestamp.time>Trial_exp.phase3_start(i) & timestamp.time<Trial_exp.phase3_end(i))=3;

        timestamp.CTRL_phase(timestamp.time>Trial_ctrl.trial_start(i) & timestamp.time<Trial_ctrl.phase1_end(i))=1;
        timestamp.CTRL_phase(timestamp.time>Trial_ctrl.phase2_start(i) & timestamp.time<Trial_ctrl.phase2_end(i))=2;
        timestamp.CTRL_phase(timestamp.time>Trial_ctrl.phase3_start(i) & timestamp.time<Trial_ctrl.phase3_end(i))=3;

        if Trial_exp.correct_phase2(i)==1
            timestamp.correct_P2(timestamp.time>Trial_exp.trial_start(i) & timestamp.time<Trial_exp.phase3_end(i))=1;
        end

        if Trial_exp.correct_phase3(i)==1
            timestamp.correct_P3(timestamp.time>Trial_exp.trial_start(i) & timestamp.time<Trial_exp.phase3_end(i))=1;
        end

    end

    writetable(timestamp,[filefolder filename '\Timestamp_MR.xlsx' ],'writemode','overwrite')
    %%
    SessionTable_temp=table;

    SessionTable_temp.ID = filename;
    SessionTable_temp.AccP2 = mean(Trial_exp.correct_phase2);
    SessionTable_temp.AccP3 = mean(Trial_exp.correct_phase3);

    %
    SessionTable_temp.lHPC_exp_all = nanmean(timestamp.L_HPC(timestamp.EXP_trials>0));
    SessionTable_temp.lHPC_exp_P2 = nanmean(timestamp.L_HPC(timestamp.EXP_phase==2));
    SessionTable_temp.lHPC_exp_P3 = nanmean(timestamp.L_HPC(timestamp.EXP_phase==3));

    SessionTable_temp.lHPC_exp_correctP2 = nanmean(timestamp.L_HPC(timestamp.correct_P2>0 & timestamp.EXP_phase==2));
    SessionTable_temp.lHPC_exp_correctP3 = nanmean(timestamp.L_HPC(timestamp.correct_P3>0 & timestamp.EXP_phase==3));

    SessionTable_temp.lHPC_ctrl_all = nanmean(timestamp.L_HPC(timestamp.CTRL_trials>0));

    %
    SessionTable_temp.rHPC_exp_all = nanmean(timestamp.R_HPC(timestamp.EXP_trials>0));
    SessionTable_temp.rHPC_exp_P2 = nanmean(timestamp.R_HPC(timestamp.EXP_phase==2));
    SessionTable_temp.rHPC_exp_P3 = nanmean(timestamp.R_HPC(timestamp.EXP_phase==3));

    SessionTable_temp.rHPC_exp_correctP2 = nanmean(timestamp.R_HPC(timestamp.correct_P2>0 & timestamp.EXP_phase==2));
    SessionTable_temp.rHPC_exp_correctP3 = nanmean(timestamp.R_HPC(timestamp.correct_P3>0 & timestamp.EXP_phase==3));

    SessionTable_temp.rHPC_ctrl_all = nanmean(timestamp.R_HPC(timestamp.CTRL_trials>0));

    SessionTable = [SessionTable; SessionTable_temp];
end

writetable(SessionTable,'D:\Human fMRI project\SessionTable.xlsx','writemode','overwrite')