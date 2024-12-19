# README

## Goal of this document

The following playbooks has to be created in different collection/role and their purpose is to test functionality of `ansible_role_returncode`. Output from Tower API has to correspond to expected output listed below. Test must be always done on multiple servers. Expected outputs listed below are done for servers `ipcmon02.BlackListHost.ibm.com` and `ipcmon02.ibm.com` - this can change based on testing environment.

## Prerequisites

Second collection/role that runs following code and links this role by `requirements.yml`

## Test Cases

### Test Case 1: No level returncode

- __Playbook code__

```yaml
---
- hosts: all
  ignore_unreachable: true
  tasks:
    - name: Set job properties
      include_role:
        name: returncode
        tasks_from: set_job_properties
      vars:
        asset_name: "UID extraction"
        documentation:
          default: "https://github.kyndryl.net/Continuous-Engineering/ansible_collection_uidextraction"

# Generate RC with no leveling (1 RC describing whole Job run)
    - name: Generate RC - no levels
      include_role:
        name: returncode
      vars:
        rc_support: developer
        rc_group: component_playbook
        rc_number: 123
        rc_message: "1 Component playbook failed due to.... Developer can support this."

# Generate RC with no leveling (1 RC describing whole Job run)
    - name: Generate RC - no levels
      include_role:
        name: returncode
      vars:
        rc_support: developer
        rc_group: component_playbook
        rc_number: 456
        rc_message: "2 Component playbook failed due to.... Developer can support this."
```

- __Expected output__

```json
    "artifacts": {
        "job_properties": {
            "asset_name": "UID extraction",
            "documentation": {
                "default": "https://github.kyndryl.net/Continuous-Engineering/ansible_collection_uidextraction"
            }
        },
        "job_results": {
            "ipcmon02.BlackListHost.ibm.com": {
                "generic": {
                    "message": "2 Component playbook failed due to.... Developer can support this.",
                    "action_rc": "2-3-456"
                }
            },
            "ipcmon02.ibm.com": {
                "generic": {
                    "message": "2 Component playbook failed due to.... Developer can support this.",
                    "action_rc": "2-3-456"
                }
            }
        }
    },
```

### Test Case 2: Level 1 returncode

- __Playbook code__

```yaml
---
- hosts: all
  ignore_unreachable: true
  tasks:
    - name: Set job properties
      include_role:
        name: returncode
        tasks_from: set_job_properties
      vars:
        asset_name: "UID extraction"
        documentation:
          default: "https://github.kyndryl.net/Continuous-Engineering/ansible_collection_uidextraction"
          db2: "www.this.is.db2.documentation.link"
        custom_job_properties:
          mykey1: "My value"
          Some another key: "Another value"

    - name: Set RC for Dashboard - First action - Level1 - to be rewritten
      include_role:
        name: returncode
      vars:
        action_name_level1: "db2"
        rc_support: developer
        rc_group: framework_playbook
        rc_number: 666
        rc_message: "This message should not be visible."

    - name: Set RC for Dashboard - First action - Level1 - rewrite previous
      include_role:
        name: returncode
      vars:
        action_name_level1: "db2"
        rc_support: account
        rc_group: component_playbook
        rc_number: 111
        rc_message: "DB2 extractor failed due to.... with custom documentation"
        documentation: "www.to.db2.111.documentation.url"

    - name: Add more job properties
      include_role:
        name: returncode
        tasks_from: set_job_properties
      vars:
        documentation:
          iis: "www.link.to.iis.documentation.added.later"

    - name: Set RC for Dashboard - First action - Level1
      include_role:
        name: returncode
      vars:
        action_name_level1: "iis"
        rc_support: account
        rc_group: component_playbook
        rc_number: 222
        rc_message: "IIS extractor failed due to...."

    - name: Set RC for Dashboard - Second action - Level1
      include_role:
        name: returncode
      vars:
        action_name_level1: "unix"
        rc_success: true
```

- __Expected output__

```json

    "artifacts": {
        "job_properties": {
            "asset_name": "unknown",
            "Some another key": "Another value",
            "documentation": {
                "default": "https://github.kyndryl.net/Continuous-Engineering/ansible_collection_uidextraction",
                "db2": "www.this.is.db2.documentation.link",
                "iis": "www.link.to.iis.documentation.added.later"
            },
            "mykey1": "My value"
        },
        "job_results": {
            "ipcmon02.BlackListHost.ibm.com": {
                "unix": {
                    "action_rc": "0"
                },
                "db2": {
                    "message": "DB2 extractor failed due to.... with custom documentation",
                    "documentation": "www.to.db2.111.documentation.url",
                    "action_rc": "1-3-111"
                },
                "iis": {
                    "message": "IIS extractor failed due to....",
                    "action_rc": "1-3-222"
                }
            },
            "ipcmon02.ibm.com": {
                "unix": {
                    "action_rc": "0"
                },
                "db2": {
                    "message": "DB2 extractor failed due to.... with custom documentation",
                    "documentation": "www.to.db2.111.documentation.url",
                    "action_rc": "1-3-111"
                },
                "iis": {
                    "message": "IIS extractor failed due to....",
                    "action_rc": "1-3-222"
                }
            }
        }
    },
```

