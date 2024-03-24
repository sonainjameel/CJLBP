function [CJLBP_SMCH] = CJLBP(Gray) % image,radius,neighbors,mapping,mode)
R = [3 2 1];
P =8;
x='x';
spoints=[];
for i=1:length(R)
sp = Sample_points(R(i),R(i)*8);
spoints{i}=sp;
end
patternMappingriu2 = getmapping(P,'riu2');


mapping=patternMappingriu2;
neighbors=P; 
mode=x;
image=Gray;
[row col] =size(Gray);
d_image=double(image);

% ===== Missing---

for i =1:length(R)
    if i==1
        im=Gray;
        [C,Dx,Dy,NN] = Segmentation(im,spoints{i},P);
        d_C = C;
        dx=Dx;
        dy=Dy;
        N = NN;
    else
        inc = R(1)-R(i);
        im=Gray(1+inc:row-inc,1+inc:col-inc);
        [C,Dx,Dy,NN] = Segmentation(im,spoints{i},P);
        N=N+NN;
    end
end
N=N/length(R);
%-------

bins = 2^neighbors;

% Initialize the result matrix with zeros.
CJLBP_S=zeros(dy+1,dx+1);
CJLBP_M=zeros(dy+1,dx+1);
CJLBP_C=zeros(dy+1,dx+1);

%Compute the LBP code image

for i = 1:neighbors

    D{i} = N(:,:,i) >= d_C;   
    Diff{i} = abs(N(:,:,i)-d_C);    
    MeanDiff(i) = mean(mean(Diff{i}));
end
% Difference threshold for CLBP_M
DiffThreshold = mean(MeanDiff);
% compute CLBP_S and CLBP_M
for i=1:neighbors
  % Update the result matrix.
  v = 2^(i-1);
  CJLBP_S = CJLBP_S + v*D{i};
  CJLBP_M = CJLBP_M + v*(Diff{i}>=DiffThreshold);
end
% CLBP_C
CJLBP_C = d_C>=mean(d_image(:));

%Apply mapping if it is defined
if isstruct(mapping)
    bins = mapping.num;
    sizarray = size(CJLBP_S);
    CJLBP_S = CJLBP_S(:);
    CJLBP_M = CJLBP_M(:);
    CJLBP_S = mapping.table(CJLBP_S+1);
    CJLBP_M = mapping.table(CJLBP_M+1);
    CJLBP_S = reshape(CJLBP_S,sizarray);
    CJLBP_M = reshape(CJLBP_M,sizarray);
    % % another implementation method
%     for i = 1:size(CLBP_S,1)
%         for j = 1:size(CLBP_S,2)
%             CLBP_S(i,j) = mapping.table(CLBP_S(i,j)+1);
%             CLBP_M(i,j) = mapping.table(CLBP_M(i,j)+1);
%         end
%     end
end

if (strcmp(mode,'h') || strcmp(mode,'hist') || strcmp(mode,'nh'))
    % Return with LBP histogram if mode equals 'hist'.
    CJLBP_S=hist(CJLBP_S(:),0:(bins-1));
    CJLBP_M=hist(CJLBP_M(:),0:(bins-1));
    if (strcmp(mode,'nh'))
        CJLBP_S=CJLBP_S/sum(CJLBP_S);
        CJLBP_M=CJLBP_M/sum(CJLBP_M);
    end
else
%     %Otherwise return a matrix of unsigned integers
%     if ((bins-1)<=intmax('uint8'))
%         CLBP_S=uint8(CLBP_S);
%         CLBP_M=uint8(CLBP_M);
%     elseif ((bins-1)<=intmax('uint16'))
%         CLBP_S=uint16(CLBP_S);
%         CLBP_M=uint16(CLBP_M);
%     else
%         CLBP_S=uint32(CLBP_S);
%         CLBP_M=uint32(CLBP_M);
%     end
end

CJLBP_SH = hist(CJLBP_S(:),0:patternMappingriu2.num-1);
    % Generate histogram of CLBP_M
    CJLBP_MH = hist(CJLBP_M(:),0:patternMappingriu2.num-1);    
    
    % Generate histogram of CLBP_M/C
    CJLBP_MC = [CJLBP_M(:),CJLBP_C(:)];
    Hist3D = hist3(CJLBP_MC,[patternMappingriu2.num,2]);
    CJLBP_MCH = reshape(Hist3D,1,numel(Hist3D)); 
    % Generate histogram of CLBP_S_M/C
    CJLBP_S_MCH = [CJLBP_SH,CJLBP_MCH];
    
    % Generate histogram of CLBP_S/M
    CJLBP_SM = [CJLBP_S(:),CJLBP_M(:)];
    Hist3D = hist3(CJLBP_SM,[patternMappingriu2.num,patternMappingriu2.num]);
    CJLBP_SMH = reshape(Hist3D,1,numel(Hist3D));
    
    % Generate histogram of CLBP_S/M/C
    CJLBP_MCSum = CJLBP_M;
    idx = find(CJLBP_C);
    CJLBP_MCSum(idx) = CJLBP_MCSum(idx)+patternMappingriu2.num;
    CJLBP_SMC = [CJLBP_S(:),CJLBP_MCSum(:)];
    Hist3D = hist3(CJLBP_SMC,[patternMappingriu2.num,patternMappingriu2.num*2]);
    CJLBP_SMCH = reshape(Hist3D,1,numel(Hist3D));