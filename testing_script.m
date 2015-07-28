x = [1,0,0]';
jj=1;
th = 20;
eta = 0:360/72:360;
eta = eta;
ome = -62.5:5:62.5;

figure
quiver3(0,0,0,x(1),x(2),x(3),'g');
hold on

R_th    = [ ...
        cosd(th(jj)) 0 sind(th(jj)); ...
        0 1 0; ...
        -sind(th(jj)) 0 cosd(th(jj)); ...
        ];
    q0  = R_th*x;
    
q_eta   = zeros(3,length(eta));

quiver3(0,0,0,q0(1),q0(2),q0(3),'b');

for i = 1:length(eta)
    %z-axis rotation
    R_eta   = [ ...
        cosd(eta(i)) -sind(eta(i)) 0; ...
        sind(eta(i)) cosd(eta(i)) 0; ...
        0 0 1]';
    q_eta(:,i)  = R_eta*q0;
    quiver3(0,0,0,q_eta(1,i),q_eta(2,i),q_eta(3,i),'r');
end

for i = 1:1:length(ome)
        %y-axis rotation
        R_ome   = [ ...
            cosd(ome(i)) 0 sind(ome(i)); ...
            0 1 0; ...
            -sind(ome(i)) 0 cosd(ome(i)); ...
            ];
        q_ome	= R_ome*q_eta;

        if(i==13)
            for(oo=1:size(q_eta,2))
                if(oo==1)
                    quiver3(0,0,0,2*q_ome(1,oo),2*q_ome(2,oo),2*q_ome(3,oo),'k')
                else
                    quiver3(0,0,0,q_ome(1,oo),q_ome(2,oo),q_ome(3,oo),'k')
                end
            end
        end
        
        ini = 1 + length(eta) * (i - 1);
        fin = length(eta) * i;
        q_pf(ini:fin,:,jj)  = q_ome';

end
    

R_th2    = [cosd(th(jj)), 0, sind(th(jj)); ...
        0, 1, 0; ...
        sind(th(jj)), 0, cosd(th(jj))];
q02  = 2*R_th2*x;
   
quiver3(0,0,0,q02(1),q02(2),q02(3),'b');