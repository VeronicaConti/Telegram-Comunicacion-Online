program telegram;

Uses sysutils;

type
    PuntArbol = ^TipoArbol;
    TipoArbol = Record
            	Nombre: String;
            	Password: String;
            	Men,May: PuntArbol;
                End;
            
    PuntListaM = ^TipoListaM;
    TipoListaM = Record
            	FechaHora: String; 
            	Texto: String;
            	Usuario:PuntArbol;
            	Leido: Boolean;
            	SigMSJ: PuntListaM;
                End;
            
    PuntListaC = ^TipoListaC;
    TipoListaC = Record
            	Codigo: Integer;
                UsuarioX:PuntArbol;
            	UsuarioY:PuntArbol;
            	Msj:PuntListaM;
            	SigC:PuntListaC;
                End;
                
    PuntListaUH= ^TipoListaUH;
    TipoListaUH = Record
            	nombre: String; 
            	cant_conversaciones:integer;
            	SigUsuario:PuntListaUH;
                End;
                
    TipoArchUsuarios = Record
                	Nombre: String;
                	Password: String;
                    End;
                    
    ArchU = File of TipoArchUsuarios;
    
    TipoArchConversaciones = Record
                        	UsuarioX:String;
                        	UsuarioY:String;
                            End;
                            
    ArchC = File of TipoArchConversaciones;
    
    TipoArchMensajes = Record
                    Codigo:Integer;
                    FechaHora:String;
                    Mensaje:String;
                    Usuario:String;
                    Leido:Boolean;
                    End;
                    
    ArchM = File of TipoArchMensajes;
    
//-------------------------------------------------------MODULOS DE CARGA DEl ARBOL DE USUARIOS----------------------------------------------------

procedure AbrirArchivo(var ArchUsuarios:ArchU); 
begin
    {$I-}
    reset(ArchUsuarios);
    {$I+}
    if (ioresult<>0) then
        rewrite(ArchUsuarios);
end;
procedure CrearNodoArbol(var nodo:PuntArbol;nombre,password:string);
//crea el nodo con los datos del archivo
begin
    new(nodo);
    nodo^.nombre:=nombre;
    nodo^.password:=password;
    nodo^.men:=nil;
    nodo^.may:=nil;
end;
procedure InsertarNodoArbol(var ArbUsuarios:PuntArbol;nodo:PuntArbol);
//inserta el nodo ordenado ascendente por nombre
Begin
    if (ArbUsuarios = NIL) then begin
        ArbUsuarios:=nodo;
    end
    else 
    if (ArbUsuarios^.nombre > nodo^.nombre) then
        InsertarNodoArbol(ArbUsuarios^.men, nodo) 
    else
        InsertarNodoArbol(ArbUsuarios^.may, nodo);
end;
procedure CargarArbol(var ArbUsuarios:PuntArbol;var ArchUsuarios:ArchU);
//carga el arbol con los datos del archivo de usuarios
var
    nodo:PuntArbol;
    datos:TipoArchUsuarios;
begin
    AbrirArchivo(ArchUsuarios);
    reset(ArchUsuarios);
    while not (eof(ArchUsuarios)) do begin
        read(ArchUsuarios,datos);
        CrearNodoArbol(nodo,datos.nombre, datos.password);
        InsertarNodoArbol(ArbUsuarios,nodo);
    end;
end;

//--------------------------------------------------MODULOS DE CARGA DE LA LISTA CONVERSACIONES--------------------------------------------------

function UsuarioBuscado(ArbUsuarios:PuntArbol; usuarioX:string):PuntArbol;
//devuelve el puntero al usuario en el arbol
begin
    if (ArbUsuarios = nil) or (ArbUsuarios^.nombre = usuarioX) then
        UsuarioBuscado:= ArbUsuarios
    else
    if (ArbUsuarios^.nombre < usuarioX) then
         UsuarioBuscado:= UsuarioBuscado(ArbUsuarios^.may,usuarioX)
    else
    if (ArbUsuarios^.nombre > usuarioX) then
        UsuarioBuscado:= UsuarioBuscado(ArbUsuarios^.men,usuarioX);
end;

procedure AbrirArchivo(var ArchConversaciones:ArchC); 
begin
    {$I-}
    reset(ArchConversaciones);
    {$I+}
    if (ioresult<>0) then
        rewrite(ArchConversaciones);
