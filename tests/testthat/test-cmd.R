context("cmd")

test_that("cmd works", {
  expect_identical(c("seq", "5"), cmd("seq", "5"))
})
