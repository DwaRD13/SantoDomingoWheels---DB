DROP PROCEDURE IF EXISTS proc_getAllRolesActive;
DROP PROCEDURE IF EXISTS proc_getRoleActiveByID;
DROP PROCEDURE IF EXISTS proc_createRole;
DROP PROCEDURE IF EXISTS proc_updateRole;
DROP PROCEDURE IF EXISTS proc_deleteRole;

DELIMITER //
DELIMITER ;

----------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE proc_getAllRolesActive (IN p_state VARCHAR(20))
BEGIN
    SELECT R.ID, R.CREATED_AT, R.DESCRIPTION, R.NAME, S.NAME AS STATE, R.UPDATED_AT
    FROM `ROLE` R
    INNER JOIN `STATE` S ON S.ID = R.STATE_ID
    WHERE S.NAME = p_state;
END //

DELIMITER ;

----------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE proc_getRoleActiveByID (IN p_id int)
BEGIN
    SELECT R.ID, R.CREATED_AT, R.DESCRIPTION, R.NAME, S.NAME AS STATE, R.UPDATED_AT
    FROM `ROLE` R
    INNER JOIN `STATE` S ON S.ID = R.STATE_ID
    WHERE R.ID = p_id;
END //

DELIMITER ;
----------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE proc_createRole (IN p_name VARCHAR(40), IN p_description VARCHAR(40), IN p_state VARCHAR(40))
BEGIN
    DECLARE v_id INT;
    DECLARE v_newRole_id INT;

    SELECT ID INTO v_id
    FROM `STATE`
    WHERE NAME = p_state;

    INSERT INTO `ROLE` (DESCRIPTION, NAME, STATE_ID) VALUES (p_description, p_name, v_id);

	SELECT ID INTO v_newRole_id FROM `ROLE` WHERE ID = last_insert_id();
    CALL proc_getRoleActiveByID(v_newRole_id);

END //
DELIMITER ;
-----------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE proc_updateRole (IN p_id INT, IN p_name VARCHAR(40), IN p_description VARCHAR(40),
                                                                      IN p_state VARCHAR(40))
BEGIN
    DECLARE v_id INT;
    DECLARE v_updateRole INT;

    SELECT ID INTO v_id
    FROM `STATE`
    WHERE NAME = p_state;

    UPDATE `ROLE`
    SET DESCRIPTION = p_description, NAME = p_name, STATE_ID = v_id, updated_at = CURRENT_TIMESTAMP
    WHERE ID = p_id;

    CALL proc_getRoleActiveByID(p_id);

END //
DELIMITER ;
----------------------------------------------------------------------------------------------------------------------
DELIMITER //
CREATE PROCEDURE proc_deleteRole (IN p_id INT)
BEGIN
    DECLARE v_id INT;

    SELECT ID INTO v_id
    FROM `STATE`
    WHERE NAME = 'DELETE';

    UPDATE `ROLE`
    SET STATE_ID = v_id, deleted_at = CURRENT_TIMESTAMP
    WHERE ID = p_id;

    CALL proc_getRoleActiveByID(p_id);


END //
DELIMITER ;
----------------------------------------------------------------------------------------------------------------------
