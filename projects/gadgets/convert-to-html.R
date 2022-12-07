# Convertir rmd to md
require(knitr)
knit('test.rmd', 'test.md')

# Convertir md to html
require(markdown)
markdownToHTML('test.md', 'test.html')
