% This is the main simulation program for phase-2 of sequential analysis

close all;	% close all the open windows
clear all;	% clear and delete all the existing variables

%Displaying the inputs mu = cell2mat(struct2cell(load('mu.mat'))); 
filename = 'demo-input.xlsx';
%filename = 'input.xlsx';
MEAN = xlsread(filename, 'mu');
SIG = xlsread(filename, 'sigma');
CELL_WEIGHTAGE = xlsread(filename, 'cell_weightage')';
CELL_COST = xlsread(filename, 'cell_cost')';
m = 1;
increment_factor = 1;
n=ones(1,length(CELL_WEIGHTAGE))* m;
%disp(n);	% Displaying n
A0=1000;
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
[num_genes, num_cells] = size(MEAN);

mu=MEAN;
sig=SIG;
c=CELL_WEIGHTAGE;
a=CELL_COST;

f = @(n)objective(n,mu,sig,c, z_alpha);

problem = createOptimProblem('fmincon','x0',n, 'objective',f, 'Aineq', A, 'bineq', b,'Aeq',Aeq,'beq',beq, 'lb',lb,'ub',ub, 'options', options, 'nonlcon',[]);
gs = GlobalSearch('Display','none');
[optimal_theoritical_n, min_theoritical_objective] = run(gs,problem);

%disp(optimal_theoritical_n);
%disp(min_theoritical_objective);

state = zeros(1,num_cells);

%disp(state)

temp = normrnd(MEAN,SIG, num_genes, num_cells);

data = temp;

sample_mean = zeros(num_genes, num_cells);
sample_std = zeros(num_genes, num_cells);

% Collecting samples from each cell using state info

while(sum(state)<num_cells)
 
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

    f = @(n)objective(n,mu,sig,c, z_alpha);

    problem = createOptimProblem('fmincon','x0',lb, 'objective',f, 'Aineq', A, 'bineq', b,'Aeq',Aeq,'beq',beq, 'lb',lb,'ub',ub, 'options', options, 'nonlcon',[]);
    gs = GlobalSearch('Display','final');
    [optimal_practical_n, min_practical_objective] = run(gs,problem);

%disp([optimal_practical_n, min_practical_objective])
   
    for cell_index = 1:num_cells
        
        %if((n(cell_index)>=optimal_practical_n(cell_index)) & (state(cell_index)==0))
        if((n(cell_index)>=optimal_practical_n(cell_index)))
            state(cell_index)=1;
        end
    end    

%disp(state)

    for cell_index = 1:num_cells
        counter=1;    
        if (state(cell_index)==0)
              
            %disp(n)
            
            while(counter<=increment_factor)
                
                data(:,cell_index,n(cell_index))= normrnd(MEAN(:,cell_index),SIG(:,cell_index), num_genes, 1);
                n(cell_index) = n(cell_index) + 1;
                counter = counter + 1;
            end    
            %sprintf('Optimal value not found for cell:%d ', cell_index);
            
        else
            sprintf('Optimal value found for cell:%d ', cell_index);
        end
 
    end
  disp(optimal_theoritical_n)    
  disp(optimal_practical_n)
disp(n)
disp(state)
disp(a*n');
    %sprintf('n:%d', n);
    
end    
