# Social Media Tracker Middleware

This is a system to provide a websocket interface to Kafka Stream aggregation pipelines. It exposes a TCP socket server on a configurable port using environment variables where Streams are expected to `push` JSON data. This data is then broadcast to all subscribing websockets. The only required variable in the JSON payload is a `type` declaration. This is used to subscribe websocket connections to message types.

The websocket connection can subscribe to different message types by passing the `?filters={type1},{type2},etc` query string on initial connection.

Before running `docker-compose build` make sure to set the variables in `default.env` and `docker.env` match and run `$ source default.env`

In your deployment the environment variable file names will probably vary, the ones here are given only as examples for configuration.
