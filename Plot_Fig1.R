## Create figure showing the total impacts for Unproductive, Industrial and 
# Smallholder plantations

library(ggplot2)
library(reshape2)
library(xtable)

# Define working directory (If running from RStudio)
#setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# Function definition 
reassign<-function(impacts_tab, stat_col,names_s){
  # Combine stats and impacts in a single table
  colnames(impacts_tab)<-c('direct','indirect','total')
  
  # Add empty rows if convinient 
  if (length(impacts_tab$direct)-length(stat_col)>=0){
    stat_names<-c(names_s,rep(0,length(impacts_tab$direct)-length(stat_col)))
    final_tab<-cbind(impacts_tab,stat_names,stat_col)
  }else{
    df_tab<-data.frame(direct=rep(0,length(stat_col)-length(impacts_tab$direct)),
                       indirect=rep(0,length(stat_col)-length(impacts_tab$direct)),
                       total=rep(0,length(stat_col)-length(impacts_tab$direct)))
    impact_rows<-rbind(impacts_tab,df_tab)
    final_tab<-cbind(impact_rows,names_s,stat_col)
  }
  
  xtable(final_tab, align='|c|c|c|c||c|c|')
}

# LOAD RData
load('Shared_Data/Data_Fig1.RData')

# Merge simulations in one table
sig_feat<-unique(c(row.names(UN_SDM),row.names(PR_SDM),row.names(IN_SDM),row.names(SH_SDM)))
mixed_table<-data.frame(unp=rep(NA,length(sig_feat)),unp_pr=rep(NA,length(sig_feat)),ind=rep(NA,length(sig_feat)),sm=rep(NA,length(sig_feat)))
row.names(mixed_table)<-sig_feat

for (i in sig_feat){
  mixed_table[i,'unp']<-UN_SDM[i,'total']
  mixed_table[i,'sm']<-SH_SDM[i,'total']
  mixed_table[i,'ind']<-IN_SDM[i,'total']
  mixed_table[i,'unp_pr']<-PR_SDM[i,'total']
  
}
mixed_table$feat<-row.names(mixed_table)

# Change table to long format (for ggplot)
long_tab<-melt(mixed_table,id.vars = c("feat"))

long_tab$feat<- factor(long_tab$feat, levels=(sig_feat))

# Missing data label
labels<-long_tab$value
labels[is.na(labels)]<- ''

# Plot
plot<-ggplot(long_tab,aes(x=factor(variable),y=factor(feat))) + 
  geom_tile(aes( fill = value, size = abs(value)), alpha=0.8) + 
  geom_text(aes(label = labels),show.legend = FALSE)+
  scale_x_discrete(position = "top", labels=c('Unproductive\n(damaged)','Unproductive\n(possibly replanted)','Industrial\n','Smallholder\n'),)+
  scale_radius(range = c(12,22)) +
  ggtitle('Significant spatial impacts for different production systems')+
  scale_fill_gradientn(colors=c("#EE6241","#EAB58B","#FFFFFF","#72AA91","#196294"),breaks=c(-6,-3,0,3,6), limits=c(-6.3,6.3))+
  theme_minimal() +labs(x = NULL,y=NULL)+ 
  theme( legend.direction="horizontal",panel.background = element_rect(fill='white',color='white'),
         panel.grid.major = element_blank(),
         panel.grid.minor = element_blank(),
         axis.ticks = element_blank(),
         plot.title = element_text(hjust = 0.5, face='bold',size=18),
         plot.title.position = 'plot', 
         text = element_text(size = 20,family='sans'),legend.justification = c(0, 0),
         legend.title.align = 0.5, 
         legend.position='bottom', 
         axis.text.x= element_text(size = 15,  family="sans", face='bold'),
         axis.text.y= element_text(size = 15, family="sans"))+
  guides(size = 'none', fill = guide_colorbar(ticks.colour = 'black',barwidth =20, alpha=0.8, title ='Magnitude',title.position = "top"))


print(UN_stat)
print(PR_stat)
print(IN_stat)
print(SH_stat)

ggsave('Figure1.pdf',path='Plots_simulations',plot=plot,width=12, height=7,dpi=400,device='pdf') 
