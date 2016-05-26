function I = smoothMask(I,filt,amp,edge_std)
I = imfilter(I,filt)*amp;
I(I>255) = 255;
I = smoothEdges(I,edge_std*4,edge_std);