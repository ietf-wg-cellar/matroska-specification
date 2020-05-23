#!/bin/bash

xsltproc \
  --stringparam GitRevision "$(git --no-pager log '--format=format:%h @ %ai' HEAD~..HEAD)" \
  transforms/ebml_schema2spec.xsl \
  ebml_matroska.xml
