function SP = objective(n, sig, c, z_alpha, delta_star, delta_0)
  
	pdf_vector = [];
	[num_genes,num_cells] = size(sig);
	
    for j=1:num_genes
        denominator=sum(((c.^2) .* sig(j,:).^2) ./ n);
  		pdf_vector(j)=normpdf(-z_alpha + ((delta_star(j) + abs( delta_0(j) ) ) ./ denominator));
    end
    
    SP=-sum(pdf_vector);
    
end