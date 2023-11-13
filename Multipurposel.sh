#!/bin/bash
#########################################################################################
# James Thrasher                                                                    
# IS 580                                                                            
#  This program searches all log files in a directory for Failed User attempted logins                                                                    
# - DJ                                                                             
# - Group collaboration                                                           
# #########################################################################################


# Set the log directory from the command line argument.
var1="$1"
var2="$2"
var3="$3"
var4="$4"
# The repeated function essentialy expands the variable $output_file when selected. It does this by searching for repeated messages and expands adds them to the file 
repeated() {
  #cat "$output_file"
  count=$(grep -i "message repeated" "$output_file" | sed 's/  / /' | cut -d ' ' -f8)
  #echo "Count: $count"
  message=$(grep -i "message repeated" "$output_file" | sed 's/  / /' | cut -d ' ' -f1-5,11-19)

  for ((i=1; i<=count; i++)); do
      echo -n "$message" >> "$output_file"
  done
  #echo "processing complete"
    # Remove the "message repeated" lines from the original output file. By editing the file in place remove lines containing message repeated
  sed -i '/message repeated/d' "$output_file" > /dev/null 2>&1
  return $output_file
} > /dev/null 2>&1 









format(){
  echo "#############################################################################################################"
  echo "#############################################################################################################"
  echo "#############################################################################################################"
  echo "#############################################################################################################"
  echo "#############################################################################################################"
}

#this function solves the first problem listed by searching for invalid user and giving the number of connection attempts from ip's but removing non connection attempts.
#T
ipc() {
  #repeated
  cat "auth.log" | grep -in "Invalid User" | grep -v "Failed password for" | grep -v "Connection closed by" | grep -v "Disconnected from" | sed 's\   \_\' | cut -d ' ' -f10 | sort | uniq -c| awk  '$1 >5' | sort -rn}

# this is done by replacing double spaces with a single space using the sed command. Using grep -v to search for lines without the phrase failed password.using sed again to repalce three spaces with an underscore. THen It pulls out items after space 11 sorts it counts it 
# and reverses the sort by the highest number to lowest. THen awk is used to only keep numbers higher than 5


# I do essentially the same process for each attempt.
failedmessage() {
    
    cat "$output_file" | grep -i 'failed password' | grep -i "root" | sed 's/  / /' | cut -d " " -f 11,9 | sort | uniq -c | sort -rn 
}
#



usernames() {
    
    cat "$output_file" | grep -i "failed password for invalid user" | sed 's\  \ \' | grep -v Disconnected | grep -v closed | cut -d " " -f 11| sort | uniq -c | awk -b '$1 > 5' | sort -rn 
}



allIP(){
  
  cat "$output_file" | grep -E -o '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b' | sort | uniq | sort -n -k 1,1

}





is_valid_ip() {
  local ip="$1"
  if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    IFS="." read -ra parts <<< "$ip"
    for part in "${parts[@]}"; do
      if ((part < 0 || part > 255)); then
        return 1  # Invalid IP
      fi
    done
    return 0  # Valid IP
  else
    return 1  # Invalid IP
  fi
}

is_username_hostname() {
  local input="$1"
  if [[ $input =~ ^[a-zA-Z0-9_.-]+@[a-zA-Z0-9.-]+$ ]]; then
    return 0  # Valid username@hostname format
  else
    return 1  # Invalid format
  fi
}
checkos(){
  os=$(cat /etc/os-release | grep -oP '\bNAME="\K[^"]+'}| cut -d ' ' -f0 )
}
checkosserver(){
  # the \b is a word boundary the \K operator resets the match and the '[^"] captures the value enclosed 
  os=$(sshpass -p "$password" ssh "$userhost" -qt cat /etc/os-release | grep -oP '\bNAME="\K[^"]+'}| cut -d ' ' -f1 )
   
}


downloadlogs(){

  if [[ "$os" == "Fedora" || "$os" == "Red Hat" ]]; then
    ifrh
  else
    ifDebian  
  fi


}



