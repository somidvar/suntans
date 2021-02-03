SUNTANSProject="/scratch/omidvar/work-directory_0801/12th/suntans-triangular-" 
for i in {12000..12000}
do
	SUNTANSComilingPath="$SUNTANSProject"$i"/iwaves/data"
	cd $SUNTANSComilingPath
	rm T.dat
	rm q.dat
done
