#!/usr/bin/python3

from antlr4 import *
from xml.dom import minidom
from gen.jsonLexer import jsonLexer
from gen.jsonParser import jsonParser
from JSONConvListener import JSONConvListener

JSON_FILE = 'data.json'
XML_FILE = 'output.xml'

def main():
    # Read the input file
    input_file = FileStream(JSON_FILE)
    print('Please wait, converting...\n')

    # Build a lexer
    lexer = jsonLexer(input_file)

    # Run lexer on the file to generate the token string
    stream = CommonTokenStream(lexer)

    # Parse the token stream
    parser = jsonParser(stream)

    # Create a parse tree
    tree = parser.json_file()

    # Walk the tree
    conv_listener = JSONConvListener()
    walker = ParseTreeWalker()
    walker.walk(conv_listener, tree)

    # Read the parsed data
    parsed_data = conv_listener.get_parsed_data()

    # Convert list to string
    pdata_str = ' '.join(map(str, parsed_data))

    # Prettify string for XML format
    xml = minidom.parseString(pdata_str)
    pretty_xml = xml.toprettyxml()
    print(pretty_xml)

    # Open the XML file
    with open(XML_FILE, "w") as xml_file:
        xml_file.write(pretty_xml)

    print('\nFile converted.')

if __name__ == '__main__':
    main()
