% This code has been developed for
% 
% "Predicting the Geothermal Reservoir Temperatures with Hydrogeochemical Aspect in Western Anatolia (Turkey): A Machine Learning Approach" has been submitted to Computer and Geosciences Journal https://www.journals.elsevier.com/computers-and-geosciences
% 
% by Füsun S. Tut Haklıdır, Mehmet Haklıdır
% 
% 1 Istanbul Bilgi University, Department of Energy Systems Engineering, Eyüp Istanbul-Turkey
% 
% 2 TUBITAK BILGEM, Gebze Kocaeli-Turkey
% 
% fusun.tut@bilgi.edu.tr, mehmet.haklidir@tubitak.gov.tr 

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



