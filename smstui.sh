#!/bin/bash

fileName='.sturec.csv'

SMS_INIT()
{

  echo "##################################################################"
  echo "#       Welcome to the SMS command line tool service.            #"
  echo "##################################################################"

  if [[ ! -f "$fileName" ]]
  then
    echo "Student records file doesn't exist, creating the required file."
    touch "$fileName"
  else
    echo "File exists and ready for SMS execution."
  fi

  if [[ ! -s "$fileName" ]]
  then
    echo "|    ID    |   NAME   |   GRADE  |" >> "$fileName"
  fi

}

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
        exit 0
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
  rec_val='^[0-9]+,[a-zA-Z]+ [a-zA-Z]+,(100|[0-9]{1,2})$'

  if [[ -z "$studentRecord" ]]
  then
    echo "Student record cant be empty, please try again."
    return
  fi

  if [[ "$studentRecord" =~ $rec_val ]]; then
    echo "$studentRecord" >> "$fileName"
    echo "Record added succesfully"
  else
    echo "Invalid record format."
    echo "Example: 123456,John Doe,90"
  fi
}

delete_student_record() {
  echo "Enter the student ID to delete:"
  read -r ID

  id_val='^[0-9]+$'

  if [[ ! "$ID" =~ $id_val ]]; then
    echo "Invalid Student ID. Please enter a numeric ID."
    return
  fi

  echo "Are you sure you want to delete the record for student ID $ID? (y/n)"
  read -r confirm
  if [[ "$confirm" != "y" ]]; then
    echo "Deletion cancelled."
    return
  fi

  if grep -q "^$ID," "$fileName"; then
    sed -i "/^$ID,/d" "$fileName"
    echo "Student record with ID $ID deleted successfully."
  else
    echo "Error: Student ID $ID not found."
  fi
}


search_student_record() {
  echo "Enter the student ID or full name to search for:"
  read -r ans

  id_check='^[0-9]+$'
  name_check='^[a-zA-Z]+ [a-zA-Z]+$'

  if [[ "$ans" =~ $id_check ]]; then
    if grep -q "^$ans," "$fileName"; then
      grep "^$ans," "$fileName"
    else
      echo "Student record with ID $ans not found."
    fi
  elif [[ "$ans" =~ $name_check ]]; then
    if grep -q ",$ans," "$fileName"; then
      grep ",$ans," "$fileName"
    else
      echo "Student record with name $ans not found."
    fi
  else
    echo "Invalid search input. Please enter a valid student ID or full name."
  fi
}


see_student_records()
{

  if [[ ! -s "$fileName" ]]
  then
    echo "File has no student records to fetch."
  else
    echo "-------------------------------------"
    cat "$fileName"
    echo "-------------------------------------"
  fi

}

main()
{

  SMS_INIT
  SMS_TOOL

}

main
