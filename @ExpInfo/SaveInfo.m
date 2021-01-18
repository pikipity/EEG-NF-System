function SaveInfo(obj)
    ExpInfoFile=fullfile(obj.DataPath,'ExpInfo.txt');
    InfoContent={'ID',obj.ID;
                 'Name',obj.Name;
                 'Exper',obj.Exper;
                 'Date',obj.Date};
    writecell(InfoContent,ExpInfoFile,'Delimiter','space','QuoteStrings',false);
end