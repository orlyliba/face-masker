function I = changeColorTemp(I,TempK,a)
I = double(I);
% Calculate temperature RGB
rgb = temperatureRGB(TempK);
% Calculate luminance of those RGB values 
hsv_orig = rgb2hsv(I);
v = hsv_orig(:,:,3);
% Alpha-blend the RGB values with the temperature RGB values at the requested strength (max strength = 50/50 blend)
r = repmat(rgb(1),[size(I,1),size(I,2)])*a + I(:,:,1)*(1-a);
g = repmat(rgb(2),[size(I,1),size(I,2)])*a + I(:,:,2)*(1-a);
b = repmat(rgb(3),[size(I,1),size(I,2)])*a + I(:,:,3)*(1-a);
% Calculate HSV equivalents for the newly blended RGB values
hsv = rgb2hsv(cat(3,r,g,b));
% Convert those HSV equivalents back to RGB, but substitute the ORIGINAL luminance value (this maintains the luminance of the pixel)
I = hsv2rgb(cat(3,hsv(:,:,1),hsv(:,:,2),v));
I = uint8(I);

