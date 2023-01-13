


FileList = {'CL121121_1','CL121122_1','CL121128_1','CL121227_1','CL130107_1','CL130109_1','CL130114_2','CL130116_2',...
    'CL130121_2','CL130122_1','CL130130_1','CL130219_1','CL130220_1','CL130225_2','CL130226_1','CL130227_1'};
Bad_perf = {'CL130107_1','CL130114_2','CL130121_2','CL130220_1','CL130227_1', 'CL121227_1', 'CL130130_1'};
Good_perf = setdiff(FileList,Bad_perf);

suf = 'B_ori';
c{1} = [172 63 25]/255; c{2} = [167 172 25]/255; 
ROOT = 'D:\Human fMRI project\plots';

SessionTable = readtable(['D:\Human fMRI project\SessionTable_' suf '.xlsx']);


for fi = 1:numel(FileList)
    filename=FileList{fi};
    filefolder= 'Y:\EPhysRawData\fmri_oppa_analysis\';

    Trial_exp = readtable([filefolder filename '\TrialInfo_EXP_' suf '.xlsx' ]);
    Trial_ctrl = readtable([filefolder filename '\TrialInfo_CTRL_' suf '.xlsx' ]);
    timestamp = readtable([filefolder filename '\Timestamp_MR.xlsx' ]);
seg = load([filefolder filename '\MR_seg.mat']);

seg = seg.Xnew;
Whole_Brain = sum(seg~=0,'all');
LHPC_volume = sum(seg==17,'all');
RHPC_volume = sum(seg==53,'all');

SessionTable.WholeBrain_V(fi) = Whole_Brain;
SessionTable.LHPC_V(fi) = LHPC_volume;
SessionTable.RHPC_V(fi) = RHPC_volume;

end
%%

segN=seg;
segN(seg~=0)=1;
segN(seg==17) = 2;
segN(seg==53) = 3;
volshow(segN,Colormap=[.5 .5 .5; 1 1 1],Alphamap=[0 .1 1 1])
title(['Whole brain = ' jjnum2str(Whole_Brain/100,2)])
