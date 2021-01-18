function addSubj(obj,newSubj)
    
    if isempty(obj.SubjList)
        obj.SubjList=[newSubj];
    else
        obj.SubjList=[newSubj obj.SubjList];
    end
    % save subj list
    obj.SaveObjList();
end