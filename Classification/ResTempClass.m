%% Training by using SVM%%
[trainedSVMClassifier, validationAccuracy] = trainSVMClassifier(dataTrainZ);
%% Training by using KNN%%
% [trainedKNNClassifier, validationAccuracy] = trainKNNClassifier(dataTrainZ);

yfit = trainedSVMClassifier.predictFcn(dataTestZ);
% yfit = trainedKNNClassifier.predictFcn(dataTestZ);

%
TempTestClass = csvread('TempTestClass.txt');
TempTestPr = yfit;
plotConfMat(confusionmat(TempTestClass,TempTestPr), {'Low', 'Medium', 'High'})



