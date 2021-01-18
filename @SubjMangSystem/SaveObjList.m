function SaveObjList(obj)
    SubjListPath=obj.ObtainSubjListPath();
    SubjList=obj.SubjList;
    save(SubjListPath,'SubjList')
end