### Test Case 3: Level 2 returncode

- __Playbook code__

```yaml
---
- hosts: all
  ignore_unreachable: true
  tasks:
    - name: Set job properties
      include_role:
        name: returncode
        tasks_from: set_job_properties
      vars:
        asset_name: "UID extraction"
        documentation:
          default: "https://github.kyndryl.net/Continuous-Engineering/ansible_collection_uidextraction"
          unix: "https://github.kyndryl.net/Continuous-Engineering/ansible_role_uidextractor_unix"
          windows: "https://github.kyndryl.net/Continuous-Engineering/ansible_role_uidextractor_windows"
          db2: "https://github.kyndryl.net/Continuous-Engineering/ansible_role_uidextractor_db2"
          iis: "https://github.kyndryl.net/Continuous-Engineering/ansible_role_uidextractor_iis"

# Set Level 2 - 2 actions. First with 2 subactions and second with 1 subaction
    - name: Set RC for Dashboard - First action, first subaction - Level2
      include_role:
        name: returncode
      vars:
        action_name_level1: "db2"
        action_name_level2: "perl"
        rc_support: developer
        rc_group: framework_playbook
        rc_number: 3333
        rc_message: "DB2 with Perl failed due to..."

    - name: Set RC for Dashboard - First action, second subaction - Level2
      include_role:
        name: returncode
      vars:
        action_name_level1: "db2"
        action_name_level2: "bash"
        rc_support: account
        rc_group: misconfiguration
        rc_number: 123
        rc_message: "DB2 with bash failed due to..."

    - name: Set RC for Dashboard - Second action with one subaction - Level2
      include_role:
        name: returncode
      vars:
        action_name_level1: "mssql"
        action_name_level2: "exe"
        rc_success: true
        documentation: "https://github.kyndryl.net/Continuous-Engineering/ansible_role_uidextractor_mssql"
```

- __Expected output__

```json

    "artifacts": {
        "job_properties": {
            "asset_name": "UID extraction",
            "documentation": {
                "default": "https://github.kyndryl.net/Continuous-Engineering/ansible_collection_uidextraction",
                "windows": "https://github.kyndryl.net/Continuous-Engineering/ansible_role_uidextractor_windows",
                "unix": "https://github.kyndryl.net/Continuous-Engineering/ansible_role_uidextractor_unix",
                "db2": "https://github.kyndryl.net/Continuous-Engineering/ansible_role_uidextractor_db2",
                "iis": "https://github.kyndryl.net/Continuous-Engineering/ansible_role_uidextractor_iis"
            }
        },
        "job_results": {
            "ipcmon02.BlackListHost.ibm.com": {
                "db2": {
                    "bash": {
                        "message": "DB2 with bash failed due to...",
                        "action_rc": "1-4-123"
                    },
                    "perl": {
                        "message": "DB2 with Perl failed due to...",
                        "action_rc": "2-2-3333"
                    }
                },
                "mssql": {
                    "exe": {
                        "documentation": "https://github.kyndryl.net/Continuous-Engineering/ansible_role_uidextractor_mssql",
                        "action_rc": "0"
                    }
                }
            },
            "ipcmon02.ibm.com": {
                "db2": {
                    "bash": {
                        "message": "DB2 with bash failed due to...",
                        "action_rc": "1-4-123"
                    },
                    "perl": {
                        "message": "DB2 with Perl failed due to...",
                        "action_rc": "2-2-3333"
                    }
                },
                "mssql": {
                    "exe": {
                        "documentation": "https://github.kyndryl.net/Continuous-Engineering/ansible_role_uidextractor_mssql",
                        "action_rc": "0"
                    }
                }
            }
        }
    },
```

### Test Case 4: Dictionary returncode

- __Playbook code__

```yaml
---
- hosts: all
  ignore_unreachable: true
  vars:
    myrole_return_codes:
      my_error_nr1:
        rc_support: account
        rc_group: misconfiguration
        rc_number: 101
        rc_message: "Error situation number 1 happened. Please fix it."
      another_error:
        rc_support: account
        rc_group: misconfiguration
        rc_number: 102
        rc_message: "Another problem happened. Please fix it."
  tasks:
    - name: Set job properties
      include_role:
        name: returncode
        tasks_from: set_job_properties
      vars:
        asset_name: "My asset"
        documentation:
          default: "https://github.kyndryl.net/Continuous-Engineering/ansible_collection_myasset"
    # Content of playbook:
    - name: Generate RC
      include_role:
        name: returncode
      vars:
        rc_variables: "{{ myrole_return_codes['my_error_nr1'] }}"
```

- __Expected output__

```json
    "artifacts": {
        "job_properties": {
            "asset_name": "My asset",
            "documentation": {
                "default": "https://github.kyndryl.net/Continuous-Engineering/ansible_collection_myasset"
            }
        },
        "job_results": {
            "ipcmon02.BlackListHost.ibm.com": {
                "generic": {
                    "message": "Error situation number 1 happened. Please fix it.",
                    "action_rc": "1-4-101"
                }
            }
        }
    },
```
