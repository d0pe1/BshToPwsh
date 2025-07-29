import os


def test_clone_agent_suite_script_exists():
    assert os.path.isfile('clone_agent_suite.sh')
