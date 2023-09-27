# Supplementary Figure 1 

# Plot summary statistics for regional predictions 
library(sf)
library(ggplot2)
library(reshape2)
library(dplyr)

Plot.provinces<-function(){
  #load already created save_file before
  Data_og<-st_read('Shared_Data/shapefiles/Villages_indonesia.shp',quiet=TRUE)
  region<-Data_og %>% subset (KODE_PROV<30)%>%
    group_by(KODE_PROV) %>%
    summarise(geometry = sf::st_union(geometry)) %>%
    ungroup()
  region = st_transform(st_simplify(st_transform(st_set_crs(region,4326),crs=3857),
                           preserveTopology = TRUE, dTolerance = 1000),crs=4326) 
  # Simplify spat ressolution of missing data
  missing<-st_read('Shared_Data/shapefiles/missing_data.shp',crs=4326, quiet=TRUE)
  missing_simp<-st_transform(st_simplify(st_transform(missing,crs=3857),
                                         preserveTopology = TRUE, dTolerance = 1000),crs=4326) #merc: 3857
  missing_simp<-st_crop(st_set_crs(missing,NA), c(xmin= -98, ymin = -7, xmax = 110, ymax = 6))#8
  missing_simp_SM<-st_transform(st_simplify(st_transform(st_set_crs(missing_simp,4326),crs=3857),
                                            preserveTopology = TRUE, dTolerance = 1000),crs=4326) #merc: 3857
  #Load Data and crop borders
  Data_og<-st_read('Shared_Data/shapefiles/Villages_indonesia.shp',quiet=TRUE)
  Data_crop<-st_crop(subset(Data_og,KODE_PROV>30), c(xmin= -98, ymin = -7, xmax = 110, ymax = 6)) #min
  Data_crop_simp<-st_transform(st_simplify(st_transform(st_set_crs(Data_crop, 4326),crs=3857),preserveTopology = TRUE, dTolerance = 100),crs=4326)
  Data_og<-st_transform(st_simplify(st_transform(st_set_crs(Data_og, 4326),crs=3857),preserveTopology = TRUE, dTolerance = 100),crs=4326)
  #Load & simplify Malasia
  Data_Malasia<-st_read('Shared_Data/shapefiles/Malasia_geom/bd012vf3991.shp',quiet=TRUE)
  Data_Malasia_crop<-st_crop(Data_Malasia, c(xmin= 98, ymin = -7, xmax = 110, ymax = 6.1))#7
  Data_Malasia_simp<-st_transform(st_simplify(st_transform(Data_Malasia_crop,crs=3857),
                                              preserveTopology = TRUE, dTolerance = 1000),crs=4326) #merc: 3857
  Data_Thai<-st_read('Shared_Data/shapefiles/Thai_geom/tha_admbnda_adm0_rtsd_20220121.shp',crs=4326 , quiet=TRUE)
  Data_Thai_crop<-st_crop(Data_Thai, c(xmin= 98, ymin = -7, xmax = 120, ymax =6.05))#7
  Data_Thai_simp<-st_transform(st_simplify(st_transform(Data_Thai_crop,crs=3857),
                                           preserveTopology = TRUE, dTolerance = 1000),crs=4326) #merc: 3857
  Data_Singap<-st_read('Shared_Data/shapefiles/Singapore_geom/sgpBound.shp',crs=4326 , quiet=TRUE)
  Data_Sing_simp<-st_transform(st_simplify(st_transform(Data_Singap,crs=3857),
                                           preserveTopology = TRUE, dTolerance = 1000),crs=4326) #merc: 3857
  
  labels_changed<-region$KODE_PROV-10
  labels_changed[length(labels_changed)]<-10
  labels_names<- c('Aech','Sumatera Utara','Sumatera Barat','Riau','Jambi','Sumatera Selatan','Bengkulu',
                   'Lampung','Kepulauan Bangka Belitung','Kepulauan Riau.')

  plot_reg<-ggplot() + geom_sf(data=region, aes(geometry=geometry, fill=factor(labels_changed)),color=NA)+
    geom_sf(data=missing_simp_SM,aes(geometry=geometry),fill='gray86',color='NA') +
    geom_sf(data=data.frame(Data_crop_simp),aes(geometry=geometry),fill='gray86',color='NA') +
    geom_sf(data=data.frame(Data_Malasia_simp),aes(geometry=geometry),fill='gray86',color='NA') +
    geom_sf(data=data.frame(Data_Thai_simp),aes(geometry=geometry),fill='gray86',color='NA') +
    geom_sf(data=data.frame(Data_Sing_simp),aes(geometry=geometry),fill='gray86',color='NA') +
    scale_fill_brewer(palette='Paired', label=labels_names, name='Provinces')+
    scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0)) +   
    guides(fill=guide_legend(ncol=5,title.position = "top"), direction='horizontal',)+theme_minimal()+
    theme(
      panel.background = element_rect(fill='#93c8d0',color=NA),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      plot.margin=unit(c(0,0,2,0), "cm"),  #(top,right,bottom,left)
      legend.title =  element_text(hjust=0.5,face='bold',size=11),
      legend.position=c(0.5,-0.15), legend.justification=c(0.5,0), #0.5,-0.1
      legend.text =  element_text(size=10), #none
      legend.key.size = unit(1, "lines"),
      text = element_text(size = 20,family='sans'),
      axis.ticks = element_blank(),
      axis.text = element_blank(), 
      axis.title=element_blank()
    )
  #Save Plots 
  ggsave(paste0("Plot_SupFig1.pdf"),plot=plot_reg, path='Plots_simulations', width=7.5,height=6,dpi=400,device='pdf') 
}


# Define working directory
#setwd(dirname(rstudioapi::getSourceEditorContext()$path))

list_names<- c('Aech','Sumatera Utara','Sumatera Barat','Riau','Jambi','Sumatera Selatan','Bengkulu',
               'Lampung','Kepulauan Bangka Belitung','Kepulauan Riau.','Sumatra')

#Plot figure showing each prov. and their name
Plot.provinces()
