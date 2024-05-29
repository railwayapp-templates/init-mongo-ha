#!/bin/bash

# Function to check if MongoDB is up
check_mongo() {
  echo "Checking MongoDB at $MONGO_PRIMARY_HOST:$MONGO_PORT..."
  mongo_output=$(mongosh --host "$MONGO_PRIMARY_HOST" --port "$MONGO_PORT" --eval "db.adminCommand('ping')" 2>&1)
  mongo_exit_code=$?
  echo "MongoDB check exit code: $mongo_exit_code"
  echo "MongoDB check output: $mongo_output"
  return $mongo_exit_code
}

# Function to initiate replica set
initiate_replica_set() {
  echo "Initiating replica set with the following configuration:"
  echo "_id: $REPLICA_SET_NAME"
  echo "Primary member: $MONGO_PRIMARY_HOST:$MONGO_PORT"
  echo "Replica member 1: $MONGO_REPLICA_HOST:$MONGO_PORT"
  echo "Replica member 2: $MONGO_REPLICA2_HOST:$MONGO_PORT"

  mongosh --host "$MONGO_PRIMARY_HOST" --port "$MONGO_PORT" <<EOF
rs.initiate({
  _id: "$REPLICA_SET_NAME",
  members: [
    { _id: 0, host: "$MONGO_PRIMARY_HOST:$MONGO_PORT" },
    { _id: 1, host: "$MONGO_REPLICA_HOST:$MONGO_PORT" },
    { _id: 2, host: "$MONGO_REPLICA2_HOST:$MONGO_PORT" }
  ]
})
EOF
  init_exit_code=$?
  echo "Replica set initiation exit code: $init_exit_code"
  return $init_exit_code
}

# Poll MongoDB until it's up
until check_mongo; do
  echo "Waiting for MongoDB to be up..."
  sleep 2
done

echo "MongoDB is up. Initiating replica set..."

# Initiate replica set and capture result
if initiate_replica_set; then
  echo "Replica set initiated successfully. Executing GraphQL mutation to remove the init service..."

  # Perform GraphQL API mutation
  curl --location "$RAILWAY_API_URL" \
    --header 'Content-Type: application/json' \
    --header "Authorization: Bearer $RAILWAY_API_TOKEN" \
    --data "{\"query\":\"mutation serviceDelete(\$environmentId: String, \$id: String!) { serviceDelete(environmentId: \$environmentId, id: \$id) }\",\"variables\":{\"environmentId\":\"$ENVIRONMENT_ID\",\"id\":\"$SERVICE_ID\"}}"
  
  if [ $? -eq 0 ]; then
    echo "GraphQL mutation executed successfully."
  else
    echo "Failed to delete the service via the API.  Please delete it manually."
  fi
else
  echo "Failed to initiate replica set. Please check the logs for more information."
fi

exit 0
