plain_string <- function(x) {
  x |>
    stringr::str_to_lower() |>
    stringr::str_remove_all("[^a-z]+")
}

valid_tag <- function(x) {
  stringr::str_detect(x, "^[a-z]+([_:][a-z]+)*=[a-zA-Z]+([_ -][a-z]+)*$")
}

as_json <- function(x) {
  x |>
    jsonlite::toJSON(auto_unbox = TRUE, pretty = TRUE) |>
    stringr::str_replace_all("  ", "    ")
}
