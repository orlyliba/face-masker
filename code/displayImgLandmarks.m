function displayImgLandmarks(I,face,landmark_points)
figure;
imshow(I)
hold on;
r = face;
rectangle('Position',[r(1) r(2) r(3)-r(1)+1 r(4)-r(2)+1],'EdgeColor','r','LineWidth',2);
P = landmark_points;
for j = 1:length(P)
    plot(P(1, j), P(2, j), 'b.', 'MarkerSize', 10);
    text(P(1, j), P(2, j),num2str(j),'color',[0 0 1]);
end
