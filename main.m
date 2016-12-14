clc
% Formular for a basic PSO
% x(t+1)=v(t+1)+x(t)
% v(t+1)=wv(t)+phi1(pi-xi)+phi2(pg-xi)
% w: inertia weight
% phi1(pi-xi): cognitive component
% phi2(pg-xi): social component

%-----------------------
% Information is saved in a matrix
% column1:objective function u
% column2:objective function v
% column3:update best position u
% column4:update best position v
% column5:update velocity u
% column6:update velocity v
% column7:best Value
%------------------------
GUI=1;
%configuration
%PSO variables GUI
if(GUI==1)
    
    iw1 = evalin('base', 'iw1');
    cfg.inertiaep =iw1;
    
    ac1 = evalin('base', 'ac1');
    cfg.accelerationCoefficient = ac1;
    
    psoSwarmSize = evalin('base', 'psoSwarmSize');
    cfg.swarmSize = psoSwarmSize;
    
    cfg.swarm= zeros(cfg.swarmSize,7);
    
    %Search swarm variables
    
    epSwarmSize = evalin('base', 'epSwarmSize');
    cfgvMap.searchSwarmSize = epSwarmSize;
    
    iterations  = evalin('base', 'psoIterations');
    vecval  = evalin('base', 'vecval');
    
    %TODO implement
    ofval  = evalin('base', 'ofval');
end

%Grid
grid.epsylon=1;
grid.xMin=-15;
grid.xMax=15;
grid.yMin=-15;
grid.yMax=15;

%Construct the grid
x=grid.xMin:grid.epsylon:grid.xMax;
y=grid.yMin:grid.epsylon:grid.yMax;
[x,y]=meshgrid(x,y);

% Change the coordinates of the objective function, should be between
% mingrid and maxgrid
uT=-10;
vT=13;

% Sphere Function
of=(x-uT).^2 + ( y-vT).^2;

%Normalized vector fields
switch vecval
    case 1
        vFieldx=y/max(abs(y(:)));
        vFieldy=x/max(abs(x(:)));
    case 2
        vFieldx=-y/max(abs(y(:)));
        vFieldy=x/max(abs(x(:)));
    case 3
        vFieldx=(x+y)/(max(abs(x(:)))+max(abs(y(:))));
        vFieldy=y/max(abs(y(:)));
    case 4
        vFieldx=-sin(y);
        vFieldy=cos(x*(y-x));
    case 5
        vFieldx=(-x-y)/(max(abs(x(:)))+max(abs(y(:))));
        vFieldy=x/max(abs(x(:)));
end


EgBests=zeros(iterations,1);
VgBests=zeros(iterations,1);
NgBests=zeros(iterations,1);

EcRate=zeros(iterations,1);
VcRate=zeros(iterations,1);
NcRate=zeros(iterations,1);


pArea=zeros(iterations,1);
its=(1:iterations).';

%-----------------Settings Explorer--------------------------------
vMap=zeros(abs(grid.xMin)+grid.xMax+1,abs(grid.yMin)+grid.yMax+1,1);
vMap=zeros(abs(grid.xMin)+grid.xMax+1,abs(grid.yMin)+grid.yMax+1,2);
cfgvMap.vMapx=vMap(:,:,1);
cfgvMap.vMapy=vMap(:,:,2);
cfgvMap.searchSwarm=zeros(cfgvMap.searchSwarmSize,8);

% Start position of each indiviual is randomly generated
for i=1:cfgvMap.searchSwarmSize
    cfgvMap.searchSwarm(i, 1) = randi([grid.xMin,grid.xMax]);
    cfgvMap.searchSwarm(i, 2) = randi([grid.xMin,grid.xMax]);
    cfgvMap.searchSwarm(i, 3) = cfgvMap.searchSwarm(i, 1);
    cfgvMap.searchSwarm(i, 4) = cfgvMap.searchSwarm(i, 2);
end
%------------------------------------------------------------------

%-----------------Settings PSO-------------------------------------
% Initialize the positions of the individuals
iter=1;
for i = 1:cfg.swarmSize
    cfg.swarm(i, 1:7) = randi([grid.xMin,grid.xMax]);
