function R = LatParmResid2(x,tth,lam,hkls,type)


%% Perform Calculations


R = zeros(size(hkls,1),1);
if(strcmp(type,'cubic'))
    for(i=1:size(hkls,1))
        R(i,1) = tth(i) - 2*asind(lam*sqrt(hkls(i,1)^2 + hkls(i,2)^2 + hkls(i,3)^2)/(2*x(1)));
    end
elseif(strcmp(type,'tetragonal'))
    for(i=1:size(hkls,1))
        R(i,1) = tth(i) - 2*asind((lam/2)*((hkls(i,1)+hkls(i,2))/x(1)^2 + hkls(i,3)/x(3)^2)^(-0.5));
    end
end
%NEED TO ADD OTHER GEOMETRY TYPES ONCE HKLS ARE AQUIRED