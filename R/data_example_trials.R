#' Data of baseline variables of seven randomised trials.
#'
#' A dataset containing baseline variables' data from seven randomised trials authored by Yuhji Saitoh and tested
#' by Carlisle JB and Loadsman JA (Anaesthesia 2017; Appendix S2 references number 1, 2, 4, 5, 7, 9 and 14). Results
#' obtained with this example can be compared with results in the Table 1 of Carlisle JB and Loadsman JA. Small
#' differences are to be expected, as p-values are obtained by means of simulations. For the sake of a faster testing,
#' the example sets the number of simulations at 100. However, we recommend at least 5000 simulations to be performed
#' in order to obtain more accurate results.
#'
#' @format A data frame with 93 rows and 9 variables:
#' \enumerate{
#'   \item trial - trial identification number;
#'   \item variable - variable identification number;
#'   \item group - group of participants identification number;
#'   \item participants - number of participants;
#'   \item mean - reported mean or proportion;
#'   \item sd - reported standard-deviation (for continuous variables only);
#'   \item decimals - number of decimal places to which the corresponding mean or proportion was reported;
#'   \item type - type of variable. 1 indicates a continuous variable; 2 indicates a categorical variable;
#'   \item name - name of the randomised trial (first author name and publication year) to which data concern.
#' }
#'
#' @docType data
#'
#' @usage data(example_trials)
#'
#' @section Source:
#' Data was retrieved from the following trials authored by Yuhji Saitoh:
#' \enumerate{
#'    \item Saitoh Y, Toyooka H, Amaha K. Recoveries of post-tetanic twitch and train-of-four responses after administration of vecuronium with different inhalation anaesthetics and neuroleptanaesthesia. British Journal of Anaesthesia 1993; 70 402-4.
#'    \item Saitoh Y, Toyooka H, Amaha K. Post-tetanic burst: a new monitoring method for intense neuromuscular block. British Journal of Anaesthesia 1995; 74: 293-5.
#'    \item Saitoh Y, Fujii Y, Toyooka H, Amaha K. Post-tetanic burst count: a stimulating pattern for profound neuromuscular blockade. Canadian Journal of Anesthesia 1995; 42: 1096-1100.
#'    \item Saitoh Y, Tanaka H, Toyooka H, Amaha K. Recovery of post-tetanic and train-of-four responses at the first dorsal interosseous an adductor pollicis muscles in patients receiving vecuronium. Canadian Journal of Anesthesia 1996; 43: 362-7.
#'    \item Saitoh Y, Nakazawa K, Makita K, Tanaka H, Toyooka H. Evaluation of residual neuromuscular blockade using modified double burst stimulation. Acta Anaesthesiologica Scandinavica 1997; 41: 741-5.
#'    \item Saitoh Y, Nakazawa K, Makita K, Tanaka H, Toyooka H. Visual evaluation of train-of-four and double burst stimulation, fade at various currents, using a rubber band. European Journal of Anaesthesiology 1997; 14: 327-32.
#'    \item Saitoh Y, Narumi Y, Fujii Y, Ueki M, Makita K. Electromyographic assessment of neuromuscular block at the gastrocnemius muscle. British Journal of Anaesthesia 1999; 82: 329-32. Retraction in: British Journal of Anaesthesia 2013; 110: 669.
#' }
#'
#'@examples
#'sim_distr(100,example_trials,TRUE)
#'
"example_trials"
