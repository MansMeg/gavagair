#' Extract content from a Gavagai tonality object
#' 
#' @param x a \code{gavagai_tonality} object.
#' @export
tonality_document <- function(x){
  checkmate::assert_class(x, "gavagai_tonality")
  dplyr::bind_rows(lapply(x$texts, extract_tonality_score_by_doc))
}

#' @rdname tonality_document
#' @export
tonality_sentence <- function(x){
  checkmate::assert_class(x, "gavagai_tonality")
  dplyr::bind_rows(lapply(x$texts, extract_tonality_score_by_sentence))
} 

#' @rdname tonality_document
#' @export
tonality_ngram <- function(x){
  checkmate::assert_class(x, "gavagai_tonality")
  dplyr::bind_rows(lapply(x$texts, extract_tonality_ngrams))
} 