end
% initial velocity u
cfg.swarm(:, 5)=0;
% initial velocity v
cfg.swarm(:, 6)=0;
cfg.swarm(:, 7)=1000000;
Ecfg=cfg;
Ncfg=cfg;
Ecfg.swarmV = cfg.swarm;
Ncfg.swarmN = cfg.swarm;
%------------------------------------------------------------------

%PARALLEL
addxy=zeros((abs(grid.xMin)+grid.xMax+1),(abs(grid.yMin)+grid.yMax+1));
axis(handles.axes2,[1 iterations 0 100])
c = Composite();

for i=1:iterations
    FLAG = getappdata(0,'FLAG');
    while FLAG
        drawnow;
        FLAG = getappdata(0,'FLAG');
    end
    spmd
        labBarrier
        %c=funList{labindex}();
        if(labindex==1)
            c=createVectorMap(cfgvMap,grid,vFieldx,vFieldy,vMap);
        end
        if(labindex==2)
            c=velPSO(Ecfg,grid,vFieldx,vFieldy,uT,vT,iter,ofval);
        end
        if(labindex==3)
            c=nPSO(cfg,grid,vFieldx,vFieldy,uT,vT,iter,ofval);
        end
        if(labindex==4)
            c=PSO(Ncfg,grid,uT,vT,iter,ofval);
        end
    end
    cfgvMap=c{1};
    Ecfg=c{2};
    cfg=c{3};
    Ncfg=c{4};
    
    %wqe=vcfg.swarmV
    cla(handles.axes1,'reset');
    cla(handles.axes5,'reset');
   
    
    a=cfgvMap.vMapx(:,:,1);
    b=cfgvMap.vMapy(:,:,1);
    a=a.^2;
    b=b.^2;
    addxy=(a+b)/2;
    myColorMap = jet;
    myColorMap(1, :) = [1 1 1];
    caxis([0 1])
    colormap(myColorMap)
    imagesc([grid.xMin grid.xMax], [grid.yMin grid.yMax], addxy,'Parent',handles.axes1)
    hold on
    % vPSO visualization
    quiverPlot=quiver(x,y,vFieldx,vFieldy,'color',[1 0 1]);
    set(quiverPlot,'Parent', handles.axes1)
    swarmVPlot=plot(Ecfg.swarmV(:,1),Ecfg.swarmV(:,2),'ko');
    set(swarmVPlot,'Parent', handles.axes1)
    colorbar(handles.axes1)
    set(handles.axes1, 'YDir', 'normal')
    hold off
    xlabel(handles.axes1,'x-Values')
    ylabel(handles.axes1,'y-Values')   
    
    % nPSO
    myColorMap2 = gray;
    myColorMap2(1, :) = [1 1 1];
    caxis([0 1])
    colormap(handles.axes5,myColorMap2)
    baba=nan(size(addxy,1));
    imagesc([grid.xMin grid.xMax], [grid.yMin grid.yMax], baba,'Parent',handles.axes5)
    hold on
    quiverPlot=quiver(x,y,vFieldx,vFieldy,'color',[1 0 1]);
    set(quiverPlot,'Parent', handles.axes5)
    
    swarmPlot=plot(cfg.swarm(:,1),cfg.swarm(:,2),'ro');
    set(swarmPlot,'Parent', handles.axes5)
    swarm2VPlot=plot(Ecfg.swarmV(:,1),Ecfg.swarmV(:,2),'ko');
    set(swarm2VPlot,'Parent', handles.axes5)
    
    swarmNPlot=plot(Ncfg.swarmN(:,1),Ncfg.swarmN(:,2),'bo');
    set(swarmNPlot,'Parent', handles.axes5)
     
    colorbar(handles.axes5,'visibility','off')
    set(handles.axes5, 'YDir', 'normal')
    xlabel(handles.axes5,'x-Values')
    ylabel(handles.axes5,'y-Values')   
    
    
    %                 % movement of the explorer swarm
    %                 p2=plot(cfgvMap.searchSwarm(:,1),cfgvMap.searchSwarm(:,2),'ro');
    %                 set(p2,'Parent', handles.axes2)
    %                 p3=plot(cfgvMap.searchSwarm(:,3),cfgvMap.searchSwarm(:,4),'gx');
    %                 set(p3,'Parent', handles.axes2)
    %                 q2=quiver(x,y,vFieldx,vFieldy);
    %                 set(q2,'Parent', handles.axes2)
    
    % global best per iteration
    EgBests(i,1)=Ecfg.gBestPerI;
    VgBests(i,1)=cfg.ngBestPerI;
    NgBests(i,1)=Ncfg.ngBestPerI;
    
    hold on
    EgBestPlot=plot(1:i,EgBests(1:i),'k.');
    VgBestPlot=plot(1:i,VgBests(1:i),'r.');
    NgBestPlot=plot(1:i,NgBests(1:i),'b.');
    set(EgBestPlot,'Parent', handles.axes4)
    set(VgBestPlot,'Parent', handles.axes4)
    set(NgBestPlot,'Parent', handles.axes4)
    legend({'EPSO','VPSO','PSO'})
    hold off
    xlabel(handles.axes4,'Iteration')
    ylabel(handles.axes4,'Best found solution')

    %convergence rate
    sigmasq = 0;
    sigmasq2 = 0;
    sigmasq3 = 0;
    N=Ecfg.swarmSize;
    favg=sum(Ecfg.swarmV(:,7))/N;
    N2=cfg.swarmSize;
    favg2=sum(cfg.swarm(:,7))/N2;
    N3=Ncfg.swarmSize;
    favg3=sum(Ncfg.swarmN(:,7))/N3;
    for iparticle= 1:N
        fi = Ecfg.swarmV(iparticle,7);
        fitness =max(1,max(abs(fi-favg)));
        sigmsq = sigmasq + ( (fi-favg)/fitness)^2;
        
        fi2 = cfg.swarm(iparticle,7);
        fitness2 =max(1,max(abs(fi2-favg2)));
        sigmsq2 = sigmasq2 + ( (fi2-favg2)/fitness2)^2;
        
        fi3 = Ncfg.swarmN(iparticle,7);
        fitness3 =max(1,max(abs(fi3-favg3)));
        sigmsq3 = sigmasq3 + ( (fi3-favg3)/fitness3)^2;
    end
    sigmsq=sigmsq/N;
    sigmsq2=sigmsq2/N2;
    sigmsq3=sigmsq3/N3;
    EcRate(i)=sigmsq;
    VcRate(i)=sigmsq2;
    NcRate(i)=sigmsq3;
    hold on
    EconvergencePlot=plot(i,sigmsq,'k.');
    VconvergencePlot=plot(i,sigmsq2,'r.');
    NconvergencePlot=plot(i,sigmsq3,'b.');
    
    set(EconvergencePlot,'Parent', handles.axes3)
    set(VconvergencePlot,'Parent', handles.axes3)
    set(NconvergencePlot,'Parent', handles.axes3)
    hold off
    
    xlabel(handles.axes3,'Iteration')
    ylabel(handles.axes3,'\sigma^2')
    
    % information collected
    areaSize = size(addxy,1)*size(addxy,2);
    exploredArea =nnz(addxy);
    exploredPerc = exploredArea/areaSize*100 ;
    pArea(i)=exploredPerc;
    hold on
    exploredPercPlot=plot(i,exploredPerc,'k.');
    set(exploredPercPlot,'Parent', handles.axes2)
    hold off
    xlabel(handles.axes2,'Iteration')
    ylabel(handles.axes2,{'Explored area','(in %)'})
    
    %%swarmdbug=cfg.swarmV
    pause(0.1);
    
end
hold on
set(plot(1:iterations,VcRate(1:iterations),'r'),'Parent', handles.axes3)
set(plot(1:iterations,NcRate(1:iterations),'b'),'Parent', handles.axes3)
set(plot(1:iterations,EcRate(1:iterations),'k'),'Parent', handles.axes3)
set(plot(1:iterations,pArea(1:iterations),'k'),'Parent', handles.axes2)

set(plot(1:iterations,EgBests(1:iterations),'k'),'Parent', handles.axes4)
set(plot(1:iterations,VgBests(1:iterations),'r'),'Parent', handles.axes4)
set(plot(1:iterations,NgBests(1:iterations),'b'),'Parent', handles.axes4)
hold off
xlabel(handles.axes4,'Iteration')
ylabel(handles.axes4,'Best found solution')

disp('FINISHED')
