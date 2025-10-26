# Load the ggplot2 library
library(ggplot2)

# Read the data from the file
pop1 <- read.table("EHH_FYP2024/EHH_rs2320590_Negrito.500kb.ehh.1_21155195_C_T;rs2320590;rs2320590.out", header = TRUE, sep = "\t")
pop2 <- read.table("EHH_FYP2024/EHH_rs2320590_Malay.500kb.ehh.1_21155195_C_T;rs2320590;rs2320590.out", header = TRUE, sep = "\t")

# Assign column names to the dataframe
colnames(pop1) <- c("PDist", "Dist", "Der", "Anc", "EHH")
colnames(pop2) <- c("PDist", "Dist", "Der", "Anc", "EHH")

# Create a line plot with Series1 and Series2
ggplot() +
  geom_line(data = pop1, aes(x = PDist, y = Der, color = "Negrito"), linewidth = 1.2) +
  geom_line(data = pop2, aes(x = PDist, y = Der, color = "Malay"), linewidth = 1.2) +
  scale_color_manual(values = c("Malay" = "red", "Negrito" = "blue")) +
  labs(x = "Distance from top SNP (mb)", y = "EHH", color = "Population") +
  labs(title = "EHH Curve of rs2320590 Derived Allele in Negrito and Malay") +
  theme_classic()