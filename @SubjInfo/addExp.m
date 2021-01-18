function addExp(obj,newExp)
    
    if isempty(obj.ExpList)
        obj.ExpList=[newExp];
    else
        obj.ExpList=[newExp obj.ExpList];
    end
end