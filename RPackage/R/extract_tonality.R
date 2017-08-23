#' Extract content from a Gavagai tonality object
#' 
#' @param x a \code{gavagai_tonality} object.
#' @export
document_scores <- function(x){
  checkmate::assert_class(x, "gavagai_tonality")
  dplyr::bind_rows(lapply(x$texts, extract_tonality_score_by_doc))
}

#' @rdname document_scores
#' @export
sentence_scores <- function(x){
  checkmate::assert_class(x, "gavagai_tonality")
  dplyr::bind_rows(lapply(x$texts, extract_tonality_score_by_sentence))
} 

#' @rdname document_scores
#' @export
ngram_scores <- function(x){
  checkmate::assert_class(x, "gavagai_tonality")
  dplyr::bind_rows(lapply(x$texts, extract_tonality_ngrams))
} 
