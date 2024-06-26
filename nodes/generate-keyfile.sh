#!/bin/bash

KEYFILE_PATH="/data/keyfile"

# Check if the keyfile already exists
if [ -f "$KEYFILE_PATH" ]; then
  echo "Keyfile already exists at $KEYFILE_PATH. Skipping keyfile generation."
else
  # Generate the keyfile from the MONGO_KEYFILE_VALUE environment variable
  if [ -z "$MONGO_KEYFILE_VALUE" ]; then
    echo "MONGO_KEYFILE_VALUE environment variable is not set. Exiting."
    exit 1
  fi

  echo "Generating keyfile from environment variable..."
  echo $MONGO_KEYFILE_VALUE > $KEYFILE_PATH
  chmod 600 $KEYFILE_PATH
fi
