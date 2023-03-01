FROM node:18-alpine as builder
RUN apk --no-cache add --virtual .builds-deps build-base python3
WORKDIR '/app'
COPY ./package.json ./
RUN npm install --legacy-peer-deps
COPY . .
RUN npm run build

FROM nginx
EXPOSE 8080
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/public /usr/share/nginx/html
#CMD ["tail", "-f","/dev/null"]
CMD ["nginx", "-g", "daemon off;"]