load('Train_CJLBP_Feature')
load('Test_CJLBP_Feature')
load('Train_CJLBP_Label')
load('Test_CJLBP_Label')
SVMModel=fitcsvm(Train_CJLBP_Feature,Train_CJLBP_Label);
[label,score]=predict(SVMModel,Test_CJLBP_Feature);
label=label';
Test_CJLBP_Label=Test_CJLBP_Label';
plotconfusion(label,Test_CJLBP_Label)