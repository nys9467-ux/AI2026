library(dplyr)
library(ggplot2)
library(tidyr)
library(patchwork) # For combining plots if needed, otherwise we save them separately

csv_path <- "C:/Users/Nys94/.gemini/antigravity/brain/d7380ecf-af3d-4a1b-bafa-c915003cc7a6/scratch/cleaned_data.csv"
df <- read.csv(csv_path)

df_regions <- df %>% filter(region != "전국")
df_national <- df %>% filter(region == "전국")

artifact_dir <- "C:/Users/Nys94/.gemini/antigravity/brain/d7380ecf-af3d-4a1b-bafa-c915003cc7a6"
windowsFonts(Malgun = windowsFont("Malgun Gothic"))

# --- Plot 4: Year-by-Year Panel Plot (Facet Grid) ---
# This shows how the correlation slope changes over the years.
p4 <- ggplot(df_regions, aes(x = avg_score, y = suicide_계)) +
  geom_point(aes(color = as.factor(year)), size = 2.5, show.legend = FALSE) +
  geom_smooth(method = "lm", formula = y ~ x, color = "#2C3E50", fill = "#BDC3C7", alpha = 0.3) +
  facet_wrap(~ year, ncol = 5) +
  labs(
    title = "연도별 삶의 만족도 점수 vs 자살률 상관관계 추이",
    subtitle = "2020년의 유의미한 음의 슬로프에서 점차 편평하게 변화하는 양상",
    x = "삶의 만족도 평균 점수 (5점 만점)",
    y = "인구 10만 명당 자살률 (명)"
  ) +
  theme_bw(base_family = "Malgun") +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    plot.subtitle = element_text(size = 10, hjust = 0.5, color = "gray30"),
    strip.background = element_rect(fill = "#ECF0F1"),
    strip.text = element_text(face = "bold", size = 11)
  )

ggsave(file.path(artifact_dir, "plot_yearly_facets.png"), plot = p4, width = 11, height = 4, dpi = 300)

# --- Plot 5: Gender-specific Scatter Plot (2020 Focus) ---
# Visualizing the stark contrast between Male and Female correlation in 2020.
df_2020 <- df_regions %>% 
  filter(year == 2020) %>%
  select(region, avg_score, suicide_남자, suicide_여자) %>%
  pivot_longer(cols = c(suicide_남자, suicide_여자), names_to = "gender", values_to = "suicide_rate") %>%
  mutate(gender = ifelse(gender == "suicide_남자", "남성 자살률 (r = -0.591*)", "여성 자살률 (r = 0.006)"))

p5 <- ggplot(df_2020, aes(x = avg_score, y = suicide_rate, label = region)) +
  geom_point(aes(color = gender), size = 3, show.legend = FALSE) +
  geom_text(vjust = -0.7, size = 3, family = "Malgun") +
  geom_smooth(method = "lm", formula = y ~ x, aes(color = gender), se = FALSE, size = 1) +
  facet_wrap(~ gender, scales = "free_y") +
  labs(
    title = "2020년 성별 자살률과 삶의 만족도 상관관계 비교",
    subtitle = "남성 자살률은 만족도와 뚜렷한 음의 관계를 보이나, 여성 자살률은 무관하게 관찰됨",
    x = "삶의 만족도 평균 점수 (5점 만점)",
    y = "인구 10만 명당 자살률 (명)"
  ) +
  scale_color_manual(values = c("남성 자살률 (r = -0.591*)" = "#2980B9", "여성 자살률 (r = 0.006)" = "#E74C3C")) +
  theme_light(base_family = "Malgun") +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    plot.subtitle = element_text(size = 10, hjust = 0.5, color = "gray30"),
    strip.text = element_text(face = "bold", size = 11, color = "black"),
    strip.background = element_rect(fill = "#F2F4F4")
  )

ggsave(file.path(artifact_dir, "plot_gender_diff.png"), plot = p5, width = 9, height = 4.5, dpi = 300)

# --- Plot 6: Ranked Bar Charts (2024 Regional Comparison) ---
# Ranked Bar Chart for 2024 Suicide Rate
df_2024 <- df_regions %>% filter(year == 2024)

p_bar_suicide <- ggplot(df_2024, aes(x = reorder(region, suicide_계), y = suicide_계)) +
  geom_bar(stat = "identity", fill = "#E74C3C", alpha = 0.8) +
  geom_text(aes(label = round(suicide_계, 1)), hjust = -0.1, size = 3, family = "Malgun") +
  coord_flip() +
  labs(
    title = "2024년 시도별 자살률 순위",
    x = "",
    y = "자살률 (명 / 10만명)"
  ) +
  theme_minimal(base_family = "Malgun") +
  theme(
    plot.title = element_text(face = "bold", size = 12, hjust = 0.5),
    axis.text.x = element_text(size = 9)
  )

# Ranked Bar Chart for 2024 Life Satisfaction
p_bar_satisfaction <- ggplot(df_2024, aes(x = reorder(region, avg_score), y = avg_score)) +
  geom_bar(stat = "identity", fill = "#3498DB", alpha = 0.8) +
  geom_text(aes(label = round(avg_score, 3)), hjust = 1.1, size = 3, family = "Malgun", color = "white") +
  coord_flip() +
  scale_y_continuous(limits = c(0, 4)) +
  labs(
    title = "2024년 시도별 삶의 만족도 점수 순위",
    x = "",
    y = "평균 만족도 점수 (5점 만점)"
  ) +
  theme_minimal(base_family = "Malgun") +
  theme(
    plot.title = element_text(face = "bold", size = 12, hjust = 0.5),
    axis.text.x = element_text(size = 9)
  )

# Combine using patchwork
p6 <- p_bar_suicide + p_bar_satisfaction + 
  plot_annotation(
    title = "2024년 시도별 자살률 vs 삶의 만족도 지표 랭킹 비교",
    theme = theme(
      plot.title = element_text(face = "bold", size = 14, hjust = 0.5, family = "Malgun")
    )
  )

ggsave(file.path(artifact_dir, "plot_regional_bars.png"), plot = p6, width = 11, height = 5.5, dpi = 300)

cat("Additional plots generated successfully!\n")
