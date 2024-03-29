- install docker, using file sh
```sh
    sudo apt update

    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt update

    sudo apt-cache policy docker-ce

    sudo apt install docker-ce -y

    sudo systemctl restart docker
    sudo systemctl enable docker
```
- update permission for install-docker.sh file
```sh
sudo chmod 760 install-docker.sh
```

- run install-docker.sh file
```sh
./install-docker.sh
```

- Executing the Docker Command Without Sudo
```sh
    sudo -i
    usermod -aG docker ubuntu
    chown root:docker -R /var/run/docker.sock
    chmod 660 -R /var/run/docker.sock

```
- reload terminal/session to apply config

- install jenkins on docker
```sh
    docker container run --name jenkins-server -d -p 8080:8080  -u root --privileged -p 5000:5000 -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/bin/docker  -v jenkins_home:/var/jenkins_home --group-add $(stat -c '%g' /var/run/docker.sock) jenkins/jenkins:2.451-jdk17
```

- Points the domain name to the IP address

- install nginx
```sh
sudo -i
apt install nginx -y
```

- create a config file for new domain of jenkins server
```sh
cd /etc/nginx
vi conf.d/jenkins.stephendevs.io.vn.conf
```

- content of config
```
server{
	listen 80;
	server_name jenkins.stephendevs.io.vn;
	
	location / {
		proxy_pass http://jenkins.stephendevs.io.vn:8080;
		proxy_http_version 1.1;
		proxy_set_header Upgrade $http_upgrade;
		proxy_set_header Connection keep-alive;
		proxy_set_header Host $host;
		proxy_cache_bypass $http_upgrade;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;
	}
}
```

- restart and enable nginx for first time
```sh
sudo systemctl restart nginx
sudo systemctl enable nginx
```

- run command to find password after install jenkins
```sh
    docker exec jenkins-server cat /var/jenkins_home/secrets/initialAdminPassword
```

- create admin account
  -  Username: admin
  -  Password: admin
  -  Confirm password: admin
  -  Fullname: admin
  -  E-mail address: admin@example.com 
  
- install plugin: docker, docker pipeline, maven integration, blue ocean
- restart docker container jenkins-server

- Manage Jenkins -> Tools -> Maven installation -> Add Maven: 
  - Name: my-maven
  - choose version: 3.9.3
  - then click apply, save


- add credential
  - credential 1:
    - Kind: username with password
    - username: <username of docker hub>
    - password: <password of docker hub>
    - ID: dockerhub
    - Description: dockerhub account
  - credential 2:
    - Kind: username with password
    - username: root
    - password: <password of mysql>
    - ID: mysql-root-login
    - Description: mysql-root-login