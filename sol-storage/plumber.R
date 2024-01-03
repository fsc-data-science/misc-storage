#' x = lapply(list.files("sol-storage/solana-EOY-stats/", full.names = TRUE), read.csv)
#' saveRDS(x, "sol-storage/nine_files_in_list.rds")

x = readRDS("nine_files_in_list.rds")

library(plumber)
library(jsonlite)

#* @apiTitle Miscellaneous Data Storage
#* @apiDescription Put CSVs here so that they can be accessed via LiveQuery

#* Echo back the input
#* @param msg The message to echo
#* @get /echo
function(msg = "") {
    list(msg = paste0("The message is: '", msg, "'"))
}

#* Return 
#* @serializer json
#* @get /solsummary
function(number){
  number <- as.numeric(number)
  
  if(number < 1 | number > 9 ){
    stop("only numbers 1 through 9 acceptable")
  }
    return( toJSON(x[[number]], auto_unbox = TRUE) )
}

# Programmatically alter your API
#* @plumber
function(pr) {
    pr %>%
        # Overwrite the default serializer to return unboxed JSON
        pr_set_serializer(serializer_unboxed_json())
}
