% load image
I= imread('image.png');
I = im2double(I);
I = rgb2gray(I);
% run descriptor
Features= CJLBP(I);


