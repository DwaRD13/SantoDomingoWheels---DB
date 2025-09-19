DROP PROCEDURE IF EXISTS proc_getAllUserActive;
DROP PROCEDURE IF EXISTS proc_getUserActiveByID;
DROP PROCEDURE IF EXISTS proc_createUserWithoutDocument;
DROP PROCEDURE IF EXISTS proc_createUserWithDocument;
DROP PROCEDURE IF EXISTS proc_addDocumentForUser;
DROP PROCEDURE IF EXISTS proc_updateUser;
DROP PROCEDURE IF EXISTS proc_deleteUser;

DELIMITER //
DELIMITER ;

----------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE proc_getAllUserActive ()
BEGIN
    DECLARE v_id INT;

    SELECT ID INTO V_ID FROM `STATE` WHERE NAME = 'ACTIVE';

    SELECT U.FIRST_NAME, U.SECOND_NAME, U.LAST_NAME, U.SECOND_SURNAME, U.EMAIL, U.BIRTH_DATE, U.CREATED_AT
           AS CREATED_USER, U.USER_NAME, S.NAME AS STATE, IDT.CREATED_AT, IDT.COUNTRY, IDT.ISSUE_DATE,
           IDT.EXPIRATION_DATE, IDT.TYPE_OF_DOCUMENT, R.NAME
    FROM `USER` U
    INNER JOIN `IDENTIFICATION_DOCUMENT` IDT ON IDT.ID = U.IDENTIFICATION_DOCUMENT_ID
    INNER JOIN `ROLE` R ON R.ID = U.ROLE_ID
    INNER JOIN `STATE` S ON S.ID = U.STATE_ID
    WHERE S.ID = v_id AND IDT.ID = v_id;

END //

DELIMITER ;

----------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE proc_getUserActiveByID (IN p_user_id INT)
BEGIN

    SELECT ID INTO V_ID FROM `STATE` WHERE NAME = 'ACTIVE';

    SELECT U.FIRST_NAME, U.SECOND_NAME, U.LAST_NAME, U.SECOND_SURNAME, U.EMAIL, U.BIRTH_DATE, U.CREATED_AT
               AS CREATED_USER, U.USER_NAME, S.NAME AS STATE, IDT.CREATED_AT, IDT.COUNTRY, IDT.ISSUE_DATE,
               IDT.EXPIRATION_DATE, IDT.TYPE_OF_DOCUMENT, R.NAME
    FROM `USER` U
    INNER JOIN `IDENTIFICATION_DOCUMENT` IDT ON IDT.ID = U.IDENTIFICATION_DOCUMENT_ID
    INNER JOIN `ROLE` R ON R.ID = U.ROLE_ID
    INNER JOIN `STATE` S ON S.ID = U.STATE_ID
    WHERE U.ID = p_user_id AND IDT.ID = v_id;

END //

DELIMITER ;

----------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE proc_createUserWithoutDocument (IN p_birth_date TIMESTAMP, IN p_email VARCHAR(40),
                                                 IN p_first_name VARCHAR(40), IN p_second_name VARCHAR(40),
                                                 IN p_last_name VARCHAR(40), IN p_second_surname VARCHAR(40),
                                                 IN p_password VARCHAR(20), IN p_username VARCHAR(20),
                                                 IN p_role_name VARCHAR(20))
BEGIN
    DECLARE v_state_id INT;
    DECLARE v_role_id INT;
    DECLARE v_newUser_id INT;

    SELECT ID INTO v_state_id FROM `STATE` WHERE NAME = 'ACTIVE';

    SELECT ID INTO v_role_id FROM `ROLE` WHERE NAME = p_role_name;


   INSERT INTO `USER` (USER_NAME, EMAIL, PASSWORD, FIRST_NAME, SECOND_NAME, LAST_NAME, SECOND_SURNAME,
   BIRTH_DATE, ROLE_ID, STATE_ID) VALUES (p_username, p_email, p_password, p_first_name, p_second_name, p_last_name,
   p_second_surname, p_birth_date, v_role_id, v_state_id);

   SELECT ID INTO v_newUser_id FROM `USER` WHERE ID = last_insert_id();
       CALL proc_getUserActiveByID(v_newUser_id);

END //

DELIMITER ;

----------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE proc_createUserWithDocument (IN p_birth_date TIMESTAMP, IN p_email VARCHAR(40),
                                                 IN p_first_name VARCHAR(40), IN p_second_name VARCHAR(40),
                                                 IN p_last_name VARCHAR(40), IN p_second_surname VARCHAR(40),
                                                 IN p_password VARCHAR(20), IN p_username VARCHAR(20),
                                                 IN p_role_name VARCHAR(20), IN p_country VARCHAR(40),
                                                 IN p_issue_date TIMESTAMP, IN p_expiration_date TIMESTAMP,
                                                 IN p_identification_number INT, IN p_type_of_document VARCHAR(40))
