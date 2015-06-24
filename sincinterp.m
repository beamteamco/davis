function   [out] = sincinterp(X, interpFactor,dimension)

flipped = 0;
if(size(X,2)>1)
    X=X';
    flipped = 1;
end

if(dimension==1)
    t=0:1/interpFactor:length(X)-1/interpFactor;
    sPeriod = 1;
%     out = zeros(length(X)*interpFactor,1);    
    
    i2 = [1:length(X)]'*ones(1,length(t));
    t2 = (t'*ones(1,length(X)))';
    
    kernel = sinc((t2-i2*sPeriod)/sPeriod);

    out = X'*(kernel);
%     for j=1:length(t)    
%         for i=1:1:length(X)
%             if(i==0)
%                 out(j,1) = X(i,1)*sinc((t(j)-(i)*sPeriod)/sPeriod); 
%             else
%                 out(j,1) = out(j,1) + X(i,1)*sinc((t(j)-(i)*sPeriod)/sPeriod); 
%             end        
%         end
%     end
elseif(dimension==2)
else
    disp('Dimension number not supported');
end

if(flipped == 1)
   out = out';
end