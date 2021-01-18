function [state,newID]=CreateNewSubj(obj,Name,varargin)
    % state:
    %   0: no error
    %   1: has redundent
    %   2: subj datapath has existed
    % Name,Birthday,Hand,Gender
    state=0;
    % Create new subj
    if length(varargin)==0
        newSubj=SubjInfo(Name);
    elseif length(varargin)==1
        newSubj=SubjInfo(Name,varargin{1});
    elseif length(varargin)==2
        newSubj=SubjInfo(Name,varargin{1},varargin{2});
    elseif length(varargin)>=3
        newSubj=SubjInfo(Name,varargin{1},varargin{2},varargin{3});
    end
    % check redunent
    index=obj.searchSubj(newSubj.ID);
    if ~isempty(index)
        state=1;
        newID=[];
        return;
    end
    % check subj data path
    DataPath=fullfile(obj.SystemConfig.DataPath,newSubj.ID);
    if exist(DataPath)
        state=2;
        newID=[];
        return
    end
    % Create subj data folder
    newSubj.changeDataFolder(DataPath);
    % Add new subj to list
    obj.addSubj(newSubj);
    newID=newSubj.ID;
    clear newSubj;
end