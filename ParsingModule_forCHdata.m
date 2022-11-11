%% 
filename = filename(1:11);
Root = ['Y:\EPhysRawData\fmri_oppa_analysis\' filename(1:end-1) '\'];

%% add epoch specific info in frame_num matrix
decision_object_string='1st decision';
decision_place_string='2nd decision';
decision_navigate_string='acc_OCPR';
decision_anyway='causeevent decision';
decision_timeout = '3rd period';
decision_timeout2 = '2nd period';

ts = 0;
for i=1:1:no_trials/2
    frame_num.ocpr_num(i,17)=line_indice_adj_timeframe(frame_num.ocpr_num(i,4));
    frame_num.ocpr_num(i,19)=line_indice_adj_timeframe(frame_num.ocpr_num(i,5));
    frame_num.ocpr_num(i,30)=str2num(log_data{line_indice_adj_timeframe(frame_num.ocpr_num(i,1))}(2:8));
    frame_num.ocpr_num(i,31)=str2num(log_data{line_indice_adj_timeframe(frame_num.ocpr_num(i,4))}(2:8));
    frame_num.ocpr_num(i,32)=str2num(log_data{line_indice_adj_timeframe(frame_num.ocpr_num(i,5))}(2:8));
    
    for j=line_indice_ocpr(1,i):1:line_indice_ocpr(2,i)
        f1=strfind(log_data{j},decision_object_string);
        f2=strfind(log_data{j},decision_place_string);
        f3=strfind(log_data{j},decision_navigate_string);
        f0=strfind(log_data{j},decision_anyway);
        fx=strfind(log_data{j},decision_timeout);
        fy=strfind(log_data{j},decision_timeout2);
        
        if ts~=1
            if ~isempty(f1) || ~isempty(fy)
                j1=j;
                while isempty(str2num(log_data{j1}(strfind(log_data{j1},'Y=')+2:strfind(log_data{j1},'Z')-1)))
                    j1=j1-1;
                end
                
                frame_num.ocpr_num(i,8)=str2num(log_data{j1}(2:8));%timestamp at 1st decision
                for k=j1-12:1:j1+12
                    f4=strfind(log_data{k},'causeevent timeframe');
                    if ~isempty(f4)
                        
                        if ~isempty(find(line_indice_adj_timeframe==k))
                            frame_num.ocpr_num(i,7)=find(line_indice_adj_timeframe==k); %timeframe closest to 1st decision
                        end
                        break
                    end
                end
                ts=1;
            end
        end
        
        if ts==1
            if  ~isempty(f2) || ~isempty(f0) ||~isempty(fx)
                j1=j;
                while isempty(str2num(log_data{j1}(strfind(log_data{j1},'Y=')+2:strfind(log_data{j1},'Z')-1)))
                    j1=j1-1;
                end
                
                frame_num.ocpr_num(i,18)=j1;
                frame_num.ocpr_num(i,9)=str2num(log_data{j1}(strfind(log_data{j1},'Y=')+2:strfind(log_data{j1},'Z')-1));
                frame_num.ocpr_num(i,12)=str2num(log_data{j1}(2:8));%timestamp at 2nd decision
                for k=j1-12:1:j1+12
                    f4=strfind(log_data{k},'causeevent timeframe');
                    if ~isempty(f4)
                        if ~isempty(find(line_indice_adj_timeframe==k))
                            frame_num.ocpr_num(i,11)=find(line_indice_adj_timeframe==k);%timeframe closest to 2nd decision
                        end
                        break
                    end
                end
                ts=2;
            end
        end
    end
end



for i=1:1:no_trials/2
    
    for j=line_indice_ocpr(1,i):1:min(line_indice_ocpr(2,i)+20, line_end)
        
        f3=strfind(log_data{j},decision_navigate_string);
        if ~isempty(f3)
            frame_num.ocpr_num(i,20)=j;
            frame_num.ocpr_num(i,16)=str2num(log_data{j}(2:8));%timestamp at 3rd decision
            f4=strfind(log_data{j},'correct');
            
            
            for l=j:1:min(j+20, line_end)
                
                f5=strfind(log_data{l},'choice');
                if ~isempty(f5)
                    frame_num.ocpr_num(i,14)=str2num(log_data{l-1}(1,end-1:end)); %answer
                    frame_num.ocpr_num(i,15)=str2num(log_data{l}(1,end-1:end)); %choice
                end
            end
            
            %period 2 accuracy
            switch frame_num.ocpr_num(i,14)
                case 3
                    range1=16000;range2=16000;
                case 6
                    range1=32000;range2=32000;
                case 9
                    range1=49000;range2=49000;
                case 12
                    range1=1 ;range2=65536;
                otherwise
                    a=1;
            end
            
            if ~isnan(frame_num.ocpr_num(i,9))
                if abs(frame_num.ocpr_num(i,9)-range1)<=6000 | abs(frame_num.ocpr_num(i,9)- range2)<=6000
                    frame_num.ocpr_num(i,10)=1;
                else
                    frame_num.ocpr_num(i,10)=0;
                end
            end
            
            %period 3 accuracy
            switch frame_num.ocpr_num(i,15)
                case 3
                    range1=16000;range2=16000;
                case 6
                    range1=32000;range2=32000;
                case 9
                    range1=49000;range2=49000;
                case 12
                    range1=1 ;range2=65536;
                otherwise
                    a=1;
            end
            
            
            if ~isnan(frame_num.ocpr_num(i,9))
                if abs(frame_num.ocpr_num(i,9)-range1)<=6000 | abs(frame_num.ocpr_num(i,9)- range2)<=6000
                    frame_num.ocpr_num(i,13)=1;
                else
                    frame_num.ocpr_num(i,13)=0;
                end
            end
            
        end
        
        
    end
end


%add epoch specific info in frame_num matrix
decision_object_string='1st decision';
decision_place_string='2nd decision';
decision_navigate_string='acc_control';
decision_anyway='causeevent decision';
decision_timeout = '3rd period';
decision_timeout2 = '2nd period';

ts=0;
for i=1:1:no_trials/2
    frame_num.control_num(i,17)=line_indice_adj_timeframe(frame_num.control_num(i,4));
    frame_num.control_num(i,19)=line_indice_adj_timeframe(frame_num.control_num(i,5));
    frame_num.control_num(i,30)=str2num(log_data{line_indice_adj_timeframe(frame_num.control_num(i,1))}(2:8));
    frame_num.control_num(i,31)=str2num(log_data{line_indice_adj_timeframe(frame_num.control_num(i,4))}(2:8));
    frame_num.control_num(i,32)=str2num(log_data{line_indice_adj_timeframe(frame_num.control_num(i,5))}(2:8));
    for j=line_indice_control(1,i):1:line_indice_control(2,i)
        f1=strfind(log_data{j},decision_object_string);
        f2=strfind(log_data{j},decision_place_string);
        f3=strfind(log_data{j},decision_navigate_string);
        f0=strfind(log_data{j},decision_anyway);
        fx=strfind(log_data{j},decision_timeout);
        fy=strfind(log_data{j},decision_timeout2);
        
        
        if ts~=1
            if ~isempty(f1) || ~isempty(fy)
                j1=j;
                while isempty(str2num(log_data{j1}(strfind(log_data{j1},'Y=')+2:strfind(log_data{j1},'Z')-1)))
                    j1=j1-1;
                end
                
                frame_num.control_num(i,8)=str2num(log_data{j1}(2:8));%timestamp at 1st decision
                for k=j1-12:1:j1+12
                    f4=strfind(log_data{k},'causeevent timeframe');
                    if ~isempty(f4)
                        
                        if ~isempty(find(line_indice_adj_timeframe==k))
                            frame_num.control_num(i,7)=find(line_indice_adj_timeframe==k); %timeframe closest to 1st decision
                        end
                        break
                    end
                end
                ts=1;
            end
        end
        
        
        
        if ts==1
            if  ~isempty(f2) || ~isempty(f0) ||~isempty(fx)
                j1=j;
                while isempty(str2num(log_data{j1}(strfind(log_data{j1},'Y=')+2:strfind(log_data{j1},'Z')-1)))
                    j1=j1-1;
                end
                
                frame_num.control_num(i,18)=j1;
                frame_num.control_num(i,9)=str2num(log_data{j1}(strfind(log_data{j1},'Y=')+2:strfind(log_data{j1},'Z')-1));
                frame_num.control_num(i,12)=str2num(log_data{j1}(2:8));%timestamp at 2nd decision
                for k=j1-12:1:j1+13
                    f4=strfind(log_data{k},'causeevent timeframe');
                    if ~isempty(f4)
                        
%                         frame_num.control_num(i,11)=find(line_indice_adj_timeframe==k); %timeframe closest to 2nd decision
                        break
                    end
                end
                ts=2;
            end
        end
    end
end


for i=1:1:no_trials/2
    
    for j=line_indice_control(1,i):1:line_indice_control(2,i)+20
        
        f3=strfind(log_data{j},decision_navigate_string);
        if ~isempty(f3)
            frame_num.control_num(i,16)=str2num(log_data{j}(2:8));%timestamp at 3rd decision
            frame_num.control_num(i,20)=j;
            f4=strfind(log_data{j},'correct');
            
            for l=j:1:j+20
                
                f5=strfind(log_data{l},'choice');
                if ~isempty(f5)
                    frame_num.control_num(i,14)=str2num(log_data{l-1}(1,end-1:end)); %answer
                    frame_num.control_num(i,15)=str2num(log_data{l}(1,end-1:end)); %choice
                end
            end
            
            %control period2 acc
            switch frame_num.control_num(i,14)
                case 3
                    range1=16000;range2=16000;
                case 6
                    range1=32000;range2=32000;
                case 9
                    range1=49000;range2=49000;
                case 12
                    range1=1 ;range2=65536;
                otherwise
                    a=1;
            end
            
            if ~isnan(frame_num.control_num(i,9))
                if abs(frame_num.control_num(i,9)-range1)<=6000 | abs(frame_num.control_num(i,9)- range2)<=6000
                    frame_num.control_num(i,10)=1;
                else
                    frame_num.control_num(i,10)=0;
                end
            end
            
            %control period 3 accuracy
            switch frame_num.control_num(i,15)
                case 3
                    range1=16000;range2=16000;
                case 6
                    range1=32000;range2=32000;
                case 9
                    range1=49000;range2=49000;
                case 12
                    range1=1 ;range2=65536;
                otherwise
                    a=1;
            end
            
            if ~isnan(frame_num.control_num(i,9))
                if abs(frame_num.control_num(i,9)-range1)<=6000 | abs(frame_num.control_num(i,9)- range2)<=6000
                    frame_num.control_num(i,13)=1;
                else
                    frame_num.control_num(i,13)=0;
                end
            end
            
        end
        
        
    end
end

%adjust frame_num latencies for nan trials to 11.2s
frame_num.adj_ocpr_num=frame_num.ocpr_num;
frame_num.adj_ocpr_num(isnan(frame_num.adj_ocpr_num(:,8)),8)=frame_num.adj_ocpr_num(isnan(frame_num.adj_ocpr_num(:,8)),31);
frame_num.adj_ocpr_num(frame_num.adj_ocpr_num(:,38)<0,38)=frame_num.adj_ocpr_num(frame_num.adj_ocpr_num(:,38)<0,38)+65536;
frame_num.epoch2_trace=frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,38)),38).*(360/65536);%epoch2 place choice in deg


