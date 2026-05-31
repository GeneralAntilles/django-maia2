# Web-based MAIA questionnaire

The [Multidimensional Assessment of Interoceptive Awaraness questionnaire](https://osher.ucsf.edu/research/maia) is a multidimensional self-report measure of interoceptive body awareness, the individual's awareness of and ability to sense internal bodily signals. This is a web-based version of the questionnaire built with Django.

The [official questionnaire](https://osher.ucsf.edu/sites/osher.ucsf.edu/files/inline-files/MAIA2%202018.05.27.pdf) is a PDF document that requires manual scoring and I built this to make it easier to take and score the questionnaire.

<p align="center">
<img src="documentation/images/survey-preview.png" alt="Survey preview" width="500"/>
<img src="documentation/images/results-preview.png" alt="Results preview" width="500"/>
</p>

## MAIA Version 2

MAIA Version 2 is a 37-item quistionnaire that assesses various dimensions of interoceptive awareness using a six-point Likert scale, ranging from 0 (never) to 5 (always). The questionnaire is divided into eight subcales, each addressing a specific aspect of interoceptive awareness:

1. **Noticing**: The ability to sense and recognize bodily sensations.
2. **Not-Distracting**: The tendency to divert attention away from uncomfortable bodily sensations.
3. **Not-Worrying**: The inclination to experience emotional distress in response to bodily sensations.
4. **Attention Regulation**: The ability to sustain and control attention to bodily sensations.
5. **Emotional Awareness**: The ability to link bodily sensations with emotional states.
6. **Self-Regulation**: The capacity to regulate psychological and emotional responses based on bodily sensations.
7. **Body Listening**: The propensity to actively listen and respond to the body's needs.
8. **Trusting**: The confidence in one's ability to interpret and respond to bodily signals appropriately.

MAIA has been employed in various research contexts, such as studying the relationship between interoceptive awareness and mental health, investigating the role of interoception in mindfulness practices, and understanding how interoceptive awareness may contribute to the development and treatment of different psychological disorders.

## Comparison data

### Papers

1. [The Multidimensional Assessment of Interoceptive Awareness, Version 2 (MAIA-2)](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0208034) - 1,090 museum visitors.
2. [Validation of the Multidimensional Assessment of Interoceptive Awareness (MAIA-2) questionnaire in hospitalized patients with major depressive disorder](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0253913) - 110 hospitalized patients with major depressive disorder (German).
3. [Examining the Factor Structure and Validity of the Multidimensional Assessment of Interoceptive Awareness](https://doi.org/10.1080/00223891.2020.1813147) - 644 and 1,516 participants from two studies gathered social media sources and an online newspaper covering psychology-related subjects, respectively.

## Installation

`django-maia2` is a reusable Django app. Install it and add it to a project:

    pip install git+https://github.com/GeneralAntilles/django-maia2

The host project must include these in `INSTALLED_APPS` alongside `maia_v2`:
`django.contrib.sites`, `django.contrib.humanize`, `crispy_forms`,
`crispy_bootstrap5`, `rest_framework`, and `meta` (django-meta). Set `SITE_ID`
and run the `sites` migrations — the app reads `Site.objects.get_current()` at
runtime. Set `CRISPY_TEMPLATE_PACK = "bootstrap5"`.

Include the app's URLs, then migrate and load the data:

    # urls.py
    path("", include("maia_v2.urls")),

    python manage.py migrate
    python manage.py seed_maia2   # questionnaire, 8 subscales, 37 items, norms

To wrap the questionnaire pages in your own site chrome, provide a
`templates/maia_v2/base.html` in a project template dir; it overrides the app's
default base (which defines the `head_title`, `content`, `css`, and `js`
blocks). See `tests/` for a minimal working project.

## Licensing

The application code is MIT-licensed (see `LICENSE`). The MAIA-2 **item text**
bundled in `maia_v2/fixtures/maia2_questions.json` is © 2018 University of
California San Francisco, included under UCSF's free-use terms and **not**
covered by the MIT license — see `maia_v2/fixtures/MAIA2_NOTICE.txt`.
