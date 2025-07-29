import os


def test_exec_remote_parallel_contains_wait():
    with open('exec_remote.sh') as f:
        content = f.read()
    assert 'wait' in content