end;
Procedure CrearNodoListaC( var nodo:PuntListaC ;ArbUsuarios:PuntArbol;UsuarioX,UsuarioY:string; var codigo:integer);
//crea nodo con los datos del archivo 
Begin
    new(nodo);
    nodo^.codigo:=codigo;
    nodo^.usuarioX:= UsuarioBuscado(ArbUsuarios,usuarioX);
    nodo^.usuarioY:= UsuarioBuscado(ArbUsuarios,usuarioY);
    nodo^.MSJ:=nil;
    nodo^.SigC:=nil;
end;
procedure InsertarNodoListaC(var ListaConvers:PuntListaC; nodo:PuntListaC);
//inserta el nodo en la lista de conversaciones ordenado ascedente por codigo
begin
    if (ListaConvers = nil) or (ListaConvers^.codigo > nodo^.codigo) then begin
        nodo^.SigC:=ListaConvers;
        ListaConvers:=nodo;
    end
    else
        InsertarNodoListaC(ListaConvers^.SigC,nodo);
end;
procedure CargarListaConvers(var ListaConvers:PuntListaC; var ArchConversaciones:ArchC; ArbUsuarios:PuntArbol);
//Carga la lista de conversaciones con los datos del archivo conversaciones
var
    nodo:PuntListaC;
    datos:TipoArchConversaciones;
    codigo:integer;
begin
    codigo:=0;
    AbrirArchivo(ArchConversaciones);
    reset(ArchConversaciones);
     while not (eof(ArchConversaciones)) do begin
        read(ArchConversaciones,datos);
        codigo:= codigo + 1;
        CrearNodoListaC(nodo,ArbUsuarios,datos.usuarioX,datos.usuarioY,codigo);
        InsertarNodoListaC(ListaConvers,nodo);
    end;
end;

//-----------------------------------------------MODULOS DE CARGA DE LISTA MENSAJES------------------------------------------------------

function ConversacionBuscada(ListaConvers:PuntListaC; codigo:integer):PuntListaC;
//Busca con el codigo la conversacion en la lista de conversaciones
begin
    if (ListaConvers = nil) or (ListaConvers^.codigo = codigo) then
             ConversacionBuscada:=ListaConvers
        else
             ConversacionBuscada:=ConversacionBuscada(ListaConvers^.sigC,codigo);
end;

procedure AbrirArchivo(var ArchMensajes:ArchM); 
begin
    {$I-}
    reset(ArchMensajes);
    {$I+}
    if (ioresult<>0) then
        rewrite(ArchMensajes);
end;

procedure CrearNodoListaM(var nuevo:PuntListaM;FechaHora,Mensaje,Usuario:string;leido:boolean; ArbUsuarios:PuntArbol);
//crea el nodo de la lista Mensajes con los datos que estan en el archivo y se busca el usuario en el arbol
begin
    new(nuevo);
    nuevo^.FechaHora:=FechaHora; 
    nuevo^.Texto:=Mensaje;
    nuevo^.Usuario:=UsuarioBuscado(ArbUsuarios,usuario);
    nuevo^.Leido:=leido;
    nuevo^.SigMSJ:=nil;
end;
procedure  InsertarNodoListaM (var nuevo:PuntListaM; Msj:PuntListaM);
//inserta el nodo a la lista de mensajes al final
begin
    if (Msj = nil) then begin
        nuevo^.SigMsj:=Msj;
        Msj:=nuevo;
    end
    else
        InsertarNodoListaM(nuevo,MSJ^.SigMSJ);
end;
procedure CargarListaMensajes(ListaConvers:PuntListaC; var ArchMensajes:ArchM; ArbUsuarios:PuntArbol);
//carga la lista de mensajes con el archivo de mensajes
var
    datos:TipoArchMensajes;
    codigo:PuntListaC;
begin
    AbrirArchivo(ArchMensajes);
    reset(ArchMensajes);
    While not (eof(ArchMensajes)) do begin
        read(ArchMensajes,datos);
        Codigo:=ConversacionBuscada(ListaConvers,datos.codigo);
        CrearNodoListaM(Codigo^.MSJ,datos.FechaHora,datos.Mensaje,datos.Usuario,datos.leido,ArbUsuarios);
        InsertarNodoListaM(ListaConvers^.MSJ,Codigo^.MSJ);
    end;
end;
        
