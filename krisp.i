%module "KRISP"
%{
%}

%include "cpointer.i"
%pointer_functions (int, intp);

extern char dberr[1024];

extern char * krisp_version_pl (void);
extern char * krisp_uversion_pl (void);
extern char * krisp_error_pl (void);
extern int  * krisp_open_pl (char *);
extern char * krisp_search_pl (int *, char *);
extern void krisp_close_pl (int *);

