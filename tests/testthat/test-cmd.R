context("cmd")

test_that("cmd works", {
  expect_identical(c("seq", "5"), cmd("seq", "5"))
})


test_that("everything works", {
  s <- spawn(cmd_bash(c("PS1='$ ' bash")), width = 120)
  expect_warning(expect_prompt(s))
  prompt(s) <- prompts$bash
  expect_prompt(s)
  tmuxr::send_keys(s, "a")
  send_backspace(s)
  start <- length(s)
  send_script(s, c("echo hi",
                   "seq#! literal = FALSE, enter = FALSE",
                   "Space  5#! literal = FALSE, hold = 0.1"),
              literal = TRUE)
  expect_error(expect_prompt(s, timeout = 1))
  send_enter(s)
  expect_silence(s)
  expect_prompt(s)
  output <- s[(length(s) - 5):(length(s) - 1)]
  expect_identical(output, c("1", "2", "3", "4", "5"))
  expect_identical(tail(s[], -5), s[-c(1:5)])
  expect_error(s[c(-1, 1)])
  expect_identical(s[0], character())
  send_lines(s, c("while true",
                  "do",
                  "date",
                  "sleep 0.5",
                  "done"), wait = TRUE)
  wait(s, 0.1)
  expect_true(length(read_screen(s)) >= 23)
  expect_error(expect_silence(s, duration = 2, timeout = 3))
  wait(s, 1)
  send_control_c(s)
  expect_silence(s)
  expect_error(s[] <- NULL)
  exit(s)
})


test_that("Docker works", {
  skip_on_cran()
  skip_on_ci()
  command <- cmd_docker(cmd_r("seq(as.integer('5')); Sys.sleep(10)"),
                        "rocker/r-ver:3.5")
  s <- spawn(command)
  expect_silence(s, 5)
  expect_identical(s[length(s) - 1], "[1] 1 2 3 4 5")
  exit(s)
})


test_that("asciinema works", {
  skip_on_cran()
  skip_on_ci()
  command <- cmd_asciinema(cmd_bash(c("PS1='$ ' bash")))
  expect_identical(command[1:2], c("asciinema", "rec"))
  filename <- command[3]
  s <- spawn(command, prompt = prompts$bash)
  expect_prompt(s)
  send_lines(s, "echo hi")
  exit(s)
  output <- processx::run("asciinema", c("cat", filename))$stdout
  expect_match(output, "echo")
  unlink(filename)
})
