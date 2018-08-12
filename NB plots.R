library('ggplot2')

info_3D <- read.delim('~/Google Drive jf565/MATLAB_R_scripts/metadata_NBs_3D.txt', stringsAsFactors = FALSE)

minNumber <- 10
ReplaceLabels <- function(Path, GFP_all,frames){
  try({
  cat('finding toReplace.txt')
  toReplaceFile <- list.files(path = Path, pattern ='toReplace.txt')
  toReplace <- read.delim(paste(Path,toReplaceFile,sep=''),sep='\t', header=TRUE, stringsAsFactors = FALSE)
  toReplace$fromF[is.na(toReplace$fromF)] <- 1
  toReplace$toF[is.na(toReplace$toF)] <- frames
  # 
  for (x in 1:length(rownames(toReplace))){
    index <- GFP_all$NewLabel == toReplace[x,2] & GFP_all$Frame >= toReplace[x,3] & GFP_all$Frame <= toReplace[x,4]
    GFP_all$NewLabel[index] <- toReplace[x,1]
    GFP_all$Replaced[index] <- 1
  }
  GFP_all <- GFP_all[!GFP_all$NewLabel == 0,]
  cat('Labels replaced')
  }, silent=TRUE)
  return(GFP_all)
}
Run <- function(Start, End, info, minNumber){
for (X in Start:End){
  try({
  Path  <- paste(info[X,1],info[X,2],info[X,3],sep='')
  cat(Path)
  frames <- info[X,4]
  XWidth <- info[X,5]
  if (is.null(XWidth)){XWidth = 512}
  YHeight <- info[X,6]
  if (is.null(YHeight)){YHeight = 512}
  
  #Width <- frames/20
  Width <- 600/20
  Folder <- unlist(strsplit(Path,'/'))
  Folder <- Folder[length(Folder)]
#   Parameters <- read.delim(paste(Path,info[x,2],'_parameters.txt',sep=''),sep = ',')
#   XWidth <- as.numeric(Parameters['Xf']-Parameters['X0']+1)
#   YHeight <- as.numeric(Parameters['Yf']-Parameters['Y0']+1)
#   info[X,5] <- XWidth 
#   info[X,6] <- YHeight
#   write.table(info,'~/Google Drive/MATLAB_R_scripts/metadata_NBs_3D.txt',sep='\t',quote=F,row.names = F)
#   
  GFP_all <- data.frame()
  for (f in 1:frames){
    try({
      GFP <- read.delim(paste(Path,'/F/frame',f,'.txt',sep=''),sep=',', header=TRUE)
      #GFP$Label <- as.factor(GFP$Label)
      GFP$Frame <- rep(f, length(rownames(GFP)))
      #GFP$Norm <- GFP$MaxIntensity/GFP$MeanIntensity
      GFP_all <- rbind(GFP_all,GFP)
    },silent = T)
  }
  #GFP_all$Label[GFP_all$Label == 32] = 2
  #GFP_all$MeanIntensity[GFP_all$Label == 29 & GFP_all$Frame == 251] = NA
  GFP_all$NewLabel <- GFP_all$Label
  GFP_all$Replaced <- 0
  MeanAll <- mean(GFP_all$MeanIntensity)
  GFP_all$MeanIntensityOld <- GFP_all$MeanIntensity
  GFP_all$MeanIntensity <- GFP_all$MeanIntensity/MeanAll
  GFP_all <- ReplaceLabels(Path, GFP_all,frames)
  ColorLimits <- c(0,max(GFP_all$MeanIntensity))
  if ((1 %in% GFP_all$Replaced)==1){Replaced=1} else {Replaced=0}
    
  for (x in GFP_all$NewLabel){
      if (length(GFP_all$NewLabel[GFP_all$NewLabel==x]) < minNumber){
        GFP_all <- GFP_all[!GFP_all$NewLabel==x,]
      }
  }
  GFP_all$NewLabel <- as.factor(GFP_all$NewLabel)
  GFP_selected <- GFP_all[GFP_all$Replaced==1,]
  GFP_selected$NewLabel <- as.factor(GFP_selected$NewLabel)
  
  #frames <- 600
  Xlim <- 600
  pdf (paste (Path,'/',Folder,'_plots.pdf', sep = "", collapse = NULL), width=Width, height=10)
  #theme(legend.position="none")
  All <- ggplot(GFP_all,aes(y=MeanIntensity, x=Frame,col=NewLabel))+
    geom_point(aes(y=MeanIntensity, x=Frame,col=NewLabel),size=0.5)+
    geom_text(aes(label=Label), size=2,vjust = 0, nudge_y = 0)+
    geom_line(aes(),size=0.25)+
    #geom_smooth(se=FALSE, span=0.15)+
    scale_x_continuous(breaks =seq(0,Xlim,15), labels=seq(0,Xlim,15),limits=c(1,Xlim))+
    #scale_y_continuous(limits=c(1,6))+
    scale_y_continuous()+
    scale_color_discrete()+
    #scale_colour_manual(values=cols)+
    theme_classic(base_size = 16)
  SizeAll <- 
    ggplot(GFP_all,aes(y=Area, x=Frame,col=NewLabel))+
    geom_point(aes(y=Area, x=Frame,col=NewLabel),size=0.5)+
    geom_line(aes(),size=0.25)+
    scale_x_continuous(breaks =seq(0,Xlim,15), labels=seq(0,Xlim,15),limits=c(1,Xlim))+
    #scale_y_continuous(limits=c(1,6))+
    scale_y_continuous()+
    scale_color_discrete()+
    #scale_colour_manual(values=cols)+
    theme_classic(base_size = 16)
  pointSizeAll <- 
    ggplot(GFP_all,aes(y=NewLabel, x=Frame,col=MeanIntensity))+
    geom_point(aes(size=Area))+
    scale_size_continuous(range = c(0, 15))+
    scale_x_continuous(breaks =seq(0,Xlim,15), labels=seq(0,Xlim,15),limits=c(1,Xlim))+
    #scale_y_continuous(limits=c(1,6))+
    scale_y_discrete()+
    scale_colour_continuous(low='blue', high='yellow', limits = ColorLimits)+
    theme_classic(base_size = 16)
  if (Replaced==1){
  Selected <- 
    ggplot(GFP_selected,aes(y=MeanIntensity, x=Frame,col=NewLabel))+
    geom_point(aes(y=MeanIntensity, x=Frame,col=NewLabel),size=0.5)+
    #geom_text(aes(label=Label), size=2,vjust = 0, nudge_y = 0)+
    geom_line(aes(),size=0.25)+
    #geom_smooth(se=FALSE, span=0.15)+
    scale_x_continuous(breaks =seq(0,Xlim,15), labels=seq(0,Xlim,15),limits=c(1,Xlim))+
    #scale_y_continuous(limits=c(1,6))+
    scale_y_continuous()+
    scale_color_discrete()+
    #scale_colour_manual(values=cols)+
    theme_classic(base_size = 16)
  Size <- 
    ggplot(GFP_selected,aes(y=Area, x=Frame,col=NewLabel))+
    geom_point(aes(y=Area, x=Frame,col=NewLabel),size=0.5)+
    geom_line(aes(),size=0.25)+
    scale_x_continuous(breaks =seq(0,Xlim,15), labels=seq(0,Xlim,15),limits=c(1,Xlim))+
    #scale_y_continuous(limits=c(1,6))+
    scale_y_continuous()+
    scale_color_discrete()+
    #scale_colour_manual(values=cols)+
    theme_classic(base_size = 16)
  pointSize <- 
    ggplot(GFP_selected,aes(y=NewLabel, x=Frame,col=MeanIntensity))+
    geom_point(aes(size=Area))+
    scale_size_continuous(range = c(0, 15))+
    scale_x_continuous(breaks =seq(0,Xlim,15), labels=seq(0,Xlim,15),limits=c(1,Xlim))+
    #scale_y_continuous(limits=c(1,6))+
    scale_y_discrete()+
    scale_colour_continuous(low='blue', high='yellow',limits = ColorLimits)+
    theme_classic(base_size = 16)
  GFP_selected_noNL <- GFP_selected[-(length(colnames(GFP_selected))-1)]
#   XWidth <- max(GFP_selected$Centroid_2)+10
#   YHeight <- max(GFP_selected$Centroid_1)+10
  GFP_selected$ScaledFrame <-  GFP_selected$Frame*XWidth/frames
  Position <- 
    ggplot(GFP_selected,aes(y=Centroid_1, x=Centroid_2))+
    geom_point(data=GFP_selected_noNL, aes(y=Centroid_1, x=Centroid_2),size=0.2,color='grey')+
    # geom_line(aes(group=NewLabel), col='black')+
    geom_point(aes(size=Area,fill=MeanIntensity),pch=21,colour="black",stroke = 0.25)+
    geom_hline(aes(yintercept=-10))+
    geom_point(aes(y=-10, x=ScaledFrame, size=Area,col=MeanIntensity))+
    scale_size_continuous(range = c(0, 3))+
    scale_x_continuous(limits=c(1,XWidth))+
    scale_y_continuous(limits=c(-20,YHeight))+
    # scale_y_discrete()+
    facet_wrap(~NewLabel,nrow=2)+
    scale_fill_continuous(low='blue', high='yellow',limits = ColorLimits)+
    scale_colour_continuous(low='blue', high='yellow',limits = ColorLimits)+
    theme_classic(base_size = 16)+coord_fixed()
  }

#   bars <- 
#     ggplot(GFP_selected,aes(y=NewLabel, x=Frame,col=MeanIntensity))+
#     geom_point(size=10, shape=124)+
#     scale_x_continuous(breaks =seq(0,frames,5), labels=seq(0,frames,5))+
#     #scale_y_continuous(limits=c(1,6))+
#     scale_y_discrete()+
#     scale_colour_continuous(low='blue', high='yellow')+
#     theme_classic(base_size = 10)
#   barsSize <- 
#     ggplot(GFP_selected,aes(y=NewLabel, x=Frame,col=MeanIntensity))+
#     geom_point(aes(size=Area),shape=124)+
#     scale_size_continuous(range = c(0, 15))+
#     scale_x_continuous(breaks =seq(0,frames,5), labels=seq(0,frames,5))+
#     #scale_y_continuous(limits=c(1,6))+
#     scale_y_discrete()+
#     scale_colour_continuous(low='blue', high='yellow')+
#     theme_classic(base_size = 10)
  if (Replaced==1){
    print(Selected)
    print(All)
    print(Size)
    print(pointSize)
    print(Position)
    write.table(GFP_selected,paste(Path,info[X,2],'_Fselected.txt',sep=''),sep='\t',quote=F,row.names = F)
    
  } else {
    print(All)
    print(SizeAll)
    print(pointSizeAll)
  }
  dev.off()
  })}
} 

Run(1,length(rownames(info_3D)), info_3D, minNumber) # 3D lacZ solo
