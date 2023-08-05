FROM node:16-alpine

ENV LOCAL_DIR=/app
ENV TEMP_CLIENT_PATH=$LOCAL_DIR/client
ENV DATA_DIR=$LOCAL_DIR/data
ENV LOG_DIR=$LOCAL_DIR/logs
ENV BUILD_PATH=$LOCAL_DIR/dist

ENV PUBLIC_URL=http://localhost
ENV SERVER_PORT=3000
ENV SERVER_PUBLIC_URL=$PUBLIC_URL:$SERVER_PORT
ENV DB_HOST=database
ENV DB_PORT=27017

WORKDIR $LOCAL_DIR

# Start with clean slate
RUN rm -rf $BUILD_PATH
# Copy server code to build path
COPY server/src $BUILD_PATH
COPY server/package*.json $BUILD_PATH

WORKDIR $BUILD_PATH

# Install server dependencies and remove package* files
RUN npm install --prod --no-audit --no-fund && rm -rf ./package*

WORKDIR $TEMP_CLIENT_PATH

# Copy client files to temporary directory
COPY client/config config
COPY client/public public
COPY client/scripts scripts
COPY client/src src
COPY client/package*.json .

# Install client dependencies
RUN npm install --production=false --no-audit --no-fund

# Build client app
RUN PUBLIC_URL=$SERVER_PUBLIC_URL \
		BUILD_PATH=$BUILD_PATH/public \
			node ./scripts/build.js

WORKDIR $LOCAL_DIR

# Remove temporary client directory
RUN rm -rf $TEMP_CLIENT_PATH

CMD PORT=$SERVER_PORT MONGODB_URL=mongodb://$DB_HOST:$DB_PORT/todo-app JWT_SECRET=myjwtsecret node $BUILD_PATH/index.js
