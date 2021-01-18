function state=DeletExp(obj,subjID,expID,delet_folder)
    % state:
    %   0: no error
    %   1: no this exp
    %   2: no folder
    %   3. no this subj
    state=0;
    % check subj
    SubjIndex=obj.searchSubj(subjID);
    if isempty(SubjIndex)
        state=3;
        return
    end
    % check exp
    ExpIndex=obj.SubjList(SubjIndex).searchExp(expID);
    if isempty(ExpIndex)
        state=1;
        return
    end
    % Remove folder
    if delet_folder
        DataPath=obj.SubjList(SubjIndex).ExpList(ExpIndex).DataPath;
        if ~exist(DataPath)
            state=2;
            return
        else
            rmdir(DataPath,'s');
        end
    end
    % Remove from list
    obj.SubjList(SubjIndex).removeExp(expID);
    % Save list
    obj.SaveObjList();
end