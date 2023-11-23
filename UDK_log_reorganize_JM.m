


ROOT.Programs = 'X:\E-Phys Analysis\fMRI_oppa\analysis_JM';
ROOT.Raw = 'Y:\EPhysRawData\fmri_oppa';
ROOT.Save = 'X:\E-Phys Analysis\fMRI_oppa\behavior data' ;

 load([ROOT.Save '\func_files.mat'])
FileList = {'CL121121_1','CL121122_1','CL121128_1','CL121227_1','CL130107_1','CL130109_1','CL130114_2','CL130116_2',...
    'CL130121_2','CL130122_1','CL130130_1','CL130219_1','CL130220_1','CL130225_2','CL130226_1','CL130227_1',...
    'JJ231019_1B', 'JJ231019_2B', 'JJ231019_3B', 'JJ231019_4B', 'JJ231025_1B', 'JJ231025_2B', 'JJ231107_1B', 'JJ231107_2B', 'JJ231107_3B', 'JJ231107_4B',...
    'JJ231114_1B', 'JJ231114_2B', 'JJ231114_3B', 'JJ231114_4B'};
addpath(genpath(ROOT.Programs))
obj_list = readtable([ROOT.Save '\obj_list.xlsx']);
oids = [[12*ones(20,1);3*ones(20,1);6*ones(20,1);9*ones(20,1)],...
    repmat([1*ones(5,1);4*ones(5,1);7*ones(5,1);10*ones(5,1)],4,1),...
    repmat([1;2;3;4;5],16,1)];
for o=1:size(obj_list,1)
    obj_list.ID(o) = find(obj_list.house(o)==oids(:,1) & obj_list.corner(o)==oids(:,2) & obj_list.order(o)==oids(:,3));
end

for fi=1:30
filename = FileList{fi};
filename0=filename(1:10);

    if strcmp(filename(1:2),'CL')

