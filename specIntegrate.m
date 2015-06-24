function [area] = specIntegrate(X,scale,a,b)

interv = scale/(length(X)-1);
% disp(interv)

%index values of a & b
sa = a/interv; 
sb = b/interv;

% disp('sa,sb')
% disp(sa)
% disp(sb)

%slope values of inebtween points if a&b indexes are non integer
aA = 0;
aB = 0;


if(mod(sa,1)~=0)
    ma = (X(floor(sa)+2)-X(floor(sa)+1))/interv;
    dya = ma*mod(sa,1);
    aA = (interv*(X(floor(sa)+1))+0.5*interv*(X(floor(sa)+2)-X(floor(sa)+1))) - (mod(sa,1)*X(floor(sa)+1)+0.5*mod(sa,1)*dya);
end
if(mod(sb,1)~=0)
    mb = (X(floor(sb)+2)-X(floor(sb)+1))/interv;
    dyb = mb*mod(sb,1);
    aB = mod(sb,1)*(X(floor(sb)+1))+0.5*mod(sb,1)*dyb;
end
% disp('aA,aB');
% disp(aA);
% disp(aB);

area=0;
if((floor(sb)-ceil(sa))~=0)
    for(i=1:(floor(sb)-ceil(sa)))
        area=area+interv*X(ceil(sa)+i)+0.5*interv*(X(ceil(sa)+1+i)-X(ceil(sa)+i));
    end
end
% disp('area (pre)');
% disp(area);

area = area + aA + aB;