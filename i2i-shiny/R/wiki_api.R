item_api <- function(...) {
  req <-
    httr2::request("https://wiki.openstreetmap.org/w/api.php") |>
    httr2::req_url_query(
      action = "wbgetentities",
      format = "json",
      ...
    )

  resp <- httr2::req_perform(req)

  resp |>
    httr2::resp_body_json() |>
    purrr::chuck("entities", 1)
}

get_item <- function(x) {
  if (stringr::str_detect(x, "^Q[0-9]+$")) {
    item_api(
      ids = x
    )
  } else {
    item_api(
      sites = "wiki",
      titles = x
    )
  }
}
