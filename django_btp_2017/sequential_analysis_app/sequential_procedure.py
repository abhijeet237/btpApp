#import required libraries

from openpyxl import load_workbook
import numpy as np
import pandas as pd

def performSequentialAnalysis(input_file, budget):
	#read from excel file
	xlsx_file = pd.ExcelFile(input_file)
	#getting data stored in 'Sheet1;
	data = xlsx_file.parse('Sheet1')

	total_gene_ids = len(data['Cell_Type'])

	#print("total_gene_ids : {}".format(total_gene_ids))
	mu = data['mu'].as_matrix()	# Mean for each group 
	sigma = data['sigma'].as_matrix() # Standard Deviation for each group
	C = data['Group-weightage'].as_matrix() # Coeficients for each group
	a = data['Gene-cost'].as_matrix() # Sampling cost for each group
	A = float(budget)
	current_iteration=1
	num_iterations=1
	denominator_matrix = np.zeros((total_gene_ids, 1))
	test_result_matrix = np.zeros((total_gene_ids, num_iterations))

	#Theoritical calulation of sample value per group
 	optimum = np.zeros((total_gene_ids, 3))#optimum matrix containing both optimum sample size & respective deviation

 	#print C
 	#print sigma
 	#print sigma[0]

	for i in range(0,total_gene_ids):
		#print (A)*(np.absolute(C[i])*sigma[i])
		num = (A)*np.absolute(C[i])*sigma[i]
		for l in range(0,total_gene_ids):
		 	denominator_matrix[l]=np.absolute(C[l])*(sigma[l])*(np.sqrt(a[l]*a[i]))
		optimum[i,0] = np.round((float(num)/float(np.sum(denominator_matrix))),precision)
	#print optimum

	while current_iteration <= num_iterations:
		#print("Current iteration : {}".format(current_iteration))    	
		m=2#size of pilot data for each group
		counter = 0
		pilot_data = np.zeros((1, m))
		sd_of_each_group = np.zeros((total_gene_ids, 1)) #stores sd of each group when it reaches its optimum sample size
		#pilot_data generated successfully
		numerator=0
		denominator=0
		calculated_value = np.zeros((total_gene_ids, 1))#stores num/denom value for each group after each iteration
		state = np.zeros((total_gene_ids, 1))#this vector is used to determine whether that particular group achieved optimum value(i.e. 1) or not (i.e. "0")
		#generating pilot_data
		for i in range(0,total_gene_ids):
			temp = np.random.normal(mu[i],sigma[i], m)
			#print("Generated normal rand_num : {}".format(temp))    	
			#print("Pilot_data : {}".format(pilot_data))    	
			if (pilot_data[0]==0).all():
				pilot_data = temp
			else:
				pilot_data = np.vstack((pilot_data, temp))
			
		while counter < total_gene_ids:#this counter shows #groups that have achieved optimum value
	  		for i in range(0,total_gene_ids):
	  			if state[i]==0:
	  				numerator = A*abs(C[i])*(np.std(pilot_data[i]))
	  				for l in range(0,total_gene_ids):
						if state[l]==1:
							#print("IF:l : {} | {} ".format(l,pilot_data)) 
							denominator_matrix[l]=abs(C[l])*(sd_of_each_group[l])*np.sqrt(a[l]*a[i])
						else:#if(state[l]==0)
							#print("Else:l : {} | {}".format(l,pilot_data)) 
							denominator_matrix[l]=abs(C[l])*(np.std(pilot_data[l]))*np.sqrt(a[l]*a[i])
				calculated_value[i] = float(numerator)/float(sum(denominator_matrix))
		   		###condition check
	 		for i in range(0,total_gene_ids):
				b = calculated_value[i]
				if (m>= b and state[i]==0):
					state[i]=1
					#optimum[i,1]=m
					#optimum[i,2]=sd(pilot_data[i,])
					test_result_matrix[i,(current_iteration-1)] = m
			 		sd_of_each_group[i]=np.std(pilot_data[i])
					counter = counter+1
									
								
			#steps to update m & pilot_data & restart process again for non-optimized groups
	  		m=m+1 #increamenting m
	  		pilot_data = np.hstack((pilot_data,np.zeros((total_gene_ids, 1))))
	  		for i in range(0,total_gene_ids):#updating the pilot data according to value of m
				if state[i]==0:
					pilot_data[i,(m-1)] = np.random.normal(mu[i], sigma[i], 1)
				
		   
		current_iteration = current_iteration + 1

  	for i in range(0,total_gene_ids): 
  		optimum[i,1] = np.mean(test_result_matrix[i])
   		optimum[i,2] = np.std(test_result_matrix[i])
	#print(optimum)
	#print(test_result_matrix)

	resultlist=[]
	n_io_list = []
	mean_N_io_list = []
	sd_mean_N_io_list = []
	#resultlist.append(data['Cell_Type'].as_matrix())
	np.around(optimum,2)
	for i in range(0,total_gene_ids):
		resultlist.append(optimum[i])
		n_io_list.append(optimum[i,0])
		mean_N_io_list.append(optimum[i,1])
		sd_mean_N_io_list.append(optimum[i,2])

	return {

		'cell_type' : data['Cell_Type'].as_matrix(),
		'resultlist' : resultlist,
		'n_io_list' : n_io_list,
		'mean_N_io_list' : np.round(mean_N_io_list,precision),
		'sd_mean_N_io_list' : np.round(sd_mean_N_io_list,precision),
		'num_iterations' : num_iterations

	}

