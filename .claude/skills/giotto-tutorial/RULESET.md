# Writing a tutorial for the Giotto Suite website

Suggestions for what a tutorial contains. The mechanics — branch,
registration, tagging, checks, PR — are covered elsewhere.

* **Tutorial skill** —
  <https://github.com/giotto-suite/Giotto_website/tree/dev/.claude/skills/giotto-tutorial>
* **Converter** —
  <https://github.com/giotto-suite/Giotto_website/blob/dev/pkgdown/convert-tutorial.R>
* **Contributing guide** — `vignettes/contributing_tutorials.Rmd`, published
  on the site

Read the skill first; it is the more current of the two, so follow it where
they disagree.

**Nothing here is enforced.** The items that break a build or a page are
mechanics and live in the skill: `pkgdown: as_is: true`, registration under
`articles:`, tags from the controlled vocabulary, and figure chunks that
evaluate. Check those there.

**What this describes.** The site holds over a hundred tutorials written over
several years, and they are not one thing. Most of what follows was read off
the recent disk-backed set, which is the most consistent cohort and the one
still being added to. The older tutorials often differ: Further reading
appears in none of the other hundred-odd, and comment density across the site
runs from nothing to half the lines. So a departure in an older tutorial is
usually its age, not a mistake, and nothing here is a reason to go back and
change it.

## Using this document

**Writing a new tutorial.** The sections below are a reasonable order, and a
reasonable set of things to think about.

**Revising a published one.** It already has a shape, readers and incoming
links. Change what is wrong, not what merely differs from the order below.
Overlap with a page you are replacing is not duplication, and a section the
old page carried stays unless it was wrong. Keep the slug, and do not cite the
superseded page under Further reading.

**Reviewing someone's tutorial.** Separate the mechanics from the suggestions,
and ask why before calling a departure a defect. Most are deliberate.

---

## 1. The pipeline

```
write the .Rmd  ->  render, iterate  ->  final render
                ->  convert (renders nothing)
                ->  preview locally, tweak
                ->  PR
```

**Publishing does not render.** The converter reads the `.Rmd` for code and
prose and the rendered `.html` for figures and output. You render while
writing; the last of those renders is what gets published.

It refuses when the `.Rmd` is newer than the `.html`, because it matches each
figure to its chunk through the source echoed beside it: a mismatched pair
silently shows a figure next to code that did not produce it.

**Preview before the PR.** About a minute, and it shows what the site build
does to your content that a local render does not — layout, spacing, column
widths.

**Check the numbers in the prose against the numbers in the output.** A
tutorial states values in its text, comments and tables: a median gene count,
cells surviving filtering, top genes, file sizes. Each is written once and
survives every re-render, including the ones where the answer changed. Take
each number and find it in the output below, or in the file it describes. File
sizes need this most, because nothing in the tutorial produces them — a table
of vendor downloads is typed from whatever the files were that day, and no
later render disagrees with it. Drifted numbers look exactly as plausible as
correct ones, which is why this is done by reading rather than by noticing
something wrong.

---

## 2. Shape

**Give the detail to what the tutorial is teaching, and compress the rest to
what is needed to reach it.** A segmentation tutorial inserts sections for
building and applying polygons and may fold normalization, dimension reduction
and clustering into one, because they are the road rather than the
destination. A cell typing tutorial does the reverse. Both are right, and that
principle outranks the list below.

The overview, dataset explanation, setup, reading the data and session
information appear in nearly every published tutorial. The rest are
situational: nothing extra to install skips the install section, a targeted
panel skips feature selection, a tutorial stopping before clustering skips the
last two. An absent situational section is not a gap.

1. **Overview** — what this does, in about three sentences, ending with what
   the reader will have. Name close relatives here rather than saving them for
   Further reading: someone on the wrong variant should find out in the first
   paragraph, not the last.

   Link the dataset by name at its first mention, and close with a line on run
   time and memory: the total time, the parallel workers and the machine's
   memory, linking to **Run time and memory** at the end. A reader decides
   here whether the tutorial suits their computer.

