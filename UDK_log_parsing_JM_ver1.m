
fileToRead1=[ROOT.Raw '\' filename0 '\' strcat(filename,'.log')];
DELIMITER = ' ';
no_trials=80;

% Import the file
rawData1 = importdata(fileToRead1, DELIMITER, 50000);

% For some simple files (such as a CSV or JPEG files), IMPORTDATA might
% return a simple array.  If so, generate a structure so that the output
% matches that from the Import Wizard.
[~,name] = fileparts(fileToRead1);
log_data=rawData1;

%% Get timestamps
timestamp=struct;
no_lines=max(size(log_data));
count_pause=0;count_timeframe=0; count_12=0; count_03=0; count_06=0; count_09=0;
time_old = 0; flag=1;
line_indice_run_start=[]; line_indice_run_end=[];
count_Rstart=0; count_Rend=0;
for i=1:1:no_lines
    k=strfind(log_data{i},'Timeframe');
    if ~isempty(k)
%         count_timeframe=count_timeframe+1;
%         line_indice_timeframe(count_timeframe)=i;

        string = log_data{i};
%         timestamp.timeframe(count_timeframe,1)=str2double(string(2:8));
        time_now = str2double(string(2:8));
        if time_now-time_old<2 | time_now-time_old>10
            if flag==0 
                count_Rend=count_Rend+1;
                line_indice_run_end(count_Rend,1)=j;
            end
            flag=1;
            j0=j;
        else
            if flag==1
                count_Rstart=count_Rstart+1;
                line_indice_run_start(count_Rstart,1)=j0;
            end

            line_index_test_end=i;
            flag=0;
            j0=j;
        end
        time_old = str2double(string(2:8)); j=i;
    end
end

line_indice_run_end = [line_indice_run_end;line_index_test_end];
% line_indice_run_end(1)=[];
line_indice_run = [line_indice_run_start,line_indice_run_end];

timestamp.run=[];
for i=1:length(line_indice_run_end)
    timestamp.run(i,1) = str2double(log_data{line_indice_run_start(i)}(2:8));
    timestamp.run(i,2) = str2double(log_data{line_indice_run_end(i)}(2:8));
end

timestamp.run(timestamp.run(:,2)-timestamp.run(:,1)<10,:)=[];

for i=1:1:no_lines
    l=strfind(log_data{i},'task number: 1');
     if ~isempty(l)
        line_indice_study_end=i;
        string=log_data{i};
        timestamp.studyend=str2double(string(2:8));
        break
     end
end


for j=1:1:max(size(line_indice_run))
    line_start=line_indice_run(j,1);line_end=line_indice_run(j,2);
    for i=line_start:1:line_end
        k=strfind(log_data{i},'Timeframe');
        if ~isempty(k)
            count_timeframe=count_timeframe+1;
            line_indice_timeframe(count_timeframe)=i;
            string=log_data{i};
            timestamp.timeframe(count_timeframe,1)=str2double(string(2:8));
        end
    end
end
for i=1:1:no_lines
    l=strfind(log_data{i},'task number: 1');
     if ~isempty(l)
        line_indice_study_end=i;
        string=log_data{i};
        timestamp.studyend=str2double(string(2:8));
        break
     end
end
%% Evaluating the timestamp adjustment
for i=1:1:length(timestamp.timeframe)
time_timeframe(i)=timestamp.timeframe(i);
end
times1=[time_timeframe 0];
times2=[0 time_timeframe];
a=times1-times2;
at=find(a<2.7 | a>2.9);
%% Adjust timeframe to cut every first 4 images
% timestamp.adj_timeframe=timestamp.timeframe(~ismember(1:size(timestamp.timeframe,1),[1:1:4 129:1:132 245:1:248 373:1:376 486:1:489 606:1:609 727:1:730 851:1:854 971:1:974 1092:1:1095 1214:1:1217 1331:1:1334 1441:1:1444 1551:1:1554])); 
% line_indice_adj_timeframe=line_indice_timeframe(1,~ismember(1:size(timestamp.timeframe,2),[1:1:4 129:1:132 245:1:248 373:1:376 486:1:489 606:1:609 727:1:730 851:1:854 971:1:974 1092:1:1095 1214:1:1217 1331:1:1334 1441:1:1444 1551:1:1554])); 

timestamp.adj_timeframe=timestamp.timeframe;
line_indice_adj_timeframe=line_indice_timeframe;





%studying 4 places once
for i=1:1:line_indice_study_end
    e12=strfind(log_data{i},'enter_arm12');
    e3=strfind(log_data{i},'enter_arm3');
    e6=strfind(log_data{i},'enter_arm6');
    e9=strfind(log_data{i},'enter_arm9');
            
    if  ~isempty(e12) 
        count_12=count_12+1;
        line_indice_enter_12(count_12)=i;
        string=log_data{i};
        timestamp.enter_12(count_12)=str2double(string(2:8));
        
        elseif ~isempty(e3)
        count_03=count_03+1;
        line_indice_enter_03(count_03)=i;
        string=log_data{i};
        timestamp.enter_03(count_03)=str2double(string(2:8));
        
        elseif ~isempty(e6)
        count_06=count_06+1;
        line_indice_enter_06(count_06)=i;
        string=log_data{i};
        timestamp.enter_06(count_06)=str2double(string(2:8));
        
        elseif ~isempty(e9)
        count_09=count_09+1;
        line_indice_enter_09(count_09)=i;
        string=log_data{i};
        timestamp.enter_09(count_09)=str2double(string(2:8));
        
    end
    
end

%% Get study time stats
overall_start_time=timestamp.timeframe(1);
overall_end_time=timestamp.studyend;
overall_time_sec=overall_end_time - overall_start_time;
overall_time_min=overall_time_sec/60;

visits_to_12=count_12/2;
visits_to_03=count_03/2;
visits_to_06=count_06/2;
visits_to_09=count_09/2;

timespent.at12=0;timespent.at03=0;timespent.at06=0;timespent.at09=0;
timespent.at12_1=0;timespent.at12_2=0;timespent.at12_3=0;timespent.at12_4=0;
timespent.at3_1=0;timespent.at3_2=0;timespent.at3_3=0;timespent.at3_4=0;
timespent.at6_1=0;timespent.at6_2=0;timespent.at6_3=0;timespent.at6_4=0;
timespent.at9_1=0;timespent.at9_2=0;timespent.at9_3=0;timespent.at9_4=0;

%calculate the time spent on individual sets
for i=1:1:line_indice_study_end
    k12_1=strfind(log_data{i},'timespent_12_1');
    k12_2=strfind(log_data{i},'timespent_12_2');
    k12_3=strfind(log_data{i},'timespent_12_3');
    k12_4=strfind(log_data{i},'timespent_12_4');
    k3_1=strfind(log_data{i},'timespent_3_1');
    k3_2=strfind(log_data{i},'timespent_3_2');
    k3_3=strfind(log_data{i},'timespent_3_3');
    k3_4=strfind(log_data{i},'timespent_3_4');
    k6_1=strfind(log_data{i},'timespent_6_1');
    k6_2=strfind(log_data{i},'timespent_6_2');
    k6_3=strfind(log_data{i},'timespent_6_3');
    k6_4=strfind(log_data{i},'timespent_6_4');
    k9_1=strfind(log_data{i},'timespent_9_1');
    k9_2=strfind(log_data{i},'timespent_9_2');
    k9_3=strfind(log_data{i},'timespent_9_3');
    k9_4=strfind(log_data{i},'timespent_9_4');
    string=log_data{i};
    
    if ~isempty(k12_1)
        timespent.at12_1=timespent.at12_1+str2num(string(size(string,2)-5:size(string,2)));
    elseif ~isempty(k12_2)
        timespent.at12_2=timespent.at12_2+str2num(string(size(string,2)-5:size(string,2)));
    elseif ~isempty(k12_3)
        timespent.at12_3=timespent.at12_3+str2num(string(size(string,2)-5:size(string,2)));
    elseif ~isempty(k12_4)
        timespent.at12_4=timespent.at12_4+str2num(string(size(string,2)-5:size(string,2)));
    elseif ~isempty(k3_1)
        timespent.at3_1=timespent.at3_1+str2num(string(size(string,2)-5:size(string,2)));
    elseif ~isempty(k3_2)
        timespent.at3_2=timespent.at3_2+str2num(string(size(string,2)-5:size(string,2)));
    elseif ~isempty(k3_3)
        timespent.at3_3=timespent.at3_3+str2num(string(size(string,2)-5:size(string,2)));
    elseif ~isempty(k3_4)
        timespent.at3_4=timespent.at3_4+str2num(string(size(string,2)-5:size(string,2)));
    elseif ~isempty(k6_1)
        timespent.at6_1=timespent.at6_1+str2num(string(size(string,2)-5:size(string,2)));
    elseif ~isempty(k6_2)
        timespent.at6_2=timespent.at6_2+str2num(string(size(string,2)-5:size(string,2)));
    elseif ~isempty(k6_3)
        timespent.at6_3=timespent.at6_3+str2num(string(size(string,2)-5:size(string,2)));
    elseif ~isempty(k6_4)
        timespent.at6_4=timespent.at6_4+str2num(string(size(string,2)-5:size(string,2)));
    elseif ~isempty(k9_1)
        timespent.at9_1=timespent.at9_1+str2num(string(size(string,2)-5:size(string,2)));
    elseif ~isempty(k9_2)
        timespent.at9_2=timespent.at9_2+str2num(string(size(string,2)-5:size(string,2)));
    elseif ~isempty(k9_3)
        timespent.at9_3=timespent.at9_3+str2num(string(size(string,2)-5:size(string,2)));
    elseif ~isempty(k9_4)
        timespent.at9_4=timespent.at9_4+str2num(string(size(string,2)-5:size(string,2)));
    end
end



for i=1:1:visits_to_12
timespent.at12=timespent.at12+timestamp.enter_12(2*i)-timestamp.enter_12(2*i-1);
end

for i=1:1:visits_to_03
timespent.at03=timespent.at03+timestamp.enter_03(2*i)-timestamp.enter_03(2*i-1);
end
for i=1:1:visits_to_06
timespent.at06=timespent.at06+timestamp.enter_06(2*i)-timestamp.enter_06(2*i-1);
end
for i=1:1:visits_to_09
timespent.at09=timespent.at09+timestamp.enter_09(2*i)-timestamp.enter_09(2*i-1);
end
%%
%Get RT for each trial
trial_num_OCPR=1;trial_num_control=1;
line_indice_ocpr=ones(2,no_trials/2);
line_indice_control=ones(2,no_trials/2);

for i=1:1:no_trials
    startstring_OCPR=sprintf('start_OCPR %i',i);
    endstring_OCPR=sprintf('end_OCPR %i',i);
    startstring_control=sprintf('start_control %i',i);
    endstring_control=sprintf('end_control %i',i);
    
    for j=line_indice_study_end:1:no_lines
        a=strfind(log_data{j},startstring_OCPR);
        b=strfind(log_data{j},startstring_control);
        string=log_data{j};
        if ~isempty(a)
             timestamp.OCPR_rt(trial_num_OCPR,1)=str2num(string(2:8));
             line_indice_ocpr(1,i/2)=j;             
             for k=j:1:j+10000
                 %here I need to put lines to get object sampling time
                 c=strfind(log_data{k},endstring_OCPR);
                 if ~isempty(c)
                     timestamp.OCPR_rt(trial_num_OCPR,2)=str2num(log_data{k}(2:8));
                     line_indice_ocpr(2,i/2)=k;
                     timespent.rt_OCPR{trial_num_OCPR}=timestamp.OCPR_rt(trial_num_OCPR,2)-timestamp.OCPR_rt(trial_num_OCPR,1);
                     trial_num_OCPR=trial_num_OCPR+1;
                     break
                 end
             end
         break
        end
        
        if ~isempty(b)
             timestamp.control_rt(trial_num_control,1)=str2num(string(2:8));
             line_indice_control(1,i/2+0.5)=j;   
             for k=j:1:j+10000
                 d=strfind(log_data{k},endstring_control);
                 if ~isempty(d)
                     timestamp.control_rt(trial_num_control,2)=str2num(log_data{k}(2:8));
                     line_indice_control(2,i/2+0.5)=k;
                     timespent.rt_control{trial_num_control}=timestamp.control_rt(trial_num_control,2)-timestamp.control_rt(trial_num_control,1);
                     trial_num_control=trial_num_control+1;
                     break
                 end
             end
        break  
        end
    end
     
end

count_coords=0;
for i=line_indice_timeframe(5):1:line_indice_study_end
    coordstring='coordinates';
    k=strfind(log_data{i},coordstring);
    if ~isempty(k)
    string=log_data{i};
    count_coords=count_coords+1;
    b=sscanf(string,'%*c%f%*c %*4c %*7c X=%f Y=%f Z=%f',[4 Inf]);
    coords_test_visit(count_coords,1)=b(1);
    coords_test_visit(count_coords,2)=b(2);
    coords_test_visit(count_coords,3)=b(3);
    coords_test_visit(count_coords,4)=b(4);
    end
end

count_coords=0;
for i=line_indice_study_end:1:no_lines
    coordstring='coordinates';
    k=strfind(log_data{i},coordstring);
    if ~isempty(k)
    string=log_data{i};
    count_coords=count_coords+1;
    b=sscanf(string,'%*c%f%*c %*4c %*7c X=%f Y=%f Z=%f',[4 Inf]);
    coords_test_test(count_coords,1)=b(1);
    coords_test_test(count_coords,2)=b(2);
    coords_test_test(count_coords,3)=b(3);
    coords_test_test(count_coords,4)=b(4);
    
    end
end

f1= figure;
plot(coords_test_visit(:,2),coords_test_visit(:,3))
figurename1=strcat(filename,'_visit.png');
saveas(f1,[ROOT.Save '\' filename0 '\' figurename1]);

f2=figure;
plot(coords_test_test(:,2),coords_test_test(:,3))
figurename2=strcat(filename,'_test.png');
saveas(f2, [ROOT.Save '\' filename0 '\' figurename2]);
    

    
    



% timespent

%%
%%Get object novelty task performance
count_acc_control=0;count_repeated_control=0;
count_acc_OCPR=0;count_repeated_OCPR=0;
corr_string1='acc_control_correct';
corr_string2='acc_OCPR_correct';
repeat_detection=0;

for i=line_indice_study_end:1:no_lines
    s=strfind(log_data{i},corr_string1);
    repeat_detection=0;
    if ~isempty(s) 
        string=log_data{i};
        for j=1:1:i-1
             t=strcmp(log_data{j}(10:size(log_data{j},2)), string(10:size(string,2)));
            if t==1
               repeat_detection=1;
            else
               repeat_detection=0;
            end
        end
        
        if repeat_detection == 0
            count_acc_control=count_acc_control+1;
            line_indice_acc_control(count_acc_control)=i;
            string=log_data{i};
            timestamp.acc_control(count_acc_control)=str2double(string(2:8));
        end
        
    else u=strfind(log_data{i},corr_string2);
        if ~isempty(u)
            string=log_data{i};
            for j=1:1:i-1
                v=strfind(log_data{j}, string(10:size(string,2)));
                if v==1
                    repeat_detection=1;
                else 
                    repeat_detection=0;
                end
            end
            
            if repeat_detection==0
                count_acc_OCPR=count_acc_OCPR+1;
                line_indice_acc_OCPR(count_acc_OCPR)=i;
                string=log_data{i};
                timestamp.acc_OCPR(count_acc_OCPR)=str2double(string(2:8));
                objectstamp.acc_OCPR{count_acc_OCPR}=string(size(string,2)-17:size(string,2)-2);
            end
            
        end
     end
end

count_wrong_OCPR=0;
for i=line_indice_study_end:1:no_lines
    repeat_detection=0;
    w=strfind(log_data{i},'acc_OCPR_wrong');
        if ~isempty(w)
            string=log_data{i};
            for j=1:1:i-1
                x=strfind(log_data{j}, string(10:size(string,2)));
                if x==1
                    repeat_detection=1;
                else 
                    repeat_detection=0;
                end
            end
            
            if repeat_detection==0
                count_wrong_OCPR=count_wrong_OCPR+1;
                line_indice_wrong(count_wrong_OCPR)=i;
                string=log_data{i};
                timestamp.wrong_OCPR(count_wrong_OCPR)=str2double(string(2:8));
                objectstamp.wrong_OCPR{count_wrong_OCPR}=string(size(string,2)-17:size(string,2)-2);
            end
            
        end
end

%%
%%get frame numbers for beginning and end of each trials
% Getting fMRI frame number from timestamps
frame_num.ocpr=zeros(size(timestamp.timeframe,1),1);
frame_num.control=zeros(size(timestamp.timeframe,1),1);

for i=1:1:size(timestamp.OCPR_rt,1)
    time1=timestamp.OCPR_rt(i,1);
    time2=timestamp.OCPR_rt(i,2);
    
    for j=1:1:size(timestamp.timeframe,1)
        if timestamp.timeframe(j)>=time1 & timestamp.timeframe(j)<=time2
            frame_num.ocpr(j,1)=i; frame_num.ocpr(j-1,1)=i;

        end
    end
end

for i=1:1:size(timestamp.control_rt,1)
    time1=timestamp.control_rt(i,1);
    time2=timestamp.control_rt(i,2);
    
    for j=1:1:size(timestamp.timeframe,1)
        if timestamp.timeframe(j)>=time1 & timestamp.timeframe(j)<=time2
            frame_num.control(j,1)=i; frame_num.control(j-1,1)=i;

        end
    end
end

            
frame_num.ocpr_num=nan(40,39);
frame_num.control_num=nan(40,39);
%1=start_frame, 2=trial-end, 3=trial duration, 4=2ndphase_start,5=3rdphase
%start, 6=3rd phase rt, 7=object_decision, 8=obj_line_indice,9=2ndphase
%angle, 10=2ndphase acc 11=2rd phase decision, 12=2nd phase time, 13=3rd
%phase acc, 14=3rd phase answer, 15=3rd phase choice.
% contrast_frame2=[0;frame_num.control];
% contrast_frame1=[frame_num.control;0];


frame_num.rev_control=frame_num.control; 
contrast_frame2=[0;frame_num.rev_control];
contrast_frame1=[frame_num.rev_control;0];


frame_contrast=contrast_frame1-contrast_frame2;
for i=1:1:40
    frame_num.control_num(i,1)=find(frame_contrast(:)==i);
    frame_num.control_num(i,2)=find(frame_contrast(:)==(i*-1))-1;
    frame_num.control_num(i,3)=frame_num.control_num(i,2)-frame_num.control_num(i,1)+1;
    frame_num.control_num(i,4)=frame_num.control_num(i,1)+4;
    frame_num.control_num(i,5)=frame_num.control_num(i,1)+8;
    frame_num.control_num(i,6)= frame_num.control_num(i,3)-8;
    
end

% contrast_frame2=[0;frame_num.ocpr];
% contrast_frame1=[frame_num.ocpr;0];

frame_num.rev_ocpr=frame_num.ocpr;
contrast_frame2=[0;frame_num.rev_ocpr];
contrast_frame1=[frame_num.rev_ocpr;0];

frame_contrast=contrast_frame1-contrast_frame2;

for i=1:1:40
    frame_num.ocpr_num(i,1)=find(frame_contrast(:)==i);
    frame_num.ocpr_num(i,2)=find(frame_contrast(:)==(i*-1))-1;
    frame_num.ocpr_num(i,3)=frame_num.ocpr_num(i,2)-frame_num.ocpr_num(i,1)+1;
    frame_num.ocpr_num(i,4)=frame_num.ocpr_num(i,1)+4;
    frame_num.ocpr_num(i,5)=frame_num.ocpr_num(i,1)+8;
    frame_num.ocpr_num(i,6)= frame_num.ocpr_num(i,3)-8;
    
end






%add epoch specific info in frame_num matrix
decision_object_string='1st decision';
decision_place_string='2nd decision';
decision_navigate_string='acc_OCPR';
end_place_string = '3rd period';

for i=1:1:no_trials/2
            timeout=1;
    frame_num.ocpr_num(i,17)=line_indice_adj_timeframe(frame_num.ocpr_num(i,4));
    frame_num.ocpr_num(i,19)=line_indice_adj_timeframe(frame_num.ocpr_num(i,5));
    frame_num.ocpr_num(i,30)=str2num(log_data{line_indice_adj_timeframe(frame_num.ocpr_num(i,1))}(2:8));
    frame_num.ocpr_num(i,31)=str2num(log_data{line_indice_adj_timeframe(frame_num.ocpr_num(i,4))}(2:8));
    frame_num.ocpr_num(i,32)=str2num(log_data{line_indice_adj_timeframe(frame_num.ocpr_num(i,5))}(2:8));
    
    for j=line_indice_ocpr(1,i):1:line_indice_ocpr(2,i)
        f1=strfind(log_data{j},decision_object_string);
        f2=strfind(log_data{j},decision_place_string);
        f3=strfind(log_data{j},decision_navigate_string);
        f0 = strfind(log_data{j},end_place_string);
        if ~isempty(f1)
            frame_num.ocpr_num(i,8)=str2num(log_data{j}(2:8));%timestamp at 1st decision
            for k=j-12:1:j+12
                f4=strfind(log_data{k},'Timeframe');
                if ~isempty(f4)
                    
                    if ~isempty(find(line_indice_adj_timeframe==k))
                    frame_num.ocpr_num(i,7)=find(line_indice_adj_timeframe==k); %timeframe closest to 1st decision
                    end
                    break
                end
            end
        end
        
        if ~isempty(f2)
            timeout=0;
            frame_num.ocpr_num(i,39) = timeout;
            frame_num.ocpr_num(i,18)=j;
            frame_num.ocpr_num(i,9)=str2num(log_data{j}(strfind(log_data{j},'Y=')+2:strfind(log_data{j},'Z')-1));
            frame_num.ocpr_num(i,12)=str2num(log_data{j}(2:8));%timestamp at 2nd decision          
            for k=j-12:1:j+12
                f4=strfind(log_data{k},'Timeframe');
                if ~isempty(f4)
                    if ~isempty(find(line_indice_adj_timeframe==k))
                    frame_num.ocpr_num(i,11)=find(line_indice_adj_timeframe==k);%timeframe closest to 2nd decision
                    end
                    break
                end
            end
        end

        if ~isempty(f0) && timeout==1
            frame_num.ocpr_num(i,39) = timeout;
                  frame_num.ocpr_num(i,18)=j;
            frame_num.ocpr_num(i,9)=str2num(log_data{j-4}(strfind(log_data{j-4},'Y=')+2:strfind(log_data{j-4},'Z')-1));
            frame_num.ocpr_num(i,12)=str2num(log_data{j-2}(2:8));%timestamp at 2nd decision          
            for k=j-12:1:j+12
                f4=strfind(log_data{k},'Timeframe');
                if ~isempty(f4)
                    if ~isempty(find(line_indice_adj_timeframe==k))
                    frame_num.ocpr_num(i,11)=find(line_indice_adj_timeframe==k);%timeframe closest to 2nd decision
                    end
                    break
                end
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
end_place_string = '3rd period';

for i=1:1:no_trials/2
    timeout=1;
    frame_num.control_num(i,17)=line_indice_adj_timeframe(frame_num.control_num(i,4));
    frame_num.control_num(i,19)=line_indice_adj_timeframe(frame_num.control_num(i,5));
    frame_num.control_num(i,30)=str2num(log_data{line_indice_adj_timeframe(frame_num.control_num(i,1))}(2:8));
    frame_num.control_num(i,31)=str2num(log_data{line_indice_adj_timeframe(frame_num.control_num(i,4))}(2:8));
    frame_num.control_num(i,32)=str2num(log_data{line_indice_adj_timeframe(frame_num.control_num(i,5))}(2:8));
    for j=line_indice_control(1,i):1:line_indice_control(2,i)
        f1=strfind(log_data{j},decision_object_string);
        f2=strfind(log_data{j},decision_place_string);
        f3=strfind(log_data{j},decision_navigate_string);
        f0=strfind(log_data{j},end_place_string);
        if ~isempty(f1)
            frame_num.control_num(i,8)=str2num(log_data{j}(2:8));%timestamp at 1st decision
            for k=j-12:1:j+12
                f4=strfind(log_data{k},'Timeframe');
                if ~isempty(f4)
                    if ~isempty(find(line_indice_adj_timeframe==k))
                    frame_num.control_num(i,7)=find(line_indice_adj_timeframe==k,1);%timeframe closest to 1st decision
                    end
                    break
                end
            end
        end

                if ~isempty(f2)
            timeout=0;
frame_num.control_num(i,39)=timeout;
            frame_num.control_num(i,18)=j;
            frame_num.control_num(i,9)=str2num(log_data{j}(strfind(log_data{j},'Y=')+2:strfind(log_data{j},'Z')-1));
            frame_num.control_num(i,12)=str2num(log_data{j}(2:8));%timestamp at 2nd decision
            for k=j-12:1:j+12
                f4=strfind(log_data{k},'Timeframe');
                if ~isempty(f4)
                    
                    frame_num.control_num(i,11)=find(line_indice_adj_timeframe==k); %timeframe closest to 2nd decision
                    break
                end
            end
                end

                  if ~isempty(f0) && timeout==1
            timeout=0;
frame_num.control_num(i,39)=timeout;
            frame_num.control_num(i,18)=j;
            frame_num.control_num(i,9)=str2num(log_data{j-4}(strfind(log_data{j-4},'Y=')+2:strfind(log_data{j-4},'Z')-1));
            frame_num.control_num(i,12)=str2num(log_data{j-2}(2:8));%timestamp at 2nd decision
            for k=j-12:1:j+12
                f4=strfind(log_data{k},'Timeframe');
                if ~isempty(f4)
                    
                    frame_num.control_num(i,11)=find(line_indice_adj_timeframe==k); %timeframe closest to 2nd decision
                    break
                end
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


frame_num.epoch3_ocpr_movement_trace=[];frame_num.epoch3_ocpr_rotation_trace=[];
frame_num.epoch3_control_movement_trace=[];frame_num.epoch3_control_rotation_trace=[];
frame_num.epoch2_ocpr_rotation_trace=[];frame_num.epoch2_control_rotation_trace=[];
%angle calculations
for i=1:1:no_trials/2
    initial_angle=0;
    moved_angle=0;
    end_angle=0;
    initial_angle3=0;
    moved_angle3=0;
    end_angle3=0;
    deviant_moved_angle_per_t=0;
    deviant_moved_angle=0;deviant_adj_angle=0;
    first_enter=0;entered_zone=0;t=0;
    direction=0;
    
    %epoch2
    if ~isnan(frame_num.ocpr_num(i,18))
    for j=frame_num.ocpr_num(i,17)+4:1:frame_num.ocpr_num(i,18)
        f5=strfind(log_data{j},'rotation');
        if ~isempty(f5)
            angle_t1=str2num(log_data{j}(strfind(log_data{j},'Y=')+2:strfind(log_data{j},'Z')-1));
            if angle_t1<=0
                angle_t1=65536+angle_t1;
            elseif angle_t1>65536
                angle_t1=angle_t1-65536;
            end
            frame_num.ocpr_num(i,21)=angle_t1;
            break
        end
    end
    
    zone_width=65536*(45/360);
    
    %calculating quadrant from choice
    for p=1:1:4
        switch p
            case 1
                range1=16384-zone_width ;range2=16384; range3=16384;range4=16384+zone_width;direction=3;
            case 2
                range1=32768-zone_width ;range2=32768; range3=32768;range4=32768+zone_width;direction=6;
            case 3
                range1=49152-zone_width;range2=49152; range3=49152;range4=49152+zone_width;direction=9;
            case 4
                range1=65536-zone_width;range2=65536;range3=0 ;range4=zone_width;direction=12;
        end
        
        if (range1<=frame_num.ocpr_num(i,9) && frame_num.ocpr_num(i,9)<=range2) || (range3<=frame_num.ocpr_num(i,9) && frame_num.ocpr_num(i,9)<=range4)
            frame_num.ocpr_num(i,36)=direction;
            break
        end
    end
    
    
    frame_num.ocpr_num(i,37)=frame_num.ocpr_num(i,14)-frame_num.ocpr_num(i,36);
    
    
    zone_width=65536*(30/360); 
    %calculating target zone range
    switch frame_num.ocpr_num(i,14)
        case 3
            range1=16384-zone_width ;range2=16384; range3=16384;range4=16384+zone_width;
        case 6
            range1=32768-zone_width ;range2=32768; range3=32768;range4=32768+zone_width;
        case 9
            range1=49152-zone_width;range2=49152; range3=49152;range4=49152+zone_width;
        case 12
             range1=65536-zone_width;range2=65536;range3=0 ;range4=zone_width;
        otherwise
    end
    
    ocpr_trial_rotation_trace=[];
    for k=frame_num.ocpr_num(i,17)+4:1:frame_num.ocpr_num(i,18)
        f6=strfind(log_data{k},'rotation');
        
        if ~isempty(f6)
            angle_t2=str2num(log_data{k}(strfind(log_data{k},'Y=')+2:strfind(log_data{k},'Z')-1));
            if angle_t2<=0
                angle_t2=65536+angle_t2;
            elseif angle_t2>65536
                angle_t2=angle_t2-65536;
            end
            
            t=t+1;
            if t==2
                initial_angle_difference=angle_t2-frame_num.ocpr_num(i,21)
                if abs(initial_angle_difference)>50000
                    frame_num.ocpr_num(i,33)=sign(initial_angle_difference*-1);
                else
                    frame_num.ocpr_num(i,33)=sign(initial_angle_difference);%-1 for right and 1 for left
                end
            end
            
            if (range1<=angle_t2 && angle_t2<=range2) || (range3<=angle_t2 && angle_t2<=range4)
                entered_zone=1;first_enter=first_enter+1;
                if first_enter==1
                    if abs(angle_t2-frame_num.ocpr_num(:,21))>=zone_width
                        deviant_adj_angle=min(min(abs(angle_t1-range1),abs(abs(angle_t1-range1)-65536)),min(abs(angle_t1-range4),abs(abs(angle_t1-range4)-65536)));
                    end
                end
            end
            
            moved_angle_per_t=min(abs(angle_t2-angle_t1),abs(abs(angle_t2-angle_t1)-65536));
            moved_angle=moved_angle+moved_angle_per_t;
            
            if entered_zone==1
                deviant_moved_angle_per_t=min(abs(angle_t2-angle_t1),abs(abs(angle_t2-angle_t1)-65536));
                deviant_moved_angle=deviant_moved_angle+deviant_moved_angle_per_t;
            end
            
            
            rotation_trace=[angle_t2 i frame_num.ocpr_num(i,10)];
            ocpr_trial_rotation_trace=[ocpr_trial_rotation_trace; rotation_trace];
            angle_t1=angle_t2;
            end_angle=angle_t2;
        end
    end
    frame_num.ocpr_num(i,23)=moved_angle; 
    frame_num.ocpr_num(i,34)=(deviant_moved_angle-deviant_adj_angle)./zone_width;
    frame_num.ocpr_num(i,35)=first_enter;
    frame_num.ocpr_num(i,22)=frame_num.ocpr_num(i,14)*65536/12;
    frame_num.ocpr_num(i,24)=min(abs(frame_num.ocpr_num(i,22)-frame_num.ocpr_num(i,21)),abs(abs(frame_num.ocpr_num(i,22)-frame_num.ocpr_num(i,21))-65536));
    frame_num.ocpr_num(i,38)=frame_num.ocpr_num(i,9)-frame_num.ocpr_num(i,22);
    frame_num.epoch2_ocpr_rotation_trace=[frame_num.epoch2_ocpr_rotation_trace; ocpr_trial_rotation_trace];
  
    end
    %epoch3
    for l=frame_num.ocpr_num(i,19)+4:1:frame_num.ocpr_num(i,20)
        f7=strfind(log_data{l},'rotation');
        if ~isempty(f7)
            angle_t1=str2num(log_data{l}(strfind(log_data{l},'Y=')+2:strfind(log_data{l},'Z')-1));
            if angle_t1<=0
                angle_t1=65536+angle_t1;
            elseif angle_t1>65536
                angle_t1=angle_t1-65536;
            end
            frame_num.ocpr_num(i,25)=angle_t1;
            break
        end
    end
    
    for m=frame_num.ocpr_num(i,19)+4:1:frame_num.ocpr_num(i,20)
        f8=strfind(log_data{m},'rotation');
        if ~isempty(f8)
            angle_t2=str2num(log_data{m}(strfind(log_data{m},'Y=')+2:strfind(log_data{m},'Z')-1));
            if angle_t2<=0
                angle_t2=65536+angle_t2;
            elseif angle_t2>65536
                angle_t2=angle_t2-65536;
            end
            moved_angle_per_t=min(abs(angle_t2-angle_t1),abs(abs(angle_t2-angle_t1)-65536));
            moved_angle3=moved_angle3+moved_angle_per_t;
            angle_t1=angle_t2;
        end
    end
    
    %record period3 coordinates
    ocpr_trial_movement_trace=[];movement_trace=[];
    for n=frame_num.ocpr_num(i,19)+4:1:frame_num.ocpr_num(i,20)
        f9=strfind(log_data{n},'coordinate');
        if ~isempty(f9)
            x_coordinate=str2num(log_data{n}(strfind(log_data{n},'X=')+2:strfind(log_data{n},'Y')-1));
            y_coordinate=str2num(log_data{n}(strfind(log_data{n},'Y=')+2:strfind(log_data{n},'Z')-1));
            movement_trace=[x_coordinate y_coordinate i frame_num.ocpr_num(i,13)];
            ocpr_trial_movement_trace=[ocpr_trial_movement_trace; movement_trace];
        end
    end
    frame_num.ocpr_num(i,26)=angle_t2;
    frame_num.ocpr_num(i,28)=moved_angle3;
    frame_num.ocpr_num(i,27)=frame_num.ocpr_num(i,9);
    frame_num.ocpr_num(i,29)=min(abs(frame_num.ocpr_num(i,28)-frame_num.ocpr_num(i,25)),abs(abs(frame_num.ocpr_num(i,28)-frame_num.ocpr_num(i,25))-65536));
    frame_num.epoch3_ocpr_movement_trace=[frame_num.epoch3_ocpr_movement_trace; ocpr_trial_movement_trace];
    
    %record rotation angles
    ocpr_trial_rotation_trace=[];rotation_trace=[];
    for n=frame_num.ocpr_num(i,19)+4:1:frame_num.ocpr_num(i,20)
        f9=strfind(log_data{n},'rotation');
        if ~isempty(f9)
            y_coordinate=str2num(log_data{n}(strfind(log_data{n},'Y=')+2:strfind(log_data{n},'Z')-1));
            rotation_trace=[y_coordinate i frame_num.ocpr_num(i,13)];
            ocpr_trial_rotation_trace=[ocpr_trial_rotation_trace; rotation_trace];
        end
    end
    
    frame_num.epoch3_ocpr_rotation_trace=[frame_num.epoch3_ocpr_rotation_trace; ocpr_trial_rotation_trace];
    
    
    
  
end

for i=1:1:no_trials/2
    initial_angle=0;
    moved_angle=0;
    end_angle=0;
    initial_angle3=0;
    moved_angle3=0;
    end_angle3=0;
    if ~isnan(frame_num.control_num(i,18))
        for j=frame_num.control_num(i,17)+4:1:frame_num.control_num(i,18)
            f5=strfind(log_data{j},'rotation');
            if ~isempty(f5)
                angle_t1=str2num(log_data{j}(strfind(log_data{j},'Y=')+2:strfind(log_data{j},'Z')-1));
                if angle_t1<=0
                    angle_t2=65536+angle_t1;
                elseif angle_t1>65536
                    angle_t1=angle_t1-65536;
                end
                frame_num.control_num(i,21)=angle_t1;
                break
            end
        end
        
        control_trial_rotation_trace=[];
        for k=frame_num.control_num(i,17)+4:1:frame_num.control_num(i,18)
            f6=strfind(log_data{k},'rotation');
            if ~isempty(f6)
                angle_t2=str2num(log_data{k}(strfind(log_data{k},'Y=')+2:strfind(log_data{k},'Z')-1));
                if angle_t2<=0
                    angle_t2=65536+angle_t2;
                elseif angle_t2>65536
                    angle_t2=angle_t2-65536;
                end
                moved_angle_per_t=min(abs(angle_t2-angle_t1),abs(abs(angle_t2-angle_t1)-65536));
                moved_angle=moved_angle+moved_angle_per_t;
                rotation_trace=[angle_t2 i frame_num.control_num(i,10)];
                control_trial_rotation_trace=[control_trial_rotation_trace; rotation_trace];
                angle_t1=angle_t2;
                end_angle=angle_t2;
            end
        end
        frame_num.control_num(i,23)=moved_angle;
        frame_num.control_num(i,22)=frame_num.control_num(i,14)*65536/12;
        frame_num.control_num(i,24)=min(abs(frame_num.control_num(i,22)-frame_num.control_num(i,21)),abs(abs(frame_num.control_num(i,22)-frame_num.control_num(i,21))-65536));
        frame_num.epoch2_control_rotation_trace=[frame_num.epoch2_control_rotation_trace; control_trial_rotation_trace];
    end
    
     %epoch3
     for l=frame_num.control_num(i,19)+4:1:frame_num.control_num(i,20)
        f7=strfind(log_data{l},'rotation');
        if ~isempty(f7)
            angle_t1=str2num(log_data{l}(strfind(log_data{l},'Y=')+2:strfind(log_data{l},'Z')-1));
            if angle_t1<=0
                angle_t1=65536+angle_t1;
            elseif angle_t1>65536
                angle_t1=angle_t1-65536;
            end
            frame_num.control_num(i,25)=angle_t1;
            break
        end
    end
    
    for m=frame_num.control_num(i,19)+4:1:frame_num.control_num(i,20)
        f8=strfind(log_data{m},'rotation');
        if ~isempty(f8)
            angle_t2=str2num(log_data{m}(strfind(log_data{m},'Y=')+2:strfind(log_data{m},'Z')-1));
            if angle_t2<=0
                angle_t2=65536+angle_t2;
            elseif angle_t2>65536
                angle_t2=angle_t2-65536;
            end
            moved_angle_per_t=min(abs(angle_t2-angle_t1),abs(abs(angle_t2-angle_t1)-65536));
            moved_angle3=moved_angle3+moved_angle_per_t;
            angle_t1=angle_t2;
        end
    end
    frame_num.control_num(i,26)=angle_t2;
    frame_num.control_num(i,28)=moved_angle3;
    frame_num.control_num(i,27)=frame_num.control_num(i,9);
    frame_num.control_num(i,29)=min(abs(frame_num.control_num(i,28)-frame_num.control_num(i,25)),abs(abs(frame_num.control_num(i,28)-frame_num.control_num(i,25))-65536));
    
    
    %record period3 coordinates
    control_trial_movement_trace=[];movement_trace=[];
    for n=frame_num.control_num(i,19)+4:1:frame_num.control_num(i,20)
        f9=strfind(log_data{n},'coordinate');
        if ~isempty(f9)
            x_coordinate=str2num(log_data{n}(strfind(log_data{n},'X=')+2:strfind(log_data{n},'Y')-1));
            y_coordinate=str2num(log_data{n}(strfind(log_data{n},'Y=')+2:strfind(log_data{n},'Z')-1));
            movement_trace=[x_coordinate y_coordinate i frame_num.control_num(i,13)];
            control_trial_movement_trace=[control_trial_movement_trace; movement_trace];
        end
    end
    
    frame_num.epoch3_control_movement_trace=[frame_num.epoch3_control_movement_trace; control_trial_movement_trace];
    
    %record rotation angles
    control_trial_rotation_trace=[];rotation_trace=[];
    for n=frame_num.control_num(i,19)+4:1:frame_num.control_num(i,20)
        f9=strfind(log_data{n},'rotation');
        if ~isempty(f9)
            y_coordinate=str2num(log_data{n}(strfind(log_data{n},'Y=')+2:strfind(log_data{n},'Z')-1));
            rotation_trace=[y_coordinate i frame_num.control_num(i,13)];
            control_trial_rotation_trace=[control_trial_rotation_trace; rotation_trace];
        end
    end
    
    frame_num.epoch3_control_rotation_trace=[frame_num.epoch3_control_rotation_trace; control_trial_rotation_trace];
    
    
    
    
    
  
end

%adjust frame_num latencies for nan trials to 11.2s
frame_num.adj_ocpr_num=frame_num.ocpr_num;
frame_num.adj_ocpr_num(isnan(frame_num.adj_ocpr_num(:,8)),8)=frame_num.adj_ocpr_num(isnan(frame_num.adj_ocpr_num(:,8)),31);
frame_num.adj_ocpr_num(frame_num.adj_ocpr_num(:,38)<0,38)=frame_num.adj_ocpr_num(frame_num.adj_ocpr_num(:,38)<0,38)+65536;
frame_num.epoch2_trace=frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,38)),38).*(360/65536);%epoch2 place choice in deg


frame_num.adj_control_num=frame_num.control_num;
frame_num.adj_control_num(isnan(frame_num.adj_control_num(:,8)),8)=frame_num.adj_control_num(isnan(frame_num.adj_control_num(:,8)),31);



%% Prepare data line for statview_OCPR
%epoch1(no_decision/lat/corr_lat/incorr_lat)
v1=sum(~isnan(frame_num.adj_ocpr_num(:,8)));
v2=mean(frame_num.adj_ocpr_num(find(~isnan(frame_num.adj_ocpr_num(:,8))),8)-frame_num.adj_ocpr_num(find(~isnan(frame_num.adj_ocpr_num(:,8))),30));

v3=nanmean(frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,10)),8)-frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,10)),30));
v4=nanmean(frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,10)==0),8)-frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,10)==0),30));

