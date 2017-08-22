#' Get tonality of text from Gavagai API
#' 
#' @param texts The texts to extract tonality from.
#' @param api_key API key to use to connect to the API.
#' @param language The language code in ISO 639-1
#' @param tonality What tonality should be returned. \code{NULL} is all.
#'
#' texts <- c("I love you!", "Indeterminacy of reference refers to the interpretation of words or phrases in isolation, and Quine's thesis is that no unique interpretation is possible, because a 'radical interpreter' has no way of telling which of many possible meanings the speaker has in mind. Quine uses the example of the word 'gavagai' uttered by a native speaker of the unknown language Arunta upon seeing a rabbit.")
#' language <- "en"
#' 
#' @export
tonality <- function(texts, api_key, language, tonality = NULL){
  checkmate::assert_character(texts, min.chars = 1, any.missing = FALSE, null.ok = FALSE)
  checkmate::assert_string(api_key)
  sup_lang <- supported_languages(api_key)
  checkmate::assert_choice(language, choices = c(sup_lang, tolower(sup_lang)))
  checkmate::assert_choice(tonality, choices = c("violence", "positivity", "skepticism", "negativity", "fear", "love", "hate", "desire"), null.ok = TRUE)
  
  call <- list(texts = dplyr::data_frame(body = texts, id = 1:length(texts)),
             language = language,
             includeSentences = TRUE)
  json_call <- jsonlite::toJSON(call, auto_unbox = TRUE)
  
  base_url <- "https://api.gavagai.se/v3/tonality?apiKey="
  r <- httr::POST(url = paste0(base_url, api_key), config = httr::content_type_json(), body = json_call)
  httr::stop_for_status(r)

  r_content <- httr::content(r)
  class(r_content) <- c("gavagai_tonality", "list")
  r_content
}

#' Extract sentence level sentiments and scores
#' @param x the text slot in a API result.
extract_tonality_score_by_sentence <- function(x){
  checkmate::assert_class(x, "list")
  checkmate::assert_names(names(x), permutation.of = c("id", "tonality"))
  
  res <- dplyr::data_frame(doc_id = x$id, 
                           sentence_id = 0, 
                           sentence = unlist(lapply(x$tonality[[1]]$sentences, FUN = function(X) X$text)))
  res$sentence_id <- 1:nrow(res)
  
  tones <- unlist(lapply(x$tonality, FUN = function(X) X$tone))
  tone_sent_score_list <- lapply(x$tonality, FUN = function(X) unlist(lapply(X$sentences, function(Y) Y$score)))
  names(tone_sent_score_list) <- paste0("score_", tones)
  tone_sent_df <- dplyr::as_data_frame(tone_sent_score_list)
  
  res <- dplyr::bind_cols(res, tone_sent_df)

  res
}

#' Extract document level sentiments and scores
#' @param x the text slot in a API result.
extract_tonality_score_by_doc <- function(x){
  checkmate::assert_class(x, "list")
  checkmate::assert_names(names(x), permutation.of = c("id", "tonality"))
  
  res <- dplyr::data_frame(doc_id = x$id)
  
  tones <- unlist(lapply(x$tonality, FUN = function(X) X$tone))
  tone_doc_score_list <- lapply(x$tonality, FUN = function(X) X$score)
  names(tone_doc_score_list) <- paste0("score_", tones)
  tone_doc_norm_score_list <- lapply(x$tonality, FUN = function(X) X$normalizedScore)
  names(tone_doc_norm_score_list) <- paste0("score_normalized_", tones)
  
  res <- dplyr::bind_cols(res, dplyr::as_data_frame(tone_doc_score_list), dplyr::as_data_frame(tone_doc_norm_score_list))
  
  res
}

#' Extract ngram with scores
#' @param x the text slot in a API result.
extract_tonality_ngrams <- function(x){
  checkmate::assert_class(x, "list")
  checkmate::assert_names(names(x), permutation.of = c("id", "tonality"))
  
  tones <- unlist(lapply(x$tonality, FUN = function(X) X$tone))
  tone_ngram_list <- lapply(x$tonality, FUN = function(X) lapply(X$sentences, function(Y) Y$ngrams))
  names(tone_ngram_list) <- paste0("ngram.", tones)
  tone_ngram_list <- lapply(tone_ngram_list, FUN = function(X) {names(X) <- 1:length(X);X})
  
  size <- sum(unlist(lapply(tone_ngram_list, FUN = function(X) lapply(X, length))))
  if(size == 0) return(NULL)
  
  tone_ngram_list <- unlist(tone_ngram_list)    
  ngram_bool <- stringr::str_detect(names(tone_ngram_list), "\\.ngram")
  score_bool <- stringr::str_detect(names(tone_ngram_list), "\\.score")
  
  txt <- names(tone_ngram_list[score_bool])
  txt_list <- stringr::str_split(txt, "\\.")
  
  ngram_df <- dplyr::data_frame(doc_id = x$id,
                                sentence_id = names(tone_ngram_list[score_bool]),
                                tonality = "",
                                ngram = tone_ngram_list[ngram_bool],
                                score = as.numeric(tone_ngram_list[score_bool]))
  ngram_df$tonality <- unlist(lapply(txt_list, function(X) X[2]))
  ngram_df$sentence_id <- unlist(lapply(txt_list, function(X) X[3]))
  
  ngram_df
}


