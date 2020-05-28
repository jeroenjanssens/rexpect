#' Does the output end with a prompt?
#'
#' @param session A rexpect_session.
#'
#' @export
ends_with_prompt <- function(session) {
  has_prompt(session) && grepl(prompt(session), read_last_line(session))
}


#' Prompt of an rexpect session
#'
#' Functions to get and set the prompt of an rexpect session. Note: this
#' function does not change the prompt of the command that is running.
#'
#' @param session A rexpect_session.
#' @param value String containing a regular expression that matches all
#'   relevant patterns.
#'
#' @return String containing a regular expression that matches all relevant
#'   patterns.
#'
#' @export
prompt <- function(session) {
  session$prompt
}


#' @rdname prompt
#' @export
`prompt<-` <- function(session, value) {
  set_prompt(session, value)
}


#' @export
#' @rdname prompt
set_prompt <- function(session, value) {
  session$prompt <- value
  invisible(session)
}


#' Does session have a prompt?
#'
#' @param session A rexpect_session.
#'
#' @export
has_prompt <- function(session) {
  !is.null(prompt(session))
}


#' Commonly used prompts
#'
#' @export
prompts <- list(
  bash = "^(.*(\\$|#)|>)$",
  ipython = "^(In \\[[0-9]+\\]| {6,})|$",
  jupyter = "^(In \\[[0-9]+\\]| {6,})|$",
  python = "^(>>>|\\.\\.\\.)$",
  r = "^(>|\\+)$",
  R = "^(>|\\+)$"
)
