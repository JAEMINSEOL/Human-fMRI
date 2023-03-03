
clear all

FileList = {'CL121121_1','CL121122_1','CL121128_1','CL121227_1','CL130107_1','CL130109_1','CL130114_2','CL130116_2',...
    'CL130121_2','CL130122_1','CL130130_1','CL130219_1','CL130220_1','CL130225_2','CL130226_1','CL130227_1'};
Bad_perf = {'CL130107_1','CL130114_2','CL130121_2','CL130220_1','CL130227_1', 'CL121227_1', 'CL130130_1'};
Good_perf = setdiff(FileList,Bad_perf);

addpath(genpath('D:\Human fMRI project'))

suf = 'B_ori';

ROOT = 'D:\Human fMRI project\plots';

SessionTable = readtable(['D:\Human fMRI project\SessionTable_' suf '.xlsx']);
% SessionTable = removevars(SessionTable, ["WholeBrain_V","LHPC_V","RHPC_V"]);

for fi = 1:numel(FileList)
    filename=FileList{fi};
    filefolder= 'Y:\EPhysRawData\fmri_oppa_analysis\';

    Trial_exp = readtable([filefolder filename '\TrialInfo_EXP_' suf '.xlsx' ]);
    Trial_ctrl = readtable([filefolder filename '\TrialInfo_CTRL_' suf '.xlsx' ]);
    timestamp = readtable([filefolder filename '\Timestamp_MR.xlsx' ]);
% seg = load([filefolder filename '\MR_seg.mat']);


%%
    segfolder = ['D:\Human fMRI project\FreeSurfer_Segmentation\SUB' num2str(fi)];
% cd(segfolder)
X = niftiread([segfolder '\mri\SUB' num2str(fi) '_aparc+aseg.nii' ]);
wh = sum(X>0,'all');

l_hpc = sum(niftiread([segfolder '\mri\aparc_aseg_17.nii' ]),'all');
l_ca1 = niftiread([segfolder '\mri\lh_hp_ca1.nii' ]);
l_ca23dg = niftiread([segfolder '\mri\lh_hp_ca23dg.nii' ]);
l_sub = niftiread([segfolder '\mri\lh_hp_sub.nii' ]);
l_ant = niftiread([segfolder '\mri\lh-anterior-hippocampus.nii' ]);
l_pos = niftiread([segfolder '\mri\lh-posterior-hippocampus.nii' ]);


r_hpc = sum(niftiread([segfolder '\mri\aparc_aseg_53.nii' ]),'all');
r_ca1 = niftiread([segfolder '\mri\rh_hp_ca1.nii' ]);
r_ca23dg = niftiread([segfolder '\mri\rh_hp_ca23dg.nii' ]);
r_sub = niftiread([segfolder '\mri\rh_hp_sub.nii' ]);
r_ant = niftiread([segfolder '\mri\rh-anterior-hippocampus.nii' ]);
r_pos = niftiread([segfolder '\mri\rh-posterior-hippocampus.nii' ]);

ca1v = sum(l_ca1,'all');
ca23dgv = sum(l_ca23dg,'all');
subv = sum(l_sub,'all');
antv = sum(l_ant,'all');
posv = sum(l_pos,'all');
tot = ca1v+ca23dgv+subv;

SessionTable.Vol_L_HPC(fi) = l_hpc/wh;
SessionTable.Vol_L_CA1(fi) = ca1v/tot*l_hpc/wh;
SessionTable.Vol_L_CA23dg(fi) = ca23dgv/tot*l_hpc/wh;
SessionTable.Vol_L_SUB(fi) = subv/tot*l_hpc/wh;
SessionTable.Vol_L_ANT(fi) = antv/tot*l_hpc/wh;
SessionTable.Vol_L_POS(fi) = posv/tot*l_hpc/wh;

ca1v = sum(r_ca1,'all');
ca23dgv = sum(r_ca23dg,'all');
subv = sum(r_sub,'all');
antv = sum(r_ant,'all');
posv = sum(r_pos,'all');
tot = ca1v+ca23dgv+subv;

SessionTable.Vol_all(fi) = wh; 
SessionTable.Vol_R_HPC(fi) = r_hpc/wh;
SessionTable.Vol_R_CA1(fi) = ca1v/tot*r_hpc/wh;
SessionTable.Vol_R_CA23dg(fi) = ca23dgv/tot*r_hpc/wh;
SessionTable.Vol_R_SUB(fi) = sub/tot*r_hpc/wh;
SessionTable.Vol_R_ANT(fi) = antv/tot*r_hpc/wh;
SessionTable.Vol_R_POS(fi) = posv/tot*r_hpc/wh;

