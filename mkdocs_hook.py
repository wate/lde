import os
import shutil
import subprocess

def on_pre_build(config, **kwargs):
    from shutil import which
    execute_cmd = False
    if shutil.which('phpdoc'):
        execute_cmd = ['phpdoc']
    else:
        if shutil.which('php') and os.path.isfile('phpDocumentor.phar'):
            execute_cmd = ['php', 'phpDocumentor.phar']
    if execute_cmd:
        subprocess.run(execute_cmd)
