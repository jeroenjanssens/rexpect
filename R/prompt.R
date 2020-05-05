#' Does the contents of a pane end with prompt?
#'
#' @param session A rexpect_session.
#'
#' @export
ends_with_prompt <- function(session) {
  if (!has_prompt(session)) return(FALSE)
  lines <- tmuxr::capture_pane(session$pane)
  last_line <- utils::tail(lines[lines != ""], n = 1)
  (length(last_line) > 0L) && grepl(last_line, session$prompt)
}


#' Get the prompt
#'
#' @param session A rexpect_session.
#'
#' @return String containing a regular expression that matches all relevant
#' prompts.
#'
#' @export
get_prompt <- function(session) {
  session$prompt
}


#' Set the prompt
#'
#' @param session A rexpect_session.
#' @param prompt String containing a regular expression that matches all
#' relevant prompts.
#'
#' @export
set_prompt <- function(session, prompt) {
  session$prompt <- prompt
  invisible(session)
}


#' Does session have a prompt?
#'
#' @param session A session, window, or pane.
#'
#' @export
has_prompt <- function(session) {
  !is.null(get_prompt(session))
}


#' Common prompt patterns
#'
#' @export
prompts <- list(
  bash = "^([^ \\$]*(\\$|#)|>)$",
  ipython = "^(In \\[[0-9]+\\]| {6,})|$",
  jupyter = "^(In \\[[0-9]+\\]| {6,})|$",
  python = "^(>>>|\\.\\.\\.)$",
  r = "^(>|\\+)$",
  R = "^(>|\\+)$"
)
