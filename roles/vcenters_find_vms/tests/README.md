# Test Cases

## Test Case 1: RC 0 - Successful - Standard call with valid 1 vm 1 vcenter

Using example play according to readme with 1 vcenter and 1 vm
Expected result: 0 success, Returns 6 facts

## Test Case 2: RC 0 - Successful - Standard call with valid 2 vm 2 vcenter

Using example play according to readme with 2 vcenter and 2 vm
Expected result: 0 success, Returns 6 facts

## Test Case 3: RC1000 3000 - Fail - Invalid format of vfv_vmware_guest_names

Using example play according to readme with 1 vcenter and 1 vm
pass a string for vfv_vmware_guest_names with either space delimiting (not matching vfv_delimiter) to example playbook
Expected result: RC 1000 or 3000

## Test Case 4: RC1001 3001 - Fail - Invalid format of vfv_vmware_vcenter_names

Using example play according to readme with 1 vcenter and 1 vm
pass a string for vfv_vmware_vcenter_names with either space delimiting (not matching vfv_delimiter) to example playbook
Expected result: RC 1001 or 3001

## Test Case 5: RC1002 3002 - Fail - Invalid format of both vfv_vmware_guest_names and vfv_vmware_vcenter_names

Using example play according to readme with 1 vcenter and 1 vm
pass a string for vfv_vmware_guest_names with either space delimiting (not matching vfv_delimiter) to example playbook
pass a string for vfv_vmware_vcenter_names with either space delimiting (not matching vfv_delimiter) to example playbook
Expected result: RC 1002 or 3002

## Test Case 6: RC1003 3003 - Fail - Playbooks without vcenter cred of credtype_vc_server

Using example play according to readme with 1 vcenter and 1 vm
Remove credtype_vc_server credentials from Job template.
Expected result: RC 1003 or 3003

## Test Case 7: RC1004 3004 - Fail - Playbooks with invalid password in cred of credtype_vc_server

Using example play according to readme with 1 vcenter and 1 vm
Invalidate password in your credtype_vc_server credential
Expected result: RC 1004 or 3004

## Test Case 8: RC1005 3005 - Success - vfv_vmware_vcenter_names has an invalid entry, fail_invalid_vcenter is false

Using example play according to readme with 1 valid vcenter and 1 valid vm
add notarealvcenter to your list of vfv_vmware_vcenter_names
set fail_invalid_vcenter as false (the default)
Expected result: RC 1005 or 3005

## Test Case 9: RC1005 3005 - Fail - vfv_vmware_vcenter_names has an invalid entry, fail_invalid_vcenter is true

Using example play according to readme with 1 valid vcenter and 1 valid vm
add notarealvcenter to your list of vfv_vmware_vcenter_names
set fail_invalid_vcenter as true
Expected result: RC 1005 or 3005

## Test Case 10: RC1006 3006 - Success - vfv_vmware_guest_names has an invalid entry, fail_invalid_guest is false

Using example play according to readme with 1 valid vcenter and 1 valid vm
add notarealguest to your list of vfv_vmware_guest_names
set fail_invalid_guest as false (the default)
Expected result: RC 1006 or 3006

## Test Case 11: RC1006 3006 - Fail - vfv_vmware_guest_names has an invalid entry, fail_invalid_guest is true

Using example play according to readme with 1 valid vcenter and 1 valid vm
add notarealguest to your list of vfv_vmware_guest_names
set fail_invalid_guest as true
Expected result: RC 1006 or 3006

## Test Case 12: RC1007 3007 - Success - vfv_vmware_guest_names and vfv_vmware_vcenter_names have invalid entries

Using example play according to readme with 1 valid vcenter and 1 valid vm
add notarealguest to your list of vfv_vmware_guest_names
add notarealvcenter to your list of vfv_vmware_vcenter_names
set fail_invalid_guest as false (the default)
set fail_invalid_vcenter as false (the default)
Expected result: RC 1007 or 3007

## Test Case 13: RC1007 3007 - Fail - vfv_vmware_guest_names and vfv_vmware_vcenter_names have invalid entries

Using example play according to readme with 1 valid vcenter and 1 valid vm
add notarealguest to your list of vfv_vmware_guest_names
add notarealvcenter to your list of vfv_vmware_vcenter_names
set fail_invalid_guest as true
set fail_invalid_vcenter as true
Expected result: RC 1007 or 3007