frame_num.adj_control_num=frame_num.control_num;
frame_num.adj_control_num(isnan(frame_num.adj_control_num(:,8)),8)=frame_num.adj_control_num(isnan(frame_num.adj_control_num(:,8)),31);




filename2=strcat([Root filename],'_ver3.mat');
save(filename2)
%%
TimeStamp_MR=table;
for i=1:numel(timestamp.adj_timeframe)
TimeStamp_MR.time(i)=str2double(timestamp.adj_timeframe{i})';
end
TimeStamp_MR.EXP_trials=frame_num.rev_ocpr;
TimeStamp_MR.CTRL_trials=frame_num.rev_control;

i=1; j=1;
CoordTable_all=table;
RotationTable_all = table;
warning off
for n=1:size(log_data,1)
    f9=strfind(log_data{n},'coordinate');
    if ~isempty(f9)
        CoordTable_all.time(i) = str2num(log_data{n}(2:8));
        CoordTable_all.X(i)=str2num(log_data{n}(strfind(log_data{n},'X=')+2:strfind(log_data{n},'Y')-1));
        CoordTable_all.Y(i)=str2num(log_data{n}(strfind(log_data{n},'Y=')+2:strfind(log_data{n},'Z')-1));
        i=i+1;
    end
    
    f8=strfind(log_data{n},'rotation');
    if ~isempty(f8)
        RotationTable_all.time(j) = str2num(log_data{n}(2:8));
        RotationTable_all.Rot(j)=str2num(log_data{n}(strfind(log_data{n},'Y=')+2:strfind(log_data{n},'Z')-1));
        RotationTable_all.Deg(j) = RotationTable_all.Rot(j)*(360/65536);
        j=j+1;
    end
