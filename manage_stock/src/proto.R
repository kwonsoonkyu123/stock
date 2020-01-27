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