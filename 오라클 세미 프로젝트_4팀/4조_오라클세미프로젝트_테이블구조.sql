SELECT USER
FROM DUAL;
--==>> HR

--�� ������
CREATE TABLE ADMINISTRATOR
( ADMIN_ID  VARCHAR2(30)
, ADMIN_PW  VARCHAR2(30) 
, CONSTRAINT ADMINISTRATOR_ADMIN_ID_PK PRIMARY KEY(ADMIN_ID)
);

ALTER TABLE ADMINISTRATOR
MODIFY
( ADMIN_PW CONSTRAINT ADMINISTRATOR_ADMIN_PW_NN NOT NULL );


--�� ������
CREATE TABLE PROFESSORS
( PRO_ID     VARCHAR2(30)                               -- �����ڹ�ȣ
, PRO_NAME   VARCHAR2(10)                               -- �����ڸ�
, PRO_PW     VARCHAR2(30)                               -- ������ ��й�ȣ(�ʱⰪ�� �ֹι�ȣ ���ڸ�)
, PRO_SSN    CHAR(14)                                   -- ������ �ֹι�ȣ
, CONSTRAINT PROFESSORS_PRO_ID_PK PRIMARY KEY(PRO_ID)
, CONSTRAINT PROFESSORS_PRO_SSN_UK UNIQUE(PRO_SSN)
);

-- NOT NULL �������� ����
ALTER TABLE PROFESSORS
MODIFY
( PRO_NAME CONSTRAINT PROFESSORS_PRO_NAME_NN NOT NULL
, PRO_PW CONSTRAINT PROFESSORS_PRO_PW_NN NOT NULL
, PRO_SSN CONSTRAINT PROFESSORS_PRO_SSN_NN NOT NULL
);


--�� �л�
CREATE TABLE STUDENTS
( ST_ID     VARCHAR2(30) 
, ST_PW     VARCHAR2(30)         -- ���ʱⰪ �ֹι�ȣ ���ڸ�
, ST_NAME   VARCHAR2(10)  
, ST_SSN    CHAR(14)     UNIQUE
, ST_DATE   DATE         DEFAULT SYSDATE
, CONSTRAINT STUDENTS_ST_ID_PK PRIMARY KEY(ST_ID)
);

-- �������� ����
ALTER TABLE STUDENTS
MODIFY
( ST_ID CONSTRAINT STUDENTS_STUDENT_ID_NN NOT NULL
, ST_NAME CONSTRAINT STUDENTS_STUDENT_NAME_NN NOT NULL
, ST_PW CONSTRAINT STUDENTS_STUDENT_PASSWORD_NN NOT NULL
, ST_SSN CONSTRAINT STUDENTS_STUDENT_SSN_NN NOT NULL
, ST_DATE CONSTRAINT STUDENTS_STUDENT_DATE_NN NOT NULL
);


--�� ����
CREATE TABLE SUBJECTS
( SUB_ID            VARCHAR2(30)        -- �����ڵ�
, SUB_NAME            VARCHAR2(30)
, S_START           DATE                -- ������
, S_END             DATE                -- ������
, CLASSROOM         VARCHAR2(30)        -- ���ǽ�
, BOOK_NAME         VARCHAR2(30)        -- å�̸�
, CONSTRAINT SUBJECTS_SUB_ID_PK PRIMARY KEY(SUB_ID)
, CONSTRAINT SUBJECTS_S_START_CK CHECK(S_START < S_END)
);


--�� ����
CREATE TABLE COURSE
( COURSE_ID     VARCHAR2(30)  
, COURSE_NAME   VARCHAR2(30)
, PRO_ID        VARCHAR2(30)
, C_START       DATE
, C_END         DATE
, CLASSROOM     VARCHAR2(30)
, CONSTRAINT COURSE_COURSE_ID_PK PRIMARY KEY(COURSE_ID)
, CONSTRAINT COURSE_COURSE_NAME_FK FOREIGN KEY(PRO_ID)
                                            REFERENCES PROFESSORS(PRO_ID)
, CONSTRAINT COURSE_C_START_CK CHECK(C_START < C_END)
);


--�� ��������
CREATE TABLE ESTABLISHED_SUB
( EST_SUB_ID        VARCHAR2(30)
, PRO_ID            VARCHAR2(30)
, COURSE_ID         VARCHAR2(30)
, SUB_ID            VARCHAR2(30)
, ATTEND_PER        NUMBER(3)
, PRACTICAL_PER     NUMBER(3)
, WRITING_PER       NUMBER(3)
, CONSTRAINT EST_SUB_EST_SUB_ID_PK PRIMARY KEY(EST_SUB_ID)
, CONSTRAINT EST_SUB_PRO_ID_FK FOREIGN KEY(PRO_ID) 
                                       REFERENCES PROFESSORS(PRO_ID)
, CONSTRAINT SUBJECTS_COURSE_ID_FK FOREIGN KEY(COURSE_ID) 
                                       REFERENCES COURSE(COURSE_ID)
, CONSTRAINT EST_SUB_SUB_ID_FK FOREIGN KEY(SUB_ID) 
                                       REFERENCES SUBJECTS(SUB_ID)
, CONSTRAINT EST_SUB_ATTEND_PER_CK CHECK(ATTEND_PER BETWEEN 0 AND 100)
, CONSTRAINT EST_SUB_PRACTICAL_PER_CK CHECK(PRACTICAL_PER BETWEEN 0 AND 100)
, CONSTRAINT EST_SUB_WRITING_PER_CK CHECK(WRITING_PER BETWEEN 0 AND 100)
, CONSTRAINT EST_SUB_TOTAL_PER_CK CHECK( (ATTEND_PER + PRACTICAL_PER + WRITING_PER) = 100 )
);


--�� ����
CREATE TABLE TEST
(
 TEST_ID          VARCHAR2(30)
,EST_SUB_ID       VARCHAR2(30)
,TEST_DATE        DATE
,CONSTRAINT TEST_TEST_ID_PK PRIMARY KEY(TEST_ID)
,CONSTRAINT TEST_EST_SUB_ID_FK FOREIGN KEY(EST_SUB_ID) REFERENCES ESTABLISHED_SUB(EST_SUB_ID)
);


--�� ������û
CREATE TABLE ENROLL
( E_ID          VARCHAR2(30)
, ST_ID         VARCHAR2(30)
, COURSE_ID     VARCHAR2(30)
, E_DATE        DATE    DEFAULT SYSDATE
, CONSTRAINT ENROLL_E_ID_PK PRIMARY KEY(E_ID)
, CONSTRAINT ENROLL_ST_ID_FK FOREIGN KEY(ST_ID) 
                                       REFERENCES STUDENTS(ST_ID)
, CONSTRAINT ENROLL_COURSE_ID_FK FOREIGN KEY(COURSE_ID) 
                                       REFERENCES COURSE(COURSE_ID)
);

