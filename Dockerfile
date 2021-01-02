FROM archlinux/base:latest AS build_image

RUN pacman -Sy tup nginx git nodejs-lts-fermium npm sassc python3 python-pip --noconfirm && (yes | pacman -Scc || :)

WORKDIR /site/pianistica

# init npm as separate step, for better caching
ADD package.json package.json
ADD package-lock.json package-lock.json
RUN npm install

ADD . .

RUN python3 -m pip install -r requirements.txt && \
    tup init && \
    tup generate build.sh && \
    sed -i.bak '2iset -o xtrace' build.sh && \
    ./build.sh && \
    rm -r node_modules .tup

FROM nginx:1.17.6-alpine as final_image
WORKDIR /site/pianistica
COPY --from=build_image /site/pianistica/static /site/pianistica/static
COPY --from=build_image /site/pianistica/serverless /site/pianistica/serverless
COPY --from=build_image /site/pianistica/mime.types /site/pianistica/mime.types

ENTRYPOINT nginx -c /site/pianistica/serverless/nginx.conf
