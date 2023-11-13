#!/bin/bash
#########################################################################################
# James Thrasher                                                                    #
# IS 580                                                                            #
# This script completes all the tasks required for the canvas assignment              #
# Resources:                                                                        #
# - DJ                                                                             #
# - Group collaboration                                                           #
# - Google                                                                        #
# - ChatGPT to clean up my code because I have more typos than anyone else I know  #
# I changed my program because of what we did in class made my program limited in number, and I find this approach simpler to recreate in a pentest #
#########################################################################################


# Set the log directory from the command line argument.
log_dir="$1"
# The repeated function essentialy expands the variable $output_file when selected. It does this by searching for repeated messages and expands adds them to the file 
repeated() {
    count=$(grep -i "message repeated" "$output_file" | sed 's/  / /' | cut -d ' ' -f6)
    message=$(grep -i "message repeated" "$output_file" | sed 's/  / /' | cut -d ' ' -f5,11-)
    for ((i=1; i<=count; i++)); do
        echo "$message" >> "$output_file"
    done
    # Remove the "message repeated" lines from the original output file. By editing the file in place remove lines containing message repeated
    sed -i '/message repeated/d' "$output_file" > /dev/null 2>&1
} > /dev/null 2>&1

#this function solves the first problem listed by searching for invalid user and giving the number of connection attempts from ip's but removing non connection attempts.
ipc() {
    repeated
    cat "$output_file" | grep -in "Invalid User" | grep -v "Failed password for" | grep -v "Connection closed by" | grep -v "Disconnected from"| sed 's\   \_\' | cut -d ' ' -f10 | sort| uniq -c | sort -rn > "$output_file"
# this is done by replacing double spaces with a single space using the sed command. Using grep -v to search for lines without the phrase failed password. THen It pulls out items after space 11 sorts it counts it and reverses the sort by the highest number to lowest.
}
#> /dev/null 2>&1 # sending the stdout to /dev/null to keep it from printing 

# I do essentially the same process for each attempt.
failedmessage() {
    repeated
    cat "$output_file" | grep -i 'failed password' | grep -v 'message repeated' | grep -i "root" | sed 's/  / /' | cut -d " " -f 11,9 | sort | uniq -c | sort -rn > "$output_file"
}> /dev/null 2>&1 #sending the stdout to /dev/null to keep it from printing 


ubuntu() {
    repeated
    cat "$output_file" | grep -i "ubuntu" | grep -i "failed password" | sort | sed 's\  \ \' | cut -d ' ' -f 11| sort | uniq -c | sort -rn > "$output_file"
}> /dev/null 2>&1 # sending the stdout to /dev/null to keep it from printing 


usernames() {
    repeated
    cat "$output_file" | grep -i "failed password for invalid user" | sed 's\  \ \' | grep -v Disconnected | grep -v closed | cut -d " " -f 11| sort | uniq -c | sort -rn > "$output_file"
}> /dev/null 2>&1 #sending the stdout to /dev/null to keep it from printing 


# Process log files in the specified directory
process_logs() {
    for file in "$log_dir"/*.log "$log_dir"/*.gz; do
        if [ -f "$file" ]; then
            if [[ "$file" == *.gz ]]; then
                # If it's a gzipped file, use zcat
                zcat "$file" >> "${file%.gz}.expanded.txt"
            else
                # If it's not gzipped, simply copy it to .expanded.txt
                cat "$file" >> "${file%.log}.expanded.txt"
            fi

            output_file="${file%.log}.expanded.txt"

            # Allow user to select a function from above to execute.
            while true; do
                echo "Select a function:"
                echo "1. Unique invalid Username"
                echo "2. Failed root"
                echo "3. Ubuntu"
                echo "4. Username list"
                echo "5. Exit"

                read -p "Enter your choice: " choice
                
                case $choice in
                    1)
                        ipc
                        ;;
                    2)
                        failedmessage
                        ;;
                    3)
                        ubuntu
                        ;;
                    4)
                        usernames
                        ;;
                    5)
                        echo "Exiting script."
                        exit 0
                        ;;
                    *)
                        echo "Invalid choice. Please select 1, 2, 3, 4, or 5."
                        ;;
                esac
            done
        fi
    done
}

# Call the process_logs function
process_logs

