<!-- omit in toc -->
# Examen Primera Evaluación: Ejercicio 2

Luis Ferrer Manero

<!-- omit in toc -->
## Resumen
Realizamos un script con bash para modificar el archivo ```/etc/hosts/``` en función de los parámetros que introducimos al ejecutarlo.

<!-- omit in toc -->
## Palabras clave
* Bash
* Script
* Código
* Condicional
* Archivo

<!-- omit in toc -->
## Índice

- [Introducción](#introducción)
- [Código inicial](#código-inicial)
- [Apartado 1: Caso de 2 parámetros](#apartado-1-caso-de-2-parámetros)
- [Apartado 2: Caso de 3 parámetros](#apartado-2-caso-de-3-parámetros)
- [Conclusión](#conclusión)

## Introducción

En este ejercicio vamos a crear un scipt con el lenguaje *bash* que modifique el contenido del archivo /etc/hosts según los parámetros que le pasemos al ejecutarlo.

## Código inicial

Antes que nada, vamos a diferenciar los casos que podemos tener a la hora de ejecutar el script. Vamos a crear condiciones para cuando tengamos 1, 2 o 3 argumentos, y que se ejecute un código diferente en cada caso.
```
#/bin/bash
if [ $# -eq 1 ]
then
    #1 parametro

elif [ $# -eq 2 ]
then
    #2 parametros
    
elif [ $# -eq 3 ]
then
    #3 parametros

else
    echo "Número de parámetros incorrecto"
fi
```

## Apartado 1: Caso de 2 parámetros

El código de este apartado se va a introducir dentro del condicional que comprueba que haya dos parámetros a la hora de ejecutar el script.

El primer paso va a ser crear las variables que contengan los parámetros introducidos:
```
enable=$1
direccion=$2
```
Y entonces distinguir si el primer parámetro es *enable* o *disable*:
```
if [ "$enable" == "enable" ]
    then

elif [ "$enable" == "disable" ]
then

fi
```
En el caso que el primer parámetro sea *enable*, tenemos que buscar la dirección en el archivo, si la encontramos, cambiar su ip a ```127.0.0.1```, y si no la encontramos, añadirla al final del archivo:

Usamos un bucle para recorrer las filas del archivo y buscar la dirección que hemos introducido como parámetro. Y si encontramos una coincidencia sustituimos la ip actual por la nueva:
```
archivo="/etc/hosts"
localhost="127.0.0.1"
encontrado=$false
while IFS= read -r line
    do
        linea=( $line )
        if [[ "$direccion" == ${linea[1]} ]]
        then
            sudo sed -i "s/$line/$localhost ${linea[1]}/" $archivo
            encontrado=$true
        fi
    done < "$archivo"
```

En el caso de que no encuentre la dirección, la introducimos al final del archivo:
```
if [ "$encontrado" -eq 0 ]
    then
        append="$localhost $direccion"
        echo "$append" | sudo tee -a $archivo
    fi
```

Y en el caso de que el primer parámetro sea *disable*, borramos la línea que contenga la dirección introducida:
```
while IFS= read -r line
    do
        linea=( $line )
        if [[ "$direccion" == ${linea[1]} ]]
        then
            sudo sed -i "/$line/d" $archivo
        fi
    done < "$archivo"
```

## Apartado 2: Caso de 3 parámetros

Si tenemos 3 parámetros tenemos que realizar el mismo procedimiento que con 2, pero utilizando la ip que introducimos si indicamos *enable*, y cambiando a ```127.0.0.1``` si introducimos *disable*:
```
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
```


## Conclusión

Bash es un lenguaje con una sintaxis parecida a la que hemos visto anteriormente en otros lenguajes de programación, pero con ciertas peculiaridades que hacen complicado trabajar con él al principio.