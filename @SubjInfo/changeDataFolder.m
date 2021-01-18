function changeDataFolder(obj,DataPath)
    obj.DataPath=DataPath;
    % Create new data path
    if ~exist(obj.DataPath)
        mkdir(obj.DataPath);
    end
    % Write subj information
    obj.SaveInfo();
end