function img_r = imresizeRGB(img,scale)
r = imresize(img(:,:,1),scale,'bilinear');
g = imresize(img(:,:,2),scale,'bilinear');
b = imresize(img(:,:,3),scale,'bilinear');
img_r = cat(3,r,g,b);
