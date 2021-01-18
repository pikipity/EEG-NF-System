function EditExpInfo(obj,subjID,expID,varargin)
    % Name,Exper,Date
    % Search exp
    SubjTargetInd=obj.searchSubj(subjID);
    ExpTargetInd=obj.SubjList(SubjTargetInd).searchExp(expID);
    % Change Information
    if isempty(varargin)
        return;
    elseif length(varargin)==1
        obj.SubjList(SubjTargetInd).ExpList(ExpTargetInd).Name=varargin{1};
    elseif length(varargin)==2
        obj.SubjList(SubjTargetInd).ExpList(ExpTargetInd).Name=varargin{1};
        obj.SubjList(SubjTargetInd).ExpList(ExpTargetInd).Exper=varargin{2};
    elseif length(varargin)>=3
        obj.SubjList(SubjTargetInd).ExpList(ExpTargetInd).Name=varargin{1};
        obj.SubjList(SubjTargetInd).ExpList(ExpTargetInd).Exper=varargin{2};
        obj.SubjList(SubjTargetInd).ExpList(ExpTargetInd).Date=varargin{3};
    end
    % save database
    obj.SaveObjList();
    % save expInfo
    obj.SubjList(SubjTargetInd).ExpList(ExpTargetInd).SaveInfo();
end