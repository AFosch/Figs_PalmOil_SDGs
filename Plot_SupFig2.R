# SAVE MAPS FOR ALL SCENARIOS

# IMPORT PACKAGES
library(tidyverse)
library(colorspace)
library(scales)
library(gtable)
library(sf)
library(ggplot2)
library(reshape2)

# Plot funcitons
Relabel<-function(val_lims,data,limits_mod) {
  # Relabel extreme values to >than max or < than min
  lims<-c(1,length(val_lims))
  
  lab_mod<-c(as.character(val_lims[1]),as.character(val_lims[length(val_lims)]))
  # Relabel extreme values to >than max or < than min
  if((limits_map[1] != limits_mod[1])&(min(data) < limits_mod[1])){
    lab_mod[1]<-paste0('<',as.character(limits_mod[1]))
  }
  if((limits_map[2] != limits_mod[2]) & (max(data) > limits_mod[2])){
    lab_mod[2]<-paste0('>',as.character(limits_mod[2]))
  }
  # Change vector of lables 
  changed_lab<- replace(val_lims,lims,lab_mod)
  return (changed_lab)
}

Align.legend <- function(p, hjust = 0.5){
  # Extract grob legend
  g <- ggplotGrob(p)
  grobs <- g$grobs
  legend_index <- which(sapply(grobs, function(x) x$name) == "guide-box")
  legend <- grobs[[legend_index]]
  # Extract grob guides table
  guides_index <- which(sapply(legend$grobs, function(x) x$name) == "layout")
  guides <- legend$grobs[[guides_index]]
  
  # Add extra column for spacing:
  # guides$width[5] is the extra spacing from the end of the legend text to the end of the 
  #legend title. If we instead distribute it 50:50 on both sides, we get a centered legend.
  
  guides2<-guides
  guides2 <- gtable_add_cols(guides, 0.5*guides2$width[3], 1)
  guides2$widths[4] <- guides$widths[3]*0.5
  title_index <- guides2$layout$name == "title"
  guides2$layout$l[title_index] <- 2
  guides2$layout$l[guides2$layout$name == "label"] <- 3
  guides2$layout$r[guides2$layout$name == "label"] <- 3
  # Reconstruct legend and write back
  legend$grobs[[guides_index]] <- guides2
  g$grobs[[legend_index]] <- legend
  
  return (g)
}

Load.shapefiles<-function(){
  # LOAD DATA 
  options(warn = -1)
  Data_og<-st_read('Shared_Data/shapefiles/Villages_indonesia.shp',quiet=TRUE)
  
  rownames(Data_og)<-Data_og$ID
  oil_raw<- read.csv('Shared_Data/oil_palm_filtered.csv')
  oil_percent<- subset(oil_raw, select = c(ID, Percentage_k, Percentage_l))
  Data_og <<- merge(Data_og, oil_percent, by="ID")
  Data_crop<-st_crop(subset(Data_og,KODE_PROV>30), c(xmin= -98, ymin = -7, xmax = 110, ymax = 6)) #min
  Data_crop_simp<<-st_transform(st_simplify(st_transform(st_set_crs(Data_crop, 4326),crs=3857),preserveTopology = TRUE, dTolerance = 100),crs=4326)
  
  missing<-st_read('Shared_Data/shapefiles/missing_data.shp',crs=4326, quiet=TRUE)
  missing_simp<<-st_transform(st_simplify(st_transform(missing,crs=3857),
                                          preserveTopology = TRUE, dTolerance = 1000),crs=4326) #merc: 3857
  missing_simp<-st_crop(st_set_crs(missing,NA), c(xmin= -98, ymin = -7, xmax = 110, ymax = 6))#8
  missing_simp_SM<<-st_transform(st_simplify(st_transform(st_set_crs(missing_simp,4326),crs=3857),
                                             preserveTopology = TRUE, dTolerance = 1000),crs=4326) #merc: 3857
  # Load & simplify Malasia map
  Data_Malasia<-st_read('Shared_Data/shapefiles/Malasia_geom/bd012vf3991.shp',quiet=TRUE)
  Data_Malasia_crop<-st_crop(Data_Malasia, c(xmin= 98, ymin = -7, xmax = 110, ymax = 6.1))#7
  Data_Malasia_simp<<-st_transform(st_simplify(st_transform(Data_Malasia_crop,crs=3857),
                                               preserveTopology = TRUE, dTolerance = 1000),crs=4326) #merc: 3857
  # Load, cut & simplify Thailand map
  Data_Thai<-st_read('Shared_Data/shapefiles/Thai_geom/tha_admbnda_adm0_rtsd_20220121.shp',crs=4326 , quiet=TRUE)
  Data_Thai_crop<-st_crop(Data_Thai, c(xmin= 98, ymin = -7, xmax = 120, ymax =6.05))#7
  Data_Thai_simp<<-st_transform(st_simplify(st_transform(Data_Thai_crop,crs=3857),
                                            preserveTopology = TRUE, dTolerance = 1000),crs=4326) #merc: 3857
  # Load, cut & simplify Singapore map
  Data_Singap<-st_read('Shared_Data/shapefiles/Singapore_geom/sgpBound.shp',crs=4326 , quiet=TRUE)
  Data_Sing_simp<<-st_transform(st_simplify(st_transform(Data_Singap,crs=3857),
                                            preserveTopology = TRUE, dTolerance = 1000),crs=4326) #merc: 3857
  options(warn = 0)
}

