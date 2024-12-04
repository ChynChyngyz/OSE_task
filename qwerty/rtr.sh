#!/bin/bash

echo "Изменить"
git status --porcelain | awk '{print $2}'