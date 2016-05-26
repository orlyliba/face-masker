% Code used in:
% "Face and Photograph Augmentation Based on a Custom Theme"
% EE368 Project, Autmn 2015
% Orly Liba (orlyliba@stanford.edu)
% Do not use wihout pemission and proper credit

%%
clc; close all; clear;
%%
load('C:\Users\orly\Documents\Stanford\Courses\EE368\project\mask_files\santa.mat')
mask_path = 'C:\Users\orly\Documents\Stanford\Courses\EE368\project\masks\santa3.jpg';
output_path = 'C:\Users\orly\Documents\Stanford\Courses\EE368\project\mask_files\santa.mat';
%%
% avoid_artifacts = 1;
% filt = fspecial('gaussian',20,10); % make ones to disable
% amp = 1;
% 
% %% update mask map
Imask = imread(mask_path);
% 
%% update mask map
mask_map_path = [mask_path(1:end-4) '_map.jpg'];
Imask_map = imread(mask_map_path);
Imask_map = mean(Imask_map,3);
%% recangle
% figure('name','select rectangle of face'); imshow(Imask)
% r = getrect;
% face_mask{1} = round([r(1), r(2), r(1)+r(3)-1, r(2)+r(4)-1]);

%% Add mask hat

mask_map_hat_path = [mask_path(1:end-4) '_map_hat.jpg'];
Imask_map_hat = imread(mask_map_hat_path);
Imask_map_hat = mean(Imask_map_hat,3);
figure; imshow(uint8(Imask_map_hat))
h = imline;
pos = getPosition(h);
hat_line = pos;
hat_w = sqrt(sum((pos(1,:)-pos(2,:)).^2));
figure; imshow(uint8(Imask))
p = ginput(1);
hat_c = p; % x,y

%%
makeEyeHoles = 0;
%%
save(output_path,'face_mask','landmark_points_array_mask','Imask_map','Imask',...
    'amp','effect','avoid_artifacts','effect_img','filt',...
    'Imask_map_hat','hat_line','hat_w','hat_c','makeEyeHoles')