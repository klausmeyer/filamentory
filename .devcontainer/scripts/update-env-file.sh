#!/usr/bin/env bash

awk '{ print toupper($1) "_VERSION=" $2 }' < .tool-versions > .devcontainer/.env
