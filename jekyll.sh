#!/bin/bash

set -e

jekyll build && jekyll serve --watch
