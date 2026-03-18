function [x, y] = data_a_ztrata()
% DATA_A_ZTRATA Definuje trenovaci data

    x = [1,2,3,4,5,6,7,8,9,10];
    y = [2.1,4.0,5.8,8.2,9.9,12.1,14.0,15.9,18.1,20.0];
end

function L = mse_loss(a, b, x, y)
% MSE_LOSS Vypocet MSE

    y_pred = a * x + b;
    L = mean((y - y_pred).^2);
end