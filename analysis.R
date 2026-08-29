# Analysis for "Is It He or She? Contrasting Gender Bias in Machine
# Translation and Generative AI".
#
# Input   coded_data.csv  -- one row per occupation, codes M / F / S for
#                            each platform in each phase
# Output  the tables and tests reported in sections 4.1 to 4.6
#
# Base R only. Set the working directory to this file's location, then
# source it.

d <- read.csv("coded_data.csv", stringsAsFactors = FALSE)
d$dir[is.na(d$dir)] <- ""

cats  <- c("M", "F", "S")               # masculine, feminine, split-gender
plats <- c("Bing", "Google", "DeepL", "ChatGPT")
n     <- nrow(d)
stopifnot(n == 128, !anyNA(d[, paste0(rep(plats, each = 2), "_",
                                      c("2023", "2026"))]))

# 2023 rows, 2026 columns
tt <- function(p) table(factor(d[[paste0(p, "_2023")]], cats),
                        factor(d[[paste0(p, "_2026")]], cats))

# codes as an n x 4 matrix, platforms in columns
codes <- function(w) sapply(plats, function(p) d[[paste0(p, "_", w)]])

# Wilson score interval, per cent. binom.test() returns Clopper-Pearson,
# which is not what is reported.
wilson <- function(k, n, conf = 0.95) {
  z   <- qnorm(1 - (1 - conf) / 2)
  ph  <- k / n
  den <- 1 + z^2 / n
  mid <- (ph + z^2 / (2 * n)) / den
  hw  <- z * sqrt(ph * (1 - ph) / n + z^2 / (4 * n^2)) / den
  100 * c(mid - hw, mid + hw)
}


# Table 1. Distribution by platform and phase ---------------------------

tab1 <- list()
for (p in plats) for (w in c("2023", "2026")) {
  v <- d[[paste0(p, "_", w)]]
  for (k in cats) {
    m  <- sum(v == k)
    ci <- wilson(m, n)
    tab1[[length(tab1) + 1L]] <- data.frame(
      platform = p, phase = w, code = k, n = m,
      pct = 100 * m / n, lo = ci[1], hi = ci[2])
  }
}
tab1 <- do.call(rbind, tab1)
cat("\nTable 1. Gender output by platform and phase, Wilson 95% CI\n")
print(tab1, digits = 3, row.names = FALSE)


# Table 2. Transitions, all four platforms pooled -----------------------

pooled <- Reduce(`+`, lapply(plats, tt))
cat("\nTable 2. Transitions, pooled (N =", sum(pooled), ")\n")
print(pooled)
cat("unchanged:", sum(diag(pooled)),
    sprintf("(%.1f%%)\n", 100 * sum(diag(pooled)) / sum(pooled)))


# 4.2 Stuart-Maxwell test of marginal homogeneity -----------------------
# No continuity correction is applied. A response category unoccupied in
# both phases is dropped rather than smoothed, being structurally absent
# from the platform's output rather than absent by sampling. This affects
# ChatGPT alone, which produced no split-gender output in either phase:
# its table reduces to the masculine-feminine contrast at one df.

smax <- function(x) {
  x <- matrix(as.numeric(x), nrow = nrow(x))
  k <- which(rowSums(x) > 0 | colSums(x) > 0)
  x <- x[k, k, drop = FALSE]
  m <- nrow(x) - 1L
  i <- seq_len(m)
  dv <- (rowSums(x) - colSums(x))[i]
  V  <- -(x[i, i, drop = FALSE] + t(x[i, i, drop = FALSE]))
  diag(V) <- (rowSums(x) + colSums(x) - 2 * diag(x))[i]
  q <- drop(dv %*% solve(V) %*% dv)
  c(chisq = q, df = m, p = pchisq(q, m, lower.tail = FALSE))
}

for (p in plats) {
  cat("\n", p, ", ", sum(tt(p)) - sum(diag(tt(p))), " items changed\n", sep = "")
  print(tt(p))
}
cat("\nStuart-Maxwell, uncorrected\n")
print(as.data.frame(t(sapply(plats, function(p) smax(tt(p))))), digits = 5)


