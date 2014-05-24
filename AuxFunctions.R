# Getting and Cleaning Data
# Course Project Auxiliary Functions
# The following definitions must be run before running each script
# 
read.all <- function(func="table", type=".", list=FALSE, ...) {
    read.func <- paste("read.", func, sep="")    # identify function to use
    read.func <- get(read.func)                  # and save it in a var
    if (!missing(list)) {
        fl <- list                               # set up file list from param
        type <- ""                               # type not used if list provided
    } else {
        if (type == ".") {                       # read everything you find
            type <- ""                           # no type needed
        }
        fl <- dir(pattern=paste(".", type, sep=""))  # set up file list from dir()
    }
    dslist <- list()                             # empty list to hold results
    for (i in 1:length(fl)) {                       # read loop
        # fn <- strsplit(fl[i], c(".txt"))          # ??? no needed anymore
        cat(paste("read_all>>> Reading file...", fl[i], "\n"))  # it could take time...
        ds <- read.func(fl[i], ...)                 # read file
        dslist[[i]] <- ds                           # store results
    } 
    cat(paste("read_all>>>", i, " files read.\n"))  # inform number of files read
    dslist                                       # go home
}
# 
fac.as.numeric <- function(x) {    
    as.numeric(as.character(x))
}

read_seg <- function(filename, nrecs=1, limit=nrecs, 
                     widths=c(1), feat.names=FALSE, feat.select=FALSE) {
    if(missing(feat.names)) {    # No features names, job not possible
        print("Features vector not specified. Function terminated")
        return(NULL)
    }
    if(missing(feat.select)) {  # keep all features if not fsv specified
        print("Warning. Feature selection vector not specified.")
        feat.select <- rep(TRUE, length(features))
    }
    lobj <- list()                                       # result list
    recs.read <- 0                                       # records counter
    seg <- 0                                             # segment index
    while(recs.read < limit) {
        if (limit - recs.read < nrecs) {            # do not read beyond limits
            nrecs <- limit - recs.read
        }
        seg <- seg + 1                                    # point to next segment
        cat("read_seg> Reading segment number: ", seg, "\n")         # keep me updated
        obj <- read.fwf(filename, widths, n=nrecs, skip=recs.read) 
        colnames(obj) <- feat.names                       # apply features labels
        objsel <- obj[,feat.select]                        # select features from df
        lobj[[seg]] <- objsel                             # store obj in list         
        rm(obj)                                           # remove object
        recs.read <- recs.read + nrecs                    # increment counter
        cat("read_seg> Segment ", seg, "done. Recs read so far: ", recs.read, "\n")
    }
    cat("read_seg> Job done. ", seg, " segments with ", recs.read, " records read.", "\n")
    return(lobj)
}

join.list <- function(list, fun=FALSE) {
    # this function joins all objects in a list by row.
    # applies function fun first, if required
    if (missing(fun)) {
        fun <- (function(x) x)
    }
    if (length(list) < 2) {
        cat("Invalid list. \n")
        return(NULL)
    } else {
        dest <- fun(list[[1]])
    }        
    for (i in 2:length(list)) {
        dest <- rbind(dest, fun(list[[i]]))
    }
    return(dest)
}
