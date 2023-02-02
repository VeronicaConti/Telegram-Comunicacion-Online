# Telegram-Comunicacion-Online
Este sistema de mensajería personal permite a sus usuario tener conversaciones entre si.
El sistema permite a un usuario crear una cuenta y comenzar a mantener conversaciones
uno a uno con otros usuarios. Cada conversación contiene todos los mensajes entre los 2
usuarios. Un usuario puede elegir borrar su cuenta cuando lo desee, borrando toda las
conversaciones en las que haya estado.
El sistema utiliza archivos para persistir su información entre ejecuciones. Cuando el
sistema inicia su ejecución toda la información que contienen es volcada a memoria
principal en las estructuras que se explicaron previamente. Cuando el sistema termina la
ejecución, estos archivos son regenerados por completo desde cero con la información
existente en memoria principal.
El sistema tiene un menú de 2 niveles. En el primer nivel, las opciones son las siguientes:
1. Login: esta opción pide el Nombre de usuario y su password, verificando que
existan y sean correctos. Si es así, el resultado será que se mostrará el segundo
nivel de menú para ese usuario.
2. Nuevo Usuario: esta opción solicita el Nombre y un password y crea un nuevo usuario en ArbUsuarios.
Deberá comprobarse que el Nombre ingresado no exista previamente en el sistema.
3. Ver Usuarios hiperconectados: esta opción muestra el listado completo en orden
de cantidad de conversaciones en que participa cada uno de mayor a menor
mostrando todos los Nombres. 
4. Salir: esta opción termina la ejecución del programa, volcando previamente toda la
información a sus archivos.
Al segundo nivel de menú, se accede luego de ejecutar exitosamente la opción de Login.
Esta pantalla muestra información de la cuenta del usuario y le da las opciones de
comandos que puede ejecutar.
Las opciones a las que tiene acceso son:
1. Listar conversaciones activas: son aquellas conversaciones en las que el usuario
tiene mensajes “no leídos”. En esta lista se muestra por cada conversación el Nombre del otro usuario,
el código de conversación, y la cantidad de mensajes no leídos. Un mensaje “no leído” por este usuario, 
es un mensaje que tiene ese estado y fue escrito por el otro usuario con quien está manteniendo la conversación.
2. Listar todas las conversaciones: este listado muestra todas las conversaciones en la
que el usuario logueado participa o participó. Se muestra por cada conversación, el
código, y el Nombre del otro usuario.
3. Ver últimos mensajes de conversación: El usuario debe ingresar el código de
conversación y el sistema le mostrará los mensajes no leídos que están en la conversación.
Los mensajes que no fueron escritos por el usuario y que estaban con
estado “no leído” deben pasar a “leído”.
4. Ver conversación: El usuario debe ingresar el código de la conversación que desea
ver y el sistema le mostrará todos los mensajes de la misma.
5. Contestar mensaje: El usuario debe ingresar el código de la conversación, el
sistema le mostrará los últimos 5 mensajes de la misma, y le pedirá que ingrese el
nuevo mensaje. El sistema completará los datos necesarios para almacenarlo
(fecha y hora, usuario). Este mensaje aparecerá con estado “no leído” para el
destinatario.
6. Nueva conversación: El usuario podrá crear una conversación con otro, si no existe
previamente una. Para esto, el usuario deberá ingresar el Nombre del destinatario
y el sistema luego de chequear que el Nombre sea válido, creará una nueva
conversación asignándole un nuevo código, que se obtiene sumando 1 al último
código de conversación existente.
7. Borrar Usuario: Esta opción elimina del sistema toda la información del usuario
logueado, incluyendo todas las conversaciones y mensajes en las que participó. No
se podrá borrar si aún tiene mensajes sin leer. Luego de ejecutado este comando,
el sistema vuelve al nivel 1 del menú.
8. Logout: Esta opción termina la sesión del usuario, volviendo al nivel 1 del menú.
