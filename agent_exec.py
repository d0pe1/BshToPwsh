import subprocess
import json
from flask import Flask, request, jsonify

app = Flask(__name__)


def run_cmd(cmd_list):
    result = subprocess.run(cmd_list, capture_output=True, text=True)
    out = result.stdout.strip()
    err = result.stderr.strip()
    code = result.returncode
    return {"stdout": out, "stderr": err, "exitCode": code}

@app.post('/exec')
def exec_cmd():
    data = request.get_json(force=True)
    target = data.get('target')
    cmd = data.get('cmd')
    if not target or not cmd:
        return jsonify({'error': 'target and cmd required'}), 400
    res = run_cmd(['./exec_remote.sh', target, cmd])
    try:
        payload = json.loads(res['stdout'])
        res.update(payload)
    except Exception:
        pass
    return jsonify(res)

@app.post('/send_file')
def send_file():
    data = request.get_json(force=True)
    target = data.get('target')
    local_path = data.get('local_path')
    remote_path = data.get('remote_path')
    if not target or not local_path or not remote_path:
        return jsonify({'error': 'target, local_path, remote_path required'}), 400
    res = run_cmd(['./send_file.sh', target, local_path, remote_path])
    return jsonify(res)

@app.post('/get_file')
def get_file():
    data = request.get_json(force=True)
    target = data.get('target')
    remote_path = data.get('remote_path')
    local_path = data.get('local_path')
    if not target or not remote_path or not local_path:
        return jsonify({'error': 'target, remote_path, local_path required'}), 400
    res = run_cmd(['./get_file.sh', target, remote_path, local_path])
    return jsonify(res)

@app.post('/sync_dir')
def sync_dir():
    data = request.get_json(force=True)
    target = data.get('target')
    local_dir = data.get('local_dir')
    remote_dir = data.get('remote_dir')
    if not target or not local_dir or not remote_dir:
        return jsonify({'error': 'target, local_dir, remote_dir required'}), 400
    res = run_cmd(['./sync_dir.sh', target, local_dir, remote_dir])
    return jsonify(res)

@app.get('/hosts')
def hosts():
    try:
        with open('hosts.db') as f:
            lines = [l.strip() for l in f if l.strip()]
    except FileNotFoundError:
        lines = []
    return jsonify({'hosts': lines})

@app.get('/health')
def health():
    res = run_cmd(['./health_endpoint.sh'])
    return jsonify(res)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
