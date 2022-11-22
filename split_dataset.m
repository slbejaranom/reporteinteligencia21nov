function [X_train,Y_train,X_test,Y_test,X_val,Y_val] = split_dataset(porcentaje_test,porcentaje_validacion,dataset)
%SPLIT_DATASET Summary of this function goes here
%   Detailed explanation goes here
    [filas, columnas] = size(dataset);
    
    X_train = dataset(1:round(filas*(1-porcentaje_validacion-porcentaje_test)),1:columnas-1);
    Y_train = dataset(1:round(filas*(1-porcentaje_validacion-porcentaje_test)),columnas);
    
    X_test = dataset(round(filas*(1-porcentaje_validacion-porcentaje_test))-1:round(filas*(1-porcentaje_test)),1:columnas-1);
    Y_test = dataset(round(filas*(1-porcentaje_validacion-porcentaje_test))-1:round(filas*(1-porcentaje_test)),columnas);
    
    X_val = dataset(round(filas*(1-porcentaje_test))-1:end,1:columnas-1);
    Y_val = dataset(round(filas*(1-porcentaje_test))-1:end,columnas);
end