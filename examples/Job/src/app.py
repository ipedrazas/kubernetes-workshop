import os

import requests


APIHOST = os.environ.get("APIHOST")


def get_checks():
    resp = requests.get(APIHOST)

    print resp.status_code


if __name__ == '__main__':
    get_checks()
