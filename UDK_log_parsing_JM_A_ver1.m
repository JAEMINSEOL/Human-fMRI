
fileToRead1=[ROOT.Raw '\' filename0 '\' strcat(filename0,'A.log')];
fileToRead2=[ROOT.Raw '\' filename0 '\' strcat('20' , filename0(3:end),'A.log')];

if exist(fileToRead1)
fileToRead = fileToRead1;
else
    fileToRead = fileToRead2;
end
DELIMITER = ' ';
no_trials=80;

% Import the file
rawData1 = importdata(fileToRead, DELIMITER, 50000);

% For some simple files (such as a CSV or JPEG files), IMPORTDATA might
% return a simple array.  If so, generate a structure so that the output
% matches that from the Import Wizard.
[~,name] = fileparts(fileToRead);
log_data=rawData1;

%% Get timestamps
timestamp=struct;
no_lines=max(size(log_data));
count_pause=0;count_timeframe=0; count_12=0; count_03=0; count_06=0; count_09=0;
time_old = 0; flag=1;
line_indice_run_start=[]; line_indice_run_end=[];
count_Rstart=0; count_Rend=0;c=1;
correct={};
for i=1:1:no_lines
    k=strfind(log_data{i},'correct InterpActor');
    if ~isempty(k)
        correct{c,1} = log_data{i};
        c=c+1;
    end
end

t=1; answ=[];
for i=1:1:no_lines
    k=strfind(log_data{i},'answer');
    if ~isempty(k)
        answ(t,1) = str2double(log_data{i}(end));
        answ(t,2) = str2double(log_data{i+1}(end));
        t=t+1;
    end
end

corr = sum(answ(:,1)==answ(:,2))/size(answ,1);