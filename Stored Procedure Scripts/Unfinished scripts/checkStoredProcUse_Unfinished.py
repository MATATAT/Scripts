import pyodbc

def runProg():
	#need to run stuff here
	cnxn = pyodbc.connect("DRIVER={SQL Server};SERVER=localhost;DATABASE=CartellaDev2;UID=sa;PWD=ingeniux")
	cursor = cnxn.cursor()
	cursor.execute("SELECT pr.name FROM sys.procedures pr")
	rows = cursor.fetchall()
	
	for row in rows:
		print row
	
	return 0
	
runProg()
raw_input("Press Enter to continue...")