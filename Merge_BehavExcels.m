SessionTable=table;
FileList = {'CL121121_1','CL121122_1','CL121128_1','CL121227_1','CL130107_1','CL130109_1','CL130114_2','CL130116_2',...
    'CL130121_2','CL130122_1','CL130130_1','CL130219_1','CL130220_1','CL130225_2','CL130226_1','CL130227_1'};
Bad_perf = {'CL130107_1','CL130114_2','CL130121_2','CL130220_1','CL130227_1', 'CL121227_1', 'CL130130_1'};
Good_perf = setdiff(FileList,Bad_perf);

suf = '_B_ori';
suf = '';
c{1} = [172 63 25]/255; c{2} = [167 172 25]/255; 
ROOT = 'D:\Human fMRI project\processed data';
%%
for fi = 1:numel(FileList)
     filename=FileList{fi};
    filefolder= 'Y:\EPhysRawData\fmri_oppa_analysis\';

    Trial_exp = readtable([filefolder filename '\TrialInfo_EXP' suf '.xlsx' ]);
    Trial_ctrl = readtable([filefolder filename '\TrialInfo_CTRL' suf '.xlsx' ]);
    timestamp = readtable([filefolder filename '\Timestamp_MR.xlsx' ]);

    Trials=table;

    Trial_exp.type=ones(size(Trial_exp,1),1);
    Trial_ctrl.type=zeros(size(Trial_ctrl,1),1);

    Trials = [Trial_exp;Trial_ctrl];
    Trials = movevars(Trials, "type", "Before", "correct_answer");
    Trials=sortrows(Trials,{'trial_start'});

    Trials{:,8:14} = Trials{:,8:14} - timestamp{1,1};

    writetable(Trials,[ROOT '\' filename '.xlsx'],'writemode','overwrite')
end