function [state,newID]=CreateNewExp(obj,subjID,varargin)
    % state:
    %   0: no error
    %   1: exp has redundent
    %   2: exp datapath has existed
    %   3: subj not exist
    state=0;
    % Check subjID
    subjIndex=obj.searchSubj(subjID);
    if isempty(subjIndex)
        state=3;
        newID=[];
        return
    end
    % Create new exp
    if isempty(varargin)
        newExp=ExpInfo();
    elseif length(varargin)==1
        newExp=ExpInfo(varargin{1});
    elseif length(varargin)==2
        newExp=ExpInfo(varargin{1},varargin{2});
    elseif length(varargin)>=3
        newExp=ExpInfo(varargin{1},varargin{2},varargin{3});
    end
    % Check exp redunent
    expIndex=obj.SubjList(subjIndex).searchExp(newExp.ID);
    if ~isempty(expIndex)
        state=1;
        newID=[];
        return
    end
    % Check exp data path
    DataPath=fullfile(obj.SubjList(subjIndex).DataPath,newExp.ID);
    if exist(DataPath)
        state=2;
        newID=[];
        return
    end
    % Create exp data folder
    newExp.changeDataFolder(DataPath);
    % Add new exp to list
    obj.SubjList(subjIndex).addExp(newExp);
    newID=newExp.ID;
    clear newExp;
    % save subj list
    obj.SaveObjList();
end