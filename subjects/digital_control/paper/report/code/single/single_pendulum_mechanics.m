function sys = single_pendulum_mechanics()
    % --- Plant parameters ---
    % Inertial
    syms m0 m1 real;
    I0 = zeros(3, 3);
    I1 = sym('I1_%d%d', [3, 3]);
   
    % Viscuous friction
    syms b0 b1 real;
          
    % Gravity
    syms g;
    gravity = [0; -g; 0];
    
    % Dimensional
    syms L1 L1_cg real; 
    
    % Extern excitations
    syms F;

    % Generalized variables
    syms x th1 real;
    syms xp  th1p real;
    syms xpp th1pp real;
    
    % Bodies
    % Car
    T0 = {T3d(0, [0, 0, 1].', [x; 0; 0])};
    L0cg = [0; 0; 0];
    
    car = build_body(m0, I0, b0, T0, L0cg, ...
                     x, xp, xpp, true, struct(''));

    % Bar 1
    T11 = car.T;
    T12 = T3d(-pi/2, [0, 0, 1].', [0; 0; 0]);
    T13 = T3d(th1, [0, 0, 1].', [0; 0; 0]);
    T1 = {T11, T12, T13};
    L1cg = [L1_cg; 0; 0];
    
    bar1 = build_body(m1, I1, b1, T1, L1cg, ...
                      th1, th1p, th1p, false, car);

    % System
    sys.bodies = {car, bar1};
    sys.gravity = gravity;
    sys.g = g;

    sys.q = [x; th1];
    sys.qp = [xp; th1p];
    sys.qpp = [xpp; th1pp];
    
    sys.Fq = [F; 0];
    sys.u = F;
    sys.y = [x; th1];
    
    sys.states = [sys.q; sys.qp];
    
    % System symbolics
    sys.syms = [g];
    sys.syms = [sys.syms, m0, b0];
    sys.syms = [sys.syms, m1, I1(3, 3), b1, L1, L1_cg];
    
    % Movement formalism
    sys = kinematic_model(sys);
    sys = dynamic_model(sys);
end