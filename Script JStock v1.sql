DROP DATABASE IF EXISTS jstock;
CREATE DATABASE jstock;
USE jstock;


/*
El modelo de datos se podría dividir en 4 partes:
	-topología: aquellas tablas que van a conformar la información relativa a las ubicaciones
	-inventariado: aquellas tablas que nos dan información sobre el inventario
	-usuarios y gestión de inventarios: cada X tiempo se va a tener que hacer un nuevo inventario, por lo tanto, debemos saber quién lo ha hecho, cuándo, y qué objetos figuran en este
	
Las partes 1 y 2 están relacionadas entre sí
*/

#TOPOLOGÍA
/*
3 tablas:
	- ALA: Las alas que tenga el instituto
	- PLANTA: Las plantas que tenga el instituto
	- AULA: Las aulas que tenga el instituto
	
Lógica:
	- Un ala tiene varias plantas 1:N
	- Una planta tiene varias aulas 1:N
	- Un aula PUEDE tener varios objetos (o no... baños, departamentos, aulas vacías, en obras...) 0:N
	
*/

CREATE TABLE ala(
id INT(11) NOT NULL PRIMARY KEY,
nombre VARCHAR (40) NOT NULL UNIQUE

);

CREATE TABLE planta(
id INT(11) NOT NULL PRIMARY KEY,
nombre VARCHAR (40) NOT NULL UNIQUE,
id_ala INT(11) NOT NULL,
mapa VARCHAR (255) NOT NULL, #del mapa se meterá el nombre/ruta de un archivo que proporcionará la API, en un principio

FOREIGN KEY (id_ala) REFERENCES ala(id)

);

CREATE TABLE aula(
id INT(11) NOT NULL PRIMARY KEY,
nombre VARCHAR (40) NOT NULL UNIQUE,
id_planta INT (11) NOT NULL,
id_ala INT(11) NOT NULL,
num_objetos INT DEFAULT 0,

FOREIGN KEY (id_ala) REFERENCES ala(id),
FOREIGN KEY (id_planta) REFERENCES planta(id)

);

#INVENTARIADO
/*
Aquí es dónde entran las operaciones CRUD que puede hacer el usuario (no tendría sentido que las partes del instituto pudieran ser modificadas, EN PRINCIPIO)

3 Tablas:
	- Categoría: Para facilitar la supervisión de los objetos, muchos pueden clasificarse en grupos. Por ejemplo, los PCs y teclados pertenecerían al categoria "Informática".
	- Objeto: El objeto en sí, que tendrá su propio id y de esta manera se podrá relacionar con su etiqueta.
	- Etiqueta: Entendemos que las etiquetas ya están hechas por tiradas, por lo tanto se les crea un id (el número de la etiqueta en sí misma) y se les asocia un objeto a través de su id.
	
Lógica:
	Un objeto pertenece a un sólo categoria 1:1
	Un objeto tiene una etiqueta 1:1
	Un objeto sólo está en un aula 1:1
	Un objeto se asocia a uno o varios inventarios 1:N
	Un usuario realiza uno o más inventarios 1:N
	

*/

CREATE TABLE categoria(
id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR (255) NOT NULL UNIQUE,
num_objetos INT DEFAULT 0

);

CREATE TABLE objeto(
id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR (255) NOT NULL,
descripcion VARCHAR (255) NOT NULL,
num_serie VARCHAR(255) UNIQUE,
categoria INT(11) NOT NULL,
fechaAlta DATETIME DEFAULT NOW(),
fechaBaja DATETIME DEFAULT NULL,
id_aula INT (11) NOT NULL,

FOREIGN KEY (categoria) REFERENCES categoria(id),
FOREIGN KEY (id_aula) REFERENCES aula(id)

);


