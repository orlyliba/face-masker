function I_crop = cropFace_rect(I,face,pad)
% pad = percentage of padding in each side
I_crop = I;
center = [(face(1)+face(3))/2,(face(2)+face(4))/2];
cx = center(1);
cy = center(2);
w = face(3) - face(1) + 1;
h = face(4) - face(2) + 1;

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



