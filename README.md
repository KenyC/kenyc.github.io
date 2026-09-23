# My Website

Website:

 - [Typst v0.15.1](https://typst.app/) for compilation. 
 - [tacit](https://yegor256.github.io/tacit/) for CSS styling.


# Develop and build

Start an autoreloading server:

```sh
typst watch --features html --features bundle --format bundle site.typ
```

Build to `site/`

```sh
typst compile --features html --features bundle --format bundle site.typ
```