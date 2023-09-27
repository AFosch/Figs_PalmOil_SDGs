# Plot summary statistics for regional predictions 

library(xtable)

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

  # Transform positive and negative influences 
  positive<-data.frame(smallholder=hp$sh + mp$sh, industrial=hp$ind + mp$ind, sdgs=hp$sdg)
  negative<-data.frame(smallholder=hn$sh + mn$sh, industrial=hn$ind + mn$ind, sdgs=hn$sdg)
  
  # Conditions for positive values
  major_pos<- 1*(positive$smallholder>positive$industrial)+
    2*(positive$smallholder<positive$industrial)+  
    3*(positive$smallholder==positive$industrial & positive$smallholder>0)+
    0*(positive$smallholder==0 & positive$industrial==0)
  
  major_pos[major_pos==1]<- rep('S',sum(major_pos==1))
  major_pos[major_pos==2]<- rep('I',sum(major_pos==2))
  major_pos[major_pos==3]<- rep('I/S',sum(major_pos==3))
  major_pos[major_pos==0]<- rep('0',sum(major_pos==0))
  
  # Conditions for negative values
  major_neg<- 1*(negative$smallholder>negative$industrial)+ 
    2*(negative$smallholder<negative$industrial)+  
    3*(negative$smallholder==negative$industrial & negative$smallholder>0)+
    0*(negative$smallholder==0 & negative$industrial==0)
  
  major_neg[major_neg==1]<- rep('S',sum(major_neg==1))
  major_neg[major_neg==2]<- rep('I',sum(major_neg==2))
  major_neg[major_neg==3]<- rep('I/S',sum(major_neg==3))
  major_neg[major_neg==0]<- rep('0',sum(major_neg==0))
  
  #List of positive and negative effects for all sdgs.
  region_pos<-rbind(region_pos,major_pos)
  region_neg<-rbind(region_neg,major_neg)
}

# change colnames of table
colnames(region_pos)<-hp$sdg

# Change colnames table for negative values 
colnames(region_neg)<-paste0(hp$sdg,'_n')

# Join positive and negative cols and sort
all_regions<- cbind(region_pos,region_neg)
all_regions<- all_regions[,c('pov','pov_n','hosp','hosp_n','prim','prim_n',
                             'jnr','jnr_n','markt','markt_n','for','for_n','crime','crime_n')]
# Change rownames to province names
row.names(region_pos)<- sapply(c(1:10,'All'),function(i)paste0('Province ',i))
row.names(region_neg)<- sapply(c(1:10,'All'),function(i)paste0('Province ',i))

#Export table
print(xtable(all_regions, align='|c|c|c|c|c|c|c|c|c|c|c|c|c|c|c|'))

# Images are added to Table 1 on the Latex Document.
