--�� ������ �䱸 �м�
-- ���� ��� ���
-- �ڽ��� ������ ����, "�����, ���� �Ⱓ(����), ����Ⱓ(��), �����, �л���, ���, �Ǳ�, �ʱ�, ����, ���
-- ���� �ߵ�Ż�� ��: ������ ���� ���� ���, �ߵ�Ż�� ���� ���
CREATE OR REPLACE VIEW VIEW_PRO_SCORE_INFO
AS
SELECT SUB.SUB_NAME "�����", SUB.S_START "���� ������", SUB.S_END "���� ������", SUB.BOOK_NAME "�����"
     , STU.ST_NAME "�л���", SC.ATTEND_SCORE "�������", SC.PRACTICAL_SCORE "�Ǳ�����", SC.WRITING_SCORE "�ʱ�����"
     , (NVL(SC.ATTEND_SCORE, 0) + NVL(SC.PRACTICAL_SCORE, 0) + NVL(SC.WRITING_SCORE, 0)) "����"
     , RANK() OVER(ORDER BY (NVL(SC.ATTEND_SCORE, 0) + NVL(SC.PRACTICAL_SCORE, 0) + NVL(SC.WRITING_SCORE, 0)) DESC) "���"
     , CASE WHEN MID.E_ID IS NOT NULL THEN 'Y'
            ELSE 'N'
       END "�ߵ�����"
FROM STUDENTS STU RIGHT JOIN ENROLL E
     ON STU.ST_ID = E.ST_ID
        LEFT JOIN SCORE SC
        ON E.E_ID = SC.E_ID
            RIGHT JOIN ESTABLISHED_SUB EST
            ON SC.EST_SUB_ID = EST.EST_SUB_ID
                LEFT JOIN SUBJECTS SUB
                ON EST.SUB_ID = SUB.SUB_ID
                    LEFT JOIN MID_DROP MID
                    ON E.E_ID = MID.E_ID; -- WHERE���� �ش�Ǵ� ���� �ڵ� �Է� 
--==>> View VIEW_PRO_SCORE_INFO��(��) �����Ǿ����ϴ�.



--�� ������ �� �䱸�м�

--������ ���� ���� ��� ����
-- ��� �������� ������ ����Ͽ� �� �� �־�� �Ѵ�.(�����ڸ�, ������ �����, ���� �Ⱓ, ���� ��, ���ǽ�, �������࿩��)
-- ������ ���� ��� NULL���� �� ó��
CREATE OR REPLACE VIEW VIEW_PRO_INFO
AS
SELECT P.PRO_NAME "�����ڸ�", S.SUB_NAME "������ �����", S.S_START || ' ~ ' || S.S_END "���� �Ⱓ", S.BOOK_NAME"�����", CLASSROOM "���ǽ�", FN_STATUS(S.S_START, S.S_END) "�������࿩��"
FROM PROFESSORS P LEFT JOIN ESTABLISHED_SUB ES
ON P.PRO_ID = ES.PRO_ID
    LEFT JOIN SUBJECTS S
    ON ES.SUB_ID = S.SUB_ID
ORDER BY P.PRO_ID;
--==>> View VIEW_PRO_INFO��(��) �����Ǿ����ϴ�.

    
--���� ���� ��� ����
-- �����ڴ� ��ϵ� ��� ������ ������ ����Ͽ� �� �� �־�� �Ѵ�. (������, ���ǽ�, �����, ���� �Ⱓ, �����, �����ڸ�)   
CREATE OR REPLACE VIEW VIEW_COR_INFO
AS
SELECT C.COURSE_NAME "������", C.CLASSROOM "���ǽ�", S.SUB_NAME "�����", S.S_START || ' ~ ' || S.S_END "���� �Ⱓ", S.BOOK_NAME "�����", P.PRO_NAME"�����ڸ�"
FROM COURSE C JOIN ESTABLISHED_SUB ES
ON C.COURSE_ID = ES.COURSE_ID
    JOIN SUBJECTS S
    ON S.SUB_ID = ES.SUB_ID 
        JOIN PROFESSORS P
        ON ES.PRO_ID = P.PRO_ID
