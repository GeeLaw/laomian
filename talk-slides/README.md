# Talk Slides

Provides a template and a set of macros useful for preparing academic talks.

## `16x9-template.pptx`

The file [`16x9-template.pptx`](16x9-template.pptx) is the template that the author has been using for his slides. To prevent networking issues, it is the best to copy this file and edit the copy (instead of using the file as a template that can be linked). Remember to set Author, Title, Subject (PowerPoint presentation metadata) once you start editing the copy, as those metadata will be exported to PDF.

This template has been updated, so earlier slides of mine might use a different version. Personally, I aim to create perfectly aligned (the coordinates of most objects are typed, not dragged-and-dropped), accessible (correct object order, adequate annotation), beautifully animated (sometimes using Morph) slides, and the tools below have been very helpful.

亚洲字体已经设置为“思源黑体 CN”，请参考[思源黑体的文档](https://github.com/adobe-fonts/source-han-sans/blob/master/README-CN.md)。注意 PowerPoint 导出 PDF 时只能嵌入 TTF，而 OTF 会被光栅化，推荐的做法是下载 CN 的 Subset OTF，并用 [otf2ttf](https://pypi.org/project/otf2ttf/) 得到 TTF 并安装到当前 Windows 用户中。演示文稿的标题、副标题、最后的“谢谢”我都用的是[思源宋体](https://github.com/adobe-fonts/source-han-serif)（的 TTF 版本），汉字名字用的是楷体，术语的英文有些用单独的矩形加注（ruby 文字），例子见[我的学术主页](https://luoji.bio/)里较新的“报告”和“幻灯片”链接。

Asian fonts are set to “Source Han Sans CN”. Please refer to [its documentation](https://github.com/adobe-fonts/source-han-sans). Note that when PowerPoint exports a presentation to PDF, it will only embed TTF and will rasterize OTF. The recommended way is to download CN Subset OTF of Source Han Sans and use [otf2ttf](https://pypi.org/project/otf2ttf/) to obtain TTF, which can be installed to the current Windows user. I use (TTF of) [Source Han Serif](https://github.com/adobe-fonts/source-han-serif) for title and subtitle of the presentation, as well as the “Thanks” on the last slide, and use Kai for names in Chinese. Technical terms (jargons) are sometimes annotated with separate rectangles (ruby text). Examples can be found on [my academic home page](https://luoji.bio/) at recent links of “报告” and “幻灯片”.

## `Talk-Slides-Helper.pptm`

The file [`Talk-Slides-Helper.pptm`](Talk-Slides-Helper.pptm) provides two macros:

- Write Slide Numbers: To write slide numbers in a presentation using `16x9-template.pptx`. Sometimes, the animation has to be done over multiple PowerPoint slides, but the slide number should not advance. This is achieved by starting the note with `!number-1` on the continuation slides.
- Clear Custom Colors: This clears custom colors so that the presentation is clean when published.

It should be used as a PowerPoint add-in.

## PowerShell scripts

- [`Select-Presentation.ps1`](Select-Presentation.ps1): This is a helper script, not to be used directly.
- [`Rename-TitlePlaceholders.ps1`](Rename-TitlePlaceholders.ps1): This renames the unique title placeholder on each slide to `!!Title`.
- [`Rename-SlideNumberPlaceholders.ps1`](Rename-SlideNumberPlaceholders.ps1): This renames the unique slide number placeholder on each slide to `!!SlideNumber`.
- [`Confirm-ShapeNames.ps1`](Confirm-ShapeNames.ps1): This checks that the names of all shapes begin with `!!` and that there are no shapes with the same name inside each slide.

It is important to name shapes properly if you are using [the Morph transition](https://support.microsoft.com/en-us/office/use-the-morph-transition-in-powerpoint-8dd1c7b2-b935-44f5-a74c-741d8d9244ea), because [names override object matching](https://support.microsoft.com/en-us/office/morph-transition-tips-and-tricks-bc7f48ff-f152-4ee8-9081-d3121788024f).

## External Tools

Use [PPspliT](https://github.com/maxonthegit/PPspliT) to split the slides by animation key frames. This enables creating PDF with each key frame as a page, so that you can use PDF “with animation” and stop worrying about possible compatibility issues. An Internet shortcut named [`PPspliT.url`](PPspliT.url) is stored in this repository.