procedure  CargarEstructuras(var ArbUsuarios:PuntArbol; var ListaConvers:PuntListaC;var ArchUsuarios:ArchU;var ArchConversaciones:ArchC;var ArchMensajes: ArchM);
//carga el arbol y las listas con la informacion de los archivos correspondientes
begin
    CargarArbol(ArbUsuarios,ArchUsuarios);
    CargarListaConvers(ListaConvers,ArchConversaciones,ArbUsuarios);
    CargarListaMensajes(ListaConvers,ArchMensajes,ArbUsuarios);
end;

//-----------------------------------------------------MODULOS DEL MENU USUARIOS NIVEL 2-------------------------------------------------------------------------------

function CantConversaciones(nombre:string;ListaConvers:PuntListaC):integer; 
// devuelve la cantidad de conversaciones del usuario
begin
    if (ListaConvers = nil) then 
        CantConversaciones:=0
    else
    if (ListaConvers^.usuarioX^.Nombre = nombre) or (ListaConvers^.usuarioY^.Nombre = nombre)  then 
        CantConversaciones:= CantConversaciones(nombre,ListaConvers^.sigC)+1
    else
        CantConversaciones:=CantConversaciones(nombre,ListaConvers^.sigC);
end;

function SumaMsjNoLeidos(MSJ:PuntListaM; nombre:string):integer; 
//devuelve la cantidad de mensajes no leidos, por conversacion, enviados por el otro usuario
begin
    if (MSJ = nil) then
        SumaMsjNoLeidos:=0
    else
    if (MSJ^.leido = false) and (MSJ^.Usuario^.nombre <> nombre)  then
        SumaMsjNoLeidos:=SumaMsjNoLeidos(MSJ^.sigMSJ,nombre)+1
    else
        SumaMsjNoLeidos:=SumaMsjNoLeidos(MSJ^.sigMSJ,nombre);
end;

function CantMsjNoleidos(ListaConvers:PuntListaC;nombre:string):integer;
//devuelve la cantidad total por usuario de mensajes no leidos, enviados por el otro usuario
var
    suma:integer;
begin
    suma:=0;
    if (ListaConvers <> nil) then begin
        if (ListaConvers^.usuarioX^.Nombre = nombre) or (ListaConvers^.usuarioY^.Nombre = nombre)  then begin
            suma:= suma+ CantMsjNoleidos(ListaConvers^.sigC,nombre) + SumaMsjNoLeidos(ListaConvers^.MSJ,nombre);
        end
        else
            suma:= suma+ CantMsjNoleidos(ListaConvers^.sigC,nombre);
    end;
    CantMsjNoleidos:=suma;
end;

procedure MostrarUsuario(nombre:string;cant,cant_noleidos:integer);
//imprime por pantalla los datos del usuario logueado
begin
    writeln('el nombre de usuario es:');
    writeln(nombre);
    writeln('la cantidad de mensajes:');
    writeln(cant);
    writeln('la cantidad de mensajes no leidos:');
    writeln(cant_noleidos);
end;

procedure MostrarUsuarioLogueado(nombre:string; ListaConvers:PuntListaC);
//muestra los datos del usuario logueado, la cantidad de conversaciones en las que participa y la cantidad de mensajes no leidos
var
    cant_noleidos,cant:integer;
    
begin
    cant:=CantConversaciones(nombre,ListaConvers);
    cant_noleidos:=CantMsjNoleidos(ListaConvers,nombre);
    MostrarUsuario(nombre,cant,cant_noleidos);
end;

procedure ListarConversActivas(ListaConvers:PuntListaC;nombre:string);
//imprime las conversaciones del usuario que tienen MSJ no leidos y la cantidad de msj no leidos
var
    cantidad:integer;
begin
    if (ListaConvers <> nil) then begin
        if (ListaConvers^.usuarioX^.Nombre = nombre) then begin
            writeln(ListaConvers^.usuarioY^.Nombre);
            writeln(ListaConvers^.codigo);
            cantidad:=SumaMsjNoLeidos(ListaConvers^.MSJ,nombre); 
            writeln(cantidad);  
            ListarConversActivas(ListaConvers^.sigC,nombre);
        end
        else
        if (ListaConvers^.usuarioY^.Nombre = nombre) then begin
            writeln(ListaConvers^.usuarioX^.Nombre);
            writeln(ListaConvers^.codigo);
            cantidad:=SumaMsjNoLeidos(ListaConvers^.MSJ,nombre);
            writeln(cantidad);
            ListarConversActivas(ListaConvers^.sigC,nombre);
        end
        else
            ListarConversActivas(ListaConvers^.sigC,nombre);
        end