BEGIN
    DECLARE v_state_id INT;
    DECLARE v_role_id INT;
    DECLARE v_newUser_id INT;
    DECLARE v_identification_document INT;

    SELECT ID INTO v_state_id FROM `STATE` WHERE NAME = 'ACTIVE';
    SELECT ID INTO v_role_id FROM `ROLE` WHERE NAME = p_role_name;

    INSERT INTO `USER` (USER_NAME, EMAIL, PASSWORD, FIRST_NAME, SECOND_NAME, LAST_NAME, SECOND_SURNAME,
    BIRTH_DATE, ROLE_ID, STATE_ID) VALUES (p_username, p_email, p_password, p_first_name, p_second_name, p_last_name,
    p_second_surname, p_birth_date, v_role_id, v_state_id);

    SELECT ID INTO v_newUser_id FROM `USER` WHERE ID = last_insert_id();

    INSERT INTO `IDENTIFICATION_DOCUMENT` (COUNTRY, ISSUE_DATE, EXPIRATION_DATE, IDENTIFICATION_NUMBER,
                                            TYPE_OF_DOCUMENT, STATE_ID, USER_ID)
                                            VALUES (p_country, p_issue_date, p_expiration_date,
                                            p_identification_number, p_type_of_document, v_state_id, v_newUser_id);


    SELECT ID INTO v_identification_document FROM `IDENTIFICATION_DOCUMENT`WHERE ID = last_insert_id();

    UPDATE `USER`
    SET IDENTIFICATION_DOCUMENT_ID = v_identification_document
    WHERE ID = v_newUser_id;

    CALL proc_getUserActiveByID(v_newUser_id);

END //

DELIMITER ;

----------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE proc_updateUser (IN p_user_id INT, IN p_birth_date TIMESTAMP, IN p_email VARCHAR(40),
                                  IN p_first_name VARCHAR(40), IN p_second_name VARCHAR(40),
                                  IN p_last_name VARCHAR(40), IN p_second_surname VARCHAR(40),
                                  IN p_password VARCHAR(20), IN p_username VARCHAR(20),
                                  IN p_role_name VARCHAR(20), IN p_country VARCHAR(40),
                                  IN p_issue_date TIMESTAMP, IN p_expiration_date TIMESTAMP,
                                  IN p_identification_number INT, IN p_type_of_document VARCHAR(40))
BEGIN
    DECLARE v_identification_document_id INT;

    SELECT ID INTO V_ID FROM `STATE` WHERE NAME = 'DELETE';

    UPDATE `USER`
    SET FIRST_NAME = p_first_name, USER_NAME = p_username, EMAIL = p_email, PASSWORD = p_password,
    SECOND_NAME = p_second_name, LAST_NAME = p_last_name, SECOND_SURNAME = p_second_surname, BIRTH_DATE = p_birth_date,
    ROLE_ID = v_role_id, UPDATED_AT = CURRENT_TIMESTAMP
    WHERE ID = p_user_id;

    IF p_type_of_document != null THEN
        BEGIN
            UPDATE `IDENTIFICATION_DOCUMENT`
            SET STATE_ID = V_ID
            WHERE USER_ID = p_user_id;

            INSERT INTO `IDENTIFICATION_DOCUMENT` (COUNTRY, ISSUE_DATE, EXPIRATION_DATE, IDENTIFICATION_NUMBER,
                                                   TYPE_OF_DOCUMENT, STATE_ID, USER_ID)
                                                   VALUES (p_country, p_issue_date, p_expiration_date,
                                                 p_identification_number, p_type_of_document, v_state_id, p_user_id);
        END;
    END IF;

    SELECT ID INTO v_identification_document_id FROM `IDENTIFICATION_DOCUMENT` WHERE ID = last_insert_id();

    UPDATE `USER`
    SET IDENTIFICATION_DOCUMENT_ID = v_identification_document_id
    WHERE ID = p_user_id;

    CALL proc_getUserActiveByID(p_user_id);

END //

DELIMITER ;

----------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE proc_deleteUser (IN p_user_id INT)
BEGIN
    DECLARE v_id INT;

    SELECT ID INTO V_ID FROM STATE WHERE NAME = 'DELETE';

    UPDATE `USER`
    SET STATE_ID = V_ID, DELETED_AT = CURRENT_TIMESTAMP
    WHERE ID = p_user_id;

    CALL proc_getUserActiveByID(p_user_id);

END //

DELIMITER ;
----------------------------------------------------------------------------------------------------------------------