%epoch2(%perf,latency,norm_lat,corr_lat,incorr_lat,corr_norm_lat,
%incorr_norm_lat,angle,norm_ang,corr_ang,incorr_ang,corr_norm_ang,incorr_norm_ang)
v5=sum(frame_num.adj_ocpr_num(:,10)==1)/40;
v6=mean(frame_num.adj_ocpr_num(find(~isnan(frame_num.adj_ocpr_num(:,12))),12)-frame_num.adj_ocpr_num(find(~isnan(frame_num.adj_ocpr_num(:,12))),31));
v7=0;
v8=nanmean(frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,10)==1),12)-frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,10)==1),31));
v9=nanmean(frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,10)==0),12)-frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,10)==0),31));
v10=0;
v11=0;
v12=nanmean(frame_num.adj_ocpr_num(:,23));
v13=nanmean(frame_num.adj_ocpr_num(:,23)./(frame_num.adj_ocpr_num(:,24)+1));
v14=nanmean(frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,10)==1),23));
v15=nanmean(frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,10)==0),23));
%corr_norm_ang, incorr_norm_ang
v16=nanmean(frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,10)==1),23)./(frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,10)==1),24)+1));
v17=nanmean(frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,10)==0),23)./(frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,10)==0),24)+1));

