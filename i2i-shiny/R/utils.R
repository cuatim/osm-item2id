valid_tag <- function(x) {
  stringr::str_detect(x, "^[a-z]+([_:][a-z]+)*=[a-z]+([_-][a-z]+)*$")
}

as_json <- function(x) {
  x |>
    jsonlite::toJSON(auto_unbox = TRUE, pretty = TRUE) |>
    stringr::str_replace_all("  ", "    ")
}
