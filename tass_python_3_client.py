"""
Author: Mario Gudelj, EnrolHQ @ https://www.enrolhq.com.au

This is a simple Python 3 client TASS. It uses a lot of the URL creation code from this file by Liam Stevens:

https://github.com/TheAlphaSchoolSystemPTYLTD/api-introduction/blob/master/encryptDecrypt.py

I've made the code a bit more pythonic, wrapped it into class and added a few common methods from the Student Details API. There are some changes
in here that make the code work with Python 3 when compared to the original file mentioned above. You need to install the following packages:

pip install requests
pip install pycryptodome

Usage:

tass_client = TassClient()
response = tass_client.get_current_students()
for student in response.json()['students']:
    print(student)


"""

import base64
import datetime
from urllib.parse import urlencode
from Crypto.Cipher import AES
import requests


class TassClient(object):

    def __init__(self, school):
        self.school = school
        self.token_key = ""
        self.app_code = ""
        self.company_code = ""
        self.version = '3'
        self.end_point = ""
        self.headers = {'content-type': 'application/json'}

    def get_encrypted_token(self, token, params):
        decoded = base64.b64decode(token)
        plaintext = params
        length = 16 - (len(plaintext) % 16)
        plaintext += chr(length) * length
        rijndael = AES.new(decoded, AES.MODE_ECB)
        ciphertext = rijndael.encrypt(plaintext.encode("utf8"))
        ciphertext = base64.b64encode(ciphertext)
        return ciphertext

    def get_url_request(self, end_point, method, app_code, company_code, version, parameters, token_key):
        encrypted = self.get_encrypted_token(token_key, parameters)
        request_dict = {
            "method": method,
            "appcode": app_code,
            "company": company_code,
            "v": version,
            "token": encrypted
        }
        request_str = urlencode(request_dict)
        url_string = end_point + '?' + request_str
        return url_string

    def get_url(self, parameters, method, version):
        """
        :param parameters: This needs to be a JSON in string form.
        :param method: This is function name in TASS API
        :return: URL you make a request to.
        """
        return self.get_url_request(self.end_point, method, self.app_code, self.company_code, version, parameters,
                                    self.token_key)

    def get_current_student_with_code(self, student_code):
        """
        See tass_playground.txt for details
        """
        params = "{'currentstatus': 'current', 'code': '%s', 'includephoto': true}" % student_code
        method = 'getStudentsDetails'
        version = '3'
        url = self.get_url(params, method, version)
        response = requests.get(url)
        return response

    def get_current_students(self):
        params = "{'currentstatus': 'current'}"
        method = 'getStudentsDetails'
        version = '3'
        url = self.get_url(params, method, version)
        response = requests.get(url)
        return response

    def get_current_parents(self):
        params = "{'currentstatus': 'current', 'commtype': 'all'}"
        method = 'getCommunicationRulesDetails'
        version = '3'
        url = self.get_url(params, method, version)
        response = requests.get(url)
        return response

    def get_parents_for_student_code(self, student_code):
        params = "{'currentstatus': 'current', 'commtype': 'all', 'code': %s}" % student_code
        method = 'getCommunicationRulesDetails'
        version = '3'
        url = self.get_url(params, method, version)
        response = requests.get(url)
        return response