end;

procedure ListarTodasConvers(ListaConvers:PuntListaC;nombre:string);
//muestra todas las conversaciones en las que participa y participo el usuario
begin
    if (ListaConvers <> nil) then begin
        if (ListaConvers^.usuarioX^.Nombre = nombre) then begin
            writeln(ListaConvers^.usuarioY^.Nombre);
            writeln(ListaConvers^.codigo);
            ListarTodasConvers(ListaConvers^.sigC,nombre);
        end
        else
        if (ListaConvers^.usuarioY^.Nombre = nombre) then begin
            writeln(ListaConvers^.usuarioX^.Nombre);
            writeln(ListaConvers^.codigo);
            ListarTodasConvers(ListaConvers^.sigC,nombre);
        end
        else
            ListarTodasConvers(ListaConvers^.sigC,nombre);
    end;
end;

procedure Mostrar(MSJ:PuntListaM);
//imprime los mensajes y si fueron leidos o no
begin
    writeln(MSJ^.FechaHora);
    writeln(MSJ^.usuario^.Nombre);
    writeln(MSJ^.Texto);
    if (MSJ^.leido = false) then 
        writeln('el mensaje NO fue leido')
    else
        writeln('el mensaje SI fue leido');
end;

procedure  Modificar(var MSJ:PuntListaM; nombre:string);
begin
    if (MSJ^.usuario^.nombre <> nombre ) and (MSJ^.leido = false) then
        MSJ^.leido:=true;
end;

procedure MostrarModificarMensajes( MSJ:PuntListaM; nombre:string);
//Muestra los ultimos 10 mensajes no leidos, si son menos de 10 completa con los leidos
//y si fueron enviados por el otro usuario, no el logueado, se modifica el estado no leido a leido
var
    cant:integer;
begin
    cant:=0;
    if (MSJ <> nil) then begin
        if (cant < 10)  then begin
            cant:=cant+1;
            Mostrar(MSJ);
            Modificar(MSJ,nombre);
            MSJ:=MSJ^.sigMSJ;
        end;
    end;
end;
        
procedure VerUltmosMsj( ListaConvers:PuntListaC; nombre:string);
//muestra con el codigo de la conversacion los ultimos 10 msj no leidos y se modifican como leidos si los escribio el otro usuario
var
    codigo:integer;
    conversacion:PuntListaC;
begin
    writeln('ingrese el codigo de la conversacion:');
    readln(codigo);
    conversacion:=ConversacionBuscada(ListaConvers,codigo);
    if (conversacion <> nil) then 
        MostrarModificarMensajes(conversacion^.MSJ,nombre);
end;

procedure MostrarTodosMensajes(MSJ:PuntListaM);
// imprime todos los mensajes de cierta conversacion y si fue o no leido
begin
    if (MSJ <> nil) then begin
        writeln(MSJ^.FechaHora);
        writeln(MSJ^.usuario^.Nombre);
        writeln(MSJ^.Texto);
    if (MSJ^.leido = false) then 
        writeln('el mensaje NO fue leido')
    else
        writeln('el mensaje fue leido');
    end;
     MSJ:=MSJ^.sigMSJ;
end;

procedure VerConversaciones( ListaConvers:PuntListaC; nombre:string);
//con el codigo de la conversacion, se muestra todos los mensajes y modifica a leidos los que fueron escritos por el otro usuario
var
    codigo:integer;
    conversacion:PuntListaC;
begin
    writeln('ingrese el codigo de la conversacion:');
    readln(codigo);
    conversacion:=ConversacionBuscada(ListaConvers,codigo);
    if (conversacion <> nil)  then begin
        MostrarTodosMensajes(conversacion^.MSJ);
        Modificar(conversacion^.MSJ,nombre);
    end;
end;

procedure MostrarCincoMsj(MSJ:PuntListaM);
//muestra los ultimos 5 mensajes de la conversacion
var
    cant:integer;
begin
    cant:=0;
    if (MSJ <> nil) then
    if (cant < 5 ) then begin
        Mostrar(MSJ);
        cant:=cant+1;
        MSJ:= MSJ^.sigMSJ;
    end;
end;

procedure Contestar(var MSJ:PuntListaM; nombre:string; ArbUsuarios:PuntArbol; ListaConvers:PuntListaC);
//crea el nodo con el mensaje, la hora la da el sistema y se marca como NO leido, el usuario ingresa solo el texto
var
    mensaje,FechaHora:string;
    leido:boolean;