%epoch3(%perf,latency,norm_lat,,corr_lat,incorr_lat
v18=sum(frame_num.adj_ocpr_num(:,13)==1)/(40-sum(isnan(frame_num.adj_ocpr_num(:,13))));
v19=mean(frame_num.adj_ocpr_num(find(~isnan(frame_num.adj_ocpr_num(:,13))),16)-frame_num.adj_ocpr_num(find(~isnan(frame_num.adj_ocpr_num(:,13))),32));
v20=0;
v21=nanmean(frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,13)==1),16)-frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,13)==1),32));
v22=nanmean(frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,13)==0),16)-frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,13)==0),32));
%lat for 0,90,180
v23=nanmean(frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,29)<3000),16)-frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,29)<3000),32));
v24=nanmean(frame_num.adj_ocpr_num(find(abs(frame_num.adj_ocpr_num(:,29)-14000)<7000),16)-frame_num.adj_ocpr_num(find(abs(frame_num.adj_ocpr_num(:,29)-14000)<7000),32));
v25=nanmean(frame_num.adj_ocpr_num(find(abs(frame_num.adj_ocpr_num(:,29)-30000)<7000),16)-frame_num.adj_ocpr_num(find(abs(frame_num.adj_ocpr_num(:,29)-30000)<7000),32));
%corr_norm_lat,incorr_norm_lat 
v26=0;
v27=0;
%angle,norm_angle,corr_ang,inorr_ang
v28=nanmean(frame_num.adj_ocpr_num(:,28));
v29=nanmean(frame_num.adj_ocpr_num(:,28)./(1+frame_num.adj_ocpr_num(:,29)));
v30=nanmean(frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,13)==1),28));
v31=nanmean(frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,13)==0),28));
%angle at 0,90,180 degrees
v32=nanmean(frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,29)<3000),28));
v33=nanmean(frame_num.adj_ocpr_num(find(abs(frame_num.adj_ocpr_num(:,29)-14000)<7000),28));
v34=nanmean(frame_num.adj_ocpr_num(find(abs(frame_num.adj_ocpr_num(:,29)-30000)<7000),28));
%corr_nomg_ang,incorr_norm_ang
v35=nanmean(frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,13)==1),28)./(1+frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,13)==1),29)));
v36=nanmean(frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,13)==0),28)./(1+frame_num.adj_ocpr_num(find(frame_num.adj_ocpr_num(:,13)==0),29)));

