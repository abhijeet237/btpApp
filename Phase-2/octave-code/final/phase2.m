% This is the main simulation program for phase-2 of sequential analysis

close all;	% close all the open windows
clear all;	% clear and delete all the existing variables

filename = 'self-made.xlsx'

MEAN = xlsread(filename, 'mu');
SIG = xlsread(filename, 'sigma');
CELL_WEIGHTAGE = xlsread(filename, 'cell_weightage')';
CELL_COST = xlsread(filename, 'cell_cost')';

[num_cells, num_genes] = size(MEAN);

delta_star_epsilon = 0.01; 
delta_0_epsilon = 0.02;

[delta_star, delta_0] = delta_calculation(CELL_WEIGHTAGE,MEAN,delta_star_epsilon, delta_0_epsilon);

A0=5000;
%increment_factor = 1;
startoff_sample_num = 2;

m = startoff_sample_num - 1;
n=ones(1,length(CELL_WEIGHTAGE))* m;
A=[];
b=[];
Aeq=CELL_COST;
beq=A0;
%beq=[];
lb=n;
ub=[];
options=optimoptions('fmincon');
options.Algorithm = 'sqp';
options.Display = 'final';
options.MaxFunEvals = 1E5;
options.MaxIter = 1E10;
z_alpha = 1.96; %alpha=0.05

%   ======================================  %
[optimal_theoritical_n, min_theoritical_objective] = fmincon(@objective, n, A, b, Aeq, beq, lb, ub, [], options, SIG, CELL_WEIGHTAGE,z_alpha, delta_star, delta_0);
%   ======================================  %
disp(optimal_theoritical_n);
disp(min_theoritical_objective);

state = zeros(num_cells,1);