begin
    leido:=false;
    writeln('ingrese un nuevo msj:');
    readln(mensaje);
    FechaHora:= DateTimeToStr(Now);
    CrearNodoListaM(MSJ,FechaHora,Mensaje,nombre,leido,ArbUsuarios);
    InsertarNodoListaM(MSJ,ListaConvers^.MSJ);
end;

procedure ContestarMsj(ListaConvers:PuntListaC; nombre:string; ArbUsuarios:PuntArbol);
//con el codigo de conversacion que ingresa el usuario muestra los ultimos 5 msj y contesta el msj
var
    codigo:integer;
    conversacion:PuntListaC;
begin
    writeln('ingrese el codigo de la conversacion:');
    readln(codigo);
    conversacion:=ConversacionBuscada(ListaConvers,codigo);
     if (conversacion <> nil) then begin
        MostrarCincoMsj(conversacion^.MSJ);
        Contestar(conversacion^.MSJ,nombre,ArbUsuarios,ListaConvers);
    end;
end;

function CodigoMayor(ListaConvers:PuntListaC):integer; //funcion que devuelve el valor del ultimo codigo, el mayor de la listaConvers, iterativa
//devuelve el codigo mayor de la listaCovers, para sumarle  1 e insertar la nueva conversacion ordenada
var
    mayor,valor:integer;
    cursor:PuntListaC;
begin
    cursor:=ListaConvers;
    mayor:=0;
    while (cursor<>nil) do begin
        valor:=cursor^.codigo;
        cursor:=cursor^.sigC;
    if (mayor < valor) then 
        mayor:=valor;
    end;
        CodigoMayor:=mayor;
end;

procedure CrearNuevaConvers(ArbUsuarios:PuntArbol; var ListaConvers:PuntListaC; nombre:string);
// modulo que pide un usuario y si existe en el arbUsuarios crea una nueva conversacion en la listaConvers, con el ultimo codigo + 1
var
    usuario:string;
    nuevou:PuntArbol;
    nodo:PuntListaC;
    codigo:integer;
begin
    codigo:=0;
    writeln('ingrese el nombre del otro usuario:');
    readln(usuario);
    nuevou:=UsuarioBuscado(ArbUsuarios,usuario);
    if (nuevou <> nil) then begin
        codigo:=CodigoMayor(ListaConvers)+1;
        CrearNodoListaC(nodo,ArbUsuarios,nombre,usuario,codigo);
        InsertarNodoListaC(ListaConvers,nodo);
    end;
end;

procedure BorrarMsj (var MSJ:PuntListaM);
begin
    if (MSJ <> nil) then begin
        BorrarMsj (MSJ^.SigMSJ);
        dispose(MSJ);
        MSJ:=nil;
    end;
end;

procedure EliminarListaMsj(ListaConvers:PuntListaC; nombre:string);
//elimina las listas de todos los mensajes que participo el usuario 
begin
    if (ListaConvers <> nil) then begin
        if (ListaConvers^.usuarioX^.Nombre = nombre) or (ListaConvers^.usuarioY^.Nombre = nombre)  then begin
            BorrarMsj(ListaConvers^.MSJ);
            ListaConvers:=ListaConvers^.sigC;
        end
        else
            ListaConvers:=ListaConvers^.sigC;
    end;
end;

procedure BorrarConvers (var ListaConvers:PuntListaC);
begin
    if (ListaConvers <> nil) then 
        BorrarConvers (ListaConvers^.sigC);
        dispose(ListaConvers);
end;
procedure EliminarConvers( var ListaConvers:PuntListaC; nombre:string);
//elimina la lista de conversaciones
begin
    if (ListaConvers <> nil) then begin
    if (ListaConvers^.usuarioX^.Nombre = nombre) or (ListaConvers^.usuarioY^.Nombre = nombre)  then begin
        BorrarConvers(ListaConvers);
        ListaConvers:=ListaConvers^.sigC;
    end
    else
        ListaConvers:=ListaConvers^.sigC;
    end;
end;

Function Minimo(ArbUsuarios:PuntArbol):PuntArbol;
begin
    if (ArbUsuarios <> nil) then 
    if (ArbUsuarios^.men = nil) then
        Minimo:=ArbUsuarios
    else
        Minimo:=Minimo(ArbUsuarios^.men);
end;

procedure Reemplazar(var ArbUsuarios:PuntArbol; puntero:PuntArbol);
var
    aeliminar:PuntArbol;
