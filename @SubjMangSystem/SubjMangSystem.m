classdef SubjMangSystem < handle
    % Subject Managment System
    % Store subject object and data path
    
    properties
        ID
        SystemConfig
        SubjList
    end
    
    methods
        function obj = SubjMangSystem(ConfigFile)
            % Initial managment system
            % Require Config File
            
            obj.ID=char(java.util.UUID.randomUUID);
            % Read Config
            fid=fopen(ConfigFile,'r');
            ConfigFileTxt=textscan(fid,'%s%[^\r]');
            fclose(fid);
            ConfigFileKeywords=ConfigFileTxt{1};
            ConfigFileContects=ConfigFileTxt{2};
            % DataPath
            Index=find(contains(ConfigFileKeywords,'DataPath'));
            obj.SystemConfig.DataPath=ConfigFileContects{Index};
            if ~exist(obj.SystemConfig.DataPath)
                mkdir(obj.SystemConfig.DataPath)
            end
            % SubjList
            SubjListPath=obj.ObtainSubjListPath();
            if ~exist(SubjListPath)
                obj.SubjList=[];
                obj.SaveObjList();
            else
                obj.LoadObjList();
            end
        end
        
        
    end
end

