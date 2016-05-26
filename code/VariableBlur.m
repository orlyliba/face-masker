function blurred=VariableBlur(inputimage, BlurParamMatr)
% Applies blur filter on the inputmage with different parameters at each 
% individual pixels.
% inputimage: the image/matrix to be blurred
% BlurParamMatr: the matrix containing the blur parameter for each pixel,
% must be the same size as inputimage

BlurParamClasses = unique(BlurParamMatr(:));
BlurParamClasses(BlurParamClasses == 0) = [];

blurred = inputimage;
for i = 1 : numel(BlurParamClasses)
   PSF =  fspecial('disk', BlurParamClasses(i));
   BlurLayer = imfilter(inputimage, PSF,'same');     
   BlurLayerR = BlurLayer(:,:,1);
   BlurLayerG = BlurLayer(:,:,2);
   BlurLayerB = BlurLayer(:,:,3);
   BlurLayerR_ = blurred(:,:,1);
   BlurLayerG_ = blurred(:,:,2);
   BlurLayerB_ = blurred(:,:,3);
   BlurLayerR_(BlurParamMatr == BlurParamClasses(i)) = BlurLayerR(BlurParamMatr == BlurParamClasses(i));
   BlurLayerR_ = reshape(BlurLayerR_,size(BlurParamMatr));
   BlurLayerG_(BlurParamMatr == BlurParamClasses(i)) = BlurLayerG(BlurParamMatr == BlurParamClasses(i));
   BlurLayerG_ = reshape(BlurLayerG_,size(BlurParamMatr));
   BlurLayerB_(BlurParamMatr == BlurParamClasses(i)) = BlurLayerB(BlurParamMatr == BlurParamClasses(i));
   BlurLayerB_ = reshape(BlurLayerB_,size(BlurParamMatr));
   blurred = cat(3,BlurLayerR_,BlurLayerG_,BlurLayerB_);
end

