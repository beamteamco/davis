function R = LatParmResid(x,tth,lam,hkls,type)


%% Perform Calculations

if(size(hkls,1) < 6)
    R = zeros(6,1);
else
    R = zeros(size(hkls,1),1);
end

if(strcmp(type,'cubic'))
    for(i=1:size(hkls,1))
        R(i,1) = tth(i) - 2*asind(lam*sqrt(hkls(i,1)^2 + hkls(i,2)^2 + hkls(i,3)^2)/(2*x(1)));
    end
elseif(strcmp(type,'tetragonal'))
    for(i=1:size(hkls,1))
        R(i,1) = tth(i) - 2*asind((lam/2)*((hkls(i,1)+hkls(i,2))/x(1)^2 + hkls(i,3)/x(3)^2)^(-0.5));
    end
elseif(strcmp(type,'monoclinic'))
    for(i=1:size(hkls,1))
        R(i,1) = tth(i) - 2*asind(((1/(sind(x(5))^2))*(hkls(i,1)^2/x(1)^2 + hkls(i,2)^2*sind(x(5))^2/x(2)^2 + hkls(i,3)^2/x(3)^2 - 2*hkls(i,1)*hkls(i,3)*cosd(x(5))/(x(1)*x(3))))^(1/2) * lam/2);
    end
end
%NEED TO ADD OTHER GEOMETRY TYPES ONCE HKLS ARE AQUIRED