function index=searchSubj(obj,subjID)
    index=[];
    for i=1:length(obj.SubjList)
        if strcmp(obj.SubjList(i).ID,subjID)
            index=i;
            break
        end
    end
end