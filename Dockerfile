
FROM node:16.14.0 as build

# Add ARGs for the required environment variables
ARG REACT_APP_TG_API_ID
ARG REACT_APP_TG_API_HASH

WORKDIR /apps

# Copy package.json and yarn.lock files separately to take advantage of Docker's layer caching
COPY yarn.lock .
COPY package.json .

# Copy package.json files for api and web directories
COPY api/package.json api/
COPY web/package.json web/

# Copy the .env file
COPY docker/.env .

# Clean yarn cache
RUN yarn cache clean

# Install dependencies
RUN yarn install --network-timeout 1000000

# Copy the entire project directory
COPY . .

# Run build command for all the workspaces
RUN yarn workspaces run build
