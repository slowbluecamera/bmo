all:
	ansible-playbook playbook.yml -i inventory

essential:
	ansible-playbook playbook.yml -i inventory --ask-become-pass --ask-vault-pass --become-method=su --tags "essential,user"

install:
	ansible-galaxy collection install -r requirements.yml
