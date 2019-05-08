# Matroska Specification

This repository holds content related to the official Matroska specification and standard. Discussion of the plans for standardization is regulated on the [CELLAR listserv](https://datatracker.ietf.org/wg/cellar/charter/). Approved changes should be submitted to this repository as a pull request. The latest draft published from these specifications can be found at the [IETF Datatracker](https://datatracker.ietf.org/doc/draft-lhomme-cellar-matroska/).

## About this repository

Local versions of the specification can be generated based on code in the `Makefile` directory and related dependencies. The dependencies required are `mmark`, `xml2rfc` and `xsltproc`. `mmark` is a Markdown processor written in Go, available [here](https://github.com/miekg/mmark) or, for Homebrew users, can be installed with `brew install mmark`. Installation instructions for `xml2rfc` (an XML-to-IETF-draft translator written in Python) are available on the [IETF Tools page](https://tools.ietf.org/tools/). `xsltproc` is a command line tool for applying XSLT stylesheets to XML documents. 

To create local copies of the RFC in `.txt`, `.md`, and `.html` format, run `make`.

To create a local copy of the website, run `make website`. This command has additional dependencies. See the "About this site" section below for installing and local rendering.

To remove generated specifications, run `make clean`.

## About this site

This site runs on [GitHub Pages](https://pages.github.com/) powered by [Jekyll](https://github.com/jekyll/jekyll/blob/master/README.markdown). Approved changes made to the `master` branch of this repository can be viewed instantly on the [associated webpage](https://cellar-wg.github.io/matroska-specification/).

If this repository is cloned onto a local machine, it can be run locally. Jekyll runs on Ruby. Like many Ruby projects, it will require that Ruby is installed on the machine. Bundler, a popular Ruby package manager gem, can be used to install the other gem-based dependencies. After these are loaded properly, a local preview of any changes can be viewed by running `jekyll serve` on the command line. Jekyll provides more in-depth options for local usage [in their docs](https://jekyllrb.com/docs/usage/).

## Code of conduct

Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

## License

The work in this repository is licensed under the Creative Commons Attribution 4.0 International (CC BY 4.0). See [LICENSE.md](LICENSE.md) for details.
