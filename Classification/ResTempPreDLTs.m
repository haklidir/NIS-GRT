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

dataFolder = "data";

%% Training Data Preparation %%

filenamePredictors = fullfile(dataFolder,"ResTempTrain.txt");
[XTrain,YTrain] = prepareDataTrain(filenamePredictors);

m = min([XTrain{:}],[],2);
M = max([XTrain{:}],[],2);
idxConstant = M == m;

for i = 1:numel(XTrain)
    XTrain{i}(idxConstant,:) = [];
end

% Normalization %%
mu = mean([XTrain{:}],2);
sig = std([XTrain{:}],0,2);

for i = 1:numel(XTrain)
    XTrain{i} = (XTrain{i} - mu) ./ sig;
end

%% Define Network Architecture %%

numResponses = size(YTrain{1},1);
featureDimension = size(XTrain{1},1);
numHiddenUnits = 200;

layers = [ ...
    sequenceInputLayer(featureDimension)
    lstmLayer(numHiddenUnits,'OutputMode','sequence')
    fullyConnectedLayer(50)
    dropoutLayer(0.5)
    fullyConnectedLayer(numResponses)
    regressionLayer];

%% solver 'adam'%%

maxEpochs = 500;
miniBatchSize = 100;

options = trainingOptions('adam', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'InitialLearnRate',0.005, ...
    'GradientThreshold',1, ...
    'Shuffle','never', ...
    'Plots','training-progress',...
    'Verbose',0);


%% Train the Network %%

net = trainNetwork(XTrain,YTrain,layers,options);

%% Test the Network %%

filenamePredictors = fullfile(dataFolder,"ResTempTestD.txt");
filenameResponses = fullfile(dataFolder,"ResTempTest.txt");
[XTest,YTest] = prepareDataTest(filenamePredictors,filenameResponses);

for i = 1:numel(XTest)
    XTest{i} = (XTest{i} - mu) ./ sig;
end

YPred = predict(net,XTest,'MiniBatchSize',1);

%% RMSE %%

for i = 1:numel(YTest)
    YTestLast(i) = YTest{i}(end);
    YPredLast(i) = YPred{i}(end);
end
figure
rmse = sqrt(mean((YPredLast - YTestLast).^2));
histogram(YPredLast - YTestLast)
title("RMSE = " + rmse)
ylabel("Frequency")
xlabel("Error")

figure(3);
ResTempTest = csvread('ResTempTest.txt');
Unit = csvread('UnitTs.txt');

TestPr = YPredLast ; 


% Create axes
axes1 = axes('Tag','MLearnAppTraceAxes');

% Create line
line(Unit,ResTempTest,'Parent',axes1,...
    'Tag','MLearnAppTracePlotTrainingDataTrace',...
    'MarkerSize',18,...
    'Marker','.',...
    'LineStyle','none',...
    'Color',[0 0.447 0.741]);

% Create line
line(Unit,TestPr,'Parent',axes1,...
    'Tag','MLearnAppTracePlotPredictionsTrace',...
    'MarkerSize',18,...
    'Marker','.',...
    'LineStyle','none',...
    'Color',[0.929 0.694 0.125]);

% Create ylabel
ylabel('Response (Reservoir Temperature)','Interpreter','none');

% Create xlabel
xlabel('Location','Interpreter','none');

% Create title
title('Predictions: model 1','Interpreter','none');

grid(axes1,'on');
% Set the remaining axes properties
set(axes1,'OuterPosition',...
    [0.00632911392405063 0.00537634408602151 0.987341772151899 0.989247311827957]);


figure(4);

axes1 = axes('Tag','MLearnAppPredictedVsActualAxes');

line(ResTempTest,TestPr,'Parent',axes1,...
    'Tag','MLearnAppPredictedVsActualPlotObservations',...
    'MarkerFaceColor',[0 0.447 0.741],...
    'MarkerSize',18,...
    'Marker','.',...
    'LineStyle','none',...
    'Color',[0 0.447 0.741]);

annotation('line',[0.132042253521127 0.903169014084507],...
    [0.110111111111111 0.926713947990544]);

% Create xlabel
xlabel('True Response');

% Create ylabel
ylabel('Predicted Response');


