\ProvidesClass{mathhw}[Math Homework]

% See https://tex.stackexchange.com/questions/1137/where-do-i-place-my-own-sty-or-cls-files-to-make-them-available-to-all-my-te for how to install

\LoadClass[a5paper]{book}
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
\setmainfont{texgyrebonum}
\setmathfont{Asana-Math}%XITSMath-Bold}%{Asana-Math}

\definecolor{lightgreen}{rgb}{0.3,0.9,0.4}

\mdfdefinestyle{definition}{%
    linecolor=gray,linewidth=1pt,
    roundcorner=4pt
}

\mdfdefinestyle{interlude}{%
    linecolor=gray,linewidth=1pt,topline=false,bottomline=false
}

\RequirePackage{dirtytalk}
\RequirePackage{geometry}
\RequirePackage{multicol}
\RequirePackage[shortlabels]{enumitem}

\def\sup#1{\textsuperscript{#1}}


\makeatletter
\newenvironment{problem}[2]{
    \protect\pagebreak[4]
    \setcounter{section}{-1}
    \addtocounter{chapter}{1}
    \begingroup\color{lightgreen} \section{#2} \endgroup \nopagebreak
    \newenvironment{parts}{
      \begin{enumerate}[(a)]
        \let\latex@item\item
        \renewcommand{\item}{\addtocounter{section}{1} \latex@item }%
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
}{%
    \end{mdframed}
}

\makeatother

% Lua
\def\evl#1{\luaexec{ tex.sprint(#1) }}

% Math commands
\def\E{\mathbb{E}}
\def\P{\mathbb{P}}
\def\Var{\textsf{Var}}
\newcommand\Normal{\mathcal{N}}
\newcommand\Poisson{\textsf{Poi}}
\newcommand\Binomial{\textsf{Bin}}
\newcommand\Geometric{\textsf{Geom}}
\newcommand\lIff{\Longleftrightarrow}
\newcommand\sIff{\Leftrightarrow}
\def\l{\left}
\def\r{\right}
\newcommand\justf[1]{\l[\begin{minipage}{0.26\linewidth}\small\tt #1 \end{minipage}\r]}
\newcommand\difftl[1]{\textrm{d#1}}
\newcommand\mean[1]{\overline{#1}}
\def\undefed{\texttt{\color{lightgreen} undefined }}
\def\thetaH{\hat{\theta}}

\def\flintg{\int_{-\infty}^{\infty}}
\def\hintg{\int_{0}^{\infty}}
\newcommand\iid{\text{i.i.d. }}

% Styling

% See https://tex.stackexchange.com/questions/5148/how-can-i-change-the-font-size-in-math-equations
\everymath=\expandafter{\the\everymath\color{yellow}}
\everydisplay=\expandafter{\the\everydisplay\color{yellow}}
\color{white}
\pagecolor{black}

% Shortcut commands
\newcommand\nocalc{\textbf{\color{red}Do not use a calculator, except to check your work.}}

% Formatting commands
\newcommand\Th{\textsuperscript{th} }


%\newgeometry{vmargin={1mm,2mm}, hmargin={2mm,2mm}}

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
