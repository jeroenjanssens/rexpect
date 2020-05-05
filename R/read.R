#' Read screen
#'
#' @param session A rexpect_session.
#'
#' @export
read_screen <- function(session) {
  tmuxr::capture_pane(session$pane)
}

# TODO: read_last
# TODO: read_history
# TODO: read_lines
# TODO: read_rectangle
# TODO: read_df
