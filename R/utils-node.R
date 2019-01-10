
check_node_installed <- function(){
  node_path <- Sys.which("node")
  if (node_path == ""){
    caller_nm <- deparse(sys.call(-1))
    stop(
      "Node is required for ", caller_nm,
      "\nPlease install node from https://nodejs.org/en/download/ ",
      "and ensure that node is on the PATH."
    )
  } else {
    return(TRUE)
  }

}
