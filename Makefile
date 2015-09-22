build:
	cp -r ~/.ssh ./.ssh
	cp -r ~/.gitconfig ./.gitconfig
	docker build -t romios/drupal .
	rm -r ./.ssh
	rm -r ./.gitconfig

run:
	docker run -i -t -d -p 127.0.0.1:88:80 -p 127.0.0.1:32:22 romios/drupal

stop:
	docker stop $(docker ps -q -f "name=romios/drupal")

ssh_connect:
	ssh -p32 root@127.0.0.1

ssh_mount:
	mkdir -p ~/localhost/drupalsite
	sudo sshfs -p32 -o allow_other root@127.0.0.1:/var/www/html ~/localhost/drupalsite

ssh_umount:
	sudo umount ~/localhost/drupalsite

clean:
	docker stop $(docker ps -a -q)
	docker rm $(docker ps -a -q)
