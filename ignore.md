# notes

Ignore these notes

## config

~/.copilot/config.json

```json
{
  "banner": "never",
  "theme": "auto",
  "asked_setup_terminals": [
    "vscode"
  ],
  "last_logged_in_user": {
    "host": "https://github.com",
    "login": "tvdvoorde"
  },
  "logged_in_users": [
    {
      "host": "https://github.com",
      "login": "tvdvoorde"
    }
  ],
  "firstLaunchAt": "2026-03-11T00:00:00.000Z",
  "trusted_folders": [
    "/Users/t.van.der.voorde/repo/public/copilot-cli-for-beginners",
    "/Users/t.van.der.voorde/architect"
  ],
  "allowed_urls": [
    "https://learn.microsoft.com",
    "https://12factor.net",
    "https://cheatsheetseries.owasp.org",
    "https://owasp.org",
    "https://www.postgresql.org",
    "https://opentelemetry.io",
    "https://docs.gunicorn.org",
    "https://wiki.postgresql.org"
  ],
  "installed_plugins": [
    {
      "name": "microsoft-docs",
      "marketplace": "",
      "version": "0.3.1",
      "installed_at": "2026-03-19T08:06:13.117Z",
      "enabled": true,
      "cache_path": "/Users/t.van.der.voorde/.copilot/installed-plugins/_direct/microsoftdocs--mcp",
      "source": {
        "source": "github",
        "repo": "microsoftdocs/mcp"
      }
    }
  ],
  "model": "claude-opus-4.6"
}
```

## mcp

~/.copilot/mcp-config.json

```json
{
  "mcpServers": {
    "playwright": {
      "type": "local",
      "command": "npx",
      "tools": [
        "*"
      ],
      "args": [
        "@playwright/mcp@latest"
      ]
    },
    "brave-search-mcp-server": {
      "command": "npx",
      "args": ["-y", "@brave/brave-search-mcp-server", "--transport", "stdio"],
      "env": {
        "BRAVE_API_KEY": "xxxxxxxxxxxxxxxxx"
      }
    }
  }
}
```

## links

https://github.blog/changelog/2026-04-07-copilot-cli-now-supports-byok-and-local-models/

brew upgrade ollama
ollama serve
ollama run gemma4:e4b

## copilot

export COPILOT_PROVIDER_BASE_URL=http://localhost:11434/v1
export COPILOT_MODEL=gemma4:e4b
export COPILOT_MODEL=qwen3.5:35b-a3b-coding-nvfp4

export COPILOT_PROVIDER_BASE_URL=
export COPILOT_MODEL=
copilot --yolo --stream on --effort xhigh

## tips

python3 -m markitdown oracle-data-safe-design-decisions.pptx > presentation.md

Check if the following topics are discussed in @presentation.md

## sample prompts

```
/research You are an architect preparing materials for workshop
 
Create a list of design decisions that need to be made regarding the design and implementation of Oracle Data Safe for databases hosted in Oracle Database @ Azure
 
Assume Oracle Database @ Azure is already implemented in an azure landingzone in a hub/spoke model and used fully in production.
 
The setup does NOT use autonomous databases
 
Use these URL’s for references - seek other references if needed
 
https://docs.oracle.com/en/cloud/paas/data-safe/index.html
 
Group the design decisions logically. Cover each area as shown below

Output should be a powerpoint PPTX
 
Put every decision on its own slide - make it a matrix in the following format
 
Upper left: decision
Upper right: options
Lower left: recommendation and impact if not chosen
Lower right: links and info
 
Create a few introduction slides as well about the topic and approach
 
```

 



You are an architect preparing materials for workshop
 
Create a list of design decisions that need to be made regarding the design and implementation of LDAP integration when connecting to Oracle VM's in Oracle Database @ Azure

A design decision should include some background, possible options, a preferred option and the impact if not chosen. Also include links to valid references
 
Assume Oracle Database @ Azure is already implemented in an azure landingzone in a hub/spoke model and used fully in production.

There is already an active solution for privileged access, called PAUL ( Privileged Access Unix Linux) - this solution is based on an LDAPS service and integrates with SSH deamons. Below you'll find the Ansible playbook to integrate this on RHEL8

Oracle VM's use Oracle Linux

Group the design decisions logically

Focus on anything that is different between Oracle Linux and RHEL, and any decisions that need to made regarding the Oracle Database @ Azure setup. 

The primary goal is to be able to better track who is accessing VM's and who elevates to sudo. 

Include the monitoring and auditing aspects as well


The playbook for reference

- name: copy nsswitch configuration file
  copy: 
   src: files/openldap/nsswitch.conf
   dest: "{{ item }}"
  loop:
    - /etc/nsswitch.conf
    - /etc/nsswitch.ldap

- name: copy openldap configuration file
  copy: 
   src: files/openldap/openldap_ldap.conf
   dest: /etc/openldap/ldap.conf

- name: create symlink to /etc/openldap/cacerts
  file: 
   src: /etc/openldap/certs
   dest: /etc/openldap/cacerts
   state: link

- name: copy openldap certificate
  copy: 
   src: files/openldap/afpki_prod.pem
   dest: /etc/openldap/cacerts/afpki.pem

- name: get certificate hash
  command: "openssl x509 -noout -hash -in /etc/openldap/cacerts/afpki.pem"
  register: cert_hash_result

- name: create symlink to certificate hash
  file: 
   src: /etc/openldap/cacerts/afpki.pem
   dest: "/etc/openldap/cacerts/{{ cert_hash_result.stdout }}.0"
   state: link

- name: install packages
  yum: 
   name: "{{ item }}"
   state: latest
  loop: 
    - sssd
    - openldap-clients  
    - openldap-devel
    - audit
    - openssh-clients
    - openssh-server
    - nscd
- name: create log directories
  file: 
    path: "{{ item }}"
    state: directory
  loop:
    - /var/log/traces
    - /var/log/traces/sar

- name: copy sssd configuration file
  copy: 
   src: files/openldap/sssd_sssd.conf
   dest: /etc/sssd/sssd.conf
   mode: '0600'

- name: Add override_homedir to the sssd conf
  lineinfile:
    path: /etc/sssd/sssd.conf
    line: override_homedir = /home/%u
    create: yes

- name: enable PasswordAuthentication
  ansible.builtin.lineinfile:
    path: /etc/ssh/sshd_config
    regexp: '^PasswordAuthentication'
    line: PasswordAuthentication yes
        
- name: authconfig setup
  command: /usr/sbin/authconfig --enablesssdauth --enablemkhomedir  --update
 
- name: copy sudoers file
  copy:
   src: files/openldap/etc_sudoers
   dest: /etc/sudoers

- name: copy access conf file
  copy:
   src: files/openldap/etc_security_access.conf
   dest: /etc/security/access.conf

- name: Add paul new family block
  block:
   - name: add paul family {{ paul_family }} to access.conf
     lineinfile:
       path: /etc/security/access.conf
       insertafter: "^# Insert your valid access.conf"
       line: "+:{{ paul_family }}:ALL"

   - name:  add paul family {{ paul_family }} to sudoers
     lineinfile:
       path: /etc/sudoers
       line: "%{{ paul_family }} ALL=(ALL) ALL"
       validate: /usr/sbin/visudo -cf %s

  when: paul_family is defined and paul_family != ''

- name: Restart ssh
  service:
    name: sshd
    state: restarted

- name: restart and enable sssd
  service: 
    name: sssd
    enabled: yes
    state: restarted





