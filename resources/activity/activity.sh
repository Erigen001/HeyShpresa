ADATA=$(curl --silent "https://www.boredapi.com/api/activity" | jq .)

ACTIVITY_TYPE=$(echo $ADATA | jq .type)
ACTIVITY=$(echo $ADATA | jq .activity)

echo "As a $ACTIVITY_TYPE activity, you could $ACTIVITY :) "
