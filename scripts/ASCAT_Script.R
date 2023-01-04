#!/usr/bin/env Rscript

# Pipeline Adapted from - https://github.com/VanLoo-lab/ascat/blob/master/ExampleData/ASCAT_fromCELfiles.R

# Set up arguments: 
library("optparse")
 
option_list = list(
  make_option(c("-o", "--out"), type="character", default="ASCAT_Output_Dir", 
              help="output directory name", metavar="character"),
  make_option(c("-f", "--file"), type="character", default=NULL, 
              help="input data", metavar="character"),
  make_option(c("-s", "--snp"), type="character", default=NULL, 
              help="SNP position file name", metavar="character"),
  make_option(c("-g", "--gccorrect"), type="character", default=NULL, 
              help="input GC correction file", metavar="character"),
  make_option(c("-r", "--replicationtiming"), type="character", default=NULL, 
              help="input Replication Timing file", metavar="character"),
  make_option(c("-a", "--algorithm"), type="character", default="aspcf", 
              help="select algorithm: aspcf or asmultipcf", metavar="character"),
  make_option(c("-p", "--penalty"), type="numeric", default=70, 
              help="select penalty", metavar="numeric")
); 


 
opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

# Set up directories to store output
mainDir <- "../"
subDir <- opt$out

print(file.path(mainDir, subDir))
dir.create(file.path(mainDir, subDir))
setwd(file.path(mainDir, subDir))

# Write out chosen arguments
fileConn <- file("ASCAT_Run_Arguments.txt")
writeLines(c(paste("Output directory name:", opt$out, sep=" "), 
             paste("Input File:", opt$file, sep=" "), 
             paste("SNP File:", opt$snp, sep=" "), 
             paste("GC correction file:", opt$gccorrect, sep=" "),
             paste("RT correction file:", opt$replicationtiming, sep=" "),
             paste("Selected segmentation algorithm:", opt$algorithm, sep=" "),
             paste("ASCAT penalty:", opt$penalty, sep=" ")),  fileConn)
close(fileConn)

# Make sure input file is given
if(is.null(opt$file)){
  print_help(opt_parser)
  stop("At least one argument must be supplied (input file)", call.=FALSE)
}

# Make sure GC correction file is given
if(is.null(opt$gccorrect)){
  print_help(opt_parser)
  stop("GC correction file must be provided", call.=FALSE)
}

# Load up Libraries 
library(ASCAT) # Using ASCAT version 3.0.0
library(dplyr) 

# Load up data - This should be first argument given
# Also note that input data is obtained from running the PennCNV-Affy pipeline
lrrbaf = read.table(opt$file, header = T, sep = "\t", row.names=1)
print("lrrbaf loaded up")

# Make a vector of clean patient IDs 
# Note these substitutions are based on the column names of the file I inputted
# May need to be adjusted to match the column names of the file you inputted
sample = sub(".CEL.Log.R.Ratio","",colnames(lrrbaf))[seq(3, ncol(lrrbaf), by = 2)]
sample = sub("X_Data_Files_", "", sample)

# Load up SNP position file. 
if(is.null(opt$snp)) {
	print("No SNPpos.txt file given, using SNP positions from input file")
	SNPpos <- lrrbaf[,1:2]
} else {
	print("SNPpos.txt file provided, loading up")
	SNPpos <- read.table(opt$snp, header=T, sep="\t", row.names=1) 
}

print("SNPpos.txt loaded up")

# Create LogR and BAF files and use patient IDs to name columns
Tumor_LogR = lrrbaf[rownames(SNPpos),c(seq(3, ncol(lrrbaf), by = 2)), drop=F]
colnames(Tumor_LogR) <- sample
print("Tumor_LogR created")

Tumor_BAF = lrrbaf[rownames(SNPpos),c(seq(4, ncol(lrrbaf), by = 2)), drop=F]
colnames(Tumor_BAF) <- sample
print("Tumor_BAF created")

# Data preprocessing - 
# replace 2's by NA
# Why: Some SNP array platforms (e.g., Affymetrix SNP 6.0) contain copy-number-only probes. These are probes in non-SNP
# locations. ASCAT can take these copy-number-only probes into account and calculate the total copy number at these loci.
# As no allelic contrast information is available, these copy-number-only probes should have NA values in their BAF data

Tumor_BAF[Tumor_BAF == 2] = NA
print("Tumor_BAF processed")

# Tumor_LogR: correct difference between copy number only probes and other probes
CNprobes = substring(rownames(SNPpos),1,2)=="CN"

