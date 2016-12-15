function [ncfg] = PSO(ncfg,grid, uT, vT,iter,ofval,vMax)
%PSO Particle swarm optimazation


for i= 1:ncfg.swarmSize
    %x(t+1)=v(t+1)+x(t)
    % Boundary handling. Particles exceeding the boundaries will be
    % repelled
    if((ncfg.swarmN(i,1)+ncfg.swarmN(i,5))<grid.xMin)
        ncfg.swarmN(i,1)=ncfg.swarmN(i,1)-ncfg.swarmN(i,5);
    elseif((ncfg.swarmN(i,1)+ncfg.swarmN(i,5))>grid.xMax)
        ncfg.swarmN(i,1)=ncfg.swarmN(i,1)-ncfg.swarmN(i,5);
    else
        ncfg.swarmN(i,1) = ncfg.swarmN(i,1)+ncfg.swarmN(i,5);
    end
    
    if((ncfg.swarmN(i,2)+ncfg.swarmN(i,6))<grid.yMin)
        ncfg.swarmN(i,2) = ncfg.swarmN(i,2)-ncfg.swarmN(i,6);
    elseif((ncfg.swarmN(i,2)+ncfg.swarmN(i,6))>grid.yMax)
        ncfg.swarmN(i,2) = ncfg.swarmN(i,2)-ncfg.swarmN(i,6);
    else
        ncfg.swarmN(i,2) = ncfg.swarmN(i,2)+ncfg.swarmN(i,6);
    end
    
    u = ncfg.swarmN(i,1);
    v = ncfg.swarmN(i,2);
       % Objective function
    if(ofval==1)
        value = (u-uT)^2 + ( v-vT)^2;
    end
    if(ofval==2)
        %aRos=1;bRos=100;
        value=1*(1-u)^2 + 100*(v-u^2)^2;
    end
    if(ofval==3)
        %aAckley=20;bAckley=0.2;c=2*pi;
        value=-20*exp(-0.2*sqrt(u^2+v^2))-exp(1/2*(cos(2*pi*u)+cos(2*pi*v)))+20*exp(1);
    end
    if(value < ncfg.swarmN(i,7))
        %update best pos u
        ncfg.swarmN(i,3) = ncfg.swarmN (i,1);
        %update best pos v
        ncfg.swarmN(i,4) = ncfg.swarmN (i,2);
        ncfg.swarmN(i,7) = value;
    end
end

%tmp is the value and gbest the index of the globalbest
[tmp, gbest] = min(ncfg.swarmN(:,7));
gbestsN(iter)=tmp;
ncfg.ngBestPerI = tmp;
for i= 1:ncfg.swarmSize

    %Update v(t+1)
    velX= rand*ncfg.inertiaep*ncfg.swarmN(i,5)+ncfg.accelerationCoefficient*rand*(ncfg.swarmN(i,3)...
        -ncfg.swarmN(i,1))+ncfg.accelerationCoefficient*rand*(ncfg.swarmN(gbest,3)-ncfg.swarmN(i,1));
    velY= rand*ncfg.inertiaep*ncfg.swarmN(i,6)+ncfg.accelerationCoefficient*rand*(ncfg.swarmN(i,4)...
        -ncfg.swarmN(i,2))+ncfg.accelerationCoefficient*rand*(ncfg.swarmN(gbest,4)-ncfg.swarmN(i,2));
    
     % regulate the max-velocity
    if(velX > vMax)
        ncfg.swarmN(i,5) = vMax;
    else if(velX < -vMax)
            ncfg.swarmN(i,5) = -vMax;
        else
            ncfg.swarmN(i,5) = velX;
        end
    end
    
    if(velY > vMax)
        ncfg.swarmN(i,6) = vMax;
    else if(velY < -vMax)
            ncfg.swarmN(i,6) = -vMax;
        else
            ncfg.swarmN(i,6) = velY;
        end
    end
end


end




