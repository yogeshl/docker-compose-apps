FROM node:18.16.0
WORKDIR /usr/src/app

COPY package*.json /usr/src/app/
RUN npm install


COPY . /usr/src/app
EXPOSE 3000
CMD [ "npx", "nodemon", "index.js"]