2. **Install packages** — the Giotto install, typically `suite_install()`,
   then anything a normal install lacks. The extras are optional; the section
   is not. Anything that must be built before Giotto goes first and alone.

   *NOTE:* everything named here has to be installable by the reader. A
   package still in a private repository makes the tutorial unreproducible
   outside the group that wrote it, and nothing checks this.

   *NOTE:* say which branch an install resolves to. `suite_install()` and a
   bare `install_github()` both follow whatever a branch points at on the day
   the reader runs them, so a tutorial written against one line of development
   can quietly install another later. Name the ref you tested against.

   *NOTE:* a suggested dependency is not an installed one. Giotto lists
   several packages under `Suggests:` rather than `Imports:` — the nearest
   neighbor backend used for clustering among them — so a clean library gets
   them only if asked. Name any the tutorial needs.

   The last two fail the same way: invisibly, because the library you rendered
   from is already correct.

3. **Dataset explanation** — the technology, the specimen, a table of files
   and sizes, and **how it was processed** where you know it: the vendor
   pipeline, the segmentation, whether a matrix shipped with it.

   Link the dataset by name to the page it comes from, such as the vendor's
   dataset page, here as well as in the Overview. The name says which release
   this is, and the page outlives direct file URLs. Then give the routes to
   the files: a command line, and a click-through precise enough to reach the
   exact file, which also reveals when the direct link has gone stale.

4. **Packages and setup** — library calls, paths, parallel workers, and the
   instructions object if you use one. One chunk holds every path. A seed
   belongs wherever it is first needed.

   Order the library calls so anything that must precede Giotto goes first,
   then Giotto, then the rest. With GiottoDisk that means `arrow` first; the
   tutorials loading it are exactly the disk-backed ones, and an in-memory
   tutorial needs none of this. Set the parallel plan here and say it is the
   reader's to change: worker count is a property of their machine, and each
   worker costs memory.

5. **Read the data** — the platform's convenience reader.

   With a disk backend, show `GiottoDisk::sourceCreate()` and
   `GiottoDisk::setArtifactDumpDir()` first, each with a sentence. For such a
   tutorial that is subject matter, not plumbing.

   Expression belongs here. Where the vendor ships a matrix, use it by default
   and optionally put rebuilding it from transcripts in a dropdown, framed as
   what you do when you need it: resegmentation, different boundaries. Where
   no matrix ships, the aggregation is the point and stays open.

   Worth a short section of its own afterwards on **what the reader can turn
   down**: the window or crop, and which setting shrinks memory. The measured
   time and memory go at the end, in **Run time and memory**.

6. **Quality control and filtering** — optionally a dropdown comparing the
   vendor's aggregation against your own. It is a check; nothing downstream
   reads it.

7. **Normalization and feature selection** — *feature selection depends on the
   panel.* Whole-transcriptome data selects highly variable features; a
   targeted panel does not, because the panel is already the selection. Say
   which case you are in rather than running it reflexively or omitting it
   silently.

8. **Dimension reduction** — optionally, check whether a component tracks a
   technical covariate rather than biology. Depth, feature count and cell area
   are the usual suspects, and a component loading on them is worth knowing
   before it drives the clustering.

9. **Clustering** — if a later section maps cluster numbers to names, say so
   near the mapping: *Leiden cluster numbers can change between package
   versions or numbers of workers. Check the markers before reusing this
   mapping on your own run.* That mapping is the one piece of a tutorial that
   can be silently wrong on a reader's machine while every figure still
   renders.

**Past clustering the tutorial is on its own** — cell typing, spatial
relationships, niches, interoperability, whatever it is for.

**After the analysis, Further reading.** Name the two or three tutorials a reader
of *this* page would open next, and say in a clause why. The test is whether
the link answers a question this tutorial raised and left open; a shared
platform or function is not a reason on its own, and a catalogue of adjacent
pages is worse than no section. What tends to qualify: a sibling on the same
specimen, a tutorial covering a method this one used but did not explain, and
the in-memory or disk-backed counterpart. Browse the site and pick what a
reader would actually want.

**Then, Run time and memory.** How long each section took and the most memory
it used, on the machine that built the page. Name the machine (processor,
cores, memory) and each setup measured: the parallel workers, and if you can,
a second run limited to what a 16 GB laptop has. Give each setup's total and a
sentence on where the time goes. Then:

- **A figure:** one bar per section, wall time and peak memory side by side,
  one color per setup. A section is a top-level heading, so the bars match
  the page.