suf = '_B_ori';
TrialInfo_EXP_s = readtable([ROOT.Raw '\' filename0 '\' 'TrialInfo_EXP' suf '.xlsx']);
TrialInfo_CTRL_s = readtable([ROOT.Raw '\' filename0 '\' 'TrialInfo_CTRL' suf '.xlsx']);

    else
suf='';
TrialInfo_EXP_s = readtable([ROOT.Save '\' filename0 '\' 'TrialInfo_EXP'  '.xlsx']);
TrialInfo_CTRL_s = readtable([ROOT.Save '\' filename0 '\' 'TrialInfo_CTRL'  '.xlsx']);

    end


TrialInfo_EXP = readtable([ROOT.Save '\' filename0 '\' 'TrialInfo_EXP' '.xlsx']);
TrialInfo_CTRL = readtable([ROOT.Save '\' filename0 '\' 'TrialInfo_CTRL' '.xlsx']);

trial_info = readtable([ROOT.Save '\TrialInfo_' filename '.xlsx' ]);

if ~any("timeout_phase2" == string(TrialInfo_EXP_s.Properties.VariableNames))
    TrialInfo_EXP.timeout_phase2 = isnan(TrialInfo_EXP_s.correct_phase2);
     TrialInfo_CTRL.timeout_phase2 = isnan(TrialInfo_CTRL_s.correct_phase2);
end

if size(trial_info,1)<240
    trial_info.run(235:240) = nan;
    trial_info.trial(235:240) = nan;
    trial_info.experiment(235:240) = nan;
    trial_info.phase(235:240) = nan;
    trial_info.EfficiencyIdx(235:240) = nan;
    trial_info.start(235:240) = nan;
    trial_info.response(235:240) = nan;
    trial_info.xEnd(235:240) = nan;
end

 TrialInfo_EXP_M = TrialInfo_EXP(:,(1:7));

TrialInfo_EXP_M.run = trial_info.run(4:6:end);

TrialInfo_EXP_M.ei = trial_info.EfficiencyIdx(6:6:end);

TrialInfo_EXP_M.obj_ID = obj_list.ID;
TrialInfo_EXP_M.obj_bld = obj_list.house;
TrialInfo_EXP_M.obj_cor = obj_list.corner;
TrialInfo_EXP_M.obj_ord = obj_list.order;

TrialInfo_EXP_M.trial_start = trial_info.start(4:6:end);
TrialInfo_EXP_M.phase1_response = trial_info.response(4:6:end);
TrialInfo_EXP_M.phase1_end = trial_info.xEnd(4:6:end);

TrialInfo_EXP_M.phase2_start = trial_info.start(5:6:end);
TrialInfo_EXP_M.phase2_response = trial_info.response(5:6:end);
TrialInfo_EXP_M.phase2_end = trial_info.xEnd(5:6:end);

TrialInfo_EXP_M.phase3_start = trial_info.start(6:6:end);
TrialInfo_EXP_M.phase3_response = trial_info.response(6:6:end);
TrialInfo_EXP_M.phase3_end = trial_info.xEnd(6:6:end);

%%
 TrialInfo_CTRL_M = TrialInfo_CTRL(:,(1:7));

TrialInfo_CTRL_M.run = trial_info.run(1:6:end);

TrialInfo_CTRL_M.ei = trial_info.EfficiencyIdx(3:6:end);

TrialInfo_CTRL_M.obj_ID = obj_list.ID;
TrialInfo_CTRL_M.obj_bld = obj_list.house;
TrialInfo_CTRL_M.obj_cor = obj_list.corner;
TrialInfo_CTRL_M.obj_ord = obj_list.order;

TrialInfo_CTRL_M.trial_start = trial_info.start(1:6:end);
TrialInfo_CTRL_M.phase1_response = trial_info.response(1:6:end);
TrialInfo_CTRL_M.phase1_end = trial_info.xEnd(1:6:end);

TrialInfo_CTRL_M.phase2_start = trial_info.start(2:6:end);
TrialInfo_CTRL_M.phase2_response = trial_info.response(2:6:end);
TrialInfo_CTRL_M.phase2_end = trial_info.xEnd(2:6:end);

TrialInfo_CTRL_M.phase3_start = trial_info.start(3:6:end);
TrialInfo_CTRL_M.phase3_response = trial_info.response(3:6:end);
TrialInfo_CTRL_M.phase3_end = trial_info.xEnd(3:6:end);

%%
TrialInfo_EXP_M.phase2_cumul_corr(1) = TrialInfo_EXP_M.correct_phase2(1) * ~TrialInfo_EXP_M.timeout_phase2(1);
TrialInfo_EXP_M.phase3_cumul_corr(1) = TrialInfo_EXP_M.correct_phase3(1) * ~TrialInfo_EXP_M.timeout_phase2(1);
TrialInfo_CTRL_M.phase2_cumul_corr(1) = TrialInfo_CTRL_M.correct_phase2(1)  * ~TrialInfo_CTRL_M.timeout_phase2(1);
TrialInfo_CTRL_M.phase3_cumul_corr(1) = TrialInfo_CTRL_M.correct_phase3(1)  * ~TrialInfo_CTRL_M.timeout_phase2(1);


for t=2:size(TrialInfo_CTRL_M,1)
    if ~isnan(TrialInfo_EXP_M.timeout_phase2(t))
TrialInfo_EXP_M.phase2_cumul_corr(t) = TrialInfo_EXP_M.correct_phase2(t) * ~TrialInfo_EXP_M.timeout_phase2(t) + TrialInfo_EXP_M.phase2_cumul_corr(t-1);
TrialInfo_EXP_M.phase3_cumul_corr(t) = TrialInfo_EXP_M.correct_phase3(t) * ~TrialInfo_EXP_M.timeout_phase2(t) + TrialInfo_EXP_M.phase3_cumul_corr(t-1);
TrialInfo_CTRL_M.phase2_cumul_corr(t) = TrialInfo_CTRL_M.correct_phase2(t) * ~TrialInfo_CTRL_M.timeout_phase2(t) + TrialInfo_CTRL_M.phase2_cumul_corr(t-1);
TrialInfo_CTRL_M.phase3_cumul_corr(t) = TrialInfo_CTRL_M.correct_phase3(t) * ~TrialInfo_CTRL_M.timeout_phase2(t) + TrialInfo_CTRL_M.phase3_cumul_corr(t-1);
    end
end

writetable(TrialInfo_EXP_M, [ROOT.Save '\TrialInfo_EXP_' filename0  '.xlsx'],'writemode','replacefile')
writetable(TrialInfo_CTRL_M, [ROOT.Save '\TrialInfo_CTRL_' filename0 '.xlsx'],'writemode','replacefile')

end