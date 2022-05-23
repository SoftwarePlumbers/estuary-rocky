# docker-estuary

Multi-stage build that:

* Builds estuary from source
* Runs estuary with conservative configuration options with respect to network usage

To configure the container, edit the files `etc/estuary/config.json` and `etc/estuary-shuttle/config.json` in this repository, or bind-mount different versions into the container.

The container entrypoint expects a single command, which will be one of:

* `estuary` (default) - runs a primary estuary node
* `shuttle` - runs an estuary shuttle node
* `init` - intializes an estuary node, generating the database and admin token, then terminates
* `register` - registers a shuttle with a running estuary node, then terminates

The supplied docker-compose.yml runs a primary node and single shuttle, using the 'init' and 'register' commands to perform all the necessary initialization.






