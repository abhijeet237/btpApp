function SP = objective(n, sig, c, z_alpha, delta_star, delta_0)
  
	%pdf_vector = [];
	%[num_cells, num_genes] = size(sig);
    
    pdf_vector=-z_alpha + ((delta_star + abs(delta_0))/(sqrt((c./n) * sig)));
    
    SP=-sum(pdf_vector);
    
end