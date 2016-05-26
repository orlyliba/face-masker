function im = smoothEdges(im,win_size,std)
f = fspecial('gaussian',win_size,std);
win = ones(size(im,1),size(im,2));
win(1:10,:) = 0;
win(end-10+1:end,:) = 0;
win(:,1:10) = 0;
win(:,end-10+1:end) = 0;
win = imfilter(win,f);
im = im.*repmat(win,[1,1,size(im,3)]);
% figure; imshow(win);