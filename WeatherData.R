filename<-function(date=Sys.time()){            # 文件根据日期来命名
       paste(format(date, "%Y%m%d"),".csv",sep="")
   }

loadDate<-function(date){                       # 读取城市列表，调用爬虫函数，合并数据保存到一个文件中。
       print(paste('Date','==>',date))
       city<-read.csv(file="WOEID.csv",header=FALSE,fileEncoding="utf-8", encoding="utf-8")  # 加载城市列表
       names(city)<-c("en","woeid","zh",'prov','long','lat')
       city<-city[-nrow(city),]
  
         wdata<-do.call(rbind, lapply(city$woeid,getWeather))
       w<-cbind(city,wdata)
       write.csv(w,file=filename(date),row.names=FALSE,fileEncoding="utf-8")
   }