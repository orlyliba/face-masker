function [c] = getCenter(face,img_width,img_height)
% pad = percentage of padding in each side
center = face.position.center;
cx = center.x * img_width / 100;
cy = center.y * img_height / 100;
c = [cx cy];