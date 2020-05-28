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
#'
#' @export
send_lines <- function(session, ..., wait = FALSE) {
  for (line in c(...)) {
    if (wait) expect_prompt(session)
    tmuxr::send_keys(session, line, literal = TRUE)
    send_enter(session)
  }
  invisible(session)
}

#' Send script
#'
#' @export
send_script <- function(session, code, marker = "#!", ...) {

  default_options <- list(...)

  for (line in code) {
    line_options <- parse_line_options(line, marker)
    line_options$session <- session

    line_options <- copy_option(line_options, default_options, "literal")
    line_options <- copy_option(line_options, default_options, "enter")
    line_options <- copy_option(line_options, default_options, "expect_prompt")

    do.call(execute_line, line_options)
  }

  invisible(session)
}


#' @keywords internal
copy_option <- function(a, b, x) {
  if (x %in% names(b) && !(x %in% names(a))) a[[x]] <- b[[x]]
  a
}

#' @keywords internal
parse_line_options <- function(line, marker) {
  parts <- strsplit(line, marker)[[1]]
  if (length(parts) > 1) {
    line_options <- eval(parse(text = paste0("alist(",
                                             paste0(parts[2:length(parts)],
                                                    collapse = ","),
                                             ")"),
                               keep.source = FALSE))
  } else {
    line_options <- list()
  }

  line_options$code <- parts[1]
  line_options
}


#' @keywords internal
execute_line <- function(session,
                         code,
                         literal = TRUE,
                         enter = literal,
                         wait = 0.1,
                         pause = 0.1,
                         hold = 0.1,
                         expect_prompt = enter)  {

  if (wait > 0) rexpect::wait(session, wait)

  if (!is.na(code) && trimws(code) != "") {
    if (literal) {
      tmuxr::send_keys(session, code, literal = TRUE)
    } else {
      parts <- strsplit(code, " ")[[1]]
      if (length(parts) == 1L) {
        tmuxr::send_keys(session, parts[1], literal = FALSE)
      } else {
        for (part in parts) {
          if (part == "") {
            rexpect::wait(session, pause)
          } else {
            tmuxr::send_keys(session, part, literal = FALSE)
          }
        }
      }
    }
  }

  if (enter) rexpect::send_enter(session)
  if (hold > 0) rexpect::wait(session, hold)
  if (expect_prompt) rexpect::expect_prompt(session)
}

