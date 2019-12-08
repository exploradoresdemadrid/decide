#!/usr/bin/env bash

existing_doc_hash=$(md5sum public/open_api/swagger_doc.json | cut -d' ' -f1)

rails runner OpenApi.write_docs

updated_doc_hash=$(md5sum public/open_api/swagger_doc.json | cut -d' ' -f1)

if [ "$existing_doc_hash" == "$updated_doc_hash" ]; then
    exit 0
else
    echo "Existing API documentation needs to be updated. Please run \"rails runner OpenApi.write_docs\" and commit new documentation."
    exit 1
fi

exit 1