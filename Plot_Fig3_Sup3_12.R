# Plot summary statistics for regional predictions (Sumatra plot & All provinces)

library(ggplot2)
library(patchwork)

Sing.plot<- function (tot_data,label_plot, class_lab,text_class){
  if(class_lab=='ind'| class_lab=='def_ind'){
    box_ticks_y<-element_blank()
  }else{
    box_ticks_y<-element_text(size = 18, family="sans", color='black') 
  }
  
  plot<-ggplot(tot_data[,c(class_lab,'class','sdg')],aes(x=factor(class,levels=c("hn", "mn",'neut','mp','hp')),y=factor(sdg, levels=rev(prefix)))) + 
    geom_point(aes(fill = class, size = 2.5*abs(tot_data[,class_lab])),shape = 21, stroke = 1, color=rgb(0, 0, 0, 0), na.rm = TRUE,show.legend=FALSE) + #1.2 no 
    scale_fill_manual(values=c(hp="#196294",hn="#EE6241",neut='#F7CE7E',mp= "#82B29E", mn="#EAB58B"))+#blue 196294"#red EE6241 #green 72AA91 #orange EAB58B
    scale_radius(range = c(16,30)) +
    geom_text(aes(label = label_plot), size=5, 
              color=ifelse(((tot_data$class=="hp" | tot_data$class=="hn") & !is.na(tot_data[,class_lab])),"white","black"),show.legend = FALSE)+
    scale_x_discrete(position = "top",labels=c('High neg.','Mod. neg.','Neutral','Mod. pos.','High pos.'))+
    scale_y_discrete(labels=rev(c('Num. SKTM pov. letters','Num. healthcare fac.','Dist. primary school',
                                  'Dist. junior-high school','Dist. to market','Forest coverage (%)','Num. types of crimes')))+
    ggtitle(paste0(text_class,' expansion in ', list_names[[j]]))+
    labs(x = NULL,y=NULL)+
    theme( legend.direction="horizontal", panel.background = element_rect(fill='white',color='white'),
           panel.grid.major = element_blank(),
           panel.grid.minor = element_blank(),
           plot.title = element_text(hjust = 0.5, face='bold',size=22),
           plot.title.position = 'plot', 
           text = element_text(family='sans'),legend.justification = c(0, 0),
           legend.title.align = 0.5, legend.text.align = 0.5,
           legend.position='bottom', 
           axis.ticks = element_blank(),axis.text.x= element_text(size = 18,  family="sans", face='bold',color='black'),#15
           axis.text.y= box_ticks_y
    ) 
}


Summary.plots<-function(hn,mn,hp,mp,neut){
  # Create common dataframe
  hn[,c('ind','sh')]<-round(hn[,c('ind','sh')],2)
  mn[,c('ind','sh')]<-round(mn[,c('ind','sh')],2)
  hp[,c('ind','sh')]<-round(hp[,c('ind','sh')],2)
  mp[,c('ind','sh')]<-round(mp[,c('ind','sh')],2)
  neut[,c('ind','sh')]<-round(neut[,c('ind','sh')],2)
  
  tot_data<-rbind(hn,mn,hp,mp,neut)
  
  # Smallholder plot 
  tot_data[tot_data==0]<-NA
  label_plot<-tot_data$sh
  label_plot[is.na(label_plot)]<- '-'
  plot_sm<- Sing.plot(tot_data,label_plot,'sh','Smallholder')
  
  # Industrial plot 
  label_plot2<-tot_data$ind
  label_plot2[is.na(label_plot2)]<- '-'
  plot2<- Sing.plot(tot_data,label_plot2,'ind','Industrial')
  plotmix<-plot_sm+plot2
  
  #Define labels to match fig number 
  if (prov_ranges$lower[j]==0){
    ggsave(paste0("Figure3.pdf"),path='Plots_simulations/',plot=plotmix,width=20, height=9,dpi=400,device='pdf')
    print("Figure3.pdf")
  }else if (prov_ranges$lower[j]==21){ 
    ggsave(paste0("SupFig_",prov_ranges$lower[j]-9,".pdf"),path='Plots_simulations/',plot=plotmix,width=20, height=9,dpi=400,device='pdf') 
    print(paste0("SupFig_",prov_ranges$lower[j]-9,".pdf"))
  }else{ 
    ggsave(paste0("SupFig_",prov_ranges$lower[j]-8,".pdf"),path='Plots_simulations/',plot=plotmix,width=20, height=9,dpi=400,device='pdf') 
    print(paste0("SupFig_",prov_ranges$lower[j]-8,".pdf")) 
    }
}

