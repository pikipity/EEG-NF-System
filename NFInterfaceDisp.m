function NFInterfaceDisp(DataPath,SignalStreamID)
    disp(DataPath)
    disp(SignalStreamID);
    % Check DataPath
%     ParameterFile=fullfile(DataPath,'InterfaceParameters.txt');
%     if ~exist(ParameterFile,'file')
%         warndlg('Please design an interface first!!')
%         return
%     end
    % Create Signal Inlet
    lib=lsl_loadlib();
%     try
%         SignalInlet=lsl_inlet(SignalStream);
%     catch
%         warndlg('Signal Source disconnected!!')
%         SignalInlet=[];
%         return;
%     end
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
%     fid=fopen(ParameterFile,'r');
%     C=textscan(fid,'%[^\r]');
%     fclose(fid);
%     C=C{1};
%     InterfaceContents={};
%     for i=1:length(C)
%         tmp=split(C{i},',');
%         for j=1:length(tmp)
%             InterfaceContents{i,j}=tmp{j};
%         end
%     end
%     for i=2:size(InterfaceContents,1)
%         for j=1:size(InterfaceContents,2)
%             eval(['InterfacePara(' num2str(i-1) ').' InterfaceContents{1,j} '=''' InterfaceContents{i,j} ''';'])
%         end
%     end
    % FrashRate
    ifi = Screen('GetFlipInterval', window);
    flipSecs=1/30;
    waitframes=round(flipSecs/ifi);
    if waitframes<1
        waitframes=1;
    end
    % Obtain specific keys in keyborad
    escKeys=KbName('ESCAPE');
    spaceKeys=KbName('space');
    % Display
    StartStep=1;
    vbl=Screen('Flip',window);
    while 1
        % Update screen
        vbl=Screen('Flip',window,vbl+(waitframes-0.5)*ifi);
        % plot framenumber
        FrameCount=[FrameCount vbl];
        if length(FrameCount)<MaxFrameCount
        else
            FrameCount=FrameCount(end-MaxFrameCount+1:end);
            FrameTime=mean(diff(FrameCount));
            FrameNumber=round(1/FrameTime);
            Screen('TextSize',window,10);
            Screen('TextFont',window,'Helvetica');
            DrawFormattedText(window,num2str(FrameNumber),1,1+10,FontColor);
        end
        % plot marker outlet id
        Screen('TextSize',window,10);
        Screen('TextFont',window,'Helvetica');
        DrawFormattedText(window,markerID,1,MaxYLim-10,FontColor);
        % State Machine
        CurrentStepTime=vbl;
        switch CurrentStep
            case 0 % Start screen
                EnableSpace=1;
                % Check start
                if StartStep
                    MaxStepTime=CurrentStepTime+10;
                    StartStep=0;
                    MarkerOutlet.push_sample({'Start_Interface'})
                end
                % Check end
                % no end
                % Disp
                Screen('TextSize',window,30);
                Screen('TextFont',window,'Helvetica');
                DrawFormattedText(window,['Press space to continue'],'center','center',FontColor);
            case 1 % Start step
                EnableSpace=0;
                % Check start
                if StartStep
                    MaxStepTime=CurrentStepTime+10;
                    StartStep=0;
                    MarkerOutlet.push_sample({'Start_Step_Intro'});
                end
                % Check end
                if MaxStepTime-CurrentStepTime<=0
                    CurrentStep=2;
                    StartStep=1;
                    MarkerOutlet.push_sample({'Stop_Step_Intro'});
                end
                % Disp
                DispTime=floor(MaxStepTime-CurrentStepTime);
                if DispTime<0
                    DispTime=0;
                end
                Screen('TextSize',window,30);
                Screen('TextFont',window,'Helvetica');
                DrawFormattedText(window,['Starting, ' num2str(DispTime) ' s'],'center','center',FontColor);
            case 2
                EnableSpace=0;
                % Check start
                if StartStep
                    MaxStepTime=CurrentStepTime+10;
                    StartStep=0;
                    MarkerOutlet.push_sample({'Start_Step'});
                end
                % Check end
                if MaxStepTime-CurrentStepTime<=0
                    CurrentStep=3;
                    StartStep=1;
                    MarkerOutlet.push_sample({'Stop_Step'});
                end
                % Disp
                DispTime=floor(MaxStepTime-CurrentStepTime);
                if DispTime<0
                    DispTime=0;
                end
                Screen('TextSize',window,30);
                Screen('TextFont',window,'Helvetica');
                DrawFormattedText(window,['Continue, ' num2str(DispTime) ' s'],'center','center',FontColor);
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
            if any(keyCode(spaceKeys))
                CurrentStep=CurrentStep+1;
                StartStep=1;
            end
        end
        if any(keyCode(escKeys))
            break;
        end
    end
    % Close window
%     SignalInlet.close_stream();
%     delete(SignalInlet);
    delete(MarkerOutlet);
    sca;
end