from unittest.mock import patch
from psycopg2 import OperationalError as Psycopg2Error

from django.core.management import call_command
from django.db.utils import OperationalError
from django.test import SimpleTestCase


@patch('core.management.commands.wait_for_db.check')
class CommandTest(SimpleTestCase):

    def test_wait_for_db(self, patched_check):
        """Test waiting for database when database is available."""
        patched_check.return_value = True  # Simulate database being available

        call_command('wait_for_db')  # Corrected command name

        patched_check.assert_called_once_with(databases=['default'])  # Corrected argument
