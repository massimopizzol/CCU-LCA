library('ggplot2')
library('reshape2')
library('Hmisc')

# Monte Carlo plot
mc = read.csv('MCsimulation1000iter20190416_nt.csv', sep = ';')
#mc <- mc[,-1] # remove pandas index...
mc <- mc[,sort(names(mc))]
head(mc)
names(mc)
dim(mc)

names(mc) <- c("CH[4]", "CO[DRM]", "CO[RWGS]", 
               "DMC[elec]", "DMC",
               "DME","DMM","EtOH[elec]",
               "FA[elec]","FA[hydro]","FT",
               "MeOH","Polyols", 'X')
summary(mc)

# Remove DMC(elec) and FD as out of scale

mc <- mc[,c("CH[4]", "CO[DRM]", "CO[RWGS]", "DMC",
            "DME","DMM","EtOH[elec]",
            "FA[elec]","FA[hydro]",
            "MeOH","Polyols", 'X')]

names(mc)
dim(mc)
head(mc)

mc_long <- melt(mc, id = c('X'))
mc_long <- mc_long[,-1]
mc_long$variable <- as.character(mc_long$variable)
mc_long <- mc_long[order(mc_long$variable),]
mc_long$variable <- factor(mc_long$variable)
head(mc_long)
tail(mc_long)


mc_long$variable <- factor(mc_long$variable, levels = c("Polyols", "FA[hydro]", 
                                                        "DMC","MeOH","CO[RWGS]", "CO[DRM]", "DME",
                                                        "CH[4]", "EtOH[elec]","DMM", "FA[elec]"))


gmc <- ggplot(mc_long, aes(x = variable, y = value)) + 
  #geom_point()+
  geom_jitter(color = "red", width = 0.1, alpha = 0.15)+
  geom_boxplot(alpha = 0.01, outlier.shape = NA)+
  #stat_summary(fun.data = mean_sdl, geom = "errorbar", color = "darkblue")+
  stat_summary(fun.y=median, geom="point", size = 1)+
  #stat_summary(fun.y=median, geom="text", aes(label = round(..y.., 2)), vjust = -1, size = 3) +
  #stat_summary(fun.y=median, geom="point", shape = 6)+
  theme_minimal()+
  theme(text = element_text(size = 10),
        #axis.text.x=element_text(angle = 90, vjust = 0.5),
        #axis.text.x=element_blank(),
        legend.position = "none",
        panel.grid = element_blank(),
        panel.background = element_rect(fill = "lightgrey"),
        plot.margin = margin(0.5,0.5,0.5,0.5, "cm")
  )



gmc  + ylab("") +  xlab("") + theme(
  plot.title = element_text(hjust = 0.5))+
  ggtitle(expression(paste("kg CO"[2], "-eq / kg captured CO"[2], " (near term scenario)")))+
  scale_x_discrete(labels = parse(text = levels(mc_long$variable)))






# Now same for long term
# Monte Carlo plot
mc = read.csv('MCsimulation1000iter20190416_lt.csv', sep = ';')
#mc <- mc[,-1] # remove pandas index...
mc <- mc[,sort(names(mc))]
head(mc)
names(mc)
dim(mc)

names(mc) <- c("CH[4]", "CO[DRM]", "CO[RWGS]", 
               "DMC[elec]", "DMC",
               "DME","DMM","EtOH[elec]",
               "FA[elec]","FA[hydro]","FT",
               "MeOH","Polyols", 'X')
summary(mc)

# Remove DMC(elec) and FD as out of scale

mc <- mc[,c("CH[4]", "CO[DRM]", "CO[RWGS]", "DMC",
            "DME","DMM","EtOH[elec]",
            "FA[elec]","FA[hydro]",
            "MeOH","Polyols", 'X')]

names(mc)
dim(mc)
head(mc)

mc_long <- melt(mc, id = c('X'))
mc_long <- mc_long[,-1]
mc_long$variable <- as.character(mc_long$variable)
mc_long <- mc_long[order(mc_long$variable),]
mc_long$variable <- factor(mc_long$variable)
head(mc_long)
tail(mc_long)


mc_long$variable <- factor(mc_long$variable, levels = c("Polyols", "FA[hydro]", 
                                                        "DMC","MeOH","CO[RWGS]", "CO[DRM]", "DME",
                                                        "CH[4]", "EtOH[elec]","DMM", "FA[elec]"))


gmc <- ggplot(mc_long, aes(x = variable, y = value)) + 
  #geom_point()+
  geom_jitter(color = "red", width = 0.1, alpha = 0.15)+
  geom_boxplot(alpha = 0.01, outlier.shape = NA)+
  #stat_summary(fun.data = mean_sdl, geom = "errorbar", color = "darkblue")+
  stat_summary(fun.y=median, geom="point", size = 1)+
  #stat_summary(fun.y=median, geom="text", aes(label = round(..y.., 2)), vjust = -1, size = 3) +
  #stat_summary(fun.y=median, geom="point", shape = 6)+
  theme_minimal()+
  theme(text = element_text(size = 10),
        #axis.text.x=element_text(angle = 90, vjust = 0.5),
        #axis.text.x=element_blank(),
        legend.position = "none",
        panel.grid = element_blank(),
        panel.background = element_rect(fill = "lightgrey"),
        plot.margin = margin(0.5,0.5,0.5,0.5, "cm")
  )



gmc  + ylab("") +  xlab("") + theme(
  plot.title = element_text(hjust = 0.5))+
  ggtitle(expression(paste("kg CO"[2], "-eq / kg captured CO"[2], " (long term scenario)")))+
  scale_x_discrete(labels = parse(text = levels(mc_long$variable)))
