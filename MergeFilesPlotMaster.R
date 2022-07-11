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

#for (i in start:stop) {
#	file_name <- paste("Spectrum_plot_for_", i, "nm.pdf", sep="")
#	pdf(file_name)
#	print(plot_list[[i]])
#	dev.off()
#}

#pdf("Spectra_plots_different_wavelength.pdf")
#for (i in 1:stop) {
#    print(plot_list[[i]])
#}
#dev.off()


# Option 2: generate all on the same plot using matplot
pdf('Excitation_by_wavelength_sameplot.pdf')
nn <- ncol(dataset[2:ncol(dataset)])
matplot(dataset[,2:ncol(dataset)], type = 'l', lty = "solid", ann=TRUE, xlab = "Wavelength", ylab = "" )
legend("topright", colnames(dataset[2:ncol(dataset)]), col=seq_len(nn), cex = 0.8, fill=seq_len(nn))

# Option 3: generate all plots separately, but on the same page using timeseries
# Then this creates a pdf file of the plots 
pdf('Excitation_by_wavelength_separateplots.pdf')
plot.ts(dataset[2:ncol(dataset)], ann=FALSE); title(main = "Separate Excitation Plots", xlab = "Wavelength")

### Under development -------------------------
# require(ggplot2)
# require(reshape2)

# df <- melt(dataset ,  id.vars = 'Wavelength', variable.name = 'series')
# plot on same grid, each series colored differently -- 
# good if the series have same scale
# ggplot(df, aes(Wavelength,value)) + geom_line(aes(colour = series))