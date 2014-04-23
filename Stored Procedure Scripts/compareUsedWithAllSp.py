#!/usr/bin/python
import pyodbc, sys, getopt

def main(argv):
	try:
		outlist, args = getopt.getopt(argv, "ho:t:")
	except getopt.GetoptError as err:
		print str(err)
		usage()
		sys.exit(2)
	
	table = None
	output = None
	
	for opt, arg in outlist:
		if opt == "-o":
			output = arg
		elif opt == "-t":
			table = arg
		elif opt == "-h":
			setup_howTo()
		else:
			assert False, "unhandled option"
	
	fileOutput = open(output, "w")
	
	pullSpNamesAndCompare(fileOutput, table)
	
	fileOutput.close()
	
# Retrieves SP names from SPs used and all SPs and compares lists
def pullSpNamesAndCompare(output, table):
	#need to run stuff here
	cnxn = pyodbc.connect("DRIVER={SQL Server};SERVER=localhost;DATABASE=CartellaDev3;UID=sa;PWD=ingeniux")
	cursor = cnxn.cursor()
	cursor.execute("SELECT pr.name FROM sys.procedures pr")
	allProcs = flattenRowList(cursor.fetchall())
	cursor.execute("SELECT DISTINCT tempTable.ObjectName FROM " + table + " tempTable WHERE tempTable.ObjectName IS NOT NULL")
	usedProcs = flattenRowList(cursor.fetchall())
	
	unusedProcs = set(allProcs).difference(set(usedProcs))
	for procName in unusedProcs:
		output.write(procName + '\n')

# Explanation of usage of program
def usage():
	print("Usage: -o <output file name> -t <SQL table to read>")
	print("-h will explain how to set up for the script")
	
# Explanation of how to set up
def setup_howTo():
	print('''This program is set up to work in conjunction with SQL Server Profiler. Set up the profiler to record the starting execution of stored procedures. You only need to have it record the ObjectName since no other information is needed. Have it save to a table. Proceed to touch as much of the site as possible. Once you are done stop the profiler and run this program with a given output name and the name of the table. The usage is -o <output file name> -t <SQL table to read>''')
	sys.exit(0)

# Explanation of Python comprehensions to understand syntax
# http://docs.python.org/2/tutorial/datastructures.html#list-comprehensions
# Pulls tuples from list then pulls name from tuples into a single list
def flattenRowList(tupleList):
	return [element for row in tupleList for element in row]

if __name__ == "__main__":
   main(sys.argv[1:])