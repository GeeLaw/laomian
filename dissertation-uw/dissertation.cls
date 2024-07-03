\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{dissertation}[2024/07/02 Dissertation (UW PhD)]

\def\dstrn@letT#1\fi{\let#1\iftrue }
\def\dstrn@letF#1\fi{\let#1\iffalse}

\dstrn@letF\if@dstrn@wip\fi

\DeclareOption{wip}{\dstrn@letT\if@dstrn@wip\fi}
\DeclareOption*{\ClassError{dissertation}
  {There are unknown option(s)}
  {Remove unknown option(s) from "\string\documentclass[...]{dissertation}"}%
}
\ProcessOptions\relax

% Implicit option --- does the abstract fit in 1 page?
\global\def\dstrn@abstract@begin{-1}
\global\def\dstrn@abstract@end  {-1}

% Report options.
\begingroup\catcode`\ =12\relax%
\ClassInfo{dissertation}{%
Explicit options:\MessageBreak%
\string\if@dstrn@wip =\if@dstrn@wip true\else false\fi\MessageBreak%
}%
\AtBeginDocument{\ClassInfo{dissertation}{%
Implicit options (from previous run):\MessageBreak%
\string\dstrn@abstract@begin = \dstrn@abstract@begin\MessageBreak%
\string\dstrn@abstract@end   = \dstrn@abstract@end\MessageBreak%
}}%
\endgroup\relax

\LoadClass[letterpaper,twoside,openright,onecolumn,11pt,final]{book}

% -------------------- layout --------------------

% Sets the page layout.
\flushbottom
% This creates a very good visual appearance of double spacing,
% although technically the correct rate should be
%   10.95*2/13.6 ~= 1.61.
\def\baselinestretch{1.5}
\AtBeginDocument{% Apply 1.5x stretch to footnotes.
  \global\footnotesep=11.55pt\relax
  \global\skip\footins=15pt plus 6pt minus 3pt\relax
}
\iffalse % Kept for reference.
  \oneinch        =4736286sp  %  1    in
  \twoinches      =9472573sp  %  2    in
  \onepoint       =65536sp    %  1    pt
  \elevenpoints   =720896sp   % 11    pt
  \tenpointninetyfivepoints
                  =717619sp   % 10.95 pt
  \pdfpagewidth   =40258437sp %  8.5  in
  \pdfpageheight  =52099153sp % 11    in
  \pdfhorigin     =4736286sp  %  1    in
  \pdfvorigin     =4736286sp  %  1    in
\else    % The real job.
  \hoffset        =0sp        %
  \voffset        =0sp        %
  \textwidth      =27269530sp % 416.1 pt = 10.95 * 38      pt
  \textheight     =42781901sp % 652.8 pt = 13.6 * 1.5 * 30 pt
  \headheight     =786432sp   % 12 pt
  \headsep        =1310720sp  % 20 pt
  \footskip       =2097152sp  % 32 pt = (20 + 12) pt
  \marginparsep   =717619sp   % 10.95 pt
  \marginparwidth =5023334sp  % 76.65 pt = 10.95 * 7 pt
  \oddsidemargin  =1758167sp  %
  \evensidemargin =1758167sp  %
  % There are 3 kinds of pages:
  % - no header, no footer (first few pages, required by graduate school);
  % - no header, yes footer (after first few pages, before main text);
  % - yes header, no footer (main text).
  % Both header and footer are 32 pt tall (furthest bound to text bound).
  % The following three \topmargin variants are computed
  % to vertically center (header? + text + footer?).
  \def\dstrn@topmargin@neither{\topmargin=-2174812sp }
  \def\dstrn@topmargin@header{\topmargin=-1126236sp }
  \def\dstrn@topmargin@footer{\topmargin=-3223388sp }
\fi

% Hide page numbers from skipped pages.
\def\cleardoublepage{\clearpage
  \ifodd\c@page\else\null\thispagestyle{empty}\newpage\fi
}

\def\ps@empty{%
  \let\@oddhead\@empty
  \let\@evenhead\@empty
  \let\@oddfoot\@empty
  \let\@evenfoot\@empty
}
\def\ps@plain{%
  \let\@oddhead\@empty
  \let\@evenhead\@empty
  \def\@oddfoot{\hfil{\thepage}\hfil}%
  \let\@evenfoot\@oddfoot
}
\def\ps@headings{%
  \def\@oddhead{\hfil\thepage~/~\pageref*{LastPage}}%
  \def\@evenhead{\thepage~/~\pageref*{LastPage}\hfil}%
  \let\@oddfoot\@empty
  \let\@evenfoot\@empty
}
\let\ps@myheadings\ps@headings

% -------------------- captioning --------------------

\long\def\@makecaption#1#2{%
  \small
  \vskip\abovecaptionskip
  \sbox\@tempboxa{{\bfseries #1\@.} #2}%
  \ifdim\wd\@tempboxa>\hsize
    {\bfseries #1\@.} #2\par
  \else
    \global\@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip
}

% Captions are above the table.
% Swap the above/below inside table floats.
\newlength{\dstrn@bak@captionskip}
\renewenvironment{table}{%
  \setlength{\dstrn@bak@captionskip}{\abovecaptionskip}%
  \setlength{\abovecaptionskip}{\belowcaptionskip}%
  \setlength{\belowcaptionskip}{\dstrn@bak@captionskip}%
  \@float{table}%
}{\end@float}
\renewenvironment{table*}{%
  \setlength{\dstrn@bak@captionskip}{\abovecaptionskip}%
  \setlength{\abovecaptionskip}{\belowcaptionskip}%
  \setlength{\belowcaptionskip}{\dstrn@bak@captionskip}%
  \@dblfloat{table}%
}{\end@dblfloat}

% -------------------- basics --------------------

\RequirePackage[utf8]{inputenc}
\RequirePackage[english]{babel}
% "xcolor" ensures (though it might not be the only package that ensures)
% that the paper size is respected by pdfLaTeX.
\RequirePackage{xcolor}
\RequirePackage{float,graphicx}
\RequirePackage{tabularx,booktabs,multirow}
\RequirePackage{relsize}
\RequirePackage{afterpage}
\RequirePackage[normalem]{ulem}
\RequirePackage[outline]{contour}
\RequirePackage{lastpage}

\let\proof\dstrn@undefined
\let\endproof\dstrn@undefined
\RequirePackage{amsfonts,amsmath,amsthm,amssymb,mathtools}
\RequirePackage{bbm,dsfont,mathrsfs,stmaryrd}
\RequirePackage{dashbox}
\RequirePackage{marvosym}

\def\ClearFloats{\afterpage{\clearpage}}

% -------------------- headings --------------------

\def\part{\cleardoublepage\secdef\@part\@spart}
\def\@part[#1]#2{%
  \refstepcounter{part}%
  \addcontentsline{toc}{part}
    {Part~\texorpdfstring{\protect\tocpartnumber}{}{\thepart:{ }}#1}%
  \null\vfil
  {\centering\huge\scshape\partname\,\,\thepart\par}\vskip 12pt%
  {\centering\huge\bfseries #2\par}%
  \vfil\clearpage
}
\def\@spart#1{\ClassError{dissertation}
  {"\string\part*" is not supported}
  {Use "\string\part"}%
}
\newlength\dstrn@toc@part@number@width
\def\tocpartnumber#1{%
  \rlap{#1}\hspace*\dstrn@toc@part@number@width
}
\def\DissertationSetPartNumberWidth{\setlength\dstrn@toc@part@number@width}
\DissertationSetPartNumberWidth{1.6em}

\def\chapter{\cleardoublepage\secdef\@chapter\@schapter}
\def\@chapter[#1]#2{%
  \refstepcounter{chapter}%
  \typeout{\@chapapp\space\thechapter.}%
  \addcontentsline{toc}{chapter}
    {Chapter~\texorpdfstring{\protect\tocchapnumber}{}{\thechapter:{ }}#1}%
  \chaptermark{#1}%
  \addtocontents{lof}{\protect\addvspace{10\p@}}%
  \addtocontents{lot}{\protect\addvspace{10\p@}}%
  \@makechapterhead{#2}%
  \@afterheading
}
\def\@makechapterhead#1{\vspace*{6pt}%
  {\centering\LARGE\scshape\@chapapp\upshape\,\,\thechapter\par}%
  {\centering\LARGE\bfseries #1\par}\vskip 20pt\relax
  \nobreak
}
\def\@schapter#1{\@makeschapterhead{#1}\@afterheading}
\def\@makeschapterhead#1{\vspace*{6pt}%
  {\centering\LARGE\bfseries #1\par}\vskip 20pt\relax
  \nobreak
}
\newlength\dstrn@toc@chap@number@width
\def\tocchapnumber#1{%
  \rlap{#1}\hspace*\dstrn@toc@chap@number@width
}
\DeclareRobustCommand\tocchaplinebreak{%
  \\\hspace*{-\cftsecindent}%
  \hphantom{Chapter~}\hspace*\dstrn@toc@chap@number@width
}
\def\DissertationSetChapterNumberWidth{\setlength\dstrn@toc@chap@number@width}
\DissertationSetChapterNumberWidth{1.6em}

\newlength\dstrn@toc@chap@hanging
\DeclareRobustCommand\tocchaphanging{\hspace*\dstrn@toc@chap@hanging}
\def\DissertationSetChapterHangingIndent{\setlength\dstrn@toc@chap@hanging}
\DissertationSetChapterHangingIndent{2em}

\def\dstrn@front@matter@bookmark#1#2{\pdfbookmark[0]{#1}{#2}}
\def\dstrn@front@matter@toc#1#2{%
  % Modified from \phantomsection.
  \Hy@MakeCurrentHref{#2.0}%
  \Hy@raisedlink{\hyper@anchorstart{\@currentHref}\hyper@anchorend}%
  \addcontentsline{toc}{chapter}{#1}%
  \addtocontents{toc}{\protect\dstrn@toc@after@front@matter@active}%
}

% Special version for bibliography.
\def\dstrn@chapter@bib#1{\cleardoublepage
  % Modified from \phantomsection.
  \Hy@MakeCurrentHref{bib.0}%
  \Hy@raisedlink{\hyper@anchorstart{\@currentHref}\hyper@anchorend}%
  \addtocontents{toc}{\protect\dstrn@toc@before@bib}%
  \addcontentsline{toc}{part}{#1}%
  \@makeschapterhead{#1}\@afterheading
}

% LNCS style with reduced margin in front of it.
\def\subsubsection{%
  \@startsection{subsubsection}{3}{\z@}%
  {-12\p@ \@plus -4\p@ \@minus -4\p@}%
  {-0.5em \@plus -0.22em \@minus -0.1em}%
  {\normalfont\normalsize\bfseries\boldmath}%
}

% LNCS style with small-caps to stand out from remarks/proofs.
\def\paragraph{%
  \@startsection{paragraph}{4}{\z@}%
  {-12\p@ \@plus -4\p@ \@minus -4\p@}%
  {-0.5em \@plus -0.22em \@minus -0.1em}%
  {\normalfont\normalsize\scshape}%
}

% Disable \subparagraph.
\def\subparagraph{\ClassError{dissertation}
  {"\string\subparagraph" is not supported}
  {Restructure headings}%
}

% -------------------- draft mode --------------------

\dstrn@letF\if@dstrn@callout@inner\fi
\if@dstrn@wip
  % Adjust layout for call-outs.
  \marginparwidth =10046669sp % 175.2 pt = 10.95 * 14 pt
  \oddsidemargin  =-3623977sp %
  \evensidemargin =7140311sp  %
  % Show pink borders.
  \RequirePackage[pass,showframe]{geometry}
  \let\dstrn@bak@Gm@pageframes\Gm@pageframes
  \def\Gm@pageframes{\begingroup
    \color{red!50}\dstrn@bak@Gm@pageframes
  \endgroup}
  % Fix incorrectly positioned call-outs.
  \RequirePackage{mparhack}
  % Provide call-outs.
  \RequirePackage[
    backgroundcolor=white!0,
    linecolor=black!70,
    bordercolor=black!70,
    textsize=footnotesize
  ]{todonotes}
  \definecolor{dstrncallout1}{rgb}{0.965,0.365,0.208}
  \definecolor{dstrncallout2}{rgb}{0.506,0.733,0.020}
  \definecolor{dstrncallout3}{rgb}{1.000,0.729,0.027}
  \definecolor{dstrncallout4}{rgb}{0.016,0.647,0.941}
  \global\def\dstrn@callout@color{dstrncallout1}
  \global\def\dstrn@callout@color@a{dstrncallout2}
  \global\def\dstrn@callout@color@b{dstrncallout3}
  \global\def\dstrn@callout@color@c{dstrncallout4}
  \global\def\dstrn@callout@color@d{}
  \def\dstrn@callout@color@rotate{%
    \global\let\dstrn@callout@color@d\dstrn@callout@color
    \global\let\dstrn@callout@color\dstrn@callout@color@a
    \global\let\dstrn@callout@color@a\dstrn@callout@color@b
    \global\let\dstrn@callout@color@b\dstrn@callout@color@c
    \global\let\dstrn@callout@color@c\dstrn@callout@color@d
  }
  \long\def\callout#1{%
    \if@dstrn@callout@inner
      \par\noindent
      \textbf{Note: }\ignorespaces #1%
    \else
      \leavevmode
      \dstrn@letT\if@dstrn@callout@inner\fi
      \todo[
        linecolor=\dstrn@callout@color,
        bordercolor=\dstrn@callout@color
      ]{\begingroup\def\baselinestretch{1}\upshape\ignorespaces #1\endgroup}%
      \dstrn@letF\if@dstrn@callout@inner\fi
      \dstrn@callout@color@rotate
    \fi
    \ignorespaces
  }
\else
  % If a previous run was in WIP mode,  "todonotes" has produced
  % many instances of "\pgfsyspdfmark" in the ".aux" file via TiKZ.
  % Using TiKZ ensures that this first run after mode switch
  % does not get hit by undefined control sequences.
  \RequirePackage{tikz}
  \long\def\callout#1{\ignorespaces}
  \def\includeonly#1{\relax}
  % This appears to have no effect?
  % The definition from LaTeX
  % (also preventing \includeonly after \begin{document})
  % seems to be applied later.
  \AtBeginDocument{\def\includeonly#1{\ClassError{dissertation}
    {"\string\includeonly" can only be used in preamble}
    {Put "\string\includeonly" before "\string\begin{document}"}%
  }}
\fi

% ---------- table of contents, list of figures, list of tables ----------

\RequirePackage{tocloft}

% Make tocloft not use special page style.
\def\ps@dstrntoc{}
\tocloftpagestyle{dstrntoc}

\def\contentsname{Contents}
\def\listfigurename{List of Figures}
\def\listtablename{List of Tables}

\setlength{\cftbeforetoctitleskip}{24pt}
\setlength{\cftaftertoctitleskip}{18pt}
\let\cftbeforeloftitleskip\cftbeforetoctitleskip
\let\cftafterloftitleskip\cftaftertoctitleskip
\let\cftbeforelottitleskip\cftbeforetoctitleskip
\let\cftafterlottitleskip\cftaftertoctitleskip

\setcounter{tocdepth}{2}
\setcounter{lofdepth}{1}
\setcounter{lotdepth}{1}

\def\cfttoctitlefont{\vspace*{1ex}\hfill\LARGE\bfseries}
\def\cftaftertoctitle{\hfill\vspace*{1ex}}
\let\cftloftitlefont\cfttoctitlefont
\let\cftlottitlefont\cfttoctitlefont
\let\cftafterloftitle\cftaftertoctitle
\let\cftafterlottitle\cftaftertoctitle

\def\cftdot{{\color{gray}.}}

% Front matter constituents are tied closer together.
\setlength{\cftbeforepartskip}{0pt}
\setlength{\cftbeforechapskip}{5pt plus 0.5pt}
\setlength{\cftbeforesecskip}{0pt}
\setlength{\cftbeforesubsecskip}{0pt}

% The vertical spaces for the main text.
\def\dstrn@toc@ctfbeforeZskips{%
  \setlength{\cftbeforepartskip}{20pt plus 2pt}%
  \setlength{\cftbeforechapskip}{10pt plus 1pt}%
  \setlength{\cftbeforesecskip}{4pt plus 0.4pt}%
  \setlength{\cftbeforesubsecskip}{1pt plus 0.1pt}%
}

% Suppress the page numbers of \part's.
\let\dstrn@toc@bak@cftpartfillnum\cftpartfillnum
\def\cftpartfillnum#1{\dstrn@toc@bak@cftpartfillnum{}}

% The \jobname.toc looks like this:
%   \contentsline {!!!} % optional, for front matter
%   \dstrn@toc@after@front@matter
%   \contentsline {???} % optional, for main text
% The "???" is either "part" or "chapter".
% If there is no "!!!", we just set the vertical spaces.
\let\dstrn@toc@after@front@matter\dstrn@toc@ctfbeforeZskips
% When any "!!!" exists, we also adjust spacing of "???".
% The activation is inserted by \dstrn@front@matter@toc.
\def\dstrn@toc@after@front@matter@active{%
  \let\dstrn@toc@after@front@matter@active\relax
  \def\dstrn@toc@after@front@matter{%
    \dstrn@toc@ctfbeforeZskips
    \@ifnextchar\contentsline\dstrn@toc@after@front@matter@@{}%
  }%
}
\def\dstrn@toc@after@front@matter@@\contentsline#1{%
  \def\dstrn@toc@first@item{#1}%
  \def\dstrn@toc@first@item@part{part}%
  % Even if the first heading in the main text is \chapter,
  % we still want to apply the \part-level spacing.
  \ifx\dstrn@toc@first@item\dstrn@toc@first@item@part\else
    \vskip 10pt plus 1pt\relax
  \fi
  \contentsline{#1}%
}

% The \jobname.toc looks like this before the bibliography:
%   \dstrn@toc@before@bib
%   \contentsline {part}{Bibliography} ...
% We have suppressed the page numbers for \part's.
% Now we restore it.
\def\dstrn@toc@before@bib{%
  \let\cftpartfillnum\dstrn@toc@bak@cftpartfillnum
}

% -------------------- bibliography --------------------

\RequirePackage[noadjust,nomove,nosort,nocompress]{cite}
\def\DissertationBibliography#1{%
  \bibliographystyle{dissertation-alphaurl}%
  \let\dstrn@toc@bak@chapter\chapter
  \def\chapter{\@ifstar\dstrn@chapter@bib\dstrn@chapter@bib}%
  \bibliography{#1}%
  \let\chapter\dstrn@toc@bak@chapter
  \let\dstrn@toc@bak@chapter\dstrn@undefined
}

\mathchardef\citeprepenalty=0\relax
\def\citeleft{[}
\def\citeright{]}
\def\citepunct{,\hspace{0pt}}
\def\citedash{--\penalty10000\relax}
\def\citemid{; }

\DeclareRobustCommand\citenolink{%
  \@ifnextchar[\dstrn@citenolink@a\dstrn@citenolink@b
}
\def\dstrn@citenolink@a[#1]#2{%
  \begingroup{\NoHyper\cite[#1]{#2}\endNoHyper}\endgroup
}
\def\dstrn@citenolink@b#1{%
  \begingroup{\NoHyper\cite{#1}\endNoHyper}\endgroup
}

% -------------------- hyper links --------------------

\definecolor{dstrnlink}{rgb}{0.8,0,0}
\definecolor{dstrncite}{rgb}{0,0,0.6}
\definecolor{dstrnurl}{rgb}{0,0.3,0.8}
\RequirePackage[
  colorlinks=true,
  linkcolor=dstrnlink,
  % anchorcolor=,
  citecolor=dstrncite,
  filecolor=dstrnurl,
  menucolor=dstrnurl,
  runcolor=dstrnurl,
  urlcolor=dstrnurl,
  bookmarks=true,
  bookmarksdepth=2
]{hyperref}

\def\HyperTargetToThisLine#1{\Hy@raisedlink{\hypertarget{#1}{}}}

% Render DOI as "DOI: <doi string as link>" and
% allow the DOI string to be broken anywhere inside.
\def\doi#1{DOI\@:
  \xdef\@doi@text\hskip\z@skip{}%
  \@ifnextchar\@doi@loop@end\@doi@loop@nop\@doi@loop#1\@doi@loop@end
  \texttt{\href{https://doi.org/#1}{\@doi@text}}%
}
\def\@doi@loop@nop\@doi@loop@end{\xdef\@doi@text@{}}
\def\@doi@loop#1{%
  \xdef\@doi@text{\@doi@text\hskip\z@skip\string#1}%
  \@ifnextchar\@doi@loop@end\@doi@loop@end\@doi@loop
}
\def\@doi@loop@end\@doi@loop@end{}

% -------------------- PDF metadata --------------------

\def\TitlePDF#1{\hypersetup{pdftitle={#1}}}
\def\AuthorPDF#1{\hypersetup{pdfauthor={#1}}}
\def\KeywordsPDF#1{\hypersetup{pdfkeywords={#1}}}
\def\SubjectPDF#1{\hypersetup{pdfsubject={#1}}}

% -------------------- theorems --------------------

% Let theorem note use the font of the theorem heading.
\let\dstrn@thethmnotefont\relax
\def\thmhead@plain#1#2#3{%
  \thmname{#1}\thmnumber{\@ifnotempty{#1}{ }\relax{#2}}%
  \thmnote{ {\dstrn@thethmnotefont(#3)}}%
}
\let\thmhead\thmhead@plain

\def\dstrn@undefine@theorem#1{%
  \expandafter\let\csname #1\endcsname\dstrn@undefined
  \expandafter\let\csname end#1\endcsname\dstrn@undefined
  \expandafter\let\csname c@#1\endcsname\dstrn@undefined
}

\dstrn@undefine@theorem{assumption}
\dstrn@undefine@theorem{claim}
\dstrn@undefine@theorem{conjecture}
\dstrn@undefine@theorem{construction}
\dstrn@undefine@theorem{corollary}
\dstrn@undefine@theorem{definition}
\dstrn@undefine@theorem{lemma}
\dstrn@undefine@theorem{proof}
\dstrn@undefine@theorem{proposition}
\dstrn@undefine@theorem{question}
\dstrn@undefine@theorem{remark}
\dstrn@undefine@theorem{theorem}
\dstrn@undefine@theorem{case}
\dstrn@undefine@theorem{example}
\dstrn@undefine@theorem{exercise}
\dstrn@undefine@theorem{note}
\dstrn@undefine@theorem{problem}
\dstrn@undefine@theorem{property}
\dstrn@undefine@theorem{solution}

\let\dstrn@undefine@theorem\dstrn@undefined

% Modified from amsthm.sty:
\def\th@remark{%
  \thm@headfont{\itshape}%
  \normalfont % body font
  % Use normal spacing.
  % \thm@preskip\topsep \divide\thm@preskip\tw@
  % \thm@postskip\thm@preskip
}

\theoremstyle{remark}
\newtheorem{remark}{Remark}
\newtheorem*{remarks}{Remarks}

\counterwithin{remark}{chapter}

\newtheorem*{dstrn@proof}{Proof}
\def\proof{\begingroup\pushQED{\qed}\begin{dstrn@proof}}
\def\endproof{\popQED\end{dstrn@proof}\endgroup}

\newtheorem*{dstrn@proof@sketch}{Proof Sketch}
\def\proofsketch{\begingroup\pushQED{\qed}\begin{dstrn@proof@sketch}}
\def\endproofsketch{\popQED\end{dstrn@proof@sketch}\endgroup}

\theoremstyle{definition}
\newtheorem{definition}{Definition}
\newtheorem{question}{Question}

\counterwithin{definition}{chapter}
\counterwithin{question}{chapter}

\theoremstyle{plain}
\newtheorem{conjecture}{Conjecture}
\newtheorem{corollary}{Corollary}
\newtheorem{claim}{Claim}
\newtheorem{lemma}{Lemma}
\newtheorem{proposition}{Proposition}
\newtheorem{theorem}{Theorem}

\counterwithin{conjecture}{chapter}
\counterwithin{theorem}{chapter}

% Make these theorem environments share the same counter.
\let\c@corollary\c@theorem
\let\thecorollary\thetheorem
\let\c@claim\c@theorem
\let\theclaim\thetheorem
\let\c@lemma\c@theorem
\let\thelemma\thetheorem
\let\c@proposition\c@theorem
\let\theproposition\thetheorem

\newtheorem*{dstrn@restated}{\dstrn@restated@name}
\def\restated#1{\begingroup\def\dstrn@restated@name{#1}\begin{dstrn@restated}}
\def\endrestated{\end{dstrn@restated}\endgroup}

\theoremstyle{definition}
\newtheorem{assumption}{Assumption}
\newtheorem{construction}{Construction}

\counterwithin{assumption}{chapter}
\counterwithin{construction}{chapter}

\newtheorem*{dstrn@redefined}{\dstrn@redefined@name}
\def\redefined#1{\begingroup\def\dstrn@redefined@name{#1}\begin{dstrn@redefined}}
\def\endredefined{\end{dstrn@redefined}\endgroup}

% -------------------- mathematics --------------------

% Greek letters (make uppercase letters and \omicron upright).
\DeclareMathSymbol{\Alpha}{\mathalpha}{operators}{"41}
\DeclareMathSymbol{\Beta}{\mathalpha}{operators}{"42}
\DeclareMathSymbol{\Gamma}{\mathalpha}{operators}{0}
\DeclareMathSymbol{\Delta}{\mathalpha}{operators}{1}
\DeclareMathSymbol{\Epsilon}{\mathalpha}{operators}{"45}
\DeclareMathSymbol{\Zeta}{\mathalpha}{operators}{"5A}
\DeclareMathSymbol{\Eta}{\mathalpha}{operators}{"48}
\DeclareMathSymbol{\Theta}{\mathalpha}{operators}{2}
\DeclareMathSymbol{\Iota}{\mathalpha}{operators}{"49}
\DeclareMathSymbol{\Kappa}{\mathalpha}{operators}{"4B}
\DeclareMathSymbol{\Lambda}{\mathalpha}{operators}{3}
\DeclareMathSymbol{\Mu}{\mathalpha}{operators}{"4D}
\DeclareMathSymbol{\Nu}{\mathalpha}{operators}{"4E}
\DeclareMathSymbol{\Xi}{\mathalpha}{operators}{4}
\DeclareMathSymbol{\Omicron}{\mathalpha}{operators}{"4F}
\DeclareMathSymbol{\Pi}{\mathalpha}{operators}{5}
\DeclareMathSymbol{\Rho}{\mathalpha}{operators}{"50}
\DeclareMathSymbol{\Sigma}{\mathalpha}{operators}{6}
\DeclareMathSymbol{\Tau}{\mathalpha}{operators}{"54}
\DeclareMathSymbol{\Upsilon}{\mathalpha}{operators}{7}
\DeclareMathSymbol{\Phi}{\mathalpha}{operators}{8}
\DeclareMathSymbol{\Chi}{\mathalpha}{operators}{"58}
\DeclareMathSymbol{\Psi}{\mathalpha}{operators}{9}
\DeclareMathSymbol{\Omega}{\mathalpha}{operators}{10}
\DeclareMathSymbol{\omicron}{\mathalpha}{letters}{"6F}
% \epsilon, \phi, \emptyset are handled in fonts.

% Asymptotics.
\def\bigO{\operatorname{O}}
\def\smallo{\operatorname{o}}
\def\bigTheta{\operatorname{\Theta}}
\def\bigOmega{\operatorname{\Omega}}
% \smallomega is handled in fonts.

\def\cbrt{\sqrt[3]}
% Latin --- upright boldfaced;
% Greek --- italicized boldfaced.
\def\dstrn@vec#1{\boldsymbol{\mathbf{#1}}}
% \vec, \1 are handled in fonts.

\def\esssup{\operatornamewithlimits{ess\,sup}}
\def\essinf{\operatornamewithlimits{ess\,inf}}
\def\EX{\operatornamewithlimits{\mathbb{E}}}
\def\Var{\operatorname{Var}}
\def\supp{\operatorname{supp}}

\def\approxS{\approx_{\textup{s}}}
\def\approxC{\approx_{\phantom{\textup{s}}}}
\def\equivS{\equiv_{\phantom{\textup{s}}}}
\def\iseq{\overset{?}{=}}
\def\defeq{\overset{\mathsmaller{\textup{def}}}{=\joinrel=}}
\def\draws{\overset{\smash{\:_\$}\vphantom{{}_0}}{\leftarrow}}
\def\poly{\operatorname{poly}}
\def\negl{\operatorname{negl}}
\DeclareMathSymbol{\dstrn@concat@base}{\mathbin}{symbols}{"6B}
\def\concat{\mathbin{%
  \mathchoice{\mskip-\thinmuskip}{\mskip-\thinmuskip}{}{}%
  \dstrn@concat@base
  \mathchoice{\mskip-\thinmuskip}{\mskip-\thinmuskip}{}{}%
}}
\def\transpose{{\mathsmaller{\mathsf{T}}}}
\def\bit{{\{0,1\}}}
\let\dstrn@bak@bot\bot
\def\bot{{\dstrn@bak@bot}}

% Define shortcuts from Office Equation Editors.
% \mathbb   => \double
\def\doubleA{{\mathbb{A}}}
\def\doubleB{{\mathbb{B}}}
\def\doubleC{{\mathbb{C}}}
\def\doubleD{{\mathbb{D}}}
\def\doubleE{{\mathbb{E}}}
\def\doubleF{{\mathbb{F}}}
\def\doubleG{{\mathbb{G}}}
\def\doubleH{{\mathbb{H}}}
\def\doubleI{{\mathbb{I}}}
\def\doubleJ{{\mathbb{J}}}
\def\doubleK{{\mathbb{K}}}
\def\doubleL{{\mathbb{L}}}
\def\doubleM{{\mathbb{M}}}
\def\doubleN{{\mathbb{N}}}
\def\doubleO{{\mathbb{O}}}
\def\doubleP{{\mathbb{P}}}
\def\doubleQ{{\mathbb{Q}}}
\def\doubleR{{\mathbb{R}}}
\def\doubleS{{\mathbb{S}}}
\def\doubleT{{\mathbb{T}}}
\def\doubleU{{\mathbb{U}}}
\def\doubleV{{\mathbb{V}}}
\def\doubleW{{\mathbb{W}}}
\def\doubleX{{\mathbb{X}}}
\def\doubleY{{\mathbb{Y}}}
\def\doubleZ{{\mathbb{Z}}}
% \mathcal  => \script
\def\scriptA{{\mathcal{A}}}
\def\scriptB{{\mathcal{B}}}
\def\scriptC{{\mathcal{C}}}
\def\scriptD{{\mathcal{D}}}
\def\scriptE{{\mathcal{E}}}
\def\scriptF{{\mathcal{F}}}
\def\scriptG{{\mathcal{G}}}
\def\scriptH{{\mathcal{H}}}
\def\scriptI{{\mathcal{I}}}
\def\scriptJ{{\mathcal{J}}}
\def\scriptK{{\mathcal{K}}}
\def\scriptL{{\mathcal{L}}}
\def\scriptM{{\mathcal{M}}}
\def\scriptN{{\mathcal{N}}}
\def\scriptO{{\mathcal{O}}}
\def\scriptP{{\mathcal{P}}}
\def\scriptQ{{\mathcal{Q}}}
\def\scriptR{{\mathcal{R}}}
\def\scriptS{{\mathcal{S}}}
\def\scriptT{{\mathcal{T}}}
\def\scriptU{{\mathcal{U}}}
\def\scriptV{{\mathcal{V}}}
\def\scriptW{{\mathcal{W}}}
\def\scriptX{{\mathcal{X}}}
\def\scriptY{{\mathcal{Y}}}
\def\scriptZ{{\mathcal{Z}}}
% \mathscr  => \cursive
\def\cursiveA{{\mathscr{A}}}
\def\cursiveB{{\mathscr{B}}}
\def\cursiveC{{\mathscr{C}}}
\def\cursiveD{{\mathscr{D}}}
\def\cursiveE{{\mathscr{E}}}
\def\cursiveF{{\mathscr{F}}}
\def\cursiveG{{\mathscr{G}}}
\def\cursiveH{{\mathscr{H}}}
\def\cursiveI{{\mathscr{I}}}
\def\cursiveJ{{\mathscr{J}}}
\def\cursiveK{{\mathscr{K}}}
\def\cursiveL{{\mathscr{L}}}
\def\cursiveM{{\mathscr{M}}}
\def\cursiveN{{\mathscr{N}}}
\def\cursiveO{{\mathscr{O}}}
\def\cursiveP{{\mathscr{P}}}
\def\cursiveQ{{\mathscr{Q}}}
\def\cursiveR{{\mathscr{R}}}
\def\cursiveS{{\mathscr{S}}}
\def\cursiveT{{\mathscr{T}}}
\def\cursiveU{{\mathscr{U}}}
\def\cursiveV{{\mathscr{V}}}
\def\cursiveW{{\mathscr{W}}}
\def\cursiveX{{\mathscr{X}}}
\def\cursiveY{{\mathscr{Y}}}
\def\cursiveZ{{\mathscr{Z}}}
% \mathfrak => \fraktur
\def\frakturA{{\mathfrak{A}}}
\def\fraktura{{\mathfrak{a}}}
\def\frakturB{{\mathfrak{B}}}
\def\frakturb{{\mathfrak{b}}}
\def\frakturC{{\mathfrak{C}}}
\def\frakturc{{\mathfrak{c}}}
\def\frakturD{{\mathfrak{D}}}
\def\frakturd{{\mathfrak{d}}}
\def\frakturE{{\mathfrak{E}}}
\def\frakture{{\mathfrak{e}}}
\def\frakturF{{\mathfrak{F}}}
\def\frakturf{{\mathfrak{f}}}
\def\frakturG{{\mathfrak{G}}}
\def\frakturg{{\mathfrak{g}}}
\def\frakturH{{\mathfrak{H}}}
\def\frakturh{{\mathfrak{h}}}
\def\frakturI{{\mathfrak{I}}}
\def\frakturi{{\mathfrak{i}}}
\def\frakturJ{{\mathfrak{J}}}
\def\frakturj{{\mathfrak{j}}}
\def\frakturK{{\mathfrak{K}}}
\def\frakturk{{\mathfrak{k}}}
\def\frakturL{{\mathfrak{L}}}
\def\frakturl{{\mathfrak{l}}}
\def\frakturM{{\mathfrak{M}}}
\def\frakturm{{\mathfrak{m}}}
\def\frakturN{{\mathfrak{N}}}
\def\frakturn{{\mathfrak{n}}}
\def\frakturO{{\mathfrak{O}}}
\def\frakturo{{\mathfrak{o}}}
\def\frakturP{{\mathfrak{P}}}
\def\frakturp{{\mathfrak{p}}}
\def\frakturQ{{\mathfrak{Q}}}
\def\frakturq{{\mathfrak{q}}}
\def\frakturR{{\mathfrak{R}}}
\def\frakturr{{\mathfrak{r}}}
\def\frakturS{{\mathfrak{S}}}
\def\frakturs{{\mathfrak{s}}}
\def\frakturT{{\mathfrak{T}}}
\def\frakturt{{\mathfrak{t}}}
\def\frakturU{{\mathfrak{U}}}
\def\frakturu{{\mathfrak{u}}}
\def\frakturV{{\mathfrak{V}}}
\def\frakturv{{\mathfrak{v}}}
\def\frakturW{{\mathfrak{W}}}
\def\frakturw{{\mathfrak{w}}}
\def\frakturX{{\mathfrak{X}}}
\def\frakturx{{\mathfrak{x}}}
\def\frakturY{{\mathfrak{Y}}}
\def\fraktury{{\mathfrak{y}}}
\def\frakturZ{{\mathfrak{Z}}}
\def\frakturz{{\mathfrak{z}}}

% -------------------- fonts --------------------

% A better version of \@ that acts like
% an invisible character with \spacefactor=1000
% without breaking kerning.
\def\willstop#1{#1\expandafter\spacefactor
\expandafter\the\expandafter\sfcode\expandafter`\csname #1\endcsname{}}
\def\wontstop#1{#1\spacefactor1000{}}

