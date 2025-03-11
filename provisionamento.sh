#!/bin/bash

#atualiza para instalação do mkpasswd
apt-get update
apt-get install whois

# Definição das arrays
GRUPOS=("GRP_ADM" "GRP_VEN" "GRP_SEC")
DIRETORIOS=("/publico" "/adm" "/ven" "/sec")
USUARIOS_ADM=("carlos" "maria" "joao")
USUARIOS_VEN=("debora" "sebastiana" "roberto")
USUARIOS_SEC=("josefina" "amanda" "rogerio")
SENHA_PADRAO="Senha123"

echo "Criando diretórios..."

# Criação dos diretórios
for dir in "${DIRETORIOS[@]}"; do
    mkdir -p "$dir"
done

echo "Criando grupos de usuários..."

# Criação dos grupos
for grupo in "${GRUPOS[@]}"; do
    groupadd "$grupo"
done

echo "Criando usuários..."

# Função para criar usuários
create_user() {
    useradd "$1" -m -s /bin/bash -p $(mkpasswd -m sha-512 "$SENHA_PADRAO") -G "$2"
}

# Criação de usuários para cada grupo
for usuario in "${USUARIOS_ADM[@]}"; do
    create_user "$usuario" "GRP_ADM"
done

for usuario in "${USUARIOS_VEN[@]}"; do
    create_user "$usuario" "GRP_VEN"
done

for usuario in "${USUARIOS_SEC[@]}"; do
    create_user "$usuario" "GRP_SEC"
done

echo "Especificando permissões dos diretórios..."

# Configuração de permissões
chown root:GRP_ADM /adm
chown root:GRP_VEN /ven
chown root:GRP_SEC /sec

chmod 770 /adm
chmod 770 /ven
chmod 770 /sec
chmod 777 /publico

echo "Fim do provisionamento"
