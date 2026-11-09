FROM node:18-alpine

WORKDIR /result

COPY package*.json ./

RUN npm install

USER node

COPY --chown=node:node . /result/

EXPOSE 8888

CMD ["npm", "start"]