Plot.maps<- function (island, pred_dif, scenario, flag_model, title_str){
  
  # Define truncated limits
  if (scenario=='SH'){
    for_limit<- c(0,30)
    hosp_limit<- c(-0.11, limits_map[2])
    prim_limit<-c(min(pred_dif),max(pred_dif))
    markt_limit<-c(0,20)
  }else if (scenario=='IND') {
    for_limit<-c(limits_map[1],4)
    hosp_limit<- c(-0.802, 0.09)
    prim_limit<-c(limits_map[1], 0)
    markt_limit<-c(0,20)
  }else{
    for_limit<- c(limits_map[1],limits_map[2])
    hosp_limit<- c(limits_map[1],limits_map[2])
    prim_limit<-c(limits_map[1],limits_map[2])
    markt_limit<-c(limits_map[1],limits_map[2])
  }
  
  limits_mod<- case_when(
    (prefix[i] =='pov') ~ c(-200,limits_map[2]),
    (prefix[i] == 'for') ~ for_limit,
    (prefix[i] =='jnr') ~ c(limits_map[1], 5),
    (prefix[i] =='prim') ~ prim_limit,
    (prefix[i] =='markt') ~ markt_limit,
    (prefix[i] =='hosp') ~ hosp_limit, #c(-0.802, 0.09),#0.08
    (prefix[i] =='crime') ~ c(-0.3,0.5)
  )
  
  # Define flags
  var_name<- case_when(
    (prefix[i] =='pov') ~ 'Num. SKTM letters',
    (prefix[i] == 'for') ~'Forest Coverage (%)',
    (prefix[i] =='jnr') ~'Dist. high school (km)',
    (prefix[i] =='prim') ~'Dist. primary school (km)',
    (prefix[i] =='markt') ~ 'Dist. minimarket (km)',
    (prefix[i] =='hosp') ~ 'Num. healthcare fac.',
    (prefix[i] =='crime') ~'Num. types of crimes'
  )
  map<-ggplot() +  geom_sf(data = simp,aes(geometry=geometry, fill=pred_dif),color=NA)+
    geom_sf(data=missing_simp_SM,aes(geometry=geometry),fill='gray86',color='NA')+
    geom_sf(data=data.frame(Data_crop_simp),aes(geometry=geometry),fill='gray86',color='NA') +
    geom_sf(data=data.frame(Data_Malasia_simp),aes(geometry=geometry),fill='gray86',color='NA') +
    geom_sf(data=data.frame(Data_Thai_simp),aes(geometry=geometry),fill='gray86',color='NA') +
    geom_sf(data=data.frame(Data_Sing_simp),aes(geometry=geometry),fill='gray86',color='NA') +
    scale_fill_continuous_divergingx(palette = "Spectral", rev=TRUE, 
                                     label = function(z) Relabel(z,pred_dif,limits_mod),
                                     name=var_name, limits=limits_mod, mid=0,oob=squish)+ 
    geom_sf(size=0.2,data=mod_simp,color='gray44',fill='NA')+
    scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0)) +    
    theme_void()+ggtitle(' ') +
    guides(fill = guide_colourbar(nbin=60,title.position = "top",direction='horizontal'))+
    theme(text=element_text(size=15,  family="sans"),
          plot.title =element_text(family='sans',size=20,hjust = 0.5,vjust=1),
          legend.justification = c(0, 0), legend.position = c(0, 0), legend.title.align = 0.5,
          legend.text.align = 0.5,legend.margin=margin(t=0.1,b=0.1, l=0.2,r=0.2, "cm"),
          plot.margin=unit(c(0,0.25,0.5,0.25), "cm"),  #(top,right,bottom,left)
          legend.background = element_rect(fill='white',color=NA),
          legend.key.width = unit(0.9, "cm"),
          panel.background = element_rect(fill='#93c8d0',color=NA))
  
  map<-Align.legend(map,hjust = 0.5) 
  ggsave(paste0('Panel_',prefix[i],'_',scenario,'.pdf'), path=paste0('Plots_simulations/SupFig2'),plot=map, width=9, height=7,dpi=400,device='pdf') 
  }



prefix<- c('pov','hosp','prim','jnr','markt','for','crime')

for (i in 1:length(prefix)){
  print(prefix[i])
  Data_og<-st_read('Shared_Data/shapefiles/Villages_indonesia.shp',quiet=TRUE)
  region<-Data_og %>% subset (KODE_PROV<30)
  oil_raw<- read.csv('Shared_Data/oil_palm_filtered.csv')
  oil_percent<- subset(oil_raw, select = c(ID, Percentage_k, Percentage_l,Area_k,Area_l))
  region <- merge(region, oil_percent, by="ID")
  simp = st_transform(st_simplify(st_transform(st_set_crs(region,4326),crs=3857),
                                  preserveTopology = TRUE, dTolerance = 1000),crs=4326) 
  simp=simp[c('KODE_PROV','Percentage_k','Percentage_l')]
  
  change<- region$Percentage_k+region$Percentage_l
  mod_area<-st_set_crs(st_union(region[change>0,]),4326)
  mod_simp<<-st_transform(st_simplify(st_transform(mod_area,crs=3857), 
                                      preserveTopology = TRUE, dTolerance = 1000),crs=4326) #merc: 3857
  # Define limits for maps
  INpredictions_SDMtc =read.csv2(paste0('Shared_Data/Output_simulations/',prefix[i],'_SDM_ind_predictions.csv'))
  SHpredictions_SDMtc =read.csv2(paste0('Shared_Data/Output_simulations/',prefix[i],'_SDM_sh_predictions.csv'))
  limits_map<- c(min(INpredictions_SDMtc$pred_dif,SHpredictions_SDMtc$pred_dif),
                 max(INpredictions_SDMtc$pred_dif,SHpredictions_SDMtc$pred_dif))
  
  Load.shapefiles()
  Plot.maps (simp, INpredictions_SDMtc$pred_dif,'IND', 'SDM', title)
  Plot.maps (simp, SHpredictions_SDMtc$pred_dif,'SH', 'SDM', title)
}

