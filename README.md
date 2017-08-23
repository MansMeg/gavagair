# gavagair
Connection to the Gavagai API to extract tonality . This is **not** an official product of Gavagai. This package try to conform to the ideas of tidy text analysis. See more [here](https://cran.r-project.org/web/packages/tidytext/vignettes/tidytext.html).

## Get started
1. You need to get an api key from Gavagai. You need to get an account [here](https://developer.gavagai.se). To try out the API you can 
There are academic licenses, but then you need to contact Gavagai.

Install the ```gavagair``` R package.
```
install.packages("devtools")
devtools::install_github("MansMeg/gavagair")
```

## Use the API

We start out by creating two sentences from Jane Austens "Pride and prejudice"" we want to get tonality for:

```
install.packages("devtools")
library(janeaustenr)
data("prideprejudice")
pride_sentence <- 
  c(paste(prideprejudice[10:11], collapse = " "),
    paste(prideprejudice[13:16], collapse = " "))

pride_sentence
```

In the next step we want to get the tonality for these sentences. We can get tonality for multiple languages:

```
library(gavagair)
api_key <- "[PUT YOR GAVAGAI API KEY HERE]"
supported_languages(api_key)

 [1] "AR" "AZ" "BG" "BN" "CA" "CS" "DA" "DE" "EL" "EN" "ES" "ET" "FA" "FI" "FR" "HE" "HI"
[18] "HR" "HU" "ID" "IS" "IT" "JA" "JV" "KO" "LT" "LV" "MS" "NL" "NO" "PL" "PT" "RO" "RU"
[35] "SK" "SL" "SQ" "SV" "SW" "TH" "TL" "TR" "UK" "UR" "VI" "ZH"
```

We can see that english is supported. Lets get the tonality for our two sentences:

```
gavagai_tonality_object <- 
  tonality(texts = pride_sentence, api_key = api_key, language = "en")
```

The API returns an gavagai tonality api object. From this we can extract the document level, senetence level and individual tonality types/ngrams:

```
> tonality_document(gavagai_tonality_object)
# A tibble: 2 x 17
  doc_id score_violence score_fear score_desire score_skepticism score_negativity
   <chr>          <dbl>      <dbl>        <dbl>            <dbl>            <dbl>
1      1              0          0            0                0                0
2      2              0          0            0                1                0
# ... with 11 more variables: score_positivity <dbl>, score_hate <dbl>, score_love <dbl>,
#   score_normalized_violence <dbl>, score_normalized_fear <dbl>,
#   score_normalized_desire <dbl>, score_normalized_skepticism <dbl>,
#   score_normalized_negativity <dbl>, score_normalized_positivity <dbl>,
#   score_normalized_hate <dbl>, score_normalized_love <dbl>
```

```
> tonality_sentence(gavagai_tonality_object)
# A tibble: 2 x 11
  doc_id sentence_id
   <chr>       <int>
1      1           1
2      2           1
# ... with 9 more variables: sentence <chr>, score_violence <dbl>, score_fear <dbl>,
#   score_desire <dbl>, score_skepticism <dbl>, score_negativity <dbl>,
#   score_positivity <dbl>, score_hate <dbl>, score_love <dbl>
```

```
> tonality_ngram(gavagai_tonality_object)
# A tibble: 3 x 5
  doc_id sentence_id   tonality   ngram score
   <chr>       <chr>      <chr>   <chr> <dbl>
1      1           1 positivity    good     1
2      1           1 positivity fortune     1
3      2           1 skepticism  may be     1
```