--������û �������� ����
ALTER TABLE ENROLL
MODIFY
(E_DATE   CONSTRAINT ENROLL_E_DATE_NN NOT NULL);


--�� ����
CREATE TABLE SCORE
( SCORE_ID              VARCHAR2(30) 
, E_ID             VARCHAR2(30)
, EST_SUB_ID            VARCHAR2(30)
, ATTEND_SCORE          NUMBER(3)
, PRACTICAL_SCORE       NUMBER(3)
, WRITING_SCORE         NUMBER(3)
, CONSTRAINT SOCRE_ID_PK PRIMARY KEY(SCORE_ID)
, CONSTRAINT SCORE_E_ID_FK FOREIGN KEY(E_ID)
             REFERENCES ENROLL(E_ID)
, CONSTRAINT SCORE_ESTABLISHED_SUB_ID_FK FOREIGN KEY(EST_SUB_ID)
             REFERENCES ESTABLISHED_SUB(EST_SUB_ID)
, CONSTRAINT SCORE_ATTEND_SCORE_CK CHECK(ATTEND_SCORE BETWEEN 0 AND 100)            
, CONSTRAINT SCORE_PRACTICAL_SCORE_CK CHECK(PRACTICAL_SCORE BETWEEN 0 AND 100)            
, CONSTRAINT SCOREWRITING_SCORE_CK CHECK(WRITING_SCORE BETWEEN 0 AND 100)

);


--�� �ߵ�����
CREATE TABLE MID_DROP
( DROP_ID       VARCHAR2(30)
, E_ID     VARCHAR2(30)
, DROP_DATE     DATE           NOT NULL
, CONSTRAINT MID_DPOP_ID_PK PRIMARY KEY(DROP_ID)
, CONSTRAINT MID_DPOP_E_ID_FK FOREIGN KEY(E_ID)
             REFERENCES ENROLL(E_ID)
-- ����Ϻ��� �ߵ����� ��¥�� �ڿ��� �Ѵٴ� ��������
);


--�� �л� �̺�Ʈ�α� ���̺�
CREATE TABLE STD_EVENTLOG
( ILJA          DATE DEFAULT SYSDATE
, MEMO          VARCHAR2(200)                                    
);
--==>> Table STD_EVENTLOG��(��) �����Ǿ����ϴ�.


--�� ���� �̺�Ʈ�α� ���̺�
CREATE TABLE PRO_EVENTLOG
( ILJA          DATE DEFAULT SYSDATE
, MEMO          VARCHAR2(200)                                    
);
--==>> Table PRO_EVENTLOG��(��) �����Ǿ����ϴ�.

--------------------------------------------------------------------------------
--PLSQL
--���л� �α��� ���ν��� ����
CREATE OR REPLACE PROCEDURE PRC_LOGIN_ST 
(
    V_USERID IN STUDENTS.ST_ID%TYPE
,   V_USERPW IN STUDENTS.ST_PW%TYPE
)
IS
    V_COUNT            NUMBER;
BEGIN
    SELECT COUNT(ST_ID) INTO V_COUNT FROM STUDENTS
    WHERE ST_ID=V_USERID AND ST_PW=V_USERPW;
 
    IF(V_COUNT > 0) THEN
        DBMS_OUTPUT.PUT_LINE(V_USERID||'�� �α��� �Ǿ����ϴ�.');  
    ELSE
        DBMS_OUTPUT.PUT_LINE('���̵� �Ǵ� ��й�ȣ�� �߸��Ǿ����ϴ�.');
    END IF;
 
END;
--==>> Procedure PRC_LOGIN_ST��(��) �����ϵǾ����ϴ�.

--�۰����� �α��� ���ν��� ����
CREATE OR REPLACE PROCEDURE PRC_LOGIN_AD 
(
    V_USERID IN ADMINISTRATOR.ADMIN_ID%TYPE
,   V_USERPW IN ADMINISTRATOR.ADMIN_PW%TYPE
)
IS
    V_COUNT            NUMBER;
BEGIN
    SELECT COUNT(ADMIN_ID) INTO V_COUNT FROM ADMINISTRATOR
    WHERE ADMIN_ID=V_USERID AND ADMIN_PW=V_USERPW;
    
    IF(V_COUNT > 0) THEN
        DBMS_OUTPUT.PUT_LINE(V_USERID||'�� �α��� �Ǿ����ϴ�.');  
    ELSE
        DBMS_OUTPUT.PUT_LINE('���̵� �Ǵ� ��й�ȣ�� �߸��Ǿ����ϴ�.');
    END IF;
END;
--==>> Procedure PRC_LOGIN_AD��(��) �����ϵǾ����ϴ�.

--�۱��� �α��� ���ν��� ����
CREATE OR REPLACE PROCEDURE PRC_LOGIN_PRO 
(
    V_USERID IN PROFESSORS.PRO_ID%TYPE
,   V_USERPW IN PROFESSORS.PRO_PW%TYPE
)
IS
    V_COUNT            NUMBER;
BEGIN
    SELECT COUNT(PRO_ID) INTO V_COUNT FROM PROFESSORS
    WHERE PRO_ID=V_USERID AND PRO_PW=V_USERPW;
 
    IF(V_COUNT > 0) THEN
        DBMS_OUTPUT.PUT_LINE(V_USERID||'�� �α��� �Ǿ����ϴ�.');  
    ELSE
        DBMS_OUTPUT.PUT_LINE('���̵� �Ǵ� ��й�ȣ�� �߸��Ǿ����ϴ�.');    
    END IF;
  
END;
--==>> Procedure PRC_LOGIN_PR��(��) �����ϵǾ����ϴ�.

--�۷α��� ���ν��� ����
CREATE OR REPLACE PROCEDURE PRC_LOGIN
(
    V_USER    IN NUMBER    
,   V_USERID  IN PROFESSORS.PRO_ID%TYPE
,   V_USERPW IN PROFESSORS.PRO_PW%TYPE
)
IS
    INPUT_ERROR    EXCEPTION;
    V_COUNT        NUMBER;
