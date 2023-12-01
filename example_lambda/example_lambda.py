from main import Main

class Example_Lambda(Main):
    def __init__(self):
        super().__init__()

    def _example_function(self):
        print('example_function')
    

def lambda_handler(event, context):
    el = Example_Lambda()
    el._example_function()
    
if __name__ == "__main__":
    el = Example_Lambda()
    el._example_function()