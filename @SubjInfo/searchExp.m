function index=searchExp(obj,ExpID)
    index=[];
    for i=1:length(obj.ExpList)
        if strcmp(obj.ExpList(i).ID,ExpID)
            index=i;
            break
        end
    end
end