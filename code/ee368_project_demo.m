% Main script for running 
% "Face and Photograph Augmentation Based on a Custom Theme"
% EE368 Project, Autmn 2015
% Orly Liba (orlyliba@stanford.edu)
% Do not use wihout pemission and proper credit

clc; clearvars; close all;
%% Init
outputFolder = 'C:\Users\orly\Documents\Stanford\Courses\EE368\project\demo output\';
addpath('C:\Users\orly\Documents\Stanford\Courses\EE368\project\Facialfeaturedetection\Facepp-Matlab-SDK\')
addpath('C:\Users\orly\Documents\Stanford\Courses\EE368\project\image warping\nonrigid_version23\')
addpath('C:\Users\orly\Documents\Stanford\Courses\EE368\project\image warping\nonrigid_version23\low_level_examples\')
addpath('c:\mexopencv-2.4')
addpaths();
addClandmarkPaths();
xml_file = fullfile(mexopencv.root(),'test','haarcascade_frontalface_alt2.xml');
classifier = cv.CascadeClassifier(xml_file);

%% Parameters
pad = 20; % percentage of padding in each side
target_pad_ratio = 1;


%% Mask
mask_path = 'C:\Users\orly\Documents\Stanford\Courses\EE368\project\mask_files\';
maskFiles = dir([mask_path '*.mat']);
fileInd = ceil(rand(1)*length(maskFiles));
mask_name = maskFiles(fileInd).name; 
disp(['Mask = ' mask_name(1:end-4)])
load([mask_path mask_name])
displayImgLandmarks(Imask,face_mask{1},landmark_points_array_mask{1});
displayImgLandmarks(Imask_map/255,face_mask{1},landmark_points_array_mask{1});

[c_mask] = [(face_mask{1}(1)+face_mask{1}(3))/2,(face_mask{1}(2)+face_mask{1}(4))/2];
Xmoving = landmark_points_array_mask{1}';
Imask_crop = cropFace_rect(Imask,face_mask{1},pad);
Imask_map_crop = cropFace_rect(Imask_map,face_mask{1},pad);

%% Target
test_img_path = 'C:\Users\orly\Documents\Stanford\Courses\EE368\project\test_imgs\';
% img = capture_ewbcam_img(5);
% imwrite(img,[test_img_path 'webcam_img.jpg']);
% target = [test_img_path 'webcam_img.jpg'];
target = [test_img_path 'jlaw2.jpg'];

%% Begin prcessing target
tic
Itarget = imread(target);

verbose = 1;
[face_target, landmark_points_array_target, img_width_target, img_height_target] = detect_clandmark(Itarget, classifier, verbose);
Itarget_final = Itarget;
Itarget_pad = round([size(Itarget_final,1),size(Itarget_final,2)]*target_pad_ratio);
Itarget_final = padarray(Itarget_final,Itarget_pad);

for face_i = 1:length(face_target)
    [c_target] = [(face_target{face_i}(1)+face_target{face_i}(3))/2,(face_target{face_i}(2)+face_target{face_i}(4))/2];
    Xstatic = landmark_points_array_target{face_i}';
    Itarget_crop = cropFace_rect(Itarget,face_target{face_i},pad);
    Xstatic_crop = Xstatic + repmat(-c_target + [size(Itarget_crop,2) size(Itarget_crop,1)]/2,[length(Xstatic) 1]);
    Imask_crop_resize = imresizeRGB(Imask_crop,[size(Itarget_crop,1) size(Itarget_crop,2)]);
    Imask_map_crop_resize = imresize(Imask_map_crop,[size(Itarget_crop,1) size(Itarget_crop,2)],'bilinear');
    Xmoving_crop = Xmoving + repmat(-c_mask + [size(Imask_crop,2) size(Imask_crop,1)]/2,[length(Xmoving) 1]);
    Xmoving_crop_resize = Xmoving_crop.*repmat(([size(Imask_crop_resize,2) size(Imask_crop_resize,1)]./[size(Imask_crop,2) size(Imask_crop,1)]),[length(Xmoving) 1]);
    
    %% Warping mask to fit target
    tform = fitgeotrans(Xmoving_crop_resize,Xstatic_crop,'lwm',68);
%     checkers = checkerboard(round(size(Imask_crop_resize,1)/10/2),10,size(Imask_crop_resize,2)/size(Imask_crop_resize,2)*10);
%     checkers = checkers(1:size(Imask_crop_resize,1),1:size(Imask_crop_resize,2));
%     figure; imshow(checkers)
%     figure; imshow(imwarp_same(checkers,tform,'FillValues',0,'SmoothEdges',true));
    Imask_crop_resize_warp = imwarp_same(Imask_crop_resize,tform,'FillValues',0,'SmoothEdges',true);
    Imask_map_crop_resize3 = repmat(Imask_map_crop_resize,[1 1 3]);
    Imask_map_crop_resize_warp = imwarp_same(Imask_map_crop_resize3,tform,'FillValues',0,'SmoothEdges',true);
    
    if avoid_artifacts
        Imask_map_crop_resize_warp = removeMaskBlobs(Imask_map_crop_resize_warp);
    end
    if makeEyeHoles
        Imask_map_crop_resize_warp = addEyeHolesToMask(Imask_map_crop_resize_warp,Xstatic_crop);
    else
        Imask_map_crop_resize_warp = hideEyes(Imask_map_crop_resize_warp,Xstatic_crop);
    end
    Imask_map_crop_resize_warp_smooth = smoothMask(Imask_map_crop_resize_warp,filt,amp,5);
    figure; imagesc(double(Imask_map_crop_resize_warp_smooth/255)); colormap gray; axis image
    I = blendMask(Imask_map_crop_resize_warp_smooth,Imask_crop_resize_warp,Itarget_crop);
    %% Place augmented face in original image
    Itarget_final(c_target(2)-size(I,1)/2+Itarget_pad(1):c_target(2)+size(I,1)/2-1+Itarget_pad(1) , c_target(1)-size(I,2)/2+Itarget_pad(2):c_target(1)+size(I,2)/2-1+Itarget_pad(2),:) = I;
    
end

if add_hat
    for face_i = 1:length(face_target)
        Itarget_final = addHatToImg(Itarget_final, Itarget_pad, landmark_points_array_target{face_i}, Imask, Imask_map_hat, hat_w, hat_c, filt, amp ,0);
    end
end

%% remve extra padding
Itarget_final = Itarget_final(Itarget_pad(1):end-Itarget_pad(1)+1,Itarget_pad(2):end-Itarget_pad(2)+1,:);
figure; imshow(uint8(Itarget_final))
imwrite(uint8(Itarget_final),[outputFolder datestr(now,30) '_' mask_name '.png'],'png')

%% add effects
if  strcmp(effect,'change_color_balance')
    Itarget_final = colorEqualization(Itarget_final,effect_img);
elseif strcmp(effect,'histogram_matching')
    Itarget_final = imhistmatch(Itarget_final,effect_img);
elseif strcmp(effect,'none')
    %do nothing    
elseif strcmp(effect,'change_saturation')
    [HSV] = rgb2hsv(Itarget_final);
    HSV(:,:,2) = HSV(:,:,2)/2;
    Itarget_final = 255*hsv2rgb(HSV);
end

if gradient_blur
    Itarget_final = addGradientBlur(Itarget_final);
end

if add_vignetting
    Itarget_final = addVignet(Itarget_final,0.5);
end

if change_color_temp
    Itarget_final = changeColorTemp(Itarget_final,TempK,a);
end

figure; imshow(uint8(Itarget_final))
imwrite(uint8(Itarget_final),[outputFolder datestr(now,30) '_' mask_name '_effects.png'],'png')

toc
