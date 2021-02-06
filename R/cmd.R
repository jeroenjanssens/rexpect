#' Command composition
#'
#' @param command A string.
#' @param args A vector of strings.
#' @param ... Strings.
#' @param vanilla A logical.
#' @param remove A logical.
#' @param image A string.
#' @param filename A string.
#' @param overwrite A logical.
#'
#' @return A vector of strings.
#'
#' @export
cmd <- function(command = NULL, args = NULL, ...) {
  c(command, args, ...)
}


#' @rdname cmd
#' @export
cmd_bash <- function(command = NULL) {
  parts <- c("bash")
  if (!is.null(command)) parts <- c(parts, "-c", command)
  parts
}


#' @rdname cmd
#' @export
cmd_r <- function(command = NULL, vanilla = TRUE) {
  parts <- c("R")
  if (vanilla) parts <- c(parts, "--vanilla")
  if (!is.null(command)) parts <- c(parts, "-e", command)
  parts
}


#' @rdname cmd
#' @export
cmd_docker <- function(command = NULL,
                       image,
                       remove = TRUE,
                       volume = NULL,
                       ...) {

  parts <- c("docker", "run")
  if (remove) parts <- c(parts, "--rm")
  if (!is.null(volume)) {
    volume_parts <- rep(paste(names(volume), volume, sep = ":"), each = 2)
    volume_parts[c(TRUE,FALSE)] <- "-v"
    parts <- c(parts, volume_parts)
  }
  parts <- c(parts, "-i", "-t", image)
  if (!is.null(command)) parts <- c(parts, command)
  parts
}


#' @rdname cmd
#' @export
cmd_asciinema <- function(command = NULL, filename = NULL, overwrite = TRUE) {
  if (is.null(filename)) filename <- tempfile()

  message("Recording asciicast at ", filename)
  parts <- c("asciinema", "rec", filename, "-q")
  if (overwrite) parts <- c(parts, "--overwrite")
  if (!is.null(command)) {
    parts <- c(parts, "-c", command)
  }
  parts
}
