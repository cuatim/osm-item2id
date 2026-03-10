get_item_by_title <- function(title) {
  req <-
    httr2::request("https://wiki.openstreetmap.org/w/api.php") |>
    httr2::req_url_query(
      action = "wbgetentities",
      format = "json",
      sites = "wiki",
      titles = title
    )

  resp <- httr2::req_perform(req)

  resp |>
    httr2::resp_body_json() |>
    purrr::chuck("entities", 1)
}
