# EEG 神经反馈系统

一款基于 MATLAB 的 EEG 神经反馈训练系统。在神经反馈实验过程中可实时观察并记录 EEG 信号和神经反馈实验标记。拥有一套被试数据管理系统，方便管理被试每次实验的数据。

系统的同步基于 [labstreaminglayer](https://github.com/labstreaminglayer/liblsl-Matlab)，可接入 labstreaminglayer 的 EEG 记录系统都可使用此神经反馈训练系统。

神经反馈训练界面使用 [Psychophysics Toolbox Version 3](http://psychtoolbox.org/)，可进行编程对反馈界面进行调整。

版权遵守 [署名-非商业性使用-禁止演绎 4.0 国际](https://creativecommons.org/licenses/by-nc-nd/4.0/deed.zh)

## 安装

1. 安装 labstreaminglayer，具体安装过程请参阅 [github.com/labstreaminglayer/liblsl-Matlab](https://github.com/labstreaminglayer/liblsl-Matlab)。
2. 安装 Psychophysics Toolbox，具体安装过程请参照 [psychtoolbox.org/download.html#installation](http://psychtoolbox.org/download.html#installation)。
3. 下载此系统，即可在 MATLAB 直接使用（现在仅在 MATLAB 2020b 中测试过）。

## 数据管理

数据保存在 `Data` 文件夹中，每个被试一个文件夹单独管理（文件夹名为被试ID），每个被试文件夹下每个实验也是一个文件单独管理（文件夹名为实验ID）。基本文件夹层级如下

+ Data
  + SubjList.mat（数据库配置文件）
  + Sub 1 ID
    + SubjInfo.txt（Sub 1 被试信息）
    + Exp 1 ID
      + ExpInfo.txt（Exp 1 实验信息）
    + Exp 2 ID
      + ExpInfo.txt（Exp 2 实验信息）
      + Data.txt（Exp 2 EEG 数据）
      + Marker.txt（Exp 2 神经反馈标记）
      + InterfaceParameters.txt （神经反馈流程与参数）
    + ...
  + Sub 2 ID
    + SubjInfo.txt（Sub 2 被试信息）
  + ...

## 使用

1. 运行 `MainWindow.mlapp` 启动主界面，在主界面可以添加、删除、编辑被试与实验信息。
2. 点击 `Connect to Device` 来搜索并连接 EEG 记录设备（EEG 记录设备需要连入 labstreaminglayer）。
3. 点击 `Design Feedback Interface` 来编辑实验流程与参数，实验流程与参数会保存在 `InterfaceParameters.txt`。
4. 点击 `Open Signal Recording` 来打开信号记录界面。
5. 点击 `Open Feedback Interface` 来打开反馈界面，反馈界面实现是 `NFInterfaceDisp.m`，可自行修改。
6. 在信号记录界面点击 `Connect to Interface` 来连接反馈界面，从而接收神经反馈标记。
7. 在信号记录界面点击 `Recording` 开始记录信号与神经反馈标记。
8. 在神经反馈界面，开始神经反馈训练。
9. 再次点击信号记录界面点击 `Recording` 停止记录信号与神经反馈标记。

基本操作的视频：[https://www.bilibili.com/video/BV1AQ4y1o79B/](https://www.bilibili.com/video/BV1AQ4y1o79B/)

