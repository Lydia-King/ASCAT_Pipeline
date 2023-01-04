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

**Note:** These files correspond to the GC correction file, replication timing correction file and SNP location file, respectively, for the Affymetrix SNP 6.0 platform. These files were built using Hg19, if you require GC correction file, replication timing correction file and SNP location file for other genome builds, such as Hg18 or Hg38, please use this [link](https://github.com/VanLoo-lab/ascat/tree/master/LogRcorrection) to create your own. 

-----

### **Scripts**
The scripts directory contains the R script ASCAT_Script.R and the submission script ASCAT_Submission.sh used to run the ASCAT pipeline. The ASCAT pipeline I am running is for microarray data without matched normals, see this [link](https://github.com/VanLoo-lab/ascat/tree/master/ExampleData) for examples of other ASCAT runs.  

The scripts provided allow users to input a number of arguments, these are described below.

- Output directory name (optional). Flags are `-o` or `--out`. Default is "ASCAT_Output_Dir".
- Input data (obtained from PennCNV-Affy pipeline). Flags are `-f` or `--file`.
- SNP position file (optional). Note that SNPpos.txt file provided in ref folder is for Hg19. Flags are `-s` or `--snp`.
- GC correction file. Flags are `-gc` or `--gccorrect`.
- Replication timing correction file (optional). Flags are `-rt` or `--replicationtiming`.
- Select which algorithm to use, aspcf or asmultipcf (optional). Flags are `-a` or `--algorithm`. Default is aspcf.
- Penalty of introducing an additional ASPCF breakpoint (optional and expert parameter, don't adapt unless you know what you are doing). Flags are `-p` or `--penalty`. Default is 70.

**Note:** All my samples come from female breast cancer patients ("XX") and so I do not need to load up the birdseed.report.txt file to extract the computed gender column to create sex vector. If your samples are from both sexes the R script provided will need to be altered. 

An example of how the script is run to preprocess the data using the 4-step procedure and Hg19 is: `sbatch ASCAT_Submission.sh ASCAT_Script.R `  

**Note:** Consistent genome build should be used throughout whole PennCNV-Affy and ASCAT pipelines. 

-----

### **To run this pipeline on your own data**

**1.** Clone this repository and navigate into it:

```bash
git clone https://github.com/Lydia-King/ASCAT_Pipeline
cd ASCAT_Pipeline
```

