# vim: tabstop=4 shiftwidth=4 softtabstop=4

# Copyright 2010 United States Government as represented by the
# Administrator of the National Aeronautics and Space Administration.
# All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.



###################
# To use this script:
# 1. change the 0 to 1 on the line 'if 0' by the comment '# generate'
# 2. run `python api.py` this will generate a trystack.cfg file with empty values
# 3. switch the 1 back to a 0
# 4. edit the trystack.cfg file with appropriate values
# 5. edit the user and password and url around line 40 to point to foreman
# 6. run `python api.py`
# 7. repeat 5 & 6 as nessesary
##################




import ConfigParser
import json
import base64
import httplib2

from urllib import urlencode

defaults = {
'public_ip': '', 'private_ip': '', 'mysql_ip': '',
'qpid_ip': '', 'public_fqdn': '', 'admin_user': '',
'admin_tenant': '', 'admin_email': '',
'admin_password': '', 'mysql_root_password': '',
'trystack_db_password': '', 'horizon_secret_key': '',
'facebook_app_id': '', 'facebook_app_secret': '',
'member_user_role': '', 'neutron_user_password': '',
'nagios_ip': '', 'nagios_password': '', 'nagios_user': '',
'neutron_ip': '', 'neutron_db_password': '', 'neutron_metadata_auth_password': '',
'neutron_metadata_shared_secret': '', 'keystone_admin_token': '',
'keystone_db_password': '',
'swift_admin_password': '', 'swift_shared_secret': '',
'ceilometer_metering_secret': '', 'ceilometer_user_password': '',
'cinder_user_password': '', 'cinder_db_password': '',
'glance_user_password': '', 'glance_db_password': '',
'nova_user_password': '', 'nova_db_password': ''}

# Get Config File
config = ConfigParser.SafeConfigParser(defaults)

# generate
if 0:
    cfgfile = open("trystack.cfg.new", 'w')
    cfgfile.add_section('NAGIOS')
    cfgfile.set('NAGIOS','user', 'admin')
    cfgfile.set('NAGIOS','password', 'changeme')
    config.write(cfgfile)
    exit()


config.read('trystack.cfg')

nagios_creds = {
    'user': config.get('NAGIOS', 'user'),
    'password': config.get('NAGIOS', 'password'),
}

# Get common paramters
h = httplib2.Http(".cache", disable_ssl_certificate_validation=True)
#h.add_credentials('admin', 'changeme') ## Doesn't work, workaround on next line!
auth = base64.encodestring('%s:%s' % (nagios_creds['user'], nagios_creds['password']))
# /api/common_parameters seemed to be limiting results to max 20 paramters
# I tried disabling this limit with page and per_page to no avail
# hack fix is to pass a number large enough that there should never be more than
# that number of parameters in the list.
resp, content = h.request("https://localhost/api/common_parameters?per_page=10000", "GET",
                 headers={'Accept': 'application/json',
                          'Content-Type': 'application/json; charset=UTF-8',
                          'Authorization': 'Basic ' + auth })

if resp.status != 200:
    print resp, content
else:
    parameters = {}
    json_parameters = json.loads(content)
    for p in json_parameters:
        parameters[p['common_parameter']['name']] = {'id': p['common_parameter']['id'], 'value': p['common_parameter']['value']} 
    #print parameters


# start update
items = {}
for k,v in config.items('DEFAULT'):
    items[k] = v

for k in items:
    if k not in parameters:
        resp, content = h.request("https://localhost/api/common_parameters", "POST",
                 headers={'Accept': 'application/json',
                          'Content-Type': 'application/json; charset=UTF-8',
                          'Authorization': 'Basic ' + auth },
                 body=json.dumps({'common_parameter': {'name': k, 'value': items[k]}}))
        print 'Add', k, resp.status
        if resp.status != 200:
            print resp, content
    if k in parameters and parameters[k]['value'] != items[k]:
        id = parameters[k]['id']
        resp, content = h.request("https://localhost/api/common_parameters/%s" % id, "PUT",
                 headers={'Accept': 'application/json',
                          'Content-Type': 'application/json; charset=UTF-8',
                          'Authorization': 'Basic ' + auth },
                 body=json.dumps({'common_parameter': {'id': id, 'name': k, 'value': items[k]}}))
        print 'Update', k, resp.status
        if resp.status != 200:
            print resp, content

