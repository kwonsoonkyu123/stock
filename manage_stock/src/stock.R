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
# insertTradeData(name="NHN한국사이버결제", date="2020-01-22", price=23200, quantity=35, tradeType="매도",
#                 tradeStrategy="예쁜차트", market="코스닥", account="미래")
# insertTradeData(name="삼성전자", date="2020-01-22", price=60700, quantity=10, tradeType="매수",
#                 tradeStrategy="장기투자", market="코스피", account="삼성")
# saveData()
# _______________________________________________________

# _______________________________________________________
# Mon Jan 27 11:10:49 2020 ------------------------------
stockData[, detail := ""]
insertStockData(name="한국조선해양", goalPrice=133000, sellPrice=130000, buyPrice=120000, lossPrice=115000,
                tradeStrategy="예쁜차트", date="2020-01-27", market="코스피",
                detail="12월5일 240선 돌파한 이후 240선을 다시 지지할 때 사려고")
insertStockData(name="KG모빌리언스", goalPrice=6450, sellPrice=6300, buyPrice=5900, lossPrice=5650,
                tradeStrategy="예쁜차트", date="2020-01-27", market="코스닥",
                detail="수급이 안좋고 240선이 하락중이긴 하지만, 차트가 워낙 예쁨. 6050으로 점점 수렴하는 모습")
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
