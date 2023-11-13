#!/bin/bash
#########################################################################################
# James Thrasher                                                                        #
# IS 580                                                                                #
#This script takes a log file with lines                                                #
#a result of llog aggregation that say "Message repeated and expands the aggregated logs#
# Resources                                                                             #
# DJ                                                                                    #
#Group collab                                                                                       #
# Google
#      #
#########################################################################################


# I tried to use this script as a base for my program. Finding the number of repeated times in the space after repeated. Then pasting the content after that the number of times repeated.
#zcat syslog.3.gz | grep -i dhcprequest | grep -v 'log aggregation' | grep repeated | cut -d' ' -f9
#2


log_dir="$1"  # Set the log directory from the command line argument.

for file in "$log_dir"/*  # Loop through each file in the specified directory.
do
  output_file="${file%.log}.expanded.txt"  # Define the output file name based on the input file.

  # Search for dhcprequest lines excluding log aggregation and lines with 'repeated.'
  searched=$(zgrep -i dhcprequest "$file" | grep -v 'log aggregation' | grep repeated)

  if [[ $searched =~ (.*)repeated\ ([0-9]+)x(.*) ]]; then
    message=${BASH_REMATCH[1]}  # Extract the message from the matched line.
    count=${BASH_REMATCH[2]}  # Extract the count of repeats from the matched line.
    for ((i=0; i<count; i++)); do
      echo "$message" >> "$output_file"  # Append the message to the output file the specified number of times.
    done
  fi

  non_repeated=$(zgrep -i dhcprequest "$file" | grep -v 'log aggregation' | grep -v repeated)  # Extract non-repeated dhcprequest lines.

  # Append non-repeated lines to the output file.
  echo "$non_repeated" >> "$output_file"
done
