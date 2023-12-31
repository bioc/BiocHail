% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rownames.R
\name{rownames,hail.table.Table-method}
\alias{rownames,hail.table.Table-method}
\title{acquire row names of a Hail Table, assuming key has been set}
\usage{
\S4method{rownames}{hail.table.Table}(x, do.NULL = TRUE, prefix = "row")
}
\arguments{
\item{x}{instance of hail.table.Table}

\item{do.NULL}{not used}

\item{prefix}{not used}
}
\value{
character()

character vector
}
\description{
acquire row names of a Hail Table, assuming key has been set
}
\note{
To try example, run `example("rownames,hail.table.Table-method")`
}
\examples{
hl <- hail_init()
annopath <- path_1kg_annotations()
tab <- hl$import_table(annopath, impute = TRUE)$key_by("Sample")
rt <- rownames(tab)
length(rt)
head(rt)
}
