# Load the ggplot2 library
library(ggplot2)

# Read the data from the file
data <- read.table("EHH_FYP2024/test2.ehh.1_93635331_G_A;rs2783493;rs2783493.out", header = TRUE, sep = "\t")

# Assign column names to the dataframe
colnames(data) <- c("PDist", "Dist", "Der", "Anc", "EHH")

ggplot(data, aes(x = PDist)) +
  geom_line(aes(y = Der, color = "Der"), linewidth = 1.2) +
  geom_line(aes(y = Anc, color = "Anc"), linewidth = 1.2) +
  geom_vline(xintercept = 3, linetype="dotted", color = "red", size=1.5) +
  geom_vline(xintercept = 24, linetype="dotted", color = "red", size=1.5) +
  labs(x = "Distance from top SNP (kb)", y = "EHH", color = "Legend") +
  scale_color_manual(values = c("Der" = "blue", "Anc" = "orange")) +
  labs(title = "EHH Curve of rs2783493 Derived allele in Negrito and Malay") +
  theme_classic()