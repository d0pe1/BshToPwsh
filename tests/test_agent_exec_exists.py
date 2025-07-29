import os


def test_agent_exec_exists():
    assert os.path.isfile('agent_exec.py')
