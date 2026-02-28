function svet = svet_vysavace(N, procento)
% SVET_VYSAVACE Vytvoří svět NxN se smetím (1 = smetí, 0 = čisto)

if nargin < 2
    procento = 0.3;
end
if procento < 0 || procento > 1
    error('procento musi byt v intervalu <0,1>.');
end

svet.N = N;
svet.mapa = double(rand(N, N) < procento); % 1/0
end