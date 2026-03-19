from flask import Flask, render_template, request

app = Flask(__name__)

@app.route("/", methods = ["GET", "POST"])

def index():
    return("<h2>Hi</h2>")

if __name__ == "__main__":
    app.run()