#!/bin/bash

GRUPOS=("GRP_ADM" "GRP_VEN" "GRP_SEC")
DIRETORIOS=("/público" "/adm" "/ven" "/sec")
USUARIOS_ADM=("Carlos" "Maria" "joao_")
USUARIOS_VEN=("debora" "sebastiana" "roberto")
USUARIOS_SEC=("josefina" "amanda" "rogerio")
SENHA_PADRAO="Senha123"

echo "Criando grupos..."
for grupo in "${GRUPOS[@]}"; do
  groupadd "$grupo" || true
done

criar_usuarios() {
  local grupo="$1"
  local usuarios=("${@:2}")
  for usuario in "${usuarios[@]}"; do
    if ! id "$usuario" > /dev/tty 2>&1; then
      useradd "$usuario" -m -s /bin/bash -p $(openssl passwd -crypt "$SENHA_PADRAO") -G "$grupo"
      passwd -e "$usuario"
    fi
  done
}

echo "Criando usuários..."
criar_usuarios "GRP_ADM" "${USUARIOS_ADM[@]}"
criar_usuarios "GRP_VEN" "${USUARIOS_VEN[@]}"
criar_usuarios "GRP_SEC" "${USUARIOS_SEC[@]}"

echo "Configurando diretórios..."
mkdir -p /público
chmod 777 /público

for dir in "/adm" "/ven" "/sec"; do
  grupo="GRP_${dir#/}"
  grupo="${grupo^^}"
  mkdir -p "$dir"
  chown root:"$grupo" "$dir"
  chmod 770 "$dir"
done

echo "Provisionamento concluído!"
