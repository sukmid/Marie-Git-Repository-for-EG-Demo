libname student 'C:\Users\sukmid\OneDrive - SAS\Desktop\Student Success - AU';
PROC SQL;
	CREATE VIEW WORK.SORTTempTableSorted AS
		SELECT T.Retention_Rate, T.State
	FROM STUDENT.SUCCESS as T
;
QUIT;
PROC MEANS DATA=WORK.SORTTempTableSorted
	FW=12
	PRINTALLTYPES
	CHARTYPE
	NWAY
	VARDEF=DF 	
		MEAN 
		STD 
		MIN 
		MAX 
		SUM 
		N	;
	VAR Retention_Rate;
	CLASS State /	ORDER=UNFORMATTED ASCENDING;
RUN;
