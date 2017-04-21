# based on https://github.com/tutumcloud/mongodb/blob/master/3.2/Dockerfile
# which is supposed to be deprecated soon, according to their readme file.
# therefore this image is mostly identical, but tracks Ubuntu 16.04 instead.

FROM ubuntu:16.04
LABEL "maintainer Chris Mosetick <cmosetick@gmail.com>"
ENV DEBIAN_FRONTEND noninteractive

RUN \
sed -i 's@http://archive.ubuntu.com/ubuntu/@http://ubuntu.osuosl.org/ubuntu@g' /etc/apt/sources.list

RUN \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list && \
    apt-get update && \
    apt-get install -y --force-yes nano pwgen mongodb-org mongodb-org-server mongodb-org-shell mongodb-org-mongos mongodb-org-tools && \
    echo "mongodb-org hold" | dpkg --set-selections && echo "mongodb-org-server hold" | dpkg --set-selections && \
    echo "mongodb-org-shell hold" | dpkg --set-selections && \
    echo "mongodb-org-mongos hold" | dpkg --set-selections && \
    echo "mongodb-org-tools hold" | dpkg --set-selections

VOLUME /data/db

ENV AUTH yes
ENV STORAGE_ENGINE wiredTiger
ENV JOURNALING yes

COPY run.sh /run.sh
COPY set_mongodb_password.sh /set_mongodb_password.sh

EXPOSE 27017 28017

CMD ["/run.sh"]

# docker run --name mongo -d -p 27017:27017 -p 28017:28017 -e MONGODB_USER=mongo -e MONGODB_DATABASE1=stuff1 -e MONGODB_DATABASE2=stuff2 -e MONGODB_PASS=cooldudes turnsallyear/mongo:run
