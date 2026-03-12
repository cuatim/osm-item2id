to_preset <- function(item, get_item_callback = get_item) {
  withr::local_collate("C")

  tag <- pluck_s(item, "P19", 1)
  key_value <- stringr::str_split_1(tag, "=")
  key <- key_value[1]
  value <- key_value[2]

  name <-
    value |>
    stringr::str_replace_all("_", " ") |>
    stringr::str_to_title()

  aliases <-
    item |>
    purrr::pluck("aliases", "en") |>
    purrr::map(
      \(x) {
        x |>
          purrr::pluck("value") |>
          stringr::str_to_title()
      }
    ) |>
    unlist() |>
    sort()

  # use alias if it is the same as name but contains white space (e.g., "Playhouse" -> "Play House")
  name_from_alias <- aliases[plain_string(aliases) %in% plain_string(name)]
  if (rlang::is_string(name_from_alias)) {
    name <- name_from_alias
  }

  tags <-
    value |>
    as.list() |>
    rlang::set_names(key)

  geometries <- c(point = "P33", line = "P34", area = "P35")
  geometry <-
    item |>
    purrr::pluck("claims") |>
    # only keep "is applicable" statements
    purrr::keep(\(x) {
      identical(x |> dplyr::first() |> pluck_v("id"), "Q8000")
    }) |>
    names() |>
    purrr::quietly(forcats::fct_recode)(!!!geometries) |>
    purrr::chuck("result") |>
    sort()

  fields <-
    item |>
    # get combination statement
    purrr::pluck("claims", "P46") |>
    # extract QIDs
    purrr::map(\(x) pluck_v(x, "id")) |>
    # get full item for each QID
    purrr::map(get_item_callback) |>
    # only keep "instance of" = "key"
    purrr::keep(\(x) identical(pluck_s(x, "P2", 1, "id"), "Q7")) |>
    # extract "permanent key ID"
    purrr::map(\(x) pluck_s(x, "P16", 1)) |>
    unlist() |>
    sort()

  structure(
    list(
      # based on https://github.com/ideditor/schema-builder?tab=readme-ov-file#preset-schema
      name = name,
      aliases = as.list(aliases),
      terms = list(),
      tags = tags,
      geometry = as.list(geometry),
      icon = "",
      fields = list(),
      moreFields = as.list(fields)
    ),
    qid = purrr::chuck(item, "id"),
    tag = tag,
    key = key,
    value = value
  )
}
