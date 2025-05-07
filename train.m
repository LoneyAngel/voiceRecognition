%��ѵ������
function hmm=train()
clear;
clc;
classes = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'k', 'g', 'x', 'z', 't', 'xzjdl'};
len = length(classes); % ��ȡ�������

% ��ʼ�� samples
samples = cell(len, 1); % ��̬��չ����
% �����������
for i = 1:len
    j = 1;
    count=1;
    while j
        fname = sprintf('data\\%s%d.wav', classes{i}, j-1);
        if exist(fname, 'file') ~= 2
            break;
        end

        [audio_data, fs] = audioread(fname);

        % �����������Ƶ
        if size(audio_data, 2) == 2
            audio_data = mean(audio_data, 2);
        end

        % ���ö˵��⺯�� vad
        try
            [start_idx, end_idx] = vad(audio_data);
            audio_data = audio_data(start_idx:end_idx); % �ü���Ч������
        catch
            fprintf('VAD����ʧ��: %s\n', fname);
            j = j + 1;
            continue;
        end

        % ���ü���������Ч��
        if isempty(audio_data) || length(audio_data) < 0.1*fs % ���ٱ���0.1��
            fprintf('��Ч������: %s\n', fname);
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
    str = sprintf('����ѵ����%d��HMMģ��', i);
    disp(str);
    hmm{i}=trainhmm(sample,[3 3 3 3]);
    disp(['��' int2str(i) '��HMMģ��ѵ����ϣ�']);
    save 'hmm.mat' hmm;
end

clear str i k j sample;