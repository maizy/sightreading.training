#!/usr/bin/env python3
# encoding: utf-8

import os.path
import subprocess
import shutil
import re
import glob

PIANISTICA_ROOT = os.path.dirname(__file__)


def create_temp_container(image):
    return subprocess.run(['docker', 'create', image], stdout=subprocess.PIPE).stdout.decode('utf-8').strip()


def remove_temp_container(temp_container):
    return subprocess.run(['docker', 'rm', '-f', temp_container], stdout=subprocess.PIPE)


def find_all_links():

    def parse_nav_links(content):
        return re.findall(r'<NavLink\s[^>]*?to="([^"]+)"[^>]*?>', content) + re.findall(r'link\(\s*"([^"]+)"', content)

    links = set()
    header = open(os.path.join(PIANISTICA_ROOT, 'static', 'js', 'components', 'header.es6')).read()
    links |= set(parse_nav_links(header))

    pages_dir = os.path.join(PIANISTICA_ROOT, 'static', 'js', 'components', 'pages')
    for page_file in glob.glob(pages_dir + os.path.sep + '*.es6'):
        page = open(os.path.join(pages_dir, page_file)).read()
        links |= set(parse_nav_links(page))

    return links - set('/')


def copy_static(result_dir, temp_container):
    subprocess.run(['docker', 'cp',
                    temp_container+':/site/pianistica/static/',
                    result_dir],
                   stdout=subprocess.PIPE)
    shutil.copy(os.path.join(result_dir, 'static', 'service_worker.js'), os.path.join(result_dir, 'sw.js'))
    shutil.copy(os.path.join(result_dir, 'static', 'favicon.ico'), os.path.join(result_dir, 'favicon.ico'))

    for pattern in ('.gitignore', '*.es6', '*.scss', 'lib-dev.js'):
        for file in glob.glob(result_dir + os.path.sep + '**' + os.path.sep + pattern, recursive=True):
            os.remove(file)


def build_indexes(links, result_dir, temp_container):
    subprocess.run(['docker', 'cp',
                    temp_container+':/site/pianistica/serverless/index.html',
                    result_dir],
                   stdout=subprocess.PIPE)

    for link in links:
        page_dir = os.path.join(result_dir, link.lstrip('/').replace('/', os.path.sep))
        os.makedirs(page_dir, 0o755, exist_ok=True)
        shutil.copy(os.path.join(result_dir, 'index.html'), os.path.join(page_dir, 'index.html'))


def build(result_dir, image):
    temp_container = create_temp_container(image)

    shutil.rmtree(result_dir, ignore_errors=True)
    os.makedirs(result_dir, mode=0o755, exist_ok=True)

    copy_static(result_dir, temp_container)
    links = find_all_links()
    build_indexes(links, result_dir, temp_container)

    remove_temp_container(temp_container)

    return True


if __name__ == '__main__':
    import sys
    if len(sys.argv) < 2:
        print('Usage: {} RESULT_DIR'.format(os.path.basename(sys.argv[0])))
        sys.exit(1)

    result_dir = sys.argv[1]
    image = sys.argv[2] if len(sys.argv) > 2 else 'pianistica:latest'
    if not build(result_dir, image):
        sys.exit(2)
    sys.exit(0)
