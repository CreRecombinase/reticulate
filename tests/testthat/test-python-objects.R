context("objects")

test_that("the length of a Python object can be computed", {
  skip_if_no_python()

  m <- py_eval("[1, 2, 3]", convert = FALSE)
  expect_equal(length(m), 3L)

  x <- py_eval("None", convert = FALSE)
  expect_identical(length(x), 0L)
  expect_identical(py_bool(x), FALSE)
  expect_error(py_len(x), "'NoneType' has no len()")

  x <- py_eval("object()", convert = FALSE)
  expect_identical(length(x), 1L)
  expect_identical(py_bool(x), TRUE)
  expect_error(py_len(x), "'object' has no len()")

})

test_that("python objects with a __setitem__ method can be used", {
  skip_if_no_python()

  library(reticulate)
  py_run_string('
class M:
  def __getitem__(self, k):
    return "M"
')

  m <- py_eval('M()', convert = TRUE)
  expect_equal(m[1], "M")

  m <- py_eval('M()', convert = FALSE)
  expect_equal(m[1], r_to_py("M"))

})



test_that("py_id() returns unique strings; #1216", {
  skip_if_no_python()

  pypy_id <- py_eval("lambda x: str(id(x))")
  o <- py_eval("object()")
  id <- pypy_id(o)
  expect_identical(py_id(o), pypy_id(o))
  expect_identical(py_id(o), id)

  expect_false(py_id(py_eval("object()")) == py_id(py_eval("object()")))
  expect_true(py_id(py_eval("object")) == py_id(py_eval("object")))
})
