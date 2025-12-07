# preguntas por categoria - ejemplo
# AÃ±ade mÃ¡s preguntas hasta alcanzar 100+ por categorÃ­a segÃºn necesites.
# Estructura: {"pregunta":"...","respuestas":[..],"correcta":index}

const QUESTIONS := {
	"programacion": [
		{"pregunta":"Â¿QuÃ© significa 'OOP'?","respuestas":["ProgramaciÃ³n orientada a objetos","OperaciÃ³n de procesos","Open Office Project","Ordenes por Protocolo"],"correcta":0},
		{"pregunta":"Â¿CuÃ¡l es un lenguaje tipado dinÃ¡micamente?","respuestas":["Python","Java","C++","C#"],"correcta":0},
		{"pregunta":"Â¿QuÃ© estructura de datos usa FIFO?","respuestas":["Cola","Pila","Ãrbol","Grafo"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es un 'commit' en git?","respuestas":["Registrar cambios en el historial","Eliminar rama","Crear carpeta","Subir archivo"],"correcta":0},
		{"pregunta":"Â¿QuÃ© hace la sentencia 'return' en una funciÃ³n?","respuestas":["Devuelve un valor y termina la funciÃ³n","Imprime texto","Crea una variable","Inicia un bucle"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es un algoritmo de ordenamiento estable?","respuestas":["Mantiene el orden relativo de elementos iguales","Cambia el orden de elementos iguales","Ordena solo por claves","No modifica datos"],"correcta":0},
		{"pregunta":"Â¿CuÃ¡l es la complejidad promedio de quicksort?","respuestas":["O(n log n)","O(n^2)","O(n)","O(log n)"],"correcta":0},
		{"pregunta":"Â¿QuÃ© patrÃ³n crea una Ãºnica instancia de una clase?","respuestas":["Singleton","Factory","Observer","Decorator"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es una 'closure' en programaciÃ³n?","respuestas":["FunciÃ³n que captura su entorno","Clase abstracta","Tipo de dato","Operador lÃ³gico"],"correcta":0},
		{"pregunta":"Â¿QuÃ© tipo de prueba verifica un componente aislado?","respuestas":["Unitarias","IntegraciÃ³n","E2E","De carga"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es TDD?","respuestas":["Desarrollo guiado por pruebas","Desarrollo tradicional","TÃ©cnica de depuraciÃ³n","TransacciÃ³n distribuida"],"correcta":0},
		{"pregunta":"Â¿QuÃ© keyword crea una clase en Python?","respuestas":["class","def","struct","type"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es un 'merge' en git?","respuestas":["Unir dos ramas","Eliminar rama","Subir cÃ³digo","Crear repositorio"],"correcta":0},
		{"pregunta":"Â¿QuÃ© significa 'HTTP'?","respuestas":["HyperText Transfer Protocol","High Transfer Text Protocol","Hyperlink Transfer Protocol","HyperText Translate Protocol"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es una API RESTful?","respuestas":["Interfaz web que usa HTTP y recursos","Base de datos relacional","LibrerÃ­a UI","Protocolo de correo"],"correcta":0},
		{"pregunta":"Â¿CuÃ¡l es el propÃ³sito de un 'router' en una aplicaciÃ³n web?","respuestas":["Dirigir rutas a controladores","Almacenar datos","Renderizar estilos","Gestionar bases de datos"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es un 'stack overflow'?","respuestas":["Desbordamiento de pila por recursiÃ³n infinita","Sobrecarga de servidor","Tipo de dato de la pila","Error de compilaciÃ³n"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es una variable inmutable?","respuestas":["No puede cambiar su valor despuÃ©s de creada","Se puede cambiar siempre","Solo existe en tiempo de compilaciÃ³n","Es pÃºblica por defecto"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es un 'garbage collector'?","respuestas":["Mecanismo que libera memoria no usada","Herramienta para limpiar cÃ³digo","Depurador automÃ¡tico","Servidor de archivos"],"correcta":0},
		{"pregunta":"Â¿QuÃ© significa 'CI/CD'?","respuestas":["IntegraciÃ³n y entrega continua","Ciclo de desarrollo","CompilaciÃ³n incremental","Control de versiones"],"correcta":0}
	],
	"redes": [
		{"pregunta":"Â¿QuÃ© significa IP?","respuestas":["Internet Protocol","Internal Process","Internet Port","Interchange Protocol"],"correcta":0},
		{"pregunta":"Â¿QuÃ© hace un router?","respuestas":["Encaminar paquetes entre redes","Almacenar archivos","Renderizar pÃ¡ginas web","Crear direcciones IP"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es DHCP?","respuestas":["Protocolo que asigna IPs automÃ¡ticamente","Protocolo de correo","Protocolo de base de datos","Protocolo de seguridad"],"correcta":0},
		{"pregunta":"Â¿QuÃ© puerto usa HTTP por defecto?","respuestas":["80","443","22","21"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es una mÃ¡scara de subred?","respuestas":["Definir la porciÃ³n de red en una IP","Encriptar datos","Asignar hostname","Monitorizar trÃ¡fico"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es NAT?","respuestas":["TraducciÃ³n de direcciones de red","Nuevo protocolo","Herramienta de backup","Servicio de DNS"],"correcta":0},
		{"pregunta":"Â¿QuÃ© protocolo se usa para correo seguro?","respuestas":["IMAPS/SMTPS","HTTP","FTP","Telnet"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es ARP?","respuestas":["Resuelve direcciones IP a MAC","Asigna IPs dinÃ¡micas","Mide latencia","Protocolo de encriptaciÃ³n"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es una VLAN?","respuestas":["Red lÃ³gica separada dentro de una fÃ­sica","Tipo de router","Unidad de almacenamiento","Balanceador de carga"],"correcta":0},
		{"pregunta":"Â¿QuÃ© significa 'ping'?","respuestas":["Comprobar conectividad y latencia","Transferir archivos","Instalar paquetes","Monitorear CPU"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es TCP?","respuestas":["Protocolo orientado a conexiÃ³n","Protocolo sin conexiÃ³n","Lenguaje de programaciÃ³n","Servicio web"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es UDP?","respuestas":["Protocolo sin conexiÃ³n, rÃ¡pido","Protocolo seguro","Servidor de archivos","Protocolo de correo"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es SSL/TLS?","respuestas":["Capa de seguridad para comunicaciones","Lenguaje de redes","Tipo de hardware","Protocolo de routing"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es un switch?","respuestas":["Dispositivo que conecta dispositivos en una LAN","Servidor remoto","Programa antivirus","Cliente ligero"],"correcta":0},
		{"pregunta":"Â¿QuÃ© significa 'latencia'?","respuestas":["Retraso en la transmisiÃ³n de datos","Ancho de banda","Tasa de error","Velocidad de CPU"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es un firewall?","respuestas":["Dispositivo o software que controla trÃ¡fico","Tipo de cable","Protocolo de red","ConfiguraciÃ³n de DNS"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es QoS?","respuestas":["Calidad de servicio para priorizar trÃ¡fico","Consulta de servidor","Herramienta de backup","Protocolo de email"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es una direcciÃ³n MAC?","respuestas":["Identificador fÃ­sico de un dispositivo de red","IP dinÃ¡mica","Nombre de host","Clave de encriptaciÃ³n"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es SNMP?","respuestas":["Protocolo para monitoreo de dispositivos","Base de datos","Protocolo de transferencia","Lenguaje de scripting"],"correcta":0}
	],
	"bases_de_datos": [
		{"pregunta":"Â¿QuÃ© significa SQL?","respuestas":["Structured Query Language","Simple Query Language","Secure Query Language","Sequential Query Language"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es una clave primaria?","respuestas":["Identificador Ãºnico de una fila","ContraseÃ±a de usuario","Ãndice secundario","Vista de base de datos"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es normalizaciÃ³n?","respuestas":["Proceso para reducir redundancia en tablas","Respaldar datos","Actualizar Ã­ndices","Optimizar consultas"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es un Ã­ndice?","respuestas":["Estructura para acelerar consultas","Tipo de dato","Tabla temporal","Backup"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es ACID?","respuestas":["Propiedades que garantizan transacciones confiables","Tipo de base de datos","Lenguaje de consulta","Sistema de backup"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es una vista?","respuestas":["Consulta almacenada como objeto lÃ³gico","Tabla fÃ­sica","Ãndice","RelaciÃ³n"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es denormalizaciÃ³n?","respuestas":["Introducir redundancia para rendimiento","Eliminar datos","Compactar tablas","Crear Ã­ndices"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es NoSQL?","respuestas":["Bases de datos no relacionales","Lenguaje de scripting","Servidor web","Sistema operativo"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es una transacciÃ³n?","respuestas":["Grupo de operaciones atÃ³micas","Copia de seguridad","Ãndice","Consulta"],"correcta":0},
		{"pregunta":"Â¿QuÃ© es replicaciÃ³n?","respuestas":["Copiar datos entre servidores para redundancia","Normalizar datos","Crear Ã­ndices","Optimizar consultas"],"correcta":0}
	]
}

# Helper para obtener preguntas aleatorias por categorÃ­a
func get_random_questions(categoria:String, count:int) -> Array:
	var list = []
	if QUESTIONS.has(categoria):
		list = QUESTIONS[categoria].duplicate()
		list.shuffle()
		return list.slice(0, min(count, list.size()))
	else:
		return []
