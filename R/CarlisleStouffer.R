#'@title Assessment of Data Trial Distributions According to the Carlisle-Stouffer Method
#'
#'@description Assessment of the distributions of baseline continuous and categorical variables in randomised trials, assuming normal distributions for the former and binomial distributions for the latter. The method used is based on the Carlisle-Stouffer method with Monte Carlo simulations. It calculates p-values for each trial baseline variable, as well as combined p-values for each trial - these p-values measure how compatible are distributions of trials baseline variables with random sampling. This package also allows for graphically plotting the cumulative frequencies of obtained p-values.
#'
#'@param m An integer specifying the number of Monte Carlo simulations to be run.
#'
#'@param dataframe A dataframe with 9 columns with order and content as specified in the "Details" section.
#'
#'@param plot_flag A logical indicating whether cumulative frequencies of p-values are to be plotted in a graph; if TRUE a plot is provided.
#'
#'@section Details:
#'The dataframe must necessarily have 9 columns with the following order and content:
#'\enumerate{
#'    \item Trial number: An integer that sequentially identifies the randomised trial from which data concern. Therefore, all rows with data from the first randomised trial should be identified with the number 1 in this first column, data from the second trial should be identified with number 2, etc.
#'    \item Variable number for each trial: An integer that sequentially identifies the different variables assessed within each trial. Therefore, for each trial, all rows with data from the first reported variable should be identified with the number 1, data from the second variable should be identified with number 2, etc.
#'    \item Group: An integer that sequentially identifies the different groups of participants for which each variable was assessed.
#'    \item Number of participants: An integer corresponding to the number of assessed individuals in each group.
#'    \item Reported mean value (continuous variables) or proportion (categorical variables): A number with the reported result (mean or proportion) obtained for the corresponding variable in each group. Proportions must NOT be presented as percentages.
#'    \item Reported standard-deviation: A number with the reported standard-deviation obtained for the corresponding variable in each group. This column only concerns continuous variables, and should be left blank for categorical variables.
#'    \item Number of decimal places: An integer that indicates the number of decimal places to which the corresponding mean or proportion was reported (e.g., 1 for "2.5").
#'    \item Variable type: 1 for continuous variables; 2 for categorical variables.
#'    \item Name: A character sequence (e.g., with author name and publication year) that names the randomised trial from which data concern.
#'    }
#'The example dataframe - example_trials - provides a model regarding the required organisation and content of the dataframe.
#'For the sake of a faster testing, the example sets the number of simulations at 100. However, we recommend at least 5000 simulations to be performed in order to obtain more accurate results.
#'
#'@return
#'\enumerate{
#'\item A dataframe with p-values for each variable in each assessed trial - each trial is displayed in a different row. For each trial, each variable ("V") is displayed in a different column; variables are listed in the same order they are presented in the original dataframe.
#'\item A dataframe with combined (overall) p-values for each assessed trial - each trial is displayed in a different row.
#'\item A graph plotting the cumulative frequency of obtained variable p-values (optional).
#'}
#'
#'@examples sim_distr(100,example_trials, TRUE)
#'
#'@section Source:
#'The code for computing p-values for continuous variables is an adaptation of the code provided in AppendixS1 of Carlisle JB and Loadsman JA, 2017, Anaesthesia.
#'
#'@section References:
#'\enumerate{
#'\item Carlisle JB, Loadsman JA. Evidence for non-random sampling in randomised, controlled trials by Yuhji Saitoh. Anaesthesia 2017;72:17-27
#'\item Carlisle JB, Dexter F, Pandit JJ, Shafer SL, Yentis SM. Calculating the probability of random sampling for continuous variables in submitted or published randomised controlled trials. Anaesthesia 2015;70:848-858
#'}
#'
#'@importFrom graphics abline par plot
#'@importFrom stats pnorm qnorm rbinom rnorm
#'@importFrom utils stack
#'
#'@export
sim_distr <- function(m, dataframe, plot_flag){

  # Name of trials ------------------------------------------------------------
  naming <- unique(dataframe[,9])
  dataframe <- dataframe[,1:8]
  # Number of trials ----------------------------------------------------------
  max_trial <- max(dataframe[,1])

  # Number of variables on each trial -----------------------------------------
  max_c1 <- NA
  for(c in 1:max_trial){
    c1 <- which(dataframe[,1]==c)
    max_measure <- max(dataframe[c1,2])
    max_c1[c] <- max_measure
  }

  # Definition of a matrix for computation of the p-values for each trial -----
  ptrialsdf <- matrix(data = NA, nrow = max_trial, ncol = max(dataframe[,2], na.rm = T))
  for(r in 1:max_trial){

    pvalue_mean <- NA
    length(pvalue_mean) <- max(dataframe[,2], na.rm = T)

    # Definition for each variable of the current trial... --------------------
    for(s in 1:max_c1[r]){
      var_row <- apply(dataframe, 1, function(row) any(row[1]==r & row[2]==s))
      # Number of rows of the current trial/variable combination --------------
      var_length <- length(which(var_row))
      # Lines of the current trial/variable combination -----------------------
      var_lines <- which(var_row)
      # Sequence from 1 to the number of rows ("var_sample") ------------------
      var_sample <- rep(1:var_length)
      # Sequence from 1 to the number of simulations --------------------------
      var_diffsample <- rep(1:m)
      # Sequence from 1 to the number of rows ("var_value") -------------------
      var_value <- rep(1:var_length)
      # Sequence from 1 to the number of rows ("var_participants") ------------
      var_participants <- rep(1:var_length)
      # sequence from 1 to the number of rows ("var_standard") ----------------
      var_standard <- rep(1:var_length)
      # sequence from 1 to the number of rows ("var_type") --------------------
      var_type <- rep(1:var_length)

      # Statistics from each row of the current trial/variable combination ----
      for(j in 1:var_length){

        #Sum ------------------------------------------------------------------
        var_value[j] <- dataframe[var_lines[j],4] * dataframe[var_lines[j],5]
        # Sample size ---------------------------------------------------------
        var_participants[j] <- dataframe[var_lines[j],4]
        # Sum of squares ------------------------------------------------------
        var_standard[j] <- dataframe[var_lines[j],4] * dataframe[var_lines[j],6]^2
        # Type of variable (continuous or categorical) ------------------------
        var_type[j] <- dataframe[var_lines[j],8]

      }

      # Overall statistics for all groups for whom each variable was assessed -
      # Overall mean --------------------------------------------------------
      mean_mean <- sum(var_value) / sum(var_participants)
      # Overall variance ----------------------------------------------------
      mean_variance <- sum(var_standard) / sum(var_participants)
      # Overall standard deviation ------------------------------------------
      mean_sd <- mean_variance^0.5
      # Mean number of participants among different groups ------------------
      mean_participants <- sum(var_participants) / var_length
      # Overall standard error of the mean ----------------------------------
      se_mean <- mean_sd / sqrt(mean_participants)

      # Sum of the squared differences between group means and the overall mean
      sum_sqdiff <- sum((dataframe[which(var_row),5] - mean_mean)^2)

      # Simulations of the distributions --------------------------------------
      mean_sim <- NA

      # Simulations for continuous variables ----------------------------------
      if (all(var_type==1)){

        # Simulations cycle ---------------------------------------------------
        for(z in 1:m){
          mean_sim <- rnorm(1, mean = mean_mean, sd = se_mean)
          for(i in 1:var_length){
            var_sample[i] <- round(sum(rnorm(dataframe[var_lines[i],4], mean = mean_sim, sd = mean_sd) / dataframe[var_lines[i],4]), dataframe[var_lines[i],7])
          }
          # Overall mean ------------------------------------------------------
          mean_sample <- sum(var_sample * var_participants) / sum(var_participants)
          # Squared differences between group means to the overall mean -------
          sqdiff_sample <- (var_sample - mean_sample)^2
          # Sum of the squared differences ------------------------------------
          var_diffsample[z] <- sum(sqdiff_sample)
        }

        # Simulations for categorical variables ---------------------------------
      } else {

        # Simulations cycle.
        for(z in 1:m){
          mean_sim <- rbinom(1, sum(var_participants), mean_mean) / sum(var_participants)
          for(i in 1:var_length){
            var_sample[i] <- round(sum(rbinom(dataframe[var_lines[i],4], 1, mean_sim) / dataframe[var_lines[i],4]), dataframe[var_lines[i],7])
          }
          # Overall "mean" ----------------------------------------------------
          mean_sample <- sum(var_sample * var_participants) / sum(var_participants)
          # Squared differences between group "means" to the overall "mean" ---
          sqdiff_sample <- (var_sample - mean_sample)^2
          # Sum of the squared differences ------------------------------------
          var_diffsample[z] <- sum(sqdiff_sample)
        }
      }

      # Obtention of p-values for each variable -------------------------------
      pvalue_1 <- sum(var_diffsample < sum_sqdiff) / m
      pvalue_2 <- sum(var_diffsample <= sum_sqdiff) / m
      pvalue_mean[s] <- (pvalue_1 + pvalue_2) / 2

    }
    ptrialsdf[r,] <- pvalue_mean
  }

  ptrialsdf <- as.data.frame(ptrialsdf)
  rownames(ptrialsdf) <- c(naming)

  # Computation of composed p-value for each trial ----------------------------
  comp_p <- apply(ptrialsdf, 1, function(x) 1 - pnorm(sum(qnorm(1-x, 0, 1), na.rm = TRUE) / (sum(!is.na(x)))^0.5, 0, 1))
  comp_p <- matrix(data = comp_p, nrow = max_trial, ncol = 1)
  comp_p <- as.data.frame(comp_p)
  rownames(comp_p) <- c(naming)
  colnames(comp_p) <- c("p-value")

  # Computation of the cumulative frequencies ---------------------------------
  sdf <- stack(ptrialsdf)
  sdf <- sort(sdf$values, decreasing=FALSE)
  sdf2 <- unique(sdf)
  sdf1 <- table(sdf)
  sdf1 <- as.data.frame(sdf1)
  sdf1 <- transform(sdf1, cumFreq = cumsum(Freq), relative = cumsum(Freq) / max(cumsum(Freq)))

  # Plotting cumulative frequencies of p-values -------------------------------
  if (plot_flag == TRUE){
    par(pty = "s")
    plot(sdf2, sdf1$relative, xlab = "P value", ylab = "Cumulative frequency", xlim = c(0,1), ylim = c(0,1))
    abline(0,1)
  }

  # Print p-values to the commandline -----------------------------------------
  cat (" \n")
  cat ("P-values for each variable ('V') in each assessed trial\n")
  print(ptrialsdf)
  cat (" \n")
  cat ("Combined (overall) p-values for each assessed trial\n")
  print(comp_p)

} # end of function
if(getRversion() >= "2.15.1") utils::globalVariables(c("Freq"))
