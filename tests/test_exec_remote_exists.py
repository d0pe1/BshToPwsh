import os

def test_exec_remote_exists():
    assert os.path.isfile('exec_remote.sh')