ORDER BY C.COURSE_ID;
--==>> View VIEW_COR_INFO��(��) �����Ǿ����ϴ�.



--�л� ���� ��� ����
-- �����ڴ� ��ϵ� ��� �л��� ������ ����� �� �־�� �Ѵ�. (�л� �̸�, ������, ��������, �������� ����, �ߵ� Ż�� ���)
CREATE OR REPLACE VIEW VIEW_STD_INFO
AS
SELECT STD.ST_NAME "�л� �̸�", C.COURSE_ID "������", S.SUB_NAME "��������", FN_TOTAL_SCORE(SCORE.SCORE_ID, SCORE.EST_SUB_ID) "�������� ����", NVL2(MD.E_ID, '�ߵ�Ż��', '�ߵ�Ż���ƴ�') "�ߵ� Ż�� ���"
FROM STUDENTS STD LEFT JOIN ENROLL E
ON STD.ST_ID = E.ST_ID
    LEFT JOIN COURSE C
    ON E.COURSE_ID = C.COURSE_ID
        LEFT JOIN ESTABLISHED_SUB ES
        ON C.COURSE_ID = ES.COURSE_ID
            LEFT JOIN SUBJECTS S
            ON ES.SUB_ID = S.SUB_ID
                LEFT JOIN MID_DROP MD
                ON E.E_ID = MD.E_ID
                    LEFT JOIN SCORE
                    ON E.E_ID = SCORE.E_ID AND SCORE.EST_SUB_ID = ES.EST_SUB_ID
ORDER BY STD.ST_ID;
--==>> View VIEW_STD_INFO��(��) �����Ǿ����ϴ�.



--�� �л� �䱸 �м�
-- ������ ���� ���� ���� �� �̿� ���� ������ Ȯ���� �� �־�� �Ѵ�. 
-- (�л� �̸�, ������, �����, ���� �Ⱓ(���� ������, �� ������), ���� ��, ���, �Ǳ�, �ʱ�, ����, ���)
CREATE OR REPLACE VIEW VIEW_STD_SCORE
AS
SELECT STD.ST_NAME "�л� �̸�", C.COURSE_ID"������", S.SUB_NAME "�����"
     , S.S_START || ' - ' || S.S_END  "���� �Ⱓ"
     , S.BOOK_NAME "���� ��"
     , SC.ATTEND_SCORE "�������", SC.PRACTICAL_SCORE "�Ǳ�����", SC.WRITING_SCORE "�ʱ�����"
     , FN_TOTAL_SCORE(SC.SCORE_ID, SC.EST_SUB_ID) "����"
     , RANK() OVER(PARTITION BY ES.EST_SUB_ID ORDER BY ( NVL(SC.ATTEND_SCORE, 0) + NVL(SC.PRACTICAL_SCORE, 0) + NVL(SC.WRITING_SCORE, 0)) DESC) "���"
FROM STUDENTS STD LEFT JOIN ENROLL E
ON STD.ST_ID = E.ST_ID 
    LEFT JOIN COURSE C
    ON C.COURSE_ID = E.COURSE_ID
        LEFT JOIN ESTABLISHED_SUB ES
        ON ES.COURSE_ID = C.COURSE_ID
            LEFT JOIN SUBJECTS S
            ON S.SUB_ID = ES.SUB_ID
                LEFT JOIN SCORE SC
                ON ES.EST_SUB_ID = SC.EST_SUB_ID AND E.E_ID = SC.E_ID
WHERE S.S_END < SYSDATE
ORDER BY ES.EST_SUB_ID;
--==>> View VIEW_STD_SCORE��(��) �����Ǿ����ϴ�.



