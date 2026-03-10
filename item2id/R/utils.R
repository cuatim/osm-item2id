valid_tag <- function(x) {
  stringr::str_detect(x, "^[a-z]+([_:][a-z]+)*=[a-z]+([_-][a-z]+)*$")
}
