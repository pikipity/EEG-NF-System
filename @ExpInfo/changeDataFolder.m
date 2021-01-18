function changeDataFolder(obj,DataPath)
    obj.DataPath=DataPath;
    % Create data folder
    if ~exist(obj.DataPath)
        mkdir(obj.DataPath);
    end
    % Write exp information
    obj.SaveInfo();
end