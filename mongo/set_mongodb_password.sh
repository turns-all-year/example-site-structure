#!/bin/bash

USER=${MONGODB_USER:-"admin"}
DATABASE1=${MONGODB_DATABASE1:-"admin"}
DATABASE2=${MONGODB_DATABASE2:-"admin"}
PASS=${MONGODB_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${MONGODB_PASS} ] && echo "preset" || echo "random" )

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MongoDB service startup"
    sleep 5
    mongo admin --eval "help" >/dev/null 2>&1
    RET=$?
done

echo "=> Creating an ${USER} user with a ${_word} password in MongoDB"
mongo admin --eval "db.createUser({user: '$USER', pwd: '$PASS', roles:[{role:'root',db:'admin'}]});"
db.createUser({user: 'admin', pwd: '$PASS', roles:[{role:'root',db:'admin'}]})

# db1
if [ "$DATABASE1" != "admin" ]; then
    echo "=> Creating an ${USER} user with a ${_word} password in MongoDB"
    mongo admin -u $USER -p $PASS << EOF
use $DATABASE1
db.createUser({user: '$USER', pwd: '$PASS', roles:[{role:'dbOwner',db:'$DATABASE1'}]})
EOF
fi

# db2
if [ "$DATABASE2" != "admin" ]; then
    echo "=> Creating an ${USER} user with a ${_word} password in MongoDB"
    mongo admin -u $USER -p $PASS << EOF
use $DATABASE2
db.createUser({user: '$USER', pwd: '$PASS', roles:[{role:'dbOwner',db:'$DATABASE2'}]})
db.createCollection("header_cache")
db.header_cache.ensureIndex({"insertDate":1}, { expireAfterSeconds: 120 })
EOF
fi

echo "=> Done!"
touch /data/db/.mongodb_password_set

echo "=========================================================================================="
echo "You can now connect to this MongoDB server using:"
echo ""
echo "    mongo $DATABASE -u $USER -p $PASS --host <host> --port <port>"
echo ""
echo "Please remember to change the above password if you did not set one at container run time "
echo "=========================================================================================="
