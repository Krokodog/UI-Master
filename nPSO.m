function [cfg] = nPSO(cfg,grid,vFieldx,vFieldy, uT, vT,iter)
%NORMALPSO Particle swarm optimazation

vMax=2;
for i= 1:cfg.swarmSize
    %x(t+1)=v(t+1)+x(t)
    % Boundary handling. Particles exceeding the boundaries will be
    % repelled
    if((cfg.swarm(i,1)+cfg.swarm(i,5))<grid.xMin)
        cfg.swarm(i,1)=cfg.swarm(i,1)-cfg.swarm(i,5);
    elseif((cfg.swarm(i,1)+cfg.swarm(i,5))>grid.xMax)
        cfg.swarm(i,1)=cfg.swarm(i,1)-cfg.swarm(i,5);
    else
        cfg.swarm(i,1) = cfg.swarm(i,1)+cfg.swarm(i,5);
    end
    
    if((cfg.swarm(i,2)+cfg.swarm(i,6))<grid.yMin)
        cfg.swarm(i,2) = cfg.swarm(i,2)-cfg.swarm(i,6);
    elseif((cfg.swarm(i,2)+cfg.swarm(i,6))>grid.yMax)
        cfg.swarm(i,2) = cfg.swarm(i,2)-cfg.swarm(i,6);
    else
        cfg.swarm(i,2) = cfg.swarm(i,2)+cfg.swarm(i,6);
    end
    
    u = cfg.swarm(i,1);
    v = cfg.swarm(i,2);
    % Objective function
    value = (u-uT)^2 + ( v-vT)^2;
    if(value < cfg.swarm(i,7))
        %update best pos u
        cfg.swarm(i,3) = cfg.swarm (i,1);
        %update best pos v
        cfg.swarm(i,4) = cfg.swarm (i,2);
        cfg.swarm(i,7) = value;
    end
end

%tmp is the value and gbest the index of the globalbest
[tmp, gbest] = min(cfg.swarm(:,7));
gbests(iter)=tmp;
cfg.ngBestPerI = tmp;
for i= 1:cfg.swarmSize
    if(cfg.swarm(i,1) > grid.xMin && cfg.swarm(i,1) <=grid.xMax && cfg.swarm(i,2) > grid.yMin && cfg.swarm(i,2) <=grid.yMax )
        [uV,vV]=getVector(cfg.swarm(i,1),cfg.swarm(i,2),vFieldx,vFieldy,grid);
    else
        uV=0;
        vV=0;
    end
    
    %Update v(t+1)
    velX= rand*cfg.inertiaep*cfg.swarm(i,5)+cfg.accelerationCoefficient*rand*(cfg.swarm(i,3)...
        -cfg.swarm(i,1))+cfg.accelerationCoefficient*rand*(cfg.swarm(gbest,3)-cfg.swarm(i,1))+uV;
    velY= rand*cfg.inertiaep*cfg.swarm(i,6)+cfg.accelerationCoefficient*rand*(cfg.swarm(i,4)...
        -cfg.swarm(i,2))+cfg.accelerationCoefficient*rand*(cfg.swarm(gbest,4)-cfg.swarm(i,2))+vV;
    
     % regulate the max-velocity
    if(velX > vMax)
        cfg.swarm(i,5) = vMax;
    else if(velX < -vMax)
            cfg.swarm(i,5) = -vMax;
        else
            cfg.swarm(i,5) = velX;
        end
    end
    
    if(velY > vMax)
        cfg.swarm(i,6) = vMax;
    else if(velY < -vMax)
            cfg.swarm(i,6) = -vMax;
        else
            cfg.swarm(i,6) = velY;
        end
    end
end


end


