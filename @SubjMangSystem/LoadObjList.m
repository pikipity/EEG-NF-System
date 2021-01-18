function LoadObjList(obj)
    SubjListPath=obj.ObtainSubjListPath();
    SubjList=load(SubjListPath);
    obj.SubjList=SubjList.SubjList;
end