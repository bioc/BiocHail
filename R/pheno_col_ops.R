#' top-level annotation harvesting from columns of summary statistics MatrixTable
#' @param x a Struct returned from mt$cols()$collect() -- which can be slow
#' @param toget character() vector of field names to retrieve
#' @note python None are transformed to NA
#' @return 1-row data.frame
top2df <- function(x, toget = c("trait_type", "phenocode", "description", "modifier", "coding_description")) {
  # must deal with python 'None'
  z <- data.frame(lapply(toget, function(w) {
    chk <- x[[w]]
    if (is.null(chk)) chk <- NA
    chk
  }))
  names(z) <- toget
  z
}

#' pheno_data component harvesting from columns of summary stats MatrixTable
#' @param m Struct returned from mt$cols()$collect()
#' @param section numeric(1) element of pheno_data list to be transformed to data.frame
#' @param toget character() vector of field names to retrieve
#' @param verbose logical(1) if TRUE (NOT default) will message that there are multiple
#' `pheno_data` components returned
#' @note applies top2df to the pheno_data component of input
#' @return 1 row data.frame
pheno_data_sec_2df <- function(m, section = 1,
                               toget = c("n_cases", "n_controls", "heritability", "pop"), verbose = FALSE) {
  pd <- m$pheno_data
  npd <- length(pd)
  if (npd > 1) {
    if (section > npd) stop("requested section number in excess of available pheno_data elements returned")
    if (verbose) {
      message(sprintf("there are %d pheno_data components, selecting component %d", npd, section))
    }
  }
  z <- pd[[section]]
  top2df(z, toget = toget)
}

#' pheno_data component harvesting from columns of summary stats MatrixTable
#' allowing for info on multiple populations in the pheno_data component
#' @param x Struct - a single element of the list returned by mt$cols()$collect()
#' @param top2get character() vector of general fields to retrieve
#' @param pheno2get character() vector of fields to be retrieved for each subpopulation
#' @return data.frame
#' @examples
#' # following are too time-consuming but can be of interest
#' # if (nchar(Sys.getenv("HAIL_UKBB_SUMSTAT_10K_PATH"))>0) {
#' #  hl = hail_init()
#' #  ss = get_ukbb_sumstat_10kloci_mt(hl)
#' #  sscol = ss$cols()$collect() # may take a bit of time
#' #  print(length(sscol))
#' #  multipop_df(sscol[[1]])
#' # }
#' #
#' \donttest{
#' # if (nchar(Sys.getenv("HAIL_UKBB_SUMSTAT_10K_PATH"))>0) {
#' # # to get an overview of all phenotype-cohort combinations in a searchable table
#' # mmm = lapply(sscol, multipop_df )
#' # mymy = do.call(rbind, mmm) # over 16k rows
#' # DT::datatable(mymy)
#' # }
#' #
#' }
#' # this runs quickly and is demonstrative
#' hl <- hail_init()
#' litzip <- system.file("extdata", "myss2.zip", package = "BiocHail")
#' td <- tempdir()
#' unzip(litzip, exdir = td)
#' ntab <- hl$read_matrix_table(paste0(td, "/myss2.mt"))
#' ntab$describe()
#' nt2 <- ntab$col$collect()
#' multipop_df(nt2[[1]]) # must select one element
#' @export
multipop_df <- function(x, top2get = c(
                          "trait_type", "phenocode",
                          "description", "modifier", "coding_description", "coding"
                        ),
                        pheno2get = c("n_cases", "n_controls", "heritability", "pop")) {
  nph <- length(x$pheno_data)
  ini <- top2df(x, toget = top2get)
  multi <- do.call(rbind, lapply(seq_len(nph), function(z) {
    pheno_data_sec_2df(x,
      section = z,
      toget = pheno2get
    )
  }))
  cbind(ini, multi)
}
