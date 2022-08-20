### Demo - Remote setup and configuration

Run an `ansible playbook` to install and setup tools on the target machines.

Notes:

- Uses `roles` to organize tasks
- Uses `ansible-vault` to encrypt sensitive data via a password file
- Uses a custom module defined in the `library` directory


Actions required:

- Edit the `hosts` file to select the target machines.
- To run the playbook, enter the command:  
  `> ansible-playbook playbook.yaml --vault-password-file password.txt`
- Use ad-hoc commands as a quick way to run a single command, examples:  
  `> ansible t2micro -m ping`  
  `> ansible all -m command -a "df -h"`

