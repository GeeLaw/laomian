# Talk Slides

Provides a template and a set of macros useful for preparing academic talks.

## `16x9-template.pptx`

This is the template that the author has been using for his slides. To prevent networking issues, it is the best to copy this file and edit the copy (instead of using the file as a template that can be linked).

This template has been updated, so earlier slides of mine might use a different version. Personally, I aim to create perfectly aligned (the coordinates of most objects are typed, not dragged-and-dropped), accessible (correct object order, adequate annotation), beautifully animated (sometimes using Morph) slides, and the tools below have been very helpful.

## `Talk-Slides-Helper.pptm`

This file provides two macros:

- Write Slide Numbers: To write slide numbers in a presentation using `16x9-template.pptx`. Sometimes, the animation has to be done over multiple PowerPoint slides, but the slide number should not advance. This is achieved by starting the note with `!number-1` on the continuation slides.
- Clear Custom Colors: This clears custom colors so that the presentation is clean when published.

It should be used as a PowerPoint add-in.

## PowerShell scripts

- `Select-Presentation.ps1`: This is a helper script, not to be used directly.
- `Rename-TitlePlaceholders.ps1`: This renames the unique title placeholder on each slide to `!!Title`.
- `Rename-SlideNumberPlaceholders.ps1`: This renames the unique slide number placeholder on each slide to `!!SlideNumber`.
- `Confirm-ShapeNames.ps1`: This checks that the names of all shapes begin with `!!` and that there are no shapes with the same name inside each slide.

It is important to name shapes properly if you are using [the Morph transition](https://support.microsoft.com/en-us/office/use-the-morph-transition-in-powerpoint-8dd1c7b2-b935-44f5-a74c-741d8d9244ea), because [names override object matching](https://support.microsoft.com/en-us/office/morph-transition-tips-and-tricks-bc7f48ff-f152-4ee8-9081-d3121788024f).
