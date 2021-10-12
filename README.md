#  Array Genotyping Conversion Tool

The AGCT (Array Genotyping Conversion Tool) pipeline consists of only 1 step:
1: Convert IDAT to GTC Format
```
This step takes IDAT files (Illumina SNP array scan Files) and converts them to GTC Format.
For this to happen an reference file (in .egt format) to normalise the data is needed and also the .bpm file (which consists of information which probes lie on the array platform) are needed.

After this conversion the array data can be converted to .txt files using the GAP pipeline.
These .GTC files can also be converted by using the Python library BeadArrayFiles.