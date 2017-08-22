#' Extract supported languages from the Gavagai API
#' 
#' @param api_key API key to use to connect to the API.
supported_languages <- function(api_key){
  checkmate::assert_string(api_key)
  base_url <- "https://api.gavagai.se/v3/languages?apiKey="
  r <- httr::GET(url = paste0(base_url, api_key))
  httr::stop_for_status(r)
  unlist(httr::content(r))
}