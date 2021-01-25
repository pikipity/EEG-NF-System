function state=AddExistSubj(obj,SubjDataPath)
    % state:
    %   0: no error
    %   1: subj data folder not exist
    %   2: subj informaton file not exist
    %   3: subj ID in information file not exist
    %   4: subj has exist
    %   5: copy error
    %   6: subj name in information file not exist
    state=0;
    % Check SubjDataPath
    if ~exist(SubjDataPath,'dir')
        state=1;
        return
    end
    % Check SubjInfo
    SubjInfoFile=fullfile(SubjDataPath,'SubjInfo.txt');
    if ~exist(SubjInfoFile,'file')
        state=2;
        return
    end
    % Read ExpInfo
    fid=fopen(SubjInfoFile,'r');
    ExistExpInfo=textscan(fid,'%s%[^\r]');
    fclose(fid);
    ExistSubjInfoKeywords=ExistExpInfo{1};
    ExistSubjInfoContents=ExistExpInfo{2};
    % Obtain Subj ID
    SubjIDInd=find(contains(ExistSubjInfoKeywords,'ID'));
    SubjID=ExistSubjInfoContents{SubjIDInd};
    if isempty(SubjID)
        state=3;
        return
    end
    SubjTest=obj.ObtainSubjInfo(SubjID);
    if ~isempty(SubjTest)
        state=4;
        return
    end
    % Obtain Subj Name
    SubjNameInd=find(contains(ExistSubjInfoKeywords,'Name'));
    SubjName=ExistSubjInfoContents{SubjNameInd};
    if isempty(SubjName)
        state=6;
        return
    end
    % Create new subj
    newSubj=SubjInfo(SubjName);
    % Change subj info
    for i=1:length(ExistSubjInfoKeywords)
        Keyword=ExistSubjInfoKeywords{i};
        Content=ExistSubjInfoContents{i};
        if isempty(Content)
            Content='';
        end
        eval(['newSubj.' Keyword '=''' Content ''';'])
    end
    % change subj datapath
    newDataPath=fullfile(obj.SystemConfig.DataPath,newSubj.ID);
    if ~strcmp(newDataPath,SubjDataPath)
        copystate=copyfile(SubjDataPath,newDataPath);
        if ~copystate
            state=5;
            return
        end
    end
    SubjDataPath=newDataPath;
    newSubj.changeDataFolder(SubjDataPath);
    % Add new exp to list
    obj.addSubj(newSubj);
    clear newSubj;
end