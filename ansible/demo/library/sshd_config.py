#!/usr/bin/python

# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
from __future__ import (absolute_import, division, print_function)
from ansible.module_utils.basic import AnsibleModule
import re
__metaclass__ = type

DOCUMENTATION = r'''
---
module: sshd_config

description: Edit SSH daemon configurations

options:
    port:
        description: Port number to use for SSH connections
        required: false
        type: int
        default: 22
    allow_tcp_forwarding:
        description: Allow TPC forwarding
        required: false
        type: bool
        default: false
    max_auth_tries:
        description: Maximum tries allowed
        required: false
        type: int
        default: 3
    password_authentication:
        description: Allow password authentication
        required: false
        type: bool
        default: false
    permit_empty_passwords:
        description: Allow password authentication with no password
        required: false
        type: bool
        default: false
    permit_root_login:
        description: Allow root login
        required: false
        type: bool
        default: false
    pubkey_authentication:
        description: Allow public-key based authentication
        required: false
        type: bool
        default: true
    x11_forwarding:
        description: Allow X11 forwarding
        required: false
        type: bool
        default: false
'''

EXAMPLES = r'''
# setup the new port to use and harden the SSH server using default settings
- name: Use most of default settings
  become: yes
  sshd_config:
    port: 42069

# setup the new port to used and specify certain settings
- name: Use most of default settings but allow TCP port forwarding
  become: yes
  sshd_config:
    port: 12345
    allow_tcp_forwarding: yes
'''

RETURN = r''' # '''


def run_module():
    module_args = dict(
        allow_tcp_forwarding=dict(type='bool', required=False, default=False),
        max_auth_tries=dict(type='int', required=False, default=3),
        password_authentication=dict(type='bool', required=False, default=False),
        permit_empty_passwords=dict(type='bool', required=False, default=False),
        permit_root_login=dict(type='bool', required=False, default=False),
        port=dict(type='int', required=False, default=22),
        pubkey_authentication=dict(type='bool', required=False, default=True),
        x11_forwarding=dict(type='bool', required=False, default=False),
    )

    result = dict(
        changed=False,
    )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    if module.check_mode:
        module.exit_json(**result)

    with open('/etc/ssh/sshd_config', 'r+') as file:
        orig_config = file.read()
        config = orig_config
        subs = []
        config_keys = [
            'allow_tcp_forwarding',
            'password_authentication',
            'permit_empty_passwords',
            'permit_root_login',
            'port',
            'pubkey_authentication',
            'max_auth_tries',
            'x11_forwarding'
        ]
        for config_key in config_keys:
            if module.params[config_key] is not None:
                config_name = config_key.title().replace('_', '')
                value = module.params[config_key]
                config_value = value if not isinstance(value, bool) else ('yes' if value else 'no')
                subs.append(
                    (f'^(#?){config_name} .*', f'{config_name} {config_value}')
                )
        for sub in subs:
            config = re.sub(sub[0], sub[1], config, flags=re.M)
        if orig_config != config:
            file.seek(0, 0)
            file.write(config)
            file.truncate()
            result['changed'] = True

    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()
