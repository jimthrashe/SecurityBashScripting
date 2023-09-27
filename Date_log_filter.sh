#!
#
#echo "the name of the file is"
File=$1
#FILTER

#grep cron "$File" | grep -v 'closed' | cut -d ' ' -f 1-3 | sort

for file in /home/jamest/Documents/IS_580_2/SSH_Security_Lab/auth.logfiles/
  do
  unsorted_data=$(grep cron "$File" | grep -v 'closed' | cut -d ' ' -f 1-3 | sort)

    # Sort unsorted data and store it
  sorted_data=$(echo "$unsorted_data" | sort -k1,1 -k2,2)

    # Sort sorted data in descending order
  reverse_data=$(echo "$sorted_data" | sort -r -k1,1 -k2,2)

    # Display both sorted data vertically
  echo -e "Ascending:\n$sorted_data\n"
  echo -e "Descending:\n$reverse_data"
  done
