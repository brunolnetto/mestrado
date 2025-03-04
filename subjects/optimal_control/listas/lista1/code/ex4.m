
% @Author: Bruno Peixoto
% Exercicio 4 - Lista 1 
% Disciplina: PME5205

clear all;
close all;
clc;

syms P1 P2 P3 L lambda epsilon;

assume(epsilon > 0);

% Custos nominais
C1 = 1 - P1 + P1^2;
C2 = 0.75 + 0.5*P2 + 0.5*P2^2;
C3 = 1 + 0.5*P3 + P3^2;

% Custo total
C = C1 + C2 + C3;

% Condicao de igualdade
cond = P1 + P2 + P3 - L;

% Multiplicadores de Lagrange
Ctilde = C + lambda*cond;

diffC_P1 = diff(Ctilde, P1);
diffC_P2 = diff(Ctilde, P2);
diffC_P3 = diff(Ctilde, P3);
diffC_lambda = diff(Ctilde, lambda);

sol = solve(diffC_P1 == 0, diffC_P2 == 0, ...
            diffC_P3 == 0,diffC_lambda == 0, ...
            P1, P2, P3, lambda, 'ReturnConditions', true);

P = [sol.P1, sol.P2, sol.P3, sol.lambda];
Peps =  P + epsilon;
Ctilde_eps = subs(Ctilde, [P1, P2, P3, lambda], Peps);
Ctilde_sol = subs(Ctilde, [P1, P2, P3, lambda], P);

% Se DC e' maior que 0, para todo epsilon, entao e' um ponto de minimo.
% Se for menor que 0, e' de maximo. Se for 0, e' inconclusivo
DC = simplify(Ctilde_eps - Ctilde_sol)