\RequirePackage[
  default,lining,
  semibold,regular,
  scaled=0.9
]{sourcecodepro}
\RequirePackage[
  default,lining,proportional,
  semibold,regular
]{sourcesanspro}
\RequirePackage[
  default,lining,proportional,
  bold,regular
]{sourceserifpro}
\RequirePackage[
  smallerops,varvw,varg,ncf,varbb,cmbraces,bigdelims,
  nonewtxmathopt,subscriptcorrection
]{newtxmath}
\RequirePackage[cal=cm]{mathalfa}

% Adjust inter-word spacing for Source Serif Pro.
\AtBeginDocument{%
  \relax\spaceskip=1.28\fontdimen2\font
    plus 1.2\fontdimen3\font
    minus 1\fontdimen4\font
  \relax
  \pretolerance=2800\relax
  \tolerance=5000\relax
}
% Adjust underline thickness to match Source Serif Pro.
\def\ULthickness{0.1ex}

% We get to decide the mathematical symbols
% potentially tampered with by the fonts.

\let\dumbepsilon\epsilon
\let\dumbphi\phi
\let\dumbemptyset\emptyset
\let\epsilon\varepsilon
\let\phi\varphi
\let\emptyset\varnothing

\def\smallomega{\operatorname{\upomega}}
\let\vec\dstrn@vec
\def\1{{\mathds{1}}}

