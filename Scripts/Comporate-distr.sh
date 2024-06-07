#!/bin/bash

# Две директории для сравнения
dir1="path/to/first/directory"
dir2="path/to/second/directory"

# Функция для сравнения содержимого файлов
compare_files() {
    file1=$1
    file2=$2

    if cmp -s "$file1" "$file2"; then
        echo "Файлы $file1 и $file2 идентичны"
    else
        echo "Файлы $file1 и $file2 отличаются"
    fi
}

# Функция для рекурсивного сравнения содержимого директорий
compare_directories() {
    local subdir1=$1
    local subdir2=$2

    # Перебор всех файлов и поддиректорий в первой директории
    for entry in "$subdir1"/*; do
        name=$(basename "$entry")
        
        if [ -d "$entry" ]; then
            # Если это поддиректория, рекурсивно сравниваем
            if [ -d "$subdir2/$name" ]; then
                compare_directories "$entry" "$subdir2/$name"
            else
                echo "Поддиректория $subdir2/$name отсутствует"
            fi
        elif [ -f "$entry" ]; then
            # Если это файл, сравниваем со всеми файлами во второй директории
            for file2 in "$subdir2"/*; do
                if [ -f "$file2" ]; then
                    compare_files "$entry" "$file2"
                fi
            done
        fi
    done
}

# Запускаем сравнение для корневых директорий
compare_directories "$dir1" "$dir2"
