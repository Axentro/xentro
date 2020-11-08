#!/bin/sh

rm -rf dist
mint build --skip-icons --skip-service-worker
rm -rf release
mv dist release

