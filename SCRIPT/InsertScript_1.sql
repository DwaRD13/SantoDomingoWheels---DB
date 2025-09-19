-- INSERT FASE ONE

-- STATE
INSERT INTO STATE (description, name, group_key) VALUES ("EN USO", "Activo", "GENERIC");
INSERT INTO STATE (description, name, group_key) VALUES ("DETENIDO", "Pausado", "GENERIC");
INSERT INTO STATE (description, name, group_key) VALUES ("NO USADO", "Borrado", "GENERIC");

-- ROL 
INSERT INTO ROLE(DESCRIPTION, NAME, STATE_ID) VALUES ('PUEDE HACER TODO', 'ADMIN', 1);
INSERT INTO ROLE(DESCRIPTION, NAME, STATE_ID) VALUES ('HACER ALGUNAS COSAS', 'USER', 1);

-- USER
INSERT INTO `USER` (USER_NAME, EMAIL, PASSWORD, FIRST_NAME, SECOND_NAME, LAST_NAME, SECOND_SURNAME,
BIRTH_DATE, ROLE_ID) VALUES ('dwa', 'darwinmunozroman13@gmail.com', '12345', 'Darwin', 'Asael', 'Muñoz',
                             'Roman',  '2005-06-13', 1);


