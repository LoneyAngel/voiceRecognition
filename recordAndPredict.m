function recordAndPredict(~, ~)
    % % GMM + HMM 声音识别按钮功能
    global resultText filep % 获取全局音频文件路径
    
    % ==== 步骤1：加载预训练模型 ====
    try
        load('hmm.mat', 'hmm');  % 加载HMM模型
    catch
        errordlg('模型文件hmm.mat加载失败！','文件错误');
        return;
    end
    
    % ==== 步骤2：读取并预处理音频 ====
    try
        [y, fs] = audioread(filep);  % 读取音频
        y = mean(y, 2);  % 转为单声道
    catch
        errordlg('音频文件读取失败！','读取错误');
        return;
    end
    
    % ==== 步骤3：特征提取 ====
    try
        [x1, x2] = vad(y);                % 获取有效段采样点索引
        y_vad = y(x1:x2);                     % 截取有效语音段
        mfccs = mfcc(y_vad);             % 对有效语音段进行mfcc特征提取
    catch
        errordlg('特征提取失败！','处理错误');
        return;
    end
    
    % ==== 步骤4：执行识别 ====
    try
        scores = zeros(1,16);
        for i = 1:16
            scores(i) = viterbi(hmm{i}, mfccs);  % 使用模型进行判断
        end
        [~, pred] = max(scores);%返回最大概率者
    catch
        errordlg('识别过程出错！','算法错误');
        return;
    end
    
    % ==== 步骤5：显示结果 ====
    chinese_mapping = {...
        '零', '一', '二', '三', '四', ...
        '五', '六', '七', '八', '九', ...
        '开门', '关门', '消毒', '照明', '通风', ...
        '现在几点了'
    };
    resultText.String = ['识别结果：', chinese_mapping{pred}];
    % msgbox(['识别为：', chinese_mapping{pred}], '结果');
end