end

TimeStamp_MR.X = CoordTable_all.X(...
    knnsearch(CoordTable_all.time,TimeStamp_MR.time));
TimeStamp_MR.Y = CoordTable_all.Y(...
    knnsearch(CoordTable_all.time,TimeStamp_MR.time));
TimeStamp_MR.Deg = RotationTable_all.Deg(...
    knnsearch(RotationTable_all.time,TimeStamp_MR.time));
%
TrialInfo_EXP=table();
TrialInfo_EXP.trial(1:40) = [1:40];
TrialInfo_EXP.correct_answer=frame_num.adj_ocpr_num(:,14);
TrialInfo_EXP.choice_phase2=frame_num.adj_ocpr_num(:,36);
TrialInfo_EXP.choice_phase3=frame_num.adj_ocpr_num(:,15);

TrialInfo_EXP.correct_phase2=frame_num.adj_ocpr_num(:,10);
TrialInfo_EXP.correct_phase3=frame_num.adj_ocpr_num(:,13);
TrialInfo_EXP.correct_phase3(isnan(TrialInfo_EXP.choice_phase3))=nan;

TrialInfo_EXP.trial_start=frame_num.adj_ocpr_num(:,30);
TrialInfo_EXP.phase1_ObjRecog=frame_num.adj_ocpr_num(:,8);
TrialInfo_EXP.phase1_end=frame_num.adj_ocpr_num(:,31);
TrialInfo_EXP.phase2_start=frame_num.adj_ocpr_num(:,31);
TrialInfo_EXP.phase2_end=frame_num.adj_ocpr_num(:,12);
TrialInfo_EXP.phase3_start=frame_num.adj_ocpr_num(:,32);
TrialInfo_EXP.phase3_end=frame_num.adj_ocpr_num(:,16);

