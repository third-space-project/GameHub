from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return jsonify({
        "message": "GameHub API is running"
    })

@app.route("/api/games")
def games():
    return jsonify([
        {
            "id": 1,
            "name": "Tetris"
        }
    ])

if __name__ == "__main__":
    app.run(debug=True)
