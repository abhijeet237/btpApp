function [mu, sig, c, a, n, A0, x] = update_parameters(state, mu, sig, c, a, n, A0)
	
	[num_genes, num_cells] = size(mu);

	x=1:1:num_cells;

	size(mu);

    counter = 0;

	for index=1:num_cells
		if(state(index)==1)
			index;
			mu(:,index-counter) = [];
			sig(:,index-counter) = [];
            disp('CCCCCCCCCCCC')
			disp(c(index-counter))
			c(index-counter) = [];
			a_value = a(index-counter);
			n_value = n(index-counter);
			A0 = A0 - (a_value * n_value);
			a(index-counter) = [];
			n(index-counter) = [];
			x(index-counter) = [];
			counter = counter + 1;

		end

	end
