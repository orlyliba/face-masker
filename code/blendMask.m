function I = blendMask(Imask_map,Imask,Itarget)    
Imask_map = Imask_map/255;
I = Imask_map.*double(Imask) + (ones(size(Imask_map))-Imask_map).*double(Itarget);