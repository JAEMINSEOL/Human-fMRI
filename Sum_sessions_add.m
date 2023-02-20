


FileList = {'CL121121_1','CL121122_1','CL121128_1','CL121227_1','CL130107_1','CL130109_1','CL130114_2','CL130116_2',...
    'CL130121_2','CL130122_1','CL130130_1','CL130219_1','CL130220_1','CL130225_2','CL130226_1','CL130227_1'};
Bad_perf = {'CL130107_1','CL130114_2','CL130121_2','CL130220_1','CL130227_1', 'CL121227_1', 'CL130130_1'};
Good_perf = setdiff(FileList,Bad_perf);

addpath(genpath('D:\Human fMRI project'))

suf = 'B_ori';
c{1} = [172 63 25]/255; c{2} = [167 172 25]/255; 
ROOT = 'D:\Human fMRI project\plots';

SessionTable = readtable(['D:\Human fMRI project\SessionTable_' suf '.xlsx']);
SessionTable = removevars(SessionTable, ["WholeBrain_V","LHPC_V","RHPC_V"]);

for fi = 1:numel(FileList)
    filename=FileList{fi};
    filefolder= 'Y:\EPhysRawData\fmri_oppa_analysis\';

    Trial_exp = readtable([filefolder filename '\TrialInfo_EXP_' suf '.xlsx' ]);
    Trial_ctrl = readtable([filefolder filename '\TrialInfo_CTRL_' suf '.xlsx' ]);
    timestamp = readtable([filefolder filename '\Timestamp_MR.xlsx' ]);
% seg = load([filefolder filename '\MR_seg.mat']);


    segfolder = ['D:\Human fMRI project\FreeSurfer_Segmentation\SUB' num2str(fi)];
% cd(segfolder)

lhpc = sum(niftiread([segfolder '\mri\aparc_aseg_17.nii' ]),'all');
ca1 = sum(niftiread([segfolder '\mri\lh_hp_ca1.nii' ]),'all');
ca23dg = sum(niftiread([segfolder '\mri\lh_hp_ca23dg.nii' ]),'all');
sub = sum(niftiread([segfolder '\mri\lh_hp_sub.nii' ]),'all');
tot = ca1+ca23dg+sub;

SessionTable.Vol_L_HPC(fi) = lhpc;
SessionTable.Vol_L_CA1(fi) = ca1/tot*lhpc;
SessionTable.Vol_L_CA23dg(fi) = ca23dg/tot*lhpc;
SessionTable.Vol_L_SUB(fi) = sub/tot*lhpc;

rhpc = sum(niftiread([segfolder '\mri\aparc_aseg_53.nii' ]),'all');
ca1 = sum(niftiread([segfolder '\mri\rh_hp_ca1.nii' ]),'all');
ca23dg = sum(niftiread([segfolder '\mri\rh_hp_ca23dg.nii' ]),'all');
sub = sum(niftiread([segfolder '\mri\rh_hp_sub.nii' ]),'all');
tot = ca1+ca23dg+sub;

SessionTable.Vol_R_HPC(fi) = rhpc;
SessionTable.Vol_R_CA1(fi) = ca1/tot*rhpc;
SessionTable.Vol_R_CA23dg(fi) = ca23dg/tot*rhpc;
SessionTable.Vol_R_SUB(fi) = sub/tot*rhpc;

SessionTable.Vol_L_EC(fi) = sum(niftiread([segfolder '\mri\aparc_aseg_1006.nii' ]),'all');
SessionTable.Vol_L_Fus(fi) = sum(niftiread([segfolder '\mri\aparc_aseg_1007.nii' ]),'all');
SessionTable.Vol_L_PH(fi) = sum(niftiread([segfolder '\mri\aparc_aseg_1016.nii' ]),'all');

SessionTable.Vol_R_EC(fi) = sum(niftiread([segfolder '\mri\aparc_aseg_2006.nii' ]),'all');
SessionTable.Vol_R_Fus(fi) = sum(niftiread([segfolder '\mri\aparc_aseg_2007.nii' ]),'all');
SessionTable.Vol_R_PH(fi) = sum(niftiread([segfolder '\mri\aparc_aseg_2016.nii' ]),'all');

% mriplot(X)
% seg = seg.Xnew;
% Whole_Brain = sum(seg~=0,'all');
% LHPC_volume = sum(seg==17,'all');
% RHPC_volume = sum(seg==53,'all');

% SessionTable.WholeBrain_V(fi) = Whole_Brain;
% SessionTable.LHPC_V(fi) = LHPC_volume;
% SessionTable.RHPC_V(fi) = RHPC_volume;

end

writetable(SessionTable,['D:\Human fMRI project\SessionTable_' suf '.xlsx'],'writemode','overwrite')
%%

% segN=seg;
% segN(seg~=0)=1;
% segN(seg==17) = 3;
% segN(seg==53) = 3;
% volshow(segN,Colormap=[.5 .5 .5; 1 1 1],Alphamap=[0 .1 1 1])
% title(['Whole brain = ' jjnum2str(Whole_Brain/100,2)])


