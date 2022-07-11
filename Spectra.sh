#!/bin/bash

# This script will combine all text files for the independent excitation data from multiple .txt files into one

rm -rf ./cleaned_raw
mkdir cleaned_raw
for file in "$@"; do
	sed '1,/#DATA/d' $file > ./cleaned_raw/clean_"$file"
	echo "$file" | cut -d"#" -f1 | cut -d"-" -f2 | cat - ./cleaned_raw/clean_"$file" > temp && mv temp ./cleaned_raw/clean_"$file"
	sed -e 1's/.*/Wavelength	&/' ./cleaned_raw/clean_"$file" > temp2 && mv temp2 ./cleaned_raw/clean_"$file"
done

echo "Done removing junk from your files. See cleaned_raw folder for sparkly files"
echo "Now starting R"

Rscript /Users/Elbassiouny/Documents/Research/Thesis/Scripts/MergeFilesPlotSameSep.R

echo "Enjoy the generated plot inside cleaned_raw folder, and the data frame used to generate it."
