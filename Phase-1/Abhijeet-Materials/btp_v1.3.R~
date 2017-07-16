library(matrixStats)
library(gdata)
library(xlsx)
#reading input file
final_opt_sample_size = matrix("0",length(M),1)
for(k in 1:10)
{
data = read.xlsx("input.xlsx", sheetName = "Sheet1", header = TRUE)
#converting the data into numeric format for further calculation
#for generating pilot_data
M=as.numeric(data[,1])#mean of all groups
D = as.numeric(data[,2])#deviation of all groups
#generating pilot_data
m=3#size of pilot data for each group
#counter = 0
pilot_data = (matrix("0",1,m))

numerator=0
denominator=0
A = 500 #total amount to be used to conduct experiment
C = as.numeric(data[,3])#coefficients for each group
a = as.numeric(data[,4])#sampling cost
calculated_value = (matrix("0",1,length(M)))#stores num/denom value for each group after each iteration
state = matrix("0",1,length(M))#this vector is used to determine whether that particular group achieved optimum value(i.e. 1) or not (i.e. "0")
optimum = matrix("0",length(M),3)#optimum matrix containing both optimum sample size & respective deviation
#third column is used to store the std deviation in calcullating ot sample size of that group

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
#pilot_data generated successfully

while(sum(as.numeric(state)) != length(M))
{ 
  for(i in 1:length(M))
  {
    if(state[i]==1)#leaving the group whose optimal sample size has already been found
    {next}
    else
     {numerator = A*abs(C[i])*(sd(pilot_data[i,]))*(1/sqrt(a[i]))}
    for(l in 1:length(M))
    {
      if(state[l]==1)
      {z=as.numeric(optimum[l,2])#as it is of type character so converting it into numeric
        denominator = denominator + abs(C[l])*z*sqrt(a[l])}#optimum[l,2] is optimum variace of l-th group
      if(state[l]==0)
      {denominator = denominator + abs(C[l]*(sd(pilot_data[l,]))*sqrt(a[l]))}
    }
    calculated_value[i] = numerator/denominator #calculating value of RHS of equation for all groups
  }
  ###condition check
  for (i in 1:length(M)) 
    { b = as.numeric(calculated_value[i])
      if(m>= b)
       {
        state[i]=1#enabling the flag showing that optimum sample size condition is achieved
	#storing respective sample size & standard deviation into a matrix        
	optimum[i,1]=m
        optimum[i,2]=sd(pilot_data[i,])
        #counter = counter+1 #increamenting counter
      }
    else{next}
    }
  #steps to update m & pilot_data & restart process again for non-optimized groups
    m=m+1 #increamenting m to generate more pilot_data
    new = matrix("0",length(M),1)
    pilot_data = cbind(pilot_data,new)
    for(i in 1:length(M))#updating the pilot data according to value of m
    {
      pilot_data[i,m] = rnorm(1,mean = M[i], sd = D[i])
    }
}
if(final_opt_sample_size[1] == 0)
{
final_opt_sample_size = optimum[,1]
}
else
{
final_opt_sample_size = cbind(final_opt_sample_size,optimum[,1])
}

}
for(i in 1:length(M))
{
optimum[i,1] = mean(as.numeric(final_opt_sample_size[1,]))
optimum[i,3] = sd(as.numeric(final_opt_sample_size[1,]))
}
print(optimum)
