# coloc_bioaida
Easy-to-use and end-to-end way to perform colocalization analysis - the assessment of correlation between two codistributed molecules labeled by different fluorophores.

# Image preprocessing in Fiji/ImageJ2 

Before starting the code make sure you installed Fiji/ImageJ2 software https://imagej.net/Fiji/Downloads as you need to preprocess your images there.

Quick guide to image preprocessing and pixel intensity data acquisition in Fiji/ImageJ2:
  1. Open your file and split it into channels (if in RGB format: Image -> Color -> Split Channels) or proceed with single-channel grayscale images (if such were acquired).
  2. You may need to deconvolve your single-channel images before colocalization analysis to reduce the blur created by signal from out-of-focus planes. A useful guide to deconvolution by Asa Giannini and John Giannini: https://pages.stolaf.edu/wp-content/uploads/sites/803/2016/12/Giannini_Giannini_Deconvolution_Manual_20161215.pdf 
  3. Select a region of interest (ROI) - a cell nucleus, for example, if nuclear molecules are in your interest. Add it to ROI manager (Analyze -> Tools -> ROI Manager).
  4. Click on the image of the first channel (e.g. green), select the ROI from ROI manager and collect pixel intensity data: Analyze -> Tools -> Save XY Coordinates. Save .csv file.
  5. Repeat Step 4 with the second channel (e.g. red).
  6. Now we are ready to start the code!

# Q&A section

  Q1: Why can't I use Fiji/ImageJ2 built-in plugins to perform colocalization analysis (e.g. Coloc2)?  
  A1: You can! Coloc2 is one of the most common methods for colocalization analysis. Usually it performs well, however, for some users one of its weak points is that it is little bit of a black box: no raw pixel intensity data, no thresholded scatterplots are available in the output - just a set of resultant parameters and usually a set of warnings (hard to get rid of). Coloc2 uses a thresholding method developed by S. V. Costes https://pubmed.ncbi.nlm.nih.gov/15189895/ - an automated, reproducible and objective algorithm to distinguish background pixels from "real' ones. It is also widely used in commercial software for analysis of microscope images. However, the algorithm can still produce inflated correlation coefficients, because it subtracts from the downstream analysis single-positive pixels (i.e. the pixels highly intensive in only one of the channels or non-colocalised) along with the background pixels. Another drawback is that it is problematic to aggregate the correlation coefficiens from multiple iterations of Coloc2 (e.g. on a set of objects) - the output is in .pdf format and if a user needs to collect the coefficients they need to copy them manually from each .pdf file. 
  
  Q2: What are the advantages of your method?
  A2: In my script Otsu thresholding algorithm is separately applied to each channel and then only double-negative pixels are subtracted from the downstream analysis. This approach preserves the influence of non-colocalised pixel on the resultant correlation coefficient, thus decreasing the possibility of getting false-positive results. The code also tests the distributions of pixel intensity data for normality and chooses the appropriate method of correlation analysis - parametric or non-parametric. The normality test is never performed in Coloc2, despite it is one of the most basic preliminary statistical tests. Thereby users can only count on the scatterplots in the output of Coloc2 to check whether the relationship between channels is linear when choosing between parametric and non-parametric tests for correlation analysis. The coefficients from multiple colocalization tests are aggregated into a dataframe that is easy to be subjected to further statistical tests.
  
# Examples

Example pixel intensity data sets (.csv) of objects with higher and lower colocalization are provided, as well as the image the values were saved from. 
