# Init Mongo Replica Set

This repo contains the script to inititiate a Mongo Replica set deployed in Railway from a template.

To deploy your own Mongo replica set in Railway, just click the button below!

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/template/ha-mongo)

For even more information, check out the tutorial in Railway:  [Deploy and Monitor a MongoDB Replica Set](https://docs.railway.app/tutorials/deploy-and-monitor-mongo)

### About the Init Service
The init service is used to execute the required command against MongoDB to initiate the replica set.  Upon completion, it deletes itself via the Railway public API.

## Example Apps

Included in this repo are some example apps to demonstrate how to connect to the replica set from a client.
- [Node app](/exampleApps/node/)
- [Python app](/exampleApps/python/)

## TODO

Currently, the replica set has auth disabled by default.  

We intend to update the template and script to deploy a [replica set with a keyfile for auth](https://www.mongodb.com/docs/manual/tutorial/deploy-replica-set-with-keyfile-access-control/) in the near future
