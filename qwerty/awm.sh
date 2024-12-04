#!/bin/bash

NAME="Chyngyz"
echo "Привет, $NAME"

read -p "Первое число: " NUM
read -p "Второе число: " NUMBER

SUM=$((NUMBER + NUM))

echo "Ответ $NUMBER + $NUM = $SUM"
echo $((NUMBER+NUM))
