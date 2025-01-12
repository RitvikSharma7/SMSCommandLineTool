#!/bin/bash

echo "Welcome to the SMS command line tool service."
echo "Please enter the file name you would like to use to execute SMS commands"
echo "##################################################################"
read -r fileName

if [[ ! -f "$fileName" ]]; then
	echo "File doesn't exist, creating a new file with desired name...."
	touch "$fileName"

else
	echo "File exists and ready for SMS execution."
fi

echo "|    ID    |   NAME   |   GRADE  |" >> "$fileName"   # Student Record Header

SMS_TOOL()
{
	select option in ADD DELETE SEARCH SEE QUIT; do

		case $option in
		ADD)
			add_student_record
			;;
		DELETE)
			delete_student_record
			;;
		SEARCH)
			search_student_record
			;;
		SEE)
			see_student_records
			;;
		QUIT)
			echo "Exiting SMS tool, Goodbye!" 
			break
			;;
		*)
			echo "Invalid option selected."
			;;
		
		esac	
	done
	
}


add_student_record()
{
	echo "Enter the student record to add as ID,FULL NAME,FINAL GRADE"
	read -r studentRecord

	if [[ -z "$studentRecord" ]]; then
		echo "Student record cant be empty, please try again."
		return
	fi


	echo "$studentRecord" >> "$fileName"
	echo "Record added succesfully"

}


delete_student_record()
{
	echo "What Student do you want to delete based on ID"
	read -r ID

	if grep -q "$ID" "$fileName"; then	
		sed -i "/$ID/d" "$fileName"
		echo "Student Record deleted succesfully."
	else
		echo "Error: Student ID not found."
	fi


}

search_student_record()
{
	echo "What student do you want to search based on ID"
	read -r ID
	
	if grep -q "$ID" "$fileName"; then
		grep "$ID" "$fileName"
	else
		echo "Student ID not found."
	fi

}

see_student_records()
{	
	if [[ ! -s "$fileName" ]]; then
		echo "File has no student records to fetch."
	else
		echo "-------------------------------------"
		cat "$fileName"
		echo "-------------------------------------"
	fi

}



main()
{
	SMS_TOOL

}

main
