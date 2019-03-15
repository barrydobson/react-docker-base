FROM node:10.15.3-alpine

RUN mkdir /usr/src && mkdir /usr/src/react-app
WORKDIR /usr/src

RUN npm install -g create-react-app

CMD ["/bin/sh"]