BEGIN
    IF(V_USER = 1) -- ������
        THEN PRC_LOGIN_AD(V_USERID, V_USERPW);
      
    ELSIF(V_USER = 2) -- ����
        THEN PRC_LOGIN_PRO(V_USERID, V_USERPW);
  
    ELSIF(V_USER = 3) -- �л�
        THEN PRC_LOGIN_ST(V_USERID, V_USERPW);  
    ELSIF (V_USER != 1 AND V_USER != 2 AND V_USER != 3)
        THEN RAISE INPUT_ERROR;
    END IF; 
    
    EXCEPTION
    WHEN INPUT_ERROR
        THEN RAISE_APPLICATION_ERROR(-20005, '�ش��ϴ� ����ڸ� �����ϼ���. (1.������, 2.����, 3.�л�)');
             ROLLBACK;
    WHEN OTHERS
        THEN ROLLBACK;
 
END;
--==>> Procedure PRC_LOGIN��(��) �����ϵǾ����ϴ�.


--�� ������ ���� ���ν���
CREATE OR REPLACE PROCEDURE PRC_AD_DELETE
( V_AD_ID   IN ADMINISTRATOR.ADMIN_ID%TYPE
)
IS
BEGIN
    -- ADMINISTRATOR(������ ���̺�) ���� ����
    DELETE
    FROM ADMINISTRATOR
    WHERE ADMIN_ID = V_AD_ID;
    
    --COMMIT;
END;
--==>> Procedure PRC_AD_DELETE��(��) �����ϵǾ����ϴ�.


--�� STUDENT ID ������
CREATE SEQUENCE SEQ_ST_ID
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;
--==>> Sequence SEQ_ST_ID��(��) �����Ǿ����ϴ�.

--�� STUDENT_INSERT ���ν���
--�� STUDENT_INSERT ���ν���
CREATE OR REPLACE PROCEDURE PRC_STUDENT_INSERT
(
   V_ST_NAME IN STUDENTS.ST_NAME%TYPE
 , V_ST_SSN IN STUDENTS.ST_SSN%TYPE
)
IS
    V_CHECK_SSN     NUMBER; 
    SSN_ERROR       EXCEPTION;

BEGIN    
    -- ���� ó��
    V_CHECK_SSN := LENGTH(V_ST_SSN);
    
    IF(V_CHECK_SSN != 14)
        THEN RAISE SSN_ERROR;        
    END IF;
        
    -- INSERT
    INSERT INTO STUDENTS(ST_ID, ST_PW, ST_NAME, ST_SSN)
    VALUES('STU' || SEQ_ST_ID.NEXTVAL,SUBSTR(V_ST_SSN,8),V_ST_NAME,V_ST_SSN);

    -- Ŀ��
    COMMIT;

    -- ���� �߻�(�Ϸ�)
     EXCEPTION
        WHEN SSN_ERROR
            THEN RAISE_APPLICATION_ERROR(-20040, '�ֹι�ȣ (-) ���� 14�ڸ��� ��Ȯ�� �Է����ּ���!');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;    
END;

--==>> Procedure PRC_STUDENT_INSERT��(��) �����ϵǾ����ϴ�.


--�� STUDENT_UPDATE ���ν���
CREATE OR REPLACE PROCEDURE PRC_STUDENT_UPDATE
(
  V_ST_ID   IN STUDENTS.ST_ID%TYPE
, V_ST_NAME IN STUDENTS.ST_NAME%TYPE
, V_ST_PW  IN STUDENTS.ST_PW%TYPE
)
IS
    NONEXIST_ERROR  EXCEPTION;
BEGIN
    UPDATE STUDENTS
    SET ST_NAME = V_ST_NAME, ST_PW = V_ST_PW
    WHERE ST_ID = V_ST_ID;
    
    IF SQL%NOTFOUND
        THEN RAISE NONEXIST_ERROR;
    END IF;
       
    COMMIT;
    
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20006,'��ġ�ϴ� �����Ͱ� �����ϴ�.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_STUDENT_UPDATE��(��) �����ϵǾ����ϴ�.


--�� STUDENT_DELETE ���ν���
CREATE OR REPLACE PROCEDURE PRC_STUDENT_DELETE 
(
    V_ST_ID      STUDENTS.ST_ID%TYPE          
  , V_ST_PW      STUDENTS.ST_PW%TYPE      
  , V_ST_NAME    STUDENTS.ST_NAME%TYPE      
  , V_ST_SSN     STUDENTS.ST_SSN%TYPE      -- �л� �ֹι�ȣ ���ڸ�
)
IS
BEGIN
        DELETE      
            FROM STUDENTS      
            WHERE ST_ID = V_ST_ID             -- �л� ���̵� üũ
                  AND ST_PW = V_ST_PW          -- �л� ��й�ȣ üũ
                  AND ST_NAME = V_ST_NAME      -- �л� �̸� üũ
                  AND ST_SSN = V_ST_SSN;         -- �л� �ֹι�ȣ ���ڸ� üũ
        COMMIT;

        EXCEPTION
            WHEN OTHERS
                THEN RAISE_APPLICATION_ERROR(-20003,'�ٽ� �Է����ּ���');
                     ROLLBACK; 
END;
--==>> Procedure PRC_STUDENT_DELETE��(��) �����ϵǾ����ϴ�.


--�� �л� ���̺� �̺�Ʈ�α� Ʈ����
CREATE OR REPLACE TRIGGER TRG_STD_EVENTLOG
            AFTER
            INSERT OR UPDATE ON STUDENTS
DECLARE
BEGIN

    IF(INSERTING)
        THEN INSERT INTO STD_EVENTLOG(MEMO) 
            VALUES('�л� ���� �߰� �Ϸ�');    
    ELSIF(UPDATING)
        THEN INSERT INTO STD_EVENTLOG(MEMO) 
            VALUES('�л� ���� ������Ʈ �Ϸ�');
            
    END IF; 
END;
--==>> Trigger TRG_STD_EVENTLOG��(��) �����ϵǾ����ϴ�.


--�� ������û INSERT ���ν���
-- �Ʒ��� ������ Ȯ�� �� �����͸� �Է��Ѵ�.
-- 1) ��������ϰ� ������
-- 2) ������ ���� ��û ����
-- 3) ���� ��¥ �ߺ�
CREATE OR REPLACE PROCEDURE PRC_ENROLL_INSERT
( V_E_ID       IN ENROLL.E_ID%TYPE
, V_ST_ID      IN ENROLL.ST_ID%TYPE
, V_COURSE_ID  IN ENROLL.COURSE_ID%TYPE
, V_E_DATE     IN ENROLL.E_DATE%TYPE
)

