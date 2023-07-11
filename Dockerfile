# STAGE 1: Build #

# We label our stage as ‘builder’
FROM ubuntu as builder

RUN apt update -y

#install node and npm
RUN apt install nodejs npm ng-common -y

RUN mkdir ./ng-app

WORKDIR /ng-app

COPY . .

# Build the angular app in production mode and store the artifacts in dist folder
RUN npm install

#build the artifacts
RUN npm run-script build

# Exposing the port to 80
EXPOSE 80

# STAGE 2: Setup #

FROM nginx:1.14.1-alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# From ‘builder’ stage copy over the artifacts in dist folder to default nginx public folder
COPY --from=builder /ng-app/dist /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
