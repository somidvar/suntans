#This is a shell script for removing the cases without wind nor tides
Project="/d/Test/suntans-9th-"
for i in {0..7}
do
	for j in 90000 90004 90008 90012 90016 90020 90024
		do
		let CaseNumber=i*196+j
		ProjectPath="$Project$CaseNumber"
		echo "casenumber: $ProjectPath"
		rm -r $ProjectPath
	done
done