%epoch1 latency std/ste
v37=std(frame_num.adj_ocpr_num(find(~isnan(frame_num.adj_ocpr_num(:,8))),8)-frame_num.adj_ocpr_num(find(~isnan(frame_num.adj_ocpr_num(:,8))),30));
v38=v37/sqrt(40);

%epoch2  choice quadrant
v39=size(find(frame_num.adj_ocpr_num(:,37)==0),1);
v40=(size(find(frame_num.adj_ocpr_num(:,37)==3),1)+size(find(frame_num.adj_ocpr_num(:,37)==-9),1));
v41=(size(find(frame_num.adj_ocpr_num(:,37)==-3),1)+size(find(frame_num.adj_ocpr_num(:,37)==9),1));
v42=(size(find(frame_num.adj_ocpr_num(:,37)==-6),1)+size(find(frame_num.adj_ocpr_num(:,37)==6),1));
%number of misses
v43=sum(isnan(frame_num.adj_ocpr_num(:,37)));
%average deviant angle in deg
v44=nanmean(frame_num.adj_ocpr_num(:,34));

%bias to left/right for initial turning in epoch2
v45=size(find(frame_num.adj_ocpr_num(:,33)==1),1);
v46=size(find(frame_num.adj_ocpr_num(:,33)==-1),1);
v47=mode(frame_num.adj_ocpr_num(:,33));
v48=nansum(frame_num.adj_ocpr_num(:,33));