%
TrialInfo_CTRL=table();
TrialInfo_CTRL.trial(1:40) = [1:40];
TrialInfo_CTRL.correct_answer=frame_num.adj_control_num(:,14);
TrialInfo_CTRL.choice_phase2=TrialInfo_CTRL.correct_answer;
TrialInfo_CTRL.choice_phase3=frame_num.adj_control_num(:,15);

TrialInfo_CTRL.correct_phase2=frame_num.adj_control_num(:,10);
TrialInfo_CTRL.correct_phase3=frame_num.adj_control_num(:,13);
TrialInfo_CTRL.correct_phase3(isnan(TrialInfo_CTRL.choice_phase3))=nan;

TrialInfo_CTRL.trial_start=frame_num.adj_control_num(:,30);
TrialInfo_CTRL.phase1_ObjRecog=frame_num.adj_control_num(:,8);
TrialInfo_CTRL.phase1_end=frame_num.adj_control_num(:,31);
TrialInfo_CTRL.phase2_start=frame_num.adj_control_num(:,31);
TrialInfo_CTRL.phase2_end=frame_num.adj_control_num(:,12);
TrialInfo_CTRL.phase3_start=frame_num.adj_control_num(:,32);
TrialInfo_CTRL.phase3_end=frame_num.adj_control_num(:,16);

%
writetable(TrialInfo_EXP, [Root 'TrialInfo_EXP.xlsx'],'writemode','overwrite')
writetable(TrialInfo_CTRL, [Root 'TrialInfo_CTRL.xlsx'],'writemode','overwrite')
writetable(TimeStamp_MR, [Root 'TimeStamp_MR.xlsx'],'writemode','overwrite')
