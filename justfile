default: manifest

format:
    just --fmt --unstable
    air format .

manifest: format
    #!/usr/bin/env Rscript
    rsconnect::writeManifest("i2i-shiny")
