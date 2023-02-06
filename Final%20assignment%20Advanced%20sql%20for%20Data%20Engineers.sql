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

--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE (IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)
LANGUAGE SQL
MODIFIES SQL DATA 
  	BEGIN 

	END@
	
--#SET TERMINATOR @

CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE (IN in_School_ID INTEGER, IN in_Leader_Score INTEGER)
LANGUAGE SQL
MODIFIES SQL DATA 
	BEGIN 
	
		UPDATE CHICAGO_PUBLIC_SCHOOLS
		SET "LEADERS_SCORE" = in_Leader_Score
		WHERE "SCHOOL_ID" = in_School_ID;
			
	END@
Exercise 3: Creating a Stored Procedure

--#SET TERMINATOR @
CREATE OR REPLACE PROCEDURE UPDATE_LEADERS_SCORE (
    IN in_School_ID  INTEGER, IN in_Leader_Score INTEGER) 
LANGUAGE SQL 
MODIFIES SQL DATA
  BEGIN
    UPDATE "CHICAGO_PUBLIC_SCHOOLS"
    SET "LEADERS_SCORE" = in_Leader_Score
    WHERE "SCHOOL_ID" = in_School_ID;
    
    IF in_Leader_Score > 0 AND in_Leader_Score < 20 THEN
	    UPDATE CHICAGO_PUBLIC_SCHOOLS
		SET "LEADERS_ICON" = 'Very Weak';
	ELSEIF in_Leader_Score < 40 THEN
	    UPDATE CHICAGO_PUBLIC_SCHOOLS
		SET "LEADERS_ICON" = 'Weak';	
	ELSEIF in_Leader_Score < 60 THEN
	    UPDATE CHICAGO_PUBLIC_SCHOOLS
		SET "LEADERS_ICON" = 'Average';
	ELSEIF in_Leader_Score < 80 THEN
	    UPDATE CHICAGO_PUBLIC_SCHOOLS
		SET "LEADERS_ICON" = 'Strong';
	ELSEIF in_Leader_Score < 100 THEN
	    UPDATE CHICAGO_PUBLIC_SCHOOLS
		SET "LEADERS_ICON" = 'Very Strong';
	ELSE
		ROLLBACK WORK
	END IF;
		COMMIT WORK;
		
  END@
   

--#ELSE 
--		COMMIT WORK;
--call UPDATE_LEADERS_SCORE
