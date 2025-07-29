import os

def test_send_file_exists():
    assert os.path.isfile('send_file.sh')
