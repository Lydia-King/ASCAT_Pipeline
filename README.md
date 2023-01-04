## ASCAT Pipeline

This repository contains scripts and ref files needed to run the Allele-Specific Copy number Analysis of Tumours (ASCAT) pipeline for CEL files, adapted from [ASCAT_fromCELfiles](https://github.com/VanLoo-lab/ascat/blob/master/ExampleData/ASCAT_fromCELfiles.R). ASCAT is a method to derive copy number profiles of tumour cells, accounting for normal cell admixture and tumour aneuploidy. ASCAT infers tumour purity and ploidy from SNP array or massively parallel sequencing data, and calculates whole-genome allele-specific copy number profiles. See the [ASCAT user guide](https://www.crick.ac.uk/research/labs/peter-van-loo/software) for more information and guidance. Below is a brief guide to what each directory (data, ref and scripts) contains. 

**Note:** If working with raw CEL files, the first step is to preprocess the CEL files using the PennCNV-Affy pipeline described in my [PennCNV_Pipeline](https://github.com/Lydia-King/PennCNV_Pipeline) repository. The PennCNV-Affy pipeline is used to preprocess raw CEL files to produce Log R Ratio (LRR) and B Allele Frequency (BAF) values that will be used as inputs for ASCAT.

-----

### **Data**
Store output from the PennCNV-Affy pipeline in this directory. 

-----

### **Ref**
The ref directory contains the ref files needed to run the ASCAT pipeline for Affymetrix SNP Array 6.0 data. Note that the zipped files should be unzipped before use. These files can also be obtained from the user guide, link provided above. The ref files needed to run this pipeline are listed below. 

- GC_AffySNP6_102015.txt
- RT_AffySNP6_102015.txt
- SNPpos.txt

**Note:** These files correspond to the GC correction file, replication timing correction file and SNP location file, respectively, for the Affymetrix SNP 6.0 platform. These files were built using Hg19, if you require a GC correction file, replication timing correction file and SNP location file for other genome builds, such as Hg18 or Hg38, please use this [link](https://github.com/VanLoo-lab/ascat/tree/master/LogRcorrection) to create your own. 

-----

### **Scripts**
The scripts directory contains the R script (ASCAT_Script.R) and the submission script (ASCAT_Submission.sh) used to run the ASCAT pipeline. The ASCAT pipeline I am running is for microarray data without matched normals, see this [link](https://github.com/VanLoo-lab/ascat/tree/master/ExampleData) for examples of other ASCAT runs.  

The scripts provided allow users to input a number of arguments. These inputted arguments are stored a file called ASCAT_Run_Arguments.txt for future reference. Arguments are described below.

- Output directory name (optional). Flags are `-o` or `--out`. Default is "ASCAT_Output_Dir".
- Input data **(needed)**. Flags are `-f` or `--file`.
- SNP position file (optional). Note that SNPpos.txt file provided in ref folder is for Hg19. Flags are `-s` or `--snp`.
- GC correction file **(needed)**. Flags are `-g` or `--gccorrect`.
- Replication timing correction file (optional). Flags are `-r` or `--replicationtiming`.
- Select which algorithm to use, aspcf or asmultipcf (optional). Flags are `-a` or `--algorithm`. Default is aspcf.
- Penalty of introducing an additional ASPCF breakpoint (optional and expert parameter, don't adapt unless you know what you are doing). Flags are `-p` or `--penalty`. Default is 70.

**Note:** All my samples come from female breast cancer patients ("XX"). As a result I do not need to load up the birdseed.report.txt file obtained from PennCNV-Affy pipeline to extract the computed gender column to create the sex vector. If your samples are from both sexes the R script provided will need to be altered. 

An example of how the script is run interactively is: `bash ASCAT_Submission.sh ASCAT_Script.R -f ../data/outfile.txt -g ../ref/GC_AffySNP6_102015.txt`  

**Note:** Consistent genome build should be used throughout whole PennCNV-Affy and ASCAT pipelines. 

-----

### **To run this pipeline on your own data**

**1.** Clone this repository and navigate into it:

```bash
git clone https://github.com/Lydia-King/ASCAT_Pipeline
cd ASCAT_Pipeline
```

**2.** Set up data directory by downloading/moving output from PennCNV-Affy into it:

```bash
mv ../PennCNV_Output/* data/ 
```

**3.** Unzip files in ref folder:

```bash
cd ref/
gunzip *.gz
```

**4.** Submit script with input arguments:

```bash
cd ../scripts

# Basic run
bash ASCAT_Submission.sh ASCAT_Script.R -f ../data/outfile.txt -g ../ref/GC_AffySNP6_102015.txt

## OR ##

sbatch ASCAT_Submission.sh ASCAT_Script.R -f ../data/outfile.txt -g ../ref/GC_AffySNP6_102015.txt
```

-----

### **Additional Resources**

 - Van Loo, P., Nordgard, S. H., Lingjærde, O. C., Russnes, H. G., Rye, I. H., Sun, W., Weigman, V. J., Marynen, P., Zetterberg, A., Naume, B., Perou, C. M., Børresen-Dale, A. L., & Kristensen, V. N. (2010). Allele-specific copy number analysis of tumors. Proceedings of the National Academy of Sciences of the United States of America, 107(39), 16910–16915. https://doi.org/10.1073/pnas.1009843107
