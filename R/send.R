#' Send keys
#'
#' @param session A rexpect_session.
#' @param ... Strings. Keys to send.
#' @param literal A logical. If `TRUE`, key name lookup is disabled and the keys
#'   are processed as literal UTF-8 characters. Default: `FALSE`.
#' @param count An integer. Number of times the keys are sent. Default: `1L`.
#'
#' @export
send_keys <- function(session, ..., literal = FALSE, count = 1L) {
  tmuxr::send_keys(session, ..., literal = literal, count = count)
  invisible(session)
}


#' Send Enter
#'
#' @param session A rexpect_session.
#'
#' @return session
send_enter <- function(session) {
  send_keys(session, "Enter")
}


#' Send Backspace
#'
#' @param session A rexpect_session.
#'
#' @return session
send_backspace <- function(session) {
  send_keys(session, "BSpace")
}


#' Send Control-C
#'
#' @param session A rexpect_session.
#'
#' @return session
send_control_c <- function(session) {
  send_keys(session, "C-c")
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
    send_keys(session, line, literal = TRUE)
    send_enter(session)
  }
  invisible(session)
}

# TODO: send_df
