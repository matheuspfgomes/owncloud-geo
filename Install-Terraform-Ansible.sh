#!/bin/bash 

export PATHTERRAFORM='/opt/terraform'
export MACHINE_TYPE=`uname -m` 
export TERRAFORM_x64='https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip'
export TERRAFORM_x32='https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_386.zip'
export BIN='/usr/bin'
export VERIFYANSIBLE=$(ls /usr/bin | grep -ci ansible)
export VERIFYTERRAFORM=$(ls /usr/bin | grep -ci terraform)

# Criando diretórios
[[ ! -d "$PATHTERRAFORM" ]] && mkdir "$PATHTERRAFORM" | echo "Criando diretório ${PATHTERRAFORM}" || echo "O diretório ${PATHTERRAFORM} já existe"

# Instalação Terraform para Linux
if [[ "$VERIFYTERRAFORM" == 0 ]]; then
  if [[ "$MACHINE_TYPE" == x86_64 ]]; then
    echo "Instalando Terraform x64"; wget "$TERRAFORM_x64" -P "$PATHTERRAFORM"; cd "$PATHTERRAFORM"; unzip terraform_0.11.7_linux_amd64.zip; ln -s "$PATHTERRAFORM"/terraform "$BIN"
  elif [[ "$MACHINE_TYPE" == i386 ]]; then
    echo "Instalando Terraform x32"; wget "$TERRAFORM_x32" -P "$PATHTERRAFORM"; cd  "$PATHTERRAFORM"; unzip terraform_0.11.7_linux_386.zip; ln -s "$PATHTERRAFORM"/terraform "$BIN"
  else
    echo "Problema ao identificar arquitetura do OS, Terraform não foi instalado"
  fi
else 
  echo "Já existe uma instalação do Terraform"
fi

# Instalando Ansible
if [[ "$VERIFYANSIBLE" == 0 ]]; then
    echo "Realizando instalação do Ansible"; apt-get update; apt-get install ansible
else 
    echo "Já existe uma instalação do Ansible"
fi
