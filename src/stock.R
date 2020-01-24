# ______________________________
# LIBRARY ####
# ______________________________
# install.packages("data.table")
# install.packages("mailR")
library(data.table)
# library(mailR)

# ______________________________
# INITIALIZE ####
# ______________________________
# 주식 사고판 데이터
# tradeData <- data.table(date=as.Date(character())       # 거래일자
#                         , name=character()              # 종목명
#                         , price=numeric()               # 거래단가
#                         , quantity=numeric()            # 거래수량
#                         , totalPrice=numeric()          # 거래액
#                         , tradeType=character()         # 거래종류
#                         , tradeStrategy=character()     # 거래전략
#                         , market=character())           # 시장
# # 주식 종목별 관리 데이터 (목표, 매도, 매수 ,손절가)
# stockData <- data.table(date=as.Date(character())
#                         , name=character()                # 종목명
#                         , goalPrice=numeric()           # 목표가
#                         , sellPrice=numeric()           # 매도가
#                         , buyPrice=numeric()            # 매수가
#                         , lossPrice=numeric()           # 손절가
#                         , goalRatio=numeric()           
#                         , profitRatio=numeric()
#                         , lossRatio=numeric()
#                         , tradeStrategy=characeter()
#                         , market=character()
#                         )      
# # 주식 잔고 데이터
# balancedData <- data.table(name=character()             # 종목명
#                            , tradeStrategy=character()  # 매매전략
#                            , totalPrice=numeric()       # 매수금
#                            , totalQuantity=numeric()    # 보유수량
#                            , averagePrice=numeric()     # 평균단가
#                            , market=character())        # 시장
# 
# # 주식 매매 전략 데이터
# tradeStrategyData <- data.table(abbr=character()        # 약칭
#                                 , detail=character())   # 세부설명
# 
# # 계좌정보
# accountData <- data.table(account=character(),
#                           company=character(),
#                           purpose=character(),
#                           loginID=character(),
#                           loginPassword=character())


# ______________________________
# FUNCTION ####                
# ______________________________
insertTradeData <- function(data=tradeData, name, date, 
                            price, quantity, tradeType, tradeStrategy, market,
                            account) {
  if (!tradeType %in% c("매수", "매도")) {
    stop("tradeType must be '매수' or '매도'")
  }
  
  if (!tradeStrategy %in% c("20일밑꼬리", "장대양봉", "20일엉덩이", "예쁜차트", "장기투자", "240돌파")) {
    stop("tradeStrategy must be '20일밑꼬리', '장대양봉', '20일엉덩이', '예쁜차트', '240돌파' or '장기투자")
  }
  
  if (!market %in% c("코스피", "코스닥")) {
    stop("market must be '코스피' or '코스닥'")
  }
  
  if (!paste(name, tradeStrategy) %in% paste(stockData$name, stockData$tradeStrategy)) {
    goalPrice <- as.integer(readline(prompt="Enter goal price : "))
    sellPrice <- as.integer(readline(prompt="Enter sell price : "))
    buyPrice <- as.integer(readline(prompt="Enter buy price : "))
    lossPrice <- as.integer(readline(prompt="Enter loss price : "))
    insertStockData(name=name, goalPrice=goalPrice, sellPrice=sellPrice,
                    buyPrice=buyPrice, lossPrice=lossPrice, tradeStrategy=tradeStrategy, date=as.Date(date), market=market)
  }
  
  tradeData <<- rbind(tradeData,
                      list(date=as.Date(date), name=name, price=price, quantity=quantity, totalPrice=price*quantity,
                           tradeType=tradeType, tradeStrategy=tradeStrategy, market=market,
                           account=account))
  updateBalancedData(name, tradeStrategy, price*quality, quantity, price, market)
}

insertStockData <- function(data=stockData, name, goalPrice=0, sellPrice, buyPrice, lossPrice, tradeStrategy,
                            date, market) {
  if (goalPrice==0) {
    goalPrice <- sellPrice
  }
  
  if (!tradeStrategy %in% c("20일밑꼬리", "장대양봉", "20일엉덩이", "예쁜차트", "장기투자", "240돌파")) {
    stop("tradeStrategy must be '20일밑꼬리', '장대양봉', '20일엉덩이', '예쁜차트', '240돌파' or '장기투자")
  }
  
  stockData <<- rbind(stockData,
                      list(name=name, goalPrice=goalPrice, sellPrice=sellPrice,
                           buyPrice=buyPrice, lossPrice=lossPrice,
                           lossRatio=sprintf("%.2f%%", (lossPrice-buyPrice)/buyPrice * 100),
                           profitRatio=sprintf("%.2f%%", (sellPrice-buyPrice)/buyPrice * 100),
                           goalRatio=sprintf("%.2f%%", (goalPrice-buyPrice)/buyPrice * 100),
                           tradeStrategy=tradeStrategy,
                           date=as.Date(date),
                           market=market
                           )
                      )
}

# 구현
insertTradeStrategyData <- function(abbr, detail) {
  tradeStrategyData <<- rbind(tradeStrategyData,
                              list(abbr=abbr
                                   , detail=detail))
}


