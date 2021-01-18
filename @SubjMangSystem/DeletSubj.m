function state=DeletSubj(obj,subjID,delet_folder)
    % state:
    %   0: no error
    %   1: no this subj
    %   2: no folder
    state=0;
    % check subj
    index=obj.searchSubj(subjID);
    if isempty(index)
        state=1;
        return
    end
    % Remove folder
    if delet_folder
        DataPath=obj.SubjList(index).DataPath;
        if ~exist(DataPath)
            state=2;
            return
        else
            rmdir(DataPath,'s');
        end
    end
    % Remove from list
    obj.removeSubj(subjID)
end