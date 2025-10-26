path_to_cv_file = "/r1/people/yap_wai/Data_Analysis/Merged/Quality_Control/Admixture/Snakemake/CV.txt"
path_to_loglikelihood_file = "/r1/people/yap_wai/Data_Analysis/Merged/Quality_Control/Admixture/Snakemake/Loglikelihood.txt"
path_to_save_LL_table = "/r1/people/yap_wai/Data_Analysis/Merged/Quality_Control/Admixture/Snakemake/Loglikelihood_MAX_table.txt"
path_to_save_plot_CV = "/r1/people/yap_wai/Data_Analysis/Merged/Quality_Control/Admixture/Snakemake/CV_plot.pdf"
path_to_save_plot_LL = "/r1/people/yap_wai/Data_Analysis/Merged/Quality_Control/Admixture/Snakemake/LL_plot.pdf"
plot_titel = "CV plot"

library(data.table)
library(ggplot2)

cv <- fread(path_to_cv_file, col.names = c("K", "Run", "cv_error"))
LL <- fread(path_to_loglikelihood_file, col.names = c("K", "Run", "loglikelihood"))
cv_plot <- ggplot(cv, aes(group=K, x=K, y=cv_error, fill="red")) +
  geom_boxplot() +
  theme(legend.position="none") +
  labs(x="K", y="Cross-validation error",
       caption = paste("min CV-error =", cv[which(cv$cv_error == min(cv$cv_error)),]$cv_error, "in K =", cv[which(cv$cv_error == min(cv$cv_error)),]$K)) +
  scale_x_continuous("K", labels = as.character(min(cv$K):max(cv$K)), breaks = min(cv$K):max(cv$K))+
  ggtitle(plot_titel)
ggsave(plot = cv_plot, filename = path_to_save_plot_CV, width = 10, height = 4)LL_plot <- ggplot(LL, aes(group=K, x=K, y=loglikelihood, fill="red")) +
  geom_boxplot() +
  theme(legend.position="none") +
  labs(x="K", y="Loglikelihood") +
  scale_x_continuous("K", labels = as.character(min(LL$K):max(LL$K)), breaks = min(LL$K):max(LL$K))+
  ggtitle(plot_titel)
ggsave(plot = LL_plot, filename = path_to_save_plot_LL, width = 10, height = 4)# For each K, determine which of the 10 runs has the highest likelihood.
LL_table <- LL[, .SD[which(loglikelihood == max(loglikelihood)),], by = K]
write.table(LL_table, path_to_save_LL_table, sep="\t", quote=F, col.names = T, row.names = F) (edited) 