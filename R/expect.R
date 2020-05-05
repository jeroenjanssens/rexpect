#' Expect prompt
#'
#' Block a session until the prompt appears.
#'
#' @param session A rexpect_session.
#' @param time Numerical. Time to wait in seconds between tries.
#'
#' @export
expect_prompt <- function(session, time = 0.1) {
  if (has_prompt(session)) {
    while (!ends_with_prompt(session)) wait(session, time)
  } else {
    warning("session has no prompt", call. = FALSE)
  }
  invisible(session)
}


# TODO: expect_silence, duration in seconds
# TODO: expect_pattern
# TODO: expect_switch (like case_when)
# NOTE: timeout in seconds
# NOTE: on_timeout ("error", "continue", func)
