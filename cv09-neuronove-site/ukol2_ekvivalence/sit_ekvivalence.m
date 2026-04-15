function [y, h1, h2] = sit_ekvivalence(x1, x2, W, b)

    h1 = sigmoid(x1 * W.ih(1,1) + x2 * W.ih(2,1) + b.h(1));
    h2 = sigmoid(x1 * W.ih(1,2) + x2 * W.ih(2,2) + b.h(2));

    y = sigmoid(h1 * W.ho(1) + h2 * W.ho(2) + b.o);

end