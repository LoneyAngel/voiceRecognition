%测试
%以现有的数据和模型进行识别准确度的计算
function hmm=test()
clear;
clc;
load('hmm.mat', 'hmm');  % 加载HMM模型
classes = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'k', 'g', 'x', 'z', 't', 'xzjdl'};
len = length(classes); % 获取类别数量

sum=0;
count=0;
% 遍历类别和序号
for i = 1:len
    j = 1;

    while j
        fname = sprintf('data\\%s%d.wav', classes{i}, j-1);
        if exist(fname, 'file') ~= 2
            break;
        end
        sum=sum+1;
        % ==== 步骤2：读取并预处理音频 ====
        try
            [y, fs] = audioread(fname);  % 读取音频
            y = mean(y, 2);  % 转为单声道
        catch
            errordlg('音频文件读取失败！','读取错误');
            j = j + 1;
            continue;
        end
        
        % ==== 步骤3：特征提取 ====
        try
            [x1, x2] = vad(y);                % 获取有效段采样点索引
            y_vad = y(x1:x2);                     % 截取有效语音段
            
            mfccs = mfcc(y_vad);             % 仅处理有效语音段
        catch
            errordlg('特征提取失败！','处理错误');
            j = j + 1;
            continue;
        end
        
        % ==== 步骤4：执行识别 ====
        try
        scores = zeros(1,16);
        for k = 1:16
            scores(k) = viterbi(hmm{k}, mfccs);  % 需要viterbi函数
        end
        [~, pred] = max(scores);
        catch
            % errordlg('识别过程出错！','算法错误');
            j = j + 1;
            continue;
        end
        if(pred==i)
            count=count+1;
        end
        j = j + 1;
    end
end
disp(count/sum);