IS
   V_ST_DATE           STUDENTS.ST_DATE%TYPE;
   V_C_START           COURSE.C_START%TYPE;     -- ����Ϸ��� ������ ������
   V_C_END             COURSE.C_END%TYPE;       -- ����Ϸ��� ������ ������
   nCNT                NUMBER;
   USER_DEFINE_ERROR   EXCEPTION;
   SAME_COURSE         EXCEPTION;
   SAME_DATE           EXCEPTION;

BEGIN
    -- ���� ó�� 1. ��������ϰ� ������
    -- ������û���� ��������Ϻ��� �����ų�, �����Ϻ��� �����ų� ���� �� ����.
    SELECT ST_DATE INTO V_ST_DATE
    FROM STUDENTS
    WHERE ST_ID = V_ST_ID;
    
    SELECT C_START, C_END INTO V_C_START, V_C_END
    FROM COURSE
    WHERE COURSE_ID = V_COURSE_ID;    

    IF (V_E_DATE < V_ST_DATE OR V_E_DATE >= V_C_START)
        THEN RAISE USER_DEFINE_ERROR;
    END IF;
    
    
    -- ���� ó�� 2. ������ ���� ��û ����
    -- �� �л��� ���� ������ ��û�� �� ����.
    SELECT COUNT(*) INTO nCNT
    FROM ENROLL
    WHERE ST_ID = V_ST_ID AND COURSE_ID = V_COURSE_ID;    
    
    IF (nCNT > 0)
        THEN RAISE SAME_COURSE;
    END IF;

    
    -- ���� ó�� 3. ���� ��¥ �ߺ�
    -- �� �л��� ������ ������ ������ ��¥��, ���� �����Ϸ��� ������ ��¥�� ��ĥ �� ����.
    SELECT COUNT(*) INTO nCNT
    FROM ENROLL E JOIN COURSE C
      ON E.COURSE_ID = C.COURSE_ID      
    WHERE E.ST_ID = V_ST_ID
      AND ( V_C_START > C.C_START AND V_C_START < C.C_END     -- ����Ϸ��� ������ ���� ��¥ ���� Ȯ��
       OR   V_C_END > C.C_START AND V_C_END < C.C_END );      -- ����Ϸ��� ������ ���� ��¥ ���� Ȯ��

    IF (nCNT > 0)
        THEN RAISE SAME_DATE;
    END IF; 


    -- INSERT
    INSERT INTO ENROLL(E_ID, ST_ID, COURSE_ID, E_DATE)
    VALUES (V_E_ID, V_ST_ID, V_COURSE_ID, V_E_DATE);

    -- Ŀ��
    COMMIT;
        
    -- ���� �߻�
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '���� ��û�� �Ұ����մϴ�.');
                 ROLLBACK;
        WHEN SAME_COURSE
            THEN RAISE_APPLICATION_ERROR(-20003, '�̹� ��û�� �����Դϴ�.');
                 ROLLBACK;
        WHEN SAME_DATE
            THEN RAISE_APPLICATION_ERROR(-20004, '��¥�� �ߺ��Ǵ� �����Դϴ�.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;            
END;
--==>> Procedure PRC_ENROLL_INSERT��(��) �����ϵǾ����ϴ�.



--�� �ߵ����� INSERT ���ν���
--> �ߵ����� ���ڵ带 �Է� ��, 
-- 1. "���� ������ < �ߵ������� < ����������"�� �´���
-- 2. ������ �������� ���� ������ �´��� Ȯ���ϴ� ���ν���
CREATE OR REPLACE PROCEDURE PRC_MID_DROP_INSERT
( V_DROP_ID     IN MID_DROP.DROP_ID%TYPE
, V_E_ID        IN MID_DROP.E_ID%TYPE
, V_DROP_DATE   IN MID_DROP.DROP_DATE%TYPE
)
IS
    V_COURSE_ID         COURSE.COURSE_ID%TYPE;
    V_C_START           COURSE.C_START%TYPE;
    V_C_END             COURSE.C_END%TYPE;    
    V_CNT               NUMBER;
    USER_DEFINE_ERROR1   EXCEPTION;
    USER_DEFINE_ERROR2   EXCEPTION;

BEGIN
    -- ���� ó��1 : "���� ������ < �ߵ������� < ����������"�� �ƴ� ���
    SELECT COURSE_ID INTO V_COURSE_ID
    FROM ENROLL
    WHERE E_ID = V_E_ID;  
    
    SELECT C_START, C_END INTO V_C_START, V_C_END
    FROM COURSE
    WHERE COURSE_ID = V_COURSE_ID;
    
    IF (V_DROP_DATE < V_C_START OR V_DROP_DATE > V_C_END)
        THEN RAISE USER_DEFINE_ERROR1;
    END IF;
    
    
    -- ���� ó��2: �̹� DROP�� ������ ���
    SELECT COUNT(*) INTO V_CNT
    FROM MID_DROP
    WHERE E_ID = V_E_ID;
    
    IF (V_CNT > 1)
        THEN RAISE USER_DEFINE_ERROR2;
    END IF;    
    

    -- INSERT
    INSERT INTO MID_DROP(DROP_ID, E_ID, DROP_DATE)
    VALUES (V_DROP_ID, V_E_ID, V_DROP_DATE);
    
    -- Ŀ��
    COMMIT;
    
    -- ���� �߻�
    EXCEPTION
        WHEN USER_DEFINE_ERROR1
            THEN RAISE_APPLICATION_ERROR(-20001, '�ߵ����� ��¥�� �߸� �ԷµǾ����ϴ�.');
                 ROLLBACK;
        WHEN USER_DEFINE_ERROR2
            THEN RAISE_APPLICATION_ERROR(-20002, '�̹� ������ �����Դϴ�.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_MID_DROP_INSERT��(��) �����ϵǾ����ϴ�.


--�� ���� ���̵� ������
CREATE SEQUENCE SEQ_PROFESSORS_ID
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;
--==>>Sequence SEQ_PROFESSORS_ID��(��) �����Ǿ����ϴ�.

--�� ���� INSERT ���ν���
CREATE OR REPLACE PROCEDURE PRC_PRO_INSERT
( V_PRO_NAME    IN PROFESSORS.PRO_NAME%TYPE
, V_PRO_SSN     IN PROFESSORS.PRO_SSN%TYPE
)
IS
    V_CHECK_SSN NUMBER; 
    SSN_ERROR EXCEPTION;

BEGIN
    SELECT LENGTH(V_PRO_SSN) INTO V_CHECK_SSN
    FROM DUAL;
    
    IF(V_CHECK_SSN = 14)
        THEN
    -- INSERT ������
    INSERT INTO PROFESSORS(PRO_ID, PRO_NAME, PRO_PW, PRO_SSN)
    VALUES('PRO' || SEQ_PROFESSORS_ID.NEXTVAL, V_PRO_NAME, SUBSTR(V_PRO_SSN,8), V_PRO_SSN);

    ELSE RAISE SSN_ERROR;        
    END IF;
   
    COMMIT;

    -- ���� �߻�(�Ϸ�)
     EXCEPTION
        WHEN SSN_ERROR
            THEN RAISE_APPLICATION_ERROR(-20040, '�ֹι�ȣ (-) ���� 14�ڸ��� ��Ȯ�� �Է����ּ���!');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
    
END;
--==>> Procedure PRC_PRO_PW_INSERT��(��) �����ϵǾ����ϴ�.

--�� ������ ���� ��ü�ϴ� ���ν���
CREATE OR REPLACE PROCEDURE PRC_PRO_CHANGE
( V_COURSE_ID   IN COURSE.COURSE_ID%TYPE
, V_PRO_ID      IN PROFESSORS.PRO_ID%TYPE
)
IS
BEGIN
    -- COURSE(�������̺�) �����ڵ� ������Ʈ
    UPDATE COURSE
    SET PRO_ID = V_PRO_ID
    WHERE COURSE_ID = V_COURSE_ID;
    
    -- CREATE TABLE ESTABLISHED_SUB(�����������̺�) �����ڵ� ������Ʈ
    UPDATE ESTABLISHED_SUB
    SET PRO_ID = V_PRO_ID
    WHERE COURSE_ID = V_COURSE_ID;

END;
--==>> Procedure PRC_PRO_CHANGE��(��) �����ϵǾ����ϴ�.


--�� ���� ���� ���� ���ν���
CREATE OR REPLACE PROCEDURE PRC_PRO_UPDATE
( V_PRO_ID      IN PROFESSORS.PRO_ID%TYPE
, V_PRO_NAME    IN PROFESSORS.PRO_NAME%TYPE
, V_PRO_PW     IN PROFESSORS.PRO_PW%TYPE
)
IS
    NONEXIST_ERROR EXCEPTION;
BEGIN
    -- PROFESSORS(�������̺�) �̸�, ��й�ȣ ������Ʈ
    UPDATE PROFESSORS
    SET PRO_NAME = V_PRO_NAME, PRO_PW = V_PRO_PW
    WHERE PRO_ID = V_PRO_ID;
    
    IF SQL%NOTFOUND
        THEN RAISE NONEXIST_ERROR;
    END IF;
    
    COMMIT;
    
    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20006,'��ġ�ϴ� �����Ͱ� �����ϴ�.');
                ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_PRO_UPDATE��(��) �����ϵǾ����ϴ�.


--�� ���� ���� Ʈ����
CREATE OR REPLACE TRIGGER TRG_PRO_DELETE
        BEFORE
        DELETE ON PROFESSORS
        FOR EACH ROW
        
BEGIN
    DELETE
    FROM COURSE
    WHERE PRO_ID=:OLD.PRO_ID;
    
    DELETE
    FROM ESTABLISHED_SUB
    WHERE PRO_ID=:OLD.PRO_ID; 

END;
--==>> Trigger TRG_PRO_DELETE��(��) �����ϵǾ����ϴ�.


--�� ���� ���� ���ν���
CREATE OR REPLACE PROCEDURE PRC_PRO_DELETE
( V_PRO_ID  IN PROFESSORS.PRO_ID%TYPE
)
IS
    NONEXIST_ERROR  EXCEPTION;
BEGIN
    DELETE
    FROM PROFESSORS
    WHERE PRO_ID = V_PRO_ID;
    
    IF SQL%NOTFOUND
    THEN RAISE NONEXIST_ERROR;
    END IF;
        
    COMMIT;

    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20009,'��ġ�ϴ� �����Ͱ� �����ϴ�.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_PRO_DELETE��(��) �����ϵǾ����ϴ�.

--�� ���� ���̺� �̺�Ʈ�α� Ʈ����
CREATE OR REPLACE TRIGGER TRG_PRO_EVENTLOG
            AFTER
            INSERT OR UPDATE ON PROFESSORS
DECLARE
BEGIN
    IF (INSERTING)
        THEN INSERT INTO PRO_EVENTLOG(MEMO)
            VALUES('�������� INSERT �������� ����Ǿ����ϴ�.');
    ELSIF (UPDATING)
        THEN INSERT INTO PRO_EVENTLOG(MEMO)
            VALUES('�������� UPDATE �������� ����Ǿ����ϴ�.');
    END IF;
END;
--==>> Trigger TRG_PRO_EVENTLOG��(��) �����ϵǾ����ϴ�.


--�� �������� INSERT ���ν���
CREATE OR REPLACE PROCEDURE PRC_ESTABLISHED_SUB
( V_EST_SUB_ID      IN ESTABLISHED_SUB.EST_SUB_ID%TYPE
, V_PRO_ID          IN ESTABLISHED_SUB.PRO_ID%TYPE
, V_COURSE_ID       IN ESTABLISHED_SUB.COURSE_ID%TYPE
, V_SUB_ID          IN ESTABLISHED_SUB.SUB_ID%TYPE
, V_ATTEND_PER      IN ESTABLISHED_SUB.ATTEND_PER%TYPE
, V_PRACTICAL_PER   IN ESTABLISHED_SUB.PRACTICAL_PER%TYPE
, V_WRITING_PER     IN ESTABLISHED_SUB.WRITING_PER%TYPE
)
IS
    V_C_START           COURSE.C_START%TYPE;
    V_C_END             COURSE.C_END%TYPE;
    V_S_START           SUBJECTS.S_START%TYPE;
    V_S_END             SUBJECTS.S_END%TYPE;
    
    USER_DEFINE_ERROR   EXCEPTION;

BEGIN
    -- ������ �� ���
    SELECT C_START, C_END INTO V_C_START, V_C_END
    FROM COURSE
    WHERE COURSE_ID = V_COURSE_ID;
    
    SELECT S_START, S_END INTO V_S_START, V_S_END
    FROM SUBJECTS
    WHERE SUB_ID = V_SUB_ID;
    
    IF (V_C_START > V_S_START OR V_S_END > V_C_END) --���� �������� ���� �����Ϻ��� �ڰų� ���� �������� ���� �����Ϻ��� �ڸ� �����߻�
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

    -- INSERT
    INSERT INTO ESTABLISHED_SUB(EST_SUB_ID,PRO_ID,COURSE_ID,SUB_ID,ATTEND_PER,PRACTICAL_PER,WRITING_PER)
    VALUES (V_EST_SUB_ID, V_PRO_ID,V_COURSE_ID,V_SUB_ID,V_ATTEND_PER,V_PRACTICAL_PER,V_WRITING_PER);
    
    -- Ŀ��
    COMMIT;
    
    -- ���� �߻�
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001, '���� ���� ��¥�� �߸� �ԷµǾ����ϴ�.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_ESTABLISHED_SUB��(��) �����ϵǾ����ϴ�.


--�� ���� ���� ���ν���
CREATE OR REPLACE PROCEDURE PRC_COR_DELETE
( V_COURSE_ID  IN COURSE.COURSE_ID%TYPE
)
IS
    NONEXIST_ERROR  EXCEPTION;
BEGIN
    
    DELETE
    FROM COURSE
    WHERE COURSE_ID= V_COURSE_ID;
    
    IF SQL%NOTFOUND
    THEN RAISE NONEXIST_ERROR;
    END IF;
        
    COMMIT;

    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20009,'��ġ�ϴ� �����Ͱ� �����ϴ�.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_COR_DELETE��(��) �����ϵǾ����ϴ�.


--�� ���� ���� Ʈ����
--> ������û ���̺�, �������� ���̺����� ���� ����
CREATE OR REPLACE TRIGGER DEL_COURSE_1
        BEFORE
        DELETE ON COURSE
        FOR EACH ROW
BEGIN
    DELETE
    FROM ENROLL
    WHERE COURSE_ID=:OLD.COURSE_ID;    
END;

CREATE OR REPLACE TRIGGER DEL_COURSE_2
        BEFORE
        DELETE ON COURSE
        FOR EACH ROW
BEGIN
    DELETE
    FROM ESTABLISHED_SUB
    WHERE COURSE_ID=:OLD.COURSE_ID;
    
END;



--�� �������࿩��(���� ����, ���� ��, ���� ����)
CREATE OR REPLACE FUNCTION FN_STATUS
( V_S_START    IN SUBJECTS.S_START%TYPE
, V_S_END     IN SUBJECTS.S_END%TYPE
)
RETURN VARCHAR2     -- ��ȯ �ڷ��� : �ڸ���(����) ���� �� ��
IS
    -- �ֿ� ���� ����
    VRESULT VARCHAR2(20);
BEGIN
    -- ���� �� ó��
    IF ( V_S_START > SYSDATE )
        THEN VRESULT := '���� ����';
    ELSIF ( V_S_END >= SYSDATE )
        THEN VRESULT := '���� ��';
    ELSE
        VRESULT := '���� ����';
    END IF;
    
    -- ���� ����� ��ȯ
    RETURN VRESULT;
    
END;
--==>> Function FN_STATUS��(��) �����ϵǾ����ϴ�.


--�� �������� ����
CREATE OR REPLACE FUNCTION FN_TOTAL_SCORE
( V_SCORE_ID    IN SCORE.SCORE_ID%TYPE
, V_EST_SUB_ID  IN SCORE.EST_SUB_ID%TYPE
)
RETURN NUMBER     -- ��ȯ �ڷ��� : �ڸ���(����) ���� �� ��
IS
    -- �ֿ� ���� ����
    VRESULT NUMBER;
    
    V_A_PER ESTABLISHED_SUB.ATTEND_PER%TYPE;
    V_P_PER ESTABLISHED_SUB.ATTEND_PER%TYPE;
    V_W_PER ESTABLISHED_SUB.ATTEND_PER%TYPE;
    
    V_A_SCORE SCORE.ATTEND_SCORE%TYPE;
    V_P_SCORE SCORE.ATTEND_SCORE%TYPE;
    V_W_SCORE SCORE.ATTEND_SCORE%TYPE;
    
BEGIN
    -- ���� �޾ƿ���
    SELECT NVL(ATTEND_PER, 0), NVL(PRACTICAL_PER, 0), NVL(WRITING_PER, 0) INTO V_A_PER, V_P_PER, V_W_PER
    FROM ESTABLISHED_SUB
    WHERE EST_SUB_ID = V_EST_SUB_ID;
    
    -- ���� �޾ƿ���
    SELECT NVL(ATTEND_SCORE, 0), NVL(PRACTICAL_SCORE, 0), NVL(WRITING_SCORE, 0) INTO V_A_SCORE, V_P_SCORE, V_W_SCORE
    FROM SCORE
    WHERE SCORE_ID = V_SCORE_ID AND EST_SUB_ID = V_EST_SUB_ID;


    VRESULT := (V_A_SCORE*V_A_PER + V_P_SCORE*V_P_PER + V_W_SCORE*V_W_PER)/100;
    
    -- ���� ����� ��ȯ
    RETURN VRESULT;
    
END;
--==>> Function FN_TOTAL_SCORE��(��) �����ϵǾ����ϴ�.


--�����ڵ� ������ ����
CREATE SEQUENCE SEQ_SCORE_ID
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;
--==>> Sequence SEQ_SCORE_ID��(��) �����Ǿ����ϴ�.


--�� �����Է� ���ν���
CREATE OR REPLACE PROCEDURE PRC_SCORE_INSERT 
( V_E_ID                IN SCORE.E_ID%TYPE 
, V_EST_SUB_ID          IN SCORE.EST_SUB_ID%TYPE
, V_ATTEND_SCORE        IN SCORE.ATTEND_SCORE%TYPE
, V_PRACTICAL_SCORE     IN SCORE.PRACTICAL_SCORE%TYPE
, V_WRITING_SCORE       IN SCORE.WRITING_SCORE%TYPE
)
IS
    V_COURSE_ID         COURSE.COURSE_ID%TYPE;
    V_PRO_ID            COURSE.PRO_ID%TYPE;
    V_CNT               NUMBER;

    NOT_YOUR_EST_ERROR   EXCEPTION;
    MID_DROP_STU_ERROR   EXCEPTION;

BEGIN
    -- ����ó��. �ߵ�Ż���� ������û ������ ���
    SELECT COUNT(*) INTO V_CNT
    FROM MID_DROP
    WHERE E_ID = V_E_ID;
    
    IF (V_CNT > 0)
        THEN RAISE MID_DROP_STU_ERROR;
    END IF;
    

    -- SCORE(�������̺�) INSERT 
    INSERT INTO SCORE(SCORE_ID, E_ID, EST_SUB_ID, ATTEND_SCORE, PRACTICAL_SCORE, WRITING_SCORE)
    VALUES('SCORE' || SEQ_SCORE_ID.NEXTVAL, V_E_ID, V_EST_SUB_ID, V_ATTEND_SCORE, V_PRACTICAL_SCORE, V_WRITING_SCORE);


    -- Ŀ��
    COMMIT;
    
    
    -- ����ó��
    EXCEPTION
        WHEN MID_DROP_STU_ERROR
            THEN RAISE_APPLICATION_ERROR(-20002, '�ߵ������� ������û �����Դϴ�.');
                 ROLLBACK;
        WHEN OTHERS 
            THEN ROLLBACK;
END;
--==>> Procedure PRC_SCORE_INSERT��(��) �����ϵǾ����ϴ�.



--�� �������� ���ν���
CREATE OR REPLACE PROCEDURE PRC_SCORE_UPDATE
( V_SCORE_ID            IN SCORE.SCORE_ID%TYPE
, V_ATTEND_SCORE        IN SCORE.ATTEND_SCORE%TYPE
, V_PRACTICAL_SCORE     IN SCORE.PRACTICAL_SCORE%TYPE
, V_WRITING_SCORE       IN SCORE.WRITING_SCORE%TYPE
)
IS
BEGIN
    -- SCORE(�������̺�) ���, �Ǳ�, �ʱ� ������Ʈ
    UPDATE SCORE
    SET ATTEND_SCORE = V_ATTEND_SCORE, PRACTICAL_SCORE = V_PRACTICAL_SCORE, WRITING_SCORE = V_WRITING_SCORE
    WHERE SCORE_ID = V_SCORE_ID;

END;
--==>> Procedure PRC_SCORE_UPDATE��(��) �����ϵǾ����ϴ�.

--�� �������� ���ν���
CREATE OR REPLACE PROCEDURE PRC_SCORE_DELETE
( V_SCORE_ID            IN SCORE.SCORE_ID%TYPE
)
IS
BEGIN
    -- SCORE(�������̺�) ���� ����
    DELETE
    FROM SCORE
    WHERE SCORE_ID = V_SCORE_ID;

END;
--==>> Procedure PRC_SCORE_DELETE��(��) �����ϵǾ����ϴ�.



--�����ڵ� ������ ����
CREATE SEQUENCE SEQ_COURSE_ID
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;
--==>> Sequence SEQ_COURSE_ID��(��) �����Ǿ����ϴ�.


--�� ���� �Է� ���ν���
CREATE OR REPLACE PROCEDURE PRC_COR_INSERT
( V_COURSE_NAME  IN COURSE.COURSE_NAME%TYPE
, V_C_START     IN COURSE.C_START%TYPE
, V_C_END       IN COURSE.C_END%TYPE
, V_CLASSROOM   IN COURSE.CLASSROOM%TYPE
)
IS
BEGIN

    INSERT INTO COURSE(COURSE_ID, COURSE_NAME, C_START,C_END, CLASSROOM)
    VALUES ('COURSE' || SEQ_COURSE_ID.NEXTVAL, V_COURSE_NAME, V_C_START,V_C_END,V_CLASSROOM);

END;
--==>> Procedure PRC_COR_INSERT��(��) �����ϵǾ����ϴ�.


--�� ���� ���� ���ν���
CREATE OR REPLACE PROCEDURE PRC_COR_UPDATE
( V_COURSE_ID    IN COURSE.COURSE_ID%TYPE 
, V_COURSE_NAME  IN COURSE.COURSE_NAME%TYPE
, V_C_START      IN COURSE.C_START%TYPE
, V_C_END        IN COURSE.C_END%TYPE
, V_CLASSROOM    IN COURSE.CLASSROOM%TYPE

)
IS

UESR_DEFINE_ERROR EXCEPTION;

V_SUB_ID     SUBJECTS.SUB_ID%TYPE;
V_S_START    DATE;
V_S_END      DATE;

BEGIN

    SELECT SUB_ID INTO V_SUB_ID
    FROM ESTABLISHED_SUB
    WHERE COURSE_ID = V_COURSE_ID;
    
    SELECT S_START, S_END INTO V_S_START, V_S_END
    FROM SUBJECTS
    WHERE SUB_ID = V_SUB_ID;
    
    -- ���� ���� �Ⱓ�� ����� �������� ���ϵ��� �ϴ� ����ó�� �ʿ�  
    
    IF (V_C_START < V_S_START OR V_S_END > V_C_END)
        THEN RAISE UESR_DEFINE_ERROR;
    END IF;
    
    EXCEPTION
        WHEN UESR_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20925,'������ �Ⱓ�� �߸��Ǿ����ϴ�..');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
            
    UPDATE COURSE
    SET COURSE_NAME = V_COURSE_NAME, C_START = V_C_START, C_END = V_C_END, CLASSROOM = V_CLASSROOM
    WHERE COURSE_ID = V_COURSE_ID; 
    
    COMMIT;

