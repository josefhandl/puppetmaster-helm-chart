#!/bin/bash

docker run --user 999:999 --cap-drop ALL -h "playground.internal" --rm -it -p 8140:8140 --name=ps ps /bin/bash

