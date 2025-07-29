import os

def test_multi_host_support_exists():
    assert os.path.isfile('multi_host_support.sh')