insertAccount <- function(account, company, purpose, loginID, loginPassword) {
  accountData <<- rbind(accountData,
                        list(
                          account=account,
                          company=company,
                          purpose=purpose,
                          loginID=ID,
                          loginPassword=loginPassword
                        ))
}

getTotalProfit <- function(profitType="month", tradeStrategy, startDate, endDate) {
  
  profitTypeList <- c("month", "week", "day", "total")
  
  if (!profitType %in% profitTypeList) {
    stop(paste0("profitType must be ", paste(profitTypeList, collapse=" or ")))
  }
  
  profitData <- tradeData[date >= as.Date(startDate) 
                          & date <= as.Date(endDate)
                          & tradeStrategy == tradeStrategy]
  
 if (profitType == "total") {
    profitData[, by := paste0(startDate, " ~ ", endDate)]
  } else if (profitType == "month") {
    profitData[, by := format(date, "%Y-%m")]
  } else if (profitType == "week") {
    profitData[, by := as.integer(date) %/% 7]
    profitData[, by := paste0(by - min(by) + 1, " 주차")]
  } else if (profitType == "day") {
    profitData[, by := date] 
  }
  # 수익률 구하는 로직 구현
  buyData <- profitData[tradeType == "매수", .(totalPrice = sum(totalPrice)
                                             , totalQuantity = sum(quantity)), by=c("name", "by")]
  buyData[, `:=` (averageBuyPrice = totalPrice / totalQuantity,
                  totalPrice = NULL,
                  totalQuantity = NULL)]
  sellData <- profitData[tradeType == "매도", .(totalPrice = sum(totalPrice)
                                              , totalQuantity = sum(quantity)), by=c("name", "by")]
  sellData[, `:=` (averageSellPrice = totalPrice / totalQuantity,
                   totalPrice = NULL)]
  
  profitData <- buyData[sellData, on=c("name", "by"), nomatch=0]
  profitData[, `:=` (profit = totalQuantity * (averageSellPrice - averageBuyPrice),
                     profitRatio = paste0(round(((averageSellPrice - averageBuyPrice) / averageBuyPrice), 2), "%"))]
  
  print(profitData)
  # 지금은 종목별인데 전체에 대한 합계도 구해야 함.
}

# 구현
updateBalancedData <- function(name, tradeStrategy, quantity, price) {
  if (name %in% balancedData[, name]) {
    balancedData <<- balancedData[name == name, `:=` (totalPrice = totalPrice + quantity * price,
                                                      totalQuantity = totalQuantity + quantity,
                                                      averagePrice = ((totalQuantity * price) + (quantity * totalPrice) / (totalQuantity + quantity)))]
  } else {
    balancedData <<- rbind(balancedData,
                           list(
                             name=name,
                             tradeStrategy=tradeStrategy,
                             totalPrice=quantity * price,
                             totalQuantity=quantity,
                             averagePrice=price,
                             market=market
                           ))
  }
}

initializeBalancedDataByTradeData <- function() {
  tradeData[, .(), by=c("name", "tradeStrategy")]
}
# 로직 다시 짜야 함함
balancedData <<- tradeData[, .(averagePrice=sum(totalPrice) / sum(quantity),
                               balancedQuantity=sum(quantity * ifelse(tradeType == "매수", 1, -1)))
                           , by=c("name", "tradeStrategy")]
balancedData[, averagePrice := balancedPrice / balancedQuantity]
balancedData[, averagePrice := ifelse(is.infinite(averagePrice), 0, averagePrice)]

getAnnualizedReturn <- function() {
  # 연수익률로 환산 : 수익률 * 보유기간 / 365
}


saveData <- function() {
  fwrite(tradeData, "./data/종목거래데이터.csv")
  fwrite(balancedData, "./data/잔고데이터.csv")
  fwrite(stockData, "./data/종목관리데이터.csv")
  fwrite(tradeStrategyData, "./data/매매전략데이터.csv")
}

loadData <- function() {
  tradeData <<- fread("./data/종목거래데이터.csv")
  tradeData[, date := as.Date(date)]
  balancedData <<- fread("./data/잔고데이터.csv")
  stockData <<- fread("./data/종목관리데이터.csv")
  stockData[, date := as.Date(date)]
  tradeStrategyData <<- fread("./data/매매전략데이터.csv")
}

# 구현
sendMail <- function(from, to, title, body, files) {
  # https://belitino.tistory.com/258
  # java runtime 64비트로 받아야 함.
  # http://www.google.com/settings/security/lesssecureapps 이거 설정
  send.mail(from="<nerochaos1@gmail.com>",
            to="<nerochaos1@gmail.com>",
            subject="manage stock in r",
            body="none",
            smtp=list(
              host.name="smtp.gmail.com", port=465,
              user.name="<nerochaos1@gmail.com>",
              passwd="", ssl=TRUE
            ),
            authenticate=TRUE,
            send=TRUE)
}

