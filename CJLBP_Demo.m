clc
clear all;
close all;
Test_CJLBP_Feature=[];
Test_CJLBP_Label=[];
Dataset='Test';
files=ls(Dataset)
files(1,:)=[]
files(1,:)=[]
%length(files)
for i=1:size(files,1)
    files2=strcat(Dataset,'\',files(i,:))
    files3=ls(files2)
    files3(1,:)=[]
    files3(1,:)=[]
    for j=1:size(files3,1)
        files4=strcat(files2,'\',files3(j,:))
        %files5=ls(files4)
        a=imread(files4);
        I=imresize(a,[200,200]);
        %imshow(I)
        % load image
        
        I = im2double(I);
        G = rgb2gray(I);
% run descriptor
        F= CJLBP(G);



        %pause(1)
        
        Test_CJLBP_Feature=[Test_CJLBP_Feature;F];
        if(files(i,:)=='1 ')
            Test_CJLBP_Label=[Test_CJLBP_Label;1];
        else
            Test_CJLBP_Label=[Test_CJLBP_Label;0];
        end
        %pause(1)
    end
end
save('Test_CJLBP_Feature','Test_CJLBP_Feature')
save('Test_CJLBP_Label','Test_CJLBP_Label')