- **How memory was measured**, in a sentence: what was counted (the R session
  and its parallel workers together), how often it was sampled, and that each
  bar is the highest value in that section. Report resident memory (section
  7).
- **A dropdown** with the same numbers as a table, for readers who want them
  exactly.

The Atera kidney tutorial is the worked example. This is the most useful
thing on the page for anyone deciding whether to follow along.

**Last, session info.**

---

## 3. Show, fold, or inline

The question is what the reader does with it.

| | |
|---|---|
| **Show** | what they must adapt or replicate: paths, thresholds, curated panels, cluster naming, palettes, and every plotting call |
| **Fold** | what they will generate themselves: differential-expression tables, cross-tabs, object listings, verification checks, long output |
| **Inline** | short output, roughly fifteen lines or fewer |

**Short output can stay inline** — a dropdown costs a click to reveal three
lines. Prefer a formatted summary line over printing a whole object. This is a
guide, not a threshold: a long table meant to be scanned can stay inline, and
a short one interrupting the argument can fold.

**Decide what the reader sees, not what the render printed.** Most output is
chatter: readers and writers announcing themselves, progress lines, disk
backend status. Nearly all of it is R messages, and once rendered a message
looks exactly like a deliberate `print` or `cat`. So mark them in the setup
chunk:

```r
knitr::opts_chunk$set(class.message = "message", class.warning = "warning")
```

The render then tags every message and warning, you still see them in your
HTML, and the converter leaves them out. If a render does not mark them, the
converter says so in its report. A value the reader needs is therefore
printed, never left to a message: an assignment such as `k <- best_k(...)`
prints nothing, so print `k` or `cat()` a summary line.

You never have to ask to see output while rendering; that happens anyway. What
you write is what to hide, and from whom:

| in the chunk header | you see it rendering | the reader sees it |
|---|---|---|
| *nothing*, for a message or warning | yes | no |
| *nothing*, for printed output | yes | **yes** |
| `keep_output = FALSE` | **yes** | no |
| `message = FALSE`, `warning = FALSE`, `results = 'hide'` | no | no |

What the setup line cannot catch is a function announcing itself with `cat()`
or `print()` rather than a message. Turn it off at the call, usually
`verbose = FALSE`, or mark the chunk `keep_output = FALSE`.

Suppressing at render time is simplest to reason about, because the output
never exists; use it where the chatter is useless to everyone, including you.
`keep_output = FALSE` is for the rest: a long step whose progress you want to
watch, a saved snapshot announcing itself. Changing your mind about it costs a
conversion rather than a render.

**The default: every figure is published, every printed value is published,
and no message or warning is.** Printed means a value auto-printed as a
chunk's last expression, `print()` or `cat()`. A summary line is
`cat(sprintf(...))`: a bare `sprintf()` is published too, but as a quoted
string after `[1]`. Convert once, read what came through, and mark what should
not have.

**Two mechanics, since neither is obvious.** A dropdown is a plain HTML
`<details>` block around the chunk with a `<summary>` line; markdown has no
syntax for it. And printed output reaches the page as a fenced block below its
chunk with knitr's `##` prefix stripped. Both styles exist in the corpus, so
when editing an older tutorial match the one already there.

Two constraints on top:

- **Folded is allowed; absent is not.** Code producing a figure must appear
  somewhere, open or in a dropdown. No hidden chunk may make a figure or an
  object used later.
- **Visuals stay visible.** Plotting code is not folded, except checks already
  inside a dropdown.

Length is not the test: a long block of curated marker genes stays open,
because it feeds a figure and a reader on another tissue must replace it.

**A chunk you want folded cannot also be the one producing a visible figure.**
Split them.

---

## 4. Figures

- **Every figure chunk labeled.** Images are named from the label.
- The figure must reach the rendered HTML or conversion finds nothing. Let the
  plot print, or return it as the chunk's last expression — both work.
- Compose with care: a saver captures a plot at the moment of the call and
  misses anything added afterwards. Route composed figures through the
  function that saves an already-built plot.
- Name every saved figure. Defaults collide when the same plot function is
  called twice.
- Keep plotting simple, and prefer the plot's own output over post-hoc
  styling.

