#!/bin/bash
set -euo pipefail
pushd $(dirname "$0")/..

export WORLD_ADDRESS="0x9b501a522a8d26886ef604bc0b8bf9b12ffcdf88adadc0e6e575f6271c6bde";

# enable system -> component authorizations

COMPONENTS=("Claim" "GameConfig" "Item" "ItemPrototype" "Name" "OwnedBy" "Position" "PositionOccupation" "Recipe" "RecipeReverseLookup" "Stake")
SYSTEMS=("Build" "Craft" "MakeStake" "Transfer" "MakeClaim" "AddName" "Occurence" "Mine" "Init" "Init2" "CreativeBuild " "BulkStake" "BulkTransfer")

for system in ${SYSTEMS[@]}; do
    for component in ${COMPONENTS[@]}; do
        echo "Setting authorization for $system -> $component"
        sozo auth writer $component $system --world $WORLD_ADDRESS
    done
done

echo "Default authorizations have been successfully set."