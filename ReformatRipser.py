## Function to split barcode output from ripser into separate files for dimensions 0 and 1
# Bernadette Stolz
# 26.3.2019

def formatFunction(landmark_filename2):

	filename = landmark_filename2 + ".txt"

	f = open(filename, "r")

	filename = landmark_filename2 + "Dim0.txt"
	outFile = open(filename, "w")
	outFile.close()

	filename = landmark_filename2 + "Dim1.txt"
	outFile = open(filename, "w")

	for line in f:
		if line.startswith("persistence intervals in dim 0:"):
			outFile.close()
			filename = landmark_filename2 + "Dim0.txt"
			outFile = open(filename, "w")
		if line.startswith("persistence intervals in dim 1:"):
			outFile.close()
			filename = landmark_filename2 + "Dim1.txt"
			outFile = open(filename, "w")
		if line.startswith(" ["):
			line = line.replace("[", "")
			line = line.replace(")", "")
			line = line.replace(",", " ")
			line = line.replace("0  ", "0 -1") #-1 is standard format
			outFile.write(line)
	f.close()
	outFile.close()
