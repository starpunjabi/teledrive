
FROM node:16.14.0 as build

# Add ARGs for the required environment variables
# Fix typo in the ARG name
ARG ARG1=3820024
ARG ARG2=c036139b9fdbc2d2044d8bdf21cb335e

WORKDIR /apps

# Copy package.json and yarn.lock files separately to take advantage of Docker's layer caching
COPY yarn.lock .
COPY package.json .

# Copy package.json files for api and web directories
COPY api/package.json api/
COPY web/package.json web/

# Copy the .env file
COPY dockerenv/. .

# Clean yarn cache
RUN yarn cache clean

# Install dependencies
# Remove "--network-timeout 1000000" argument from yarn install command
RUN yarn install

# Copy the entire project directory
COPY . .

# Run build command for all the workspaces
RUN yarn workspaces run build

# Add new line to expose port 3000
EXPOSE 3000