# 4.2 Exact McNemar, masculine vs not-masculine -------------------------
# mcnemar.test() is the asymptotic version and applies a continuity
# correction by default; the exact test is the binomial on the discordant
# pairs.

mcn <- list()
for (p in plats) {
  a  <- d[[paste0(p, "_2023")]] == "M"
  b  <- d[[paste0(p, "_2026")]] == "M"
  bc <- c(sum(a & !b), sum(!a & b))
  ci <- wilson(sum(b), n)
  mcn[[p]] <- data.frame(platform = p, M_to_not = bc[1], not_to_M = bc[2],
                         p = binom.test(bc[1], sum(bc), 0.5)$p.value,
                         masc_2026 = 100 * sum(b) / n, lo = ci[1], hi = ci[2])
}
cat("\nExact McNemar, masculine vs not-masculine\n")
print(do.call(rbind, mcn), digits = 4, row.names = FALSE)


# 4.4 Direction of the split --------------------------------------------

he  <- sum(startsWith(d$dir, "competent=He"))
she <- sum(startsWith(d$dir, "competent=She"))
bt  <- binom.test(he, he + she, 0.5)
w3  <- wilson(he, he + she)

cat("\nDirection of split-gender assignment\n")
cat("competence to he:", he, "  to she:", she, "  total:", he + she, "\n")
cat(sprintf("%.1f%%, Wilson 95%% CI [%.1f, %.1f], exact binomial p = %s\n",
            100 * he / (he + she), w3[1], w3[2], format(bt$p.value, digits = 4)))

sp <- d[d$dir != "", ]
cat("\nTable 3. Direction by occupation classification\n")
print(table(sp$cls, sp$dir))


# 4.5 Fleiss' kappa and cross-platform consensus ------------------------

kap <- function(w) {
  m  <- sapply(cats, function(k) rowSums(codes(w) == k))
  nr <- length(plats)
  Pi <- (rowSums(m^2) - nr) / (nr * (nr - 1))
  Pe <- sum((colSums(m) / (n * nr))^2)
  c(Pbar = mean(Pi), Pe = Pe, kappa = (mean(Pi) - Pe) / (1 - Pe))
}

cons <- function(w) {
  m <- codes(w)
  c(all_masculine = sum(apply(m, 1, function(r) all(r == "M"))),
    all_feminine  = sum(apply(m, 1, function(r) all(r == "F"))),
    any_feminine  = sum(apply(m, 1, function(r) any(r == "F"))),
    any_split     = sum(apply(m, 1, function(r) any(r == "S"))),
    unanimous     = sum(apply(m, 1, function(r) length(unique(r)) == 1)))
}

cat("\nFleiss' kappa, four platforms as raters\n")
print(as.data.frame(t(sapply(c("2023", "2026"), kap))), digits = 4)
cat("\nTable 4. Cross-platform agreement\n")
print(as.data.frame(t(sapply(c("2023", "2026"), cons))))


# 4.6 Association with the occupation classification --------------------
# Permutation rather than chi-square: the feminine-classified category
# holds only 10 occupations, so the asymptotic approximation is
# unreliable. Cramer's V is deterministic; the simulated p varies
# slightly between runs and between RNG implementations.

set.seed(20260828)
assoc <- list()
for (p in plats) for (w in c("2023", "2026")) {
  m  <- table(factor(d$cls, c("Feminin", "Maskulin", "Netral")),
              factor(d[[paste0(p, "_", w)]], cats))
  m  <- m[, colSums(m) > 0, drop = FALSE]
  x2 <- suppressWarnings(chisq.test(m, correct = FALSE)$statistic)
  assoc[[paste(p, w)]] <- data.frame(
    platform = p, phase = w,
    dim = paste(nrow(m), ncol(m), sep = "x"),
    chisq = as.numeric(x2),
    V = sqrt(x2 / (sum(m) * (min(dim(m)) - 1))),
    p = suppressWarnings(chisq.test(m, simulate.p.value = TRUE,
                                    B = 20000)$p.value))
}
cat("\nTable 5. Association with occupation classification\n")
print(do.call(rbind, assoc), digits = 4, row.names = FALSE)

cat("\n")
print(sessionInfo())
