from flask import Flask, render_template, request, session

app = Flask(__name__)
app.secret_key = "sc6106_demo_secret_key"

@app.route("/", methods = ["GET", "POST"])
def index():
    return(render_template("index.html"))

@app.route("/main", methods = ["GET", "POST"])
def main():
    if request.method == "POST":
        user_name = (request.form.get("q") or "").strip()
        if user_name:
            session["user_name"] = user_name

    return(render_template("main.html", user_name=session.get("user_name", "")))

@app.route("/transferMoney", methods = ["GET", "POST"])
def transferMoney():
    return(render_template("transferMoney.html", user_name=session.get("user_name", "")))

@app.route("/depositMoney", methods = ["GET", "POST"])
def depositMoney():
    return(render_template("depositMoney.html"))

@app.route("/userManager", methods = ["GET", "POST"])
def userManager():
    return(render_template("userManager.html", user_name=session.get("user_name", "")))

@app.route("/messageBoard", methods = ["GET", "POST"])
def messageBoard():
    return(render_template("messageBoard.html"))

if __name__ == "__main__":
    app.run()