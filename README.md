# osm-item2id

A tool to convert [OSM wikibase data items](https://wiki.openstreetmap.org/wiki/Data_items) to [iD Tagging Schema](https://github.com/openstreetmap/id-tagging-schema) entries.

## i2i interactive website

Makes preset drafts to facilitate faster creation of [pull requests](https://github.com/openstreetmap/id-tagging-schema/blob/main/CONTRIBUTING.md#making-changes). Prior experience with contributing to the iD Tagging Schema required.

**ALPHA release! This tool works best with complete input data. Incomplete data may result in crashes with unclear error messages.**

### Installation

Choose one of the following methods:

* Use the [publicly hosted version](https://cx-i2i.share.connect.posit.cloud/).
* Clone the repository and [deploy](https://shiny.posit.co/r/deploy.html) it yourself.
* Run locally in [RStudio](https://posit.co/download/rstudio-desktop/):

```r
shiny::runGitHub("osm-item2id", "cuatim", subdir = "i2i-shiny")
```

### Creating a new [preset](https://github.com/ideditor/schema-builder#presets)

1. Create or amend the [OSM wiki](https://wiki.openstreetmap.org/wiki/) entry for the tag.
2. Create or amend the corresponding wikibase [data item](https://wiki.openstreetmap.org/wiki/Data_items). Ensure all relevant properties are set. Incomplete data may cause the tool to fail.
3. Enter the tag in the tool to generate a preset [preset](https://github.com/ideditor/schema-builder#presets) draft.
4. Amend as needed:
    * `name`: This is just the value of the tag. May be too simple.
    * `terms`: Always empty. Fill manually or delete if not needed.
    * `icon`: Always empty. [Fill manually](https://github.com/ideditor/schema-builder/blob/main/ICONS.md).
    * `fields`/`moreFields`: All keys from the [combination property](https://wiki.openstreetmap.org/wiki/Property:P46) are placed into `moreFields`. Consider moving some to `fields` where appropriate. [Often other presets are referenced instead of listing all fields manually.](https://github.com/ideditor/schema-builder?tab=readme-ov-file#fieldsmorefields) Remove fields not implemented in iD (from the draft only, not the data item).
    * `aliases`, `tags`, and `geometry`: Should be correct already. If not, update the underlying data item.
    * Add [additional data](https://github.com/ideditor/schema-builder#preset-properties) as needed.
