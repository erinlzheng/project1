library(rgdal)
library(spatstat)
library(maptools)

rm(list = ls())

# import state boundary shapefile
ga <- readOGR(dsn = getwd(), layer = "Georgia_State_Boundary")

plot(ga)
summary(ga)

# transform to UTMs
ga <- spTransform(ga, CRS("+proj=utm +zone=17 +datum=WGS84"))

# convert to object of type 'owin' for package::'spatstat'
ga_owin <- as.owin(ga)
ga_owin_erode <- erosion(ga_owin, r = 8000)

ga_box = boundingbox(ga_owin)

# create systematic grid of points spaced by 25000 m
ga_syst = rsyst(ga_owin_erode, dx = 25000)
Window(ga_syst) <- ga_box


ga_syst_discs <- discs(ga_syst, 50000)

par(mar = c(1, 1, 2.2, 1))  

plot(ga_owin, 
     lty = 1, 
     cols = "white", 
     border = "black", 
     box = FALSE, 
     main = "")

plot(ga_owin_erode, lty = 3, border = "gray50", add = TRUE)
plot(ga_syst, pch = 16, cols = "red3", add = TRUE)
plot(ga_syst_discs, border = "purple", add = TRUE)

lpos = legend("topright",
	 legend = c("Georgia border",
                  "Georgia border eroded",
                  "Union of circular quadrats"),
       cex = 0.9,
       lty = c(1, 2, 1),
       col = c("black", "gray50", "red3"))



# convert to 'SpatialPoints' object for package::'sp'
ga_syst_SP <- as(ga_syst, "SpatialPoints") 
summary(ga_syst_SP)

# need to set projection again 
proj4string(ga_syst_SP) <- CRS("+proj=utm +zone=17 +ellps=WGS84")

# transform back to lat/long
ga_syst_SP_latlon <- spTransform(ga_syst_SP, CRS("+proj=longlat +datum=WGS84"))
summary(ga_syst_SP_latlon)

ga_grid_df <- as.data.frame(ga_syst_SP_latlon)
View(ga_grid_df)

ga_grid_df <- ga_grid_df[, c(2,1)]

colnames(ga_grid_df) <- c("latitude", "longitude") 
write.csv(ga_grid_df, "ga_grid_df.csv")