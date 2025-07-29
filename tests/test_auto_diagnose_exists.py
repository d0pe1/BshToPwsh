import os

def test_auto_diagnose_exists():
    assert os.path.isfile('auto_diagnose.sh')
