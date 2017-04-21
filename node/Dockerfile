# e.g. turnsallyear/node
FROM cmosetick/alpine-dumb-init:node-6.10
LABEL "maintainer Chris Mosetick <cmosetick@gmail.com>"

# dir where the actual front end code for the site lives
COPY site /site

RUN \
cd /site && \
yarn install && \
yarn global add serve

ENTRYPOINT ["/usr/bin/dumb-init","--"]
CMD ["serve","-p","6000","/site"]
