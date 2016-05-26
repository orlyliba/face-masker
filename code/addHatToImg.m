function Itarget = addHatToImg(Itarget, Itarget_pad, Ptarget, Imask, Imask_map_hat, hat_w, hat_c, filt, amp ,verbose)
% Code used in:
% "Face and Photograph Augmentation Based on a Custom Theme"
% EE368 Project, Autmn 2015
% Orly Liba (orlyliba@stanford.edu)
% Do not use wihout pemission and proper credit

% find angle of face
line_of_face = Ptarget(:,28:31);
y = [line_of_face(2,:)' ones(length(line_of_face(1,:)),1)];
x = [line_of_face(1,:)'];
A = y\x;
angle = (180/pi*atan(A(1)));

% Find scale of face compared to hat
hat_scale = sqrt(sum((Ptarget(:,17)-Ptarget(:,1)).^2))/hat_w;

% Adapt hat to target
Imask_hat_resize = imresizeRGB(Imask,hat_scale);
Imask_map_hat_smooth = imfilter(Imask_map_hat,filt)*amp;
Imask_map_hat_smooth_resize = repmat(imresize(Imask_map_hat_smooth,hat_scale),[1 1 3]);

% Rotate about the center of the face (between eyes)
hat_c_resize = hat_c*hat_scale;
Imask_map_hat_smooth_resize=rotateAround(Imask_map_hat_smooth_resize, hat_c_resize(2), hat_c_resize(1), angle, 'bilinear');
Imask_hat_resize=rotateAround(Imask_hat_resize, hat_c_resize(2), hat_c_resize(1), angle, 'bilinear');
if verbose
    figure; imshow(uint8(Imask_hat_resize))
    figure; imshow(uint8(Imask_map_hat_smooth_resize*255))
end

% Position the hat on the image
pos = Ptarget(:,28) - hat_c_resize' + [1; 1] + [Itarget_pad(2);Itarget_pad(1)]; % top left corner of crop
Itarget(pos(2):pos(2)+size(Imask_hat_resize,1)-1,pos(1):pos(1)+size(Imask_hat_resize,2)-1,:) =...
    Imask_map_hat_smooth_resize/255.*double(Imask_hat_resize) + ...
    (ones(size(Imask_map_hat_smooth_resize))-Imask_map_hat_smooth_resize/255).*double(Itarget(pos(2):pos(2)+size(Imask_hat_resize,1)-1,pos(1):pos(1)+size(Imask_hat_resize,2)-1,:));