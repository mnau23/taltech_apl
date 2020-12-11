#!/usr/bin/python3

import json
from antlr4 import *
from gen.csvLexer import csvLexer
from gen.csvParser import csvParser
from CSVConvListener import CSVConvListener

CSV_FILE = 'dataset/us-1.csv'
#CSV_FILE = 'dataset/us-500.csv'
JSON_FILE = 'output.json'

def main():
    # Read the input file
    input_file = FileStream(CSV_FILE)
    print('Please wait, converting...')

    # Build a lexer
    lexer = csvLexer(input_file)

    # Run lexer on the file to generate the token string
    stream = CommonTokenStream(lexer)

    # Parse the token stream
    parser = csvParser(stream)

    # Create a parse tree
    tree = parser.csv_file()

    # Walk the tree
    conv_listener = CSVConvListener()
    walker = ParseTreeWalker()
    walker.walk(conv_listener, tree)

    # Read the parsed data
    parsed_data = conv_listener.get_parsed_data()
    print(parsed_data)

    # Write the JSON file
    with open(JSON_FILE, 'w') as json_file:
        json.dump(parsed_data, json_file, indent=4, sort_keys=True)

if __name__ == '__main__':
    main()
