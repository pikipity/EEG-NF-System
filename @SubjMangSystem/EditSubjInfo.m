function EditSubjInfo(obj,subjID,varargin)
    % Name,Birthday,Hand,Gender
    % Search subj
    targetindex=obj.searchSubj(subjID);
    % Change Information
    if isempty(varargin)
        return;
    elseif length(varargin)==1
        obj.SubjList(targetindex).Name=varargin{1};
    elseif length(varargin)==2
        obj.SubjList(targetindex).Name=varargin{1};
        obj.SubjList(targetindex).Birthday=varargin{2};
    elseif length(varargin)==3
        obj.SubjList(targetindex).Name=varargin{1};
        obj.SubjList(targetindex).Birthday=varargin{2};
        obj.SubjList(targetindex).Hand=varargin{3};
    elseif length(varargin)>=4
        obj.SubjList(targetindex).Name=varargin{1};
        obj.SubjList(targetindex).Birthday=varargin{2};
        obj.SubjList(targetindex).Hand=varargin{3};
        obj.SubjList(targetindex).Gender=varargin{4};
    end
    % save database
    obj.SaveObjList();
    % save subjInfo
    obj.SubjList(targetindex).SaveInfo();
end