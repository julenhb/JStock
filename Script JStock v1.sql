DROP DATABASE IF EXISTS jstock;
CREATE DATABASE jstock;
USE jstock;

/*
El modelo de datos se podría dividir enb 3 partes:
	-topología: aquellas tablas que van a conformar la información relativa a las ubicaciones
	-inventariado: aquellas tablas que nos dan información sobre el inventario
	-usuarios: los usuarios que van a manejar la aplicación
	
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
	- Tipo: Para facilitar la supervisión de los objetoss, muchos pueden clasificarse en grupos. Por ejemplo, los PCs y teclados pertenecerían al tipo "Informática".
	- Objeto: El objeto en sí, que tendrá su propio id y de esta manera se podrá relacionar con su etiqueta.
	- Etiqueta: Entendemos que las etiquetas ya están hechas por tiradas, por lo tanto se les crea un id (el número de la etiqueta en sí misma) y se les asocia un objeto a través de su id.
	
Lógica:
	Un objeto pertenece a un sólo tipo 1:1
	Un objeto tiene una etiqueta 1:1
	Un objeto sólo está en un aula 1:1

*/

CREATE TABLE tipo(
id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR (255) NOT NULL UNIQUE,
num_objetos INT DEFAULT 0

);

CREATE TABLE objeto(
id INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre VARCHAR (255) NOT NULL,
descripcion VARCHAR (255) NOT NULL,
tipo INT(11) NOT NULL,
id_aula INT (11) NOT NULL,

FOREIGN KEY (tipo) REFERENCES tipo(id),
FOREIGN KEY (id_aula) REFERENCES aula(id)

);


CREATE TABLE etiqueta(
id INT (11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
id_objeto INT (11) NOT NULL,

FOREIGN KEY (id_objeto) REFERENCES objeto(id)

);

DESCRIBE ala;
DESCRIBE planta;
DESCRIBE aula;
DESCRIBE tipo;
DESCRIBE etiqueta;
DESCRIBE objeto;


SELECT*FROM ala;
SELECT*FROM planta;
SELECT*FROM aula;
SELECT*FROM tipo;
SELECT*FROM etiqueta;
SELECT*FROM objeto;


INSERT INTO ala (id, nombre) VALUES
(1, "Ala Izquierda"),
(2, "Ala Derecha");

INSERT INTO planta (id_ala, id, nombre) VALUES
(1, 0, "Planta Baja Izquierda"),
(1, 1, "Planta 1 Izquierda"),
(1, 2, "Planta 2 Izquierda"),
(2, 3, "Planta Baja Derecha"),
(2, 4, "Planta 1 Derecha"),
(2, 5, "Planta 2 Derercha");

INSERT INTO aula (id_ala, id_planta, id, nombre) VALUES
(1, 2, 0, "AULA 0"),
(1, 2, 1, "AULA 1");

INSERT INTO tipo (nombre) VALUES
("Informática"),
("Proyectores"),
("Periféricos"),
("Herramientas");

INSERT INTO objeto (nombre, descripcion, tipo, id_aula) VALUES
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
(12),
(13),
(14),
(15),
(16),
(17),
(18),
(19),
(20),
(21),
(22);



SELECT et.id AS etiqueta, ob.id AS ID_OBJETO, ob.nombre AS objeto, tp.nombre AS tipo, au.nombre AS aula, pl.nombre AS planta, al.nombre AS ala    
FROM etiqueta et

INNER JOIN objeto ob
ON et.id_objeto = ob.id
INNER JOIN tipo tp
ON ob.tipo = tp.id
INNER JOIN aula au
ON ob.id_aula = au.id
INNER JOIN planta pl
ON au.id_planta = pl.id
INNER JOIN ala al
ON au.id_ala = al.id

WHERE et.id = 2;












