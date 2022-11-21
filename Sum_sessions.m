
SessionTable=table;
FileList = {'CL121121_1','CL121122_1','CL121128_1','CL121227_1','CL130107_1','CL130109_1','CL130114_2','CL130116_2',...
    'CL130121_2','CL130122_1','CL130130_1','CL130219_1','CL130220_1','CL130225_2','CL130226_1','CL130227_1'};
Bad_perf = {'CL130107_1','CL130114_2','CL130121_2','CL130220_1','CL130227_1'};
Good_perf = setdiff(FileList,Bad_perf);

%%
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

    if size(timestamp,1)<=size(lHPC,1)
    timestamp.L_HPC = lHPC(1:size(timestamp,1));
    timestamp.R_HPC = rHPC(1:size(timestamp,1));
    else
        timestamp.L_HPC(1:size(lHPC,1)) = lHPC;
    timestamp.R_HPC(1:size(lHPC,1)) = rHPC;
    end

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
    SessionTable_temp.AccP2 = nanmean(Trial_exp.correct_phase2);
    SessionTable_temp.AccP3 = nanmean(Trial_exp.correct_phase3);

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
    disp([filename ' is finished!'])
end

writetable(SessionTable,'D:\Human fMRI project\SessionTable.xlsx','writemode','overwrite')

%%

SessionTable = readtable('D:\Human fMRI project\SessionTable.xlsx');
for fi=1:size(SessionTable,1)
    if ismember(SessionTable.ID(fi),Bad_perf)
        SessionTable.Perf(fi)=0;
    else
        SessionTable.Perf(fi)=1;
    end
end

figure;
temp=SessionTable(SessionTable.Perf==0,:);
scatter((temp.AccP2+temp.AccP3)/2,(temp.lHPC_exp_P2+temp.rHPC_exp_P2)/2,40,[167 172 25]/255,'filled')
hold on
temp=SessionTable(SessionTable.Perf==1,:);
scatter((temp.AccP2+temp.AccP3)/2,(temp.lHPC_exp_P2+temp.rHPC_exp_P2)/2,40,[172 63 25]/255,'filled')

set(gca,'xlim',[0 1],'ylim',[450 750], 'fontsize',12,'fontweight','b')
xlabel('OPRP accuracy')
ylabel('HPC intensity')

%%


figure;
temp=SessionTable;
x=temp.AccP2; y=temp.AccP3;
c=(temp.lHPC_exp_P2 + temp.lHPC_exp_P2)/2;

scatter(x,y,40,c,'filled')
colormap jet
caxis([450 600])
c = colorbar;
c.Label.String = 'rHPC intensity (OPRP)';

% bubblechart(x,y,sz)
hold on


set(gca,'xlim',[0 1],'ylim',[.5 1], 'fontsize',12,'fontweight','b')
xlabel('OPRP accuracy')
ylabel('SMP accuracy')

%%

figure;
temp=SessionTable;
x=temp.AccP3; 
y=(temp.lHPC_exp_P3 + temp.lHPC_exp_P3)/2;
b1 = x\y;
yCalc1 = b1*x;

scatter(x,y,40,'k','filled')
P = polyfit(x,y,1);
yfit = polyval(P, x);          % Estimated  Regression Line
SStot = sum((y-mean(y)).^2);                    % Total Sum-Of-Squares
SSres = sum((y-yfit).^2);                       % Residual Sum-Of-Squares
Rsq = 1-SSres/SStot;                            % R^2

yfit = polyval(P,x);
hold on;
plot(x,yfit,'r-.');
corrcoef(x,y)
text(min(x),max(y)*1.1,['r^2 = ' num2str(Rsq)])


set(gca,'xlim',[0.5 1],'ylim',[450 800], 'fontsize',12,'fontweight','b')
xlabel('SMP accuracy')
ylabel('lHPC intensity (SMP)')

%%

figure;
temp=SessionTable(SessionTable.Perf==0,:);
temp2=SessionTable(SessionTable.Perf==1,:);
x=[1,1;2,2;];
dat=[mean(temp.lHPC_exp_P2) mean(temp2.lHPC_exp_P2);mean(temp.rHPC_exp_P2) mean(temp2.rHPC_exp_P2)];
b = bar(x,dat);
b(1).FaceColor = [167 172 25]/255;
b(2).FaceColor = [172 63 25]/255;
hold on

ngroups = size(dat, 1);
nbars = size(dat, 2);
% Calculating the width for each bar group
groupwidth = min(0.8, nbars/(nbars + 1.5));
err = [std(temp.lHPC_exp_P2)/length(temp.lHPC_exp_P2) std(temp2.lHPC_exp_P2)/length(temp2.lHPC_exp_P2);...
    std(temp.rHPC_exp_P2)/length(temp.rHPC_exp_P2) std(temp2.rHPC_exp_P2)/length(temp2.rHPC_exp_P2)];
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    er = errorbar(x, dat(:,i), err(:,i), '.');
    er.Color = [0 0 0];                            
er.LineStyle = 'none';  
end

set(gca,'ylim',[550 650], 'fontsize',12,'fontweight','b')
% xlabel('Group')
xticklabels({'lHPC', 'rHPC'})
ylabel('HPC intensity')
legend({'Bad perf.','Good perf.'})

ttest2(temp.lHPC_exp_P2,temp2.lHPC_exp_P2)

%
figure;
temp=SessionTable(SessionTable.Perf==0,:);
scatter(temp.AccP2,temp.AccP3,40,[167 172 25]/255,'filled')
hold on
temp=SessionTable(SessionTable.Perf==1,:);
scatter(temp.AccP2,temp.AccP3,40,[172 63 25]/255,'filled')
set(gca, 'fontsize',12,'fontweight','b')
xlabel('OPRP accuracy')
ylabel('SMP accuracy')
legend({'Bad perf.','Good perf.'})