%ste of deviant anlge from deg of deviant angle
v49=nanstd(frame_num.adj_ocpr_num(:,34))/sqrt(40-v43);
v50=(v39-v40)/(v39+v40)+(v39-v41)/(v39+v41);

%save per subject behavioral data
individual_subject_behavior_ocpr=[v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v22 v23 v24 v25 v26 v27 v28 v29 v30 v31 v32 v33 v34 v35 v36 v37 v38 v39 v40 v41 v42 v43 v44 v45 v46 v47 v48 v49 v50];

%% Prepare data line for statview_control
%epoch1(no_decision/lat/corr_lat/incorr_lat)
v1=sum(~isnan(frame_num.adj_control_num(:,8)));
v2=mean(frame_num.adj_control_num(find(~isnan(frame_num.adj_control_num(:,8))),8)-frame_num.adj_control_num(find(~isnan(frame_num.adj_control_num(:,8))),30));
v3=nanmean(frame_num.adj_control_num(find(frame_num.adj_control_num(:,10)),8)-frame_num.adj_control_num(find(frame_num.adj_control_num(:,10)),30));
v4=nanmean(frame_num.adj_control_num(find(frame_num.adj_control_num(:,10)==0),8)-frame_num.adj_control_num(find(frame_num.adj_control_num(:,10)==0),30));