begin
    aeliminar:=ArbUsuarios;
    ArbUsuarios:=puntero;
    dispose(aeliminar);
    aeliminar:=nil;
end;

procedure EliminarNodo(var ArbUsuarios:PuntArbol);
//elimina al nodo y lo reemplaza por el menor si es la raiz
var
    aux,menor:PuntArbol;
begin
    if (ArbUsuarios^.men <> nil) and (ArbUsuarios^.may <> nil) then begin
        aux:=ArbUsuarios;
        menor:= Minimo (ArbUsuarios^.may);
        ArbUsuarios^.nombre:=menor^.nombre;
        ArbUsuarios^.men:=aux^.men;
        ArbUsuarios^.may:=aux^.may;
    end
    else
    if (ArbUsuarios^.men <> nil) then
        Reemplazar(ArbUsuarios,ArbUsuarios^.men)
    else
    if (ArbUsuarios^.may <> nil) then
        Reemplazar(ArbUsuarios,ArbUsuarios^.may)
    else
        Reemplazar(ArbUsuarios,nil);
end;

Procedure EliminarUsuario(var ArbUsuarios:PuntArbol; nombre:string);
//elimina al usuario del arbUsuarios
begin
    if (ArbUsuarios <> nil) then 
    if (ArbUsuarios^.Nombre > nombre) then
        EliminarUsuario(ArbUsuarios^.men,nombre)
    else
    if (ArbUsuarios^.Nombre < nombre) then
        EliminarUsuario(ArbUsuarios^.may,nombre)
    else
        EliminarNodo(ArbUsuarios);
end;

procedure BorrarUsuario(var ArbUsuarios:PuntArbol; var ListaConvers:PuntListaC; nombre:string; var opcion:integer);
//modulo que elimina al usuario logueado, conversaciones y mensajes, si NO tiene mensajes sin leer, sino NO lo borra
var
    cant_noleidos:integer;
    usuario:PuntArbol;
begin
    cant_noleidos:=CantMsjNoleidos(ListaConvers,nombre);
    if (cant_noleidos = 0) then begin
        EliminarListaMsj(ListaConvers,nombre); 
        EliminarConvers(ListaConvers,nombre);
        ListaConvers:=nil;
        EliminarUsuario(ArbUsuarios,nombre);
        ArbUsuarios:=nil;
    end
    else
    if (cant_noleidos <> 0 ) then begin
        writeln('el usuario tiene mensajes sin leer');
    end;
        usuario:=UsuarioBuscado(ArbUsuarios,nombre);
    if (usuario = nil) then
        opcion:=8;
end;
    
procedure OpcionesMenuUsuario;
//writeln de las opciones del menu 2
begin
    writeln('Ingresa la opcion: ');
    writeln('1-Listado de conversaciones activas');
    writeln('2-Listado de todas las conversaciones ');
    writeln('3-Ver ultimos mensajes de conversacion'); 
    writeln('4-Ver conversacion');
    writeln('5-Contestar mensaje');
    writeln('6-Crear una nueva conversacion');
    writeln('7-Borrar Usuario');
    writeln('8-Logout/salir');
end;

procedure MenuUsuario(var ArbUsuarios:PuntArbol; var ListaConvers:PuntListaC; nombre:string);
//Menu para usuarios nivel 2
var
    opcion:integer;
begin
    MostrarUsuarioLogueado(nombre,ListaConvers); 
    OpcionesMenuUsuario;
    readln(opcion);
    while (opcion < 8) do begin
    case (opcion) of 
        1:ListarConversActivas(ListaConvers,nombre);
        2:ListarTodasConvers(ListaConvers,nombre);  
        3:VerUltmosMsj(ListaConvers,nombre);
        4:VerConversaciones(ListaConvers,nombre); 
        5:ContestarMsj(ListaConvers,nombre,ArbUsuarios);
        6:CrearNuevaConvers(ArbUsuarios,ListaConvers,nombre); 
        7:BorrarUsuario(ArbUsuarios,ListaConvers,nombre,opcion); 
    end;
        OpcionesMenuUsuario;
        readln(opcion);
    end;
end;

//---------------------------------------------------------MODULOS DEL MENU DE INICIO ----------------------------------------------------------------------------------

procedure Login(var ArbUsuarios:PuntArbol; var ListaConvers:PuntListaC); 
//pide nombre de usuario y contraseña y los busca en el arbol, si existen pasan al menu para usuarios nivel 2
var
    nombre,contrasenia:string;
    usuario:PuntArbol;
