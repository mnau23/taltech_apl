from gen.jsonListener import jsonListener
from gen.jsonParser import jsonParser

class JSONConvListener(jsonListener):
    def __init__(self):
        self.data_buffer = list()

    def get_parsed_data(self):
        return self.data_buffer

    # Enter a parse tree produced by jsonParser#value.
    def enterValue(self, ctx: jsonParser.ValueContext):
        pass
        #print('Enter value')

    # Exit a parse tree produced by jsonParser#value.
    def exitValue(self, ctx: jsonParser.ValueContext):
        pass
        #print('Exit value')

    # Enter a parse tree produced by jsonParser#obj.
    def enterObj(self, ctx: jsonParser.ObjContext):
        pass
        #print('Enter object')

    # Exit a parse tree produced by jsonParser#obj.
    def exitObj(self, ctx: jsonParser.ObjContext):
        pass
        #print('Exit object')

    # Enter a parse tree produced by jsonParser#pair.
    def enterPair(self, ctx: jsonParser.PairContext):
        #print('Enter pair')
        open_tag = '<' + ctx.STRING().getText().replace('"','') + '>'
        #print(open_tag)
        self.data_buffer.append(open_tag)

    # Exit a parse tree produced by jsonParser#pair.
    def exitPair(self, ctx: jsonParser.PairContext):
        close_tag = '</' + ctx.STRING().getText().replace('"', '') + '>'
        #print(close_tag)
        self.data_buffer.append(close_tag)
        #print('Exit pair')

    # Enter a parse tree produced by jsonParser#arr.
    def enterArr(self, ctx: jsonParser.ArrContext):
        pass
        #print('Enter array')

    # Exit a parse tree produced by jsonParser#arr.
    def exitArr(self, ctx: jsonParser.ArrContext):
        pass
        #print('Exit array')

    # Exit a parse tree produced by jsonParser#number.
    def exitNumber(self, ctx:jsonParser.NumberContext):
        num = ctx.getText()
        #print(num)
        self.data_buffer.append(num)

    # Exit a parse tree produced by jsonParser#string.
    def exitString(self, ctx:jsonParser.StringContext):
        str = ctx.getText().replace('"', '')
        #print(str)
        self.data_buffer.append(str)
