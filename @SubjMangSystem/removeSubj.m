function removeSubj(obj,subjID)
    
    index=obj.searchSubj(subjID);
    newlistind=setdiff(1:length(obj.SubjList),index);
    obj.SubjList=obj.SubjList(newlistind);
    % save subj list
    obj.SaveObjList();
end