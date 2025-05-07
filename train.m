%主训练函数
function hmm=train()
clear;
clc;
classes = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'k', 'g', 'x', 'z', 't', 'xzjdl'};
len = length(classes); % 获取类别数量

% 初始化 samples
samples = cell(len, 1); % 动态扩展数组
% 遍历类别和序号
for i = 1:len
    j = 1;
    count=1;
    while j
        fname = sprintf('data\\%s%d.wav', classes{i}, j-1);
        if exist(fname, 'file') ~= 2
            break;
        end

        [audio_data, fs] = audioread(fname);

        % 处理多声道音频
        if size(audio_data, 2) == 2
            audio_data = mean(audio_data, 2);
        end

        % 调用端点检测函数 vad
        try
            [start_idx, end_idx] = vad(audio_data);
            audio_data = audio_data(start_idx:end_idx); % 裁剪有效语音段
        catch
            fprintf('VAD处理失败: %s\n', fname);
            j = j + 1;
            continue;
        end

        % 检查裁剪后数据有效性
        if isempty(audio_data) || length(audio_data) < 0.1*fs % 至少保留0.1秒
            fprintf('无效语音段: %s\n', fname);
            j=j+1;
            continue;
        end

        samples{i}{count} = audio_data;
        j = j + 1;
        count=count+1;
    end
end
save 'samples.mat' samples;
 
for i=1:length(samples)
    sample=[];
    for k=1:length(samples{i})
        sample(k).wave=samples{i}{k};
        sample(k).data=[];
    end
    str = sprintf('现在训练第%d个HMM模型', i);
    disp(str);
    hmm{i}=trainhmm(sample,[3 3 3 3]);
    disp(['第' int2str(i) '个HMM模型训练完毕！']);
    save 'hmm.mat' hmm;
end

clear str i k j sample;