FROM node:20.3.1-alpine3.18 AS build

WORKDIR /opt/app
COPY package*.json ./
RUN apk add --no-cache git
RUN npm ci --no-color
COPY . .
RUN npm run build

FROM node:20.3.1-alpine3.18
RUN apk add --no-cache bash zip
WORKDIR /opt/app
COPY --from=build /opt/app/dist ./dist
COPY --from=build /opt/app/node_modules ./node_modules
COPY templates ./templates
COPY build-tpk.sh ./

ENTRYPOINT [ "/opt/app/build-tpk.sh" ]
