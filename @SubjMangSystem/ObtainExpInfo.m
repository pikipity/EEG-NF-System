function info=ObtainExpInfo(obj,subjID,expID)
    % Return experiment information object
    % ID, Name, Exper, Date, DataPath
    subjInfo=obj.ObtainSubjInfo(subjID);
    if isempty(subjInfo)
        info=[];
        return
    end
    if ischar(expID)
        expInd=subjInfo.searchExp(expID);
    elseif isnumeric(expID)
        expInd=expID;
    else
        info=[];
        return
    end
    info=subjInfo.ExpList(expInd);
end