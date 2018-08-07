Esse projeto consiste em provisionar um ambiente em Google Cloud para utilização do serviço ownCloud utilizando: Terraform, Ansible e Docker-compose
Não é obrigatório utilização do serviço Google Cloud, o ambiente ownCloud pode ser provisionado em qualquer servidor Debian/Ubuntu utilizando apenas a ferramenta Ansible e Docker-compose 

* Clone o diretório para o seu home
```
$ cd ~
$ git clone git@github.com:matheuspfgomes/owncloud-geo.git
```

* Caso ainda não tenha instalado em sua máquina as ferramentas Terraform e Ansible, pode utilizar o seguinte script:
Obs. Esse script foi desenvolvido para utilizar em Debian/Ubuntu
```
$ sudo ~/owncloud-geo/Install-Terraform-Ansible.sh
```

* Após instalação das ferramentas Terraform e Ansible, copie sua chave do Google Cloud para o diretório terraform:
Caso ainda não tenha uma chave para gerenciamento do Google Cloud, segue o link: https://console.cloud.google.com/apis/credentials/serviceaccountkey
```
$ cp GCP-key.json ~/owncloud-geo/terraform/
``` 

* Agora precisamos editar o arquivo terraform/provider.tf para inserir o nome do projeto no Google Cloud e a região que vai ser utilizada:
```
provider "google" {
    credentials = "${file("GCP-key.json")}"
    project = "geofusion-212223"
    region = "us-east1"
}
```

* Configure uma chave ssh no Google Cloud para ser importada automaticamente no servidor ao ser criado:
```
$ ssh-keygen -t rsa -f ~/.ssh/owncloud-user -C owncloud-user
$ chmod 400 ~/.ssh/owncloud-user.pub
$ cat ~/.ssh/owncloud-user.pub
```
Após ter criado a chave, copie o conteúdo da chave owncloud-user.pub e importe em: https://console.cloud.google.com/compute/metadata/sshKeys
Caso não esteja utilizando o serviço do Google Cloud e queira pular o provisionamento via Terraform, inserir a chave .pub em ~/.ssh/authorized_keys do usúario que vai ser utilizado para provisionamento pelo Ansible

* Entre no diretório do terraform e execute os seguintes comandos para provisionar o ambiente no Google:
```
$ cd ~/owncloud-geo/terraform
$ terraform init
$ terraform apply
```

* Após ter executado o terraform com sucesso, ele vai te exibir o IP público do servidor.
Copie o IP para inserir no arquivo de configuração de hosts do Ansible:
```
$ sudo vi /etc/ansible/hosts

exemplo: 
[owncloud]
IP ansible_ssh_user=owncloud-user
```

* Alterando usuário e senha ownCloud docker-compose 
```
$ vi ~/owncloud-geo/ownCloud/docker/docker-compose.yml

- OWNCLOUD_ADMIN_USERNAME=
- OWNCLOUD_ADMIN_PASSWORD=
```

* Realizando instalação do Docker, docker-compose, ownCloud
```
$ ansible-playbook ~/owncloud-geo/ansible/install-owncloud.yml
```

* Desmontando o ambiente Google Cloud
```
$ cd  ~/owncloud-geo/terraform 
$ terraform destroy
```
