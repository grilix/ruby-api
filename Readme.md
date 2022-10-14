# Configuración

Copiar el archivo `.env.example` como `.env` y configurar los valores en este último.

Correr `docker/setup.sh`.

# Levantar el proyecto

Correr `docker/start.sh`

# Testear

Correr `docker/test.sh`

# Consola REPL

Correr `docker/run.sh api ruby ./console`


## Crear usuarios

```ruby
Services::Users::Authentication.register_user({
  username: 'name',
  password: 'pass',
})
```
