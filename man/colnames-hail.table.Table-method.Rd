% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/colnames.R
\name{colnames,hail.table.Table-method}
\alias{colnames,hail.table.Table-method}
\title{extract field names from hail.table.Table}
\usage{
\S4method{colnames}{hail.table.Table}(x, do.NULL = TRUE, prefix = "col")
}
\arguments{
\item{x}{hail.table.Table instance}

\item{do.NULL}{ignored}

\item{prefix}{ignored}
}
\value{
character vector
}
\description{
extract field names from hail.table.Table
}
\examples{
hl <- hail_init()
annopath <- path_1kg_annotations()
tab <- hl$import_table(annopath, impute = TRUE)$key_by("Sample")
colnames(tab)
}
