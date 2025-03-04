close all;

mdlname = 'LC_VSI_filter';

open_system(mdlname);
set_param(mdlname, 'SaveOutput', 'on');

simOut = sim('LC_VSI_filter', 'StopTime', num2str(0.1), ...
             'SrcWorkspace', 'current', ...
             'AbsTol', '1e-10', ...
             'RelTol', '1e-10');
% Line signal
% Noise
% I
% V
% pwm
% Saturated PWM

x = simOut.get('x');
xhat = simOut.get('xhat');
noise = simOut.get('noise');
line_signal = simOut.get('line_signal');
time = simOut.get('time');

noise = [time, noise];
line_signal = [time, line_signal];

x = [time x(:, 1) x(:,2)];
xtilde = [time xhat(:, 1:2)];
wtilde = xhat(:, 3:end);

line_tilde = [time wtilde(:, 1)];
noise_tilde = [time sum(wtilde(:, 2:end)')'];

% States
hfig = figure('units','normalized', ...
              'outerposition', [0 0 1 1], ...
              'PaperPositionMode', 'auto');
         
subplot(2, 1, 1)
plot(x(:, 1), x(:, 2))
hold on
plot(xtilde(:, 1), xtilde(:, 2))
hold off

title('Filter current','Interpreter','latex')          
xlabel('Time [s]','Interpreter','latex');
ylabel('Amplitude [A]','Interpreter','latex');
legend({'$i_f$', '$\tilde{i}_f$'}, ...
        'Location','best','Interpreter','latex')

subplot(2, 1, 2)
plot(x(:, 1), x(:, 3))
hold on
plot(xtilde(:, 1), xtilde(:, 3))
hold off

title('Capacitor voltage','Interpreter','latex')          
xlabel('Time [s]','Interpreter','latex');
ylabel('Amplitude [V]','Interpreter','latex');
legend({'$v_c$', '$\tilde{v}_c$'}, ...
        'Location','best','Interpreter','latex')

% Harmonic components
hfig = figure('units','normalized', ...
              'outerposition', [0 0 1 1], ...
              'PaperPositionMode', 'auto');

subplot(2, 1, 1)
plot(line_tilde(:, 1), line_tilde(:, 2))
hold on
plot(line_signal(:, 1), line_signal(:, 2))
hold off

xlabel('Time [s]','Interpreter','latex');
ylabel('Amplitude [V]','Interpreter','latex');

legend({'$\tilde{u}(t)$', '$u(t)$'}, ...
        'Location','best','Interpreter','latex')

subplot(2, 1, 2)
plot(noise_tilde(:, 1), noise_tilde(:, 2))
hold on
plot(noise(:, 1), noise(:, 2))
hold off

title('Harmonic noise prediction','Interpreter','latex')

xlabel('$Time [s]$','Interpreter','latex');
ylabel('Amplitude [V]','Interpreter','latex');

legend({'$\mathbf{\tilde{w}}$', '$\mathbf{w}$'}, ...
        'Location','best','Interpreter','latex')
