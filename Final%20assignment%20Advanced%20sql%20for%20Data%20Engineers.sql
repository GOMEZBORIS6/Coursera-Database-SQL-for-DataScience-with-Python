1.Write and execute a SQL query to list the school names, community names and average attendance for communities with a hardship index of 98.

select CS.NAME_OF_SCHOOL, CD.COMMUNITY_AREA_NAME, CS.AVERAGE_STUDENT_ATTENDANCE,CD.HARDSHIP_INDEX 
from CHICAGO_PUBLIC_SCHOOLS CS left outer join CENSUS_DATA CD 
on CS.COMMUNITY_AREA_NUMBER = CD.COMMUNITY_AREA_NUMBER where HARDSHIP_INDEX = 98

2.Write and execute a SQL query to list all crimes that took place at a school. Include case number, crime type and community name.
select C.CASE_NUMBER,C.PRIMARY_TYPE,CD.COMMUNITY_AREA_NAME, C.LOCATION_DESCRIPTION 
from CHICAGO_CRIME_DATA C left outer join CENSUS_DATA CD 
on C.COMMUNITY_AREA_NUMBER = CD.COMMUNITY_AREA_NUMBER where C.LOCATION_DESCRIPTION like 'SCHOOL%'

3. Creating a View: Write and execute a SQL statement to create a view showing the columns listed in the following table, with new column names as shown in the second column.

CREATE OR REPLACE VIEW Info_CHICAGO_PUBLIC_SCHOOLS
AS SELECT NAME_OF_SCHOOL as School_Name,Safety_Icon as Safety_Rating,Family_Involvement_Icon as Family_Rating,
Environment_Icon as Environment_Rating,Instruction_Icon as Instruction_Rating,Leaders_Icon as Leaders_Rating,
Teachers_Icon as Teachers_Rating
FROM CHICAGO_PUBLIC_SCHOOLS

select * from Info_CHICAGO_PUBLIC_SCHOOLS
select School_Name,Leaders_Rating from Info_CHICAGO_PUBLIC_SCHOOLS 

Exercise 3: Creating a Stored Procedure

--#SET TERMINATOR @
CREATE PROCEDURE UPDATE_LEADERS_SCORE (
    IN in_School_ID  INTEGER, IN in_Leader_Score INTEGER) 
LANGUAGE SQL 
MODIFIES SQL DATA
  BEGIN
    UPDATE "CHICAGO_PUBLIC_SCHOOLS"
    SET "LEADERS_SCORE" = in_Leader_Score
    WHERE "SCHOOL_ID" = in_School_ID;
    
    IF in_Leader_Score >=  80 THEN 
        UPDATE "CHICAGO_PUBLIC_SCHOOLS"
        SET "LEADERS_ICON" = 'Very_Strong'
        WHERE "SCHOOL_ID" = in_School_ID;
    ELSEIF in_Leader_Score>= 60 and in_Leader_Score <= 79  THEN
        UPDATE "CHICAGO_PUBLIC_SCHOOLS"
        SET "LEADERS_ICON" = 'Strong'
        WHERE "SCHOOL_ID" = in_School_ID;
    ELSEIF in_Leader_Score >=  40 and in_Leader_Score <= 59  THEN
        UPDATE "CHICAGO_PUBLIC_SCHOOLS"
        SET "LEADERS_ICON" = 'Average'
        WHERE "SCHOOL_ID" = in_School_ID;
    ELSEIF in_Leader_Score >=  20 and in_Leader_Score <= 39  THEN
        UPDATE "CHICAGO_PUBLIC_SCHOOLS"
        SET "LEADERS_ICON" = 'Weak'
        WHERE "SCHOOL_ID" = in_School_ID;
    ELSEIF in_Leader_Score >= 0 and in_Leader_Score >= 19 THEN
        UPDATE "CHICAGO_PUBLIC_SCHOOLS"
        SET "LEADERS_ICON" = 'Very Weak'
        WHERE "SCHOOL_ID" = in_School_ID;
        
    ELSE 
		COMMIT WORK;
    END IF;
  END@

call UPDATE_LEADERS_SCORE
