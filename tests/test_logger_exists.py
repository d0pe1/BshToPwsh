import os

def test_logger_exists():
    assert os.path.isfile('logger.sh')
