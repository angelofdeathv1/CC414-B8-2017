variable rc refcursor;
exec foxtest2.paquete1.insertarmusico('David Gonzalez', '21/APR/1995', :rc);
print rc;

variable rc refcursor;
exec foxtest2.paquete2.createconcert('28/AUG/1995', :rc)
print rc;

variable rc refcursor;
exec foxtest2.paquete3.createband('Fuckin Banda', '21/APR/2017', :rc);
print rc;

variable rc refcursor;
exec foxtest2.paquete4.createtour(:rc);
print rc;



