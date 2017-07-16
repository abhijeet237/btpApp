import subprocess

# Define command and arguments

def run_R_script(R_script_path, input_file_path , experiment_budget):
	
	command = 'Rscript'
	
	path2script = R_script_path

	# Variable number of args in a list
	#args = ['11', '3', '9', '42']
	args = [input_file_path, experiment_budget]
	# Build subprocess command
	cmd = [command, path2script] + args

	# check_output will run the command and store to result
	x = subprocess.check_output(cmd, universal_newlines=True).split("\n")
	
	return 'The maximum of the numbers is:', x


print run_R_script('/home/jishnu/Desktop/btp-sequential-analysis/Jishnu-Materials/X-app/sequential_procedure.R', '/home/jishnu/Desktop/btp-sequential-analysis/Jishnu-Materials/X-app/input.xlsx', '1000')
