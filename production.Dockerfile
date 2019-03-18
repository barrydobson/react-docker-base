FROM node:10.15.3-alpine as build-deps

WORKDIR /usr/src/app
RUN npm install react-scripts@2.1.8 -g --silent

COPY ./react-app/package.json ./react-app/yarn.lock ./

RUN yarn
COPY ./react-app/ ./
RUN CI=true npm test
RUN yarn build

FROM nginx:1.15.9-alpine
ARG CLIENT_ENVIRONMENT=local
ENV CLIENT_ENVIRONMENT="${CLIENT_ENVIRONMENT}"
COPY ./config/nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY ./lib/launch-prod.sh ./
RUN chmod +x launch-prod.sh
COPY config/client-side /usr/share/nginx/config/
COPY --from=build-deps /usr/src/app/build /usr/share/nginx/html
EXPOSE 80
CMD ./launch-prod.sh