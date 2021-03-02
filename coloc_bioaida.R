library(magrittr) # %>%
library(data.table)
library(autothresholdr)
library(ggplot2)
library(hexbin)

#making vectors for aggregation of correlation coeffitients
control <- c()
treatment <- c()

#reading pixel intensity data
green <- read.csv('green dec.csv') %>%
  as.data.table()
red <- read.csv('red dec.csv') %>%
  as.data.table()

#thresholding pixel intensity data in each channel
thgreen <- auto_thresh(green$Value, "Otsu")
thred <- auto_thresh(red$Value, "Otsu")

#combining pixel intensity data from both channels in one dataframe
merged <- cbind.data.frame(green, red)
names(merged)[3] <- "green"
names(merged)[6] <- "red"
merged[,c(4,5)] <- NULL

#subtracting double-negative (background) pixels
mergedth <- merged[!(green<=thgreen & red<=thred)]

#testing the normality of data
ntg <- ks.test(mergedth$green, "pnorm", mean=mean(mergedth$green), sd=sd(mergedth$green))
ntr <- ks.test(mergedth$red, "pnorm", mean=mean(mergedth$red), sd=sd(mergedth$red))

#performing colocalization analysis for samples from the control group
if (ntg$p.value>=0.05 & ntr$p.value>=0.05) {
  ct <- cor.test(mergedth$green, mergedth$red, method='pearson')
  control <- append(control, ct$estimate)
} else {
  ct <- cor.test(mergedth$green, mergedth$red, method='spearman')
  control <- append(control, ct$estimate)}

#performing colocalization analysis for samples from the treatment group
if (ntg$p.value>=0.05 & ntr$p.value>=0.05) {
  ct <- cor.test(mergedth$green, mergedth$red, method='pearson')
  treatment <- append(treatment, ct$estimate)
} else {
  ct <- cor.test(mergedth$green, mergedth$red, method='spearman')
  treatment <- append(treatment, ct$estimate)}

#aggregating coefficients from two experimental groups
results <- data.frame(control, treatment)
