clear all
clear classes

if exist('D:\Github\EEG-NF-System\Data_test','dir')
    rmdir('D:\Github\EEG-NF-System\Data_test','s');
end

ConfigFile='SubjMangSystemConfig_for_test.txt';
SubjSystem=SubjMangSystem(ConfigFile);

SubjDataPath=fullfile('D:\Github\EEG-NF-System','Test_Subj_Folder');
state=SubjSystem.AddExistSubj(SubjDataPath);
state=SubjSystem.AddExistSubj(SubjDataPath);

[CreateSubjState1,newSubjID1]=SubjSystem.CreateNewSubj('TestSubj1');
ExpDataPath=fullfile('D:\Github\EEG-NF-System','Data','e17420f4-c892-4a23-bb27-2e23cd711d75','4a6d657f-2c55-429c-b6e8-9b17c31fc608');
state=SubjSystem.AddExistExp(newSubjID1,ExpDataPath)
state=SubjSystem.AddExistExp(newSubjID1,ExpDataPath)
ExpDataPath=fullfile('D:\Github\EEG-NF-System','Test_Exp_Folder');
state=SubjSystem.AddExistExp(newSubjID1,ExpDataPath)
state=SubjSystem.AddExistExp(newSubjID1,ExpDataPath)
state=SubjSystem.AddExistExp('ddd',ExpDataPath)


% [CreateSubjState1,newSubjID1]=SubjSystem.CreateNewSubj('TestSubj1');
% [CreateExpState1_1,newExpID1_1]=SubjSystem.CreateNewExp(newSubjID1);
% [CreateExpState1_2,newExpID1_2]=SubjSystem.CreateNewExp(newSubjID1);
% pause(1)
% 
% [CreateSubjState2,newSubjID2]=SubjSystem.CreateNewSubj('TestSubj2');
% [CreateExpState2_1,newExpID2_1]=SubjSystem.CreateNewExp(newSubjID2);
% [CreateExpState2_2,newExpID2_2]=SubjSystem.CreateNewExp(newSubjID2);
% pause(1)
% 
% 
% SubjSystem.DeletSubj(newSubjID1,1)
% SubjSystem.DeletExp(newSubjID2,newExpID2_1,1)



