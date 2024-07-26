# to develop locally, pull image from BRIDigital Wifi with no proxy
# docker image pull image-repo.bri.co.id/edm/datahub/base/hasura-engine-cli:latest -u edm

FROM image-repo.bri.co.id/edm/datahub/base/hasura/graphql-engine:v2.41.0.cli-migrations-v3

# Set environment variablessss
# ENV HASURA_GRAPHQL_METADATA_DATABASE_URL postgres://postgres:postgrespassword@host.docker.internal:5432/datahub-hasura-chm
# ENV HASURA_GRAPHQL_ADMIN_SECRET myadminsecretkey
# ENV HASURA_GRAPHQL_ENABLE_CONSOLE true
# ENV HASURA_GRAPHQL_ENABLED_LOG_TYPES startup, http-log, webhook-log, websocket-log, query-log
# Expose the Hasura port

EXPOSE 80
# Start Hasura when the container starts

WORKDIR /app
COPY . .

CMD ["graphql-engine", "serve", "--server-port", "80"]
# CMD ["graphql-engine", "serve"]


# if the docker image is changed, run the command below to build it 
# docker build -t datahub-hasura-chm .

# command to ru  the container locally and delete the container after it exited, and read the environment file from the .env 
# docker run -p 8089:8080 --name datahub-hasura-chm-container --rm --env-file .env datahub-hasura-chm
# (if running in port 8080, check EXPOSE dan CMD command above) 

# how to run metadata-export:
# 1. run the docker using the command above
# 2. update the config.yaml endpoint to the port where docker is running. in this case, the port is 8089 (see docker run above)
# 3. run hasura metadata export --admin-secret "<admin-secret>" .
