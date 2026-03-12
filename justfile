default: manifest

format:
    just --fmt --unstable
    taplo fmt air.toml
    air format .

manifest: format
    #!/usr/bin/env Rscript
    rsconnect::writeManifest("i2i-shiny")
