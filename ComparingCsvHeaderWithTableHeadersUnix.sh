#Purpose : This script comapres the header of a csv with the header of the table and writes the header comparison remarks alongwith record count of csv file and record count of header in a final csv file.
#Method to call the script : sh script_name /hdfs/app/input_csv.csv database_name.table_name

echo "Address of csv : $1"
echo "Name of table : $2"

substring=$(echo $2 | cut -d '.' -f 2)
echo $substring

hive -e 'set hive.cli.print.header=true;select * from '$2' limit 0' | sed 's/[[:space:]]\+/,/g;s/'$substring.'//g' > /hdfs/app/Wrapper/temp_file.txt

head -1 $1 >> /hdfs/appWrapper/temp_file.txt

head -1 $1 | tr "[A-Z]" "[a-z]" >> /hdfs/appWrapper/temp_file.txt

table_header="$(head -1 /hdfs/appWrapper/temp_file.txt | tail -1)"
#table header will always come in lower case

csv_header="$(head -2 /hdfs/appWrapper/temp_file.txt | tail -1)"

csv_header_lower="$(head -3 /hdfs/appWrapper/temp_file.txt | tail -1)"

record_count_table="$(hive -e "select count(*) from $2;")"

record_count_csv="$(wc -l $1)"

record_count_csv_final="$(echo $record_count_csv | cut -d '.' -f 1)"

echo "table record count $record_count_table"

echo "csv record count $record_count_csv_final"

if [ "$table_header" == "$csv_header" ]; then
        echo "Perfect Match"
        echo "$1,$2,Perfect Match" >> /hdfs/appWrapper/header_report.csv
else
        if [ "$table_header" == "$csv_header_lower" ]; then
                echo "Match but characters lower in csv"
                echo "$1,$2,Match but characters lower in csv" >> /hdfs/appWrapper/header_report.csv
        else
                echo "No match"
                echo "$1,$2,No match" >> /hdfs/appWrapper/header_report.csv
fi
fi
