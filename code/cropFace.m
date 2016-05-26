function I_crop = cropFace(I,face,img_width,img_height,pad)
% pad = percentage of padding in each side
I_crop = I;
center = face.position.center;
cx = center.x * img_width / 100;
cy = center.y * img_height / 100;
w = face.position.width / 100 * img_width;
h = face.position.height / 100 * img_height;

w = w*(1+2*pad/100);
h = h*(1+2*pad/100);

if round(cy + h/2) > size(I_crop,1)
    I_crop = padarray(I_crop,[round(h/2) 0],'post');
end
I_crop = I_crop(1:round(cy + h/2),:,:);

if round(cx + w/2) > size(I_crop,2)
    I_crop = padarray(I_crop,[0 round(w/2)],'post');
end
I_crop = I_crop(:,1:round(cx + w/2),:);

if round(cy - h/2) < 1    
    I_crop = padarray(I_crop,[round(h/2) 0],'pre');
    cy = cy + round(h/2);
end
I_crop = I_crop(round(cy - h/2):end,:,:);    

if round(cx - w/2) < 1    
    I_crop = padarray(I_crop,[0 round(w/2)],'pre');
    cx = cx + round(w/2);
end
I_crop = I_crop(:,round(cx - w/2):end,:);    



