function [akce, stav] = muj_agent(percepce, stav)
% percepce.vidim_smeti, percepce.vidim_stenu
% akce: 'VYSAJ', 'POHNI_SE', 'OTOC_VPRAVO', 'OTOC_VLEVO'

if nargin < 2 || isempty(stav)
    stav.stena_za_sebou = 0;
end

if percepce.vidim_smeti
    akce = 'VYSAJ';
    stav.stena_za_sebou = 0;
    return;
end

if percepce.vidim_stenu
    stav.stena_za_sebou = stav.stena_za_sebou + 1;
    if stav.stena_za_sebou >= 2
        akce = 'OTOC_VLEVO';
        stav.stena_za_sebou = 0;
    else
        akce = 'OTOC_VPRAVO';
    end
else
    akce = 'POHNI_SE';
    stav.stena_za_sebou = 0;
end
end