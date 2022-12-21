Scripts and data files needed to run ASCAT pipeline for CEL files, adapted from https://github.com/VanLoo-lab/ascat/blob/master/ExampleData/ASCAT_fromCELfiles.R 

**Step 1: PennCNV Affy pipeline**

The first step is to preprocess the CEL files using PennCNV-Affy (giving Log R Ratio (LRR) and B Allele Frequency (BAF)), see http://penncnv.openbioinformatics.org/en/latest/user-guide/affy/. 

The PennCNV folder contains files/scripts to run the PennCNV Affy pipeline for the Affymetrix SNP Array 6.0. The PennCNV_Pipeline script allows users to input arguments and run the 3-step or 4-step pipeline using Hg18/Hg19/Hg38. When only a limited number of CEL files are available it is recommended to only use steps 1.1, 1.2 and 1.4. 

**Step 2: ASCAT pipeline** 

After generating the LRR values and the BAF values for each marker in each individual, these output files can be used as inputs for the ASCAT algorithm.
