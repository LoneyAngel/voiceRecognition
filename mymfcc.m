%mfcc
clear;
clc; 
for i=1:10
    for j=1:10
        fname = sprintf('train\\%d%d.wav', i-1,j-1);
        samples{i}{j}=audioread(fname);
    end
end
save 'samples.mat' samples;

K   = length(samples);

% 计算语音参数
disp('正在计算语音参数');
for k = 1:K
    if isfield(samples(k),'data') && ~isempty(samples(k).data)
        continue;
    else
        samples(k).data = mfcc_(samples(k).wave);
    end
end