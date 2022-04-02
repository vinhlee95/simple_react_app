# Build dependencies
#!/bin/bash
FROM node:17-alpine as dependencies

WORKDIR /app

COPY package.json .
RUN npm i

COPY . . 

CMD npm run start

# Build phase
FROM dependencies as builder

RUN npm run build

# Run phase
FROM nginx:alpine

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]