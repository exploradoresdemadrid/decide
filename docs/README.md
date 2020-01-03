# Decide

_Decide_ es un sistema open soure (bajo licencia MIT) para gestionar procesos de votación en asambleas y otros espacios parcicipativos. Está pensado especialmente para aquellos espacios en los que cada participante puede tener un número de votos distinto.

## ¿Cómo funciona?

En _decide_ existen dos tipos de usuarios:
- Usuarios de **administración**: Gestionan las votaciones (preguntas, opciones, tipos de votación, etc.) así como los grupos que participan en ellas (incluyendo el número de votos asignados). Tienen acceso al panel de administrción.
- Representantes de **grupos**: Participan en las votaciones con la emisión de sus votos.

## Procesos de votación

El proceso de votaciones comienza con el alta de los grupos (o entidades con derecho de voto) y las preguntas a votar (enmarcadas dentro de una votación). A continuación, cada grupo inicia sesión y emite sus votos. Una vez los grupos han votado, se pueden visualizar los resultados de la votación.

### Alta de grupos

Los usuarios con permisos de administración pueden crear y eliminar grupos, así como modificar el número de votos asociados a cada uno.

### Creación de votaciones

Los usuarios con permisos de administración tienen permisos para crear, modificar y eliminar votaciones. Las votaciones están formadas por una serie de preguntas, y cada pregunta tiene asociadas una serie de opciones.

Las votaciones tienen el siguiente ciclo de vida: 

1. **Borrador**: es posible añadir preguntas nuevas y modificar las existentes. Los contenidos son invisibles para los grupos (no así el título de la votación).
1. **Abierta**: los grupos pueden ver las preguntas de la votación y emitir sus votos. Cuando la votación está en este estado, sus preguntas no se pueden modificar.
1. **Finalizada**: Se hacen públicos los resultados, por lo que no es posible emitir más votos ni modificar las preguntas.

### Emisión de votos

Cada grupo tiene asignado un PIN único de seis dígitos que se utiliza para iniciar sesión en el sistema. Una vez iniciada sesión, los grupos pueden emitir votos en las votaciones abiertas. La emisión de votos tiene las siguientes características:

- Es necesario responder a todas las preguntas de la votación para emitir los votos.
- Es posible dividir los votos de cada pregunta entre diferentes respuestas. Por ejemplo, un grupo con 7 votos podría emitir, para una misma pregunta, 3 votos a la opción A, 2 a la opción B y uno a la opción C. También podría emitir todos los votos asociados a la misma opción.
- No es posible modificar los votos una vez emitidos.
- En las votaciones anonimizadas no se guarda la asociación de qué grupo emitió qué votos. Por este motivo, ni es posible, ni será posible relacionar de ninguna manera el sentido del voto de un grupo concreto.

### Revisión de los resultados

Una vez que la votación se encuentra en estado finalizada, es posible ver los resultados de la misma. Para cada pregunta se expone una tabla de resltados y un gráfico de barras.

## Cómo participar

Puedes participar en el proyecto de diferentes formas:
- **Enviando ideas**: ¿Quieres utilizar _Decide_ en una organización pero no se ajusta del todo a vuestras necesidades? Puedes abrir un issue para empezar a debatir la idea.
- **Reporte de errores**: ¿Has encontrado algún error en el funcionamiento? Abre un issue para reportarlo. Si es un problema relacionado con la seguridad, en lugar de abrir un issue escribe a tecnologia[at]exploradoresdemadrid[dot]org.
- **Envío de PRs**: ¿Te animas a participar con el desarrollo? Comenta en un issue abierto tu interés por hacerte cargo (o crea un ticket si no existe) y envía tu _Pull Request_
- **Propuestas de diseño**: Nos encantaría recibir propuestas para mejorar el diseño actual del servicio, tanto en la experiencia de administración como de votación. ¡No dudes en abrir un ticket para enviar tus propuestas!

## Demo

Puedes utilizar el [entorno de pruebas](https://edm-decide-beta.herokuapp.com/users/sign_in) para ver cómo funciona la creación de votaciones, preguntas, grupos, etc.
