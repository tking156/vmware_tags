# README

## Synopsis

This role can be used when you have one or more virtual machines on one or more vcenters, and need to have a list of which vm is on which vcenter. It can be configured to work with event automation, or custom return codes. It is expected to be used as a building block to perform some other task against a specific vm or list of vm's.

## Variables

Variable | Default| Comments
----------|-----------------|--------
**vfv_delimiter** (String) | ','| delimiter of the string holding vmware_vcenter_names or vmware_guest_names
**vfv_eventautomation** (Boolean) | false | Force role to run in event_automation mode, removed returncode
**vfv_fail_invalid_guest** (Boolean) | false | Cause the role to fail if any guests listed are not found
**vfv_fail_invalid_vcenter** (Boolean) | false | Cause the role to fail if any vcenters listed are not found
**vfv_vmware_guest_names** (List or String) |  (String) myguest1, myguest2 | **Mandatory** list or comma separated string of all guest names to check against each vcenter
**vfv_vmware_validate_certs** (Boolean) | false| used to force or bypass validation of vcenter server certificates
**vfv_vmware_vcenter_names** (List or String) | (String) myvcenter1, myvcenter2 | **Mandatory** list or comma separated string of all vcenters to check.

## Results from execution

_See documentation for [Return Code](https://github.kyndryl.net/Continuous-Engineering/ansible_role_returncode/) Building Block._

Return Code Group | Return Code | Comments
----------|--------------|---------
misconfiguration | 3000 |  vfv_vmware_guest_names is invalid format or empty, must be a comma delimited string of guest names or a list object
misconfiguration | 3001 |  vfv_vmware_vcenter_names is invalid format or empty, must be a comma delimited string of vcenter names or a list object
misconfiguration | 3002 |  Both your vfv_vmware_vcenter_names and vfv_vmware_guest_names variables are invalid format or empty, refer to error 3000 and 3001 to correct them
misconfiguration | 3003 |  Credential type credtype_vc_server is not present, please add a valid cred
misconfiguration | 3004 |  login failure with credtype_vc_server credential, check your credential
misconfiguration | 3005 |  vfv_vmware_vcenter_names has an invalid entry, we could not find the vcenter listed, see 3001 above
misconfiguration | 3006 |  vfv_vmware_guest_names has an invalid entry, we could not find the guest listed, see 3000 above. This will fail the role if vfv_fail_invalid_guest is true
misconfiguration | 3007 |  vfv_vmware_guest_names and vfv_vmware_vcenter_names have invalid entries, see 3005, 3006 above. This will fail the role if fail_invalid_vcenter is true.

**Note**: all event automation codes are the same as Return Code with the exception they are all 1000 series. ie:

* rc_number 1000 has same description as returncode 3000 above
* rc_number 1001 has same description as returncode 3001 above
* etc.

## Procedure

This role is to be used when multiple vcenters exist on an account and you need to know which vcenter a given VM exists on. It is not meant to be a reporting tool, but rather a building block to feed vcenter/vmware pairs to other playbooks or roles as facts. It **requires 1 vm, 1 vcenter, and a credtype_vc_server as a minimum**.

This role returns the following variables, as facts, for your playbook or role to consume:

**vfv_vm_vcenter** is a List of Dictionaries. These are all the guests with corresponding vcenter they were found on. This is likely what you want to iterate over in your playbook.

```yaml
vfv_vm_vcenter:
  - guest: "guest1"
    vcenter: "vcenter1"
  - guest: "guest2"
    vcenter: "vcenter2"
```

**vfv_guests_found** is a List defaulting to [], and lists any vm's that were found on one of the vcenters

```yaml
vfv_guests_found:
  - guest1
  - guest2
```

**vfv_guests_missed** is a List defaulting to [], and lists any vm's that were NOT found on one of the vcenters

```yaml
vfv_guests_missed:
  - guest3
  - guest4
```

**vfv_vcenter_found** is a List defaulting to [], and A list of any vcenter that were found and logged into

```yaml
vfv_vcenter_found:
  - vcenter1
  - vcenter2
```

**vfv_vcenter_missed** is a List defaulting to [], and A list of any vcenter that were NOT found

```yaml
vfv_vcenter_missed:
  - vcenter3
  - vcenter4
```

**vfv_vcenter_login_failed** is a list defaulting to [], is a list of any vcenter we failed to login to This is not the same as vfv_vcenter_missed, these ones were found but some login issue like password etc. If no failures to login, your playbook will find this as undefined.

```yaml
vfv_vcenter_login_failed:
  - vcenter5
  - vcenter6
```

## Support

This asset is supported on a best effort basis. To report a bug please open an issue in github and ping <thomas.king@kyndryl.com> on teams or email.

## Deployment

This role is not meant to be deployed on it's own, it is meant ot be called from inside another role or playbook. See the sample playbook in [Examples](#examples).

## Known problems and limitations

This role was designed and tested on:

* RH8 jumphost
  * Python 3
  * pyvmomi must be installed
  * Collection: community.vmware version 3.11.1
  * Role: ansible_role_return_codes version 1.3/main
  * Execution Environment: ansible_kyndryl_2.13
* It is recommended when running under eventautomation mode that only 1 VM is listed, but more than 1 vcenter can be listed.

## Prerequisites

**The following are mandatory** if you include this role in your playbook

* **Variables** defined
  * vfv_vmware_guest_names
  * vfv_vmware_vcenter_names
* **Credentials** provided
  * credtype_vc_server
* **Roles** included in playbook directory/file roles/requirements.yml

    ```yaml
    - name: returncode
      src: git+https://github.kyndryl.net/Continuous-Engineering/ansible_role_returncode.git
      version: 1.3/main
    - name: vcenters_find_vm
      src: git+https://github.kyndryl.net/Continuous-Engineering/vcenters_find_vms.git
      version: dev
    ```

* **Collections** included in playbook directory/file collections/requirements.yml

    ```yaml
    collections:
      - name: community.vmware
        version: 3.11.1
    ```

* **Python** version tested
  * "ansible.python.interpreterPath": "/bin/python3"

* **Execution Environment** tested
  * ansible_kyndryl_2.13

## Examples

An example playbook showing the 6 facts returned by the role

```yaml
- name: list the facts returned by vcenters_find_vm
  hosts: all
  gather_facts: false
  tasks:

    - name: setup returncode in playbook
      ansible.builtin.include_role:
        name: returncode
        tasks_from: set_job_properties
      vars:
        asset_name: "using vcenter_find_vm"
        documentation:
          default: "https://github.kyndryl.net/your_playbook_for_vmware"

    - name: Include role
      ansible.builtin.include_role:
        name: vcenters_find_vm

    - name: Show a list of dictionaries for guests and vcenters they are on
      ansible.builtin.debug:
        var: vfv_vm_vcenter
        verbosity: 0

    - name: Show guests that role found from inside playbook
      ansible.builtin.debug:
        var: vfv_guests_found
        verbosity: 0

    - name: Show guests that role could not find from inside playbook
      ansible.builtin.debug:
        var: vfv_guests_missed
        verbosity: 0

    - name: Show vcenters that role found from inside playbook
      ansible.builtin.debug:
        var: vfv_vcenter_found
        verbosity: 0

    - name: Show vcenters that role could not find from inside playbook
      ansible.builtin.debug:
        var: vfv_vcenter_missed
        verbosity: 0

    - name: Show vcenters we couldn't log into from inside playbook
      ansible.builtin.debug:
        var: vfv_vcenter_login_failed
        verbosity: 0

      # Need to report success when everything was good
    - name: Success end of playbook
      ansible.builtin.include_role:
        name: returncode
      vars:
        rc_success: true
      when:
        - returncode is undefined or returncode == "0"
```

## License

[Kyndryl Intellectual Property](https://github.kyndryl.net/Continuous-Engineering/CE-Documentation/blob/master/files/LICENSE.md)