pushGitHub <- function(files=NULL, msg) {
  # git configure 설정
  # $ git config --global user.name "John Doe"
  # $ git config --global user.email johndoe@example.com
  if (is.na(files)) {
    shell("git add --all")
    shell(paste0("git commit -m '", msg, "'"))
    shell("git push origin master")
  }
  shell(paste0("git add ", paste(files, collapse=" ")))
  shell(paste0("git commit -m '", msg, "'"))
  shell("git push origin master")
}
# _________________________________
# INPUT ####
# _________________________________
loadData()
# _______________________________________________________
# Fri Jan 17 19:07:31 2020 ------------------------------
# insertTradeData(name="삼성화재", price=228500, quantity=2, tradeType="매수",
#                 tradeStrategy="20일밑꼬리", market="코스피")
# insertTradeData(name="한국전자금융", price=7940, quantity=70, tradeType="매수",
#                 tradeStrategy="장기투자", market="코스닥")
# _______________________________________________________

# _______________________________________________________
# Sun Jan 19 22:31:39 2020 ------------------------------
# stockData[, tradeStrategy := ""]
# insertStockData(name="신한지주", sellPrice=45000, buyPrice=40400, lossPrice=39350, tradeStrategy="20일밑꼬리")
# insertStockData(name="기아차", goalPrice=45950, sellPrice=44500, buyPrice=41400, lossPrice=39950, tradeStrategy="20일밑꼬리")
# insertStockData(name="팬오션", goalPrice=5000, sellPrice=4625, buyPrice=4250, lossPrice=4160, tradeStrategy="20일밑꼬리")
# 
# insertStockData(name="인바디", sellPrice=25750, buyPrice=21800, lossPrice=20500, tradeStrategy="장기투자")
# 
# insertStockData(name="SK바이오랜드", sellPrice=27300, buyPrice=23500, lossPrice=21400, tradeStrategy="장대양봉")
# 
# insertStockData(name="태광", sellPrice=11500, buyPrice=10800, lossPrice=10550, tradeStrategy='240돌파')
# 
# insertStockData(name="다우데이타", goalPrice=8620, sellPrice=8500, buyPrice=7960, lossPrice=7720, tradeStrategy="예쁜차트")
# insertStockData(name="인바디", goalPrice=25750, sellPrice=24200, buyPrice=21800, lossPrice=20500, tradeStrategy="예쁜차트")
# 
# insertTradeStrategyData("20일밑꼬리", "20일선 밑에서 밑꼬리를 달고 있을 때 매수, 대형주에 적합함.")
# _______________________________________________________

# _______________________________________________________
# Mon Jan 20 18:27:35 2020 ------------------------------
# stockData[, date := "2020-01-01"]
# stockData[, date := as.Date(date)]
# 
# insertTradeData(name="아모레G", price=87000, quantity=10, tradeType="매수",
#                 tradeStrategy="예쁜차트", market="코스피")
# insertTradeData(name="웅진코웨이", price=88100, quantity=10, tradeType="매수",
#                 tradeStrategy="예쁜차트", market="코스피")
# insertTradeData(name="태광", price=10800, quantity=70, tradeType="매수",
#                 tradeStrategy="240돌파", market="코스닥")
# insertTradeData(name="NHN한국사이버결제", price=22400, quantity=35, tradeType="매수",
#                 tradeStrategy="예쁜차트", market="코스닥")
# 
# insertTradeStrategyData("장기투자", "회사 영업이익이 상승중이고, 부채비율이 낮고, 내가 많이 들어본 회사")
# insertTradeStrategyData("장대양봉", "120일선 위에서 거래대금 300억 이상으로 장대양봉이 나오면, 장대양봉의 중심에서 매수 시작")
# saveData()
# _______________________________________________________

# _______________________________________________________
# Tue Jan 21 22:01:17 2020 ------------------------------
# stockData[, market := ""]
# tradeData[, account := ""]
# 
# insertTradeData(name="기아차", price=41400, quantity=20, tradeType="매수",
#                 tradeStrategy="20일밑꼬리", market="코스피", account="나무")
# insertTradeData(name="SK바이오랜드", price=23300, quantity=30, tradeType="매수",
#                 tradeStrategy="장대양봉", market="코스닥", account="미래")
# 
# saveData()
# _______________________________________________________

# _______________________________________________________
# Fri Jan 22 08:46:12 2020 ------------------------------
insertTradeData(name="NHN한국사이버결제", date="2020-01-22", price=23200, quantity=35, tradeType="매도",
                tradeStrategy="예쁜차트", market="코스닥", account="미래")
insertTradeData(name="삼성전자", date="2020-01-22", price=60700, quantity=10, tradeType="매수",
                tradeStrategy="장기투자", market="코스피", account="삼성")
saveData()
# _______________________________________________________





# 아직 안함.
insertTradeStrategyData("240돌파")
insertTradeStrategyData("예쁜차트")

tradeStrategyData의 abbr에 없으면 stop 나오게 수정.

# _________________________________
# SEND MAIL ####
# _________________________________
# sendmail(from="<nerchaos2@korea.ac.kr>", to="<nerochaos9@naver.com>",
#         msg="hello", subject="hi", control=list(smtpServer="ASPMX.L.GOOGLE.COM"))
