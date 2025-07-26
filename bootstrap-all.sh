#!/usr/bin/env bash

if command -v slimdot >/dev/null 2>&1; then 
    slimdot all
else 
    curl -sSL "https://raw.githubusercontent.com/bchirva/slimdot/master/slimdot" | bash -s -- all 
fi

