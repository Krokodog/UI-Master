function [cfgvMap] = createVectorMap(cfgvMap,grid,vx,vy,vMap)
%CREATEVECTORMAP Calculate a correction value for each cell visted by an
%individual
%----------------------------------------------
% column1: posx
% column2: posy
% column3: newposx
% column4: newposy
% column5: update xvel
% column6: update yvel

for i = 1:cfgvMap.searchSwarmSize
    
    % Remember old position
    cfgvMap.searchSwarm(i, 1) = cfgvMap.searchSwarm(i, 3);
    cfgvMap.searchSwarm(i, 2) = cfgvMap.searchSwarm(i, 4);
    
    % New position with wind
    cfgvMap.searchSwarm(i,3) = cfgvMap.searchSwarm(i,1)+cfgvMap.searchSwarm(i,5);
    cfgvMap.searchSwarm(i,4) = cfgvMap.searchSwarm(i,2)+cfgvMap.searchSwarm(i,6);
    
    if(cfgvMap.searchSwarm(i,3)<grid.xMin)
        cfgvMap.searchSwarm(i,3)=grid.xMin;
    end
    if(cfgvMap.searchSwarm(i,3)>grid.xMax)
        cfgvMap.searchSwarm(i,3)=grid.xMax;
    end
    if(cfgvMap.searchSwarm(i,4)<grid.yMin)
        cfgvMap.searchSwarm(i,4)=grid.yMin;
    end
    if(cfgvMap.searchSwarm(i,4)>grid.yMax)
        cfgvMap.searchSwarm(i,4)=grid.yMax;
    end
    
    % Check if particle is still in the defined grid after each
    % movement. Save the correction value in the vMap-matrix.
    if(cfgvMap.searchSwarm(i,3)>=grid.xMin &&cfgvMap.searchSwarm(i,3)<=grid.xMax &&cfgvMap.searchSwarm(i,4)>=grid.yMin &&cfgvMap.searchSwarm(i,4)<=grid.yMax)
        if(cfgvMap.vMapx(round(cfgvMap.searchSwarm(i,2)+(abs(grid.xMin))+1),round(cfgvMap.searchSwarm(i,1)+(abs(grid.xMin))+1))==0 && cfgvMap.vMapy(round(cfgvMap.searchSwarm(i,2)+(abs(grid.yMin))+1),round(cfgvMap.searchSwarm(i,1)+(abs(grid.yMin))+1))==0)
            cfgvMap.vMapx(round(cfgvMap.searchSwarm(i,2)+(abs(grid.xMin))+1),round(cfgvMap.searchSwarm(i,1)+(abs(grid.xMin))+1),1)= cfgvMap.searchSwarm(i,3)-cfgvMap.searchSwarm(i,1);
            cfgvMap.vMapy(round(cfgvMap.searchSwarm(i,2)+(abs(grid.xMin))+1),round(cfgvMap.searchSwarm(i,1)+(abs(grid.xMin))+1),1)= cfgvMap.searchSwarm(i,4)-cfgvMap.searchSwarm(i,2);
        end
    end
end


for i= 1:cfgvMap.searchSwarmSize
    
    % If an indivudual would exceed the boundary its velocity is set to
    % zero, else calculate the velocity at the position of the
    % individual
    if(cfgvMap.searchSwarm(i,3) > grid.xMin && cfgvMap.searchSwarm(i,3) <=grid.xMax && cfgvMap.searchSwarm(i,4) > grid.yMin && cfgvMap.searchSwarm(i,4) <=grid.yMax )
        [uV,vV]=getVector(cfgvMap.searchSwarm(i,3),cfgvMap.searchSwarm(i,4),vx,vy,grid);
    else
        uV=0;
        vV=0;
    end
    
    % Velocity update
    cfgvMap.searchSwarm(i,5) =uV;
    cfgvMap.searchSwarm(i,6) =vV;
    
end
vMap(:,:,1)=cfgvMap.vMapx(:,:,1);
vMap(:,:,2)=cfgvMap.vMapy(:,:,1);
labSend(vMap,2);
end




