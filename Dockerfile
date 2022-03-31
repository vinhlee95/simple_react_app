# BUILD PHASE
FROM node:17-alpine as builder

# set working direction
WORKDIR /app

# install application dependencies
COPY package.json .
RUN npm i

COPY . . 

RUN npm run build

# RUN PHASE
FROM nginx:alpine

COPY --from=builder /app/build /usr/share/nginx/html
