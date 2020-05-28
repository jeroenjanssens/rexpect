#' Send Enter
#'
#' @param session A rexpect_session.
#'
#' @return session
#'
#' @export
send_enter <- function(session) {
  tmuxr::send_keys(session, "Enter")
  invisible(session)
}


#' Send Backspace
#'
#' @param session A rexpect_session.
#'
#' @return session
#'
#' @export
send_backspace <- function(session) {
  tmuxr::send_keys(session, "BSpace")
  invisible(session)
}


#' Send Control-C
#'
#' @param session A rexpect_session.
#'
#' @return session
#'
#' @export
send_control_c <- function(session) {
  tmuxr::send_keys(session, "C-c")
  invisible(session)
}


#' Send literal text
#'
#' @param session A rexpect_session.
#' @param ... One or more strings.
#' @param wait A logical. If `TRUE`, wait for prompt to appear before sending
#'   each line. Default: `FALSE`.
#'
#' @return session
send_lines <- function(session, ..., wait = FALSE) {
  for (line in c(...)) {
    if (wait) expect_prompt(session)
    tmuxr::send_keys(session, line, literal = TRUE)
    send_enter(session)
  }
  invisible(session)
}

# TODO: send_df
