# This python script is for reading huge log files (specifically hive and SparkSQL) and writing run time of each job in a csv.
# One job might contain multiple sql scripts run time. This scripts adds up all the sub jobs (sql scripts) run time and writes in a csv 
# Sample input file -> Hive_Log.txt
import sys

file_name = sys.argv
print(file_name[1])

source = open(file_name[1], "r")

final_list=[]
temp_list=[]

for i in source:
	if("JobName" in i):
		temp_list.append(i)
	elif("Time taken: " in i):
		i_split=[]
		i_split=i.split()
		temp_list.append(float(i_split[-2]))
		
print(temp_list)

			
x=0
while(x != len(temp_list)):
	#print(x)
	if(type(temp_list[x]) == str):
		final_list.append(temp_list[x][:-1])
		x = x+1
	else:
		y=x
		summ =0
		while(y != len(temp_list)):
			if(type(temp_list[y]) == str):
				break
			else:
				summ = summ + temp_list[y]
			y = y+1
		final_list.append(summ)
		x = y

print(final_list)



target = open("/home/cloudera/Desktop/output2.csv", "w")

for item in final_list:
	if(type(item) == str):
		target.write(item)
		target.write(",")
	else:
		target.write(str(item))
		target.write("\n")