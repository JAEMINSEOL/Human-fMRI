
filefolder= 'Y:\EPhysRawData\fmri_oppa_analysis\CL130226_1';

 files=dir(fullfile([filefolder '\fmri\epi'], 'swraf*.nii'));



X=[];

for f=1:size(files,1)
    filename = files(f).name;

    %     X(:,:,:,f) = analyze75read([filefolder '\fmri\epi\' filename ]);

    X0= niftiread([filefolder '\fmri\epi\' filename ]); % for MR data
    X(:,:,:,f) = permute(X0,[2 1 3]);

end

% save([filefolder '\MR_all.mat'],'X')

% 0219, 0225, 0226는 nii 파일

%%
filefolder= 'Y:\EPhysRawData\fmri_oppa_analysis\CL130107_1';
filename='raparc+aseg.nii';
%  filename='rbrainmask.nii';

X= niftiread([filefolder '\fmri\freesurfer_results\' filename ]); % for MR segmentation
X = permute(X,[2 1 3]);

Xnew=imresize3(X,'OutputSize',[76 63 55],'method',"nearest");


save([filefolder '\MR_seg.mat'],'Xnew')
figure; imagesc(squeeze(Xnew(:,:,33)))
%  130107 r seg 파일 없음 
% 130220 130121 w seg 파일 대신 사용