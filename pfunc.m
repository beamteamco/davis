function y = pfunc(p,x,type)
p   = p(:);
x   = x(:);
y   = x.*0;
% type = 'pvoigt';
numpk   = (length(p) - 2)/4;

A       = p(1);
Gamma   = p(2);
eta     = p(3);
xPeak   = p(4);

pG  = [A Gamma xPeak];
pL  = [A Gamma xPeak];

for i = 1:1:numpk
    ji  = 4*(i - 1) + 1;
    jf  = 4*i;
    ppk = p(ji:jf);
    if(strcmp(type,'pvoigt'))
        ypk = pkpseudoVoigt(ppk,x);
    elseif(strcmp(type,'gaussian'))
        ypk = pkGaussian(pG,x);
    elseif(strcmp(type,'lorentz'))
        ypk = pkLorentzian(pL,x);
    end
    y   = y + ypk;
end
pbkg    = p((numpk*4+1):end);
ybkg    = polyval(pbkg,x);

y   = y + ybkg;