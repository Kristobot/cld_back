# Usamos la misma imagen base de Elixir/Alpine
FROM elixir:1.14.1-alpine

# Establecemos el directorio de trabajo
WORKDIR /app

# Instalamos Hex y Rebar (gestores de paquetes y builds)
RUN mix local.hex --force && mix local.rebar --force

# Instalamos dependencias necesarias para desarrollo
RUN apk update && \
    apk add --no-cache \
    make \
    build-base \
    inotify-tools \
    bash \
    postgresql-client  # Cambié a PostgreSQL pero puedes usar mysql si prefieres

# Configuramos el entorno de desarrollo
ENV MIX_ENV=dev

# Copiamos solo los archivos necesarios para instalar dependencias

# Instalamos las dependencias de Elixir

# Copiamos el resto de la aplicación

CMD ["sh", "./bin/start.sh"]