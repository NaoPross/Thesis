% vim:ts=2 sw=2 et tw=78:

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tex/hsrthesis}[
  2022/01/07 v0.1 HSR Thesis Class
]

% ---------------------------------------------------------------------------
% Dependencies

% To create class options
\RequirePackage{kvoptions}

% Colors
\RequirePackage{xcolor}

% ---------------------------------------------------------------------------
% Class options

\SetupKeyvalOptions{
  family=hsrth,
  prefix=hsrth@
}

% Print additional information in the footer for drafting
\DeclareBoolOption[false]{draftmode}

% Parse options
\ProcessKeyvalOptions{hsrth}

% ---------------------------------------------------------------------------
% Load a parent class, and change its style

% Load a KOMA report class
\LoadClass[
  % Use the civilized paper format
  pape=a4,
  % Leave a bit of space on the right for the binding
  BCOR=5mm,
  % Two sided document, and always start a new chapter on a right page. If the
  % left page (before a new chapter) is empty, do not put any headers or
  % footers on it (empty style)
  twoside, openright, cleardoublepage=empty,
  % Add extra sections
  titlepage, abstract=on,
]{scrreprt}

% Set up margins
\PassOptionsToPackage{geometry}{a4paper}
\RequirePackage{geometry}

% KOMA classes use an annoying package called typearea that chooses the margins
% for you. The margins chosen by typearea are typographically better, but
% usually unreasonably large, so we need to override its settings.
\AfterCalculatingTypearea{
  \geometry{
    inner=3cm, outer=2.5cm,
    includeheadfoot, top=2cm, bottom=2cm
  }
}

% Set up page headers and footers (using KOMA)
\PassOptionsToPackage{scrlayer-scrpage}{autooneside=false, draft=false}
\RequirePackage{scrlayer-scrpage}

% Display current chapter or section in the header (only one at the time)
\renewcommand{\sectionmark}[1]{\markright{\thesection~#1}}
\renewcommand{\chaptermark}[1]{\markboth{\if@mainmatter\fi\thechapter~#1}{}}

\lehead{\leftmark}
\rohead{\rightmark}

% Page numbers are sans-serif bold and slanted
\setkomafont{pagenumber}{\sffamily\bfseries\slshape}

% Other headers are in italic
\setkomafont{pageheadfoot}{\itshape}

% Special behaviour when in draft mode
\ifhsrth@draftmode
  % Put date and time in footer
  \RequirePackage{scrtime}
  \newcommand{\draftfooterstring}{
    \footnotesize\slshape (Draft of \today\ at \thistime)
  }
  \cefoot{\draftfooterstring}
  \cofoot{\draftfooterstring}

  % Put a big watermark on the first page
  \PassOptionsToPackage{firstpageonly}{draftwatermark}
  \RequirePackage{draftwatermark}
  \DraftwatermarkOptions{
    text={\sffamily\bfseries DRAFT},
    scale=1.2
  }
\fi

% Floating captions configuration
% Caption names are in sans-serif bold, not indented and have are separated
% from the caption text by a quad space
\setkomafont{captionlabel}{\sffamily\bfseries}
\setcapindent{0pt}
\renewcommand*{\captionformat}{\quad}

% Set up sub figures (using the subcaption package) to look like in IEEE
% classes. That means like: (a)
\RequirePackage{subcaption}
\usepackage[labelformat=simple]{subcaption}
\renewcommand\thesubfigure{(\alph{subfigure})}

% Customize how chapters look
\RedeclareSectionCommand[beforeskip=0pt, afterskip=3\baselineskip]{chapter}
\renewcommand*{\chapterformat}{%
  \chapappifchapterprefix{\nobreakspace}
  {%
    \bfseries\slshape\sffamily\color{blue!30!white}%
    \fontsize{3em}{0em}\selectfont%
    \thechapter\autodot%
  }
  \normalfont\enskip
}

% ---------------------------------------------------------------------------
% Font configuration

% Note: This setup is rather fragile so it is easy to mess up. The best would
%       be to use the (new) fontspec package commands:
%       
%       \setmainfont{<font name>}
%       \setsansfont{<font name>}
%       \setmonofont{<font name>}
\RequirePackage{fontspec}

% However some fonts are easier to load through old packages so fontenc is
% here for backwards compatibility.
\PassOptionsToPackage{T1}{fontenc}
\RequirePackage{fontenc}

% Select serif font to be Latin Modern, i.e. the ``default LaTeX font''
\RequirePackage{lmodern}

% Select sans-serif fonts
\RequirePackage{roboto}

% Select monospaced font
\PassOptionsToPackage{scaled}{beramono}
\RequirePackage{beramono}

% ---------------------------------------------------------------------------
% Sane defaults for other packages

% Set up links

% TODO: is this stuff really necessary?
% \PassOptionsToPackage{hyperref}{%
%   pdftitle = {}
%   pdfsubject = {}
%   pdfauthor = {}
% }

\RequirePackage{hyperref}
\hypersetup{
  % Remove ugly boxes
  hidelinks,
  % Set colors
  colorlinks = true,
  anchorcolor = black,
  citecolor = black,
  filecolor = black,
  linkcolor = black,
  menucolor = black,
  runcolor = black,
  urlcolor = {black!50!blue}, 
}


% Set up listings
\RequirePackage{listings}
\lstdefinestyle{hsrthesis}{
  abovecaptionskip = \baselineskip,
  belowcaptionskip = \baselineskip,
  breaklines = true,
  inputencoding = utf8,
  % frame
  frame = leftline,
  framerule = 3pt,
  rulecolor = \color{cyan!20!white},
  % margin
  xleftmargin = 5mm,
  framexleftmargin = 5mm,
  % background
  backgroundcolor = \color{white},
  % default language:
  language = TeX,
  showstringspaces = false,
  % font
  basicstyle = \ttfamily,
  identifierstyle = \color{black},
  keywordstyle = \bfseries \color{blue!70!black},
  commentstyle = \color{gray},
  stringstyle = \color{orange!60!black},
  % tabs
  tabsize=4,
}
\lstset{
  % set style
  style=hsrthesis,
  % code is floating, caption below
  float, captionpos=b,
}
