classdef ExpInfo < handle
    
    properties
        ID
        Name
        Exper
        Date
        DataPath
    end
    
    methods
        function obj = ExpInfo(varargin)
            % Initial experiemtn info
            % ExpInfo(Name,exper,date)
            obj.ID=char(java.util.UUID.randomUUID);
            if isempty(varargin)
                obj.Name='';
                obj.Exper='';
                obj.Date='';
                obj.DataPath='';
            end
            if length(varargin)==1
                obj.Name=varargin{1};
                obj.Exper='';
                obj.Date='';
                obj.DataPath='';
            end
            if length(varargin)==2
                obj.Name=varargin{1};
                obj.Exper=varargin{2};
                obj.Date='';
                obj.DataPath='';
            end
            if length(varargin)==3
                obj.Name=varargin{1};
                obj.Exper=varargin{2};
                obj.Date=varargin{3};
                obj.DataPath='';
            end
            if length(varargin)==4
                obj.Name=varargin{1};
                obj.Exper=varargin{2};
                obj.Date=varargin{3};
                obj.DataPath=varargin{4};
            end
        end
        
        
    end
end

