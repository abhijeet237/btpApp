function [delta_star, delta_0] = delta_calculation(c,mu,delta_star_epsilon, delta_0_epsilon)
	[num_genes,num_cells] = size(mu);
	for j=1:num_genes
        delta(j) = c * mu(j,:)';
        delta_star(j) = delta(j) + delta_star_epsilon;
        delta_0(j) = delta(j) + delta_0_epsilon;
    	end
end