begin
    writeln('Ingresa el nombre de usuario: ');
    readln(nombre);
    writeln('Ingresa la contrasenia: ');
    readln(contrasenia);
    usuario:=UsuarioBuscado(ArbUsuarios,nombre);
    if (usuario <> nil ) and (usuario^.password = contrasenia) then
        MenuUsuario(ArbUsuarios,ListaConvers,usuario^.nombre);
end;
procedure NuevoUsuario(var ArbUsuarios:PuntArbol);
//pide nombre y si NO existe en el arbUsuarios crea al usuario 
var
    nombre, contra:string;
    usuario,nodo:PuntArbol;
begin
    writeln('Ingresa el nombre del nuevo usuario: ');
    readln(nombre);
    usuario:=UsuarioBuscado(ArbUsuarios,nombre);
    if (usuario = nil) then begin
        writeln('Ingresa la contrasenia: ');
        readln(contra);
        CrearNodoArbol(nodo,nombre,contra);
        InsertarNodoArbol(ArbUsuarios,nodo);
    end
    else
        writeln('el usuario ya esta registrado: ');
end;

procedure CrearNodoListaUH(var nodo:PuntListaUH; nombre:string; ListaConvers:PuntListaC);
//crea el nodo de la lista uh con el nombre del arbUsuarios y la cant de conversaciones por usuario
begin
    new(nodo);
    nodo^.nombre:=nombre; 
    nodo^.cant_conversaciones:=CantConversaciones(nombre,ListaConvers);
    nodo^.SigUsuario:=nil;
end;
procedure InsertarNodoListaUH(var ListaUH:PuntListaUH; nodo:PuntListaUH);
// inserta el nodo en la lista uh ordenado ascendente por cantidad de conversaciones por usuario
begin
    if (ListaUH= nil) or (ListaUH^.cant_conversaciones >= nodo^.cant_conversaciones) then begin
            nodo^.SigUsuario:=ListaUH;
            ListaUH:=nodo;
        end
        else
            InsertarNodoListaUH(ListaUH^.SigUsuario,nodo);
end;
procedure  CrearListaUH (var ListaUH:PuntListaUH; ArbUsuarios:PuntArbol;ListaConvers:PuntListaC);
//crea la lista uh 
var
    nodo:PuntListaUH;
begin
    if (ArbUsuarios <> nil) then begin
        CrearNodoListaUH(nodo, ArbUsuarios^.nombre, ListaConvers);
        InsertarNodoListaUH(ListaUH,nodo);
        CrearListaUH(ListaUH,ArbUsuarios^.men,ListaConvers);
        CrearListaUH(ListaUH,ArbUsuarios^.may,ListaConvers);
    end;
end;
procedure ImprimirListaUH(ListaUH:PuntListaUH);
//muestra por pantalla la lista uh 
begin
    if (ListaUH <> Nil) then begin
        writeln(ListaUH^.nombre, ' ');
        writeln(ListaUH^.cant_conversaciones, ' ');
        ImprimirListaUH(ListaUH^.SigUsuario);
    end;
end;

procedure EliminarListaUH(var ListaUH:PuntListaUH);
//elimina los nodos de la lista uh
begin
    if (ListaUH <> nil) then begin
        EliminarListaUH(ListaUH^.SigUsuario);
        dispose(ListaUH);
    end;
end;

procedure VerUsuariosHiperconectados(ArbUsuarios:PuntArbol;ListaConvers:PuntListaC);
//muestra los usuarios conectados, se crea una lista de usuarios hiperconectados
//se muestra por pantalla y al salir se elimina la lista
var
    ListaUH:PuntListaUH;
begin
    ListaUH:=nil;
    CrearListaUH(ListaUH,ArbUsuarios,ListaConvers);
    ImprimirListaUH(ListaUH);
    EliminarListaUH(ListaUH);
    ListaUH:=nil;
end;

procedure OpcionesMenu;
//writeln de las opciones del menu 1
begin
    writeln('Ingresa la opcion: ');
    writeln('1-Login');
    writeln('2-Nuevo Usuario ');
    writeln('3-Ver usuarios conectados');
    writeln('4-salir');
end;

procedure MenuInicial(var ArbUsuarios:PuntArbol; var ListaConvers:PuntListaC);
//menu nivel 1 por el cual se pasa al menu nivel 2 luego de login
var
     opcion:integer;
