library(rvest)
library(pbapply)
library(jiebaR)

url <- "https://zh.wikisource.org/w/index.php?title=%E4%B8%89%E5%9C%8B%E6%BC%94%E7%BE%A9/%E7%AC%AC001%E5%9B%9E&printable=yes"


read_chapter <- function(url) {
    dom <- read_html(url)
    title <- dom %>% html_nodes("tr+ tr td")  %>% .[2] %>% html_text()
    content <- dom %>% html_nodes("dd , p") %>% html_text(trim = T) %>% paste0(collapse = "")
    whole <- paste(title, content, "\n")
    write(whole, "data/three_kingdoms.txt", append = T)
}



toc_url <- "https://zh.wikisource.org/zh-hant/%E4%B8%89%E5%9C%8B%E6%BC%94%E7%BE%A9"

dom <- read_html(toc_url)
paths <- dom %>% html_nodes("#mw-content-text li a") %>% .[1:120] %>% html_attr("href")
urls <- lapply(paths, . %>% paste0("https://zh.wikisource.org",.))

urls %>% pblapply(read_chapter)


mixseg = worker()
mixseg$output = "data/three_kingdoms_cut.txt"

mixseg["./data/three_kingdoms.txt"]
