# Statistical analysis of MC simulation results
# Massimo Pizzol, Feb 2019

library("reshape2")
library('broom')

getwd()

# Near term first
# Import & format data
mc = read.csv('MCsimulation1000iter20190416_nt.csv', sep = ';')
mc <- mc[,-1] # remove pandas index...
mc <- mc[,sort(names(mc))]
head(mc)
names(mc)
summary(mc)

names(mc) <- c("CH4", "CO(DRM)", "CO(rWGS)", 
  "DMC(elec)", "DMC(eth)",
  "DME(SG)","DMM","EtOH(elec)",
  "FA(elec)","FA(hydro)","FT",
  "MeOH","PEP")

# Export basic stats for reporting
stats_base <- t(sapply(mc,summary))
stats_sd <- sapply(mc,sd)
stats_nice <- cbind(stats_base, stats_sd)
write.table(stats_nice, "CCU-MC-Stats_nt.txt")


# Plot stripcharts
stripchart(mc[,c(1,2,3,5,6,7,8,9,10,11,12,13)], pch = 16, 
           method = 'jitter', jitter = 0.2, col = 'red', 
           main = 'Carbon Footprint (st) - results of MC simulation (kg CO2-eq)', las = 2, vertical = TRUE)

# Perform pairwise tests and export result
d <- mc[,1:13]  # reshape data in long format to perform pairwise tests
d <- t(d)
d <- cbind(rownames(d), data.frame(d, row.names=NULL))
colnames(d)[1] <- 'route'
d <- melt(d, id = 'route')

res <- pairwise.wilcox.test(d$value, d$route, p.adj = "bonf")  
tidy(res)
write.table(tidy(res), "CCU-MC_wil_nt.txt")



# Calculate percentages of differneces between routes, examples
A <- mc$CH4
B <- mc$"CO(DRM)"
par(mfrow=c(1,1))
hist(A-B, breaks = 100) # as Simapro does
sum((A-B) > 0) / 1000 *100 # perc positive difference (B better than A)
sum((A-B) < 0) / 1000 *100 # perc negative difference (A better than B)
sum((A-B) == 0) / 1000 *100 # perc positive difference (A equal to B)


# Do this for all route pairs
diff_names <- list() 
diff_values <- list()
diff_perc <- list()
  
for (i in 1:dim(mc)[2]){
  for (j in 1:dim(mc)[2]){
    
    names <- c(names(mc)[i], names(mc)[j])
    diff = mc[,i] - mc[,j]
    values <- tidy(summary(diff))
    perpos <- sum(diff > 0) / 1000 * 100 
    perneg <- sum(diff < 0) / 1000 * 100 
    perequ <- sum(diff == 0) / 1000 * 100
    perscal <- round(median(mc[,i]) / median(mc[,j]) * 100, 2) # impact of i compared to j
    percs <- c(perpos, perneg, perequ, perscal)
      
    index <- (i-1)*dim(mc)[2]+j
    diff_names[[index]] <- names
    diff_values[[index]] <- values
    diff_perc[[index]] <- percs
  }
}
  
doubles <- c() # this is an index to locate duplicate couples (e.g.Route01-Route02, Route02-Route01, I keep only the first)
for (i in 1:dim(mc)[2]){  
  for (j in 1:i){
    doubles <- append(doubles,dim(mc)[2]*i-dim(mc)[2]+j)  # this indexing was clever :)
      }
    }
  
diff_res <- cbind(do.call(rbind, diff_names), do.call(rbind, diff_values), do.call(rbind, diff_perc))
names(diff_res)[1:2] <- c('BaseRoute','AltRoute')
names(diff_res)[9:12] <- c('Percpos', 'Percneg', 'Percequ', 'Percscal')
diff_res <- diff_res[-doubles,]  # removing duplicates
tail(diff_res, 10)  #just a check
write.table(diff_res, "CCU-MC_diff_nt.txt")


#####################################################


## Now the same but with the long term scenario
# Import and format data
mc = read.csv('MCsimulation1000iter20190416_lt.csv', sep = ';')
mc <- mc[,-1] # remove pandas index...
mc <- mc[,sort(names(mc))]
head(mc)
names(mc)
summary(mc)

names(mc) <- c("CH4", "CO(DRM)", "CO(rWGS)", 
               "DMC(elec)", "DMC(eth)",
               "DME(SG)","DMM","EtOH(elec)",
               "FA(elec)","FA(hydro)","FT",
               "MeOH","PEP")

# Export basic stats for reporting
stats_base <- t(sapply(mc,summary))
stats_sd <- sapply(mc,sd)
stats_nice <- cbind(stats_base, stats_sd)
write.table(stats_nice, "CCU-MC_stats_lt.txt")

# Plot stripcharts
stripchart(mc[,c(1,2,3,5,6,7,8,9,10,11,12,13)], pch = 16, 
           method = 'jitter', jitter = 0.2, col = 'red', 
           main = 'Carbon Footprint (lt) - results of MC simulation (kg CO2-eq)', las = 2, vertical = TRUE)

          # note how the uncertainties are higher for the lt scenario

# Pairwise tests
d <- mc[,1:13]  # reshape data in long format to perform pairwise tests
d <- t(d)
d <- cbind(rownames(d), data.frame(d, row.names=NULL))
colnames(d)[1] <- 'route'
d <- melt(d, id = 'route')

res <- pairwise.wilcox.test(d$value, d$route, p.adj = "bonf")  
tidy(res)
write.table(tidy(res), "CCU-MC_wil_lt.txt")


# Calculate percentages of differneces between routes, examples
A <- mc$CH4
B <- mc$"CO(DRM)"
par(mfrow=c(1,1))
hist(A-B, breaks = 100) # as Simapro does
sum((A-B) > 0) / 1000 *100 # perc positive difference (B better than A)
sum((A-B) < 0) / 1000 *100 # perc negative difference (A better than B)
sum((A-B) == 0) / 1000 *100 # perc positive difference (A equal to B)


# Do this for all route pairs
diff_names <- list() 
diff_values <- list()
diff_perc <- list()

for (i in 1:dim(mc)[2]){
  for (j in 1:dim(mc)[2]){
    
    names <- c(names(mc)[i], names(mc)[j])
    diff = mc[,i] - mc[,j]
    values <- tidy(summary(diff))
    perpos <- sum(diff > 0) / 1000 * 100 
    perneg <- sum(diff < 0) / 1000 * 100 
    perequ <- sum(diff == 0) / 1000 * 100
    perscal <- round(median(mc[,i]) / median(mc[,j]) * 100, 2) # impact of i compared to j
    percs <- c(perpos, perneg, perequ, perscal)
    
    index <- (i-1)*dim(mc)[2]+j
    diff_names[[index]] <- names
    diff_values[[index]] <- values
    diff_perc[[index]] <- percs
  }
}

doubles <- c() # this is an index to locate duplicate couples (e.g.Route01-Route02, Route02-Route01, I keep only the first)
for (i in 1:dim(mc)[2]){  
  for (j in 1:i){
    doubles <- append(doubles,dim(mc)[2]*i-dim(mc)[2]+j)  # this indexing was clever :)
  }
}

diff_res <- cbind(do.call(rbind, diff_names), do.call(rbind, diff_values), do.call(rbind, diff_perc))
names(diff_res)[1:2] <- c('BaseRoute','AltRoute')
names(diff_res)[9:12] <- c('Percpos', 'Percneg', 'Percequ', 'Percscal')
diff_res <- diff_res[-doubles,]  # removing duplicates
tail(diff_res, 10)  #just a check
write.table(diff_res, "CCU-MC_diff_lt.txt")
