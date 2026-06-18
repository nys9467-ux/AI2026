library(dplyr)

csv_path <- "C:/Users/Nys94/.gemini/antigravity/brain/d7380ecf-af3d-4a1b-bafa-c915003cc7a6/scratch/cleaned_data.csv"
df <- read.csv(csv_path)

df_regions <- df %>% filter(region != "전국")

cat("=== Correlation by Gender and Year ===\n")
gender_cor_by_year <- df_regions %>%
  group_by(year) %>%
  summarise(
    n = n(),
    cor_male = cor(avg_score, suicide_남자),
    p_val_male = cor.test(avg_score, suicide_남자)$p.value,
    cor_female = cor(avg_score, suicide_여자),
    p_val_female = cor.test(avg_score, suicide_여자)$p.value,
    .groups = "drop"
  )
print(gender_cor_by_year)
