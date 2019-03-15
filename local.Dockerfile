FROM node:10.15.3-alpine

RUN mkdir /usr/src && mkdir /usr/src/app
WORKDIR /usr/src/app

ENV PATH /usr/src/app/node_modules/.bin:$PATH

COPY ./react-app/package.json ./react-app/yarn.lock ./

RUN yarn install
RUN npm install react-scripts@2.1.8 -g --silent

# start app
CMD ["npm", "start"]