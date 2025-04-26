function showEndpoint(~, ~)
    % 端点检测功能按钮
    global currentAudio currentFs endpointAx

    if isempty(currentAudio)
        msgbox('请先载入语音文件','提示');
        return;
    end

    y = currentAudio;
    fs = currentFs;

    % 进行端点检测
    [x1,x2]=vad(y,fs);
    y_vad = y(x1:x2);
    % 显示端点检测结果
    axes(endpointAx);
    cla(endpointAx);
    plot((1:length(y_vad))/fs, y_vad);
    title('端点检测结果');
end