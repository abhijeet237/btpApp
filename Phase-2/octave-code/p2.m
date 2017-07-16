% This is the main simulation program for phase-2 of sequential analysis

close all;	% close all the open windows
clear all;	% clear and delete all the existing variables

%Displaying the inputs mu = cell2mat(struct2cell(load('mu.mat'))); 
%filename = 'demo-input-2.xlsx';
%filename = 'input-3-2.xlsx';
%filename = 'input-10-10.xlsx';
%filename = 'input.xlsx';
filename = 'self-made.xlsx'
MEAN = xlsread(filename, 'mu')';
SIG = xlsread(filename, 'sigma')';
CELL_WEIGHTAGE = xlsread(filename, 'cell_weightage')';
CELL_COST = xlsread(filename, 'cell_cost')';
startoff_sample_num = 2;
m = startoff_sample_num - 1;
%disp(n);	% Displaying n
A0=5000;
increment_factor = 1;
n=ones(1,length(CELL_WEIGHTAGE))* m;
A=[];
b=[];
Aeq=CELL_COST;
%Aeq=[];
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
num_genes = length(MEAN(:,1));
num_cells = length(MEAN(1,:));
z=zeros(0,0);
mu=MEAN;
sig=SIG;
c=CELL_WEIGHTAGE;
a=CELL_COST;
delta_star_epsilon = .1 
delta_0_epsilon = .2
[delta_star, delta_0] = delta_calculation(c,mu,delta_star_epsilon,delta_0_epsilon)
SP=[];
N=n;
NN=[]
opt=[]
%   ======================================  %
[optimal_theoritical_n, min_theoritical_objective] = fmincon(@objective, N, A, b, Aeq, beq, lb, ub, [], options, sig, c,z_alpha, delta_star, delta_0);
%   ======================================  %
%disp(optimal_theoritical_n);
%disp(min_theoritical_objective);

state = zeros(1,num_cells);

%disp(state)

%temp = normrnd(MEAN,SIG, num_genes, num_cells);

for i=1:num_genes
    for j=1:num_cells
        temp(i,j)=normrnd(MEAN(i,j),SIG(i,j));
    end
end

data = temp;

sample_mean = zeros(num_genes, num_cells);
sample_std = zeros(num_genes, num_cells);

% Collecting samples from each cell using state info

%bool=1;
while(sum(state)<num_cells)
% while(bool<92)
    %disp(sum(state))   
    
    for gene_index = 1:num_genes
       for cell_index = 1:num_cells
           if(state(cell_index)==0)
               sample_mean(gene_index,cell_index) = mean(data(gene_index,cell_index,:));
               sample_std(gene_index,cell_index) = std(data(gene_index,cell_index,:));
           end    
       end
    end    
    
    %disp(sample_mean)
    %disp(sample_std)
    mu=sample_mean;
    sig=sample_std;  
    disp('NNNNNNNNNNNNNNNNNNNNNnn')
    disp(N)
    [mu, sig, C, Aeq, n, beq, X] = update_parameters(state, mu, sample_std, c, a, N, A0);
    disp(n)
    lb=n;
    
%   ==============PRACTICAL===============  %
[optimal_practical_n, min_practical_objective] = fmincon(@objective, n, A, b, Aeq, beq, lb, ub, [], options, sig, C ,z_alpha, delta_star, delta_0);
%   ======================================  %

%disp([optimal_practical_n, min_practical_objective])
   
%disp(N);
%disp(n);
%disp(optimal_practical_n);
disp('X')
disp(X)

    for index = 1:length(X)   
    %for cell_index = 1:num_cells   
        %if((n(cell_index)>=floor(optimal_practical_n(cell_index))) & (state(cell_index)==0))
        if((N(X(index))>=floor(optimal_practical_n(index))))
        %if((N(X(index))>=optimal_practical_n(index)))
            state(X(index))=1;
        end
    end    

%disp(state)

    for cell_index = 1:num_cells
        counter=1;    
        if (state(cell_index)==0)
            
            disp(N);
            
            while(counter<=increment_factor)
                
                data(:,cell_index,N(cell_index))= normrnd(MEAN(:,cell_index),SIG(:,cell_index), num_genes, 1);
                N(cell_index) = N(cell_index) + 1;
                counter = counter + 1;
            end    
            sprintf('Optimal value not found for cell:%d ', cell_index);
            
       % else
        %    sprintf('Optimal value found for cell:%d ', cell_index);
        end
 
    end
    
    %SP = [SP ;min_practical_objective]
    NN= [NN ;n];
    %opt=[opt ; optimal_practical_n]
    disp(optimal_theoritical_n)
  disp(optimal_practical_n)
  disp(N)
disp(n)
disp(state)
disp(beq)
disp(a*N');

    

z=[z,min_practical_objective];
lb=n;
    %sprintf('n:%d', n);
%bool=bool + 1;
end    

%plot(N,SP)
    