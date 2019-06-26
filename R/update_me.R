#' Update imthcm package itself
#'
#' Aim of this function is to check and eventually update the imthcm package
#' with a possible new version on GitHub.
#'
#' @return invisible()
#' @export
#'
#' @examples
#' \dontrun{
#'     library(imthcm)
#'     update_me()
#' }
update_me <- function() {

  if (!interactive()) {
    stop("Please run in interactive session", call. = FALSE)
  }

  ## Retrieve version of installed version of imthcm package
  #
  local <- utils::packageDescription('imthcm')[['Version']] %>%
    parse_version()

  ## Retrieve the versions for master and develop branches
  #
  remotes <- retrieve_remotes()


  ## Find the maximum depth of versioning to convert the other eventualy
  ## adding zeros
  #
  l_local   <- length(local)
  l_remote  <- purrr::map_int(remotes, length)
  max_depth <- max(l_local, l_remote)

  local_fill  <- (l_local  + 1L):(max_depth + 1L)
  remote_fill <- purrr::map(l_remote, ~ (.x + 1L):(max_depth + 1L))

  local[local_fill]   <- 0L
  remotes <- purrr::map2(remotes, remote_fill, ~ {
    .x[.y] <- 0L
    .x
  })

  to_be_updated <- purrr::map_lgl(remotes, ~ any(local < .x))
  developer     <- all(purrr::map_lgl(remotes, ~
                    !any(local < .x) && any(local > .x)
  ))

  if (!any(to_be_updated)) {
    message('You are up to date!')
    if (developer) {
      message(glue::glue(
        'Are you a developer? ',
        'Your version ({paste(local, collapse = ".")}) ',
        'is greater then every remote ones!'
      ))
    }
    return(invisible())
  } else {
    to_update <- remotes[to_be_updated]
    purrr::walk2(to_update, names(to_update), ~
      message(paste0(
        'The package version in the branch ',
        .y,
        ' is ', paste(.x, collapse = '.'), '\n',
        'Version of your installed package is ',
        paste(local, collapse = '.'), '\n\n'
      ))
    )

    branch_pkg <- paste0(
      "Which branch do you want to use to update your imthcm package?\n",
      paste("* ", names(to_update), collapse = "\n")
    )
    opt <- c(names(to_update),
      'Are you joking me?!',
      'I don\'t want to update imthcm!'
    )
    shuffle <- sample(seq_along(opt))
    which_branch <- utils::menu(opt[shuffle], title = branch_pkg)

    selection <- shuffle[which_branch]
    ok_pkg <- selection %in% seq_along(to_update)

    if (!ok_pkg) {
      message('0k, goodbye!')
      return(invisible())
    }

    devtools::install_github('UBESP-DCTV/imthcm',
      ref = names(to_update)[selection]
    )
  } # end of else in "if (!any(to_be_updated))"
  return(invisible())
}


#' Parse version of a package
#'
#' @param ver character string representing the version of a package
#'
#' @return an integer vector with the component of the version
#'
#' @examples
#' imthcm:::parse_version('0.2.1')

parse_version <- function(ver) {
  stringr::str_split(ver, '\\.') %>%
    unlist() %>%
    as.integer()
}

#' Get the version of the package in the remote
#'
#' @param con a connection to the remote DESCRIPTION file of the package
#'
#' @return a character string with the version of the package
#'
#' @examples
#'
#' url(
#'   'https://raw.githubusercontent.com/UBESP-DCTV/imthcm/master/DESCRIPTION'
#' ) %>%
#' imthcm:::remote_version()
remote_version <- function(con) {
  readLines(con) %>%
    stringr::str_subset('[Vv]er') %>%
    stringr::str_extract('[^\\s]+$') %>%
    parse_version()
}


retrieve_remotes <- function() {
  ## Open a connection with the master and develop branches DESCRIPTION file
  #
  cons <- purrr::map(c(master = 'master', develop = 'develop'), ~
    url(glue::glue(
      'https://raw.githubusercontent.com/UBESP-DCTV/imthcm/{.x}/DESCRIPTION'
    ))
  )
  on.exit(purrr::walk(cons, close), add = TRUE)

  ## Retrieve the versions for master and develop branches
  #
  purrr::map(cons, remote_version)
}