CREATE TABLE etiqueta(
id INT (11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
id_objeto INT (11) NOT NULL,

FOREIGN KEY (id_objeto) REFERENCES objeto(id)

);

#EL USUARIO Y LA GESTIÓN DE LOS INVENTARIOS
/*
Vamos a poder manejar dos tipos de usuarios, el master o root, que poseerá todos los privilegios a la hora de manejar el inventario,
y los usuarios comunes, que tendrán acciones más limitadas. Se ha barajado la posibilidad (lo que no quiere decir que se vaya a implementar) de que, 
para dar de alta un inventario en la base de datos, el usuario o usuarios master reciban primero una especie de "pull request" que confirme esa adición.

3 tablas:
	- Usuario: Para saber quién registra objetos en un inventario.
	- Inventario: Cada x tiempo se tendrá que hacer un inventario nuevo.
	- Inventario_objeto: Es la manera que tenemos de relacionar los objetos con el inventario al que pertenecen.
*/

CREATE TABLE usuario(
id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
nickname VARCHAR (80) NOT NULL UNIQUE,
nombre VARCHAR(255) NOT NULL,
pwd VARCHAR (255) NOT NULL,
admn BOOLEAN DEFAULT FALSE,
activo BOOLEAN DEFAULT TRUE

);


CREATE TABLE inventario(
id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR(80) NOT NULL,
fecha DATETIME NOT NULL

);


CREATE TABLE inventario_objeto(
id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
id_inventario INTEGER NOT NULL,
id_objeto INTEGER NOT NULL,
id_aula INTEGER NOT NULL,
id_usuario INTEGER NOT NULL,
fechaRegistro DATETIME NOT NULL,

FOREIGN KEY (id_inventario) REFERENCES inventario(id),
FOREIGN KEY (id_objeto) REFERENCES objeto(id),
FOREIGN KEY (id_usuario) REFERENCES usuario(id),
FOREIGN KEY (id_aula) REFERENCES aula(id)
);


DESCRIBE ala;
DESCRIBE planta;
DESCRIBE aula;
DESCRIBE categoria;
DESCRIBE etiqueta;
DESCRIBE objeto;
DESCRIBE inventario;
DESCRIBE inventario_objeto;
DESCRIBE usuario;

SELECT*FROM ala;
SELECT*FROM planta;
SELECT*FROM aula;
SELECT*FROM categoria;
SELECT*FROM etiqueta;
SELECT*FROM objeto;
SELECT*FROM inventario;
SELECT*FROM inventario_objeto;
SELECT*FROM usuario;


#CONSULTAS BÁSICAS QUE VA A NECESITAR LA APLICACIÓN DE JSTOCK

/********** DQL *************
- ¿Qué necesito que la base de datos LE DIGA al usuario sobre lo que ACTUALMENTE existe en la base de datos?
- Información con la cual voy a rellenar elementos como listas y comboboxes
*/


/*
	ANTES DE EMPEZAR A ETIQUIETAR NADA, NECESITTO SABER DÓNDE ESTOY
	- La consulta principal será el saber dónde estoy exactamenter a través del aula, que tiene información sobre la planta y el ala sobre las
	  que está situada.
*/

#si quiero saber el ala
SELECT ala.nombre
FROM ala 
INNER JOIN aula
ON ala.id = aula.id_ala
WHERE aula.id = 1;

#si quiero saber la planta
SELECT planta.nombre
FROM planta
INNER JOIN aula
ON aula.id_planta = planta.id
WHERE aula.id = 1;

#si quiero obtener la topología entera a través del aula (por ejemplo, con una lectura de etiqueta)
SELECT ala.id AS idAla, planta.id AS idPlanta, aula.id AS idAula, ala.nombre AS ala, planta.nombre AS planta, aula.nombre AS aula
FROM planta
INNER JOIN aula
ON aula.id_planta = planta.id
INNER JOIN ala
ON aula.id_ala = ala.id
WHERE aula.id = 1;


/* 
	LECTURA DE LAS ETIQUETAS
	- Voy a leer etiquetas con el teléfono móvil, por lo tanto, cuando eso ocurra, la aplicación tendrá que realizar la siguiente consulta
*/

SELECT et.id AS etiqueta, ob.id AS ID_OBJETO, ob.nombre AS objeto, cat.nombre AS categoria, au.nombre AS aula, pl.nombre AS planta, al.nombre AS ala    
FROM etiqueta et

INNER JOIN objeto ob
ON et.id_objeto = ob.id
INNER JOIN categoria cat
ON ob.categoria = cat.id
INNER JOIN aula au
ON ob.id_aula = au.id
INNER JOIN planta pl
ON au.id_planta = pl.id
INNER JOIN ala al
ON au.id_ala = al.id

WHERE et.id = 11
ORDER BY et.id;


/*
	INFORMACIÓN SOBRE UN ALA EN PARTICULAR
	- ¿En qué ala estoy?
	- ¿Cuántas plantas tiene ese ala? Y por lo tanto...
	- ¿Cuántas aulas hay en ese ala? Y por lo tanto...
	- ¿Cuántos objetos hay en ese ala? Y por lo tanto...
	- ¿Cuántas categorías figuran en ese ala?
*/

SELECT*FROM ala;

#en qué ala estoy
SELECT ala.id as idAla, ala.nombre AS ala
FROM ala
WHERE ala.id = 1;

#cuántas plantas?
SELECT planta.id AS idPlanta, planta.nombre AS planta
FROM planta
WHERE planta.id_ala = 1;                               #SE PODRÍA HACER CON INNER JOIN TAMBIÉN, ESTA FORMA ES MÁS SIMPLE

#cuántas aulas
SELECT aula.id AS idAula, aula.nombre AS aula
FROM aula
WHERE aula.id_ala = 1;											#SE PODRÍA HACER CON INNER JOIN TAMBIÉN, ESTA FORMA ES MÁS SIMPLE

#cuántos objetos tiene ese ala?
SELECT COUNT(ob.id)
FROM objeto ob
INNER JOIN aula
ON aula.id = ob.id_aula
WHERE aula.id_ala = 1;											#SE PODRÍA HACER CON INNER JOIN TAMBIÉN, ESTA FORMA ES MÁS SIMPLE

#qué objetos tiene ese ala?
SELECT et.id AS etiqueta, ob.id AS ID_OBJETO, ob.nombre AS objeto, cat.nombre AS categoria, au.nombre AS aula, pl.nombre AS planta  
FROM etiqueta et

INNER JOIN objeto ob
ON et.id_objeto = ob.id
INNER JOIN categoria cat
ON ob.categoria = cat.id
INNER JOIN aula au
ON ob.id_aula = au.id
INNER JOIN planta pl
ON au.id_planta = pl.id
INNER JOIN ala al
ON au.id_ala = al.id

WHERE al.id = 1
ORDER BY et.id;

/*
	INFORMACIÓN SOBRE UNA PLANTA EN PARTICULAR
	- ¿En que planta estoy?      													ESTARÍA BIEN AQUÍ PEDIR EL MAPA
	- ¿Cuántas aulas hay en esa planta? Y por lo tanto...
	- ¿Cuántos objetos hay en esa planta? Y por lo tanto...
	- ¿Cuántas categorías figuran en esa planta?
	
*/

SELECT*FROM planta;

#en qué planta estoy?
SELECT planta.id as idPlanta, planta.nombre AS planta
FROM planta
WHERE planta.id = 1;

#cuántas aulas
SELECT aula.id AS idAula, aula.nombre AS aula
FROM aula																		#SE PODRÍA HACER CON INNER JOIN TAMBIÉN, ESTA FORMA ES MÁS SIMPLE
WHERE aula.id_planta = 1;	

#cuántos objetos tiene esa planta?
SELECT COUNT(ob.id)
FROM objeto ob																	#SE PODRÍA HACER CON INNER JOIN TAMBIÉN, ESTA FORMA ES MÁS SIMPLE
INNER JOIN aula
ON aula.id = ob.id_aula
WHERE aula.id_planta = 1;

#qué objetos tiene ese planta?
SELECT et.id AS etiqueta, ob.id AS ID_OBJETO, ob.nombre AS objeto, cat.nombre AS categoria, au.nombre AS aula
FROM etiqueta et

INNER JOIN objeto ob
ON et.id_objeto = ob.id
INNER JOIN categoria cat
ON ob.categoria = cat.id
INNER JOIN aula au
ON ob.id_aula = au.id
INNER JOIN planta pl
ON au.id_planta = pl.id

WHERE pl.id = 1
ORDER BY et.id;


/* 
	INFORMACIÓN SOBRE LOS OBJETOS DE UN AULA EN PARTICULAR
	- Toda la información sobre los objetos de un aula (sin su etiquetado y con su etiquetado)
	- El nombre de los objetos de un aula
	- Un objeto concreto dentro de un aula (otra con sólo su nombre y otra con nombre y etiqueta)
	- El nombre de las categorías de los objetos que están contenidos en un mismo aula
	- El número de objetos que contiene un aula (2 maneras: a través de la función de agrupación COUNT o consultando el campo calculado
*/

SELECT*FROM aula;

SELECT ob.id, ob.nombre, ob.descripcion, ob.num_serie, cat.nombre, ob.fechaAlta, ob.fechaBaja, ob.id_aula
FROM objeto ob
INNER JOIN categoria cat
ON ob.categoria = cat.id
WHERE id_aula = 1
ORDER BY ob.id;

#lo mismo que la consulta anterior pero mostrando el objeto con su etiqueta actual
SELECT et.id AS etiqueta, ob.id, ob.nombre, ob.descripcion, ob.num_serie, cat.nombre, ob.fechaAlta, ob.fechaBaja, ob.id_aula 
FROM objeto ob
INNER JOIN etiqueta et
ON ob.id = et.id_objeto
INNER JOIN categoria cat
ON ob.categoria = cat.id
WHERE ob.id_aula = 1
ORDER BY et.id;

SELECT nombre
FROM objeto
WHERE id_aula = 1
ORDER BY id;


SELECT et.id AS etiqueta, ob.id, ob.nombre, ob.descripcion, ob.num_serie, cat.nombre, ob.fechaAlta, ob.fechaBaja, ob.id_aula 
FROM objeto ob
INNER JOIN etiqueta et
ON ob.id = et.id_objeto
INNER JOIN categoria cat
ON ob.categoria = cat.id
WHERE ob.id_aula = 1 AND et.id = 10;

SELECT ob.nombre
FROM objeto ob
INNER JOIN etiqueta et
ON ob.id = et.id_objeto
WHERE id_aula = 1 AND et.id = 10;

SELECT DISTINCT cat.nombre
FROM categoria cat
INNER JOIN objeto ob
ON cat.id = ob.categoria
WHERE ob.id_aula = 1;    #muy útil para lo filtros en búsquedas, los resultados de esta consulta podrían meterse en un combobox

SELECT COUNT(id)
FROM objeto
WHERE id_aula = 1; #podemos consultar los objetos de un aula sin acceder a su campo num_objetos

						/* OJO: Si no se ha programado un procedimiento/trigger en la base de datos o bien un método en la parte DAO de la app que actualice automáticamente
		  					el campo num_objetos cada vez que un objeto sea registrado en un aula, la siguiente consulta va a fallar, por eso hay que ser muy cuidadosos con los
		  					campos calculados
						*/
		
SELECT num_objetos
FROM aula
WHERE id = 1; #consultamos el número de objetos de un aula a través del campo num_onbjetos




/*
	INFORMACIÓN SOBRE LOS OBJETOS
	- Toda su información al leer su etiqueta (línea 217)
	- ¿Dónde está?
	- ¿En qué inventarios aparece?
	- ¿Cuándo fue dado de alta? 
	- ¿Ha sido dado de baja? ¿Cuándo?
	- Categoría a la que pertenece
	- Qué etiqueta le corresponde
	*/

#Dónde está
SELECT aula.id AS idAula, aula.nombre AS aula
FROM aula
INNER JOIN objeto
ON aula.id = objeto.id_aula
WHERE objeto.id = 1;

#En qué inventarios aparece
SELECT it.id as idInventario, it.nombre AS inventario, it.fecha AS fechaInventario, ivo.id_aula aulaInventario, ob.fechaAlta AS fechaAlta_objeto, ob.id_aula AS aulaObjeto
FROM inventario it
INNER JOIN inventario_objeto ivo
ON it.id = ivo.id_inventario
INNER JOIN objeto ob
ON ivo.id_objeto = ob.id
WHERE ob.id = 1;                  /*Con esta consulta, además de saber en qué inventarios está registrado el objeto, se puede ver si ha habido cambios entre dónde estaba (fechaInventario)
                                    y dónde está ahora (aulaObjeto). O también, si se ha registrado en un aula dónde no debería estar, y problemas relacionados. Las fechas nos ayudarán
                                    a determinar cuál es el caso
											 																																												*/

#fecha de ALTA
SELECT fechaAlta
FROM objeto
WHERE id = 1;

#fecha de BAJA
SELECT fechaBaja
FROM objeto
WHERE id = 1;

#categoría del objeto
SELECT cat.id AS idCategoría, cat.nombre AS categoría
FROM objeto ob
INNER JOIN categoria cat
ON ob.categoria = cat.id
WHERE ob.id = 1;

#cuál es su etiqueta
SELECT et.id
FROM objeto ob
INNER JOIN etiqueta et
ON ob.id = et.id_objeto
WHERE ob.id = 1;

/*
	LO QUE VOY A PREGUNTAR A LAS CATEGORÍAS
	- Filtros de búsqueda avanzada
*/

#dime todos los objetos que pertencen a x categoría
SELECT ob.*
FROM objeto ob
INNER JOIN categoria cat
ON ob.categoria = cat.id
WHERE cat.id = 1;

#cuántas existencias hay dentro de una misma categoría
SELECT COUNT(ob.id)
FROM objeto ob
INNER JOIN categoria cat
ON ob.categoria = cat.id
WHERE cat.id = 1;

/*
	INFORMACIÓN SOBRE EL INVENTARIO
	- Qué objetos pertenecen a un inventario
	- Quién los registró
	- Cuántas existencias tiene un inventario
*/

#objetos pertenencientes a inventario x
SELECT inv.nombre AS inventario, et.id, ob.id, ob.nombre, ob.descripcion, ob.num_serie, cat.nombre, ivo.fechaRegistro, aula.nombre AS aula, pl.nombre AS planta, ala.nombre AS ala
FROM objeto ob
INNER JOIN etiqueta et
ON ob.id = et.id_objeto
INNER JOIN categoria cat
ON ob.categoria = cat.id
INNER JOIN aula
ON ob.id_aula = aula.id
INNER JOIN planta pl
ON aula.id_planta = pl.id
INNER JOIN ala 
ON aula.id_ala = ala.id
INNER JOIN inventario_objeto ivo
ON ivo.id_objeto = ob.id
INNER JOIN inventario inv
ON inv.id = ivo.id_inventario
WHERE inv.id = 1;

#quién registró x objeto/inventario
SELECT usu.nickname, ob.id, ob.nombre
FROM usuario usu
INNER JOIN inventario_objeto ivo
ON usu.id = ivo.id_usuario
INNER JOIN objeto ob
ON ivo.id_objeto = ob.id
WHERE ivo.id_inventario = 1;              /*en este caso obtenemos un duplicado del objeto con id 2, dado que lo han registrado dos usuarios en diferente ocasión. 
															Por eso es importante el Pull Request que se comentó, o bien poner atributos que se puedan repetir (consecuencia de errores)
															con la resticción UNIQUE, para que de por sí la BD no lo permita. Si se deja como está, habría que, como mínimo, avisar al usuario
															por mensaje que el objeto que intenta registrar ya está en ese inventario y jugar con las fechas si lo que queremos es tenerlo registrado y,
															aunque esté duplicado, lo hagamos para dejar constancia de que estuvo en el otro aula...*/

#número de objetos en un inventario												
SELECT COUNT(id_objeto)
FROM inventario_objeto
WHERE id_inventario = 1;                   /*POR EL MOTIVO ANTERIOR, OBTENDRÍAMOS DUPLICADOS, LO MEJOR SERÍA CAMBIAR EL id_objeto de la tabla inventario_objeto a UNIQUE,
															de manera que, si lo que quiero es registrar que un objeto se ha movido de sitio, llamo a un UPDATE sobre las tablas necesarias
															y así evito los duplicados*/






/************OPERACIONES DML***************/


INSERT INTO ala (id, nombre) VALUES
(1, "Ala Izquierda"),
(2, "Ala Derecha");

INSERT INTO planta (id_ala, id, nombre, mapa) VALUES
(1, 0, "Planta Baja Izquierda", "map"),
(1, 1, "Planta 1 Izquierda", "map"),
(1, 2, "Planta 2 Izquierda", "map"),
(2, 3, "Planta Baja Derecha", "map"),
(2, 4, "Planta 1 Derecha", "map"),
(2, 5, "Planta 2 Derercha", "map");

INSERT INTO aula (id_ala, id_planta, id, nombre) VALUES
(1, 2, 0, "AULA 0"),
(1, 2, 1, "AULA 1");

INSERT INTO categoria (nombre) VALUES
("Informática"),
("Proyectores"),
("Periféricos"),
("Herramientas");

INSERT INTO objeto (nombre, descripcion, categoria, id_aula) VALUES
("PC HP", "Ordenador de sobremesa alta gama marca HP", 1, 0),
("PC HP", "Ordenador de sobremesa alta gama marca HP", 1, 0),
("PC HP", "Ordenador de sobremesa alta gama marca HP", 1, 0),
("PC HP", "Ordenador de sobremesa alta gama marca HP", 1, 0),
("PC HP", "Ordenador de sobremesa alta gama marca HP", 1, 0),
("PC HP", "Ordenador de sobremesa alta gama marca HP", 1, 0),
("PC HP", "Ordenador de sobremesa alta gama marca HP", 1, 0),
("Proyector BENQ", "Proyector BENQ con 300 luds", 2, 1),
("PC HP", "Ordenador de sobremesa alta gama marca HP", 1, 1),
("PC HP", "Ordenador de sobremesa alta gama marca HP", 1, 1),
("Proyector BENQ", "Proyector BENQ con 300 luds", 2, 1);


INSERT INTO etiqueta (id_objeto) VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11);



