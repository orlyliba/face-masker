% Code used in:
% "Face and Photograph Augmentation Based on a Custom Theme"
% EE368 Project, Autmn 2015
% Orly Liba (orlyliba@stanford.edu)
% Do not use wihout pemission and proper credit

%%
clc; close all; clear;
%%
load('C:\Users\orly\Documents\Stanford\Courses\EE368\project\mask_files\skull3.mat')
mask_path = 'C:\Users\orly\Documents\Stanford\Courses\EE368\project\masks\skull3.jpg';
output_path = 'C:\Users\orly\Documents\Stanford\Courses\EE368\project\mask_files\skull3.mat';
%%
% add_hat = 0;
% add_vignetting = 1;
% gradient_blur = 1;
% change_color_temp = 1;
% TempK = 10000;
% makeEyeHoles = 0;
% % effect_img = [];
% a = 0.29;
% Imask_map_hat = [];
% hat_line = [];
% hat_c = [];
% hat_w = [];
% effect = 'none';
% 
Imask = imread(mask_path);
Imask_map = mean(imread([mask_path(1:end-4) '_map.jpg']),3);
filt = fspecial('gaussian',20,5); % make ones to disable

%%
save(output_path,'face_mask','landmark_points_array_mask','Imask_map','Imask',...
    'amp','effect','avoid_artifacts','effect_img','filt',...
    'add_hat','Imask_map_hat','hat_line','hat_w','hat_c','makeEyeHoles',...
    'TempK','a','change_color_temp','add_vignetting','gradient_blur')
