FROM archlinux/base:latest

RUN pacman -Sy base-devel lua51 luajit luarocks tup nginx git npm discount sassc --noconfirm && (yes | pacman -Scc || :)

# setup lua (TODO: remove, need only for static/guides compilation)
RUN luarocks --lua-version=5.1 install moonscript && \
    luarocks --lua-version=5.1 install discount && \
    luarocks --lua-version=5.1 install lua-cjson
RUN eval $(luarocks --lua-version=5.1 path)

WORKDIR /site/sightreading.training

# init npm as separate step, for better caching
ADD package.json package.json
ADD package-lock.json package-lock.json
RUN npm install

ADD . .

RUN sed -i.bak 's/^.*moon.*//' ./Tuprules.tup && \
    tup init

RUN tup generate build.sh && \
    sed -i.bak '2iset -o xtrace' build.sh

RUN ./build.sh

ENTRYPOINT nginx -c /site/sightreading.training/serverless-nginx.conf