\def\absurdumhitwall{{\ensuremath
  {\mkern-0.333333mu{\rightarrow}\mkern-3.33333mu{|}\mkern1mu\relax
  \textup{\raisebox{-0.142857em}{\rotatebox{90}{\smash
  {\scalebox{0.8}[0.5]{\tiny
  \rlap{\hskip0.05em\relax\textbackslash}\textbackslash\,%
  \rlap{\hskip0.05em\relax\textbackslash}\textbackslash\,%
  \rlap{\hskip0.05em\relax\textbackslash}\textbackslash\,%
  \rlap{\hskip0.05em\relax\textbackslash}\textbackslash\,%
  }}}}}\mkern2mu\relax}%
}}

% -------------------- absurdum --------------------

% \absurdumhitwall is handled by fonts.
\def\absurdumlightning{{\textup{\Lightning}}}
\let\absurdum\absurdumhitwall

% -------------------- underlines --------------------

\DeclareRobustCommand*\dumbunderline[1]{\uline{#1}}
\DeclareRobustCommand*\smartunderline[1]{%
  \begingroup
  \setlength{\ULdepth}{0.45ex}%
  \contourlength{0.32ex}%
  \uline{\phantom{\contour{white}{#1}}}%
  \llap{\contour{white}{#1}}%
  \endgroup
}
\let\underlined\smartunderline

% -------------------- URL --------------------

% Reset URL breaking after the packages might have messed with it.
\def\UrlBreaks{%
  \do\A\do\a\do\B\do\b\do\C\do\c\do\D\do\d\do\E\do\e\do\F\do\f\do\G\do\g
  \do\H\do\h\do\I\do\i\do\J\do\j\do\K\do\k\do\L\do\l\do\M\do\m\do\N\do\n
  \do\O\do\o\do\P\do\p\do\Q\do\q\do\R\do\r\do\S\do\s\do\T\do\t
  \do\U\do\u\do\V\do\v\do\W\do\w\do\X\do\x\do\Y\do\y\do\Z\do\z
  \do\0\do\1\do\2\do\3\do\4\do\5\do\6\do\7\do\8\do\9%
}
\def\UrlBigBreaks{%
  \do\,\do\.\do\?\do\!\do\:\do\;\do\'\do\"%
  \do\[\do\]\do\{\do\}\do\(\do\)\do\<\do\>%
  \do\/\do\|\do\\%
  \do\`\do\@\do\#\do\$\do\^\do\&\do\*\do\_\do\=\do+%
  % I have no idea how to handle "~", so I am not touching it.
  % "%" is handled by UrlSpecials.
  % "-" is handled by not putting it anywhere.
}
% By not putting "-" anywhere,
% a break is allowed before it but not after it.
\def\UrlNoBreaks{}

% -------------------- metadata --------------------

\def\dstrn@def@metadata#1#2#3{%
  \newtoks#1%
  \def#2##1{#1={##1}}%
  #1={{\color{red}#3}}%
}
\dstrn@def@metadata\dstrn@title
  \DissertationTitle{Unknown Title}
\dstrn@def@metadata\dstrn@author
  \DissertationAuthor{Unknown Author}
\dstrn@def@metadata\dstrn@degree
  \DissertationDegree{Unknown Degree Title}
\dstrn@def@metadata\dstrn@year
  \DissertationYear{Unknown Graduation Year}
\dstrn@def@metadata\dstrn@reading
  \DissertationReadingCommittee{Unknown Reading Committee}
\dstrn@def@metadata\dstrn@program
  \DissertationProgram{Unknown Program Offering Degree}
\dstrn@def@metadata\dstrn@chair
  {\DissertationSupervisoryChair(s)}{Unknown Supervisory Chair(s)}
\dstrn@def@metadata\dstrn@copyright
  \DissertationCopyright{\YearHolder{Unknown Year}{Unknown Holder}}
\let\dstrn@def@metadata\dstrn@undefined

\def\DissertationHasSingleChair{\def\chairname{Chair}}
\def\DissertationHasMultipleChairs{\def\chairname{Chairs}}
\DissertationHasSingleChair

\def\acknowledgename{Acknowledgments}

% The first three things of the front matter are as follows:
% - title page, required by the graduate school;
% - copyright page, required by the graduate school;
% - abstract, required by the graduate school.
% The first two pages must be title and copyright, in arbitrary order.
% The graduate school wants un-numbered abstract page.
% - If the abstract fits in 1 page, then it is un-numbered, and
%   Roman numerals start on acknowledgments or table of contents.
% - Otherwise, it is numbered with Roman numberals, and
%   Roman numbering continues until the end of the front matter.
% The following items can be arbitrarily ordered:
% - dedication page (optional);
% - acknowledgments (optional);
% - table of contents.
% This class requires table of contents be typeset.
% Optionally, these items can immediately follow table of contents:
% - list of figures;
% - list of tables.
% Either can be omitted and they have no fixed order.
%
% Pragmatically,
%         title < abstract
%     copyright < abstract
%      abstract < skip
%      abstract < dedication
%      abstract < acknowledge
%      abstract < ToC
%           ToC < main
% are enforced by checking LHS in RHS ("must be after"), and
%    dedication < main
%   acknowledge < main
% are enforced by checking RHS in LHS ("must be before"), and
% that LoF/LoT must follow ToC or LoT/LoF
% is enforced specially ("must be doing ToCLoFT").

\dstrn@letF\if@dstrn@done@Title\fi
\dstrn@letF\if@dstrn@done@Copyright\fi
\dstrn@letF\if@dstrn@done@Abstract\fi
\dstrn@letF\if@dstrn@done@ToC\fi
\dstrn@letF\if@dstrn@done@MainText\fi

\def\dstrn@StartUnnumbered{%
  % It is a bug to call \dstrn@StartUnnumbered more than once.
  \let\dstrn@StartUnnumbered\dstrn@undefined
  % It is a bug to call \dstrn@StartRoman before \dstrn@StartUnnumbered.
  \def\dstrn@StartRoman{%
    % The first page to use Roman numbering is not fixed.
    % Second call to \dstrn@StartRoman has no effect
    % until Arabic page numbering starts --- after that it is a bug.
    \let\dstrn@StartRoman\relax
    % It is a bug to call \dstrn@StartArabic before \dstrn@StartRoman.
    \def\dstrn@StartArabic{%
      % It is a bug to call any of them after the first \dstrn@StartArabic.
      \let\dstrn@StartRoman\dstrn@undefined
      \let\dstrn@StartArabic\dstrn@undefined
      \dstrn@topmargin@header
      \pagestyle{headings}\pagenumbering{arabic}%
    }%
    \dstrn@topmargin@footer
    \pagestyle{plain}\pagenumbering{roman}%
  }%
  \dstrn@topmargin@neither
  \pagestyle{empty}\pagenumbering{alph}%
}

% These are for the users, not the class author.
\def\dstrn@CanOnlyCallOnce#1{\def#1{\ClassError{dissertation}{%
    "\string#1"\MessageBreak
    can only be called once%
  }{Remove extraneous\MessageBreak "\string#1"}%
}}
\def\dstrn@MustBeAfter#1#2#3\fi{#3\else\ClassError{dissertation}{%
    "\string#1"\MessageBreak
    can only be called after\MessageBreak
    "\string#2"%
  }{Fix order}%
\fi}
\def\dstrn@MustBeBefore#1#2#3\fi{#3\ClassError{dissertation}{%
  "\string#1"\MessageBreak
  can only be called before\MessageBreak
  "\string#2"%
}{Fix order}\fi}

\def\dstrn@StartDocument{%
  % The document could be started with either title or copyright.
  % Second call to \dstrn@StartDocument has no effect.
  \let\dstrn@StartDocument\relax
  \dstrn@letF\if@dstrn@done@Title\fi
  \dstrn@letF\if@dstrn@done@Copyright\fi
  \dstrn@letF\if@dstrn@done@Abstract\fi
  \dstrn@letF\if@dstrn@done@ToC\fi
  \dstrn@letF\if@dstrn@done@MainText\fi
  \cleardoublepage
  \dstrn@StartUnnumbered
  \input{title}%
}

% Before typesetting table of contents,
% neither list of figures nor list of tables can be typeset.
\def\dstrn@MustBeDoingToCLoFT#1{%
  \dstrn@MustBeAfter #1\DissertationMakeTableOfContents\iffalse\fi
}
% This makes us enter ToCLoFT mode.
\def\dstrn@EnterToCLoFT{%
  % It is a bug to re-enter ToCLoFT.
  \let\dstrn@EnterToCLoFT\dstrn@undefined
  % Allow list of figures/tables to be typeset.
  \def\dstrn@MustBeDoingToCLoFT##1{\relax}%
  % This makes us exit from ToCLoFT mode.
  \def\dstrn@ExitToCLoFT{%
    % It is the user's error to typeset list of figures/tables
    % disconnected from table of contents.
    \def\dstrn@MustBeDoingToCLoFT####1{\ClassError{dissertation}{%
      "\string####1" must\MessageBreak
      either immediately follow\MessageBreak
      "\string\DissertationMakeTableOfContents" and friends\MessageBreak
      or not appear at all%
    }{Fix order}}
    % Exiting twice has no effect.
    \let\dstrn@ExitToCLoFT\relax
    % Restore link coloring.
    \let\Hy@colorlink\dstrn@toc@bak@Hy@colorlink
    \let\dstrn@toc@bak@Hy@colorlink\dstrn@undefined
  }%
  % Temporarily disable link coloring.
  \let\dstrn@toc@bak@Hy@colorlink\Hy@colorlink
  \def\Hy@colorlink##1{\begingroup}%
  % Start odd-numbered (right-hand) and use Roman page numbers.
  \cleardoublepage
  \dstrn@StartRoman
}
% Before entering ToCLoFT mode, exiting has no effect.
\let\dstrn@ExitToCLoFT\relax

\def\DissertationMakeTitlePage{%
  \dstrn@CanOnlyCallOnce\DissertationMakeTitlePage
  \dstrn@StartDocument
  \dstrn@letT\if@dstrn@done@Title\fi
  \dstrn@front@matter@bookmark{Title}{title}%
  \null\vfil
  \begin{minipage}{0.9\textwidth}%
    {\def\baselinestretch{1}\centering\LARGE
      \long\def\TitleAbstract##1##2{##1}%
      \expandafter\ignorespaces
      \the\dstrn@title
      \unskip\par
    }\vskip 36pt%
    {\centering
      \expandafter\ignorespaces
      \the\dstrn@author
      \unskip\par
    }\vskip 36pt%
    {\centering
      A dissertation\par
      submitted in partial fulfillment of the\par
      requirements for the degree of\par
    }\vskip 36pt%
    {\centering
      \expandafter\ignorespaces
      \the\dstrn@degree
      \unskip\par
    }\vskip 36pt%
    {\centering
      University of Washington\par
      \expandafter\ignorespaces
      \the\dstrn@year
      \unskip\par
    }\vskip 36pt%
    {\centering
      Reading Committee:\par
      \def\and{\unskip\par}%
      \expandafter\ignorespaces
      \the\dstrn@reading
      \unskip\par
    }\vskip 36pt%
    {\centering
      Program Authorized to Offer Degree:\par
      \expandafter\ignorespaces
      \the\dstrn@program
      \unskip\par
    }%
  \end{minipage}%
  \vfil\clearpage
}

\def\DissertationMakeCopyrightPage{%
  \dstrn@CanOnlyCallOnce\DissertationMakeCopyrightPage
  \dstrn@StartDocument
  \dstrn@letT\if@dstrn@done@Copyright\fi
  \dstrn@front@matter@bookmark{Copyright}{copyright}%
  \null
  {\centering
    \def\YearHolder##1##2{\vskip 24pt%
      {\textcopyright} Copyright ##1\par ##2\par
    \expandafter\ignorespaces}%
    \expandafter\ignorespaces
    \the\dstrn@copyright
    \unskip\par
  }%
  \clearpage
}

\def\DissertationMakeAbstract{%
  \dstrn@CanOnlyCallOnce\DissertationMakeAbstract
  \dstrn@MustBeAfter
    \DissertationMakeAbstract
    \DissertationMakeTitlePage
    \if@dstrn@done@Title\fi
  \dstrn@MustBeAfter
    \DissertationMakeAbstract
    \DissertationMakeCopyrightPage
    \if@dstrn@done@Copyright\fi
  \dstrn@letT\if@dstrn@done@Abstract\fi
  \dstrn@front@matter@bookmark{Abstract}{abstract}%
  \ifx\dstrn@abstract@begin\dstrn@abstract@end
    % The abstract fits in 1 page.
    % It is un-numbered.
    \null\vfil\vskip 18pt\relax
  \else
    % The abstract does not fit in 1 page.
    % Roman numbering starts now.
    \dstrn@StartRoman
    % This elastic \vskip reduces
    % the probability of non-stabilizing typesetting.
    \null\vskip 34pt plus 16pt minus 16pt\relax
  \fi
  \begin{minipage}{0.9\textwidth}%
    {\centering
      University of Wahsington\par
    }\vskip 24pt%
    \write\@auxout{\global\def\string\dstrn@abstract@begin{\arabic{page}}}%
    {\centering\bfseries
      Abstract\par
    }\vskip 24pt%
    {\centering
      \long\def\TitleAbstract##1##2{##2}%
      \expandafter\ignorespaces
      \the\dstrn@title
      \unskip\par
    }\vskip 24pt%
    {\centering
      \expandafter\ignorespaces
      \the\dstrn@author
      \unskip\par
    }\vskip 24pt%
    {\centering
      {\chairname} of the Supervisory Committee:\par
      \def\of{\unskip\par\ignorespaces}
      \expandafter\ignorespaces
      \the\dstrn@chair
      \unskip\par
    }%
  \end{minipage}\vskip 36pt\relax
  % The \par removes the trailing space of the paragraph,
  % which cannot be removed if \write is seen first.
  % This reduces the probability of having
  % a visually empty page containing just a space,
  % in which case the program will think
  % the abstract spans across multiple pages,
  % although the last and second page is empty.
  \noindent\expandafter\ignorespaces\input{abstract}\par
  \write\@auxout{\global\def\string\dstrn@abstract@end{\arabic{page}}}%
  % If the abstract fits in 1 page, it is vertically centered.
  % Otherwise, \vfil essentailly has no effect.
  \vfil\clearpage
}

\def\DissertationSkipPage{%
  \dstrn@MustBeAfter
    \DissertationSkipPage
    \DissertationMakeAbstract
    \if@dstrn@done@Abstract\fi
  \null\thispagestyle{empty}\clearpage
}

\def\DissertationMakeDedicationPage{%
  \dstrn@CanOnlyCallOnce\DissertationMakeDedicationPage
  \dstrn@MustBeAfter
    \DissertationMakeDedicationPage
    \DissertationMakeAbstract
    \if@dstrn@done@Abstract\fi
  \dstrn@MustBeBefore
    \DissertationMakeDedicationPage
    \DissertationStartMainText
    \if@dstrn@done@MainText\fi
  \dstrn@ExitToCLoFT
  % This page can be either odd-numbered or even-numbered.
  % It also has no effect to page numbering.
  \clearpage
  \dstrn@front@matter@bookmark{Dedication}{dedicate}%
  \noindent\expandafter\ignorespaces\input{dedicate}\par
  \clearpage
}

\def\DissertationMakeAcknowledgments{%
  \dstrn@CanOnlyCallOnce\DissertationMakeAcknowledgments
  \dstrn@MustBeAfter
    \DissertationMakeAcknowledgments
    \DissertationMakeAbstract
    \if@dstrn@done@Abstract\fi
  \dstrn@MustBeBefore
    \DissertationMakeAcknowledgments
    \DissertationStartMainText
    \if@dstrn@done@MainText\fi
  \dstrn@ExitToCLoFT
  % Start odd-numbered (right-hand) and use Roman page numbers.
  \cleardoublepage
  \dstrn@StartRoman
  \dstrn@front@matter@toc{\acknowledgename}{acknowledge}%
  % Modified from \tableofcontents.
  \begingroup
    \parindent\z@
    \parskip\cftparskip
    \addpenalty\@secpenalty
    \vspace*{\cftbeforetoctitleskip}%
    {%
      \interlinepenalty\@M
      {\cfttoctitlefont\acknowledgename}{\cftaftertoctitle}%
      \par\nobreak
      \vskip\cftaftertoctitleskip
      \@afterheading
    }%
  \endgroup
  \noindent\expandafter\ignorespaces\input{acknowledge}\par
  \clearpage
}

\def\DissertationMakeTableOfContents{%
  \dstrn@CanOnlyCallOnce\DissertationMakeTableOfContents
  \dstrn@MustBeAfter
    \DissertationMakeTableOfContents
    \DissertationMakeAbstract
    \if@dstrn@done@Abstract\fi
  \dstrn@EnterToCLoFT
  \dstrn@letT\if@dstrn@done@ToC\fi
  \dstrn@front@matter@bookmark{\contentsname}{toc}%
  \begingroup
    \def\baselinestretch{1}\upshape
    \tableofcontents
  \endgroup
  \clearpage
}

\def\DissertationMakeListOfFigures{%
  \dstrn@CanOnlyCallOnce\DissertationMakeListOfFigures
  \dstrn@MustBeDoingToCLoFT\DissertationMakeListOfFigures
  \clearpage
  \dstrn@front@matter@toc{\listfigurename}{lof}%
  \begingroup
    \def\baselinestretch{1}\upshape
    \listoffigures
  \endgroup
  \clearpage
}

\def\DissertationMakeListOfTables{%
  \dstrn@CanOnlyCallOnce\DissertationMakeListOfTables
  \dstrn@MustBeDoingToCLoFT\DissertationMakeListOfTables
  \clearpage
  \dstrn@front@matter@toc{\listtablename}{lot}%
  \begingroup
    \def\baselinestretch{1}\upshape
    \listoftables
  \endgroup
  \clearpage
}

\def\DissertationStartMainText{%
  \dstrn@CanOnlyCallOnce\DissertationStartMainText
  \dstrn@MustBeAfter
    \DissertationStartMainText
    \DissertationMakeTableOfContents
    \if@dstrn@done@ToC\fi
  \dstrn@ExitToCLoFT
  \dstrn@letT\if@dstrn@done@MainText\fi
  \cleardoublepage
  \dstrn@StartArabic
  % An \immediate version of
  %   \addtocontents{toc}{\protect\dstrn@toc@after@front@matter}
  % The \immediate is necessary to ensure that
  %   \dstrn@toc@after@front@matter
  % is produced even when the first thing in the main text is \include,
  % which itself \immediate\write's \@input{included.aux} to \@auxout.
  \immediate\write\@auxout{%
    \string\@writefile{toc}{\string\dstrn@toc@after@front@matter}%
  }%
}