%epoch2(%perf,latency,norm_lat,corr_lat,incorr_lat,corr_norm_lat,
%incorr_norm_lat,angle,norm_ang,corr_ang,incorr_ang,corr_norm_ang,incorr_norm_ang)
v5=sum(frame_num.adj_control_num(:,10)==1)/40;
v6=mean(frame_num.adj_control_num(find(~isnan(frame_num.adj_control_num(:,12))),12)-frame_num.adj_control_num(find(~isnan(frame_num.adj_control_num(:,12))),31));
v7=0;
v8=nanmean(frame_num.adj_control_num(find(frame_num.adj_control_num(:,10)==1),12)-frame_num.adj_control_num(find(frame_num.adj_control_num(:,10)==1),31));
v9=nanmean(frame_num.adj_control_num(find(frame_num.adj_control_num(:,10)==0),12)-frame_num.adj_control_num(find(frame_num.adj_control_num(:,10)==0),31));
v10=0;
v11=0;
v12=nanmean(frame_num.adj_control_num(:,23));
v13=nanmean(frame_num.adj_control_num(:,23)./(1+frame_num.adj_control_num(:,24)));
v14=nanmean(frame_num.adj_control_num(find(frame_num.adj_control_num(:,10)==1),23));
v15=nanmean(frame_num.adj_control_num(find(frame_num.adj_control_num(:,10)==0),23));
%corr_norm_ang, incorr_norm_ang
v16=nanmean(frame_num.adj_control_num(find(frame_num.adj_control_num(:,10)==1),23)./(1+frame_num.adj_control_num(find(frame_num.adj_control_num(:,10)==1),24)));
v17=nanmean(frame_num.adj_control_num(find(frame_num.adj_control_num(:,10)==0),23)./(1+frame_num.adj_control_num(find(frame_num.adj_control_num(:,10)==0),24)));

