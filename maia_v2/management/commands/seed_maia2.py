from django.core.management import call_command
from django.core.management.base import BaseCommand, CommandError
from django.db import transaction

from maia_v2.models import Questionnaire


class Command(BaseCommand):
    help = (
        "Seed the MAIA-2 questionnaire, its 8 subscale categories, the 37 "
        "items, and the published comparison norms from the bundled fixtures."
    )

    @transaction.atomic
    def handle(self, *args, **options):
        # The MAIA-2 fixtures pin the questionnaire to pk=1 (the models use
        # `default=1` FKs). Refuse to clobber a different questionnaire there.
        existing = Questionnaire.objects.filter(pk=1).first()
        if existing is not None and existing.internal_name != 'maia_v2':
            raise CommandError(
                f"Questionnaire pk=1 is already '{existing.internal_name}', "
                "not 'maia_v2'. Refusing to overwrite — the MAIA-2 fixtures "
                "assume pk=1. Seed MAIA-2 into a database where pk=1 is free."
            )

        verbosity = options.get('verbosity', 1)
        call_command('loaddata', 'maia2_questions', verbosity=verbosity)
        call_command('loaddata', 'maia2_comparison_data', verbosity=verbosity)
        self.stdout.write(self.style.SUCCESS(
            'Seeded MAIA-2 questionnaire, categories, questions, and norms.'))
