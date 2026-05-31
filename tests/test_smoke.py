from django.test import TestCase
from django.urls import reverse


class ImportSafetyTests(TestCase):
    def test_forms_module_imports_without_querying_db(self):
        # The form builds its fields in __init__, not at class-definition time,
        # so importing the module must not touch the database. (The stronger
        # guarantee is checked by `manage.py makemigrations --check`.)
        import maia_v2.forms  # noqa: F401

        self.assertTrue(hasattr(maia_v2.forms, 'MAIAForm'))


class MAIA2SmokeTests(TestCase):
    fixtures = ['maia2_questions', 'maia2_comparison_data']

    def test_questionnaire_renders(self):
        resp = self.client.get(
            reverse('questionnaire', kwargs={'questionnaire': 'maia_v2'}))
        self.assertEqual(resp.status_code, 200)
        # First MAIA-2 item text, proving the seeded questions render.
        self.assertContains(resp, 'When I am tense')

    def test_full_submission_redirects_to_results(self):
        submit_url = reverse(
            'questionnaire-submit', kwargs={'questionnaire': 'maia_v2'})
        answers = {str(i): 3 for i in range(1, 38)}  # all 37 items
        resp = self.client.post(submit_url, answers)
        self.assertEqual(resp.status_code, 302)
        results = self.client.get(resp.url)
        self.assertEqual(results.status_code, 200)