END;
--==>> Procedure PRC_COR_UPDATE��(��) �����ϵǾ����ϴ�.



--�� ���� ����(����) �ο�
CREATE OR REPLACE PROCEDURE PRC_SUB_SCORE_RATIO
( V_EST_SUB_ID     IN ESTABLISHED_SUB.EST_SUB_ID%TYPE 
, V_ATTEND_PER     IN ESTABLISHED_SUB.ATTEND_PER%TYPE
, V_PRACTICAL_PER  IN ESTABLISHED_SUB.PRACTICAL_PER%TYPE
, V_WRITING_PER    IN ESTABLISHED_SUB.WRITING_PER%TYPE
)
IS
BEGIN
    
    UPDATE ESTABLISHED_SUB
    SET ATTEND_PER = V_ATTEND_PER, PRACTICAL_PER = V_PRACTICAL_PER, WRITING_PER = V_WRITING_PER
    WHERE EST_SUB_ID = V_EST_SUB_ID; 
    
END;
--==>> Procedure PRC_SUB_SCORE_RATIO��(��) �����ϵǾ����ϴ�.


--�۰��� DELETE ���ν��� ����
CREATE OR REPLACE PROCEDURE PRC_SUB_DELETE
(
    V_SUB_ID IN SUBJECTS.SUB_ID%TYPE
)
IS
    NONEXIST_ERROR  EXCEPTION;
