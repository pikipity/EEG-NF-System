function NFInterfaceDisp(DataPath,SignalStreamID)
    disp(DataPath)
    disp(SignalStreamID);
    % Prepare beep
    InitializePsychSound(1);
    nrchannels = 2;
    freq = 48000;
    repetitions = 1;
    beepLengthSecs = 0.3;
    beepPauseTime =0.3;
    startCue = 0;
    waitForDeviceStart = 1;
    pahandle = PsychPortAudio('Open', [], 1, 1, freq, nrchannels);
    PsychPortAudio('Volume', pahandle, 0.5);
    myBeep = MakeBeep(500, beepLengthSecs, freq);
    PsychPortAudio('FillBuffer', pahandle, [myBeep; myBeep]);
    % Check DataPath
    ParameterFile=fullfile(DataPath,'InterfaceParameters.txt');
    if ~exist(ParameterFile,'file')
        warndlg('Please design an interface first!!')
        return
    end
    % Create Signal Inlet
    lib=lsl_loadlib();
    result = lsl_resolve_byprop(lib,'source_id',SignalStreamID);
    if isempty(result)
        warndlg('Signal Source disconnected!!')
        return
    end
    SignalStream=result{1};
    chNumber=SignalStream.channel_count;
    SamplingFreq=SignalStream.nominal_srate;
    DefaultWinLen=100;
    SignalInlet=lsl_inlet(SignalStream);
    SignalInlet.close_stream();
    SignalContainer=zeros(chNumber,SamplingFreq*DefaultWinLen);
    TimeContainer=-DefaultWinLen:1/SamplingFreq:0;
    TimeContainer=TimeContainer(2:end);
    % Create Marker Outlet
    markerID=char(java.util.UUID.randomUUID);
    info = lsl_streaminfo(lib,'NFInterfaceMarker','Markers',1,0,'cf_string',markerID);
    MarkerOutlet=lsl_outlet(info);
    % Create Window
    sca;
    KbName('UnifyKeyNames');
    PsychDefaultSetup(2);
    Screen('Preference', 'SkipSyncTests', 1); 
    screenNumber = max(Screen('Screens'));
    white = WhiteIndex(screenNumber);
    black = BlackIndex(screenNumber);
    red=[1 0 0];
    green=[0 1 0];
    blue=[0 0 1];
    BackgroundColor=white;
    FontColor=black;
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, BackgroundColor);
    Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    % Window and System Parameters
    [MaxXLim, MaxYLim] = Screen('WindowSize', window);
    [xCenter, yCenter] = RectCenter(windowRect);
    CurrentStep=0;
    NFStep=0;
    FrameCount=[];
    MaxFrameCount=30;
    % NF Parameter
    fid=fopen(ParameterFile,'r');
    C=textscan(fid,'%[^\n]');
    fclose(fid);
    C=C{1};
    InterfaceContents={};
    for i=1:length(C)
        tmp=split(C{i},',');
        for j=1:length(tmp)
            InterfaceContents{i,j}=tmp{j};
        end
    end
    for i=2:size(InterfaceContents,1)
        for j=1:size(InterfaceContents,2)
            eval(['InterfacePara(' num2str(i-1) ').' InterfaceContents{1,j} '=''' InterfaceContents{i,j} ''';'])
        end
    end
    % FrashRate
    ifi = Screen('GetFlipInterval', window);
    flipSecs=1/30;
    waitframes=round(flipSecs/ifi);
    if waitframes<1
        waitframes=1;
    end
    % Obtain specific keys in keyborad
    escKeys=KbName('ESCAPE');
    downKeys=KbName('DownArrow');
    % Display
    IntroTime=3;
    PreviousNFTime=0;
    CalNFTime=0;
    NFWindow=1;
    FeedbackValue=0;
    StartStep=1;
    vbl=Screen('Flip',window);
    MaxStepTime=0;
    while 1
        % Update screen
        vbl=Screen('Flip',window,vbl+(waitframes-0.5)*ifi);
        CurrentStepTime=vbl;
        % plot framenumber
        FrameCount=[FrameCount vbl];
        if length(FrameCount)<MaxFrameCount
        else
            FrameCount=FrameCount(end-MaxFrameCount+1:end);
            FrameTime=mean(diff(FrameCount));
            FrameNumber=round(1/FrameTime);
            Screen('TextSize',window,10);
            Screen('TextFont',window,'Helvetica');
            DrawFormattedText(window,[num2str(FrameNumber) ', ' num2str(floor(MaxStepTime-CurrentStepTime))],1,1+10,FontColor);
        end
        % plot marker outlet id
        Screen('TextSize',window,10);
        Screen('TextFont',window,'Helvetica');
        DrawFormattedText(window,markerID,1,MaxYLim-10,FontColor);
        % State Machine
        switch CurrentStep
            case 0 % Start screen
                EnableSpace=1;
                % Check start
                if StartStep
                    MaxStepTime=inf;
                    StartStep=0;
                    MarkerOutlet.push_sample({'Start_Interface'})
                end
                % Check end
                % no end
                % Disp
                Screen('TextSize',window,30);
                Screen('TextFont',window,'Helvetica');
                DrawFormattedText(window,['Press DOWN to continue'],'center','center',FontColor);
            case 1 % Start step
                EnableSpace=0;
                % Check start
                if StartStep
                    % Start a new step
                    NFStep=NFStep+1;
                    if NFStep>length(InterfacePara)
                        break;
                    end
                    % Display requirement for 5 seconds
                    MaxStepTime=CurrentStepTime+IntroTime;
                    StartStep=0;
                    StepType=InterfacePara(NFStep).StepType;
                    MarkerOutlet.push_sample({regexprep(['Start_Intro_' StepType],' +','_')});
                end
                % Check end
                if MaxStepTime-CurrentStepTime<=0
                    CurrentStep=2;
                    StartStep=1;
                    StepType=InterfacePara(NFStep).StepType;
                    MarkerOutlet.push_sample({regexprep(['Stop_Intro_' StepType],' +','_')});
                end
                % Disp
                switch InterfacePara(NFStep).StepType
                    case 'Open Eyes'
                        DispString='Please open eyes until beep';
                    case 'Close Eyes'
                        DispString='Please close eyes until beep';
                    case 'NF'
                        DispString='Neurofeedback Training';
                    otherwise
                        DispString='None';
                end
                Screen('TextSize',window,30);
                Screen('TextFont',window,'Helvetica');
                DrawFormattedText(window,DispString,'center','center',FontColor);
            case 2 % Continue step
                EnableSpace=0;
                % Check start
                if StartStep
                    MaxStepTime=CurrentStepTime+str2num(InterfacePara(NFStep).Duration);
                    StartStep=0;
                    if strcmp(InterfacePara(NFStep).StepType,'NF')
                        CalNFTime=NFWindow;
                        PreviousNFTime=CurrentStepTime;
                        TargetFeedbackValue=0;
                        % open stream
                        try
                            SignalInlet.open_stream(2);
                        catch
                            warndlg('Signal source disconnect.');
                            break;
                        end
                    end
                    StepType=InterfacePara(NFStep).StepType;
                    MarkerOutlet.push_sample({regexprep(['Start_' StepType],' +','_')});
                end
                % Check end
                if MaxStepTime-CurrentStepTime<=0
                    CurrentStep=1;
                    StartStep=1;
                    StepType=InterfacePara(NFStep).StepType;
                    MarkerOutlet.push_sample({regexprep(['Stop_' StepType],' +','_')});
                    if strcmp(InterfacePara(NFStep).StepType,'Open Eyes') || strcmp(InterfacePara(NFStep).StepType,'Close Eyes')
                        PsychPortAudio('Start', pahandle, repetitions, startCue, waitForDeviceStart);
                        PsychPortAudio('Stop', pahandle, 1, 1);
                    end
                    if strcmp(InterfacePara(NFStep).StepType,'NF')
                        %close stream
                        SignalInlet.close_stream();
                    end
                end
                % Disp
                switch InterfacePara(NFStep).StepType
                    case 'Open Eyes'
                        DispString='+';
                        Screen('TextSize',window,80);
                        Screen('TextFont',window,'Helvetica');
                        DrawFormattedText(window,DispString,'center','center',green);
                    case 'Close Eyes'
                        DispString='+';
                        Screen('TextSize',window,80);
                        Screen('TextFont',window,'Helvetica');
                        DrawFormattedText(window,DispString,'center','center',red);
                    case 'NF'
                        % Read Data
                        [chunk,stamps]=SignalInlet.pull_chunk();
                        if ~isempty(chunk)
                            keepContain=SignalContainer(:,size(chunk,2)+1:end);
                            SignalContainer=[keepContain chunk];
                            if size(stamps,2)>1
                                real_sampling_period=mean(diff(stamps));
                            else
                                real_sampling_period=1/SamplingFreq;
                            end
                            if TimeContainer(end)<(stamps(1)-DefaultWinLen*real_sampling_period)
                                TimeContainer=-(length(TimeContainer)*real_sampling_period):real_sampling_period:0;
                                TimeContainer=TimeContainer(1:end-1)+stamps(1);
                            end
                            keepContain=TimeContainer(:,size(chunk,2)+1:end);
                            TimeContainer=[keepContain stamps];
                        end
                        if CurrentStepTime-PreviousNFTime>=CalNFTime
                            FeedbackValue=TargetFeedbackValue;
                            PreviousNFTime=CurrentStepTime;
                            CalNFTime=NFWindow;
                            % cal target feedback value
                            CalChannel=str2num(InterfacePara(NFStep).Channel);
                            if CalChannel>size(SignalContainer,1)
                                warndlg('Select channel cannot be used');
                                break;
                            end
                            CalData=detrend(SignalContainer.').';
                            [~,TimeInd]=min(abs(TimeContainer-(TimeContainer(end)-CalNFTime)));
                            CalData=CalData(CalChannel,TimeInd:end);
                            CalTime=TimeContainer(TimeInd:end);
                            cal_sampling_period=mean(diff(CalTime));
                            %
                            L=length(CalData);
                            NFFT=2^nextpow2(L);
                            FFT_res=fft(CalData,NFFT)/length(CalData);
                            FFT_res=FFT_res(1:NFFT/2+1);
                            Fs=1/cal_sampling_period;
                            FFT_freq=Fs/2*linspace(0,1,NFFT/2+1);
                            FFT_res=abs(FFT_res);
                            %
                            [~,ind_freq_4]=min(abs(FFT_freq-4));
                            [~,ind_freq_30]=min(abs(FFT_freq-30));
                            FeedbackFreq=InterfacePara(NFStep).FeedbackFreq;
                            FeedbackFreq=split(FeedbackFreq,'~');
                            [~,ind_freq_min]=min(abs(FFT_freq-str2num(FeedbackFreq{1})));
                            [~,ind_freq_max]=min(abs(FFT_freq-str2num(FeedbackFreq{2})));
                            UpperValue=sum(FFT_res(ind_freq_min:ind_freq_max))/(str2num(FeedbackFreq{2})-str2num(FeedbackFreq{1}));
                            LowerValue=sum(FFT_res(ind_freq_4:ind_freq_30))/(30-4);
                            TargetFeedbackValue=UpperValue/LowerValue;
                            %
                            MarkerOutlet.push_sample({regexprep(['CalValue:' num2str(TargetFeedbackValue)],' +','_')});
                        end
                        FeedbackValue=FeedbackValue+(TargetFeedbackValue-FeedbackValue)/(PreviousNFTime+CalNFTime-CurrentStepTime)*((waitframes-0.5)*ifi);
                        if FeedbackValue>1
                            FeedbackValue=1;
                        end
                        if FeedbackValue<0
                            FeedbackValue=0;
                        end
                        % Dsip
                        if strcmp(InterfacePara(NFStep).FeedbackDirection,'Positive')
                            FeedbackThreshold=str2num(InterfacePara(NFStep).FeedbackThreshold);
                        else
                            FeedbackThreshold=1-str2num(InterfacePara(NFStep).FeedbackThreshold);
                        end
                        RectWidth=floor(100);
                        RectHigh=floor(MaxYLim*0.8);
                        wholeRect=floor([xCenter-RectWidth/2,...
                                         (MaxYLim-RectHigh)/2,...
                                         xCenter+RectWidth/2,...
                                         (MaxYLim-RectHigh)/2+RectHigh]);
                        dispRect=floor([xCenter-RectWidth/2,...
                                        (MaxYLim-RectHigh)/2+RectHigh*(1-FeedbackValue),...
                                        xCenter+RectWidth/2,...
                                        (MaxYLim-RectHigh)/2+RectHigh]);
                        NFLine=floor([xCenter-RectWidth/2,...
                                        (MaxYLim-RectHigh)/2+RectHigh*(1-FeedbackThreshold),...
                                        xCenter+RectWidth/2,...
                                        (MaxYLim-RectHigh)/2+RectHigh]);
                        if FeedbackValue>FeedbackThreshold
                            Screen('FillRect',window,green,dispRect);
                        else
                            Screen('FillRect',window,red,dispRect);
                        end
                        Screen('FrameRect',window,black,wholeRect,3);
                        Screen('FrameRect',window,black,NFLine,3);
                    otherwise
                        DispString='None';
                        Screen('TextSize',window,30);
                        Screen('TextFont',window,'Helvetica');
                        DrawFormattedText(window,DispString,'center','center',FontColor);
                end
            case 3 % Resting screen
                EnableSpace=0;
                % Check start
                if StartStep
                    MaxStepTime=CurrentStepTime+10;
                    StartStep=0;
                    MarkerOutlet.push_sample({'Start_Rest'});
                end
                % Check end
                if MaxStepTime-CurrentStepTime<=0
                    CurrentStep=1;
                    StartStep=1;
                    MarkerOutlet.push_sample({'Stop_Rest'});
                end
                % Disp
                DispTime=floor(MaxStepTime-CurrentStepTime);
                if DispTime<0
                    DispTime=0;
                end
                Screen('TextSize',window,30);
                Screen('TextFont',window,'Helvetica');
                DrawFormattedText(window,['Resting, ' num2str(DispTime) ' s'],'center','center',FontColor);
            otherwise
                break;
        end
        % check key
        [~,~,keyCode]=KbCheck;
        if EnableSpace
            if any(keyCode(downKeys))
                CurrentStep=CurrentStep+1;
                StartStep=1;
            end
        end
        if any(keyCode(escKeys))
            break;
        end
    end
    % Close window
    SignalInlet.close_stream();
    delete(SignalInlet);
    MarkerOutlet.push_sample({'System_Close'})
    delete(MarkerOutlet);
    PsychPortAudio('Close', pahandle);
    sca;
end