%epoch3(%perf,latency,norm_lat,,corr_lat,incorr_lat
v18=sum(frame_num.adj_control_num(:,13)==1)/(40-sum(isnan(frame_num.adj_control_num(:,13))));
v19=mean(frame_num.adj_control_num(find(~isnan(frame_num.adj_control_num(:,13))),16)-frame_num.adj_control_num(find(~isnan(frame_num.adj_control_num(:,13))),32));
v20=0;
v21=nanmean(frame_num.adj_control_num(find(frame_num.adj_control_num(:,13)==1),16)-frame_num.adj_control_num(find(frame_num.adj_control_num(:,13)==1),32));
v22=nanmean(frame_num.adj_control_num(find(frame_num.adj_control_num(:,13)==0),16)-frame_num.adj_control_num(find(frame_num.adj_control_num(:,13)==0),32));
%lat for 0,90,180
v23=nanmean(frame_num.adj_control_num(find(frame_num.adj_control_num(:,29)<3000),16)-frame_num.adj_control_num(find(frame_num.adj_control_num(:,29)<3000),32));
v24=nanmean(frame_num.adj_control_num(find(abs(frame_num.adj_control_num(:,29)-14000)<7000),16)-frame_num.adj_control_num(find(abs(frame_num.adj_control_num(:,29)-14000)<7000),32));
v25=nanmean(frame_num.adj_control_num(find(abs(frame_num.adj_control_num(:,29)-30000)<7000),16)-frame_num.adj_control_num(find(abs(frame_num.adj_control_num(:,29)-30000)<7000),32));
%corr_norm_lat,incorr_norm_lat 
v26=0;
v27=0;
%angle,norm_angle,corr_ang,inorr_ang
v28=nanmean(frame_num.adj_control_num(:,28));
v29=nanmean(frame_num.adj_control_num(:,28)./(1+frame_num.adj_control_num(:,29)));
v30=nanmean(frame_num.adj_control_num(find(frame_num.adj_control_num(:,13)==1),28));
v31=nanmean(frame_num.adj_control_num(find(frame_num.adj_control_num(:,13)==0),28));
%angle at 0,90,180 degrees
v32=nanmean(frame_num.adj_control_num(find(frame_num.adj_control_num(:,29)<3000),28));
v33=nanmean(frame_num.adj_control_num(find(abs(frame_num.adj_control_num(:,29)-14000)<7000),28));
v34=nanmean(frame_num.adj_control_num(find(abs(frame_num.adj_control_num(:,29)-30000)<7000),28));
%corr_nomg_ang,incorr_norm_ang
v35=nanmean(frame_num.adj_control_num(find(frame_num.adj_control_num(:,13)==1),28)./(1+frame_num.adj_control_num(find(frame_num.adj_control_num(:,13)==1),29)));
v36=nanmean(frame_num.adj_control_num(find(frame_num.adj_control_num(:,13)==0),28)./(1+frame_num.adj_control_num(find(frame_num.adj_control_num(:,13)==0),29)));



%save per subject behavioral data
individual_subject_behavior_control=[v1 v2 v3 v4 v5 v6 v7 v8 v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v22 v23 v24 v25 v26 v27 v28 v29 v30 v31 v32 v33 v34 v35 v36];

individual_subject_behavior=[individual_subject_behavior_ocpr individual_subject_behavior_control];

%%
overall_time=timestamp.OCPR_rt(size(timestamp.OCPR_rt,1),1)-timestamp.timeframe(1);
overall_time_min=overall_time/60

count_true_acc_control=count_acc_control - count_repeated_control;
acc_control=count_true_acc_control/(no_trials/2)

count_true_acc_OCPR=count_acc_OCPR - count_repeated_OCPR;
acc_OCPR=count_true_acc_OCPR/(no_trials/2)

objectstamp.wrong_OCPR
clear i j k m l 

filename=strcat(filename,'_ver3.mat');
if ~exist([ROOT.Save '\' filename0]), mkdir([ROOT.Save '\' filename0]); end
save([ROOT.Save '\' filename0 '\' filename])

%%
TimeStamp_MR=table;
for i=1:numel(timestamp.adj_timeframe)
TimeStamp_MR.time(i)=timestamp.adj_timeframe(i);
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
TrialInfo_EXP.timeout_phase2=frame_num.adj_ocpr_num(:,39);
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
TrialInfo_CTRL.timeout_phase2=frame_num.adj_control_num(:,39);
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
writetable(TrialInfo_EXP, [ROOT.Save '\' filename0 '\' 'TrialInfo_EXP.xlsx'],'writemode','replacefile')
writetable(TrialInfo_CTRL, [ROOT.Save '\' filename0 '\' 'TrialInfo_CTRL.xlsx'],'writemode','replacefile')
writetable(TimeStamp_MR, [ROOT.Save '\' filename0 '\' 'TimeStamp_MR.xlsx'],'writemode','replacefile')

disp([filename ' is finished!'])




