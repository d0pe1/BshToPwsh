import os

def test_health_endpoint_exists():
    assert os.path.isfile('health_endpoint.sh')
