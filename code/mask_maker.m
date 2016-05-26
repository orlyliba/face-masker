% Code used in:
% "Face and Photograph Augmentation Based on a Custom Theme"
% EE368 Project, Autmn 2015
% Orly Liba (orlyliba@stanford.edu)
% Do not use wihout pemission and proper credit

% Script to make mask and save it's properties

%%
clc; close all; clear;

%%
mask_path = 'C:\Users\orly\Documents\Stanford\Courses\EE368\project\masks\obama.jpg';
mask_reference_path = 'C:\Users\orly\Documents\Stanford\Courses\EE368\project\masks\obama.jpg';
mask_effect_img_path = 'C:\Users\orly\Documents\Stanford\Courses\EE368\project\masks\obama.jpg';
output_path = 'C:\Users\orly\Documents\Stanford\Courses\EE368\project\mask_files\obama.mat';
detectable = 1;
%%
addpath('C:\Users\orly\Documents\Stanford\Courses\EE368\project\Facialfeaturedetection\Facepp-Matlab-SDK\')
addpath('C:\Users\orly\Documents\Stanford\Courses\EE368\project\image warping\nonrigid_version23\')
addpath('C:\Users\orly\Documents\Stanford\Courses\EE368\project\image warping\nonrigid_version23\low_level_examples\')
addpath('c:\mexopencv-2.4')
addpaths();
addClandmarkPaths();
xml_file = fullfile(mexopencv.root(),'test','haarcascade_frontalface_alt2.xml');
classifier = cv.CascadeClassifier(xml_file);

%%
% mask
mask_map_path = [mask_path(1:end-4) '_map.jpg'];
Imask = imread(mask_path);
Imask_map = imread(mask_map_path);
Imask_map = mean(Imask_map,3);

if detectable
    [face_mask, landmark_points_array_mask, img_width, img_height] = detect_clandmark(Imask, classifier, 1);
else
    % load reference mask
    Iref = imread(mask_reference_path);
    [face_ref, landmark_points_array_ref, img_width, img_height] = detect_clandmark(Iref, classifier, 1);
    N = length(landmark_points_array_ref{1});
    
    figure('name','select rectangle of face'); imshow(Imask)
    r = getrect;
    face_mask{1} = round([r(1), r(2), r(1)+r(3)-1, r(2)+r(4)-1]);
    
    %%
    figure('name','mark points');
    imshow(Imask)
    hold on;
    for ind = 1:N
        disp(ind)
        p = ginput(1);
        plot(p(1),p(2),'.m');
        text(p(1),p(2),num2str(ind));
        landmark_points_array_mask{1}(ind,:) = p;
    end
    landmark_points_array_mask{1} = landmark_points_array_mask{1}';
    
    %% validation
    figure;
    imshow(Imask)
    hold on;
    r = face_mask{1};
    rectangle('Position',[r(1) r(2) r(3)-r(1)+1 r(4)-r(2)+1],'EdgeColor','r','LineWidth',2);
    P = landmark_points_array_mask{1};
    for j = 1:length(P)
        plot(P(1, j), P(2, j), 'b.', 'MarkerSize', 10);
        text(P(1, j), P(2, j),num2str(j),'color',[0 0 1]);
    end
end
%%
amp = 1;
filt = fspecial('gaussian',20,5); % make ones to disable
effect = 'none';%'none';%'change_color_balance'; %'change_saturation'
effect_img = [];%imread(mask_effect_img_path);%[];%imread(mask_effect_img_path);
avoid_artifacts = 1;

%%
save(output_path,'face_mask','landmark_points_array_mask','Imask_map','Imask','amp','effect','avoid_artifacts','effect_img','filt')