# Define working directory
#setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# Load data
load('Shared_Data/Data_Fig3_Tab1.RData') 
list_names<- c('Aech','Sumatera Utara','Sumatera Barat','Riau','Jambi','Sumatera Selatan','Bengkulu',
               'Lampung','Kepulauan Bangka Belitung','Kepulauan Riau.','Sumatra')
#Save tables 
region_pos<-data.frame()
region_neg<-data.frame()

#Simulations for regions.
for (j in 1:length(prov_ranges$lower)){

  # Extract data
  hp<- data.frame(ind=sapply(1:length(prefix),function(i) vil_list_hp[[i]]$ind[j]),
                  sh=sapply(1:length(prefix),function(i) vil_list_hp[[i]]$sh[j]), 
                  sdg=prefix, class= rep('hp',length(prefix)))
  hn<- data.frame(ind=sapply(1:length(prefix),function(i) vil_list_hn[[i]]$ind[j]),
                  sh=sapply(1:length(prefix),function(i) vil_list_hn[[i]]$sh[j]), 
                  sdg=prefix, class= rep('hn',length(prefix)))
  mp<- data.frame(ind=sapply(1:length(prefix),function(i) vil_list_mp[[i]]$ind[j]),
                  sh=sapply(1:length(prefix),function(i) vil_list_mp[[i]]$sh[j]), 
                  sdg=prefix, class= rep('mp',length(prefix)))
  mn<- data.frame(ind=sapply(1:length(prefix),function(i) vil_list_mn[[i]]$ind[j]),
                  sh=sapply(1:length(prefix),function(i) vil_list_mn[[i]]$sh[j]), 
                  sdg=prefix, class= rep('mn',length(prefix)))
  neut<-data.frame(ind=sapply(1:length(prefix),function(i) vil_list_0[[i]]$ind[j]),
                   sh=sapply(1:length(prefix),function(i) vil_list_0[[i]]$sh[j]), 
                   sdg=prefix, class= rep('neut',length(prefix)))

  Summary.plots(hn,mn,hp,mp,neut)
  
  # Transform positive and negative influences 
  positive<-data.frame(smallholder=hp$sh + mp$sh, industrial=hp$ind + mp$ind, sdgs=hp$sdg)
  negative<-data.frame(smallholder=hn$sh + mn$sh, industrial=hn$ind + mn$ind, sdgs=hn$sdg)
  
  # Conditions for positive values
  major_pos<- 1*(positive$smallholder>positive$industrial)+
    2*(positive$smallholder<positive$industrial)+  
    3*(positive$smallholder==positive$industrial & positive$smallholder>0)+
    0*(positive$smallholder==0 & positive$industrial==0)
  
  major_pos[major_pos==1]<- rep('SH',sum(major_pos==1))
  major_pos[major_pos==2]<- rep('IN',sum(major_pos==2))
  major_pos[major_pos==3]<- rep('IN/SH',sum(major_pos==3))
  major_pos[major_pos==0]<- rep('0',sum(major_pos==0))
  
  # Conditions for negative values
  major_neg<- 1*(negative$smallholder>negative$industrial)+ 
    2*(negative$smallholder<negative$industrial)+  
    3*(negative$smallholder==negative$industrial & negative$smallholder>0)+
    0*(negative$smallholder==0 & negative$industrial==0)
  
  major_neg[major_neg==1]<- rep('SH',sum(major_neg==1))
  major_neg[major_neg==2]<- rep('IN',sum(major_neg==2))
  major_neg[major_neg==3]<- rep('IN/SH',sum(major_neg==3))
  major_neg[major_neg==0]<- rep('0',sum(major_neg==0))
  
  #List of positive and negative effects for all sdgs.
  region_pos<-rbind(region_pos,major_pos)
  region_neg<-rbind(region_neg,major_neg)
}


