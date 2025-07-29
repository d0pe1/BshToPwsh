import subprocess
import os


def test_exec_remote_contains_exitcode():
    with open('exec_remote.sh') as f:
        content = f.read()
    assert 'exitCode' in content
