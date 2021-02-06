#' Expect prompt
#'
#' Wait until the prompt appears on the last line.
#'
#' @param session A rexpect_session.
#' @param interval Numerical. Time to wait between tries in seconds.
#'   Default: 0.5.
#' @param timeout Numerical. Maximum amount of time to wait.
#'   Default: `NULL`.
#'
#' @export
expect_prompt <- function(session, interval = 0.5, timeout = NULL) {
  start <- Sys.time()
  if (has_prompt(session)) {
    while (!ends_with_prompt(session)) {
      Sys.sleep(interval)
      if (!is.null(timeout) && (Sys.time() - start) >= timeout) {
        stop("timed out after ", timeout, " seconds", call. = FALSE)
      }
    }
  } else {
    warning("session has no prompt", call. = FALSE)
  }
  invisible(session)
}


#' Expect silence
#'
#' Wait until the output hasn't changed for a while.
#'
#' @param session A rexpect_session.
#' @param duration Numerical. Time output needs to remain unchanged in seconds.
#'   Default: 1.
#' @param interval Numerical. Time to wait between tries in seconds.
#'   Default: 0.5.
#' @param timeout Numerical. Maximum amount of time to wait.
#'   Default: `NULL`.
#'
#' @export
expect_silence <- function(session, duration = 1,
                           interval = 0.5, timeout = NULL) {
  start <- Sys.time()
  timer <- start

  last_activity <- tmuxr::prop(session, "window_activity")

  while (TRUE) {
    Sys.sleep(interval)
    activity <- tmuxr::prop(session, "window_activity")
    if (last_activity != activity) {
      last_activity <- activity
      timer <- Sys.time()
    }

    if ((Sys.time() - timer) >= duration) break
    if (!is.null(timeout) && (Sys.time() - start) >= timeout) {
      stop("timed out after ", timeout, " seconds", call. = FALSE)
    }
  }

  invisible(session)
}


# TODO: expect_pattern
# TODO: expect_switch (like case_when)
