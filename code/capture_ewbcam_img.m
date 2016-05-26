function img = capture_ewbcam_img(t)
cam = webcam('Integrated Webcam');
preview(cam)
pause(t)
closePreview(cam)
img = snapshot(cam);
% figure; imshow(img)
clear('cam');