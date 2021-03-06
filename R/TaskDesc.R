#' Description object for task.
#'
#' Description object for task, encapsulates basic properties of the task
#' without having to store the complete data set.
#'
#' Object members:
#' \describe{
#' \item{id [\code{character(1)}]}{Id string of task.}
#' \item{type [\code{character(1)}]}{Type of task, \dQuote{classif} for classification,
#'   \dQuote{regr} for regression, \dQuote{surv} for survival and \dQuote{cluster} for
#'   cluster analysis, \dQuote{costsens} for cost-sensitive classification, and
#'   \dQuote{multilabel} for multilabel classification.}
#' \item{target [\code{character(0)} | \code{character(1)} | \code{character(2)} | \code{character(n.classes)}]}{
#'   Name(s) of the target variable(s).
#'   For \dQuote{surv} these are the names of the survival time and event columns, so it has length 2.
#'   For \dQuote{costsens} it has length 0, as there is no target column, but a cost matrix instead.
#'   For \dQuote{multilabel} these are the names of logical columns that indicate whether a
#'   class label is present and the number of target variables corresponds to the number of
#'   classes.}
#' \item{size [\code{integer(1)}]}{Number of cases in data set.}
#' \item{n.feat [\code{integer(2)}]}{Number of features, named vector with entries:
#'   \dQuote{numerics}, \dQuote{factors}, \dQuote{ordered}, \dQuote{functionals}.}
#' \item{has.missings [\code{logical(1)}]}{Are missing values present?}
#' \item{has.weights [\code{logical(1)}]}{Are weights specified for each observation?}
#' \item{has.blocking [\code{logical(1)}]}{Is a blocking factor for cases available in the task?}
#' \item{class.levels [\code{character}]}{All possible classes.
#'   Only present for \dQuote{classif}, \dQuote{costsens}, and \dQuote{multilabel}.}
#' \item{positive [\code{character(1)}]}{Positive class label for binary classification.
#'   Only present for \dQuote{classif}, NA for multiclass.}
#' \item{negative [\code{character(1)}]}{Negative class label for binary classification.
#'   Only present for \dQuote{classif}, NA for multiclass.}
#' }
#' @name TaskDesc
#' @rdname TaskDesc
NULL

makeTaskDescInternal = function(type, id, data, target, weights, blocking, spatial) {
  # get classes of feature cols
  cl = vcapply(data, function(x) class(x)[1L])
  cl = table(dropNamed(cl, target))
  n.feat = c(
    numerics = sum(cl[c("integer", "numeric")], na.rm = TRUE),
    factors = sum(cl["factor"], na.rm = TRUE),
    ordered = sum(cl["ordered"], na.rm = TRUE),
    functionals = sum(cl["matrix"], na.rm = TRUE)
  )

  makeS3Obj("TaskDesc",
    id = id,
    type = type,
    target = target,
    size = nrow(data),
    n.feat = n.feat,
    has.missings = anyMissing(data),
    has.weights = !is.null(weights),
    has.blocking = !is.null(blocking),
    is.spatial = spatial
  )
}
