# Script to plot spatial distribution of species from csv map file in input of OSMOSE med
# Author : Fabien Moullec
# Date : 26/06/2017

rm(list = ls())

# Load libraries
library(rgdal)
library(raster)
library(rgeos)
library(fields)
library(matlab)
library(oceanmap)

# Chargement du raster de la MED
rast.med <- readGDAL("C:/Users/Fabien/Documents/Scripts R/création des inputs osmose/grille osmose/rastmed.tif")
rast.med <- raster(rast.med)

# chargement du dossier "map" de la config osmose
setwd("C:/Users/Fabien/Documents/OSMOSE-MED/Calibration/OSMOSE_MED_DATARMOR_used/fmoullec/EA_MED/LIB/osmose/maps")

# Récupération des coordonnées long-lat du raster de la Med
grid <- coordinates(rast.med)
grid[,2]=rev(grid[,2])

# Loop over files to add the new mask on species distribution maps
mois <- "annuel"
sp <- "map70-Scomberscombrus.csv"
mp <- paste0("C:/Users/Fabien/Documents/OSMOSE-MED/Calibration/OSMOSE_MED_DATARMOR_used/fmoullec/EA_MED/LIB/osmose/maps/",sp)
matr <- read.csv(mp, sep = ",", header = F)
mat <- as.matrix(matr)
mat <- fliplr(t(mat))
vec <- as.vector(mat)
tab <- cbind(grid,vec)
rmed <- rasterFromXYZ(tab, res = 10000, crs = CRS("+init=epsg:3035"))

# Change value
values(rmed)[(values(rmed)==-99)] <- NA

# Change projection
proje <- "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs"
# Il faut modifier la méthode d'interpolation, ngb si data binaire, binomial si data continues
r.proj <- projectRaster(rmed, crs = proje, method = "ngb")

# Plot
dat <- raster :: crop (r.proj , extent (c(-6,37,30,46))) 
v(dat, main=mois,pal="haxbyrev", cbpos="r", cb.xlab="Probability of presence")

