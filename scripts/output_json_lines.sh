#!/bin/bash
# Script to output the JSON array line by line to stdout

json_array='[ "line1", "line2", "line3" ]'  # Replace this with your actual JSON array

cat "$json_array" | jq -r '.[]' > output.adoc

