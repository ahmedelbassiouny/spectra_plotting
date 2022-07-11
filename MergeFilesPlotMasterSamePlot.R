setwd("./cleaned_raw")
# This will generate a list of files to be merged
file_list <- list.files()
# The following for loop then creates the dataframe and combines files into it
for (file in file_list){
      
  # if the merged dataset doesn't exist, create it
  if (!exists("dataset")){
    dataset <- read.table(file, header=TRUE, sep="")
  }
  
  # if the merged dataset does exist, append to it
  if (exists("dataset")){
    temp_dataset <-read.table(file, header=TRUE, sep="")
    dataset<-merge(dataset, temp_dataset)
    rm(temp_dataset)
  }

}
# Makes the first column as the index values
rownames(dataset) <- dataset$Wavelength
# The next line exports the data frame into a tab-delimited text file
write.table(dataset, "combineddataset.txt", sep="\t")



# Option 2: generate all on the same plot using matplot
pdf('Excitation_by_wavelength_sameplot.pdf')
nn <- ncol(dataset[2:ncol(dataset)])
matplot(dataset[,2:ncol(dataset)], type = 'l', lty = "solid", ann=TRUE, xlab = "Wavelength", ylab = "" )
legend("topright", colnames(dataset[2:ncol(dataset)]), col=seq_len(nn), cex = 0.8, fill=seq_len(nn))
