#!/bin/bash
set -x

fileName=".sturec.csv"

if [[ ! -s "$fileName" ]]; then
	echo "|     ID     |     NAME     |     FINAL GRADE     |" >> "$fileName"
fi

gui_menu()
{
  whiptail --title "SMS TOOL" --msgbox "Welcome to the SMS GUI tool.Press OK to continue." 8 70

  while true;do
  OPTION=$(whiptail --title "SMS TOOL" --menu "Choose an SMS command." 25 78 16 \
	   ADD "Add a student reecord" \
	   DELETE "Delete a student record based on ID" \
	   SEARCH "Search for a student record based on ID." \
	   SEE "See list of student records present" \
	   QUIT "Quit the SMS tool." 3>&1 1>&2 2>&3)

  case $OPTION in

  "ADD")
    add
    ;;

  "DELETE")
    delete
    ;;

  "SEARCH")
    search
    ;;

   "SEE")
     seeRecs
     ;;

   "QUIT")
     whiptail --title "Goodbye" --msgbox "Quitting SMS TOOL...." 8 70
     exit 0
     ;;

    *)
     whiptail --title "ERROR" --msgbox "Error selecting a choice." 8 70
     ;;
     esac
  done

}

add()
{

  sturec=$(whiptail --title "SMS TOOL" --inputbox "Enter student record. FORMAT: ID, FULL-NAME, FINAL-GRADE" 8 70 3>&1 1>&2 2>&3)
  local exit_codeA=$?
	
  if [[ "$exit_codeA" -ne 0 ]]; then
     whiptail --title "SMS TOOL" --msgbox "Addition Operation cancelled." 8 70
     return
  fi

  if [[ -z "$sturec" ]]; then
     whiptail --title "SMS TOOL" --msgbox "Inavlid student record, try again." 8 70
  fi
		
  echo "$sturec" >> "$fileName"
  whiptail --title "SMS TOOL" --msgbox "Student record added!" 8 70
}

delete()
{

  ID=$(whiptail --title "SMS TOOL" --inputbox "Enter Student ID to delete student record" 8 70 3>&1 1>&2 2>&3)
  local exit_codeD=$?

  if [[ "$exit_codeD" -ne 0 ]]; then
     whiptail --title "SMS TOOL" --msgbox "Deletion operation cancelled." 8 70
     return
  fi

  if grep -q "$ID" "$fileName"; then
     whiptail --title "SMS TOOL" --msgbox "Student Record deleted." 8 70
     sed -i "/$ID/d" "$fileName"
  else
     whiptail --title "SMS TOOL" --msgbox "Student record not found." 8 70
  fi

}

search()
{

  SID=$(whiptail --title "SMS TOOL" --inputbox "Enter student ID or student NAME to search student record." 8 70 3>&1 1>&2 2>&3)
  local exit_codeS=$?

  if [[ "$exit_codeS" -ne 0 ]]; then
     whiptail --title "SMS TOOL" --msgbox "Search operation cancelled." 8 70
     return
  fi

  if grep -q "$SID" "$fileName"; then
     sturec=$(grep "$SID" "$fileName")
     whiptail --title "SMS TOOL" --msgbox "$sturec" 15 70
  else
     whiptail --title "SMS TOOL" --msgbox "Record not found." 8 70
  fi
		
}

seeRecs()
{	
  whiptail --title "Student Records" --textbox "$fileName" 30 70
}

main()
{
  gui_menu
}

main 2>&1
