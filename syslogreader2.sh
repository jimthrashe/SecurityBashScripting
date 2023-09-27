#!/bin/bash

#Logs in Log File
##########################
#Assignmetn 3
#Read Files in a directory
#
#Resources <BS>https://www.redhat.com/en/blog/speculative-store-bypass-explained-what-it-how-it-works /09/07/2023 3:38
#https://chat.openai.com/ I searched for the grep filter because mine was not working 
#https://linuxhint.com/bash_conditional_statement/ Conditional statements
###########################

#h=0
#file=$1
#search for pattern
#if grep -i "Speculative-Store-Bypass: Vulnerable" "$file"; then
  #echo'System Vulnerable'
#else
  #echo 'Not Vulnerable'
#fi

h=0
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

directory="$1" #introduce directory 

if [ ! -d "$directory" ]; then
    echo "Directory '$directory' does not exist."
    exit 1
fi


for file in "$directory"/*; do
  if [[ "$file" == *.gz ]]; then
    content=$(zcat "$file" 2>/dev/null | tr -d '\000') #used gpt to remove null byte statement gave tr -d \'000' 
  else
    content=$(cat "$file" 2>/dev/null | tr -d '\000')
  fi



  if echo "$content" | grep -qi "Speculative-Store-Bypass: Vulnerable"; then
    echo "File '$file' is Vulnerable"
  else
    echo "File '$file' is not Vulnerable"
  fi
done


#9/12/2023 searching syslog* for ip connections
#zgrep -i dhcprequest syslog* | head | cut -d ' ' -f 8,12
#add
