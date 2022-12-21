Scripts and data files needed to run ASCAT pipeline for CEL files, adapted from https://github.com/VanLoo-lab/ascat/blob/master/ExampleData/ASCAT_fromCELfiles.R 

**Step 1: PennCNV Affy pipeline**

The first step is to preprocess the CEL files using PennCNV-Affy (giving LogR and BAF), see http://penncnv.openbioinformatics.org/en/latest/user-guide/affy/. 

The PennCNV folder contains files/scripts to run the PennCNV Affy pipeline for the Affymetrix SNP Array 6.0. The PennCNV_Pipeline script allows users to input arguments and run the 3-step or 4-step pipeline using Hg18/Hg19/Hg38. When only a limited number of CEL files are available it is recommended to only use steps 1.1, 1.2 and 1.4. 

**Step 2: ASCAT pipeline** 

These include scripts to run PennCNV to obtain LRR and BAF files from raw CEL files, scripts to run ASCAT on LRR and BAF files and scripts to process/format the allele-specific data obtained from ASCAT.

