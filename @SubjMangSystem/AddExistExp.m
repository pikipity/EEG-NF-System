function state=AddExistExp(obj,subjID,ExpDataPath)
    % state:
    %   0: no error
    %   1: subj not exist
    %   2: experiment data path not exist
    %   3: experiment information file not exist
    %   4: experiment ID in information file not exist
    %   5: experiment has exist
    %   6: copy folder error
    state=0;
    % Check subjID
    subjIndex=obj.searchSubj(subjID);
    if isempty(subjIndex)
        state=1;
        return
    end
    % Check ExpDataPath
    if ~exist(ExpDataPath,'dir')
        state=2;
        return
    end
    % Check ExpInfo
    ExpInfoFile=fullfile(ExpDataPath,'ExpInfo.txt');
    if ~exist(ExpInfoFile,'file')
        state=3;
        return
    end
    % Read ExpInfo
    fid=fopen(ExpInfoFile,'r');
    ExistExpInfo=textscan(fid,'%s%[^\r]');
    fclose(fid);
    ExistExpInfoKeywords=ExistExpInfo{1};
    ExistExpInfoContents=ExistExpInfo{2};
    % Obtain Exp ID
    ExpIDInd=find(contains(ExistExpInfoKeywords,'ID'));
    ExpID=ExistExpInfoContents{ExpIDInd};
    if isempty(ExpID)
        state=4;
        return
    end
    ExpTest=obj.ObtainExpInfo(subjID,ExpID);
    if ~isempty(ExpTest)
        state=5;
        return
    end
    % Create new exp
    newExp=ExpInfo();
    % Change exp info
    for i=1:length(ExistExpInfoKeywords)
        Keyword=ExistExpInfoKeywords{i};
        Content=ExistExpInfoContents{i};
        if isempty(Content)
            Content='';
        end
        eval(['newExp.' Keyword '=''' Content ''';'])
    end
    % change exp datapath
    newDataPath=fullfile(obj.SubjList(subjIndex).DataPath,newExp.ID);
    if ~strcmp(newDataPath,ExpDataPath)
        copystate=copyfile(ExpDataPath,newDataPath);
        if ~copystate
            state=6;
            return
        end
    end
    ExpDataPath=newDataPath;
    newExp.changeDataFolder(ExpDataPath);
    % Add new exp to list
    obj.SubjList(subjIndex).addExp(newExp);
    clear newExp;
    % save subj list
    obj.SaveObjList();
end