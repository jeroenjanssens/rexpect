#' Read screen
#'
#' @param session A rexpect_session.
#' @param ... Other arguments passed on to `tmuxr::capture_pane`.
#'
#' @export
read_screen <- function(session, ...) {
  tmuxr::capture_pane(session, ...)
}


#' Read last line
#'
#' @param session A rexpect_session.
#'
#' @export
read_last_line <- function(session) {
  n <- as.numeric(tmuxr::prop(session, "cursor_y"))
  tmuxr::capture_pane(session, start = n, end = n)
}


#' Number of lines
#'
#' Includes the current line.
#'
#' @param x A rexpect_session.
#'
#' @return An integer.
#'
#' @export
length.rexpect_session <- function(x) {
  session <- x
  on_screen <- cursor(session)[2]
  off_screen <- as.numeric(tmuxr::prop(session, "history_size"))
  on_screen + off_screen
}

#' Get cursor position on screen
#'
#' Starts at top-left corner (1, 1) and ends at bottom-right corner
#'   (width, height)
#'
#' @param session A rexpect_session.
#'
#' @return A numerical vector with two values.
#'
#' @export
cursor <- function(session) {
  x_y <- tmuxr::display_message(session, "#{cursor_x}\n#{cursor_y}")
  as.numeric(x_y) + 1 # in tmux, cursor_x and cursor_y start at 0
}


#' Read all output
#'
#' @param session A rexpect_session.
#'
#' @return A vector of strings.
#'
#' @export
read_all <- function(session) {
  tmuxr::capture_pane(session, start = "-", end = cursor(session)[2] - 1)
}


#' Read a portion of all output
#'
#' @param session A rexpect_session.
#' @param from,to Integers.
#' @param ... Other arguments passed on to `tmuxr::capture_pane`.
#'
#' @return A vector of strings.
#'
#' @export
read_output <- function(session, from, to, ...) {
  off_screen <- as.numeric(tmuxr::prop(session, "history_size"))
  start = from - off_screen - 1
  end = to - off_screen - 1
  tmuxr::capture_pane(session, start = start, end = end, ...)
}


#' @export
`[<-.rexpect_session` <- function(session, ind = NULL, value) {
  stop("cannot rewrite history", call. = FALSE)
}


#' @export
`[.rexpect_session` <- function(session, ind = NULL) {
  if (is.null(ind)) return(read_all(session))

  if (any(ind < 0) && any(ind > 0)) {
    stop("only 0's may be mixed with negative subscripts", call. = FALSE)
  }

  ind <- ind[ind != 0]
  if (length(ind) == 0) return(character())

  if (all(ind < 0)) {
    pos <- 1:length(session)
    ind <- pos[ind]
  }

  from <- min(ind)
  to <- max(ind)
  lines <- read_output(session, from = from, to = to)
  ind <- ind - from + 1
  lines[ind]
}
