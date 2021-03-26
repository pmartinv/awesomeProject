FROM nginx:1.18.0
LABEL maintainer="pmarti20@gmail.com"
ARG VERSION
LABEL build.version=$VERSION
ARG COMMIT
LABEL build.commit=$COMMIT
COPY . /usr/share/nginx/html 
