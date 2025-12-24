%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Resume Template
% LaTeX3-based class definition (expl3)
% Version 1.0 (7 January 2026)
%
% Created by Lukas Vasadi
% Inspired by Trey Hunner
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e} % Raise error if not correct version
\ProvidesClass{resume}[2026/01/01 v1.0 Resume Class (expl3)]

% ------------------------------------------------------------------
% Load base class
% ------------------------------------------------------------------
\LoadClass[11pt]{article}

% ------------------------------------------------------------------
% LaTeX3 (expl3) kernel
% ------------------------------------------------------------------
\RequirePackage{expl3}
\RequirePackage{xparse}
\ExplSyntaxOn

% ------------------------------------------------------------------
% Required packages
% ------------------------------------------------------------------
\RequirePackage[parfill]{parskip}   % Remove paragraph indentation
\RequirePackage{geometry}
\RequirePackage{enumitem}
\RequirePackage{graphicx}           % Including images
\RequirePackage{hyperref}           % Embedding hyperlinks
\RequirePackage{textcomp}           % Using text companion fonts
\RequirePackage{fontawesome5}

\pagestyle{empty} % Suppress headers and footers on all pages
\hypersetup{colorlinks=true, linkcolor=blue, filecolor=magenta, urlcolor=black}

% ------------------------------------------------------------------
% Page layout
% ------------------------------------------------------------------
\geometry{top=0.6in, bottom=0.6in, left=0.75in, right=0.75in}

\dim_new:N \g_resume_section_before_sep_dim
\dim_new:N \g_resume_section_after_sep_dim

\keys_define:nn { resume }
{
	section-before-sep .dim_set:N = \g_resume_section_before_sep_dim,
	section-before-sep .initial:n = 1em,

	section-after-sep .dim_set:N = \g_resume_section_after_sep_dim,
	section-after-sep .initial:n = 0em,
}

