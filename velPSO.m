function [cfg] = velPSO(cfg,grid,vFieldx,vFieldy, uT, vT ,iter,ofval,vMax)
%VELPSO Particle swarm optimazation considering the vector field
vMap = labReceive(1);

awareness=0;
for i= 1:cfg.swarmSize
    
    % x(t+1)=v(t+1)+x(t)
    % with correction
    if(cfg.swarmV(i,1)>=grid.xMin &&cfg.swarmV(i,1)<=grid.xMax &&cfg.swarmV(i,2)>=grid.yMin &&cfg.swarmV(i,2)<=grid.yMax)
        %xCor=vMap(round(cfg.swarmV(i,2)+abs(grid.yMin)+1),round(cfg.swarmV(i,1)+abs(grid.xMin)+1),1);
        %yCor=vMap(round(cfg.swarmV(i,2)+abs(grid.yMin)+1),round(cfg.swarmV(i,1)+abs(grid.xMin)+1),2);       
        [xCor,yCor]=getVector(cfg.swarmV(i,1),cfg.swarmV(i,2),vMap(:,:,1),vMap(:,:,2),grid);
        if(xCor~=0 || yCor~=0)
           awareness=awareness+1; 
        end
    else
        xCor=0;
        yCor=0;
    end
    
    % Boundary handling. Particles exceeding the boundaries will be
    % repelled
    if((cfg.swarmV(i,1)+cfg.swarmV(i,5))<grid.xMin)
        cfg.swarmV(i,1)=cfg.swarmV(i,1)-cfg.swarmV(i,5);
    elseif((cfg.swarmV(i,1)+cfg.swarmV(i,5))>grid.xMax)
        cfg.swarmV(i,1)=cfg.swarmV(i,1)-cfg.swarmV(i,5);
    else
        cfg.swarmV(i,1) = cfg.swarmV(i,1)+cfg.swarmV(i,5)-xCor;
        cfg.swarmV(i,5)= cfg.swarmV(i,5) -xCor;
    end
    
    if((cfg.swarmV(i,2)+cfg.swarmV(i,6))<grid.yMin)
        cfg.swarmV(i,2) = cfg.swarmV(i,2)-cfg.swarmV(i,6);
    elseif((cfg.swarmV(i,2)+cfg.swarmV(i,6))>grid.yMax)
        cfg.swarmV(i,2) = cfg.swarmV(i,2)-cfg.swarmV(i,6);
    else
        cfg.swarmV(i,2) = cfg.swarmV(i,2)+cfg.swarmV(i,6)-yCor;
        cfg.swarmV(i,6)= cfg.swarmV(i,6) -yCor;
    end
    
    
    
    uVelo = cfg.swarmV(i,1);
    vVelo = cfg.swarmV(i,2);
    
    % Objective function
        if(ofval==1)
            valueVelo = (uVelo-uT)^2 + ( vVelo-vT)^2;
        end
        if(ofval==2)
            %aRos=1;bRos=100;
            valueVelo=1*(1-uVelo)^2 + 100*(vVelo-uVelo^2)^2;
        end
        if(ofval==3)
            %aAckley=20;bAckley=0.2;c=2*pi;
            valueVelo=-20*exp(-0.2*sqrt(uVelo^2+vVelo^2))-exp(1/2*(cos(2*pi*uVelo)+cos(2*pi*vVelo)))+20*exp(1);
        end
    if(valueVelo < cfg.swarmV(i,7))
        % update best pos u
        cfg.swarmV(i,3) = cfg.swarmV (i,1);
        % update best pos v
        cfg.swarmV(i,4) = cfg.swarmV (i,2);
        cfg.swarmV(i,7) = valueVelo;
    end
    
end

% tmp is the value and gbest the index of the globalbest
[tmpV, gbestVelo] = min(cfg.swarmV(:,7));
gbestsV(iter)=tmpV;
cfg.gBestPerI = tmpV;
cfg.awareness=awareness/cfg.swarmSize;
for i= 1:cfg.swarmSize
    % update v(t+1)
    if(cfg.swarmV(i,1) > grid.xMin && cfg.swarmV(i,1) <=grid.xMax && cfg.swarmV(i,2) > grid.yMin && cfg.swarmV(i,2) <=grid.yMax )
        [uV,vV]=getVector(cfg.swarmV(i,1),cfg.swarmV(i,2),vFieldx,vFieldy,grid);
    else
        uV=0;
        vV=0;
    end
    velX=rand*cfg.inertiaep*cfg.swarmV(i,5)+cfg.accelerationCoefficient*rand*(cfg.swarmV(i,3)...
        -cfg.swarmV(i,1))+cfg.accelerationCoefficient*rand*(cfg.swarmV(gbestVelo,3)-cfg.swarmV(i,1))+uV;
    velY=rand*cfg.inertiaep*cfg.swarmV(i,6)+cfg.accelerationCoefficient*rand*(cfg.swarmV(i,4)...
        -cfg.swarmV(i,2))+cfg.accelerationCoefficient*rand*(cfg.swarmV(gbestVelo,4)-cfg.swarmV(i,2))+vV;
    
    % regulate the max-velocity
    if(velX > vMax)
        cfg.swarmV(i,5) = vMax;
    else if(velX < -vMax)
            cfg.swarmV(i,5) = -vMax;
        else
            cfg.swarmV(i,5) = velX;
        end
    end
    
    if(velY > vMax)
        cfg.swarmV(i,6) = vMax;
    else if(velY < -vMax)
            cfg.swarmV(i,6) = -vMax;
        else
            cfg.swarmV(i,6) = velY;
        end
    end
end
%dedbug=cfg.swarmV
end