SessionTable.Vol_L_EC(fi) = sum(niftiread([segfolder '\mri\aparc_aseg_1006.nii' ]),'all')/wh;
SessionTable.Vol_L_Fus(fi) = sum(niftiread([segfolder '\mri\aparc_aseg_1007.nii' ]),'all')/wh;
SessionTable.Vol_L_PH(fi) = sum(niftiread([segfolder '\mri\aparc_aseg_1016.nii' ]),'all')/wh;

SessionTable.Vol_R_EC(fi) = sum(niftiread([segfolder '\mri\aparc_aseg_2006.nii' ]),'all')/wh;
SessionTable.Vol_R_Fus(fi) = sum(niftiread([segfolder '\mri\aparc_aseg_2007.nii' ]),'all')/wh;
SessionTable.Vol_R_PH(fi) = sum(niftiread([segfolder '\mri\aparc_aseg_2016.nii' ]),'all')/wh;
mriplot(-(l_sub+l_ca23dg*2+l_ca1*3))
    mriplot((l_ant+4*l_pos))
    l_hpc = niftiread([segfolder '\mri\aparc_aseg_17.nii' ]);
        mriplot((l_hpc))
% mriplot(X)
% seg = seg.Xnew;
% Whole_Brain = sum(seg~=0,'all');
% LHPC_volume = sum(seg==17,'all');
% RHPC_volume = sum(seg==53,'all');

% SessionTable.WholeBrain_V(fi) = Whole_Brain;
% SessionTable.LHPC_V(fi) = LHPC_volume;
% SessionTable.RHPC_V(fi) = RHPC_volume;
%% IES
id=find(Trial_exp.correct_phase2);
SessionTable.IES_EXP_OPRP(fi) = nanmean(Trial_exp.phase2_end(id)-Trial_exp.phase2_start(id))/SessionTable.AccP2(fi);

id=find(Trial_exp.correct_phase3);
SessionTable.IES_EXP_SMP(fi) = nanmean(Trial_exp.phase3_end(id)-Trial_exp.phase3_start(id))/SessionTable.AccP3(fi);

id=find(Trial_ctrl.correct_phase2);
SessionTable.IES_CTRL_OPRP(fi) = nanmean(Trial_ctrl.phase2_end(id)-Trial_ctrl.phase2_start(id))/nanmean(Trial_ctrl.correct_phase2);

id=find(Trial_ctrl.correct_phase3);
SessionTable.IES_CTRL_SMP(fi) = nanmean(Trial_ctrl.phase3_end(id)-Trial_ctrl.phase3_start(id))/nanmean(Trial_ctrl.correct_phase3);

%% RCS
id=find(Trial_exp.correct_phase2);
SessionTable.RCS_EXP_OPRP(fi) = nansum(Trial_exp.correct_phase2)/nansum(Trial_exp.phase2_end(id)-Trial_exp.phase2_start(id));

id=find(Trial_exp.correct_phase3);
SessionTable.RCS_EXP_SMP(fi) = nansum(Trial_exp.correct_phase3)/nansum(Trial_exp.phase3_end(id)-Trial_exp.phase3_start(id));

id=find(Trial_ctrl.correct_phase2);
SessionTable.RCS_CTRL_OPRP(fi) = nansum(Trial_ctrl.correct_phase2)/nansum(Trial_ctrl.phase2_end(id)-Trial_ctrl.phase2_start(id));

id=find(Trial_ctrl.correct_phase3);
SessionTable.RCS_CTRL_SMP(fi) = nansum(Trial_ctrl.correct_phase3)/nansum(Trial_ctrl.phase3_end(id)-Trial_ctrl.phase3_start(id));

end

writetable(SessionTable,['D:\Human fMRI project\SessionTable_' suf '.xlsx'],'writemode','overwrite')
%%

% segN=seg;
% segN(seg~=0)=1;
% segN(seg==17) = 3;
% segN(seg==53) = 3;
% volshow(segN,Colormap=[.5 .5 .5; 1 1 1],Alphamap=[0 .1 1 1])
% title(['Whole brain = ' jjnum2str(Whole_Brain/100,2)])


