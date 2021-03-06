% These codes has been developed for
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
%% Training by using Linear Reg.%%

[trainedResTempModel, validationRMSE] = trainResTempRegressionModel(dataTrainZ);

%% Training by using Linear SVM.%%
% [trainedResTempSVMModel, validationRMSE] = trainResTempSVMModel(dataTrainZ);
%%

TempTest = csvread('TempTest.txt');
% Create plot
plot(TempTest, 'DisplayName','Actual','Marker','diamond');

% Create xlabel
xlabel({'Record Number'});

% Create ylabel
ylabel({'Temperature (C)'});

hold on;

yfit = trainedResTempModel.predictFcn(dataTestZ);
% yfit = trainedResTempSVMModel.predictFcn(dataTestZ);

TestPr = yfit ; 

plot(TestPr, 'DisplayName','Predicted','Marker','hexagram');

legend ('show');

figure(2);

axes1 = axes('Tag','MLearnAppPredictedVsActualAxes');

line(TempTest,TestPr,'Parent',axes1,...
    'Tag','MLearnAppPredictedVsActualPlotObservations',...
    'MarkerFaceColor',[0 0.447 0.741],...
    'MarkerSize',18,...
    'Marker','.',...
    'LineStyle','none',...
    'Color',[0 0.447 0.741]);

annotation('line',[0.132042253521127 0.903169014084507],...
    [0.110111111111111 0.926713947990544]);

% Create xlabel
xlabel('Actual Reservoir Temperature');

% Create ylabel
ylabel('Predicted Reservoir Temperature');


