# Laomian `crypto-paper`: Awesome LaTeX Class for Paper in Cryptography

## Usage of class `crypto-paper`

```tex
\documentclass[
  layout=...,
  pdf-metadata=...,
  envelope-icons=...,
  opens-on=...,
  bst=...,
  vec=...,
  absurdum=...,
  links=...,
  fonts=...,
  underlines=...,
  non-anonymous,
  no-page-limits,
  no-table-of-contents,
  no-separate-title-page,
  no-total-number-of-pages,
  no-lncs-array-table-margins,
  no-swapped-table-caption-margins,
  no-footnotemark-skip,
  no-footnote-targeting,
  no-microtype,
  format=...
]{crypto-paper}
```

For technical reasons, the document is always two-sided (though it only appears two-sided in draft mode). All options are optional, but it is good habit to always specify `format=...`. Due to this reason, it is recommended that `format=...` be put last to ease source code version control without using a trailing comma.

**`format=`** specifies the format. It can be one of the following:

| name | shorthand | suitable for |
| :--- | :-------- | :---------- |
| `eprint` | E | submission to [Cryptology ePrint Archive](https://eprint.iacr.org/) |
| `eprint-draft` | E-D | ePrint work in progress |
| `lncs-camera-ready` | L-CR | submission of camera-ready source code to Springer in LNCS format |
| `lncs-camera-ready-reference` | L-CR-REF | creating a reference PDF for Springer (mimicking the final published result) |
| `lncs-camera-ready-iacr` | L-CR-IACR | creating a PDF archived by the IACR |
| `lncs-camera-ready-draft` | L-CR-D | camera-ready work in progress |
| `lncs-submission` | L-S | submission to IACR conferences |
| `lncs-submission-draft` | L-S-D | submission to IACR work in progress |
| `focs-submission` | F-S | submission to FOCS |
| `focs-submission-draft` | F-S-D | submission to FOCS work in progress |

The default is `eprint`. The following table describes the formats:

| format → | E | E-D | L-CR | L-CR-REF | L-CR-IACR | L-CR-D | L-S | L-S-D | F-S | F-S-D |
| -------: | :-  | :- | :- | :- | :- | :- | :- | :- | :- | :- |
| base format →<br>feature ↓ | &nbsp; | E | &nbsp; | L-CR | L-CR | L-CR | L-CR-IACR | L-S | E | F-S|
| don’t disturb | N/A | &nbsp; | Springer LNCS | N/A | N/A | N/A | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| base `\documentclass` | `article` | &nbsp; | `llncs` | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| `layout=` | `38x48` | &nbsp; | N/A | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | `6.5x9` | &nbsp; |
| paper | letter | &nbsp; | letter | LNCS | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| draft | ❌ | ✔ | ❌ | &nbsp; | &nbsp; | ✔ | &nbsp; | ✔ | &nbsp; | ✔ |
| running heads | ❌ | &nbsp; | ❌ | ✔ | &nbsp; | ✔ | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| anonymous | ❌ | &nbsp; | ❌ | &nbsp; | &nbsp; | &nbsp; | ✔ | &nbsp; | ✔ | &nbsp; |
| `pdf-metadata=` | `yes` | &nbsp; | `no` | `yes` | `yes` | `yes` | `no` | &nbsp; | `no` | &nbsp; |
| `envelope-icons=` | `yes` | &nbsp; | `no` | `yes` | `yes` | `yes` | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| ORCID icons | ✔ | &nbsp; | ❌ | ✔ | ✔ | ✔ | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| IACR copyright | ✔ | &nbsp; | ❌ | &nbsp; | ✔ | &nbsp; | ❌ | &nbsp; | ❌ | &nbsp; |
| page numbers | ✔ | &nbsp; | ❌ | &nbsp; | ✔ | ✔ | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| total number of pages | ✔ | &nbsp; | ❌ | &nbsp; | ✔ | ✔ | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| table of contents | ✔ | &nbsp; | ❌ | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| separate title page | ✔ | &nbsp; | ❌ | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| `opens-on=` | `any` | `right` | N/A | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | `right` |
| `bst=` | `alpha` | &nbsp; | `splncs04` | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| supplementary materials | ❌ | &nbsp; | ❌ | &nbsp; | &nbsp; | &nbsp; | ✔ | &nbsp; | &nbsp; | &nbsp; |
| page limits | ❌ | &nbsp; | ✔ | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| `vec=` | `itbf` | &nbsp; | `itbf` | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| `absurdum=` | `hitwall` | &nbsp; | `hitwall` | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| `links=` | `colorful` | &nbsp; | `blue` | &nbsp; | `colorful` | `colorful` | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| `fonts=` | `source` | &nbsp; | `computer-modern` | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | `computer-modern` | &nbsp; |
| `underlines=` | `smart` | &nbsp; | `dumb` | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| LNCS array/table margins | ✔ | &nbsp; | ✔ | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| swap table caption margins | ✔ | &nbsp; | ✔ | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| LNCS theorem note styles | ❌ | &nbsp; | ✔ | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| footnote mark skip | ✔ | &nbsp; | ❌ | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| footnote targeting | ✔ | &nbsp; | ❌ | ✔ | ✔ | ✔ | &nbsp; | &nbsp; | &nbsp; | &nbsp; |
| `microtype` | ✔ | &nbsp; | ❌ | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; | &nbsp; |

**`layout=`** overrides the layout. It can be `38x48` (preferred by the 2023 version; `\textwidth` is 38 times font size and `\textheight` is 48 times `\baselineskip`) or `6.5x9` (FOCS submission; type center is 6.5in by 9in) or `6x9` (preferred by the 2022 version; type center is 6in by 9in). In addition, `38x48` and `6.5x9` use `\flushbottom`, but `6x9` does not. This option is meaningless if the document is in LNCS formats (the type center is always specified by LNCS). Technically, FOCS [requires](https://focs.computer.org/2023/) `6.5x9`, so it is better to not modify the layout for FOCS.

**`pdf-metadata=`** overrides the PDF metadata. It can be `yes` or `no`. This option is meaningless if the document is anonymous, in which case the PDF metadata are never emitted. This option is also meaningless if the document is set to not disturb Springer LNCS (the PDF metadata are never emitted if `format=lncs-camera-ready`).

**`envelope-icons=`** overrides whether envelope icons are shown for corresponding authors. It can be `yes` or `no`. This option is meaningless if the document is set to not disturb Springer LNCS (the envelope icons are never shown if `format=lncs-camera-ready`).

**`opens-on=`** overrides the opening side for the main body after the separate title page. It can be `right` or `any`. This option is meaningless if there is no separate title page (including the case if the document is in LNCS formats; the main body never starts on a new page).

**`bst=`** overrides the bibliography style. It can be `alpha` or `splncs04`.

**`vec=`** sets the vector style for `\vec`. It can be `itbf` or `bf`.

**`absurdum=`** sets the *reduction ad absurdum* symbol. It can be `hitwall` or `lightning`.

**`links=`** overrides the hyperlink colors. It can be `colorful` or `blue`.

**`fonts=`** overrides the fonts. It can be [`source`](https://github.com/adobe-fonts), `times`, `palatino`, `libertine`, `utopia`, or `computer-modern`. This option is meaningless if the document is in LNCS formats (the fonts are always Computer Modern).

**`underlines=`** overrides the underline style. It can be `smart` or `dumb`. Smart underlines skip descenders.

**`non-anonymous`** makes the paper non-anonymous (useful for [TCC](https://tcc.iacr.org/)). This option is meaningless if the document is in ePrint formats (the document is always non-anonymous).

**`no-page-limits`** marks that there is no page limit (useful for TCC). When this option is active, the appendix is also not (pretentiously) marked as “Supplementary Materials”. This option is meaningless if the document is in ePrint formats (the document never has page limits).

**`no-table-of-contents`** hides the table of contents. This option is meaningless if the document is in LNCS formats (the document never shows table of contents).

**`no-separate-title-page`** makes the body follow the abstract without starting on a new page. This option is meaningless if the table of contents is shown (a separate title page is always used) or if the document is in LNCS formats (a separate title page is never used).

**`no-total-number-of-pages`** makes the page numbers show as `x` instead of `x / y`. This option is meaningless if the page numbers are not shown (the total number of pages is never shown).

**`no-lncs-array-table-margins`** prevents setting `\arraycolsep` and `\tabcolsep` to 1.4pt. This option is meaningless if the document is in LNCS formats (the array/table inter-column margins are always set by LNCS).

**`no-swapped-table-caption-margins`** prevents swapping `\abovecaptionskip` and `\belowcaptionskip` (so that by default, the former is zero and the latter is non-zero). This option is meaningless if the document is in LNCS formats (the margins are always swapped by LNCS).

**`yes-lncs-theorem-note-styles`** changes the theorem notes to use the same style as the headings, e.g., boldfaced for theorems and italicized for remarks. This option is meaningless if the document is in LNCS formats (the notes always use the same style as the headings in LNCS).

**`no-footnotemark-skip`** disables improvement of footnote mark locations. This improvement is deferred to LNCS if the document is in LNCS formats. When this option is effective, use `\LaomianFnMarkSkip` to define the skip placed after a footnote mark. By default, it is `\hskip 1pt\relax`.

**`no-footnote-targeting`** disables improvement of footnote hyperlink target locations. This improvement is never enabled when the document is sent to Springer for typesetting.

**`no-microtype`** disables loading of package `microtype`. This package is never loaded if the document is in LNCS formats. Note that it is important to let the class be aware of `microtype`, because the adjustments should be disabled for table of contents.

## Special provision of license

As an exception, for a document typeset (e.g., using `pdflatex`) from modified versions of the files of Laomian that, when originally obtained from Laomian, are one of `crypto-paper` directory and its descendants and that are not any of `crypto-paper/paper/.example` or its descendants, reproduction of copyright or permission notice in the typeset document itself (e.g., `main.pdf`) is not required, and the typeset document itself can be distributed without those notices.

As a reminder, license to files does not imply license to the name of the author of Laomian. Researchers should supply proper metadata when preparing manuscripts. Any changes made after the files are obtained from Laomian are not covered by the license of Laomian. Researchers should write [their own copyright notice](LICENSE.md) for record-keeping purposes or in case the sources are published.

## What's new since the 2022 version?

The following have changed:

- The template is now a class, instead of a bunch of loose files.
- The output is technically two-sided (truly two-sided in draft mode).
- The type center for ePrint is slightly modified.
- The array/table inter-column margins for ePrint use the LNCS values.
- Some control sequences are renamed or undefined.

We aim for compatibility and ease of transition, so many of these changes can be reverted without observable difference. However, this version does not support one-sided output. Fortunately, this does not affect any non-draft output. To migrate from the 2022 version, use

```tex
\documentclass[
  layout=6x9,
  vec=bf,
  no-lncs-array-table-margins,
  no-swapped-table-caption-margins,
  ...
]{crypto-paper}
\LaomianTwentyTwentyTwo
```

to revert changes that alter horizontal or vertical typesetting and obtain the control sequences in the 2022 version.

The following tables describe the mapping between the 2022 version and this version:

| **the 2022 version**<br>`\input{preamble1}`<br>`...`<br>`\input{preamble2}` | **this version**<br><br>`\documentclass[format=...]{crypto-paper}`<br> |
| :- | :- |
| `\SubmissionWorkInProgress` | `lncs-submission-draft` |
| `\Submission` | `lncs-submission` |
| `\CameraReadyWorkInProgress` | `lncs-camera-ready-draft` |
| `\CameraReadyIACR` | `lncs-camera-ready-iacr` |
| `\CameraReadyReference`<br>(formerly `\CameraReadySpringer`) | `lncs-camera-ready-reference` |
| `\CameraReady` | `lncs-camera-ready` |
| `\ePrintWorkInProgress` | `eprint-draft` |
| `\ePrint` | `eprint` |

<!-- this comment splits the two tables -->

| **the 2022 version**<br>`...` | **this version**<br>`\documentclass[...]{crypto-paper}` |
| :- | :- |
| `\MakeNonAnonymous` | `non-anonymous` |
| `\UseColorfulLinks` | `links=colorful` |
| `\UseBlueLinks` | `links=blue` |
| `\NoPageLimits` | `no-page-limits` |
| `\DoNotUseFancyFonts` | `fonts=computer-modern` |
| `\UseNumericBib` | `bst=splncs04` |
| `\UseAlphaBib` | `bst=alpha` |
| `\HideTOC` | `no-table-of-contents` |
| `\NoSeparateTitlePage` | `no-separate-title-page` |

### Detailed Changes

This section lists the changes that affect typesetting.

**Two-sided output.** The output technically is always two-sided. It mostly reflects in the draft mode, where call-out boxes go to different sides on odd- and even-numbered pages. In ePrint draft mode, the main body by default starts on an odd-numbered page, so that when printed on both sides (flipping on long edge), the call-out boxes always goes to the outer side.

**Running headings.** Running heads are enabled when drafting the camera-ready and when creating the reference PDF mimicking Springer typeset result.

**Page numbers.** Page numbers default to `x / y` format with the total number of pages shown. Previous this was only enabled for ePrint. (This can be reverted using option `no-total-number-of-pages` when applied to LNCS formats.)

**ePrint new design.** The type center for ePrint is now 38 times font size wide (slightly narrower than before) and 48 times line height tall. It uses `\flushbottom` for vertical typesetting. It also picks up the array/table inter-column margins and the table caption margins from LNCS. Previously, the type center for ePrint is 6 inches wide 9 inches tall, it uses `\raggedbottom`, and it does not pick up the margins from LNCS. (This can be reverted using option `layout=6x9`.)

**Document date.** The document date is no longer automatically supplied. (`\LaomianTwentyTwentyTwo` supplies the date.)

**Renamed control sequences.** The following control sequences are renamed: (`\LaomianTwentyTwentyTwo` redefines the old names.)

```tex
% Format: \new % \old
\LaomianIacrCopyright   % \IACRCopyright
\LaomianBody            % \TypesetTableOfContents
\LaomianAcknowledgments % \TypesetAcknowledgement
\LaomianBibliography    % \TypesetBibliography
\LaomianAppendix        % \TypesetAppendix
\ClearFloats            % \clearfloats
\underlined             % \ul
```

**Undefined control sequences.** The following control sequences are undefined: (`\LaomianTwentyTwentyTwo` redefines them.)

```tex
\widenarrow
\dashboxed
\grayboxed
\varemptyset
\nothing
\security\phase\endsecurity
% ^^^ \begin{security}\phase{...} ...\end{security}
```

**Control sequences with different meaning.** The following control sequences have changed their meaning:

- `\vec` uses italicized boldface, the orthodox. (This can be reverted using option `vec=bf`.)
- `\varphi` and `\varepsilon` are the cursive versions (the non-cursive/lunate versions are `\dumbphi` and `\dumbepsilon`).
- `\bot` and `\concat` have improved spacing.
- `\LaomianAcknowledgments` looks for `acknowledgments.tex`.

`\LaomianTwentyTwentyTwo` reverts the second and the third bullet items, and it makes `\LaomianAcknowledgments` and `\TypesetAcknowledgement` fall back to `acknowledgement.tex` when `acknowledgments.tex` does not exist.

## Other Notes

### Version Controlling and Editing

Manual synchronization between Overleaf and GitHub is recommended. Use the following command to set up two remotes:

```
git remote add overleaf <Overleaf Git URL>
git remote add github <GitHub Git URL>
```

Since Overleaf still uses `master` as the branch name and GitHub has started using `main`, the two remotes will not have colliding branch names.

Please break lines semantically, e.g., after a sentence or a long clause. Avoid using a text-editor that formats the file to break at column 80. Please also try writing meaningful Git commit messages.

A recommended editor is [Visual Studio Code](https://code.visualstudio.com/), for which this repository has a version-controlled configuration file:

- The editor wraps at columns 80 (without changing the file content) or at the editor width, whichever is smaller.
- The integrated terminal opens at `paper` directory, convenient for running LaTeX commands for the paper.
- The spell-checker dictionary is stored.

After installing Visual Studio Code, a few useful customization are as follows:

- Run `code --install-extension streetsidesoftware.code-spell-checker` to install the spell checker. When adding a word in this paper, choose "add to folder dictionary". This will save the dictionary entry to `.vscode/settings.json`, and can be version-controlled.
- To use Visual Studio Code as the default Git editor, run `git config --global core.editor "code --wait"`. This gives an integrated experience when committing from the integrated terminal.

### Reading the Difference

Use `git diff --color=always --word-diff <opts/args> | ansi2html.sh > diff.html` at the root of the repository.
HTML files and `ansi2html.sh` at the root are ignored.

### Troubleshooting

If the integrated terminal does not open at `paper` directory...

- The user might have disallowed workspace shell overriding. To allow it, press Ctrl+Shift+P (or Cmd+Shift+P) in Visual Studio Code and type `terminal workspace shell`, choose "Terminal: Manage Workspace Shell Permissions", and then choose "Allow Workspace Shell Configuration".

If the integrated terminal opens Bash, but your default shell is the Z shell (`zsh`) or another shell... (see [Apple Support Knowledge Base article](https://support.apple.com/kb/HT208050))

- The configuration file uses PowerShell if it exists, and Bash otherwise. To use the Z shell instead, open `.vscode/settings.json` and change line 15 to `"cd ./paper >/dev/null 2>&1; PWSHFN=$(which pwsh); if [ $? -eq 0 ]; then exec /bin/bash -l -c \"$(printf \"exec %q -NoLogo\" \"$PWSHFN\")\"; else exec zsh -l; fi"`.

If BibTeX (distributed by MiKTeX) complains "Sorry---you've exceeded BibTeX's number of strings"...

- Run `initexmf --set-config-value [BibTeX]max_strings=35000` to increase the limit to 35000, which should be enough.
