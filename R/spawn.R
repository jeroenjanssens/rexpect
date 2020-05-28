#' Spawn a new rexpect session
#'
#' @param command A vector of strings.
#' @param name A string.
#' @param prompt A string.
#' @param width An integer.
#' @param height An integer.
#'
#' @return A rexpect_session.
#'
#' @export
spawn <- function(command, name = NULL, prompt = NULL, width = 80, height = 24) {

  # start tmux session
  session <- tmuxr::new_session(shell_command = command,
                                width = width,
                                height = height)

  # get pane
  pane <- tmuxr::list_panes(session)[[1]]
  structure(list(id = pane$id,
                 prompt = prompt),
            class = c("rexpect_session", class(pane)))
}


#' End a rexpect session
#'
#' @param session A rexpect_session.
#'
#' @export
exit <- function(session) {
  tmuxr::kill_pane(session$pane)
  invisible(NULL)
}


#' Wait
#'
#' @param session A rexpect_session.
#' @param duration A numerical. Time to wait in seconds. Default: `0.1`.
#'
#' @export
wait <- function(session, duration = 0.1) {
  Sys.sleep(duration)
  invisible(session)
}
