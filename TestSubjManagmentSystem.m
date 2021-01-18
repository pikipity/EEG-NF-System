clear all
clear classes

ConfigFile='SubjMangSystemConfig.txt';
SubjSystem=SubjMangSystem(ConfigFile);

[CreateSubjState1,newSubjID1]=SubjSystem.CreateNewSubj('TestSubj1');
[CreateExpState1_1,newExpID1_1]=SubjSystem.CreateNewExp(newSubjID1);
[CreateExpState1_2,newExpID1_2]=SubjSystem.CreateNewExp(newSubjID1);
pause(1)

[CreateSubjState2,newSubjID2]=SubjSystem.CreateNewSubj('TestSubj2');
[CreateExpState2_1,newExpID2_1]=SubjSystem.CreateNewExp(newSubjID2);
[CreateExpState2_2,newExpID2_2]=SubjSystem.CreateNewExp(newSubjID2);
pause(1)


SubjSystem.DeletSubj(newSubjID1,1)
SubjSystem.DeletExp(newSubjID2,newExpID2_1,1)



