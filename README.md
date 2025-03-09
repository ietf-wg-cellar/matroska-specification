[![CI](https://github.com/ietf-wg-cellar/matroska-specification/actions/workflows/generate-rfcs.yaml/badge.svg)](https://github.com/ietf-wg-cellar/matroska-specification/actions/workflows/generate-rfcs.yaml)

# Matroska Specification

This repository holds content related to the official Matroska specification and standard. Discussion of the plans for standardization is regulated on the [CELLAR listserv](https://datatracker.ietf.org/wg/cellar/charter/). Approved changes should be submitted to this repository as a pull request. The latest draft published from these specifications can be found at the [IETF Datatracker](https://datatracker.ietf.org/doc/draft-ietf-cellar-matroska/).

## About this repository

Local versions of the specification can be generated based on code in the `Makefile` directory and related dependencies. The dependencies required are `mmark`, `xml2rfc` and `xsltproc`. `mmark` is a Markdown processor written in Go, available [here](https://github.com/mmarkdown/mmark) . Installation instructions for `xml2rfc` (an XML-to-IETF-draft translator written in Python) are available on the [IETF Tools page](https://tools.ietf.org/tools/). `xsltproc` is a command line tool for applying XSLT stylesheets to XML documents. A bootstrap and Makefile are provided to gather dependencies and generate the RFC documents.

To create local copies of the RFC in `.txt`, `.md`, and `.html` format, run `make`.

To remove generated specifications, run `make clean`.

## Code of conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## License

The work in this repository is licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0). See [LICENSE.md](LICENSE.md) for details.
