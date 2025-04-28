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

    % 计算 25% 和 75% 的时间点
    total_length = length(y_vad); % y_vad 的总长度
    time_25_percent = (0.25 * total_length) / fs; % 25% 的时间点
    time_75_percent = (0.75 * total_length) / fs; % 75% 的时间点
    
    % 在 25% 和 75% 的位置画竖线
    xline(time_25_percent, 'k--', 'LineWidth', 1.5); % 红色虚线
    xline(time_75_percent, 'k--', 'LineWidth', 1.5); % 绿色虚线


    title('端点检测结果');
end