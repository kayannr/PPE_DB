#!/bin/bash


# define database connections 
db_name="supplier_csv_imports"
db_user="csv_imports"
db_password="password"

# define directory where CSV files from suppliers are located 
csv_files_directory="/path/to/the/csv/files"

# go into directory
cd $csv_files_directory

# get a list of CSV files in directory
csv_files=`ls -1 *.csv`

# loop through csv files
for csv_file in ${csv_files[@]}
do

	#extract specific columns from csv_file using cut command, excluding the first row (header) using tail command that extracts from the second row onward, and save it as a file called exracted_file.csv before feeding into the database 
	cut -d ‘;’ -f 1,2,5,6,7,8,9 csv_file |tail -n +2 > extracted_file.csv


	#import extracted csv file into existing database (i.e. mysql)
	function import_csv(){
		echo "import into exisiting database table..."
		cat ${extracted_file.csv}|while IFS=$',' read col1 col2 col3 col4 col5 col6 col7
		do
			echo "INSERT INTO $table_name (Prodct ID, Description, Order Date , Order Number, Quantity, Unit Cost, Subtotal) VALUES (DEFAULT, '$col1', '$col2', '$col3', '$col4', '$col5', '$col6', '$col7');"
		done | sudo mysql -u$db_user -p${rootpass} $db_name
	}

	#check for errors
	function check_error() {
		if [ $? -ne 0 ]; then
			echo "Error, terminating program!.."
			exit -1
		fi
	}

done
exit