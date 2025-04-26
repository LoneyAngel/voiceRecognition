function runGUI
    clc; close all;
    global waveformAx mcffAx spectrumAx endpointAx resultText


    % 创建主界面窗口
    f = figure('Name','语音识别系统','Position',[300 100 1000 700]);

    % 左侧功能面板标题
    uicontrol('Style','text','Position',[50 620 120 30],'String','操作面板','FontSize',12,'FontWeight','bold');

    % 功能按钮
    uicontrol('Style','pushbutton','String','载入语音','FontSize',12,...
        'Position',[50 560 120 40],'Callback',@loadAudio);

    uicontrol('Style','pushbutton','String','频谱分析','FontSize',12,...
        'Position',[50 500 120 40],'Callback',@showSpectrum);

    uicontrol('Style','pushbutton','String','端点检测','FontSize',12,...
        'Position',[50 440 120 40],'Callback',@showEndpoint);

    uicontrol('Style','pushbutton','String','识别','FontSize',12,...
        'Position',[50 380 120 40],'Callback',@recordAndPredict);

    uicontrol('Style','pushbutton','String','退出','FontSize',12,...
        'Position',[50 320 120 40],'Callback',@(src,evt) close(f));

    resultText = uicontrol('Style','text','String','识别结果：','FontSize',12,...
        'Position',[40 250 180 30],'HorizontalAlignment','left');

    % 图像区域
    waveformAx = axes('Parent',f,'Position',[0.35, 0.60, 0.28, 0.3]);
    title(waveformAx, '原始语音');

    %显示mfcc
    % 修改后的 MFCC 特征显示区域
    mcffAx = axes('Parent',f,'Position',[0.70, 0.60, 0.28, 0.3]);
    title(mcffAx, 'MFCC（含动态）');

    spectrumAx = axes('Parent',f,'Position',[0.35, 0.15, 0.28, 0.3]);
    title(spectrumAx, '频谱分析');

    endpointAx = axes('Parent',f,'Position',[0.70, 0.15, 0.28, 0.3]);
    title(endpointAx, '端点检测');
end
