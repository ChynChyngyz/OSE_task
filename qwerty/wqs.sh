#!/bin/bash

read -p "Первое число: " q
read -p "Второе число: " w

#-gt Больше
#-ge Больше-Равно
#-ne Не равно
#-eq Равно
#-lt Меньше
#-le Меньше равно

if [ $q -le $w ]; then
  echo "123"
elif [ $q -lt $w ]; then
  echo "321"
else
  echo "1"
fi