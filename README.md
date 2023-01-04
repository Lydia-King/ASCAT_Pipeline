## ASCAT Pipeline

This repository contains scripts and ref files needed to run the Allele-Specific Copy number Analysis of Tumours (ASCAT) pipeline for CEL files, adapted from [ASCAT_fromCELfiles](https://github.com/VanLoo-lab/ascat/blob/master/ExampleData/ASCAT_fromCELfiles.R). ASCAT is a method to derive copy number profiles of tumour cells, accounting for normal cell admixture and tumour aneuploidy. ASCAT infers tumour purity and ploidy from SNP array or massively parallel sequencing data, and calculates whole-genome allele-specific copy number profiles. See the [ASCAT user guide](https://www.crick.ac.uk/research/labs/peter-van-loo/software) for more information and guidance. Below is a brief guide to what each directory (data, ref and scripts) contains. 

**Note:** If working with raw CEL files, the first step is to preprocess the CEL files using the PennCNV-Affy pipeline described in my [PennCNV_Pipeline](https://github.com/Lydia-King/PennCNV_Pipeline) repository. The PennCNV-Affy pipeline is used to preprocess raw CEL files to produce Log R Ratio (LRR) and B Allele Frequency (BAF) values that will be used as inputs for ASCAT.

-----

### **Data**
Store output from PennCNV-Affy in this directory. 

-----

### **Ref**
The ref directory contains the ref files needed to run the ASCAT pipeline for Affymetrix SNP Array 6.0 data. Note that the zipped files should be unzipped before use. These files can also be obtained from the user guide, link provided above. The ref files needed to run this pipeline are listed below. 

- GC_AffySNP6_102015.txt
- RT_AffySNP6_102015.txt
- SNPpos.txt

-----

### **Scripts**
### **Scripts**
The scripts directory contains the PennCNV_Script.sh script used to run the PennCNV-Affy pipeline for the Affymetrix SNP Array 6.0. The PennCNV-Affy pipeline contains 2 steps, however we are only interested in Step 1: Generate the signal intensity data based on raw CEL files. Step 1 has 4 substeps (substeps 1.1 - 1.4) and the script allows users to input arguments to run the 3-step or 4-step pipeline using Hg18, Hg19 or Hg38. When only a limited number of CEL files are available it is recommended to only use substeps 1.1, 1.2 and 1.4.  

An example of how the script is run to preprocess the data using the 4-step procedure and Hg19 is: `sbatch PennCNV_Script.sh Hg19 4Step`  

**Important:** Accepted arguments for argument 1 include `Hg18`, `Hg19` or `Hg38` and accepted arguments for argument 2 include `3Step` or `4Step`. If anything else is inputted an error will be produced. 

 ASCAT_Script.R

ASCAT_Submission.sh 
-----

### **To run this pipeline on your own data**

**1.** Clone this repository and navigate into it:

```bash
git clone https://github.com/Lydia-King/ASCAT_Pipeline
cd ASCAT_Pipeline
```

