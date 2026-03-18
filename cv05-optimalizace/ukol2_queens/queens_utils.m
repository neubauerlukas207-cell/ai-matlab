function out = queens_utils(mode, input)

    if strcmp(mode,'gen')
        out = randperm(input);
    elseif strcmp(mode,'conf')
        stav = input;
        N = length(stav);
        h = 0;

        for i=1:N-1
            for j=i+1:N
                if abs(i-j) == abs(stav(i)-stav(j))
                    h = h + 1;
                end
            end
        end
        out = h;
    end
end