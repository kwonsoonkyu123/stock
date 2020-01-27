import sys
from PyQt5.QtWidgets import *
from PyQt5.QtGui import  *
from PyQt5.QAxContainer import *
import time

class MyWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.kw = Kiwoom()

        # Kiwoom Login
        self.kiwoom = QAxWidget("KHOPENAPI.KHOpenAPICtrl.1")
        self.kiwoom.dynamicCall("CommConnect()")
        self.kiwoom.OnReceiveConditionVer.connect(self.receive_condition)

        # OpenAPI+ Event
        self.kiwoom.OnEventConnect.connect(self.event_connect)
        self.kiwoom.OnReceiveTrData.connect(self.receive_trdata)
        self.kiwoom.OnReceiveTrCondition.connect(self.receive_condition_list)

        self.setWindowTitle("PyStock")
        self.setGeometry(300, 300, 1000, 300)

        label = QLabel('종목코드: ', self)
        label.move(20, 20)

        self.code_edit = QLineEdit(self)
        self.code_edit.move(80, 20)
        self.code_edit.setText("039490")

        search_btn = QPushButton("조회", self)
        search_btn.move(190, 20)
        search_btn.clicked.connect(self.search_clicked)

        acc_btn = QPushButton("계좌정보", self)
        acc_btn.move(300, 20)
        acc_btn.clicked.connect(self.acc_clicked)

        list_btn = QPushButton("종목리스트", self)
        list_btn.move(410, 20)
        list_btn.clicked.connect(self.list_clicked)

        balance_btn = QPushButton("예수금/잔고", self)
        balance_btn.move(520, 20)
        balance_btn.clicked.connect(self.balance_clicked)

        holding_btn = QPushButton("보유종목", self)
        holding_btn.move(630, 20)
        holding_btn.clicked.connect(self.holding_clicked)

        prog_trade_btn = QPushButton("프로그램매매", self)
        prog_trade_btn.move(740, 20)
        prog_trade_btn.clicked.connect(self.prog_trade_clicked)

        test_btn = QPushButton("테스트", self)
        test_btn.move(850, 20)
        test_btn.clicked.connect(self.test_clicked)

        self.text_edit = QTextEdit(self)
        self.text_edit.setGeometry(10, 60, 390, 220)
        self.text_edit.setEnabled(False)

        self.listWidget = QListWidget(self)
        self.listWidget.setGeometry(410, 60, 170, 220)

    def event_connect(self, err_code):
        if err_code == 0:
            self.text_edit.append("로그인 성공")

    def search_clicked(self):
        code = self.code_edit.text()
        self.text_edit.append("종목코드: " + code)

        # SetInputValue
        self.kiwoom.dynamicCall("SetInputValue(QString, QString)", "종목코드", code)

        # CommRqData
        self.kiwoom.dynamicCall("CommRqData(QString, QString, int, QString)", "종목검색", "opt10007", 0, "0101")

    def acc_clicked(self):
        account_num = self.kiwoom.dynamicCall("GetLoginInfo(QString)", ["ACCNO"])
        self.text_edit.append("계좌번호 : " + account_num.strip())

    def list_clicked(self):
        ret = self.kiwoom.dynamicCall("GetCodeListByMarket(QString)", ["0"])
        kospi_code_list = ret.split(";")
        kospi_code_name_list = []

        for kospi_code in kospi_code_list:
            name = self.kiwoom.dynamicCall("GetMasterCodeName(QString)", [kospi_code])
            kospi_code_name_list.append(kospi_code + " : " + name)

        self.listWidget.addItems(kospi_code_name_list)

    def balance_clicked(self):
        account_num = self.code_edit.text()
        self.kiwoom.dynamicCall("SetInputValue(QString, QString)", "계좌번호", account_num.strip())
        self.kiwoom.dynamicCall("CommRqData(QString, QString, int, QString)", "예수금상세현황요청", "opw00001", 0, "0101")

    def holding_clicked(self):
        account_num = self.code_edit.text()
        self.kiwoom.dynamicCall("SetInputValue(QString, QString)", "계좌번호", account_num.strip())
        self.kiwoom.dynamicCall("CommRqData(QString, QString, int, QString)", "보유종목", "opt10085", 0, "0101")

    def prog_trade_clicked(self):
        ret = self.kiwoom.dynamicCall("GetCodeListByMarket(QString)", ["0"])
        kospi_code_list = ret.split(";")

        for kospi_code in kospi_code_list:
            pass

    def test_clicked(self):
        ret = self.kiwoom.dynamicCall("GetConditionLoad()")

    def receive_condition(self):
        cond_name_list = self.kiwoom.dynamicCall("GetConditionNameList()")
        cond_name_list_array = cond_name_list.rstrip(";").split(";")

        self.text_edit.append(str(cond_name_list_array[0]))
        for cond_name in cond_name_list_array:
            index, name = cond_name.split("^")
            self.kiwoom.dynamicCall("SendCondition(QString, QString, int, int)", "0101", name, index, 0)

    def receive_condition_list(self, sScrNo, strCodeList, strConditionName, nIndex, nNext):
        # 매수
        strCodeList = strCodeList.split(";")
        self.text_edit.append(str(strCodeList))
        for strCode in strCodeList:
            if strCode != "":
                self.kiwoom.dynamicCall("SetInputValue(QString, QString)", "종목코드", strCode)
                price = self.kiwoom.dynamicCall("CommRqData(QString, QString, int, QString)", "매수전가격확인", "opt10007", 0, "0101")
                self.text_edit.append("가격 :" + str(price))
                if int(price) > 10000:
                    quan = 1
                else:
                    quan = 10000 // price
                self.kiwoom.dynamicCall("SendOrder(QString, QString, QString, int, QString, int, int, QString, QString)", "매수주문", "0101", "8128413111", 1, strCode, quan, 0, "03", "")

                time.sleep(0.2)

    def receive_trdata(self, screen_no, rqname, trcode, recordname, prev_next, data_len, err_code, msg1, msg2):
        if rqname == "종목검색":
            name = self.kiwoom.dynamicCall("GetCommData(QString, QString, int, QString)", trcode, rqname, 0, "종목명")
            volume = self.kiwoom.dynamicCall("GetCommData(QString, QString, int, QString)", trcode, rqname, 0, "거래량")
            trAmt = self.kiwoom.dynamicCall("GetCommData(QString, QString, int, QString)", trcode, rqname, 0, "거래대금")
            openPrice = self.kiwoom.dynamicCall("GetCommData(QString, QString, int, QString)", trcode, rqname, 0, "시가")
            closePrice = self.kiwoom.dynamicCall("GetCommData(QString, QString, int, QString)", trcode, rqname, 0, "현재가")
            maxPrice = self.kiwoom.dynamicCall("GetCommData(QString, QString, int, QString)", trcode, rqname, 0, "고가")
            minPrice = self.kiwoom.dynamicCall("GetCommData(QString, QString, int, QString)", trcode, rqname, 0, "저가")

            self.text_edit.append("종목명: " + name.strip())
            self.text_edit.append("거래량: " + volume.strip())
            self.text_edit.append("거래대금: " + trAmt.strip()[:2] + "억")
            self.text_edit.append("시가: " + openPrice.strip())
            self.text_edit.append("종가: " + closePrice.strip())
            self.text_edit.append("고가: " + maxPrice.strip())
            self.text_edit.append("저가: " + minPrice.strip())
        elif rqname == "예수금상세현황요청":
            balance = int(self.kiwoom.dynamicCall("GetCommData(QString, QString, int, QString)", trcode, rqname, 0, "주문가능금액").strip())
            balance = str(balance // 100000000) + "억원" if balance >= 100000000 else str(balance // 10000) + "만원"
            self.text_edit.append("예수금 : " + balance)
        elif rqname == "보유종목":
            holding = self.kiwoom.dynamicCall("GetCommData(QString, QString, int, QString)", trcode, rqname, 0, "종목명")

            self.text_edit.append("종목명: " + holding.strip())
        elif rqname == "매수전가격확인":
            price = self.kiwoom.dynamicCall("GetCommData(QString, QString, int, QString)", trcode, rqname, 0, "현재가").strip()
            self.text_edit.append("가격ㄱㄱ :" + price)
            return price



if __name__ == "__main__":
    app = QApplication(sys.argv)
    myWindow = MyWindow()
    myWindow.show()
    app.exec_()