% Expose access as user API
\NewDocumentCommand \resumesetup { m }
{
	\keys_set:nn { resume } { #1 }
}

% ------------------------------------------------------------------
% Variable definitions
% ------------------------------------------------------------------
\tl_new:N \g_resume_name_tl
\tl_new:N \g_resume_address_tl
\tl_new:N \g_resume_email_tl
\tl_new:N \g_resume_phone_tl
\tl_new:N \g_resume_linkedin_tl
\tl_new:N \g_resume_github_tl
\tl_new:N \g_resume_website_tl

% User-level commands (LaTeX2e interface)
\NewDocumentCommand \name { m }
{ \tl_gset:Nn \g_resume_name_tl {#1} }

\NewDocumentCommand \address { m }
{ \tl_gset:Nn \g_resume_address_tl {#1} }

\NewDocumentCommand \email { m }
{ \tl_gset:Nn \g_resume_email_tl {#1} }

\NewDocumentCommand \phone { m }
{ \tl_gset:Nn \g_resume_phone_tl {#1} }

\NewDocumentCommand \linkedin { m }
{ \tl_gset:Nn \g_resume_linkedin_tl {#1} }

\NewDocumentCommand \github { m }
{ \tl_gset:Nn \g_resume_github_tl {#1} }

\NewDocumentCommand \website { m }
{ \tl_gset:Nn \g_resume_website_tl {#1} }

% ------------------------------------------------------------------
% Resume header
% ------------------------------------------------------------------
\cs_new_protected:Nn \resume_print_header:
{
	\begin{center}
		{\huge\bfseries \g_resume_name_tl} \\[0.5em]

		\tl_if_blank:VF \g_resume_address_tl
		{ \g_resume_address_tl \\[0.2em] }

		\tl_if_blank:VF \g_resume_phone_tl
		{ \faPhone\ \g_resume_phone_tl \quad }
		\tl_if_blank:VF \g_resume_email_tl
		{ \faEnvelope\ \href{mailto:\g_resume_email_tl}{\g_resume_email_tl} \\[0.2em] }

		\tl_if_blank:VF \g_resume_linkedin_tl
		{
			\tl_set_eq:NN \l_tmpa_tl \g_resume_linkedin_tl
			\regex_replace_all:nnN { ^https?:\/\/ } { } \l_tmpa_tl
			\faLinkedin\ \href{\g_resume_linkedin_tl}{\l_tmpa_tl} \quad
		}
		\tl_if_blank:VF \g_resume_github_tl
		{
			\tl_set_eq:NN \l_tmpa_tl \g_resume_github_tl
			\regex_replace_all:nnN { ^https?:\/\/ } { } \l_tmpa_tl
			\faGithub\ \href{\g_resume_github_tl}{\l_tmpa_tl} \quad
		}
		\tl_if_blank:VF \g_resume_website_tl
		{
			\tl_set_eq:NN \l_tmpa_tl \g_resume_website_tl
			\regex_replace_all:nnN { ^https?:\/\/ } { } \l_tmpa_tl
			\faGlobe\ \href{\g_resume_website_tl}{\l_tmpa_tl}
		}
	\end{center}
	\vspace{0.2em}
}

\AtBeginDocument{\resume_print_header:}

% ------------------------------------------------------------------
% Section environment definition
% ------------------------------------------------------------------
\tl_new:N  \l_resume_section_label_tl

\keys_define:nn { resumesection }
{
	label .tl_set:N  = \l_resume_section_label_tl,
	label .initial:n = {},
}

\NewDocumentEnvironment { resumesection } { O{} }
{
	\keys_set:nn { resumesection } { #1 }

	\vspace{\g_resume_section_before_sep_dim}

	\tl_if_blank:VF \l_resume_section_label_tl
	{
		{ \Large\bfseries \l_resume_section_label_tl } \par
		\vspace{-0.7em}
		\rule{\linewidth}{0.5pt}
		\vspace{0.5em}
	}

	% Use group to scope formatting
	\group_begin:
}
{
	\group_end:
	\vspace{\g_resume_section_after_sep_dim}
}

% ------------------------------------------------------------------
% Employer environment definition
% ------------------------------------------------------------------
\keys_define:nn { employer }
{
	name .tl_set:N = \l_resume_employer_name_tl,
	name .value_required:n = true,

	location .tl_set:N = \l_resume_employer_location_tl,
	location .value_required:n = true,

	dates .tl_set:N = \l_resume_employer_dates_tl,
	dates .value_required:n = true,
}

\NewDocumentEnvironment{ employer }{ O{} }
{
	\keys_set:nn { employer } { #1 }

	\makebox[\linewidth][s]{\large \textbf{\l_resume_employer_name_tl} \hspace{0.2em} \textbar \hspace{0.2em} \l_resume_employer_location_tl \hfill \l_resume_employer_dates_tl} \par
}
{ \par \vspace{0.5em} }

% ------------------------------------------------------------------
% Role environment definition
% ------------------------------------------------------------------
\keys_define:nn { role }
{
	title .tl_set:N = \l_resume_role_title_tl,
	title .value_required:n = true,

	dates .tl_set:N = \l_resume_role_dates_tl,
	dates .value_required:n = false,
}

\NewDocumentEnvironment{ role }{ O{} }
{
	\keys_set:nn { role } { #1 }

	\tl_if_blank:VTF \l_resume_role_dates_tl
	{ \textit{\l_resume_role_title_tl} \par }
	{ \makebox[\linewidth][s]{\textit{\l_resume_role_title_tl} \hfill \l_resume_role_dates_tl} \par }

	\begin{itemize}[label=$\cdot$, leftmargin=1em, itemsep=-0.4em, topsep=0pt,]
		}
		{ \end{itemize} \par }

% ------------------------------------------------------------------
% Institution environment definition
% ------------------------------------------------------------------
\keys_define:nn { institution }
{
	name .tl_set:N = \l_resume_institution_name_tl,
	name .value_required:n = true,

	location .tl_set:N = \l_resume_institution_location_tl,
	location .value_required:n = true,
}

\NewDocumentEnvironment{ institution }{ O{} }
{
	\keys_set:nn { institution } { #1 }

	{\large \textbf{\l_resume_institution_name_tl} \hspace{0.2em} \textbar \hspace{0.2em} \l_resume_institution_location_tl}
	\par \vspace{-0.2em}
}
{ \par \vspace{0.5em} }

% ------------------------------------------------------------------
% Degree environment definition
% ------------------------------------------------------------------
\keys_define:nn { degree }
{
	name .tl_set:N = \l_degree_name_tl,
	name .value_required:n = name,

	awarddate .tl_set:N = \l_degree_awarddate_tl,
	awarddate .value_required:n = false,
}

\NewDocumentEnvironment{ degree }{ O{} }
{
	\keys_set:nn { degree } { #1 }

	\tl_if_blank:VTF \l_degree_awarddate_tl
	{ \l_degree_name_tl \par }
	{ \makebox[\linewidth][s]{\l_degree_name_tl \hfill \l_degree_awarddate_tl} \par }
	\setlength{\parskip}{0.2\baselineskip}
}
{ \par }

% ------------------------------------------------------------------
% Skills
% ------------------------------------------------------------------
\dim_new:N \l__resume_skill_label_width_dim
\dim_set:Nn \l__resume_skill_label_width_dim { 5cm }

\cs_new_protected:Nn \__resume_skill_render:nn
{
	\begin{tabular}{@{}p{\l__resume_skill_label_width_dim} p{\dimexpr\linewidth-\l__resume_skill_label_width_dim\relax}@{}}
		\textbf{#1} & #2 \\[0.2\baselineskip]
	\end{tabular}
}

\NewDocumentCommand \skillset { m m }
{
	\__resume_skill_render:nn {#1}{#2}
}

% ------------------------------------------------------------------
% Program with optional date
% ------------------------------------------------------------------
\cs_new_protected:Nn \__resume_program_renderer:nn
{
	{ \makebox[\linewidth][s]{#1 \hfill #2} \par }
	\setlength{\parskip}{0.2\baselineskip}
}

\NewDocumentCommand \program { m m }
{
	\__resume_program_renderer:nn {#1}{#2}
}

% ------------------------------------------------------------------
% Patent citation
% ------------------------------------------------------------------
\tl_new:N \l_resume_patent_url_tl
\tl_new:N \l_resume_patent_title_tl
\tl_new:N \l_resume_patent_authors_tl
\tl_new:N \l_resume_patent_type_tl
\tl_new:N \l_resume_patent_number_tl
\tl_new:N \l_resume_patent_date_tl


\keys_define:nn { patent }
{
	url .tl_set:N  = \l_resume_patent_url_tl,
	url .initial:n = {},
	url .value_required:n = true,

	title .tl_set:N  = \l_resume_patent_title_tl,
	title .initial:n = {},
	title .value_required:n = true,

	authors .tl_set:N  = \l_resume_patent_authors_tl,
	authors .initial:n = {},
	authors .value_required:n = true,

	type .tl_set:N  = \l_resume_patent_type_tl,
	type .initial:n = {},
	type .value_required:n = true,

	number .tl_set:N  = \l_resume_patent_number_tl,
	number .initial:n = {},
	number .value_required:n = true,

	date .tl_set:N  = \l_resume_patent_date_tl,
	date .initial:n = {},
	date .value_required:n = true,
}

\cs_new_protected:Npn \__resume_patent_ieee_render:n #1
{
	\group_begin:

	\keys_set:nn { patent } { #1 }

	\setlength{\baselineskip}{1.5em}
	\setlength{\parskip}{0.5\baselineskip}

	\l_resume_patent_authors_tl,\

	\tl_if_blank:VTF \l_resume_patent_url_tl
	{ ``\l_resume_patent_title_tl,''\  }
	{ ``\href{\l_resume_patent_url_tl}{\l_resume_patent_title_tl},''\  }

	\l_resume_patent_type_tl\ No.\ \l_resume_patent_number_tl,\ \l_resume_patent_date_tl.

	\par

	\group_end:
}

\NewDocumentCommand \patentieee { m }
{ \__resume_patent_ieee_render:n { #1 } }

% ------------------------------------------------------------------
% Abstract citation
% ------------------------------------------------------------------
\tl_new:N \l_resume_abstract_title_tl
\tl_new:N \l_resume_abstract_authors_tl
\tl_new:N \l_resume_abstract_conference_tl
\tl_new:N \l_resume_abstract_location_tl
\tl_new:N \l_resume_abstract_year_tl


\keys_define:nn { abstract }
{
	title .tl_set:N  = \l_resume_abstract_title_tl,
	title .initial:n = {},
	title .value_required:n = true,

	authors .tl_set:N  = \l_resume_abstract_authors_tl,
	authors .initial:n = {},
	authors .value_required:n = true,

	conference .tl_set:N  = \l_resume_abstract_conference_tl,
	conference .initial:n = {},
	conference .value_required:n = true,

	location .tl_set:N  = \l_resume_abstract_location_tl,
	location .initial:n = {},
	location .value_required:n = true,

	year .tl_set:N  = \l_resume_abstract_year_tl,
	year .initial:n = {},
	year .value_required:n = true,
}

\cs_new_protected:Npn \__resume_abstract_ieee_render:n #1
{
	\group_begin:

	\keys_set:nn { abstract } { #1 }

	\setlength{\baselineskip}{1.5em}
	\setlength{\parskip}{0.5\baselineskip}

	\l_resume_abstract_authors_tl,\ ``\l_resume_abstract_title_tl,''\
	presented\ at\ the\ \textit{\l_resume_abstract_conference_tl},\
	\l_resume_abstract_location_tl,\ \l_resume_abstract_year_tl.

	\par

	\group_end:
}

\NewDocumentCommand \abstractieee { m }
{ \__resume_abstract_ieee_render:n { #1 } }

% ------------------------------------------------------------------
% End expl3
% ------------------------------------------------------------------
\ExplSyntaxOff

% End class definition
