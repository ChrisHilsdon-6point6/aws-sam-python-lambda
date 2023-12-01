import sys
import logging4

class Main:
    def __init__(self):
        formatter = '[[time]] - [[name]] - [[level_name]] - [[msg]]'

        logger = logging4.Logger(name="MyLogger")
        logger.add_channel(filename=sys.stdout, level=logging4.ERROR, formatter=formatter)
        

        logger.info('logger info message')
        print('main class loaded!')
    
    def _test_function():
        print('Running test function!')