if(ncol(Tumor_LogR) == 1){
	print("Tumor_LogR has 1 column")
	Tumor_LogR[CNprobes,1] = Tumor_LogR[CNprobes,1]-mean(Tumor_LogR[CNprobes,1], na.rm=T)
	Tumor_LogR[!CNprobes,1] = Tumor_LogR[!CNprobes,1]-mean(Tumor_LogR[!CNprobes,1], na.rm=T) 
} else {
	print("Tumor_LogR has more than 1 column")
	Tumor_LogR[CNprobes, ] <- as.data.frame(apply(Tumor_LogR[CNprobes,], 2, function(x) x - mean(x, na.rm=T)))
	Tumor_LogR[!CNprobes, ] <- as.data.frame(apply(Tumor_LogR[!CNprobes,], 2, function(x) x - mean(x, na.rm=T)))
}

# Limit the number of digits:
Tumor_LogR = round(Tumor_LogR, 4)
print("Tumor_LogR processed")
print("Done Formatting")

# Store output
write.table(cbind(SNPpos, Tumor_BAF), "ASCAT_tumor_BAF.txt", sep="\t", row.names=T, col.names=NA, quote=F)
write.table(cbind(SNPpos, Tumor_LogR), "ASCAT_tumor_LogR.txt", sep="\t", row.names=T, col.names=NA, quote=F)

print("Done writing out preprocessed data")

# Start ASCAT Pipeline
print("Start ASCAT Pipeline")

# Load up preprocessed data
file.tumor.LogR <- dir(pattern="ASCAT_tumor_LogR.txt")
file.tumor.BAF <- dir(pattern="ASCAT_tumor_BAF.txt")
print("Preprocessed data loaded up")

# Note: All my samples are females and so I don't have to load up birdseed.report.txt file 
# Otherwise:
# gender <- read.table("birdseed.report.txt", sep="\t", skip=66, header=T)
# sex <- as.vector(gender[,"computed_gender"])
# sex[sex == "female"] <- "XX"
# sex[sex == "male"] <- "XY"
# sex[sex == "unknown"] <- "XX"

# Load up data - Function to read in SNP array data
ascat.bc <- ascat.loadData(file.tumor.LogR, file.tumor.BAF, chrs=c(1:22, "X"))

# ASCAT Pipeline
# Produce png files showing the logR and BAF values for tumour and germline samples (Before GC correction)
ascat.plotRawData(ascat.bc, img.prefix = "Before_correction_")

# Corrects logR of the tumour sample(s) with genomic GC content (replication timing is optional)
if(is.null(opt$replicationtiming)){
  ascat.bc <- ascat.correctLogR(ascat.bc, opt$gccorrect)
} else {
  ascat.bc <- ascat.correctLogR(ascat.bc, opt$gccorrect, opt$replicationtiming)
}

# Produce png files showing the logR and BAF values for tumour and germline samples (After GC correction)
ascat.plotRawData(ascat.bc, img.prefix = "After_correction_")

# Predicts the germline genotypes of samples for which no matched germline sample is available
gg <- ascat.predictGermlineGenotypes(ascat.bc, platform = "AffySNP6")

print(paste("ASCAT segmentation algorithm =", opt$algorithm, sep=" "))
print(paste("ASCAT penalty =", opt$penalty, sep=" "))
selected_penalty = opt$penalty
 
# Run ASPCF segmentation
if(opt$algorithm != "aspcf" & opt$algorithm != "asmultipcf"){
  stop("Error: One of aspcf or asmultipcf must be selected", call.=FALSE)
} else if(opt$algorithm == "aspcf"){
  ascat.bc = ascat.aspcf(ascat.bc, ascat.gg = gg, penalty = selected_penalty)
} else {
  # ASCAT run with multi-sample segmentation (when shared breakpoints are expected)
  ascat.bc = ascat.asmultipcf(ascat.bc, ascat.gg = gg, penalty = selected_penalty)
}

# Plots the SNP array data before and after segmentation
ascat.plotSegmentedData(ascat.bc)

# ASCAT main function, calculating the allele-specific copy numbers
ascat.output = ascat.runAscat(ascat.bc) 

print("ASCAT Pipeline Complete") 

print("Saving Files")
write.table(ascat.output$segments, file=paste(c("ASCAT_Run"),".segments.txt",sep=""), sep="\t", quote=F, row.names=F)
write.table(ascat.output$aberrantcellfraction, file=paste(c("ASCAT_Run"),".acf.txt",sep=""), sep="\t", quote=F, row.names=F)
write.table(ascat.output$ploidy, file=paste(c("ASCAT_Run"),".ploidy.txt",sep=""), sep="\t", quote=F, row.names=F)
QC = ascat.metrics(ascat.bc, ascat.output)
save(ascat.bc, ascat.output, QC, file = 'ASCAT_objects.Rdata')
print("Script Run Successfully")
