-- INSERT FASE ONE

-- STATE
INSERT INTO STATE (description, name, group_key) VALUES ("EN USO", "Activo", "GENERIC");
INSERT INTO STATE (description, name, group_key) VALUES ("DETENIDO", "Pausado", "GENERIC");
INSERT INTO STATE (description, name, group_key) VALUES ("NO USADO", "Borrado", "GENERIC");
INSERT INTO STATE (description, name, group_key) VALUES ("Disponible", "AVAILABLE", "VEHICLE");
INSERT INTO STATE (description, name, group_key) VALUES ("Reservado", "RESERVED", "VEHICLE");
INSERT INTO STATE (description, name, group_key) VALUES ("En uso", "IN_USE", "VEHICLE");
INSERT INTO STATE (description, name, group_key) VALUES ("Mantenimiento", "MAINTENANCE", "VEHICLE");
INSERT INTO STATE (description, name, group_key) VALUES ("Bloqueado", "BLOCKED", "VEHICLE");
INSERT INTO STATE (description, name, group_key) VALUES ("Detenido por temas sanitarios", "QUARANTINE", "VEHICLE");
INSERT INTO STATE (description, name, group_key) VALUES ("Retirado",  "RETIRED", "VEHICLE");
INSERT INTO STATE (description, name, group_key) VALUES ('Reservación iniciada, aún no confirmada', 'PENDING', 'BOOKING');
INSERT INTO STATE (description, name, group_key) VALUES ('Reservación confirmada y vehículo bloqueado', 'CONFIRMED', 'BOOKING');
INSERT INTO STATE (description, name, group_key) VALUES ('Cliente recogió el vehículo', 'CHECKED_IN', 'BOOKING');
INSERT INTO STATE (description, name, group_key)VALUES ('Reserva finalizada correctamente', 'COMPLETED', 'BOOKING');
INSERT INTO STATE (description, name, group_key)VALUES ('Reserva cancelada', 'CANCELLED', 'BOOKING');
INSERT INTO STATE (description, name, group_key)VALUES ('Cliente no se presentó', 'NO_SHOW', 'BOOKING');

-- ROL 
INSERT INTO ROLE(DESCRIPTION, NAME, STATE_ID) VALUES ('Admin', 'ADMIN', 1);
INSERT INTO ROLE(DESCRIPTION, NAME, STATE_ID) VALUES ('User', 'USER', 1);
INSERT INTO ROLE(DESCRIPTION, NAME, STATE_ID) VALUES ('Empleado', 'EMPLOYEE', 1);

-- USER
INSERT INTO `USER` (USER_NAME, EMAIL, PASSWORD, FIRST_NAME, SECOND_NAME, LAST_NAME, SECOND_SURNAME,
BIRTH_DATE, ROLE_ID) VALUES ('dwa', 'darwinmunozroman13@gmail.com', '12345', 'Darwin', 'Asael', 'Muñoz',
                             'Roman',  '2005-06-13', 1);


