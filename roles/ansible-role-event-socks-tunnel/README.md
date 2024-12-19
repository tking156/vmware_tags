# Synopsis

This role is setting up an unix socket tunnel across jumphosts and create a socket file which is used to connect windows endpoint.

Generated socket file follows follwing naming convention and created under **/tmp** directory in job execution environment in Ansible Tower:

    mysocks-{{ account_code }}-{{ transaction_number }}-{{ jh_socks_port }}


# Variables

| Parameter | Defaults | Comments |
|------------------------|---------------|--------|
| **acc_id** (String) | {{ blueid_shortcode }} | Name of organization ( 3 letter code ) |
| **transaction_id** (Number) | {{ tower_job_id }} | It represents Ansible Tower Job ID or any random value between 1-999999999999999 |
| **socks_controlmaster** (boolean) | true | Add ssh attribute `-o ControlMaster=auto` |
| **socks_controlpersist** (boolean) | true | Add ssh attribute `-o ControlPersist=no` |
| **socks_exitonforwardfailure** (boolean) | true | Add ssh attribute `-o ExitOnForwardFailure=yes` |
| **socks_identitiesonly** (boolean) | false | Add ssh attribute `-o IdentitiesOnly=yes` |
| **socks_nopasswordauthentication** (boolean) | true | Add ssh attribute `-o PasswordAuthentication=no` |
| **socks_serveralivecountMax** (boolean) | true | Add ssh attribute `-o ServerAliveCountMax=3` |
| **socks_serveraliveinterval** (boolean) | true | Add ssh attribute `-o socks_ServerAliveInterval=30` |
| **socks_stricthostkeychecking** (boolean) | true | Add ssh attribute `-o StrictHostKeyChecking=no` |
| **socks_switches** (boolean) | true | Add ssh switches `-CfNq` |
| **socks_userknownhostsfile** (boolean) | true | Add ssh attribute `-o UserKnownHostsFile=/dev/null` |

# Results from execution

Set following fact variable to represent status of socket file creation.

|Variable Name  |Generated Values  |Comments  |
|---------------|--------|----------|
|**Socks_File_Created** | **SUCCESS**/**FAILED** | It represents status of socks file creation to setup socket tunnel accross jumphosts.|


# Credential

It requires credential of following credential types as per required number of jumphosts to setup socket tunnel.

    Credential with "credtype_jumphost_1hop" credential type for 1hop jumphost.
    Credential with "credtype_jumphost_2hop" credential type for 2hop jumphosts.
    Credential with "credtype_jumphost_3hop" credential type for 3hop jumphosts.
    Credential with "credtype_jumphost_4hop" credential type for 4hop jumphosts.
    Credential with "credtype_jumphost_5hop" credential type for 5hop jumphosts.


# Examples

*Example represents part of calling playbook/role* 
```yaml
  ---
  # Tasks on Tower
  - hosts: localhost
    connection: local
    tasks:
      - name: Tasks on localhost
        debug:
          msg: "Example task on localhost"
      # Calling socks tunnel role if we have windows endpoint
      - name: Role ensures that the socks tunnel is setup
        import_role:
          name: ansible-role-event-socks-tunnel

  # Tasks on endpoints
  - hosts: all
    tasks:
      - name: Tasks on endpoint
        debug:
          msg: "Example task on endpoint"
```
# L3 Support
L3 support is for engaging CACF Global Dev team.Open a Issue in GitHub using the following link: (Choose [L3 Support Request](https://github.kyndryl.net/la-innovation/next_framework_l3/issues/new/choose))

# License

[Kyndryl Intellectual Property](https://github.kyndryl.net/Continuous-Engineering/CE-Documentation/blob/master/files/LICENSE.md)
