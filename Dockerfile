FROM ubuntu:latest

# Actualizar y preparar el sistema
RUN apt-get update && \
    apt-get install -y software-properties-common curl gnupg && \
    rm -rf /var/lib/apt/lists/*

# Agregar la clave GPG en el directorio recomendado
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Agregar el repositorio oficial de HashiCorp
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list

# Instalar Terraform
RUN apt-get update && apt-get install -y terraform && rm -rf /var/lib/apt/lists/*

# Establecer directorio de trabajo
WORKDIR /tmp
