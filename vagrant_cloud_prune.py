'''
Remove old box versions from Vagrant Cloud, keep last N
'''


import argparse
import json
import os
from datetime import datetime
from urllib.request import urlopen, Request


USER_AGENT = 'vagrant_cloud_prune.py <https://github.com/sio/vagrant-boxes-debian>'

API_ROOT = 'https://app.vagrantup.com/api/v1'
API_BOX_URL = '{API_ROOT}/box/{box}'
API_VERSION_URL = '{API_ROOT}/box/{box}/version/{version}'


def api(url, method='GET'):
    '''Call Vagrant Cloud API <https://www.vagrantup.com/vagrant-cloud/api>'''
    token = os.environ['VAGRANT_CLOUD_TOKEN']
    request = Request(
        url,
        method=method,
        headers={
            'User-Agent': USER_AGENT,
            'Authorization': f'Bearer {token}',
        },
    )
    with urlopen(request) as response:
        if response.code not in {200, 201, 204}:
            raise ValueError(f'HTTP {response.code}: {method} {url}')
        return json.load(response)


def box_info(box):
    '''Fetch box information from Vagrant Cloud API'''
    url = API_BOX_URL.format(API_ROOT=API_ROOT, box=box)
    return api(url)


def delete_box(box, version):
    '''Delete box version from Vagrant Cloud'''
    url = API_VERSION_URL.format(
            API_ROOT=API_ROOT,
            box=box,
            version=version
    )
    return api(url, method='DELETE')


def parse_args(*a, **ka):
    '''Parse commandline arguments'''
    parser = argparse.ArgumentParser(
        description='Prune older box versions from Vagrant Cloud, keep only last N',
        epilog='Licensed under the Apache License, version 2.0',
    )
    parser.add_argument(
        'box',
        metavar='BOX',
        help='box name at Vagrant Cloud [organization/name]',
    )
    parser.add_argument(
        'keep',
        metavar='NUM',
        default=10,
        nargs='?',
        type=int,
        help='number of newest boxes to keep',
    )
    args = parser.parse_args(*a, **ka)
    boxname_parts = args.box.split('/')
    if len(boxname_parts) != 2 or not all(boxname_parts):
        parser.error(f'invalid box identifier: {args.box}')
    return args


def main():
    '''CLI entrypoint'''
    args = parse_args()
    for idx, release in enumerate(sorted(
            box_info(args.box)['versions'],
            key=lambda v: datetime.fromisoformat(v['created_at']),
            reverse=True,
    )):
        if idx >= args.keep:
            print(f'Deleting {args.box} (version {release["version"]})')
            delete_box(args.box, release['version'])


if __name__ == '__main__':
    main()
