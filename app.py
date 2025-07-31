from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    print("This is a hello world app")
    return "Hello, Worlds!"
    
