import os

def test_tunnel_setup_exists():
    assert os.path.isfile('tunnel_setup.sh')
