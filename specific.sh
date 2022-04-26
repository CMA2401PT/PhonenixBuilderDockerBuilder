#!bin/sh
docker run --rm --name="builder" \
    -v ${PWD}/cache/:/root/go \
    -v ${PWD}/start.sh:/root/start.sh \
    -v /Users/dai/Develop/projects/PhoenixBuilderOrig/:/phoenixbuilder \
    -v ${PWD}/output/:/phoenixbuilder/build/ \
    cma2401pt/phoenixbuilder:latest /bin/bash /root/start.sh