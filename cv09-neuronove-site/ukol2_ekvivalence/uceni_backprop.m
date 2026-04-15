function [W, b, errors] = uceni_backprop()

    lr = 1.0;
    max_epoch = 20000;

    X = [0 0; 0 1; 1 0; 1 1];
    T = [1; 0; 0; 1];

    % inicializace
    W.ih = randn(2,2) * 0.5;
    W.ho = randn(2,1) * 0.5;

    b.h = randn(2,1) * 0.5;
    b.o = randn(1,1) * 0.5;

    errors = [];

    for epoch = 1:max_epoch
        mse = 0;

        for i = 1:4
            x1 = X(i,1);
            x2 = X(i,2);
            t = T(i);

            [y, h1, h2] = sit_ekvivalence(x1, x2, W, b);

            e = y - t;
            mse = mse + e^2;

            % delty
            delta_o = e * y * (1 - y);
            delta_h1 = delta_o * W.ho(1) * h1 * (1 - h1);
            delta_h2 = delta_o * W.ho(2) * h2 * (1 - h2);

            % aktualizace vah
            W.ho(1) = W.ho(1) - lr * delta_o * h1;
            W.ho(2) = W.ho(2) - lr * delta_o * h2;

            W.ih(1,1) = W.ih(1,1) - lr * delta_h1 * x1;
            W.ih(2,1) = W.ih(2,1) - lr * delta_h1 * x2;

            W.ih(1,2) = W.ih(1,2) - lr * delta_h2 * x1;
            W.ih(2,2) = W.ih(2,2) - lr * delta_h2 * x2;

            % biasy
            b.o = b.o - lr * delta_o;
            b.h(1) = b.h(1) - lr * delta_h1;
            b.h(2) = b.h(2) - lr * delta_h2;
        end

        mse = mse / 4;
        errors(end+1) = mse;

        if mod(epoch,1000)==0
            fprintf('Epoch %d, MSE = %.4f\n', epoch, mse);
        end

        if mse < 0.01
            fprintf('Ukonceno v epoche %d\n', epoch);
            break;
        end
    end
end