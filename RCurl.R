library(RCurl)#load library and get data
library(XML)
getWeather<-function (x){
  url<-paste('http://weather.yahooapis.com/forecastrss?w=',x,'&u=c',sep="")       # yahoo的数据源地址
  doc = xmlTreeParse(getURL(url),useInternal = TRUE)                              # 解析XML文档
  ans<-getNodeSet(doc, "//yweather:atmosphere")
  humidity<-as.numeric(sapply(ans, xmlGetAttr, "humidity"))                       # 温度
  visibility<-as.numeric(sapply(ans, xmlGetAttr, "visibility"))                   # 能见度
  pressure<-as.numeric(sapply(ans, xmlGetAttr, "pressure"))                       # 气压
  rising<-as.numeric(sapply(ans, xmlGetAttr, "rising"))                           # 气压变动
  ans<-getNodeSet(doc, "//item/yweather:condition")
  code<-sapply(ans, xmlGetAttr, "code")                                           # 天气情况
  ans<-getNodeSet(doc, "//item/yweather:forecast[1]")
  low<-as.numeric(sapply(ans, xmlGetAttr, "low"))                                 # 最高气温
  high<-as.numeric(sapply(ans, xmlGetAttr, "high"))                               # 最低气温
  print(paste(x,'==>',low,high,code,humidity,visibility,pressure,rising))
  cbind(low,high,code,humidity,visibility,pressure,rising)                        # 以data.frame格式返回
}

filename<-function(date=Sys.time()){            # 文件根据日期来命名
  paste(format(date, "%Y%m%d"),".csv",sep="")
}

loadDate<-function(date){                       # 读取城市列表，调用爬虫函数，合并数据保存到一个文件中。
  print(paste('Date','==>',date))
  city <- WOEID  # 加载城市列表
  names(city)<-c("en","woeid","zh",'prov','long','lat')
  city<-city[-nrow(city),]
  
  wdata<-do.call(rbind, lapply(city$woeid,getWeather))
  w<-cbind(city,wdata)
  write.csv(w,file=filename(date),row.names=FALSE,fileEncoding="utf-8")
}