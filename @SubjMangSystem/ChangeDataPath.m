function ChangeDataPath(obj,new_DataPath)
    % Move DataPath
    obj.SystemConfig.DataPath=new_DataPath;
    if ~exist(obj.SystemConfig.DataPath)
        mkdir(obj.SystemConfig.DataPath)
    end
    % Load SubjList
    SubjListPath=obj.ObtainSubjListPath();
    if ~exist(SubjListPath)
        obj.SubjList=[];
        obj.SaveObjList();
    else
        obj.LoadObjList();
    end
end