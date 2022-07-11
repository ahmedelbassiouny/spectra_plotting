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

# Option 1: generate ggplots for each wavelength and make a pdf with each graph as a separate page
require(ggplot2)
start <- 2
stop <- ncol(dataset)
plot_list <- list()
for(i in start:stop){
	graphy <- ggplot(dataset,aes_string(x=names(dataset)[1],y=names(dataset)[i])) + geom_line()
	plot_list[[i]] <- graphy
}

pdf("Spectra_plots_different_wavelength.pdf")
for (i in 1:stop) {
    print(plot_list[[i]])
}
dev.off()


