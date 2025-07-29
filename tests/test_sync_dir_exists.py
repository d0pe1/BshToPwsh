import os

def test_sync_dir_exists():
    assert os.path.isfile('sync_dir.sh')
