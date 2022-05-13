from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return '==============================\n<br>Hello, World! This is Praveen\n<br>This is new Production<br>==============================\n<br>'

if __name__ == "__main__":
    app.runRemove(host='0.0.0.0', port=8080, debug=True)
    
