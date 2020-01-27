# _________________________________
# INPUT ####
# _________________________________
loadData()
# _______________________________________________________
# Fri Jan 17 19:07:31 2020 ------------------------------
# insertTradeData(name="�Ｚȭ��", price=228500, quantity=2, tradeType="�ż�",
#                 tradeStrategy="20�Ϲز���", market="�ڽ���")
# insertTradeData(name="�ѱ����ڱ���", price=7940, quantity=70, tradeType="�ż�",
#                 tradeStrategy="�������", market="�ڽ���")
# _______________________________________________________

# _______________________________________________________
# Sun Jan 19 22:31:39 2020 ------------------------------
# stockData[, tradeStrategy := ""]
# insertStockData(name="��������", sellPrice=45000, buyPrice=40400, lossPrice=39350, tradeStrategy="20�Ϲز���")
# insertStockData(name="�����", goalPrice=45950, sellPrice=44500, buyPrice=41400, lossPrice=39950, tradeStrategy="20�Ϲز���")
# insertStockData(name="�ҿ���", goalPrice=5000, sellPrice=4625, buyPrice=4250, lossPrice=4160, tradeStrategy="20�Ϲز���")
# 
# insertStockData(name="�ιٵ�", sellPrice=25750, buyPrice=21800, lossPrice=20500, tradeStrategy="�������")
# 
# insertStockData(name="SK���̿�����", sellPrice=27300, buyPrice=23500, lossPrice=21400, tradeStrategy="�����")
# 
# insertStockData(name="�±�", sellPrice=11500, buyPrice=10800, lossPrice=10550, tradeStrategy='240����')
# 
# insertStockData(name="�ٿ쵥��Ÿ", goalPrice=8620, sellPrice=8500, buyPrice=7960, lossPrice=7720, tradeStrategy="������Ʈ")
# insertStockData(name="�ιٵ�", goalPrice=25750, sellPrice=24200, buyPrice=21800, lossPrice=20500, tradeStrategy="������Ʈ")
# 
# insertTradeStrategyData("20�Ϲز���", "20�ϼ� �ؿ��� �ز����� �ް� ���� �� �ż�, �����ֿ� ������.")
# _______________________________________________________

# _______________________________________________________
# Mon Jan 20 18:27:35 2020 ------------------------------
# stockData[, date := "2020-01-01"]
# stockData[, date := as.Date(date)]
# 
# insertTradeData(name="�Ƹ�G", price=87000, quantity=10, tradeType="�ż�",
#                 tradeStrategy="������Ʈ", market="�ڽ���")
# insertTradeData(name="�����ڿ���", price=88100, quantity=10, tradeType="�ż�",
#                 tradeStrategy="������Ʈ", market="�ڽ���")
# insertTradeData(name="�±�", price=10800, quantity=70, tradeType="�ż�",
#                 tradeStrategy="240����", market="�ڽ���")
# insertTradeData(name="NHN�ѱ����̹�����", price=22400, quantity=35, tradeType="�ż�",
#                 tradeStrategy="������Ʈ", market="�ڽ���")
# 
# insertTradeStrategyData("�������", "ȸ�� ���������� ������̰�, ��ä������ ����, ���� ���� �� ȸ��")
# insertTradeStrategyData("�����", "120�ϼ� ������ �ŷ���� 300�� �̻����� ������� ������, ������� �߽ɿ��� �ż� ����")
# saveData()
# _______________________________________________________

# _______________________________________________________
# Tue Jan 21 22:01:17 2020 ------------------------------
# stockData[, market := ""]
# tradeData[, account := ""]
# 
# insertTradeData(name="�����", price=41400, quantity=20, tradeType="�ż�",
#                 tradeStrategy="20�Ϲز���", market="�ڽ���", account="����")
# insertTradeData(name="SK���̿�����", price=23300, quantity=30, tradeType="�ż�",
#                 tradeStrategy="�����", market="�ڽ���", account="�̷�")
# 
# saveData()
# _______________________________________________________

# _______________________________________________________
# Fri Jan 22 08:46:12 2020 ------------------------------
# insertTradeData(name="NHN�ѱ����̹�����", date="2020-01-22", price=23200, quantity=35, tradeType="�ŵ�",
#                 tradeStrategy="������Ʈ", market="�ڽ���", account="�̷�")
# insertTradeData(name="�Ｚ����", date="2020-01-22", price=60700, quantity=10, tradeType="�ż�",
#                 tradeStrategy="�������", market="�ڽ���", account="�Ｚ")
# saveData()
# _______________________________________________________

# _______________________________________________________
# Mon Jan 27 11:10:49 2020 ------------------------------
stockData[, detail := ""]
insertStockData(name="�ѱ������ؾ�", goalPrice=133000, sellPrice=130000, buyPrice=120000, lossPrice=115000,
                tradeStrategy="������Ʈ", date="2020-01-27", market="�ڽ���",
                detail="12��5�� 240�� ������ ���� 240���� �ٽ� ������ �� �����")
insertStockData(name="KG�������", goalPrice=6450, sellPrice=6300, buyPrice=59000, lossPrice=5650,
                tradeStrategy="������Ʈ", date="2020-01-27", market="�ڽ���",
                detail="������ ������ 240���� �϶����̱� ������, ��Ʈ�� ���� ����. 6050���� ���� �����ϴ� ���")
saveData()
# _______________________________________________________





# ���� ����.
insertTradeStrategyData("240����")
insertTradeStrategyData("������Ʈ")

tradeStrategyData�� abbr�� ������ stop ������ ����.

# _________________________________
# SEND MAIL ####
# _________________________________
# sendmail(from="<nerchaos2@korea.ac.kr>", to="<nerochaos9@naver.com>",
#         msg="hello", subject="hi", control=list(smtpServer="ASPMX.L.GOOGLE.COM"))