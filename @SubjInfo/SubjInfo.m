classdef SubjInfo < handle
    % Store subject information
    
    properties
        ID
        Name
        Birthday
        Hand
        Gender
        DataPath
        ExpList
    end
    
    methods
        function obj = SubjInfo(Name,varargin)
            % Initial subject
            % SubjInfo(Name,Birthday,Hand,Gender)
            % Name must be given
            obj.ID=char(java.util.UUID.randomUUID);
            obj.Name=Name;
            obj.DataPath='';
            obj.ExpList=[];
            if isempty(varargin)
                obj.Birthday='';
                obj.Hand='';
                obj.Gender='';
            end
            if length(varargin)==1
                obj.Birthday=varargin{1};
                obj.Hand='';
                obj.Gender='';
            end
            if length(varargin)==2
                obj.Birthday=varargin{1};
                obj.Hand=varargin{2};
                obj.Gender='';
            end
            if length(varargin)==3
                obj.Birthday=varargin{1};
                obj.Hand=varargin{2};
                obj.Gender=varargin{3};
            end
        end
        
    end
end

