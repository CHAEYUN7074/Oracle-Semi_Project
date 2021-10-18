--○ 교수자 요구 분석
-- 성적 출력 기능
-- 자신이 강의한 과목, "과목명, 과목 기간(시작), 과목기간(끝), 교재명, 학생명, 출결, 실기, 필기, 총점, 등수
-- 과정 중도탈락 시: 수강한 과목 성적 출력, 중도탈락 여부 출력
CREATE OR REPLACE VIEW VIEW_PRO_SCORE_INFO
AS
SELECT SUB.SUB_NAME "과목명", SUB.S_START "과목 시작일", SUB.S_END "과목 종료일", SUB.BOOK_NAME "교재명"
     , STU.ST_NAME "학생명", SC.ATTEND_SCORE "출결점수", SC.PRACTICAL_SCORE "실기점수", SC.WRITING_SCORE "필기점수"
     , (NVL(SC.ATTEND_SCORE, 0) + NVL(SC.PRACTICAL_SCORE, 0) + NVL(SC.WRITING_SCORE, 0)) "총점"
     , RANK() OVER(ORDER BY (NVL(SC.ATTEND_SCORE, 0) + NVL(SC.PRACTICAL_SCORE, 0) + NVL(SC.WRITING_SCORE, 0)) DESC) "등수"
     , CASE WHEN MID.E_ID IS NOT NULL THEN 'Y'
            ELSE 'N'
       END "중도포기"
FROM STUDENTS STU RIGHT JOIN ENROLL E
     ON STU.ST_ID = E.ST_ID
        LEFT JOIN SCORE SC
        ON E.E_ID = SC.E_ID
            RIGHT JOIN ESTABLISHED_SUB EST
            ON SC.EST_SUB_ID = EST.EST_SUB_ID
                LEFT JOIN SUBJECTS SUB
                ON EST.SUB_ID = SUB.SUB_ID
                    LEFT JOIN MID_DROP MID
                    ON E.E_ID = MID.E_ID; -- WHERE절에 해당되는 교수 코드 입력 
--==>> View VIEW_PRO_SCORE_INFO이(가) 생성되었습니다.



--○ 관리자 측 요구분석

--교수자 계정 관리 기능 구현
-- 모든 교수자의 정보를 출력하여 볼 수 있어야 한다.(교수자명, 배정된 과목명, 과목 기간, 교재 명, 강의실, 강의진행여부)
-- 배정된 과목 없어서 NULL값일 때 처리
CREATE OR REPLACE VIEW VIEW_PRO_INFO
AS
SELECT P.PRO_NAME "교수자명", S.SUB_NAME "배정된 과목명", S.S_START || ' ~ ' || S.S_END "과목 기간", S.BOOK_NAME"교재명", CLASSROOM "강의실", FN_STATUS(S.S_START, S.S_END) "강의진행여부"
FROM PROFESSORS P LEFT JOIN ESTABLISHED_SUB ES
ON P.PRO_ID = ES.PRO_ID
    LEFT JOIN SUBJECTS S
    ON ES.SUB_ID = S.SUB_ID
ORDER BY P.PRO_ID;
--==>> View VIEW_PRO_INFO이(가) 생성되었습니다.

    
--과정 관리 기능 구현
-- 관리자는 등록된 모든 과정의 정보를 출력하여 볼 수 있어야 한다. (과정명, 강의실, 과목명, 과목 기간, 교재명, 교수자명)   
CREATE OR REPLACE VIEW VIEW_COR_INFO
AS
SELECT C.COURSE_NAME "과정명", C.CLASSROOM "강의실", S.SUB_NAME "과목명", S.S_START || ' ~ ' || S.S_END "과목 기간", S.BOOK_NAME "교재명", P.PRO_NAME"교수자명"
FROM COURSE C JOIN ESTABLISHED_SUB ES
ON C.COURSE_ID = ES.COURSE_ID
    JOIN SUBJECTS S
    ON S.SUB_ID = ES.SUB_ID 
        JOIN PROFESSORS P
        ON ES.PRO_ID = P.PRO_ID
ORDER BY C.COURSE_ID;
--==>> View VIEW_COR_INFO이(가) 생성되었습니다.



--학생 관리 기능 구현
-- 관리자는 등록된 모든 학생의 정보를 출력할 수 있어야 한다. (학생 이름, 과정명, 수강과목, 수강과목 총점, 중도 탈락 사실)
CREATE OR REPLACE VIEW VIEW_STD_INFO
AS
SELECT STD.ST_NAME "학생 이름", C.COURSE_ID "과정명", S.SUB_NAME "수강과목", FN_TOTAL_SCORE(SCORE.SCORE_ID, SCORE.EST_SUB_ID) "수강과목 총점", NVL2(MD.E_ID, '중도탈락', '중도탈락아님') "중도 탈락 사실"
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
--==>> View VIEW_STD_INFO이(가) 생성되었습니다.



--○ 학생 요구 분석
-- 수강이 끝난 과목 선택 시 이에 대한 성적을 확인할 수 있어야 한다. 
-- (학생 이름, 과정명, 과목명, 교육 기간(시작 연월일, 끝 연월일), 교재 명, 출결, 실기, 필기, 총점, 등수)
CREATE OR REPLACE VIEW VIEW_STD_SCORE
AS
SELECT STD.ST_NAME "학생 이름", C.COURSE_ID"과정명", S.SUB_NAME "과목명"
     , S.S_START || ' - ' || S.S_END  "교육 기간"
     , S.BOOK_NAME "교재 명"
     , SC.ATTEND_SCORE "출결점수", SC.PRACTICAL_SCORE "실기점수", SC.WRITING_SCORE "필기점수"
     , FN_TOTAL_SCORE(SC.SCORE_ID, SC.EST_SUB_ID) "총점"
     , RANK() OVER(PARTITION BY ES.EST_SUB_ID ORDER BY ( NVL(SC.ATTEND_SCORE, 0) + NVL(SC.PRACTICAL_SCORE, 0) + NVL(SC.WRITING_SCORE, 0)) DESC) "등수"
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
--==>> View VIEW_STD_SCORE이(가) 생성되었습니다.