**Resolution and size.** The converter resizes every figure to at most 1,100
pixels wide, and the site shows each one at the full width of the content
column. Nothing above that reaches the site, so aim for width × dpi near
1,100 (7 inches at dpi 150 is 1,050) rather than far above it: overshooting
is discarded, inflates the HTML, and has broken figure extraction outright.
To make a map read better at that size, change point size or figure shape,
not dpi.

Keep a tutorial's figures to roughly fifteen megabytes. The repository is near
its hosting limit and images are most of it, so this is a real constraint.

---

## 5. Code and variables

**Comments say why, not what.** Three to fifteen percent of code lines is a
reasonable range to aim for, and the recent tutorials sit near the bottom of
it. A brief comment naming what a call is for is useful; one restating the
call is not, and a chunk needing many is often a chunk to split or a function
that should exist.

**If you are working with an agent, it should not add comments you did not ask
for.** A requested change is a change; explaining it in the file is a separate
request. Ask for comments explicitly, and say how many.

**Write a function rather than helper code.** If a visualization or
calculation has no Giotto function, propose one to the relevant package and
call it. Helper code in a tutorial is a maintenance burden nobody owns.

The exception is code correcting a defect in the data. If an export is wrong
and the tutorial must repair it before anything works, that repair belongs in
the tutorial, visible, with a sentence on how the defect was found. It is not
a helper: a reader with the same platform needs to recognize the problem in
their own export, and a package function would hide the thing the section
teaches. Giotto assumes a correct export, so this stays until the vendor fixes
it. Worked example: the CosMx polygon offset, where the export writes polygon
positions at twice scale while the shapes are correct, so the fix is a
per-cell translation rather than a division.

**Hoist what the reader must change; leave the rest where it is used.** A
value they must edit belongs at the top with a name — paths, a seed, a label
map, a palette reused across figures, a window or threshold needing retuning.
A value they will never touch belongs inline: point sizes, strokes, a one-off
color.

**If a value repeats, name it. If it appears once or twice and is simple,
leave it in the call.** Repetition is the signal: the same color in four
plots, the same threshold in three chunks. A derived value is usually better
computed where needed than stored.

Prefer a stated constant over code that computes one. If a window is known,
give its coordinates and say what it contains rather than searching for it.

---

## 6. Paths and naming

- Every path in **one chunk**, behind an environment variable with a relative
  default. No absolute path anywhere else.
- No machine-specific path may survive into the published page, including
  inside printed output.
- Set figure dimensions once, so per-figure overrides carry only a name and a
  genuine difference.
- **Name the platform and the specimen, and leave the rest to the browser.**
  The published titles settle on one shape: the technology, the tissue, and
  where a page has siblings a short phrase saying what makes it different.
  *Visium HD Human Colorectal Cancer: Segmented Cells*. *Stereo-seq Mouse
  Testis: 10 um Bins*. The package name has already been removed from the
  titles that carried it. The dataset size has not: a couple still say *Mini
  Dataset*, which the browser filters on anyway. The exception is a tutorial
  whose subject *is* the package.

---

## 7. Header

Title and tags. Tags must satisfy the site's controlled vocabulary, which is
the authority rather than any example.

One more is **recommended, not expected**: an **`author`** field, so a reader
knows who to ask; three tutorials carry one. Run time and memory belong in the
body, not the header: a line in the Overview and a section at the end
(section 2).

When you report memory, report peak **resident** memory. Scheduler accounting often
reports virtual address space instead, which can read in terabytes for a job
that ran in gigabytes. Measure on a comparable machine rather than
extrapolating from core count: memory, not cores, decides whether a run
finishes.

---

## 8. Checks

`pkgdown/check-site.R` is the only automated check and the only thing here
that can block a build. It runs in CI on every pull request, takes about a
second, and reads text and YAML without building the site: registration under
`articles:`, navbar links that resolve, `pkgdown: as_is: true`, referenced
images that exist, and tags from the controlled vocabulary. It warns rather
than fails on a chunk that evaluates, because self-contained presentation code
legitimately does.

Everything else here is yours to apply by eye. Two failure modes deserve a
deliberate look before the PR, because a local render shows neither:

- **An unbalanced code fence** swallows everything after it and appears only
  once the page is built.
- **A machine-specific path** reaching the page, in code or in output.
