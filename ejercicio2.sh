#!/bin/bash
archivo="/etc/hosts"
localhost="127.0.0.1"
if [ $# -eq 1 ]
then
    #1 parametro
    
elif [ $# -eq 2 ]
then
    #2 parametros
    enable=$1
    direccion=$2
    if [ "$enable" == "enable" ]
    then
        encontrado=0
        while IFS= read -r line
        do
            linea=( $line )
            if [[ "$direccion" == ${linea[1]} ]]
            then
                sudo sed -i "s/$line/$localhost ${linea[1]}/" $archivo
                encontrado=1
            fi
        done < "$archivo"
        if [ "$encontrado" -eq 0 ]
        then
            append="$localhost $direccion"
            echo "$append" | sudo tee -a $archivo
        fi
    elif [ "$enable" == "disable" ]
    then
        while IFS= read -r line
        do
            linea=( $line )
            if [[ "$direccion" == ${linea[1]} ]]
            then
                sudo sed -i "/$line/d" $archivo
            fi
        done < "$archivo"
    fi
elif [ $# -eq 3 ]
then
    #3 parametros
    enable=$1
    direccion=$2
    ip=$3
    if [ "$enable" == "enable" ]
    then
        encontrado=0
        while IFS= read -r line
        do
            linea=( $line )
            if [[ "$direccion" == ${linea[1]} ]]
            then
                sudo sed -i "s/$line/$ip ${linea[1]}/" $archivo
                encontrado=1
            fi
        done < "$archivo"
        if [ "$encontrado" -eq 0 ]
        then
            append="$ip $direccion"
            echo "$append" | sudo tee -a $archivo
        fi
    elif [ "$enable" == "disable" ]
    then
        while IFS= read -r line
        do
            linea=( $line )
            if [[ "$direccion" == ${linea[1]} ]]
            then
                sudo sed -i "s/$line/$localhost ${linea[1]}/" $archivo
            fi
        done < "$archivo"
    fi
else
    echo "Número de parámetros incorrecto"
fi