function I = removeMaskBlobs(I)
temp = I(:,:,1);
temp(temp>0) = 1;
temp = bwlabel(temp);
stats = regionprops(temp,'area');
region = 1;
for ind = 1:length(stats)
    stats(ind).Area;
    if stats(ind).Area > stats(region).Area;
        region = ind;
    end
end
I = I.*repmat((temp == region),[1 1 3]);