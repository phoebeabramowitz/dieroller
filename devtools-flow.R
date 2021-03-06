check_sides <- function(sides){
  if(length(sides)!=6){
    stop("\nargument 'sides' must be a vector of length 6")
  }
  else{
    TRUE
  }
}

check_prob <- function(prob){
  if(length(prob)!=6){
    stop("\nargument 'sides' must be a vector of length 6")
  }
  if(sum(prob)!=1){
    stop("elements in \nargument 'prob' must add up to 1")
  }
  if (any(prob < 0) | any(prob > 1)) {
    stop("\n'prob' values must be between 0 and 1")
  }
  else{
    TRUE
  }
}

die <- function(sides=seq(1,6),prob=rep(1/6,6)){
  check_sides(sides)
  check_prob(prob)
  list(sides,prob)
}

#' @export
print.die <- function(x, ...) {
  cat('object "die"\n\n')
  cat(x[1],x[2])
  invisible(x)
}

#purpose: repeat each value in proportion to its probability in prob
#' @title check times functions
#' @description checks validity of times argument
#' @param times number of rolls
#' @return TRUE or Stop
#what to do if it's a numeric but actually an integer
check_times <- function(times){
  if (times <= 0 | !is.numeric(times)) {
    stop("\nargument 'times' must be a positive integer")
  } 
  else {
    TRUE
  }
}


#' @title Make Roll Object
#' @description Constructor function for object "roll"
#' @param die object of class die
#' @param flips object of class flip
#' @keywords internal
make_roll <- function(die,flips){
  res <- list(
    rolls = flips,
    sides = die[[1]],
    prob  = die[[2]],
    total = length(flips)
  )
  class(res) <- "roll"
  res
}

#' @title die roll function 
#' @description simulates rolling a die a given number of times
#' @param die object (a list of vectors)
#' @param times number of rolls
#' @return list of rolls,sides,prob,total
roll.die <- function(die, times = 1) {
  check_times
  flips <- sample(die[[1]], size = times, replace = TRUE, prob = die[[2]])
  make_roll(die,flips)
}

#' @export
print.roll <- function(x, ...) {
  cat('object "roll"\n\n')
  cat(x$rolls)
  invisible(x)
}

#' @export
summary.roll <- function(x, ...) {
  proportions <- c(
    sum(x$rolls == x$sides[1]) / x$total,
    sum(x$rolls == x$sides[2]) / x$total,
    sum(x$rolls == x$sides[3]) / x$total,
    sum(x$rolls == x$sides[4]) / x$total,
    sum(x$rolls == x$sides[5]) / x$total,
    sum(x$rolls == x$sides[6]) / x$total
  )
  freqs <- data.frame(
    side = x$sides,
    count = c(sum(x$rolls == x$sides[1]),
              sum(x$rolls == x$sides[2]),
              sum(x$rolls == x$sides[3]),
              sum(x$rolls == x$sides[4]),
              sum(x$rolls == x$sides[5]),
              sum(x$rolls == x$sides[6])
    ),
    prop = proportions)
  obj <- list(freqs = freqs)
  class(obj) <- "summary.roll"
  obj
}

#' @export
print.summary.roll <- function(x, ...) {
  cat('summary "roll"\n\n')
  print(x$freqs)
  invisible(x)
}

props <- function(x){
  c(sum(x$rolls == x$sides[1]) / x$total,
    sum(x$rolls == x$sides[2]) / x$total,
    sum(x$rolls == x$sides[3]) / x$total,
    sum(x$rolls == x$sides[4]) / x$total,
    sum(x$rolls == x$sides[5]) / x$total,
    sum(x$rolls == x$sides[6]) / x$total)
}

plot.roll <- function(x) {
  barplot(props(x), names.arg = x$sides,
          xlab = "sides of die", 
          ylab = sprintf("relative frequency"))
  title(sprintf("Relative Frequencies in a series of %s coin tosses", x$total))
}

#' @export
"[<-.roll" <- function(x, i, value) {
  if (value != x$sides[1] & value != x$sides[2] & value != x$sides[3] &
      value != x$sides[4] & value != x$sides[5] & value != x$sides[6]) {
    stop(sprintf('\nreplacing value must be %s, %s, %s, %s,%s or %s', x$sides[1], 
                 x$sides[2], x$sides[3], x$sides[4], x$sides[5], x$sides[6]))
  }
  if (i > x$total) {
    stop("\nindex out of bounds")
  }
  x$rolls[i] <- value
  make_roll(x$die, x$rolls)
}


#' @export
"[.roll" <- function(x, i) {
  x$rolls[i]
}


#' @export
"+.roll" <- function(obj, incr) {
  if (length(incr) != 1 | incr <= 0) {
    stop("\ninvalid increament")
  }
  more_flips <- sample(obj$sides, size = incr, replace = TRUE, prob = x$prob)
  make_roll(obj$die, c(obj$rolls, more_flips))
}

