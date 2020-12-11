from gen.csvListener import csvListener
from gen.csvParser import csvParser

class CSVConvListener(csvListener):
    def __init__(self):
        self.is_header = False
        self.header_fields = list()
        self.curr_row_fields = list()
        self.data_buffer = list()

    def get_parsed_data(self):
        return self.data_buffer

    def append_field_to_row(self, fieldData):
        if self.is_header:
            self.header_fields.append(fieldData)
            print(fieldData)
        else:
            self.curr_row_fields.append(fieldData)

    # Enter a parse tree produced by csvParser#hdr.
    def enterHdr(self, ctx:csvParser.HdrContext):
        print('Enter header')
        self.is_header = True

    # Exit a parse tree produced by csvParser#hdr.
    def exitHdr(self, ctx:csvParser.HdrContext):
        print('Exit header')
        self.is_header = False

    # Enter a parse tree produced by csvParser#row.
    def enterRow(self, ctx:csvParser.RowContext):
        print('Enter row')
        self.curr_row_fields = list()

    # Exit a parse tree produced by csvParser#row.
    def exitRow(self, ctx:csvParser.RowContext):
        print('Exit row')
        if not self.is_header:
            row_data = dict()
            for i, field in enumerate(self.curr_row_fields):
                row_data[self.header_fields[i]] = field
            self.data_buffer.append(row_data)

    # Exit a parse tree produced by csvParser#number.
    def exitNumber(self, ctx:csvParser.NumberContext):
        self.append_field_to_row(int(ctx.getText()))

    # Exit a parse tree produced by csvParser#string.
    def exitString(self, ctx:csvParser.StringContext):
        self.append_field_to_row(ctx.getText().replace('"', ''))

    # Exit a parse tree produced by csvParser#empty.
    def exitEmpty(self, ctx:csvParser.EmptyContext):
        self.append_field_to_row('')
