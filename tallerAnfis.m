%% Serie de Mackey-Glass

clear all,
close all,
clc,

load mgdata.dat
time = mgdata(:,1);
x = mgdata(:, 2);
figure(1)
plot(time,x)
title('Mackey-Glass Chaotic Time Series')
xlabel('Time (sec)')
ylabel('x(t)')

% Generación del dataset
orden_predictor = 5;
[filas, columnas] = size(mgdata);
dataset = zeros(filas, orden_predictor+1);
for i = 1:1:orden_predictor+1
    dataset(i:end,i) = mgdata(1:(end-(i-1)),2);
end
dataset = fliplr(dataset);

% Generación del anfis

rng('shuffle');

n=orden_predictor; % numero de entradas
m=10; % numero de reglas
myfix = FIS_aleatorio(m,n) % Genera sistema difuso Takagi-sugeno de forma aleatoria

nex = 50; % número de experimentos
nit = 50; % número de iteraciones

dataset = dataset./max(max(dataset));

%shuffled dataset
shuffled_dataset = shuffle_dataset(dataset);

porcentaje_test = 0.2;
porcentaje_validacion = 0.1;

% Split del dataset
[X_train,Y_train,X_test,Y_test,X_val,Y_val] = split_dataset(porcentaje_test,porcentaje_validacion,dataset);
[X_train_shuffled,Y_train_shuffled,X_test_shuffled,Y_test_shuffled,X_val_shuffled,Y_val_shuffled] = split_dataset(porcentaje_test,porcentaje_validacion,shuffled_dataset);

for k=1:nex
    q = nit; % Contador de EPOCAS
    
    opt = anfisOptions('InitialFIS',FIS_aleatorio(m,n),'EpochNumber',q);
    opt.DisplayANFISInformation = 0;
    opt.DisplayErrorValues = 0;
    opt.DisplayStepSize = 0;
    opt.DisplayFinalResults = 0;
    opt.StepSizeIncreaseRate = 1.0000001;    % tasa de aprendizaje
    opt.StepSizeDecreaseRate = 0.9999999;    % tasa de aprendizaje
    opt.InitialStepSize = 0.01;
    opt.ValidationData = [X_test_shuffled Y_test_shuffled]; % conjunto de validación 28 muestras
    [fis,trainError,stepSize,chkFIS,chkError] = anfis([X_train_shuffled Y_train_shuffled],opt); % conjunto de entrenamiento 98 muestras
    
    fis_iter(k) = fis;
    trainError_iter(:,k) = trainError;
    stepSize_iter(:,k) = stepSize;
    chkFIS_iter(k) = chkFIS;
    chkError_iter(:,k) = chkError;
    
    k  
end

figure, 
plot(chkError_iter);
title("Error de validación cuadrático medio");
xlabel("Numero de epocas");
ylabel("Error");

figure, 
plot(trainError_iter);
title("Error de entrenamiento cuadrático medio");
xlabel("Numero de epocas");
ylabel("Error");

figure,
histogram(chkError_iter);
title("Histograma error de validación cuadrático medio");
xlabel("Error");
ylabel("Repetibilidad");

figure,
histogram(trainError_iter);
title("Histograma error de entrenamiento cuadrático medio");
xlabel("Error");
ylabel("Repetibilidad");

% Guarda el numero de experimento y la iteracion en la que se logro "optimizar"
mint=min(min(trainError_iter));
[N_iter,N_exp]=find(trainError_iter == mint); 