BEGIN
    DELETE
    FROM SUBJECTS
    WHERE SUB_ID = V_SUB_ID;
    
    IF SQL%NOTFOUND
    THEN RAISE NONEXIST_ERROR;
    END IF;
        
    COMMIT;

    EXCEPTION
        WHEN NONEXIST_ERROR
            THEN RAISE_APPLICATION_ERROR(-20009,'��ġ�ϴ� �����Ͱ� �����ϴ�.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>>Procedure PRC_SUB_DELETE��(��) �����ϵǾ����ϴ�.

--�� ���� UPDATE ���ν���
CREATE OR REPLACE PROCEDURE PRC_SUB_UPDATE
(
    V_SUB_ID    IN  SUBJECTS.SUB_ID%TYPE
,   V_SUB_NAME    IN  SUBJECTS.SUB_NAME%TYPE 
)
IS
    V_COUNT             NUMBER;
    NOT_FOUND_ERROR    EXCEPTION;
BEGIN
    --������ �����ڵ��� �ִ��� üũ
    SELECT COUNT(*) INTO V_COUNT
    FROM SUBJECTS
    WHERE SUB_ID = V_SUB_ID;
    
    --������ �����ڵ尡 �ִ� ���
    IF V_COUNT = 1
    THEN
        UPDATE SUBJECTS
        SET    SUB_NAME = V_SUB_NAME
        WHERE  SUB_ID = V_SUB_ID;
        
        COMMIT;
    ELSE
        RAISE NOT_FOUND_ERROR;
    END IF;
    
    EXCEPTION
    WHEN NOT_FOUND_ERROR
        THEN RAISE_APPLICATION_ERROR(-20010, '��ġ�ϴ� �����Ͱ� �����ϴ�.');
             ROLLBACK;
    WHEN OTHERS
        THEN ROLLBACK;
END;
--==>>Procedure PRC_SUB_UPDATE��(��) �����ϵǾ����ϴ�.


--���������ڵ� ������ ����
CREATE SEQUENCE SEQ_E_SUB_ID
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;
--==>> Sequence SEQ_E_SUB_ID��(��) �����Ǿ����ϴ�.


--�� �������� INSERT ���ν���
CREATE OR REPLACE PROCEDURE PRC_ESTABLISHED_SUB
( V_PRO_ID          IN ESTABLISHED_SUB.PRO_ID%TYPE
, V_COURSE_ID       IN ESTABLISHED_SUB.COURSE_ID%TYPE
, V_SUB_ID          IN ESTABLISHED_SUB.SUB_ID%TYPE
)
IS
    V_C_START           COURSE.C_START%TYPE;
    V_C_END             COURSE.C_END%TYPE;
    V_S_START           SUBJECTS.S_START%TYPE;
    V_S_END             SUBJECTS.S_END%TYPE;
    
    USER_DEFINE_ERROR   EXCEPTION;

BEGIN
    -- ������ �� ���
    SELECT C_START, C_END INTO V_C_START, V_C_END
    FROM COURSE
    WHERE COURSE_ID = V_COURSE_ID;
    
    SELECT S_START, S_END INTO V_S_START, V_S_END
    FROM SUBJECTS
    WHERE SUB_ID = V_SUB_ID;
    
    IF (V_C_START > V_S_START OR V_S_END > V_C_END) --���� �������� ���� �����Ϻ��� �ڰų� ���� �������� ���� �����Ϻ��� �ڸ� �����߻�
        THEN RAISE USER_DEFINE_ERROR;
    END IF;

    -- INSERT
    INSERT INTO ESTABLISHED_SUB(EST_SUB_ID,PRO_ID,COURSE_ID,SUB_ID)
    VALUES ('ESUB' || SEQ_E_SUB_ID.NEXTVAL, V_PRO_ID,V_COURSE_ID,V_SUB_ID);
    
    -- Ŀ��
    COMMIT;
    
    -- ���� �߻�
    EXCEPTION
        WHEN USER_DEFINE_ERROR
            THEN RAISE_APPLICATION_ERROR(-20001, '���� ���� ��¥�� �߸� �ԷµǾ����ϴ�.');
                 ROLLBACK;
        WHEN OTHERS
            THEN ROLLBACK;
END;
--==>> Procedure PRC_ESTABLISHED_SUB��(��) �����ϵǾ����ϴ�.


--�����ڵ� ������ ����
CREATE SEQUENCE SEQ_SUB_ID
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;
--==>> Sequence SEQ_SUB_ID��(��) �����Ǿ����ϴ�.


--�� ���� + �������� INSERT 
CREATE OR REPLACE PROCEDURE PRC_SUB_INSERT
( V_COURSE_ID     IN COURSE.COURSE_NAME%TYPE
, V_SUB_NAME        IN SUBJECTS.SUB_NAME%TYPE
, V_S_START         IN SUBJECTS.S_START%TYPE
, V_S_END           IN SUBJECTS.S_END%TYPE
, V_BOOK_NAME       IN SUBJECTS.BOOK_NAME%TYPE
, V_PRO_ID        IN PROFESSORS.PRO_NAME%TYPE
)
IS
    V_EST_SUB_ID      ESTABLISHED_SUB.EST_SUB_ID%TYPE;
   -- V_PRO_ID        ESTABLISHED_SUB.PRO_ID%TYPE;
   -- V_COURSE_ID     ESTABLISHED_SUB.COURSE_ID%TYPE;
    V_SUB_ID        ESTABLISHED_SUB.SUB_ID%TYPE;
BEGIN

    -- PRC_ESTABLISHED_SUB ���ν����� ��¥�� ����ó���ϴ� �κ� ���ԵǾ� �־ ���� ����� ���� ����ó�� ���� �ۼ����� �ʾҽ��ϴ�.
    
    V_SUB_ID := 'SUB' || SEQ_SUB_ID.NEXTVAL;

    -- SUBJECTS(����) ���̺� INSERT
    INSERT INTO SUBJECTS(SUB_ID, SUB_NAME, S_START, S_END, BOOK_NAME)
    VALUES (V_SUB_ID, V_SUB_NAME, V_S_START, V_S_END, V_BOOK_NAME);

    -- ESTABLISHED_SUB(����) ���̺� INSERT
    PRC_ESTABLISHED_SUB(V_PRO_ID, V_COURSE_ID, V_SUB_ID);

    -- ����
    EXCEPTION
        WHEN OTHERS 
            THEN RAISE_APPLICATION_ERROR(-20003,'�ٽ� �Է����ּ���');
                 ROLLBACK;

END;
--==>> Procedure PRC_SUB_INSERT��(��) �����ϵǾ����ϴ�.

--�� ���� UPDATE & DELETE Ʈ����
CREATE OR REPLACE TRIGGER TRG_SUB_UPDATE
        BEFORE
        UPDATE OR DELETE ON SUBJECTS
        FOR EACH ROW
        
BEGIN
    DELETE
    FROM ESTABLISHED_SUB
    WHERE SUB_ID=:OLD.SUB_ID; 

END;
--==>> Trigger TRG_SUB_UPDATE��(��) �����ϵǾ����ϴ�.
