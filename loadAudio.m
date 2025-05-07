%初始化用户上传的音频文件
function loadAudio(~, ~)
    % 获取 GUI 中的共享变量
    global waveformAx mcffAx currentAudio currentFs filep  file

    [file, path] = uigetfile('*.wav', '选择语音文件');
    if isequal(file, 0)
        return;
    end
    filep=strcat(path,file);
    % 读取音频文件
    [y, fs] = audioread(filep);

    if size(y, 2) > 1
        y = mean(y, 2);  % 如果是立体声，转换为单声道
    end

    currentAudio = y;
    currentFs = fs;

    % 显示波形
    axes(waveformAx);
    cla(waveformAx);
    plot((1:length(y)) / fs, y);
    title('原始语音');

    coeffs = mfcc(y);
     % 选择要显示的特征类型（1:静态, 2:一阶差分, 3:二阶差分）
    % featureType = 1;  % 修改此值选择不同特征
    % 
    % switch featureType
    %     case 1
    %         coeffs = coeffs(:, 1);  % 静态系数
    %     case 2
    %         coeffs = coeffs(:, 14); % 一阶差分
    %     case 3
    %         coeffs = coeffs(:, size(coeffs, 2)); % 二阶差分
    % end
    % 在指定的坐标轴 (mfccAx) 上绘制 MFCC 曲线
    axes(mcffAx);  % 激活指定的坐标轴
    cla(mcffAx);   % 清除当前坐标轴上的内容

    % 绘制 MFCC 曲线
    plot(coeffs, 'LineWidth', 1.5);  % 绘制蓝色曲线
    title(mcffAx, 'MFCC（含动态）');  % 设置图标题
    xlabel(mcffAx, '时间帧');  % x轴标签
    ylabel(mcffAx, 'MFCC系数值');  % y轴标签

    % 设置坐标轴范围
    xlim(mcffAx, [1 size(coeffs, 1)]);  % x轴从1到特征矩阵的行数
    ylim(mcffAx, [min(coeffs(:)) max(coeffs(:))]);  % y轴根据特征的最小值和最大值

    % 显示图例
    legend(mcffAx, 'MFCC系数序列');
end