ifrh(){
  
  download_directory=/var/log
  file= "$script_dir/$userhost.log"
  "scp -r $download_directory/*" "$script_dir"


  command=mv "$script_dir/log" "$file"

}
ifDebian(){

  download_directory=/var/log
  file= "$script_dir/$userhost.log"

  "scp -r $download_directory/*" 
  command=mv "$script_dir/log" "$file"
}
connectssh(){

  userhost="$var1"
  password="$var2"
  echo "Connecting To: $var1"
  #call check os
  checkosserver
 
  echo "Operating System: $os"
  
  
  
  #sshpass -p 'L3T"5dothis!' ssh "$userhost" -qt "$command"
  #ssh "$userhost" -qt "$command"
  #scp -r -oPassword="$password" "$userhost":/var/log .
  sshpass -p "$password" scp -r "$userhost":/var/log .


}




process_logclass(){
  log_dir=$var1
  script_dir=$(dirname "$0")
  if [[ "$log_dir" == *.gz ]]; then
            zcat "$log_dir" >> "$script_dir/$(basename ${log_dir%.gz}).expanded.txt.tmp"
        else
            cat "$log_dir" >> "$script_dir/$(basename ${log_dir%.log}).expanded.txt.tmp"
        fi
       
        output_file="$script_dir/$(basename ${log_dir%.log}).expanded.txt.tmp"
        expanded_file="$script_dir/$(basename ${log_dir%.log}).expanded.txt"
        final_file="$script_dir/$(basename ${log_dir%.log}).filtered.txt"


        
        
        repeated 

        
        
        

        echo " All Unique IP's in Log file " > $final_file
        allIP >> $final_file
        echo " " >> $final_file
        format >> $final_file
        echo " " >> $final_file
        echo "All Failed login Attemp Usernames" >> $final_file
        echo " " >> $final_file
        usernames >> $final_file
        echo ' ' >> $final_file
        format >> $final_file
        echo " " >> $final_file       
        echo "Number of IP failed logins" >> $final_file
        ipc >> $final_file
       
        rm "$output_file"
        rm "$expanded_file"

}




rm "$output_file"

process_logdirectory() {
    log_dir="$1"  # Set your log directory here (e.g., var1="/path/to/logs")

    script_dir=$(dirname "$0")

    for file in "$log_dir"/*.log "$log_dir"/*.gz; do
        if [ -f "$file" ]; then
            if [[ "$file" == *.gz ]]; then
                # If it's a gzipped file, use zcat
                zcat "$file" >> "$script_dir/$(basename ${file%.gz}).expanded.txt.tmp"
            else
                # If it's not gzipped, simply copy it to .expanded.txt
                cat "$file" >> "$script_dir/$(basename ${file%.log}).expanded.txt.tmp"
            fi

            output_file="$script_dir/$(basename ${file%.log}).expanded.txt.tmp"
            expanded_file="$script_dir/$(basename ${file%.log}).expanded.txt"
            final_file="$script_dir/$(basename ${file%.log}).filtered.txt"

          
            repeated >> "$expanded_file"
            echo " All Unique IP's in Log file " > "$final_file"
            allIP >> "$final_file"
            echo " " >> "$final_file"
            format >> "$final_file"
            echo " " >> "$final_file"
            echo "All Failed login Attempt Usernames" >> "$final_file"
            echo " " >> "$final_file"
            usernames >> "$final_file"
            echo ' ' >> "$final_file"
            format >> "$final_file"
            echo " " >> "$final_file"       
            echo "Number of IP failed logins" >> "$final_file"
            ipc >> "$final_file"

            rm "$output_file"  # Remove the specified file
            rm "$expanded_file"
          
        fi
    done
}





main(){
  script_dir=$(dirname "$0")
  if is_username_hostname "$var1"; then
    connectssh
  else
    if [ -d "$var1" ]; then
      process_logdirectory "$var1" 
    else [ -f "$var1" ]
      process_logclass "$var1"
    fi
  fi
}

# Call the main function
main
