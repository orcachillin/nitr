FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npx tsc
RUN npx vite build
RUN npx mikro-orm cache:generate --combined
RUN npm ci --omit=dev && cp -r /app/node_modules /app/node_modules_prod

FROM node:22-alpine
RUN apk add --no-cache postgresql postgresql-client redis supervisor bash

COPY --from=build /app/dist ./dist
COPY --from=build /app/temp ./temp
COPY --from=build /app/node_modules_prod ./node_modules
COPY --from=build /app/package.json ./

COPY docker/supervisord.conf /etc/supervisord.conf
COPY docker/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 3000
ENTRYPOINT ["/entrypoint.sh"]