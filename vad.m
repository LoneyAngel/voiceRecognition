%训练和预测使用的端点检测函数
function [StartPoint, EndPoint] = vad(k)
    % 预处理
    k = double(k)/max(abs(double(k))); % 归一化

    % 分帧参数
    FrameLen = 240; % 30ms@8kHz
    FrameInc = 80;  % 10ms overlap

    % 短时过零率
    FrameTemp1 = enframe(k(1:end-1), FrameLen, FrameInc);
    FrameTemp2 = enframe(k(2:end), FrameLen, FrameInc);
    zcr = sum(abs(FrameTemp1 - FrameTemp2) > 0.01, 2);

    % 短时能量（预加重）
    amp = sum(abs(enframe(filter([1 -0.9375],1,k), FrameLen, FrameInc)), 2);

    % 自适应阈值
    ZcrMean = mean(zcr);
    ZcrLow = max(3, round(0.2*ZcrMean));
    ZcrHigh = max(8, round(0.5*ZcrMean));

    AmpMean = mean(amp);
    AmpLow = max(2, 0.1*AmpMean);
    AmpHigh = max(10, 0.3*max(amp));

    % 状态机参数
    MaxSilence = 6;  % 最大静音长度(帧)
    MinAudio = 10;   % 最短语音长度(帧)

    % 端点检测
    Status = 0;
    StartPoint = 1;
    HoldTime = 0;
    SilenceTime = 0;

    for n = 1:length(zcr)
        switch Status
            case 0 % 静音
                if amp(n) > AmpHigh || zcr(n) > ZcrHigh
                    StartPoint = n; % 直接记录当前帧为起始点
                    Status = 1;
                    HoldTime = 1;   % 初始化语音持续时间
                    SilenceTime = 0;
                else
                    HoldTime = HoldTime + 1;
                end
            case 1 % 语音
                if amp(n) > AmpLow || zcr(n) > ZcrLow
                    HoldTime = HoldTime + 1;
                    SilenceTime = 0;
                else
                    SilenceTime = SilenceTime + 1;
                    if SilenceTime >= MaxSilence
                        EndPoint = n - SilenceTime;
                        if (EndPoint - StartPoint + 1) < MinAudio
                            Status = 0; % 无效语音段，重置
                            HoldTime = 0;
                        else
                            Status = 2; % 有效结束
                        end
                    end
                end
            case 2 % 结束
                break;
        end
    end

    % 转换为采样点索引
    StartPoint = (StartPoint - 1) * FrameInc + 1;
    EndPoint = min(StartPoint + HoldTime * FrameInc - 1, length(k));
end


%如果enframe函数报错，可以将这部分取消注释
% function frames = enframe(x, win_len, hop_len)
%     num_frames = floor((length(x)-win_len)/hop_len) + 1;
%     frames = zeros(num_frames, win_len);
%     for i = 1:num_frames
%         start = (i-1)*hop_len + 1;
%         frames(i,:) = x(start:start+win_len-1);
%     end
% end