#!/usr/bin/env bash

. '.env'

if [[ -z $DOMAIN ]]; then
	echo "Must specify bucket/domain in .env file."
	echo "Exiting..."
	exit 1
fi

# s3 rm --recursive s3://example.com/.git

aws s3 sync \
	"src/" "s3://$DOMAIN/"
