library(matrixStats)
library(gdata)
library(xlsx)
#reading input file
data = read.xlsx("input.xlsx", sheetName = "Sheet1", header = TRUE)

#converting the data into numeric foramt for further calculation
M=as.numeric(data[,1])

D = as.numeric(data[,2])

A = 5000 #total amount to be used to conduct experiment
C = as.numeric(data[,3])#coefficients for each group
a = as.numeric(data[,4])
num_iterations=5
current_iteration=1
denominator_matrix = matrix("0",length(M),1)
test_result_matrix = matrix("0",length(M),num_iterations)
 
 #Theoritical calulation of sample value per group
 optimum = matrix("0",length(M),3)#optimum matrix containing both optimum sample size & respective deviation
 
 for(i in 1:length(M))
 {
   num = as.numeric(A*abs(C[i])*D[i])
   #den = 0
   for(l in 1:length(M)){
     #den = den + (abs(C[l])*D[l]*sqrt(a[l]*a[i]))
     denominator_matrix[l,]=abs(C[l])*(D[l])*sqrt(a[l]*a[i]) 
   }
   
   optimum[i,1] = num/sum(as.numeric(denominator_matrix))
 }
 
 
while(current_iteration <= num_iterations)
{
  print(current_iteration)
  m=2#size of pilot data for each group
  counter = 0
  pilot_data = (matrix("0",1,m))
  sd_of_each_group = (matrix("0",length(M),1)) #stores sd of each group when it reaches its optimum sample size
  #pilot_data
  #pilot_data generated successfully
  numerator=0
  denominator=0
  
  calculated_value = (matrix("0",1,length(M)))#stores num/denom value for each group after each iteration
  state = matrix("0",1,length(M))#this vector is used to determine whether that particular group achieved optimum value(i.e. 1) or not (i.e. "0")
  
 
  
#generating pilot_data
for(i in 1:length(M))
{
  temp = rnorm(m,mean = M[i], sd = D[i])
  if(pilot_data[1]==0)
  {
    pilot_data = temp
  }
  else
  {
    pilot_data = rbind(pilot_data, temp)
  }
}

  
while(counter < length(M))#this counter shows #groups that have achieved optimum value
{ 
  
  for(i in 1:length(M))
  {
    if(state[i]==0){
      
      numerator = A*abs(C[i])*(sd(pilot_data[i,]))
      
      for(l in 1:length(M))
      {
        #if(state[l]==1)
        #{z=as.numeric(optimum[l,2])#as it is of type character so converting it into numeric
        # denominator = denominator + abs(C[l])*z*sqrt(a[l]*a[i])}#optimum[l,2] is optimum variace of l-th group
        #if(state[l]==0)
        #{denominator = denominator + abs(C[l]*(sd(pilot_data[l,]))*sqrt(a[l]*a[i]))}
        
        if(state[l]==1)
        {
        denominator_matrix[l,]=abs(C[l])*(as.numeric(sd_of_each_group[l,]))*sqrt(a[l]*a[i])
        }else{#if(state[l]==0)
        denominator_matrix[l,]=abs(C[l])*(sd(pilot_data[l,]))*sqrt(a[l]*a[i]) 
        }
      }
      calculated_value[i] = numerator/sum(as.numeric(denominator_matrix))
      
      #print(calculated_value)
      
    }
    
   
  }
  ###condition check
  for (i in 1:length(M)) 
  { 
    b = as.numeric(calculated_value[i])
    
  if(m>= b && state[i]==0)
  {
    state[i]=1
    #optimum[i,1]=m
    #optimum[i,2]=sd(pilot_data[i,])
    test_result_matrix[i,current_iteration] = m
    sd_of_each_group[i,]=sd(pilot_data[i,])
    counter = counter+1
  }
  }
  #steps to update m & pilot_data & restart process again for non-optimized groups
  m=m+1 #increamenting m
  pilot_data = cbind(pilot_data,"0")
  for(i in 1:length(M))#updating the pilot data according to value of m
  {
    if(state[i]==0){
      pilot_data[i,m] = rnorm(1,mean = M[i], sd = D[i])
    }
  }
  #final = as.numeric(state)
}
  current_iteration = current_iteration + 1
}
 
 
 for (i in 1:length(M)) {
   
   optimum[i,2] = mean(as.numeric(test_result_matrix[i,]))
   optimum[i,3] = sd(as.numeric(test_result_matrix[i,]))
   
 }
 
print(optimum)



