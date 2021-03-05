#QUESTION:
#The log_files folder also contains some stdout logging files (prefix file name = ’stdout’). Write a shell script
#that, given a job name (look for string “Job Name”) as input argument, reports the CPU-time (look for string
#“cput”). If the job name has been used more than once, the maximum CPU-time should be reported. If no
#job name is specified as input argument, the job name with the highest cpu time must be reported (job name
#+ cpu time). It should look something like this:
#• $ ./cputime.sh T1234
#>‌>CPU time of 00:14:08 for job T1234
#• $ ./cputime.sh
#>‌>Maximum CPU time of 01:16:22 for job C4321

#!/bin/bash
counter=0
for file in $(grep -l "Job Name: $1" log_files/*.be)
do
	
	#No file entered
	if [ $# -eq 0 ]; then
			echo "No parameter provided, calculating maximum CPU time"
			
			for item in $(find log_files/ -maxdepth 1 -name "*stdout*")
			do
				cput=$(grep "cput" $item | cut -d "=" -f2 | cut -d "," -f1)
				jname=$(grep "Job Name" $item | cut -d " " -f3)
				
				#If this is the first iteration, assume it is the maximum CPU time
				if [ "$counter" == "0" ]; then
					max_cput=$cput
					max_jname=$jname
					counter=$(($counter + 1 ))
				else
					#echo "file number: $counter"
					counter=$(($counter + 1 ))
					
					IFS=: read old_hour old_min s <<< "$max_cput"
					IFS=: read hour min s <<< "$cput"

					# convert the date "1970-01-01 hour:min:00" in seconds from Unix EPOCH time
					sec_old=$(date -d "1970-01-01 $old_hour:$old_min:00" +%s)
					sec_new=$(date -d "1970-01-01 $hour:$min:00" +%s)
					
					if [ $sec_new -gt $sec_old ]; then
							max_cput=$cput
							max_jname=$jname
					fi
				
				fi
				
			done
			echo "Maximum CPU time of $max_cput for job $max_jname"
			
			exit 1
	
	#We have $1 and 1 $file
	else			
		#echo "$file"
		#Get CPU time from simple text extraction between "=" and ","
		cput=$(grep "cput" $file | cut -d "=" -f2 | cut -d "," -f1)
		
		#If this is the first iteration, assume it is the maximum CPU time
		if [ "$counter" == "0" ]; then
			max_cput=$cput
			max_jname=$jname
			counter=$(($counter + 1 ))
		else
			#echo "file number: $counter"
			counter=$(($counter + 1 ))
					
			#If incoming cput is greater then store it as maximum
			IFS=: read old_hour old_min s <<< "$max_cput"
			IFS=: read hour min s <<< "$cput"

			# convert the date "1970-01-01 hour:min:00" in seconds from Unix EPOCH time
			sec_old=$(date -d "1970-01-01 $old_hour:$old_min:00" +%s)
			sec_new=$(date -d "1970-01-01 $hour:$min:00" +%s)
				
			if [ $sec_new -gt $sec_old ]; then
				max_cput=$cput
			fi
		fi
	fi
done
	echo "CPU time of $max_cput for job $1"
