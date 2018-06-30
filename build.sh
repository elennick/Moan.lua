#!/bin/bash
echo "Starting..."
rm -rf src/
mkdir src
moonc -t src .
cp -R assets src/assets/
love src &

exit 0
