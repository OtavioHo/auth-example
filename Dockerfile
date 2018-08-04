################################################################################
#                                  BASE IMAGE                                  #
################################################################################

# Use official Node's alpine image as base
FROM node:8.11.3-alpine AS base

# Set the path where the files will be stored in the container
ENV MY_PATH=/usr/src/auth-project

# Environment variables for the container network
ENV PORT=8080 \
	HOST=0.0.0.0

# Expose default port to connect with the service
EXPOSE $PORT

# Create the directory defined by $API_PATH (if doesn't exist) and cd into it
WORKDIR $MY_PATH

################################################################################
#                           DEVELOPMENT IMAGE                                  #
################################################################################

# Expanding base image as development image
FROM base AS development

# Set the environment for nodejs
ENV NODE_ENV=development

# Copy package.json and package-lock.json
COPY package.json yarn.lock ./

# Install dependencies
RUN npm install -g nodemon
RUN yarn install

# Copy the application code to the build path
COPY . .

# Define the the default command to execute when container is run
CMD ["nodemon", "index.js"]

################################################################################
#                               BUILDER IMAGE                                  #
################################################################################

# Expanding base image as builder image
FROM base AS builder

# Copy code from the development container
COPY --from=development $MY_PATH ./

# Transpile, minify, uglify and bundle code
RUN yarn build

# Remove all files but the ones listed below (necessary for production)
RUN find * -maxdepth 0 \( \
	-name 'node_modules' -o \
	-name 'package.json' -o \
    -name 'yarn.lock' -o \
	\) -prune -o -exec rm -rf '{}' ';'


################################################################################
#                            PRODUCTION IMAGE                                  #
################################################################################

# Expanding base image as production image
FROM base AS production

# Set the environment for nodejs
ENV NODE_ENV=production

# Copy code from the builder container
COPY --from=builder $MY_PATH ./

# Remove development dependencies
RUN yarn install --frozen-lockfile --ignore-scripts --prefer-offline --force

# Define the the default command to execute when container is run
CMD [ "npm", "start" ]

