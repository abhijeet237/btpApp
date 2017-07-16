% This is the main simulation program for phase-2 of sequential analysis

close all;	% close all the open windows
clear all;	% clear and delete all the existing variables

%Displaying the inputs mu = cell2mat(struct2cell(load('mu.mat'))); 
%filename = 'demo-input.xlsx';
filename = 'input.xlsx';
MEAN = xlsread(filename, 'mu')';
SIG = xlsread(filename, 'sigma')';
CELL_WEIGHTAGE = xlsread(filename, 'cell_weightage')';
CELL_COST = xlsread(filename, 'cell_cost')';
m = 2;
increment_factor = 1;
n=ones(1,length(CELL_WEIGHTAGE))* m;
%disp(n);	% Displaying n
A0=500;
A=[];
b=[];
Aeq=CELL_COST;
beq=A0;
lb=n;
ub=[];
options=optimoptions('fmincon');
options.Algorithm = 'interior-point';
options.Display = 'none';
options.MaxFunEvals = 1E5;
options.MaxIter = 1E5;
z_alpha = 1.96; %alpha=0.05
num_genes = length(MEAN(:,1));
num_cells = length(MEAN(1,:));

mu=MEAN;
sig=SIG;
c=CELL_WEIGHTAGE;
a=CELL_COST;

f = @(n)objective(n,mu,sig,c,a, z_alpha);

problem = createOptimProblem('fmincon','x0',n, 'objective',f, 'Aineq', A, 'bineq', b,'Aeq',Aeq,'beq',beq, 'lb',lb,'ub',ub, 'options', options, 'nonlcon',[]);
gs = GlobalSearch('Display','final');
[x,fval] = run(gs,problem);
%   ======================================  %
[optimal_theoritical_n, min_theoritical_objective] = fmincon(f, n, A, b, Aeq, beq, lb, ub, [], options);
%   ======================================  %
disp(optimal_theoritical_n);
%
disp(x)
disp(min_theoritical_objective);


disp(fval)