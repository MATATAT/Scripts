from P4 import *
import sys

p4 = P4()
p4.port = "perforce.ingeniux.com:1666"
p4.user = "build"
p4.password = ""

def main(argv):
	try:
		p4.connect()

		# Integrate
		Integrate()

		# Resolve
		Resolve()

		# Submit
		Submit()

		p4.disconnect()
	except Exception e:
		# Regular error
		print e

		# Perforce errors (last run command)
		for err in p4.errors:
			print err

def Integrate():
	print "Starting integration..."
	p4.run("integrate", "-o", "-b", )

def Resolve():
	print "Resolving files..."

def Submit():
	print "Submitting resolved files..."

if __name__ == "__main__":
	main(sys.argv[1:]);