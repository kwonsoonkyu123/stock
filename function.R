# ______________________________
# LIBRARY ####
# ______________________________
# install.packages("data.table")
# install.packages("mailR")
library(data.table)
# library(mailR)


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
    detail <- readline(prompt="Enter reason to buy detail")
    insertStockData(name=name, goalPrice=goalPrice, sellPrice=sellPrice,
                    buyPrice=buyPrice, lossPrice=lossPrice, tradeStrategy=tradeStrategy, date=as.Date(date)
                    , market=market, detail=detail)
  }
  
  tradeData <<- rbind(tradeData,
                      list(date=as.Date(date), name=name, price=price, quantity=quantity, totalPrice=price*quantity,
                           tradeType=tradeType, tradeStrategy=tradeStrategy, market=market,
                           account=account))
  updateBalancedData(name, tradeStrategy, price*quality, quantity, price, market)
}

insertStockData <- function(data=stockData, name, goalPrice=0, sellPrice, buyPrice, lossPrice, tradeStrategy,
                            date, market, detail) {
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
                           market=market,
                           detail=detail
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

getTotalProfit <- function(profitType="month", tradeStrategyToGet, startDate, endDate) {
  
  profitTypeList <- c("month", "week", "day", "total")
  
  if (!profitType %in% profitTypeList) {
    stop(paste0("profitType must be ", paste(profitTypeList, collapse=" or ")))
  }
  
  profitData <- tradeData[date >= as.Date(startDate) 
                          & date <= as.Date(endDate)
                          & tradeStrategy == tradeStrategyToGet]
  
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
                     profitRatio = paste0(round(((averageSellPrice - averageBuyPrice) / averageBuyPrice * 100), 2), "%"))]
  
  print(profitData)
  # 지금은 종목별인데 전체에 대한 합계도 구해야 함.
}

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
  initBalancedData <- data.table(name=character()
                                 , tradeStrategy=character()
                                 , totalPrice=numeric()  
                                 , totalQuantity=numeric() 
                                 , averagePrice=numeric()  
                                 , market=character())
  lapply(1:nrow(tradeData), function(row) {
    name_temp <- tradeData[row, name]
    tradeStrategy_temp <- tradeData[row, tradeStrategy]
    price_temp <- tradeData[row, price]
    quantity_temp <- tradeData[row, (quantity = ifelse(tradeType=="매수", quantity, -quantity))]
    tradeType_temp <- tradeData[row, tradeType]
    market_temp <- tradeData[row, market]
    
    # balancedData에 있는 종목이면
    if (paste(name_temp, tradeStrategy_temp) %in% initBalancedData[, paste(name, tradeStrategy)]) {
      initBalancedData[name==name_temp & tradeStrategy==tradeStrategy_temp, `:=`
                       (totalQuantity = totalQuantity + quantity_temp,
                         totalPrice = totalPrice + ifelse(tradeType=="매수", price_temp * quantity_temp
                                                          , averagePrice * quantity_temp))]
      initBalancedData[name==name_temp & tradeStrategy==tradeStrategy_temp, `:=`
                       (averagePrice = totalPrice / totalQuantity)]
    } else { # balancedData에 없는 종목이면
      initBalancedData <<- rbind(initBalancedData,
                                 list(
                                   name=name_temp
                                   , tradeStrategy=tradeStrategy_temp
                                   , totalPrice=price * quantity_temp
                                   , totalQuantity=quantity_temp
                                   , averagePrice=price_temp
                                   , market=market_temp
                                 ))
    }
  })
  return (initBalancedData[totalQuantity != 0])
}


getAnnualizedReturn <- function() {
  # 연수익률로 환산 : 수익률 * 보유기간 / 365
}


saveData <- function() {
  fwrite(tradeData, "./manage_stock/data/종목거래데이터.csv")
  fwrite(balancedData, "./manage_stock/data/잔고데이터.csv")
  fwrite(stockData, "./manage_stock/data/종목관리데이터.csv")
  fwrite(tradeStrategyData, "./manage_stock/data/매매전략데이터.csv")
}

loadData <- function() {
  tradeData <<- fread("./manage_stock/data/종목거래데이터.csv")
  tradeData[, date := as.Date(date)]
  balancedData <<- fread("./manage_stock/data/잔고데이터.csv")
  stockData <<- fread("./manage_stock/data/종목관리데이터.csv")
  stockData[, date := as.Date(date)]
  tradeStrategyData <<- fread("./manage_stock/data/매매전략데이터.csv")
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
  shell('git config --global user.name "John Doe"')
  shell('git config --global user.email "nerochaos2@korea.ac.kr')
  
  if (length(files)==0) {
    shell("git add --all")
    shell(paste0('git commit -m "', msg, '"'))
    shell("git push origin master")
  }
  shell(paste0('git add ', paste(files, collapse=" ")))
  shell(paste0('git commit -m "', msg, '"'))
  shell("git push origin master")
}