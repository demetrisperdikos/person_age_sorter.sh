#!/bin/bash


# Getting the input file
input_file=$1


get_age() {
    # Getting the birth day
    birth_date=$1

    # getting year, month, and day from the birth date
    birth_year=${birth_date:0:4}
    birth_month=${birth_date:5:2}
    birth_day=${birth_date:8:2}

    # basically just making it the last day of 2023 since maria is born that day
    current_year=2023
    current_month=12
    current_day=31

    # getting the age using the birth year, month, and day
    if ((10#$birth_month > 10#$current_month)) || ((10#$birth_month == 10#$current_month && 10#$birth_day > 10#$current_day)); then
        person_age=$((current_year-birth_year-1))
    else
        person_age=$((current_year-birth_year))
    fi

    echo $person_age
}

# Creating a temporary file
temp_file="temp_data.txt"
> $temp_file

# Reading and checking each line from the input file
while IFS= read -r record; do
    city_name=$(echo $record | awk -F ',' '{print $3}' | xargs)

    if [[ $city_name =~ .*\ .+ ]]; then
        birth_date=$(echo $record | awk -F ',' '{print $2}' | xargs)
        person_age=$(get_age $birth_date)
        person_name=$(echo $record | awk -F ',' '{print $1}' | xargs)
        echo "$person_name,$person_age" >> $temp_file
    fi
done < "$input_file"

# Sorting the info by age in descending order and printing the results
echo "First and Last Name, Age"
sort -t "," -k2 -nr $temp_file


rm $temp_file

