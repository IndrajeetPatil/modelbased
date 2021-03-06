% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/estimate_means.R
\name{estimate_means}
\alias{estimate_means}
\title{Estimate Marginal Means (Model-based average at each factor level)}
\usage{
estimate_means(
  model,
  levels = NULL,
  fixed = NULL,
  modulate = NULL,
  transform = "response",
  ci = 0.95,
  ...
)
}
\arguments{
\item{model}{A statistical model.}

\item{levels}{A character vector or formula specifying the names of the
factors over which levels to estimate the means, contrasts or slopes. If
\code{NULL} (default), will automatically try to find it.}

\item{fixed}{A character vector indicating the names of the predictors to be
"fixed" (i.e., maintained), so that the estimation is made at these values.}

\item{modulate}{A character vector indicating the names of a numeric variable
along which the means or the contrasts will be estimated. Other arguments
from \code{\link{visualisation_matrix}}, such as \code{length} to adjust the
number of data points.}

\item{transform}{Is passed to the \code{type} argument in \code{emmeans::emmeans()}. See \href{https://CRAN.R-project.org/package=emmeans/vignettes/transformations.html}{this vignette}. Can be \code{"none"} (default for contrasts),
\code{"response"} (default for means), \code{"mu"}, \code{"unlink"},
\code{"log"}. \code{"none"} will leave the values on scale of the linear
predictors. \code{"response"} will transform them on scale of the response
variable. Thus for a logistic model, \code{"none"} will give estimations
expressed in log-odds (probabilities on logit scale) and \code{"response"}
in terms of probabilities.}

\item{ci}{Confidence Interval (CI) level. Default to 0.95 (95\%).}

\item{...}{Other arguments passed for instance to \code{\link{visualisation_matrix}}.}
}
\value{
A dataframe of estimated marginal means.
}
\description{
Estimate average value of response variable at each factor levels. For plotting, check the examples in \code{\link{visualisation_recipe}}. See also other
related functions such as \code{\link{estimate_contrasts}} and \code{\link{estimate_slopes}}.
}
\examples{
library(modelbased)

# Frequentist models
# -------------------
model <- lm(Petal.Length ~ Sepal.Width * Species, data = iris)

estimate_means(model)
estimate_means(model, fixed = "Sepal.Width")
estimate_means(model, levels = c("Species", "Sepal.Width"), length = 2)
estimate_means(model, levels = "Species=c('versicolor', 'setosa')")
estimate_means(model, levels = "Sepal.Width=c(2, 4)")
estimate_means(model, levels = c("Species", "Sepal.Width=0"))
estimate_means(model, modulate = "Sepal.Width", length = 5)
estimate_means(model, modulate = "Sepal.Width=c(2, 4)")

# Methods that can be applied to it:
means <- estimate_means(model, fixed = "Sepal.Width")
plot(means) # which runs visualisation_recipe()
effectsize::standardize(means)
\donttest{
if (require("lme4")) {
  data <- iris
  data$Petal.Length_factor <- ifelse(data$Petal.Length < 4.2, "A", "B")

  model <- lmer(Petal.Length ~ Sepal.Width + Species + (1 | Petal.Length_factor), data = data)
  estimate_means(model)
  estimate_means(model, modulate = "Sepal.Width", length = 3)
}

# Bayesian models
# -------------------
data <- mtcars
data$cyl <- as.factor(data$cyl)
data$am <- as.factor(data$am)

if (require("rstanarm")) {
  model <- stan_glm(mpg ~ cyl * am, data = data, refresh = 0)
  estimate_means(model)

  model <- stan_glm(mpg ~ cyl * wt, data = data, refresh = 0)
  estimate_means(model)
  estimate_means(model, modulate = "wt")
  estimate_means(model, fixed = "wt")
}
}

\dontrun{
if (require("brms")) {
  model <- brm(mpg ~ cyl * am, data = data, refresh = 0)
  estimate_means(model)
}
}

}
