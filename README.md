
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rexpect <img src="man/figures/logo.png" align="right" width="100px" />

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-green.svg)](https://www.tidyverse.org/lifecycle/#stable)

`rexpect` is an R package that allows you to automate interactions with
programs that expose a text terminal interface. The API is inspired by
the original Expect tool by Don Libes.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("jeroenjanssens/rexpect")
```

## Example

Let’s say we have a Python script that repeatedly asks for a number.
When the user enters `sum`, the script prints the sum of all the
numbers. The script exits when the user presses `CTRL-C`. Here’s the
contents of *bin/sum.py*:

``` python
#!/usr/bin/env python3

numbers = []

while True:
    user_input = input("Enter a number: ")
    
    if user_input == "sum":
        print(f"The sum is: {sum(numbers)}")
        continue

    try:
        numbers.append(float(user_input))
    except ValueError:
        print("Please enter a valid number.")
```

We can use `rexpect` to run this script and interact with it. Let’s
enter the numbers 7, 13, and 22 and see what the sum is:

``` r
library(rexpect)
#> 
#> Attaching package: 'rexpect'
#> The following object is masked from 'package:utils':
#> 
#>     prompt

session <- spawn("bin/sum.py", prompt = "^(.*):$")
send_lines(session, c("7", "13", "22", "sum"), wait = TRUE)
```

Under the hood, `rexpect` starts a tmux session using
[tmuxr](https://jeroenjanssens.github.io/tmuxr):

``` r
session
#> tmuxr pane 42:1.0: [80x23] [history 0/50000, 3912 bytes] %48 (active)
```

We can capture the output and extract the sum:

``` r
print(output <- read_all(session))
#> [1] "Enter a number: 7"   "Enter a number: 13"  "Enter a number: 22" 
#> [4] "Enter a number: sum" "The sum is: 42.0"    "Enter a number:"
as.numeric(gsub("[^0-9.]", "", output[length(output) - 1]))
#> [1] 42
```

We’ve accomplished our goal, so let’s exit:

``` r
send_lines(session, "exit")
read_all(session)
#> [1] "Enter a number: 7"            "Enter a number: 13"          
#> [3] "Enter a number: 22"           "Enter a number: sum"         
#> [5] "The sum is: 42.0"             "Enter a number: exit"        
#> [7] "Please enter a valid number." "Enter a number:"
```

Oh that’s right, we need to press `CTRL-C` to exit the script:

``` r
send_control_c(session)
```

This was a rather simple example to demonstrate some of the capabilities
of `rexpect`. The session could have taken place inside a Docker
container or over SSH. We could also have recorded the session using
[asciinema](https://asciinema.org/). Have a look at [the function
reference](https://jeroenjanssens.github.io/rexpect/reference/) to learn
more about what `rexpect` has to offer.

## License

The `rexpect` package is licensed under the MIT License.
