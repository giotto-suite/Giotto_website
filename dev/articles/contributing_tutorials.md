# Contributing tutorials to the website

To add a new example to the website <https://giottosuite.com>, please
follow these steps:

## 1 Clone the Giotto_website repository

Clone the Giotto_website repository from
<https://github.com/giotto-suite/Giotto_website> and switch to the
**“dev” branch**.

New tutorials go to `dev` first, where they are published to
<https://giottosuite.com/dev/> for review. They reach the live site when
`dev` is promoted to `suite`. **Do not branch from `suite`** — that
publishes straight to the released site with no review step.

## 2 Create a new R markdown file

Create a new .Rmd (R markdown) file under the folder “vignettes”.

- If you are planning to include figures as part of the tutorial, create
  a new folder under “vignettes/images” with the same name as your .Rmd
  file.
- All scripts need a header like shown below that starts at line 1.
- Here you should edit the title.

&nbsp;

    ---
    title: "TITLE TO USE"
    output: 
      html_document:
        number_sections: true
        toc: true
    pkgdown:
      as_is: true
    vignette: >
      %\VignetteIndexEntry{TITLE TO USE}
      %\VignetteEngine{knitr::rmarkdown}
      %\VignetteEncoding{UTF-8}
    ---

## 3 Set the R chuncks correctly

Absolutely no `eval=TRUE` for example code. To save time when rendering
the website, all chunks should not evaluate the code.

Image results should be included via linking or a `knitr` chunk of this
style:

    #knitr::include_graphics("images/TUTORIAL_FOLDER/#_IMAGE_NAME.png")

*The upper case sections just show which areas should be edited, not
that they need to be upper case*

## 4 Create your example

Add the text and code of your tutorial. Please use similar variable
names to previous tutorials, we have created a list of common variables
and default values in this
[spreadsheet](https://docs.google.com/spreadsheets/d/1ciK9-A0wR7IRotM6XwiTlImciDRnH-wMhJ0FKBcIWCI/edit?gid=0#gid=0).

## 5 Session info

Files should have a session info section at the end of the tutorial.

## 6 Preview the document

Knit the document to check if the vignette looks how you like, and that
it actually knits properly.

Optionally, you can run
[`pkgdown::build_site()`](https://pkgdown.r-lib.org/reference/build_site.html),
but this may be hard to run locally.

## 7 Register the tutorial in `_pkgdown.yml`

Add your tutorial in **two** places in `_pkgdown.yml`. Missing the
second one fails the build.

**1. Under `articles:`** — find the section your tutorial belongs to and
add the vignette name (the filename without `.Rmd`) to its `contents:`
list:

    - title: Analysis
      contents:
      - hvf
      - YOUR_VIGNETTE_NAME

**2. Under `navbar:`** — add a menu entry so people can find it, with
`href` pointing at `articles/YOUR_VIGNETTE_NAME.html`:

          - text: A short, descriptive title
            href: articles/YOUR_VIGNETTE_NAME.html

Because you are on the `dev` branch, this only affects the development
site. The change reaches <https://giottosuite.com> when `dev` is merged
into `suite`.

## 8 Preview locally

    Rscript pkgdown/preview-sites.R --dev --quick

This builds the site and opens it in a browser. `--quick` skips the
other tutorials so it takes about a minute; drop it for a full build.

## 9 Push the changes to Github

Push your branch and open a Pull Request **against `dev`**.

Once it is merged, the development site rebuilds and your tutorial
appears at <https://giottosuite.com/dev/>. The development build takes
roughly 5–10 minutes. (A full release build of the site takes
considerably longer — 40–70 minutes — because it also runs every
documentation example.)
