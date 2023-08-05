FROM node:16-alpine

ENV LOCAL_DIR=/app
ENV TEMP_CLIENT_PATH=$LOCAL_DIR/client
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
COPY app/server/src $BUILD_PATH
COPY app/server/package*.json $BUILD_PATH

WORKDIR $BUILD_PATH

# Install server dependencies and remove package* files
RUN npm install --prod --no-audit --no-fund && rm -rf ./package*

WORKDIR $TEMP_CLIENT_PATH

# Copy client files to temporary directory
COPY app/client/config config
COPY app/client/public public
COPY app/client/scripts scripts
COPY app/client/src src
COPY app/client/package*.json .

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

# FROM nginx:alpine
# COPY --from=app /app/build /usr/share/nginx/html
# COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# EXPOSE 80

# CMD ["nginx", "-g", "daemon off;"]
