/*****************************************************************************/
/* Create CAS Connection												     */
/*  Once the options are set, the cas command connects the default session   */ 
/*  to the specified CAS server and CAS port, for example the default value  */
/*  is 5570.                                                                 */
/*****************************************************************************/
options cashost="<cas server name>" casport=<port number>;
cas;

/*****************************************************************************/
/* New CAS Session                                                           */
/*  Start a session named mySession using the existing CAS server connection */
/*  while allowing override of caslib, timeout (in seconds), and locale      */
/*  defaults.                                                                */
/*****************************************************************************/
cas mySession sessopts=(caslib=casuser timeout=1800 locale="en_US");

/*****************************************************************************/
/*  Disconnect CAS Session                                                   */ 
/*  Disconnect from a session named mySession.  Before disconnecting, set an */ 
/*  appropriate value for the timeout parameter.  You can reconnect to the   */
/*  session before the timeout expires.  Otherwise the session is terminated */
/*****************************************************************************/
cas mySession sessopts=(timeout=1800);    /* 30 minute timeout */
cas mySession disconnect;

/*****************************************************************************/
/*  Reconnect to a session named "mySession".                                */ 
/*****************************************************************************/
cas mySession reconnect;

/*****************************************************************************/
/*  Terminate the specified CAS session (mySession). No reconnect is possible*/
/*****************************************************************************/
cas mySession terminate;

/*****************************************************************************/
/*  List session options for the specified CAS session (mySession).          */
/*****************************************************************************/
cas mySession listsessopts;

/*****************************************************************************/
/*  List all the CAS sessions (and their session properties) created or      */
/*  reconnected to by the SAS Client.                                        */
/*****************************************************************************/
cas _all_ list;

/*****************************************************************************/
/*  List all of the CAS sessions known to the CAS server for the userID      */
/*  associated with "mySession".                                             */
/*****************************************************************************/
cas mySession listsessions;

/*****************************************************************************/
/*  Create a CAS library (myCaslib) for the specified path ("/filePath/")    */ 
/*  and session (mySession).  If "sessref=" is omitted, the caslib is        */ 
/*  created and activated for the current session.  Setting subdirs extends  */
/*  the scope of myCaslib to subdirectories of "/filePath".                  */
/*****************************************************************************/
caslib myCaslib datasource=(srctype="path") path="/filePath/" sessref=mySession subdirs;
libname myCaslib cas;

/*****************************************************************************/
/*  Create a default CAS session and create SAS librefs for existing caslibs */
/*  so that they are visible in the SAS Studio Libraries tree.               */
/*****************************************************************************/
cas; 
caslib _all_ assign;

/* Save Table to CASLIB */
/* Creates a permanent copy of an in-memory table ("table-name") from "sourceCaslib".      */
/* The in-memory table is saved to the data source that is associated with the target      */
/* caslib ("targetCaslib") using the specified name ("file-name").                         */
/*                                                                                         */
/* To find out the caslib associated with an CAS engine libref, right click on the libref  */
/* from "Libraries" and select "Properties". Then look for the entry named "Server Session */
/* CASLIB".                                                                                */
proc casutil;
    save casdata="table-name" incaslib="sourceCaslib" outcaslib="targetCaslib"
	     casout="file-name";
quit;

/*****************************************************************************/
/* Load Data to CASLIB                                                       */ 
/* Load file from a client location ("pathToClientFile") into the specified  */
/*  caslib ("myCaslib") and save it as "tableNameForLoadedFile".             */
/*****************************************************************************/
proc casutil;
	load file="pathToClientFile" 
	outcaslib="myCaslib" casout="tableNameForLoadedFile";
run;
/*****************************************************************************/
/*  Load SAS data set from a Base engine library (library.tableName) into    */
/*  the specified caslib ("myCaslib") and save as "targetTableName".         */
/*****************************************************************************/
proc casutil;
	load data=library.tablename outcaslib="myCaslib"
	casout="targetTableName";
run;
/*****************************************************************************/
/*  Load a table ("sourceTableName") from the specified caslib               */
/*  ("sourceCaslib") to the target Caslib ("targetCaslib") and save it as    */
/*  "targetTableName".                                                       */
/*****************************************************************************/
proc casutil;
	load casdata="sourceTableName" incaslib="sourceCaslib" 
	outcaslib="targetCaslib" casout="targetTableName";
run;

/*****************************************************************************/
/*  Delete a table or file from a caslib data source ("sourceCaslib").  The  */ 
/*  quiet option suppresses error messages.  Specify casdata="fileName" to   */
/*  remove SASHDAT files from HDFS data source for HDFS-type caslibs.        */ 
/*****************************************************************************/
proc casutil;
   deletesource casdata="tableName" incaslib="sourceCaslib" quiet;
run;
/*****************************************************************************/
/*  Remove an in-memory table ("tableName") from "sourceCaslib". The quiet   */ 
/*  option suppresses error messages and avoids setting SYSERR when the      */
/*  specified table is not found.                                            */
/*****************************************************************************/
proc casutil;
   droptable casdata="tableName" incaslib="sourceCaslib" quiet;
run;

/*****************************************************************************/
/*  Delete the specified caslib (caslibName).  The SESSREF parameter is      */
/*  optional.  If SESSREF is not specified, the current session is used.     */
/*****************************************************************************/
caslib caslibName drop sessref=mySession;





