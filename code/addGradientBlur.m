function I = addGradientBlur(I)
gamma = 2;
blur_levels = 8;
blur_std = 11; % maximal blur disk size

dx = abs([1:size(I,2)] - size(I,2)/2);
dy = abs([1:size(I,1)] - size(I,1)/2);
[dx, dy] = meshgrid(dx,dy);
r = sqrt(dx.^2+dy.^2);
r = r./max(r(:));
BlurMat = r.^gamma;
% quantize for efficiency
BlurMat = round(BlurMat*blur_levels)/blur_levels;
BlurMat = BlurMat*blur_std;
I = VariableBlur(I, BlurMat);
BlurParamMatr = sqrt(dx.^2+dy.^2);
