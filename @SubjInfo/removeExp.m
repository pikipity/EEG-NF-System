function removeExp(obj,ExpID)
    
    index=obj.searchExp(ExpID);
    newlistind=setdiff(1:length(obj.ExpList),index);
    obj.ExpList=obj.ExpList(newlistind);
end