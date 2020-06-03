%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Dissociating contextual vs. semantic effects in associative priming% Version 1. There are 3 main conditions of interest:% Context only, Category only, Both% 80 object sets% 20 trials in the 3 conditions and 20 trials with unrelated pairs, no% repeat of prime% 40 trials of non-objects (primes for these trials are not in the 80 sets)% Randomize all trials % Written by Olivia Cheung, 2011 Feb 14% This version was last modified on 2011 Oct 19%% Task: object/non-object judgement% object size: 274 x 274%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%clear all;close all;% myWinSize = [1024 768];% screens = Screen('Screens');% [checkx checky] = Screen('WindowSize',max(screens));% if checkx ~= myWinSize(1) || checky ~= myWinSize(2);%     error(['screen resolution must be ' num2str(myWinSize(1)) 'x' num2str(myWinSize(2))]);% endcommandwindow;KeyboardType = -1;Screen('Preference', 'SkipSyncTests', 1); %need this line for laptoppractice = 1; %If there are practice trials, practice=1. To skip the practice trials, practice=2%%Prompt Box for Subject Informationrepeat=1;while (repeat);    prompt= {'Subject number','Subject Initials'};    defaultAnswer={'1', 'aaa'};    answer=inputdlg(prompt,'Subject information',1, defaultAnswer);    [subjno,subjini]=deal(answer{:});    if isempty(str2num(subjno)) || ~isreal(str2num(subjno))        h=errordlg('Subject Number must be an integers','Input Error'); repeat=1; uiwait(h);    else        cd('CvSPriming_Data')        fileName=['CvSPrim100_100','_',subjini,'_',subjno,'.txt'];	% set data file directory and name        if exist(fileName)~=0            button=questdlg('Overwrite data?');            if strcmp(button,'Yes'); repeat=0; end        else            repeat=0;        end    endendsubjno = str2num(subjno);rand('state',subjno*1.2345);randstate=rand('state');dataFile=fopen(fileName, 'a');cd('..')%Change Back to experiment directoryfprintf(dataFile,('\nsubjno\tsubjini\tpractice\ttrial\tRelation\tobject\tcorr_resp\tsubj_resp\tGradedRes\trt'));bkgdcolor = [255 255 255];  %background colorblack = [0 0 0]; %(text color)%Key Press and Message definedobject_resp = KbName('1!');nonobject_resp = KbName('0)');%messageobject = 'That was a real object.';%messagenotobject = 'That was an abstract sculpture.';screens = Screen('Screens');screenNumber = max(screens);[w,screenRect] = Screen('OpenWindow',screenNumber, bkgdcolor);HideCursor;Screen('TextSize',w,20);%set time infofixation_time = .5;%stimulus positionScreenWidth=RectWidth(screenRect);ScreenHeight=RectHeight(screenRect);image_width=274;image_height=274;StimPos=[ScreenWidth/2-image_width/2 ScreenHeight/2-image_height/2 ScreenWidth/2+image_width/2 ScreenHeight/2+image_height/2];cd CvSPriming_images;%Start Trials for Test Phasemessage = 'The study is about to begin.\n\nOn each trial, you will see two objects in a row.\nThe first image will appear very briefly.\nYou should try to look at it because it may help you to identify the second image.\n\nFor the second object, \nyour task is to judge whether it shows a common object (e.g., an apple)\nor an abstract scuplture.\n\nPress the spacebar to continue.';DrawFormattedText(w,message,'center','center',black);Screen('Flip',w);WaitSecs(1);KbWait(KeyboardType);message ='Press "1" if the second image shows a real object.\nPress "0" if it shows an abstract sculpture.\n\n*When you see the second image,\nrespond as fast and as accurately as you can.*\n\nPress the spacebar to continue.';DrawFormattedText(w,message,'center','center',black);Screen('Flip',w);WaitSecs(1);KbWait(KeyboardType);mask=imread('mask.jpg','jpg');mask_texture = Screen('MakeTexture', w, mask);%Checkif practice==1;    Blockstart=1;        message ='There will be a block of practice trials.\nWhen you are ready, press the spacebar to continue.';    DrawFormattedText(w,message,'center','center',black);    Screen('Flip',w);    WaitSecs(1);    KbWait(KeyboardType);    elseif practice==2;    Blockstart=2;endshuffle_objects=Shuffle(1:80);objlist1=shuffle_objects(1:20);objlist2=shuffle_objects(21:40);objlist3=shuffle_objects(41:60);objlist4=shuffle_objects(61:80);for condition = Blockstart:2; %practice=1, real=2        %this should be the matrix for the whole practice or real block    if practice == 1;        clear design;        design(:,1) = [repmat((1:2),1,4) (1:4)]'; %5 conditions: 2 trials in C, S, B, U, and 4 trials for Nonobjects        nTRIAL = length(design); %number of trials equals that of the design        design(:,2) = [repmat(1,1,2) repmat(2,1,2) repmat(3,1,2) repmat(4,1,2) repmat(5,1,4)]';        design(:,3) = [repmat(1,1,8) repmat(2,1,4)]';%2 responses: 1=object, 2=nonobject    elseif practice == 2;        clear design;        design(:,1) = [objlist1 objlist2 objlist3 objlist4 (1:40)]'; %Prime object: 1-60 for 6 times, 4 times before real objects, twice before abstract sculptures        nTRIAL = length(design); %number of trials equals that of the design        design(:,2) = [repmat(1,1,20) repmat(2,1,20) repmat(3,1,20) repmat(4,1,20) repmat(5,1,40)]';        design(:,3) = [repmat(1,1,80) repmat(2,1,40)]';%real object or abstract sculpture (obj1-30 small, obj31-60 large)    end        %Prepare trials    order=Shuffle(1:nTRIAL); %randomize the order of the trials        for tt=1:nTRIAL;                trial=order(tt); %define trial no. for stimuli to use        objectnumber=design(trial,1); %select object pairs (object#)        relation=design(trial,2); %1=context, 2=semantic, 3=both, 4=unrelated, 5=nonobjects        CorrResp = design(trial,3);  %1=object, 2=non-object                if relation==1;            pair_condition='context';        elseif relation==2;            pair_condition='semantic';        elseif relation==3;            pair_condition='both';        elseif relation==4;            pair_condition='unrelated';        elseif relation==5;            pair_condition='nonobject';        end                if relation<5;        	prime_condition='real';        elseif relation==5;        	prime_condition='non';        end                if practice==1;            prac_condition='prac';        elseif practice==2;            prac_condition='obj';        end                if practice==1;            S1=imread(['Prime_',pair_condition,'_',prac_condition,'_',num2str(objectnumber),'.jpg'],'jpg');        elseif practice==2;            S1=imread(['Prime_',prime_condition,'_',prac_condition,'_',num2str(objectnumber),'.jpg'],'jpg');        end        S2=imread(['Target_',pair_condition,'_',prac_condition,'_',num2str(objectnumber),'.jpg'],'jpg');                S1_texture = Screen('MakeTexture', w, S1);        S2_texture = Screen('MakeTexture', w, S2);                clear KeyCode(object_resp); clear KeyCode(nonobject_resp);        clear rt;                fixtime=0; S1time=0; masktime=0; clear S2time;        DrawFormattedText(w,'+','center','center',black);        Screen('Flip',w);        trialstarttime=GetSecs;        while fixtime<fixation_time;            fixtime=GetSecs-trialstarttime;        end                Screen('DrawTexture',w,S1_texture,[],StimPos);        Screen('Flip',w);        stimtime=GetSecs;        while S1time<.1;            S1time=GetSecs-stimtime;        end        Screen('DrawTexture',w,mask_texture,[],StimPos);        Screen('Flip',w);        while masktime<.2; %time with S1+mask (mask=150ms)            masktime=GetSecs-stimtime;        end        Screen('DrawTexture',w,S2_texture,[],StimPos);        Screen('Flip',w);        S2time=GetSecs-stimtime;        RTstart=GetSecs;                while (GetSecs - RTstart)<=5;            [KeyIsDown, endrt, KeyCode]=KbCheck(KeyboardType);            if (KeyCode(object_resp)==1 || KeyCode(nonobject_resp)==1);                break;            end            if (GetSecs - RTstart)>=.1 && (GetSecs - RTstart)<=.35;                Screen('DrawTexture',w,mask_texture,[],StimPos);                Screen('Flip',w);            end            if (GetSecs - RTstart)>.35;                Screen('Flip',w);            end        end        while KbCheck(KeyboardType); end        rt = endrt-RTstart; rt = (rt)*1000;                if (KeyCode(object_resp)==1 && CorrResp==2);            GradedRes=0;            subj_resp='object';        elseif (KeyCode(nonobject_resp)==1 && CorrResp==1);            GradedRes=0;            subj_resp='nonobject';        elseif KeyIsDown==0;            GradedRes=99;            subj_resp='nil';        elseif (KeyCode(object_resp)==1 && CorrResp==1);            GradedRes=1;            subj_resp='object';        elseif (KeyCode(nonobject_resp)==1 && CorrResp==2);            GradedRes=1;            subj_resp='nonobject';        else            GradedRes=100;            subj_resp='wrongkey';        end                if CorrResp==1;            corr_resp='object';        elseif CorrResp==2;            corr_resp='nonobject';        end        fprintf(dataFile, ('\n%d\t%s\t%d\t%d\t%s\t%d\t%s\t%s\t%d\t%3.3f'),subjno,subjini,practice,tt,pair_condition,objectnumber,corr_resp,subj_resp,GradedRes,rt);                Screen('Close', S1_texture);        Screen('Close', S2_texture);                Screen('Flip',w);        WaitSecs(1);                if tt==60; %a break after 60 trials            message = 'You have finished a block.\nPress the spacebar to continue to the next block';            DrawFormattedText(w,message,'center','center',black);            Screen('Flip',w);            WaitSecs(1);            KbWait(KeyboardType);        end    end        if practice==1;        practice=2;        message = 'You have finished the practice trials.\nIf you have any questions, please ask the experimenter now.\nWhen you are ready, press the spacebar to continue.';        DrawFormattedText(w,message,'center','center',black);        Screen('Flip',w);        WaitSecs(1);        KbWait(KeyboardType);    endendmessage = 'You have just finished the experiment!\nPlease get the experimenter.';DrawFormattedText(w,message,'center','center',black);Screen('Flip',w);WaitSecs(1);KbWait(KeyboardType);Screen('CloseAll');ShowCursor;fclose('all');