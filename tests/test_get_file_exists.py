import os

def test_get_file_exists():
    assert os.path.isfile('get_file.sh')
