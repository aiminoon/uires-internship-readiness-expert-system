from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import clips
import os

app = Flask(__name__)
CORS(app)

RULES_PATH = os.path.join(os.path.dirname(__file__), "rules.clp")


@app.route("/", methods=["GET"])
def index():
    return send_from_directory(os.path.dirname(__file__), "index.html")


@app.route("/favicon.ico", methods=["GET"])
def favicon():
    return ("", 204)

def run_expert_system(cgpa, resume, skills, portfolio, documents, interview):
    env = clips.Environment()
    env.load(RULES_PATH)
    env.reset()

    # Assert the student fact
    fact_str = (
        f"(student "
        f"(cgpa {cgpa}) "
        f"(resume {resume}) "
        f"(skills {skills}) "
        f"(portfolio {portfolio}) "
        f"(documents {documents}) "
        f"(interview {interview}))"
    )
    env.assert_string(fact_str)
    env.run()

    # Collect results
    conclusion_level = None
    recommendations = []
    flags = []

    for fact in env.facts():
        tmpl = fact.template.name
        if tmpl == "conclusion":
            conclusion_level = fact["level"]
        elif tmpl == "recommendation":
            recommendations.append(fact["text"])
        elif tmpl == "flag":
            flags.append({"name": fact["name"], "severity": fact["severity"]})

    return {
        "conclusion": conclusion_level,
        "flags": flags,
        "recommendations": recommendations
    }


@app.route("/evaluate", methods=["POST"])
def evaluate():
    data = request.get_json()
    required = ["cgpa", "resume", "skills", "portfolio", "documents", "interview"]
    for field in required:
        if field not in data:
            return jsonify({"error": f"Missing field: {field}"}), 400

    result = run_expert_system(
        cgpa=data["cgpa"],
        resume=data["resume"],
        skills=data["skills"],
        portfolio=data["portfolio"],
        documents=data["documents"],
        interview=data["interview"]
    )
    return jsonify(result)


@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok"})


if __name__ == "__main__":
    app.run(debug=True, port=5050)
