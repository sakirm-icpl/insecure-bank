check_and_install() {
    if ! command -v "$1" &> /dev/null; then
        echo "$1 is not installed. Installing..."
        if [ "$1" == "jq" ]; then
            # Install jq (for JSON processing)
            sudo apt-get update
            sudo apt-get install -y jq
        elif [ "$1" == "python3" ]; then
            # Install Python 3
            sudo apt-get update
            sudo apt-get install -y python3
        elif [ "$1" == "pip3" ]; then
            # Install pip3
            sudo apt-get update
            sudo apt-get install -y python3-pip
        fi
    fi
}

# Check and install prerequisites
check_and_install jq
check_and_install python3
check_and_install pip3

# Install xlsxwriter Python module
if ! pip3 show xlsxwriter &> /dev/null; then
    echo "Installing xlsxwriter..."
    pip3 install xlsxwriter
fi

# Specify the input JSON file path
input_json="/var/lib/jenkins/workspace/mobsf/app.json"

# Output Excel file
output_excel="${input_json%.json}.xlsx"

# Convert JSON to CSV using jq
jq -r '(.[0] | keys_unsorted), map(.[]) | @csv' "$input_json" > temp.csv

# Convert CSV to Excel using xlsxwriter
python3 -c "
import csv
import xlsxwriter

with open('temp.csv', 'r') as csv_file:
    csv_reader = csv.reader(csv_file)
    workbook = xlsxwriter.Workbook('$output_excel')
    worksheet = workbook.add_worksheet()

    for row_num, row_data in enumerate(csv_reader):
        for col_num, col_data in enumerate(row_data):
            worksheet.write(row_num, col_num, col_data)

    workbook.close()
"

# Remove temporary CSV file
rm temp.csv

echo "Conversion completed. Excel file: $output_excel"
