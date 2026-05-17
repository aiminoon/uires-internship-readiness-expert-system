;;; ============================================================
;;; Internship Readiness Expert System - CLIPS Rules
;;; ============================================================

(deftemplate student
  (slot cgpa)         ; low | medium | high
  (slot resume)       ; missing | incomplete | complete
  (slot skills)       ; none | basic | proficient
  (slot portfolio)    ; zero | one | two-plus
  (slot documents)    ; missing | incomplete | complete
  (slot interview))   ; no | partial | yes

(deftemplate flag
  (slot name)
  (slot severity))    ; critical | minor

(deftemplate recommendation
  (slot text))

(deftemplate conclusion
  (slot level))       ; ready | partial | not-ready

;;; ============================================================
;;; DISQUALIFYING (CRITICAL) FLAGS
;;; ============================================================

(defrule flag-cgpa-low
  (student (cgpa low))
  =>
  (assert (flag (name cgpa-low) (severity critical)))
  (assert (recommendation (text "Improve your CGPA to at least 2.00. Focus on your weakest subjects, seek tutoring, and consult your academic advisor for a study plan."))))

(defrule flag-resume-missing
  (student (resume missing))
  =>
  (assert (flag (name resume-missing) (severity critical)))
  (assert (recommendation (text "Create a professional resume immediately. Use templates from resources like Canva, Overleaf, or your university's career centre. Include your education, skills, and any experience."))))

(defrule flag-skills-none
  (student (skills none))
  =>
  (assert (flag (name skills-none) (severity critical)))
  (assert (recommendation (text "Build at least basic technical skills relevant to your field. Enrol in free courses on Coursera, edX, or YouTube. Even one recognised certification can significantly boost your profile."))))

(defrule flag-documents-missing
  (student (documents missing))
  =>
  (assert (flag (name documents-missing) (severity critical)))
  (assert (recommendation (text "Prepare all required application documents (transcripts, IC copy, offer letter acceptance form, etc.). Check with your faculty's industrial training unit for the complete checklist."))))

;;; ============================================================
;;; IMPROVEMENT (MINOR) FLAGS
;;; ============================================================

(defrule flag-cgpa-medium
  (student (cgpa medium))
  =>
  (assert (flag (name cgpa-medium) (severity minor)))
  (assert (recommendation (text "Your CGPA is acceptable but aim to raise it above 3.00. A higher CGPA opens doors to more competitive internship placements."))))

(defrule flag-resume-incomplete
  (student (resume incomplete))
  =>
  (assert (flag (name resume-incomplete) (severity minor)))
  (assert (recommendation (text "Complete your resume. Ensure it includes a strong summary, all technical skills, relevant projects, and is tailored to the internship role you are applying for."))))

(defrule flag-skills-basic
  (student (skills basic))
  =>
  (assert (flag (name skills-basic) (severity minor)))
  (assert (recommendation (text "Advance your technical skills from basic to proficient. Work on hands-on projects, contribute to open-source, or complete an advanced certification to demonstrate competency."))))

(defrule flag-portfolio-zero
  (student (portfolio zero))
  =>
  (assert (flag (name portfolio-zero) (severity critical)))
  (assert (recommendation (text "Build at least one project to showcase your skills. It can be a personal project, a university assignment, or a contribution to open-source. Upload it to GitHub and document it properly."))))

(defrule flag-portfolio-one
  (student (portfolio one))
  =>
  (assert (flag (name portfolio-one) (severity minor)))
  (assert (recommendation (text "Having one project is a good start, but aim for two or more. A richer portfolio demonstrates consistency and initiative to potential employers."))))

(defrule flag-documents-incomplete
  (student (documents incomplete))
  =>
  (assert (flag (name documents-incomplete) (severity minor)))
  (assert (recommendation (text "Complete all required documents before submitting your application. Missing documents can cause your application to be rejected outright."))))

(defrule flag-interview-no
  (student (interview no))
  =>
  (assert (flag (name interview-no) (severity critical)))
  (assert (recommendation (text "Begin interview preparation now. Practice common technical and behavioural questions, research the company, and do mock interviews with peers or your career centre."))))

(defrule flag-interview-partial
  (student (interview partial))
  =>
  (assert (flag (name interview-partial) (severity minor)))
  (assert (recommendation (text "Continue strengthening your interview preparation. Practise answering the STAR method for behavioural questions and solve technical problems on platforms like LeetCode or HackerRank."))))

;;; ============================================================
;;; CONCLUSION RULES (run after flags)
;;; ============================================================

(defrule conclude-not-ready
  (declare (salience -10))
  (flag (severity critical))
  =>
  (assert (conclusion (level not-ready))))

(defrule conclude-partial
  (declare (salience -20))
  (not (conclusion (level not-ready)))
  (flag (severity minor))
  =>
  (assert (conclusion (level partial))))

(defrule conclude-ready
  (declare (salience -30))
  (not (conclusion (level not-ready)))
  (not (conclusion (level partial)))
  =>
  (assert (conclusion (level ready))))
