# docker-estuary

Multi-stage build that:

* Builds estuary from source
* Runs estuary with conservative configuration options with respect to network usage

To build the container, run `buildme.sh` and supply the requested build arguments.

To run the container, run `runme.sh` (supply the optional argument 'shuttle'  to run a shuttle).

To configure the container, edit the files `etc/estuary/config.json` and `etc/estuary-shuttle/config.json` in this repository, or bind-mount different versions into the container.




