function [face, landmark_points_array, img_width, img_height] = detect_clandmark(I, classifier, verbose)
% Code used in:
% "Face and Photograph Augmentation Based on a Custom Theme"
% EE368 Project, Autmn 2015
% Orly Liba (orlyliba@stanford.edu)
% Do not use wihout pemission and proper credit
% This function uses Clandmark, by Michal Uricar: https://github.com/uricamic/clandmark. 

% CDPM
cdpm_model = 'C:\Users\orly\Documents\Stanford\Courses\EE368\project\Facialfeaturedetection\clandmark-master\models\CDPM.xml';
cdpm_flandmark = flandmark_class(cdpm_model);
bw = cdpm_flandmark.getBWsize();
cdpm_featuresPool = featuresPool_class(bw(1), bw(2));
cdpm_featuresPool.addLBPSparseFeatures(0);
cdpm_flandmark.setFeaturesPool(cdpm_featuresPool.getHandle());

% FDPM
fdpm_model = 'C:\Users\orly\Documents\Stanford\Courses\EE368\project\Facialfeaturedetection\clandmark-master\models\FDPM.xml';
fdpm_flandmark = flandmark_class(fdpm_model);
bw = fdpm_flandmark.getBWsize();
fdpm_featuresPool = featuresPool_class(bw(1), bw(2));
fdpm_featuresPool.addLBPSparseFeatures(0);
fdpm_flandmark.setFeaturesPool(fdpm_featuresPool.getHandle());


img_width = size(I,2);
img_height = size(I,1);

% Detect face OpenCV
Ibw = cv.cvtColor(I,'RGB2GRAY');
Ibw = cv.equalizeHist(Ibw);
bbox = classifier.detect(Ibw,'ScaleFactor',1.3,'MinNeighbors',2,'MinSize',[30,30]); % format expected by clandmark is [x_min, y_min, x_max, y_max]

for face_i = 1:length(bbox)
    bbox1 = bbox{face_i};
    w = bbox1(3);
    h = bbox1(4);
    x = bbox1(1) + w/2 - w/2*1.2;
    y = bbox1(2) + h/2 - h/2*1.2;
    w = w*1.2;
    h = h*1.2;
    bbox1 = [x, y, x+w-1, y+h-1];        
    
    % Detect landmarks - Coarse
    [Pcoarse, Stats1] = flandmark_opt_sv_detector(Ibw, int32(bbox1), cdpm_flandmark);
    
    % construct ideal bbox from GT
    bbox2 = getUpdatedBBOX(Pcoarse);            
    bbox2 = [bbox2(1,1), bbox2(2,1), bbox2(1,3), bbox2(2,3)];
    
    % Detect landmarks - Fine
    [P, Stats2] = flandmark_opt_sv_detector(Ibw, int32(bbox2(:)), fdpm_flandmark);
    
    if verbose
        figure; hold on;
        imshow(I, [], 'Border', 'tight'); hold on;
        r = bbox1;
        rectangle('Position',[r(1) r(2) r(3)-r(1)+1 r(4)-r(2)+1],'EdgeColor','g','LineWidth',2);
        r = bbox2;
        rectangle('Position',[r(1) r(2) r(3)-r(1)+1 r(4)-r(2)+1],'EdgeColor','r','LineWidth',2);
%         plot(Pcoarse(1, :), Pcoarse(2, :), 'k.', 'MarkerSize', 10);
%         for j = 1:length(Pcoarse)
%             text(Pcoarse(1, j), Pcoarse(2, j),num2str(j),'color',[0 0 0]);
%         end
        plot(P(1, :), P(2, :), 'b.', 'MarkerSize', 10);
        for j = 1:length(P)
            text(P(1, j), P(2, j),num2str(j),'color',[0 0 1]);
        end
        hold off;
    end
    face{face_i} = round(bbox2);
    landmark_points_array{face_i} = P;
end