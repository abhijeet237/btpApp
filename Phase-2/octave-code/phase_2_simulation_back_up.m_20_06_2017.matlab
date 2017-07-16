% This is the main simulation program for phase-2 of sequential analysis

close all;	% close all the open windows
clear all;	% clear and delete all the existing variables

cd ./sample_inputs;	% moving to smple_inputs diraectory where sample inputs files are stored

%loading the input data from sample input files

%mu = load('mu.mat'); 
%sig = load('sig.mat'); 
%c = load('cell_weightage.mat'); 
%a = load('cell_cost.mat');

load mu.mat;
load sig.mat;
load cell_weightage.mat;
load cell_cost.mat;

cd ./..;     % Going back to the parent folder from sample_inpust folder

%Displaying the inputs
disp(sprintf('Input Values used'));
disp(sprintf('========================================'));
disp(sprintf('mu'));
disp(mu)
disp(sprintf('sigma'));
disp(sig)
disp(sprintf('cell_weightage'));
disp(c)
disp(sprintf('cell_cost'));
disp(a)
A0=5000;
disp(sprintf('========================================'));
% Generating n vector with random initial values  
n=ceil(99*rand(1,length(c)));
disp(sprintf('initial_n'));
disp(n);	% Displaying n

% Computing delta and delta_0 using c and sig
delta = mu * c';
num_genes = length(sig(:,1));
z_alpha=1.96
disp(sprintf('delta'));
disp(delta);	% Displaying delta
disp(sprintf('delta_0'));
% Computing delta_o from delta (using random difference)
delta_0 = delta + ceil(50*rand(size(mu)(1),1));	%random value added for accepting the null hypothesis

disp(delta_0);	% Displaying delta_0

%[n ,SP_history] = gradientDescent(n, delta, delta_0, c, sig, (.05), 15000);

pdf_vector = [];
disp(z_alpha)
for j=1:num_genes
  pdf_vector(j)=normpdf(-z_alpha + (delta(j) .+ abs( delta_0(j) ) ) ./ (sum((c.^2) .* sig(j,:).^2 ./ n)));
end

sum(pdf_vector)

disp(linear_contraints(A0,a,n));

%% ============= Part 4: Visualizing J(theta_0, theta_1) =============
