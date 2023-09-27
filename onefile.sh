#!
###########################
#Assignmetn 3
#Read Files in a directory
#
#Resources <BS>https://www.redhat.com/en/blog/speculative-store-bypass-explained-what-it-how-it-works /09/07/2023 3:38
#https://chat.openai.com/ I searched for the grep filter because mine was not working 
#https://linuxhint.com/bash_conditional_statement/ Conditional statements
###########################

h=0
file=$1
#search for pattern
if grep -i "Speculative-Store-Bypass: Vulnerable" "$file"; then
  echo'System Vulnerable'
else
  echo 'Not Vulnerable'
fi

