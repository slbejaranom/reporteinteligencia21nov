function [shuffled_dataset] = shuffle_dataset(dataset)
%SHUFFLE_DATASET Summary of this function goes here
%   Detailed explanation goes here
    [filas, columnas] = size(dataset);

    % Le hacemos shuffle al dataset
    shuffled_index = randperm(filas);
    shuffled_dataset = zeros(filas,columnas);
    
    for i=1:1:filas
        shuffled_dataset(i,:) = dataset(shuffled_index(i),:);
    end
end