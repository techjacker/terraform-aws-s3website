#!/usr/bin/env bash

. '.env'

aws acm request-certificate \
	--region "$REGION" \
	--domain-name "*.$DOMAIN" \
	--subject-alternative-names "$DOMAIN"

acm list-certificates --region "$REGION"



