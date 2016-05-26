% Code used in:
% "Face and Photograph Augmentation Based on a Custom Theme"
% EE368 Project, Autmn 2015
% Orly Liba (orlyliba@stanford.edu)
% Do not use wihout pemission and proper credit

%%
clc; close all; clear;

%%
load('C:\Users\orly\Documents\Stanford\Courses\EE368\project\mask_files\skull3.mat')
% mask_path = 'C:\Users\orly\Documents\Stanford\Courses\EE368\project\masks\ronald2.jpg';
output_path = 'C:\Users\orly\Documents\Stanford\Courses\EE368\project\mask_files\skull3.mat';
mask_reference_path = 'C:\Users\orly\Documents\Stanford\Courses\EE368\project\masks\obama.jpg';

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
Iref = imread(mask_reference_path);
[face_ref, landmark_points_array_ref, img_width, img_height] = detect_clandmark(Iref, classifier, 1);

% Imask = imread(mask_path);

figure;
imshow(uint8(Imask))
hold on;
r = face_mask{1};
rectangle('Position',[r(1) r(2) r(3)-r(1)+1 r(4)-r(2)+1],'EdgeColor','r','LineWidth',2);
P = landmark_points_array_mask{1};
for j = 1:length(P)
    plot(P(1, j), P(2, j), 'b.', 'MarkerSize', 10);
    text(P(1, j), P(2, j),num2str(j),'color',[0 0 1]);
end

for ind = 37%1:length(landmark_points_array_ref{1})
    disp(ind)
    p = ginput(1);
    plot(p(1),p(2),'.m');
    text(p(1),p(2),num2str(ind));
    landmark_points_array_mask{1}(:,ind) = p;
end

% add_hat = 1;
% add_vignetting = 0;
% gradient_blur = 0;
% change_color_temp = 0;
% TempK = 3000;
% makeEyeHoles = 1;
% effect_img = [];
% a = 0.29;

%%
% save(output_path,'face_mask','landmark_points_array_mask','Imask_map','Imask','amp','effect','avoid_artifacts','effect_img','filt')
% save(output_path,'face_mask','landmark_points_array_mask','Imask_map','Imask','amp','effect','avoid_artifacts','effect_img','filt','makeEyeHoles')
save(output_path,'face_mask','landmark_points_array_mask','Imask_map','Imask',...
    'amp','effect','avoid_artifacts','effect_img','filt',...
    'add_hat','Imask_map_hat','hat_line','hat_w','hat_c','makeEyeHoles',...
    'TempK','a','change_color_temp','add_vignetting','gradient_blur')