# Imports
library(readtext)
library(dplyr)

# Path definition of the news archives
path <- "~/Downloads/bbc/"
# List with the 5 categories
file.remove("~/Downloads/bbc/README.TXT")
list_categories <- list.files(path = path)

# Save to dataset the number of files in each category folder
summary_categories <- data.frame(matrix(ncol = 2, nrow = 0))
colnames(summary_categories) <- c('Category', 'Number_of_Files')

for (category in list_categories){
  category_path <- paste(path, category, sep='/')
  n_files <- length(list.files(path=category_path))
  summary_categories = rbind(summary_categories, data.frame('Category' = category, 
                                                            'Number_of_Files' = n_files))
}

summary_categories

# Read every folder and create the final dataframe
df_final <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(df_final) <- c('doc_id', 'text', 'category')

for(category in list_categories){
  category_path <- paste(path, category, sep='/')
  
  df <- readtext(category_path)
  df["category"] = category
  
  df_final = rbind(df_final, df)
}

colnames(df_final) <- c('File_Name', 'Content', 'Category')

df_final <-
  df_final %>% 
  mutate(Complete_Filename = paste(File_Name, Category, sep='-'))


# Write csv to import to python
write.csv2(df_final,fileEncoding = 'utf8', "~/Desktop/News_dataset.csv", row.names = FALSE)
