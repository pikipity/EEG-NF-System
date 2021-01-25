function SaveInfo(obj)
    subjInfoFile=fullfile(obj.DataPath,'SubjInfo.txt');
    InfoContent={'ID',obj.ID;
                 'Name',obj.Name;
                 'Birthday',obj.Birthday;
                 'Hand',obj.Hand;
                 'Gender',obj.Gender};
   try
        writecell(InfoContent,subjInfoFile,'Delimiter','space','QuoteStrings',false);
   catch
       fid=fopen(subjInfoFile,'w');
       for i=1:size(InfoContent,1)
           fprintf(fid,'%s %s\r',InfoContent{i,1},InfoContent{i,2});
       end
       fclose(fid);
   end
end