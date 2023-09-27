# Plot unproductive land in Sumatra. 

# IMPORT PACKAGES
library(sf)
library(ggplot2)
library(reshape2)

# Functions 
Load.shapefiles<-function(){
  options(warn = -1)
  # LOAD DATA 
  Data_crop<-st_crop(subset(Data_og,KODE_PROV>30), c(xmin= -98, ymin = -7, xmax = 110, ymax = 6)) 
  Data_crop_simp<<-st_transform(st_simplify(st_transform(st_set_crs(Data_crop, 4326),crs=3857),preserveTopology = TRUE, dTolerance = 100),crs=4326)
  
  removed<-st_read('Shared_Data/shapefiles/missing_data.shp',crs=4326, quiet=TRUE)
  removed_simp<<-st_transform(st_simplify(st_transform(removed,crs=3857),
                                          preserveTopology = TRUE, dTolerance = 1000),crs=4326) 
  removed_simp<-st_crop(st_set_crs(removed,NA), c(xmin= -98, ymin = -7, xmax = 110, ymax = 6)) 
  removed_simp_SM<<-st_transform(st_simplify(st_transform(st_set_crs(removed_simp,4326),crs=3857),
                                             preserveTopology = TRUE, dTolerance = 1000),crs=4326)
  # Load & simplify Malasia map
  Data_Malasia<-st_read('Shared_Data/shapefiles/Malasia_geom/bd012vf3991.shp',quiet=TRUE)
  Data_Malasia_crop<-st_crop(Data_Malasia, c(xmin= 98, ymin = -7, xmax = 110, ymax = 6.1))
  Data_Malasia_simp<<-st_transform(st_simplify(st_transform(Data_Malasia_crop,crs=3857),
                                               preserveTopology = TRUE, dTolerance = 1000),crs=4326) #merc: 3857
  # Load, cut & simplify Thailand map
  Data_Thai<-st_read('Shared_Data/shapefiles/Thai_geom/tha_admbnda_adm0_rtsd_20220121.shp',crs=4326 , quiet=TRUE)
  Data_Thai_crop<-st_crop(Data_Thai, c(xmin= 98, ymin = -7, xmax = 120, ymax =6.05)) 
  Data_Thai_simp<<-st_transform(st_simplify(st_transform(Data_Thai_crop,crs=3857),
                                            preserveTopology = TRUE, dTolerance = 1000),crs=4326) # merc: 3857
  # Load, cut & simplify Thailand map
  Data_Singap<-st_read('Shared_Data/shapefiles/Singapore_geom/sgpBound.shp',crs=4326 , quiet=TRUE)
  Data_Sing_simp<<-st_transform(st_simplify(st_transform(Data_Singap,crs=3857),
                                            preserveTopology = TRUE, dTolerance = 1000),crs=4326) #merc: 3857
  options(warn = 0)
  
}

Plot.unprod.both<-function(limits_map,limits_mod){
  
  sum_total<-simp['Percentage_k'][[1]] + simp['Percentage_l'][[1]]
  
  bool_small_more<- 1*(simp$Percentage_k < simp$Percentage_l)
  bool_ind_more<- 2*(simp$Percentage_k > simp$Percentage_l)
  bool_same<- 3*((simp$Percentage_k == simp$Percentage_l) & (sum_total>0))
  bool_no_unpr<- 4*((sum_total==0))
  fill_class<-bool_small_more+bool_ind_more+bool_same+bool_no_unpr
  
  plot_un<-ggplot() +  geom_sf(data = simp,aes(geometry=geometry, fill=factor(fill_class)),color=NA)+
    geom_sf(data=data.frame(removed_simp_SM),aes(geometry=geometry),fill='gray86',color='NA') +
    geom_sf(data=data.frame(Data_crop_simp),aes(geometry=geometry),fill='gray86',color='NA') +
    geom_sf(data=data.frame(Data_Malasia_simp),aes(geometry=geometry),fill='gray86',color='NA') +
    geom_sf(data=data.frame(Data_Thai_simp),aes(geometry=geometry),fill='gray86',color='NA') +
    geom_sf(data=data.frame(Data_Sing_simp),aes(geometry=geometry),fill='gray86',color='NA') +
    scale_fill_manual(name='Main producer unproductive land',values=c("#196294","#EE6241",'#F7CE7E','white','gray86'),labels=c('Smallholder','Industrial','Both','No damaged land','Missing data'))+
    scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0)) +
    theme_void()+
    theme(text=element_text(size=14,  family="sans"),plot.title=element_blank(),
          legend.justification = c(0, 0), legend.position = c(0, 0), legend.title.align = 0.5,
          legend.text.align = 0.5,legend.margin=margin(t=0.1,b=0.1, l=0.2,r=0.2, "cm"),
          plot.margin=unit(c(0,0.25,0,0.25), "cm"),  #(top,right,bottom,left)
          legend.background = element_rect(fill='white',color=NA),
          legend.key.width = unit(0.9, "cm"),
          panel.background = element_rect(fill='#93c8d0',color=NA)
    )
  return(plot_un)
}


# Define working directory
#setwd(dirname(rstudioapi::getSourceEditorContext()$path))

#Load data 
Data_og<-st_read('Shared_Data/shapefiles/Villages_indonesia.shp',quiet=TRUE)

region<-Data_og %>% subset (KODE_PROV<30)
simp = st_transform(st_simplify(st_transform(st_set_crs(region,4326),crs=3857),
                                  preserveTopology = TRUE, dTolerance = 1000),crs=4326) 

oil_raw<- read.csv('Shared_Data/oil_palm_filtered.csv')
oil_percent<- subset(oil_raw, select = c(ID, Percentage_k, Percentage_l,Area_k,Area_l))
simp <- merge(simp, oil_percent, by="ID")
simp=simp[c('KODE_PROV','Percentage_k','Percentage_l','Area_k','Area_l')]

change<- simp$Percentage_k+simp$Percentage_l
mod_area<-st_union(st_as_sf(simp[change,]))

#Estimate where unproductive land is majoritary.
tot_percent_L<-sum(simp$Percentage_l)/(sum(simp$Percentage_k)+sum(simp$Percentage_l))
tot_percent_k<-sum(simp$Percentage_k)/(sum(simp$Percentage_k)+sum(simp$Percentage_l))
area_oil<- subset(oil_raw, select = c(ID, Area_k, Area_l))
Data_area<- merge(Data_og, area_oil, by="ID")

tot_area_L<-sum(Data_area$Area_l[Data_area$KODE_PROV<30])/(sum(Data_area$Area_k[Data_area$KODE_PROV<30])+sum(Data_area$Area_l[Data_area$KODE_PROV<30]))
tot_area_k<-sum(Data_area$Area_k[Data_area$KODE_PROV<30])/(sum(Data_area$Area_k[Data_area$KODE_PROV<30])+sum(Data_area$Area_l[Data_area$KODE_PROV<30]))

# Plot villages with more area of each class. 
limits_mod<-c(0,50) 
limits_map<-c(0,max(simp$Percentage_l,simp$Percentage_k))
Load.shapefiles()
plot_both<-Plot.unprod.both(limits_map,limits_mod)
ggsave(paste0("Figure_4.pdf"),path='Plots_simulations/',plot=plot_both, width=9, height=7,dpi=400,device='pdf') 
