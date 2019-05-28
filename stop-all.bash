#!/bin/bash

kill -9 `ps -ef | grep platinumd | grep instance | awk '{print $2}' | xargs`
