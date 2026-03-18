function [a, b, loss_history] = gradient_descent(x, y, alpha, max_iter)

    a = 0;
    b = 0;

    n = length(x);
    loss_history = zeros(1, max_iter);

    for i = 1:max_iter
        y_pred = a * x + b;
        e = y - y_pred;

        dL_da = -(2/n) * sum(x .* e);
        dL_db = -(2/n) * sum(e);

        a = a - alpha * dL_da;
        b = b - alpha * dL_db;

        loss_history(i) = mean((y - (a*x + b)).^2);
    end
end