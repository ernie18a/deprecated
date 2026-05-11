```yml
---
- name: echo
  script: ../../../scripts/echo.sh
  environment:
    RD: "{{ RD.stdout }}"
  register: RD
- name: debug
  debug:
    var: RD.stdout_lines
---
- name: script + register
  script: ../../../scripts/register.sh
  register: RD
# name: debug
# debug:
#   var: RD.stdout_lines
echo $RD
echo FROM.REGISTER.SH
```
