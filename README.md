# gavagair
Connection to the Gavagai API to extract tonality . This is **not** an official product of Gavagai. This package try to conform to the ideas of tidy text analysis (but this is not yet fully implemented). See more [here](https://cran.r-project.org/web/packages/tidytext/vignettes/tidytext.html).

## Get started
1. You need to get an api key from Gavagai. You need to get an account [here](https://developer.gavagai.se). To try out the API you can 
There are academic licenses, but then you need to contact Gavagai.

2. Install the ```gavagair``` R package.
```
> install.packages("devtools")
> devtools::install_github("MansMeg/gavagair", subdir = "RPackage")
```

## Use the Gavagai API

We start out by creating two sentences from Jane Austens "Pride and prejudice" that we want to get the tonality for:

```
> install.packages("janeaustenr")
> data("emma", package = "janeaustenr")
> emma_paragraphs <- 
    c(paste(emma[15:18], collapse = " "),
      paste(emma[20:25], collapse = " "))
> emma_paragraphs

[1] "Emma Woodhouse, handsome, clever, and rich, with a comfortable home and happy disposition, seemed to unite some of the best blessings of existence; and had lived nearly twenty-one years in the world with very little to distress or vex her."
[2] "She was the youngest of the two daughters of a most affectionate, indulgent father; and had, in consequence of her sister's marriage, been mistress of his house from a very early period. Her mother had died too long ago for her to have more than an indistinct remembrance of her caresses; and her place had been supplied by an excellent woman as governess, who had fallen little short of a mother in affection."
```

In the next step we want to get the tonality for these sentences. We can get tonality for multiple languages:

```
> library(gavagair)
> api_key <- "[PUT YOR GAVAGAI API KEY HERE]"
> supported_languages(api_key)

 [1] "AR" "AZ" "BG" "BN" "CA" "CS" "DA" "DE" "EL" "EN" "ES" "ET" "FA" "FI" "FR" "HE" "HI"
[18] "HR" "HU" "ID" "IS" "IT" "JA" "JV" "KO" "LT" "LV" "MS" "NL" "NO" "PL" "PT" "RO" "RU"
[35] "SK" "SL" "SQ" "SV" "SW" "TH" "TL" "TR" "UK" "UR" "VI" "ZH"
```

We can see that english is supported. Lets get the tonality for our two sentences:

```
> gavagai_tonality_object <- 
    tonality(texts = emma_paragraphs, api_key = api_key, language = "en")
```

The API returns an gavagai tonality api object. From this we can extract tonality at the document level, at the senetence level and at the token/ngram level:

```
> tonality_document(gavagai_tonality_object)
# A tibble: 2 x 17
  doc_id score_violence score_fear score_desire score_skepticism score_negativity
   <chr>          <dbl>      <dbl>        <dbl>            <dbl>            <dbl>
1      1              0          0            0                1                2
2      2              0          0            0                0                1
# ... with 11 more variables: score_positivity <dbl>, score_hate <dbl>, score_love <dbl>,
#   score_normalized_violence <dbl>, score_normalized_fear <dbl>,
#   score_normalized_desire <dbl>, score_normalized_skepticism <dbl>,
#   score_normalized_negativity <dbl>, score_normalized_positivity <dbl>,
#   score_normalized_hate <dbl>, score_normalized_love <dbl>
```

```
> tonality_sentence(gavagai_tonality_object)
# A tibble: 3 x 11
  doc_id sentence_id
   <chr>       <int>
1      1           1
2      2           1
3      2           2
# ... with 9 more variables: sentence <chr>, score_violence <dbl>, score_fear <dbl>,
#   score_desire <dbl>, score_skepticism <dbl>, score_negativity <dbl>,
#   score_positivity <dbl>, score_hate <dbl>, score_love <dbl>
```

```
> tonality_ngram(gavagai_tonality_object)
# A tibble: 13 x 5
   doc_id sentence_id   tonality        ngram score
    <chr>       <chr>      <chr>        <chr> <dbl>
 1      1           1 skepticism     distress     1
 2      1           1 negativity     distress     1
 3      1           1 negativity          vex     1
 4      1           1 positivity       clever     1
 5      1           1 positivity         rich     1
 6      1           1 positivity  comfortable     1
 7      1           1 positivity        happy     1
 8      1           1 positivity     the best     1
 9      1           1 positivity    blessings     1
10      2           2 negativity     too long     1
11      2           1 positivity affectionate     1
12      2           2 positivity    excellent     1
13      2           2 positivity    affection     1
```
