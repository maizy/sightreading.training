FROM archlinux/base:latest AS build_image

RUN pacman -Sy tup nginx git npm sassc python3 python-pip --noconfirm && (yes | pacman -Scc || :)

WORKDIR /site/sightreading.training

# init npm as separate step, for better caching
ADD package.json package.json
ADD package-lock.json package-lock.json
RUN npm install

ADD . .

RUN sed -i.bak 's/^.*moon.*//' ./Tuprules.tup && \
    python3 -m pip install -r requirements.txt && \
    tup init && \
    tup generate build.sh && \
    sed -i.bak '2iset -o xtrace' build.sh && \
    ./build.sh && \
    rm -r node_modules .tup

FROM nginx:1.16.1-alpine as final_image
WORKDIR /site/sightreading.training
COPY --from=build_image /site/sightreading.training/static /site/sightreading.training/static
COPY --from=build_image /site/sightreading.training/serverless /site/sightreading.training/serverless
COPY --from=build_image /site/sightreading.training/mime.types /site/sightreading.training/mime.types

ENTRYPOINT nginx -c /site/sightreading.training/serverless/nginx.conf
