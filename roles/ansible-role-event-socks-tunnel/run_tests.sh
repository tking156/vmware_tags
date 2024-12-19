#!/bin/sh

chmod 0600 tests/id_rsa

docker-compose -f tests/docker-compose.yml up -d

export JH1_SSH_PRIVATE_KEY=`pwd`/tests/id_rsa
export JH2_SSH_PRIVATE_KEY=`pwd`/tests/id_rsa
export JH3_SSH_PRIVATE_KEY=`pwd`/tests/id_rsa
export JH4_SSH_PRIVATE_KEY=`pwd`/tests/id_rsa
export JH5_SSH_PRIVATE_KEY=`pwd`/tests/id_rsa

ansible-playbook -i tests/inventory.yml tests/test.yml "$@"
return_code=$?

docker-compose -f tests/docker-compose.yml stop

exit $return_code
