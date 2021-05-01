library(rgdal)
library(maptools)
library(sp)
library(spdep)
library(gridExtra)

plot(GA_CO)

##

rm(list = ls()

##

# Import state boundaries and insurance data:

all <- read.csv("all.csv")  # insurance data
# View data.frame
View(all)
names(all)

# [1] "X"               "OBJECTID"        "County"          "County_Full"    
# [5] "totpop10"        "Reg_Comm"        "Acres"           "Sq_Miles"       
# [9] "Label"           "State"           "totpop19"        "accident_count" 
# [13] "allstate"        "statefarm"       "country"         "farm_bureau"    
# [17] "nationwide"      "alfa"            "american_family" "aflac"          
#[21] "acceptance"      "cotton_states"   "all_companies"  

all["insurance_10000"] <- all$all_companies / all$totpop19
all["accidents_10000"] <- all$accident_count/ all$totpop19

###

GA_CO <- readOGR(dsn=getwd(), layer="47f01f96-97ff-4424-87e1-b4dc85d67d92202043-1-1mic60v.toaw")

# plot SpatialPolygonsDataFrame
plot(GA_CO)
names(GA_CO)

# [1] "OBJECTID"   "STATEFP10"  "COUNTYFP10" "GEOID10"    "NAME10"    
# [6] "NAMELSAD10" "totpop10"   "WFD"        "RDC_AAA"    "MNGWPD"    
# [11] "MPO"        "MSA"        "F1HR_NA"    "F8HR_NA"    "Reg_Comm"  
# [16] "Acres"      "Sq_Miles"   "Label"      "GlobalID"   "last_edite"

#####

# Spatial join
all_CO <- merge(ga_co, all, by.x="NAME10", by.y="County")
spplot(all_CO, "insurance_10000")
spplot(all_CO, "all_companies")

queen_self <- include.self(poly2nb(all_CO))
queen_B <- nb2listw(queen_self, style="B")

Gi_star_Conf <- localG(all_CO$all_companies, queen_B)
Gi_star_Prev <- localG(all_CO$insurance_10000, queen_B)

all_CO$Conf_Z <- Gi_star_Conf[1:159]
all_CO$Prev_Z <- Gi_star_Prev[1:159]

# START
png("Companies_hot_spot.png", height = 5.5, width = 5.5, units = "in", res = 300)
grid.arrange(spplot(all_CO, "Conf_Z", main="Hot-Spot Z-scores: company counts"),
		 spplot(all_CO, "Prev_Z", main="Hot-Spot Z-scores: rates of companies"))
dev.off()
# END

#########

#Determine P_values from Standard Normal Distribution
P_left_conf <- pnorm(all_CO$Conf_Z)
P_right_conf <- pnorm(all_CO$Conf_Z , lower.tail=FALSE)

#Are they significant: TRUE or FALSE? Without multiple test correction
Sig_right_conf <- P_right_conf <= 0.05
Sig_left_conf <- P_left_conf <= 0.05

Sig_left_conf[Sig_left_conf == 1] <- -1
Two_tailed_genius_conf <- Sig_right_conf + Sig_left_conf
print(Two_tailed_genius_conf)
#[1] -1 -1  0  0  0  0 -1 -1  0  0  0  0  0  0  0  0  0  0  0  0  1  0  0  0  0

Two_tailed_genius_conf[Two_tailed_genius_conf == -1] <- "Sig neg"
Two_tailed_genius_conf[Two_tailed_genius_conf == 0] <- "Not sig"
Two_tailed_genius_conf[Two_tailed_genius_conf == 1] <- "Sig"
Two_tailed_genius_conf <- as.factor(Two_tailed_genius_conf)

all_CO$Conf_sig <- Two_tailed_genius_conf

##


##

#Determine P_values from Standard Normal Distribution
P_left_prev <- pnorm(all_CO$Prev_Z)
P_right_prev <- pnorm(all_CO$Prev_Z , lower.tail=FALSE)

#Are they significant: TRUE or FALSE? Without multiple test correction
Sig_right_prev <- P_right_prev <= 0.05
Sig_left_prev <- P_left_prev <= 0.05

Sig_left_prev[Sig_left_prev == 1] <- -1
Two_tailed_genius_prev <- Sig_right_prev + Sig_left_prev
print(Two_tailed_genius_prev)
#[1] -1 -1  0  0  0  0 -1 -1  0  0  0  0  0  0  0  0  0  0  0  0  1  0  0  0  0

Two_tailed_genius_prev[Two_tailed_genius_prev == -1] <- "Sig neg"
Two_tailed_genius_prev[Two_tailed_genius_prev == 0] <- "Not sig"
Two_tailed_genius_prev[Two_tailed_genius_prev == 1] <- "Sig"
Two_tailed_genius_prev <- as.factor(Two_tailed_genius_prev)

##


all_CO$Prev_sig <- Two_tailed_genius_prev 

####


# START
png("Companies_hot_spot_sign.png", height = 5.5, width = 5.5, units = "in", res = 300)
grid.arrange(spplot(all_CO, "Conf_sig", main = "Signficant hot/cold spots: company counts"),
		 spplot(all_CO, "Prev_sig", main = "Signficant hot/cold spots: rate of companies"))

dev.off()
# END

#########################

## Accidents

Gi_star_Conf <- localG(all_CO$accident_count, queen_B)
Gi_star_Prev <- localG(all_CO$accidents_10000, queen_B)

all_CO$Conf_Z <- Gi_star_Conf[1:159]
all_CO$Prev_Z <- Gi_star_Prev[1:159]

# START
png("Accidents_hot_spot.png", height = 5.5, width = 5.5, units = "in", res = 300)
grid.arrange(spplot(all_CO, "Conf_Z", main="Hot-Spot Z-scores: accident_counts"),
		 spplot(all_CO, "Prev_Z", main="Hot-Spot Z-scores: accident_rates"))
dev.off()
# END

#########

#Determine P_values from Standard Normal Distribution
P_left_conf <- pnorm(all_CO$Conf_Z)
P_right_conf <- pnorm(all_CO$Conf_Z , lower.tail=FALSE)

#Are they significant: TRUE or FALSE? Without multiple test correction
Sig_right_conf <- P_right_conf <= 0.05
Sig_left_conf <- P_left_conf <= 0.05

Sig_left_conf[Sig_left_conf == 1] <- -1
Two_tailed_genius_conf <- Sig_right_conf + Sig_left_conf
print(Two_tailed_genius_conf)
#[1] -1 -1  0  0  0  0 -1 -1  0  0  0  0  0  0  0  0  0  0  0  0  1  0  0  0  0

Two_tailed_genius_conf[Two_tailed_genius_conf == -1] <- "Sig neg"
Two_tailed_genius_conf[Two_tailed_genius_conf == 0] <- "Not sig"
Two_tailed_genius_conf[Two_tailed_genius_conf == 1] <- "Sig"
Two_tailed_genius_conf <- as.factor(Two_tailed_genius_conf)

all_CO$Conf_sig <- Two_tailed_genius_conf

##


##

#Determine P_values from Standard Normal Distribution
P_left_prev <- pnorm(all_CO$Prev_Z)
P_right_prev <- pnorm(all_CO$Prev_Z , lower.tail=FALSE)

#Are they significant: TRUE or FALSE? Without multiple test correction
Sig_right_prev <- P_right_prev <= 0.05
Sig_left_prev <- P_left_prev <= 0.05

Sig_left_prev[Sig_left_prev == 1] <- -1
Two_tailed_genius_prev <- Sig_right_prev + Sig_left_prev
print(Two_tailed_genius_prev)
#[1] -1 -1  0  0  0  0 -1 -1  0  0  0  0  0  0  0  0  0  0  0  0  1  0  0  0  0

Two_tailed_genius_prev[Two_tailed_genius_prev == -1] <- "Sig neg"
Two_tailed_genius_prev[Two_tailed_genius_prev == 0] <- "Not sig"
Two_tailed_genius_prev[Two_tailed_genius_prev == 1] <- "Sig"
Two_tailed_genius_prev <- as.factor(Two_tailed_genius_prev)

##


all_CO$Prev_sig <- Two_tailed_genius_prev 

####


# START
png("Accidents_hot_spot_sign.png", height = 5.5, width = 5.5, units = "in", res = 300)
grid.arrange(spplot(all_CO, "Conf_sig", main = "Signficant hot/cold spots: accident counts"),
		 spplot(all_CO, "Prev_sig", main = "Signficant hot/cold spots: accident rates"))

dev.off()
# END





