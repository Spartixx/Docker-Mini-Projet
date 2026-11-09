FROM node:26-alpine AS builder

WORKDIR /result

COPY package*.json ./

FROM builder AS deps-dev

RUN npm install

FROM builder AS deps-prod

ENV NODE_ENV ${NODE_ENV}
RUN npm ci --only=production

FROM builder AS source

USER node

COPY --chown=node:node . .

EXPOSE 8888

CMD ["npm", "start"]

FROM source AS dev
COPY --from=deps-dev /result/node_modules ./node_modules

FROM source AS prod
COPY --from=deps-prod /result/node_modules ./node_modules