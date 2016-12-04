function [u,v] = getVector(x,y,vFieldx,vFieldy,grid)
%GETVECTOR Calculate the precise velocity vector, using interpolation
%   x and y coordinates of the individual
%   vFieldx and vFieldy velocity fields in x- and y-direction

u=0;
v=0;


% Boundary handling
if(x < grid.xMin+1)
    x=grid.xMin;
end
if(x > grid.xMax)
    x=grid.xMax;
end
if(y < grid.yMin+1)
    y=grid.yMin;
end
if(y > grid.yMax)
    y=grid.yMax;
end

% Grid points
p00=[floor(x),floor(y)];
p10=[ceil(x),floor(y)];
p01=[floor(x),ceil(y)];
p11=[ceil(x),ceil(y)];

vSize=size(vFieldx,1);
shift=abs(grid.xMin);

% Velocity at grid points
v1=[vFieldx(p00(2)+shift+1,(shift+p00(1)+1)),vFieldy(p00(2)+shift+1,(shift+p00(1)+1))];
v2=[vFieldx(p01(2)+shift+1,(shift+p01(1)+1)),vFieldy(p01(2)+shift+1,(shift+p01(1)+1))];
v3=[vFieldx(p10(2)+shift+1,(shift+p10(1)+1)),vFieldy(p10(2)+shift+1,(shift+p10(1)+1))];
v4=[vFieldx(p11(2)+shift+1,(shift+p11(1)+1)),vFieldy(p11(2)+shift+1,(shift+p11(1)+1))];

% There are three cases:
% 1. On 1 gridpoint
% 2. Between 2 gridpoints
% 3. In a cell of 4 gridpoints
% Use interpolation v=(1-t)*p1+t*p2 , t e[0,1]

% rem = remainder, get the grid vertices
fractX=rem(x,1);
fractY=rem(y,1);

% Case 1
if fractX == 0 && fractY==0
    u = vFieldx((abs(grid.xMin)+x+1),x+abs(grid.xMin)+1);
    v = vFieldy((abs(grid.yMin)+y+1),y+abs(grid.yMin)+1);
end

% Case 2 in x-direction
if fractX ~= 0 && fractY==0
    if((p00(2)-y)==0)
        interpVal=(1-fractX)*v1+fractX*v3;
    else
        interpVal=(1-fractX)*v2+fractX*v4;
    end
    u=interpVal(1);
    v=interpVal(2);
end

% Case 2 in y-direction
if fractX == 0 && fractY~=0
    if((p00(1)-x)==0)
        interpVal=(1-fractY)*v1+fractY*v3;
    else
        interpVal=(1-fractY)*v2+fractY*v4;
    end
    u=interpVal(1);
    v=interpVal(2);
end

% Case 3
if fractX ~= 0 && fractY~=0
    
    %Interpolation in x direction
    vX0=(1-fractX)*v1+fractX*v3;
    vX1=(1-fractX)*v2+fractX*v4;
    
    %Interpolation in y direction
    vXY=(1-fractY)*vX0+fractY*vX1;
    
    u=vXY(1);
    v=vXY(2);
end

end

