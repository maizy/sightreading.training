FROM archlinux/base:latest

RUN pacman -Sy base-devel tup nginx git npm sassc python3 --noconfirm && (yes | pacman -Scc || :)

WORKDIR /site/sightreading.training

# init npm as separate step, for better caching
ADD package.json package.json
ADD package-lock.json package-lock.json
RUN npm install

ADD . .

RUN sed -i.bak 's/^.*moon.*//' ./Tuprules.tup && \
    tup init && \
    tup generate build.sh && \
    sed -i.bak '2iset -o xtrace' build.sh && \
    ./build.sh && \
    rm -r node_modules .tup

ENTRYPOINT nginx -c /site/sightreading.training/serverless-nginx.conf
