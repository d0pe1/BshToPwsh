import os

def test_session_manager_exists():
    assert os.path.isfile('session_manager.ps1')
