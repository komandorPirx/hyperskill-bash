#!/usr/bin/env bash

function f1() {
    str="[a-z]+_to_[a-z]+"
    nb="^[+-]?[0-9]+\.?[0-9]*$"
    nb1="^[0-9]+$"
    float_nb="^[-+]?[0-9]+\.?[0-9]*$"
    re='^[0-9[+$'
    re1='^[+-]?[0-9]+([.][0-9]+)?$'
    zero='^[0]'
    echo "Enter a definition:"

    while true 
    do
        read -a user_input
        arr_length="${#user_input[@]}"
        definition="${user_input[0]}"
        constant="${user_input[1]}"

        if [ "$arr_length" -eq "2" ] \
            && [[ "$definition" =~ $str ]]\
            && [[ "$constant" =~ $nb ]]; then
                    file_name="definitions.txt"
                    echo "$definition $constant" >> "$file_name"
                    break
                else
                    echo "The definition is incorrect!Enter a definition:"
                    continue
        fi
    done
}

function f2() {
    if [ ! -s definitions.txt ]; then
        echo "Please add a definition first!"
    else
        echo "Type the line number to delete or '0' to return"
        nl -w1 -s ". " definitions.txt
        #lines = $(wc -l  definitions.txt)
        lines=$(cat definitions.txt | wc -l)
        while true
        do
            read -a number
            if [ $lines -ge $number ] && [[ $number =~ $nb ]]; then
                sed -i "${number}d" definitions.txt
                break
            else
                echo "Enter a valid line number!"
                continue
            fi
        done
    fi
}

function f3() {
    if [ ! -s definitions.txt ]; then
        echo "Please add a definition first!"
    else
        echo "Type the line number to convert units or '0' to return"
        nl -w1 -s ". " definitions.txt
        lines=$(cat definitions.txt | wc -l)
        while true 
        do
            read -a line_number
            if [ "$line_number" != 0 ] ; then
                if [[ $line_number =~ [[:digit:]] ]] && [ $lines -ge $line_number ] ; then
                    line=$(sed "${line_number}!d" definitions.txt)
                    read text conversion_factor <<< $line
                    echo "Enter a value to convert:"
                    while true 
                    do
                        read -a value_to_convert
                        if [[ $value_to_convert =~ [[:digit:]] ]] ; then
                            #if [[ $value_to_convert =~ $re1 ]]; then
                            result=$(bc -l <<<"${value_to_convert}*${conversion_factor}") 
                            echo "Result: " $result
                            break
                        else
                            echo "Enter a float or integer value!"
                            continue
                        fi
                    done
                    break
                else 
                    echo "Enter a valid line number!"
                    continue
                fi
            else
                break
            fi
        done
    fi
}

echo "Welcome to the Simple converter!"
echo ""

while true 
do
    echo "Select an option"
    echo "0. Type '0' or 'quit' to end program"
    echo "1. Convert units"
    echo "2. Add a definition"
    echo "3. Delete a definition"
    read -a user_input
    case "$user_input" in
        0 | "quit")
            echo "Goodbye!"
            break;;
        1)
            f3
            #echo " "
            ;;
        2)
            f1
            #echo " "
            ;;
        3)
            f2
            #echo " "
            ;;
        *)
            echo "Invalid option!"
            #echo " "
            ;;
    esac
done
