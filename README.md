# UIRES — University Internship Readiness Expert System

A rule-based expert system that helps university students self-assess their readiness to apply for industrial training (internships), built for WID2001 Knowledge Representation and Reasoning at Universiti Malaya (FSKTM).

## Overview

Students often get rejected from internship applications due to gaps they can't see themselves — an incomplete resume, missing documents, weak technical proficiency, or poor interview preparation. UIRES simulates the decision-making of an Industrial Training Coordinator, using a CLIPS-powered inference engine to audit a student's profile across six readiness dimensions and return a classification with actionable, prioritized recommendations.

## Problem

- Students face a cycle of rejection due to hidden gaps in resumes, projects, and interview readiness relative to industry benchmarks.
- No existing academic advisory tool treats internship readiness as a combined academic, documentary, technical, and behavioural problem — most systems focus narrowly on course selection, scholarships, or general career guidance.
- CGPA alone is an insufficient predictor of readiness; a multi-factor assessment is needed.

## Approach

**Six readiness dimensions** were formalised into IF–THEN rules within the knowledge base:

| Dimension | Values | Rationale |
|---|---|---|
| CGPA | <2.00 / 2–3 / >3.00 | Minimum threshold set by most industry partners |
| Resume status | Missing / Incomplete / Complete | Primary screening document for employers |
| Technical skills | None / Basic / Proficient | ICT partners require demonstrable competencies |
| Project portfolio | 0 / 1 / 2+ | Applied capability beyond coursework |
| Required documents | Missing / Incomplete / Complete | Admin docs must be complete before applying |
| Interview prep | No / Partially / Yes | Key weak point for graduates |

**Inference strategy:** forward chaining — student-supplied facts are asserted, rules fire against them, and a conclusion is derived. Rules run in two waves:

1. **Wave 1 — Flag rules.** Each dimension is checked against critical thresholds (e.g. CGPA < 2.00, missing resume, no technical skills, missing documents) and minor thresholds (e.g. medium CGPA, incomplete resume, basic skills).
2. **Wave 2 — Conclusion rules.** Any critical flag → `Not Ready`. No critical flags but at least one minor flag → `Partially Ready`. No flags at all → `Ready to Apply`.

**Knowledge base validation:** the rule set was elicited through a semi-structured interview with the FSKTM Industrial Training Coordinator, then reviewed and validated by the same subject matter expert for accuracy against current placement requirements and industry expectations.

## Architecture

```
User Interface (HTML + JS)          Backend (Flask)
- 6 radio-button questions    <-->  - Receives POST request
- Progress bar                      - Validates all six fields
- Renders result banner             - Returns conclusion, flags, recommendations
        ^                                    |
        |                                    v
Knowledge Base (rules.clp)   <-->   Inference Engine (CLIPS)
- Domain rules, read-only           - New environment per request (stateless)
  at runtime                        - Stores working memory during inferencing
                                     - Forward chaining with salience ordering
```

- **Knowledge base (`rules.clp`):** deftemplates for `student`, `flag`, `recommendation`, and `conclusion`; 4 templates, 11 flag rules, 3 conclusion rules.
- **Inference engine:** CLIPS, invoked fresh per request so the system is fully stateless.
- **Backend:** Flask — validates input, asserts facts, runs inference, collects the conclusion/flags/recommendations into a JSON response.
- **Frontend:** static HTML/JS — collects answers, POSTs to the API, renders a colour-coded readiness banner with a numbered action plan.

## Output

Students are classified into one of three tiers:

- **Ready to Apply** — all six readiness criteria fulfilled.
- **Partially Ready** — one or two gaps identified, with targeted recommendations.
- **Not Ready Yet** — significant gaps detected, with a prioritized action plan.

## Tech stack

- Python / Flask (backend API)
- CLIPS (rule-based inference engine)
- HTML, CSS, JavaScript (frontend)

## Testing

Validated through 8 scenario-based test cases, including system health checks, a fully-ready student profile, minor-issue and multiple-minor-issue profiles, a not-ready profile, missing-field handling, and invalid-value handling.

| Scenario | Expected | Result |
|---|---|---|
| Fully prepared student | Ready | Passed |
| One minor issue | Partial | Passed |
| Multiple minor issues | Partial | Passed |
| Major weaknesses | Not Ready | Passed |
| Missing required field | 400 error | Passed |
| Invalid input values | Rejected | Failed (known limitation) |

## Known limitations

- Backend does not currently reject out-of-range/invalid input values (accepts only expected values by convention, not enforcement).
- Frontend has minor text-encoding issues with special characters.

## Future work

- Stricter backend input validation.
- Hybrid rule-based + LLM engine for more natural, generative feedback.
- Real-time job-matching based on verified readiness scores.
- Dashboard for industry panels to update the knowledge base as market trends evolve.

## Course context

Developed for **WID2001 Knowledge Representation and Reasoning**, Faculty of Computer Science and Information Technology (FSKTM), Universiti Malaya, as a group project applying rule-based expert system design and forward-chaining inference to a real institutional problem — supporting SDG 4 (Quality Education) and SDG 8 (Decent Work and Economic Growth).

## Team

- Dennis Aimin Oon Bin jeffrey Oon — Knowledge Engineer
- Muhammad Imran Bin Ilias — Programmer
- Muhammad Aiman Bin Sharuddin — Domain Expert
- Ahmad Firdaus Bin Ahmad Hafiz — Project Manager
- Adib Rusyaidi Bin Mohd Zaki — End User
