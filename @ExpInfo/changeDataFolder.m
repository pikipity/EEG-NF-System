function changeDataFolder(obj,DataPath)
    obj.DataPath=DataPath;
    if ~exist(obj.DataPath)
        mkdir(obj.DataPath);
    end
end