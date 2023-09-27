#!/bin/bash

###########################################
# James Thrasher                          #
# IS 580                                  #
# Search files for a pattern              #
# Resources                               #
# None different since my last file 
# I am learning
#  Found out how to void data via claude  #
###########################################

# Check if the correct number of arguments are provided
if [ $# -lt 2 ]; then # Check number of arguments
  echo "Usage: $0 <path> <pattern>" >&2 # Print usage help
  exit 1 # Exit with error
fi 

# Assign arguments to variables  
path="$1" # Assign first argument to path variable
pattern="$2" # Assign second argument to pattern 

# Check if path is a directory
if [ -d "$path" ]; then # Check if path is directory
  echo "Searching in directory $path for $pattern" # Print message

  # Loop through files
  for file in "$path"/*; do # Loop through files
    
    # Check if file is readable
     
    if [[ "$file" == *.gz ]]; then #if the file ends in .gz can be repeated for other zip files with elif statements
      content=$(zcat "$file" 2>/dev/null | tr -d '\000') #used gpt to remove null byte statement gave tr -d \'000' 
    else
      content=$(cat "$file" 2>/dev/null | tr -d '\000')
    fi
    
    if echo "$content" | grep -qi "$pattern"; then   # echos if the string " " is in the log
        echo "File '$file' is Vulnerable"
      else
        echo "File '$file' is not Vulnerable"
    fi


  done

# Check if path is a file
elif [ -f "$path" ]; then # Check if path is file

  # Path is a file
    if [[ "$file" == *.gz ]]; then #if the file ends in .gz can be repeated for other zip files with elif statements
      content=$(zcat "$file" 2>/dev/null | tr -d '\000') #used gpt to remove null byte statement gave tr -d \'000' 
    else
      content=$(cat "$file" 2>/dev/null | tr -d '\000')
    fi  
    if echo "$content" | grep -qi "$pattern"; then   # echos if the string " " is in the log
      echo "File '$file' is Vulnerable"
    else
      echo "File '$file' is not Vulnerable"
    fi

# Invalid path
else # Path not directory or file
  echo "Error: Invalid path $path" >&2 # Print error
  exit 1 # Exit with error
fi

