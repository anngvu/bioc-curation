#!/bin/bash

# Define variables
EDAM_STABLE_LATEST="https://edamontology.org/EDAM_1.25.owl"
EDAM="edam.owl"


[ ! -f "$EDAM" ] && curl "$EDAM_STABLE_LATEST" -o "$EDAM"

# General preprocessing to remove deprecated + notRecommendedForAnnotation
robot_base_cmd=(
  robot
  --add-prefix "edam: http://purl.obolibrary.org/obo/edam#"
  remove --input "$EDAM"
  --select "owl:deprecated='true'"
  remove --select "http://edamontology.org/notRecommendedForAnnotation='true'"
)

# Get a subset
process_subset() {
  local subset="$1"
  local output_file="$2"

  "${robot_base_cmd[@]}" \
    filter --select "oboInOwl:inSubset=edam:$subset" \
    --select annotations \
    --output "tmp.json"
  
  jq --arg subset "$subset" '{ ($subset): [.graphs[].nodes[].lbl] }' "tmp.json" > subsets/edam_"$subset".json
}

# Process the subsets
process_subset "formats" 
process_subset "topics"
process_subset "operations"
process_subset "data"

jq -s 'add' subsets/*.json > enums.json
