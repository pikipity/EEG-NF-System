function SaveInfo(obj)
    ExpInfoFile=fullfile(obj.DataPath,'ExpInfo.txt');
    InfoContent={'ID',obj.ID;
                 'Name',obj.Name;
                 'Exper',obj.Exper;
                 'Date',obj.Date};
    try
        writecell(InfoContent,ExpInfoFile,'Delimiter','space','QuoteStrings',false);
    catch
        fid=fopen(ExpInfoFile,'w');
       for i=1:size(InfoContent,1)
           fprintf(fid,'%s %s\r',InfoContent{i,1},InfoContent{i,2});
       end
       fclose(fid);
    end
end