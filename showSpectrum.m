function showSpectrum(~, ~)
    % 频谱分析功能按钮
    global currentAudio currentFs spectrumAx

    if isempty(currentAudio)
        msgbox('请先载入语音文件','提示');
        return;
    end

    y = currentAudio;
    fs = currentFs;

    N = length(y);
    Y = abs(fft(y));
    f = (0:N-1)/N * fs;

    axes(spectrumAx);
    cla(spectrumAx);
    plot(f(1:floor(N/2)), Y(1:floor(N/2)));
    title('频谱分析');
    xlabel('频率 (Hz)');
    ylabel('幅度');
end