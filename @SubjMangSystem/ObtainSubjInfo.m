function info=ObtainSubjInfo(obj,subjID)
    % Return subject object
    % ID, Name, Birthday, Hand, Gender, DataPath, ExpList
    if ischar(subjID)
        subInd=obj.searchSubj(subjID);
    elseif isnumeric(subjID)
        subInd=subjID;
    else
        info=[];
        return
    end
    info=obj.SubjList(subInd);
end