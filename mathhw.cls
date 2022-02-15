\ProvidesClass{mathhw}[Math Homework]

% See https://tex.stackexchange.com/questions/1137/where-do-i-place-my-own-sty-or-cls-files-to-make-them-available-to-all-my-te for how to install

\LoadClass[a4paper, 12pt]{article}
\RequirePackage{luacode}
\RequirePackage{xcolor}

% Auxiliary Lua
\begin{luacode*}
    lib = require('libtex.lua')
\end{luacode*}

\RequirePackage{graphicx}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsfonts} % For ℙ symbol
\RequirePackage[framemethod=tikz]{mdframed} % See https://tools.ietf.org/doc/texlive-doc/latex/mdframed/mdframed.pdf
\RequirePackage{fontspec}
\RequirePackage{unicode-math}
\RequirePackage{ifthen}
\RequirePackage{listings}

\setmainfont{texgyrebonum}
\setmonofont{FreeMono Bold}
\setmathfont{Asana-Math}%XITSMath-Bold}%{Asana-Math}

\definecolor{lightgreen}{rgb}{0.3,0.9,0.4}
\definecolor{lightgray}{rgb}{0.8,0.8,0.8}

\mdfdefinestyle{definition}{%
    linecolor=gray,linewidth=1pt,
    roundcorner=4pt
}

\mdfdefinestyle{interlude}{%
    linecolor=gray,linewidth=1pt,topline=false,bottomline=false
}

% See https://www.overleaf.com/learn/latex/Code_listing
\lstdefinestyle{darkmode}{
    backgroundcolor=\color{black},
    commentstyle=\color{lightgreen},
    keywordstyle=\color{pink},
    stringstyle=\color{orange},
    basicstyle=\ttfamily\footnotesize\color{white},
    breakatwhitespace=false,
    breaklines=true,
    numberstyle=\tiny\color{lightgray},
    numbers=left,
    numbersep=5pt,
    tabsize=2,
    keepspaces=true,
    showspaces=true,
    showstringspaces=false,
    showtabs=true,
    captionpos=b
}

\lstset{style=darkmode}

\RequirePackage{geometry}
\RequirePackage{multicol}
\RequirePackage[shortlabels]{enumitem}

\def\sup#1{\textsuperscript{#1}}


\makeatletter
\newenvironment{problem}[2]{
    \protect\pagebreak[4]
    \setcounter{subsection}{-1}
    \setcounter{section}{#1}
    \addtocounter{section}{-1}
    \begingroup\color{lightgreen} \section{#2} \endgroup \nopagebreak
    \newenvironment{parts}{
      \begin{enumerate}[(a)]
        \let\latex@item\item
        \renewcommand{\item}{\addtocounter{subsection}{1} \latex@item }%
      }{\end{enumerate}}
}{}

\newenvironment{solution}{
    \nopagebreak
    {\hrule} \nopagebreak
    \setlength\parindent{0.1in}
}{\newpage}

\newenvironment{defs}{%
    \begin{mdframed}[style=definition]%
    \textbf{\large Some Definitions}
    \begin{itemize}%
        \let\latex@item\item
        \renewcommand{\item}[1][]{\latex@item \textbf{Let ##1}}%
}{%
    \end{itemize}%
    \end{mdframed}%
}
\newenvironment{interlude}[1]{%
    \begin{mdframed}[style=interlude,frametitle={#1}]%
    \begin{minipage}{\linewidth}
    \setlength\parindent{0.5cm}
    \color{black}
    \everymath=\expandafter{\the\everymath\color{black}}
    \everydisplay=\expandafter{\the\everydisplay\color{black}}
    \newcommand\beginproof{
  {\setlength\parindent{0pt}
  \textbf{PROOF:}
  }}
}{%
    \end{minipage}
    \end{mdframed}
}

\makeatother

% Lua
\def\evl#1{\luaexec{ tex.sprint(#1) }}
\def\mathevl#1{\luaexec{ lib.exportMathLib(); tex.sprint(#1) }}

% See https://tex.stackexchange.com/a/511817
\newcommand\calc[2][]{\ifthenelse{\equal{#1}{}}{\mathevl{#2}}{\mathevl{round(#2*pow(10,#1))/pow(10,#1)}}}

% Math commands
\newcommand\bE{\mathbb{E}} %
\newcommand\bP{\mathbb{P}} % Primes (or probability of)
\newcommand\bQ{\mathbb{Q}} % Rationals
\newcommand\bR{\mathbb{R}} % Reals
\newcommand\bZ{\mathbb{Z}} % Integers

\newcommand\proj[2]{\textsf{proj}_{#1}{#2}}
\newcommand\norm[1]{ \left|\left| #1 \right|\right| }

\newcommand\Var{\textsf{Var}}
\newcommand\Normal{\mathcal{N}}
\newcommand\Poisson{\textsf{Poi}}
\newcommand\Binomial{\textsf{Bin}}
\newcommand\Geometric{\textsf{Geom}}
\newcommand\lIff{\Longleftrightarrow}
\newcommand\sIff{\Leftrightarrow}

\def\abs#1{\left|#1\right|}
\newcommand\justf[1]{\left[ \begin{minipage}{0.2\linewidth}\begin{center}\small #1 \end{center}\end{minipage} \right]}
\newcommand\difftl[1]{\textrm{d#1}}
\newcommand\mean[1]{\overline{#1}}
\newcommand\undefed{\texttt{\color{lightgreen} undefined }}
\newcommand\thetaH{\hat{\theta}}

\def\flintg{\int_{-\infty}^{\infty}}
\def\hintg{\int_{0}^{\infty}}
\newcommand\iid{\text{i.i.d. }}

% Styling

% See https://tex.stackexchange.com/questions/5148/how-can-i-change-the-font-size-in-math-equations
\everymath=\expandafter{\the\everymath\color{pink}}
\everydisplay=\expandafter{\the\everydisplay\color{pink}}
\color{white}
\pagecolor{black}

% Shortcut commands
\newcommand\nocalc{\textbf{\color{red}Do not use a calculator, except to check your work.}}
\newcommand\hint[1]{{\tt\color{gray}\everymath=\expandafter{\the\everymath\color{purple}} [Hint:] \color{gray}\emph{#1}}}
\newcommand\TODO[1]{\text{\tt\color{red} // TODO: #1}}

% Formatting commands
\newcommand\Th{\textsuperscript{th} }

% Example usage:
% \begin{document}
% \maketitle
% \begin{problem}{1}{Leaders, Basic Blocks, and Control Flow Graphs}
%  This is a template.
%  \begin{solution}
%    ...and it is currently set up for homework.
%  \end{solution}
%\end{problem}
%\end{document}
