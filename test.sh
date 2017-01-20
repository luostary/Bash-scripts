#!/bin/bash


# Параметры
range=$1 # присваиваем переменной range значение параметра скрипта
step=0
count=1


# Выполнение
if [[ $range  == '' ]]
then
    echo 'Не указан параметр при запуске скрипта'
    echo "Пример: $ $BASH_SOURCE '107, 126, 145'"
    exit
fi
echo "Вы запустили скрипт с параметром '$range'"
IFS=',|.|-|:' read -a formattedRange <<< $range
for i in $formattedRange
do
    if [[ $i =~ ^([0-9]{1,})$ ]]; then
        arr[$count]=$i
        count=$(($count+1))
    else
        arr=()
        break
    fi

done
count=1
for key in ${!arr[@]}; do
    nextKey=$(($key + 1))
    if [[ ${arr[$nextKey]} != '' ]]; then
        if [[ $count == 1 ]]; then
            step=$((${arr[$nextKey]} - ${arr[$key]}))
            echo "Шаг прогрессии: $step"
        fi

        if [[ ${arr[$nextKey]} != $((${arr[$key]} + $step)) ]]; then
            echo 'Строка не является правильной прогрессией'
            exit
        fi
    fi
    count=$(($count+1))
done
if [[ $step -gt 0 ]]; then
    echo "Строка является правильной возрастающей прогрессией"
elif [[ $step -eq 0 ]]; then
    echo "Строка не является прогрессией"
else
    echo "Строка является правильной убывающей прогрессией"
fi
