build:
	cp -r ~/.ssh ./ssh
	cp -r ~/.gitconfig ./gitconfig
	docker build -t romios/drupal .
	rm -r ./ssh
	rm -r ./gitconfig

run:
	docker run -i -t -d -p 127.0.0.1:88:80 -p 127.0.0.1:32:22 romios/drupal

ssh_connect:
	ssh -p32 root@127.0.0.1

ssh_mount:
	umount ~/localhost/drupalsite
	mkdir -p ~/localhost/drupalsite
	sudo sshfs -p32 -o allow_other root@localhost:/var/www/html ~/localhost/drupalsite

clean:
	docker stop $(docker ps -a -q)
	docker rm $(docker ps -a -q)