INSERT INTO usuario (nickname, nombre, pwd, admn) VALUES
("julen.herber@educa.jcyl.es", "julen", "1234a", 1);

INSERT INTO usuario (nickname, nombre, pwd, admn) VALUES
("usu1@educa.jcyl.es", "usuario1", "1234a", 0);


DESCRIBE inventario_objeto;
SELECT*FROM inventario_objeto;
SELECT*FROM usuario;

INSERT INTO inventario(nombre, fecha) VALUES
("Inventario de prueba", '2023-04-02 13:55:00');

INSERT INTO inventario_objeto(id_inventario, id_objeto, id_aula, id_usuario, fechaRegistro) VALUES
(1, 2, 1, 1, (SELECT fechaAlta FROM objeto WHERE objeto.id = 2));

INSERT INTO inventario_objeto(id_inventario, id_objeto, id_aula, id_usuario, fechaRegistro) VALUES  
(1, 1, 0, 1, (SELECT fechaAlta FROM objeto WHERE objeto.id = 1)),
(1, 3, 0, 1, (SELECT fechaAlta FROM objeto WHERE objeto.id = 3)),
(1, 4, 0, 1, (SELECT fechaAlta FROM objeto WHERE objeto.id = 4)),
(1, 2, 0, 3, NOW()),
(1, 5, 0, 1, (SELECT fechaAlta FROM objeto WHERE objeto.id = 5)),
(1, 11, 1, 1, (SELECT fechaAlta FROM objeto WHERE objeto.id = 11));
/*****
MUCHO CUIDADO CON ESTA CONSULTA, POR EL SIGUIENTE MOTIVO:
	- Cuando se vaya especificar el id_aula, se debe comprobar primero que se objeto pertence a ese aula
	- Si por el contrario, ese objeto NO PERTENCE al aula en el que está en se momento, nos vemos ante dos situaciones distintas:
		1. Haremos un update del id_aula del objeto para indicar que se ha desplazado, cambiando los otros campos que se vean afectados si hace falta.
		2. En vez de asignarlo al inventario, deberemos llevar el objeto a su aula correpondiente
		
	- En ambas situaciones intentaría que, antes de registrar algo en esta tabla, si surge este conflicto la aplicación mande un mensaje avisando al usuario de
	que hay un objeto desubicado o fuera de su sitio, y que él mismo vea que decisión tiene que tomar.
***/