begin
    OpcionesMenu;
    readln(opcion);
    while (opcion < 4) do begin
    case (opcion) of 
        1:Login(ArbUsuarios,ListaConvers);
        2:NuevoUsuario(ArbUsuarios);
        3:VerUsuariosHiperconectados(ArbUsuarios,ListaConvers);
    end;
        OpcionesMenu;
        readln(opcion);
    end;
end;

//-------------------------------------------------------------- MODULOS DE CARGA DE ARCHIVOS -------------------------------------------------------------------

procedure GuardarArchUsuarios(ArbUsuarios:PuntArbol; var ArchUsuarios:ArchU);
var
    datos:TipoArchUsuarios;
begin
    rewrite(ArchUsuarios);
    if (ArbUsuarios <> nil) then begin
        datos.nombre:= ArbUsuarios^.nombre;
        datos.password:=ArbUsuarios^.password;
        write(ArchUsuarios,datos);
        ArbUsuarios:= ArbUsuarios^.men;
        ArbUsuarios:=ArbUsuarios^.may;
    end;
end;

procedure GuardarArchConvers(ListaConvers:PuntListaC; var ArchConversaciones:ArchC);
var
    datos:TipoArchConversaciones;
begin
    rewrite(ArchConversaciones);
    if (ListaConvers <> nil) then begin
        datos.UsuarioX:=ListaConvers^.UsuarioX^.nombre;
        datos.UsuarioY:=ListaConvers^.UsuarioY^.nombre;
        write(ArchConversaciones,datos);
        ListaConvers:=ListaConvers^.sigC;
    end;
end;
procedure GuardarMsj(MSJ:PuntListaM ; var datos:TipoArchMensajes);
begin
    if (MSJ <> nil) then begin
        datos.FechaHora:=MSJ^.FechaHora;
        datos.mensaje:=MSJ^.Texto;
        datos.usuario:=MSJ^.usuario^.nombre;
        datos.leido:=MSJ^.leido;
        MSJ:=MSJ^.sigMSJ;
    end;
end;

procedure GuardarArchMsj(ListaConvers:PuntListaC; var ArchMensajes: ArchM);
var
    datos:TipoArchMensajes;
    conversacion:PuntListaC;
begin
    rewrite(ArchMensajes);
    if (ListaConvers <> nil) then begin
        datos.codigo:= ListaConvers^.codigo;
        conversacion:=ConversacionBuscada(ListaConvers,datos.codigo);
    if (conversacion <> nil ) then begin
        GuardarMsj(conversacion^.Msj,datos);
        write(ArchMensajes,datos);
        ListaConvers:=ListaConvers^.sigC;
    end
    else
        ListaConvers:=ListaConvers^.sigC;
    end;
end;
    
procedure GuardarEnArchivos(ArbUsuarios:PuntArbol;ListaConvers:PuntListaC;var ArchUsuarios:ArchU;var ArchConversaciones:ArchC;var ArchMensajes: ArchM);
//se pasa toda la informacion de el arbol y las listas a cada archivo al salir del menu y antes de finalizar el programa
begin
    GuardarArchUsuarios(ArbUsuarios,ArchUsuarios);
    GuardarArchConvers(ListaConvers,ArchConversaciones);
    GuardarArchMsj(ListaConvers,ArchMensajes);
end;

//----------------------------------------------------------------- PROGRAMA PRINCIPAL--------------------------------------------------------------------------- 

var
    ArbUsuarios:PuntArbol;
    ListaConvers:PuntListaC;
    ArchUsuarios:ArchU;
    ArchConversaciones:ArchC;
    ArchMensajes:ArchM;
    
begin
    ArbUsuarios:=nil;
    ListaConvers:=nil;
    assign(ArchUsuarios,'/work/vconti_ArchUsuarios.dat');
    assign(ArchConversaciones,'/work/vconti_ArchConversaciones.dat');
    assign(ArchMensajes,'/work/vconti_ArchMensajes.dat');
    CargarEstructuras(ArbUsuarios,ListaConvers,ArchUsuarios,ArchConversaciones,ArchMensajes);
    MenuInicial(ArbUsuarios,ListaConvers);
    GuardarEnArchivos(ArbUsuarios,ListaConvers,ArchUsuarios,ArchConversaciones,ArchMensajes);
    close(ArchUsuarios);
    close(ArchConversaciones);
    close(ArchMensajes);
end.