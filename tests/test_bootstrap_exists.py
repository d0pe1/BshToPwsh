import os


def test_bootstrap_script_exists():
    assert os.path.isfile('bootstrap.sh')
