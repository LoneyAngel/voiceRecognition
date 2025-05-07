%ѵ����Ԥ��ʹ�õĶ˵��⺯��
function [StartPoint, EndPoint] = vad(k)
    % Ԥ����
    k = double(k)/max(abs(double(k))); % ��һ��

    % ��֡����
    FrameLen = 240; % 30ms@8kHz
    FrameInc = 80;  % 10ms overlap

    % ��ʱ������
    FrameTemp1 = enframe(k(1:end-1), FrameLen, FrameInc);
    FrameTemp2 = enframe(k(2:end), FrameLen, FrameInc);
    zcr = sum(abs(FrameTemp1 - FrameTemp2) > 0.01, 2);

    % ��ʱ������Ԥ���أ�
    amp = sum(abs(enframe(filter([1 -0.9375],1,k), FrameLen, FrameInc)), 2);

    % ����Ӧ��ֵ
    ZcrMean = mean(zcr);
    ZcrLow = max(3, round(0.2*ZcrMean));
    ZcrHigh = max(8, round(0.5*ZcrMean));

    AmpMean = mean(amp);
    AmpLow = max(2, 0.1*AmpMean);
    AmpHigh = max(10, 0.3*max(amp));

    % ״̬������
    MaxSilence = 6;  % ���������(֡)
    MinAudio = 10;   % �����������(֡)

    % �˵���
    Status = 0;
    StartPoint = 1;
    HoldTime = 0;
    SilenceTime = 0;

    for n = 1:length(zcr)
        switch Status
            case 0 % ����
                if amp(n) > AmpHigh || zcr(n) > ZcrHigh
                    StartPoint = n; % ֱ�Ӽ�¼��ǰ֡Ϊ��ʼ��
                    Status = 1;
                    HoldTime = 1;   % ��ʼ����������ʱ��
                    SilenceTime = 0;
                else
                    HoldTime = HoldTime + 1;
                end
            case 1 % ����
                if amp(n) > AmpLow || zcr(n) > ZcrLow
                    HoldTime = HoldTime + 1;
                    SilenceTime = 0;
                else
                    SilenceTime = SilenceTime + 1;
                    if SilenceTime >= MaxSilence
                        EndPoint = n - SilenceTime;
                        if (EndPoint - StartPoint + 1) < MinAudio
                            Status = 0; % ��Ч�����Σ�����
                            HoldTime = 0;
                        else
                            Status = 2; % ��Ч����
                        end
                    end
                end
            case 2 % ����
                break;
        end
    end

    % ת��Ϊ����������
    StartPoint = (StartPoint - 1) * FrameInc + 1;
    EndPoint = min(StartPoint + HoldTime * FrameInc - 1, length(k));
end


%���enframe�����������Խ��ⲿ��ȡ��ע��
% function frames = enframe(x, win_len, hop_len)
%     num_frames = floor((length(x)-win_len)/hop_len) + 1;
%     frames = zeros(num_frames, win_len);
%     for i = 1:num_frames
%         start = (i-1)*hop_len + 1;
%         frames(i,:) = x(start:start+win_len-1);
%     end
% end