def performSequentialAnalysisSimulation(input_file, budget, num_iterations, precision):
	#read from excel file
	xlsx_file = pd.ExcelFile(input_file)
	#getting data stored in 'Sheet1;
	data = xlsx_file.parse('Sheet1')

	total_gene_ids = len(data['Cell_Type'])

	#print("total_gene_ids : {}".format(total_gene_ids))
	mu = data['mu'].as_matrix()	# Mean for each group 
	sigma = data['sigma'].as_matrix() # Standard Deviation for each group
	C = data['Group-weightage'].as_matrix() # Coeficients for each group
	a = data['Gene-cost'].as_matrix() # Sampling cost for each group
	A = float(budget)
	current_iteration=1

	denominator_matrix = np.zeros((total_gene_ids, 1))
	test_result_matrix = np.zeros((total_gene_ids, num_iterations))

	#Theoritical calulation of sample value per group
 	optimum = np.zeros((total_gene_ids, 3))#optimum matrix containing both optimum sample size & respective deviation
 	inter_stage_status = []
 	temporary_list=[]
 	#print C
 	#print sigma
 	#print sigma[0]

	for i in range(0,total_gene_ids):
		#print (A)*(np.absolute(C[i])*sigma[i])
		num = (A)*np.absolute(C[i])*sigma[i]
		for l in range(0,total_gene_ids):
		 	denominator_matrix[l]=np.absolute(C[l])*(sigma[l])*(np.sqrt(a[l]*a[i]))
		optimum[i,0] = np.round((float(num)/float(np.sum(denominator_matrix))),precision)
	#print optimum

	while current_iteration <= num_iterations:
		#print("Current iteration : {}".format(current_iteration))    	
		m=2#size of pilot data for each group
		counter = 0
		pilot_data = np.zeros((1, m))
		sd_of_each_group = np.zeros((total_gene_ids, 1)) #stores sd of each group when it reaches its optimum sample size
		#pilot_data generated successfully
		numerator=0
		denominator=0
		calculated_value = np.zeros((total_gene_ids, 1))#stores num/denom value for each group after each iteration
		state = np.zeros((total_gene_ids, 1))#this vector is used to determine whether that particular group achieved optimum value(i.e. 1) or not (i.e. "0")
		#generating pilot_data
		for i in range(0,total_gene_ids):
			temp = np.random.normal(mu[i],sigma[i], m)
			#print("Generated normal rand_num : {}".format(temp))    	
			#print("Pilot_data : {}".format(pilot_data))    	
			if (pilot_data[0]==0).all():
				pilot_data = temp
			else:
				pilot_data = np.vstack((pilot_data, temp))
		stage=0	
		while counter < total_gene_ids:#this counter shows #groups that have achieved optimum value
	  		
	  		for i in range(0,total_gene_ids):
	  			if state[i]==0:
	  				numerator = A*abs(C[i])*(np.std(pilot_data[i]))
	  				for l in range(0,total_gene_ids):
						if state[l]==1:
							#print("IF:l : {} | {} ".format(l,pilot_data)) 
							denominator_matrix[l]=abs(C[l])*(sd_of_each_group[l])*np.sqrt(a[l]*a[i])
						else:#if(state[l]==0)
							#print("Else:l : {} | {}".format(l,pilot_data)) 
							denominator_matrix[l]=abs(C[l])*(np.std(pilot_data[l]))*np.sqrt(a[l]*a[i])
				calculated_value[i] = float(numerator)/float(sum(denominator_matrix))
		   		###condition check
	 		for i in range(0,total_gene_ids):
				b = calculated_value[i]
				if (m>= b and state[i]==0):
					state[i]=1
					#optimum[i,1]=m
					#optimum[i,2]=sd(pilot_data[i,])
					test_result_matrix[i,(current_iteration-1)] = m
			 		sd_of_each_group[i]=np.std(pilot_data[i])
					counter = counter+1				
								
			#steps to update m & pilot_data & restart process again for non-optimized groups
	  		m=m+1 #increamenting m
	  		pilot_data = np.hstack((pilot_data,np.zeros((total_gene_ids, 1))))
	  		for i in range(0,total_gene_ids):#updating the pilot data according to value of m
				if state[i]==0:
					pilot_data[i,(m-1)] = np.random.normal(mu[i], sigma[i], 1)
			if(current_iteration == 1):	
				#print('current_iteration:', current_iteration)	
				#print('stage:',stage)	
				stage = stage + 1
				#print('Stage:', stage, ' | trm : ', test_result_matrix[:,0])
				for cell_id in range(0,total_gene_ids):
					#print(test_result_matrix[cell_id,0]," | ",state[cell_id,0])
					temporary_list.append([test_result_matrix[cell_id,0],state[cell_id,0]])
				#inter_stage_status.append([{'sample_size':test_result_matrix[:,0].tolist(),'state':state[:,0].tolist()}])		
				inter_stage_status.append(temporary_list)
		   
		current_iteration = current_iteration + 1

  	for i in range(0,total_gene_ids): 
  		optimum[i,1] = np.mean(test_result_matrix[i])
   		optimum[i,2] = np.std(test_result_matrix[i])
	#print(optimum)
	#print(test_result_matrix)

	resultlist=[]
	n_io_list = []
	mean_N_io_list = []
	sd_mean_N_io_list = []
	#resultlist.append(data['Cell_Type'].as_matrix())
	np.around(optimum,2)
	for i in range(0,total_gene_ids):
		resultlist.append(optimum[i])
		n_io_list.append(optimum[i,0])
		mean_N_io_list.append(optimum[i,1])
		sd_mean_N_io_list.append(optimum[i,2])

	return {

		'cell_type' : data['Cell_Type'].as_matrix(),
		'resultlist' : resultlist,
		'n_io_list' : n_io_list,
		'mean_N_io_list' : np.round(mean_N_io_list,precision),
		'sd_mean_N_io_list' : np.round(sd_mean_N_io_list,precision),
		'num_iterations' : num_iterations,
		'inter_stage_status' :  inter_stage_status,
		'shape' : np.shape(inter_stage_status)

	}
