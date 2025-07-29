import os

def test_watchdog_exists():
    assert os.path.isfile('watchdog.sh')
