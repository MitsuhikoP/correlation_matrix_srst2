# correlation_matrix_srst2

This program drows heatmap of correlation matrix from SRST2(https://github.com/katholt/srst2) output file.
It shows coexistance or complementation of bacterial pathogens.

This analysis ignores phylogenetic relationship. 


# dependency

perl
r
gplots


# Usage
correlation_matrix_srst2.pl srst2__gene__*__results.txt output_prefix [0|1|2]

output file
output_prefix.txt
the correlation matrix. -999 means incalculable.

output_prefix.pdf
heatmap of the correlation matrix.

argment3 undetected mark; 0:only - (default). 1:- and ? . 2:- , ? and * 

In -, ?, and *, refer to SRST2(https://github.com/katholt/srst2) output.


