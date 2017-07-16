function [delta_star, delta_0] = delta_calculation(c,mu,delta_star_epsilon, delta_0_epsilon)
	
        delta = c * mu;
        delta_star = delta + delta_star_epsilon;
        delta_0 = delta + delta_0_epsilon;
        
end

