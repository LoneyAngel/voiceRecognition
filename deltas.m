
function d = deltas(x)
% 计算动态特征（差分）系数，x行为维度，列为时间帧
% 参考 HTK 的计算方式，使用 ±2 差分窗口

    [numFeatures, numFrames] = size(x);
    d = zeros(numFeatures, numFrames);
    N = 2;

    denom = 2 * sum((1:N).^2);

    for t = 1:numFrames
        numerator = zeros(numFeatures, 1);
        for n = 1:N
            idx1 = min(numFrames, t + n);
            idx2 = max(1, t - n);
            numerator = numerator + n * (x(:,idx1) - x(:,idx2));
        end
        d(:,t) = numerator / denom;
    end
end