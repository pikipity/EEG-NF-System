function SaveInfo(obj)
    subjInfoFile=fullfile(obj.DataPath,'SubjInfo.txt');
    InfoContent={'ID',obj.ID;
                 'Name',obj.Name;
                 'Birthday',obj.Birthday;
                 'Hand',obj.Hand;
                 'Gender',obj.Gender};
   writecell(InfoContent,subjInfoFile,'Delimiter','space','QuoteStrings',false);
end