from flask import Flask, render_template, request

app = Flask(__name__)

@app.route("/", methods = ["GET", "POST"])
def index():
    return(render_template("index.html"))

@app.route("/main", methods = ["GET", "POST"])
def main():
    return(render_template("main.html"))

@app.route("/transferMoney", methods = ["GET", "POST"])
def transferMoney():
    return(render_template("transferMoney.html"))

@app.route("/depositMoney", methods = ["GET", "POST"])
def depositMoney():
    return(render_template("depositMoney.html"))

@app.route("/userManager", methods = ["GET", "POST"])
def userManager():
    return(render_template("userManager.html"))

@app.route("/messageBoard", methods = ["GET", "POST"])
def messageBoard():
    return(render_template("messageBoard.html"))

if __name__ == "__main__":
    app.run()