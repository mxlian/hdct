Program Proyecto_CT;



uses crt, dos;



const
  cf  = White;      {color del fondo}
  cl  = Black;      {color de la letra}
  cfs = Blue ;      {color del fondo seleccionado}
  cls = Yellow;     {color de la letra seleccionada}
  CANT_TOTAL = 1000;{cantidad de sectores maxima}


var
  nom: array[1..5] of string; {textos a imprimir de las opciones}
  i: integer;                 {repeticion para manejar el array anterior}
  opc: integer;               {opcion seleccionada al momento}
  a: char;                    {valor ASCII de la tecla presionada}
  CANT_OPC: integer;          {cantidad de opciones a desplegar}

  SEC: array [0..CANT_TOTAL] of integer;  {GLOBAL!! guarda los sectores a visitar}
  C_SEC: integer;                         {GLOBAL!! guarda cuantos sectores se visitan}

  {valores globales son como constantes que seran inicializados desde afuera}
  VALOR_MAX: integer;  {valor maximo de "simulacion" de sector}
  DISCO, DIRRAM, SECTORES: String; {BORRAME}
  BYTES_MAX: longint;
  VER_DEBUG: boolean;
  MAX_CILINDRO: integer;



{-----------------------------------
crea la secuencia manual
------------------------------------}
procedure Sec_man;
var
  i:integer;
  lee: integer;
begin
  ClrScr;

  WriteLn('Ingrese la cantidad de sectores que desea a ingresar');
  WriteLn('(El maximo es ',CANT_TOTAL,'): ');
  ReadLn(C_SEC);
  while ( ( C_SEC > CANT_TOTAL ) or ( C_SEC < 1 ) )do
  begin
    WriteLn('ERROR de desborde, el numero debe estar en el rango [1,', CANT_TOTAL, ']');
    Write('Ingrese nuevamente: ');
    ReadLn(C_SEC);
  end;

  WriteLn;
  WriteLn('Ingrese los numeros de bloque en forma secuencial');
  WriteLn('(entre 1 y VALOR_MAX)');

  for i := 1 to C_SEC do
  begin
    Write('Ingrese el ',i+1,'o numero de bloque (1-',VALOR_MAX,'): ');
    ReadLn(Sec[i]);
    while ( ( Sec[i] > VALOR_MAX ) or ( sec[i] < 1 ) )do
    begin
      Write('ERROR de desborde, ingrese nuevamente el ',i+1,'o numero de bloque (1-',VALOR_MAX,'): ');
      ReadLn(Sec[i]);
    end;
  end;

  WriteLn('Secuencia manual completada satisfactoriamente');

  WriteLn; Write('Presione una tecla para volver al menu');
  repeat until KeyPressed; ReadKey;
  ClrScr;

end;



{-----------------------------------
crea la secuencia aleatoria
------------------------------------}
procedure Sec_ale;
var
  i:integer;
begin
  ClrScr;

  Write('Ingrese la cantidad de sectores que desea generar');
  WriteLn('(El maximo es ',CANT_TOTAL,'): ');
  ReadLn(C_SEC);
  while ( ( C_SEC > CANT_TOTAL ) or ( C_SEC < 1 ) )do
  begin
    WriteLn('ERROR de desborde, el numero debe estar en el rango [1,', CANT_TOTAL, ']');
    Write('Ingrese nuevamente: ');
    ReadLn(C_SEC);
  end;

  C_SEC := C_SEC-1;

  WriteLn('Creando la secuencia aleatoria...');

  for i:=0 to C_SEC do
    SEC[i]:= Random(VALOR_MAX);

  WriteLn('Secuencia aleatoria completada satisfactoriamente');

  WriteLn; Write('Presione una tecla para volver al menu');
  repeat until KeyPressed; ReadKey;
  ClrScr;

end;



{-----------------------------------
muestra la secuencia en pantalla
------------------------------------}
procedure Ver_sec;
var
  i:integer;
begin
  ClrScr;

  for i:=0 to C_SEC do
  begin
    Write(SEC[i],' ');
  end;

  WriteLn; Write('Presione una tecla para volver al menu');
  repeat until KeyPressed; ReadKey;
  ClrScr;

end;




{-----------------------------------
Submenu secuencia de bloques
------------------------------------}

procedure Secuencia;
var
  nom: array[1..4] of string; {textos a imprimir de las opciones}
  i: integer;                 {repeticion para manejar el array anterior}
  opc: integer;               {opcion seleccionada al momento}
  a: char;                    {valor ASCII de la tecla presionada}
  CANT_OPC: integer;

begin

  ClrScr;

{INICIO SUBMENU SECUENCIA  --------------------------------------------------}
  CANT_OPC := 4;     {cantidad de opciones a desplegar}

  {opcion y color predeterminados y se les dan los nombres a las opciones}
  opc := 1;
  nom[1] := 'Ver secuencia a ejecutar';
  nom[2] := 'Crear secuencia manualmente';
  nom[3] := 'Crear secuencia aleatoria';
  nom[4] := 'Volver al Menu Principal';

  {MENU -->> bucle que espera teclas a ser presionadas para hacer algo}
  a := chr(0);
  while (a <> chr(27)) do {mientras tecla sea distinta de Escape}
  begin

    {se fija que tecla fue presionada}
    case ord(a) of
      {arriba}
      80: if opc<CANT_OPC then opc:=opc+1 else opc:= 1;
      {abajo}
      72: if opc>1 then opc:=opc-1 else opc:= CANT_OPC;
      {se fija en que opcion esta cuando se presiona enter y llama al proc}
      13: case opc of
            1: begin Ver_Sec end;
            2: begin Sec_Man end;
            3: begin Sec_Ale end;
            4: begin ClrScr; exit; end;
          end;
    end;

    {imprime todo el menu}
    for i := 1 to CANT_OPC do
    begin

      {elige la opcion que debe marcarse con un distinto color de background}
      if i=opc then
      begin
        TextColor(cls);
        TextBackground(cfs);
      end
      else
      begin
        TextColor(cl);
        TextBackground(cf);
      end;

      {posiciona e imprime las opciones en su lugar}
      GotoXY(28,9+i);
      write(nom[i]);

    end;

    {imprime el nombre del programa y eso arriba de la pantalla}
    TextBackground(cfs);
    TextColor(cls);
    GotoXY(1,1); Write('                             SECUENCIA DE BLOQUES                               ');

    {imprime la ayuda de teclas al pie de la pantalla}
    TextColor(cl);
    TextBackground(cf);
    GotoXY(2,24);
    write('   presione abajo y arriba para moverse sobre el menu y enter para ejecutar ');

    {espera a presionar una tecla}
    a:=readkey;

  end;

  ClrScr;

{FIN SUBMENU SECUENCIA  --------------------------------------------------}

end;




{////////////////////////////////////
  funciones para la conversion
/////////////////////////////////////}
function IntToStr(num: integer): string ;
begin
  case num of
   0: IntToStr :='0';
   1: IntToStr :='1';
   2: IntToStr :='2';
   3: IntToStr :='3';
   4: IntToStr :='4';
   5: IntToStr :='5';
   6: IntToStr :='6';
   7: IntToStr :='7';
   8: IntToStr :='8';
   9: IntToStr :='9';
   10: IntToStr :='A';
   11: IntToStr :='B';
   12: IntToStr :='C';
   13: IntToStr :='D';
   14: IntToStr :='E';
   15: IntToStr :='F';
 end;

end;

function hex(num: longint): string;
begin
 if (num div 16 < 16) then
   hex := IntToStr(num div 16) + IntToStr(num mod 16)
 else
   hex:= hex(num div 16) + IntToStr(num mod 16);
end;

function StrToInt(S: String): Longint;
  function CharToInt(C:Char): integer;
  begin
    case C of
      '0': CharToInt := 0;
      '1': CharToInt := 1;
      '2': CharToInt := 2;
      '3': CharToInt := 3;
      '4': CharToInt := 4;
      '5': CharToInt := 5;
      '6': CharToInt := 6;
      '7': CharToInt := 7;
      '8': CharToInt := 8;
      '9': CharToInt := 9;
    end;
  end;

  function pot(base, exp: integer): longint;
  var i:integer;
      aux:longint;
  begin
    aux := 1;
    for i := 0 to exp-1 do
    begin
      aux := aux * base;
    end;
    pot := aux;
  end;

var i:integer;
    aux:longint;
begin
  aux:=0;
  i:=1;
  while i<=Length(S) do
  begin
    aux := aux + (pot(10,(Length(S)-i)))*CharToInt(S[i]);
    inc(i);
  end;
  StrToInt := aux;
end;

function StrToBool(S: string): boolean;
begin
  for i := 1 to Length(S) do
    S[i] := UpCase(S[i]);
  if  S = 'TRUE' then StrToBool := true
  else StrToBool := false;
end;


{--------------------------------------------------------------

*** ESTA ES LA PARTE MAS GROSA (LLAMADA A INTERRUPCION 13h) ***

--------------------------------------------------------------}


procedure SimulateSeekToCylinder2(Pos: word);
var
  Reg: Registers;
  Cilindro: Word;
  Temp: Byte;

begin
  {Saco el numero de cilindro por regla de tres}
  Cilindro := Round( pos * MAX_CILINDRO / VALOR_MAX );
  { meto el numero de cilindro en los registros}
  Reg.CX :=  Cilindro;
  Temp:=Reg.CL;
  Reg.CX:=(Reg.CX SHR 8) SHL 6; {Roto 8 para dejarlos en 0 al resto
                                dejando solo los 2 bits LSB del CH en
                                los 2 bits MSB del CL}
  Reg.CH:=Temp;
  Reg.AH := $0C;  { $0C Numero de Servicio de la interrupcion$13: Seek to Cylinder}
  Reg.DH := $01;  {head number}

  Reg.DL := $80;  {drive number ($80:first/$81:second)}

  Intr($13, Reg); {llamada}
  if ( VER_DEBUG ) and ( ( Reg.Flags and $01 ) = $01 ) then
  begin
    WriteLn('Seek cilindro: [',Cilindro, '] POS LOGICA [',pos,'] La interrupcion fallo, volcando registros...');
    WriteLn('AX =0x ', hex(Reg.AX));
    WriteLn('BX =0x ', hex(Reg.BX));
    WriteLn('CX =0x ', hex(Reg.CX));
    WriteLn('DX =0x ', hex(Reg.DX));
    WriteLn('BP =0x ', hex(Reg.BP));
    WriteLn('SI =0x ', hex(Reg.SI));
    WriteLn('DI =0x ', hex(Reg.DI));
    WriteLn('DS =0x ', hex(Reg.DS));
    WriteLn('ES =0x ', hex(Reg.ES));
    WriteLn('FLAGS =0x ', hex(Reg.Flags));
    WriteLn('Presione una tecla para continuar...');
    WriteLn;
    ReadKey;
  end
  else
    WriteLn('Movimiento cilindro: [', Pos, '] exitoso');

  WriteLn;
  delay (700);
end;

procedure SimulateSeekToCylinder(pos: integer);
begin
end;

procedure ejecutarFIFO;
begin
  ClrScr;
  WriteLn('Comenzando la Ejecucion: Algoritmo FIFO');
  WriteLn('---------------------------------------');
  WriteLn('   Presione una tecla para continuar   ',CANT_TOTAL);
  ReadKey;

  for i:=0 to C_SEC do
	SimulateSeekToCylinder(SEC[i]);

  WriteLn;
  WriteLn('Fin de la Ejecucion: Algoritmo FIFO');
  WriteLn('Presione una tecla para continuar   ');
  ReadKey;
  ClrScr;
end;


Procedure ejecutarSSTF(cant:integer);
var
  Vect: array[0..1000] of integer;
  i, j, min, pos, bucle: integer;
begin
  ClrScr;
  WriteLn('Comenzando la Ejecucion: Algoritmo SSTF');
  WriteLn('---------------------------------------');
  WriteLn('   Presione una tecla para continuar   ',CANT_TOTAL);
  WriteLN(C_SEC);
  ReadKey;

  for i:=0 to 3 do
    Vect[i]:=SEC[i];

  SimulateSeekToCylinder(Vect[0]);
 {
  j:=0;
  min:=VALOR_MAX;
  pos:=1;

  for bucle:=1 to C_SEC do
  begin
    for i:=1 to C_SEC do
    begin
      if ( (Vect[i] <> -1) and (i<>j) ) then
	if abs(Vect[j]-Vect[i]) < min then
	begin
	  min := abs(Vect[j]-Vect[i]);
	  pos := i;
	end;
    end;
    Vect[j]:=-1; pone en -1 las ya visitadas
    j:=pos;
    SimulateSeekToCylinder(Vect[j]);
    min := VALOR_MAX;
  end;
                                    }
  ejecutarFIFO;
  WriteLn;
  WriteLn('Fin de la Ejecucion: Algoritmo SSTF');
  WriteLn('Presione una tecla para continuar   ');
end;


Procedure ejecutarSCAN;
var
  V: array[0..CANT_TOTAL-1] of longint;
  i, j, min, pos, bucle, aux: longint;
begin
  ClrScr;
  WriteLn('Comenzando la Ejecucion: Algoritmo SCAN');
  WriteLn('---------------------------------------');
  WriteLn('   Presione una tecla para continuar   ');
  ReadKey;

  for i:=0 to CANT_TOTAL do
    V[i]:=SEC[i];

  SimulateSeekToCylinder(V[0]);

  {ordeno}
  for i:=1 to C_SEC do
  begin
    for j:=i to C_SEC do
    begin
      if V[j]<V[i] then
      begin
        aux:=V[j];
        V[j]:=V[i];
        V[i]:=aux;
      end;
    end;
  end;

  {busco la pos}
  i:=1;
  while V[i]<V[0] do
    i:=i+1;
  pos:=i;

  {recorro pa'tras hasta el principio y despues pa'delante}
  if pos <> 1 then
  for i:=pos-1 downto 1 do
    SimulateSeekToCylinder(V[i]);
  SimulateSeekToCylinder(0);
  for i:=pos to C_SEC do
    SimulateSeekToCylinder(V[i]);

  WriteLn;
  WriteLn('Fin de la Ejecucion: Algoritmo SCAN');
  WriteLn('Presione una tecla para continuar   ');
  ReadKey;
  ClrScr;
end;


Procedure ejecutarCSCAN;
var
  V: array[0..CANT_TOTAL-1] of longint;
  i, j, min, pos, bucle, aux: longint;
begin
  ClrScr;
  WriteLn('Comenzando la Ejecucion: Algoritmo CSCAN');
  WriteLn('----------------------------------------');
  WriteLn('   Presione una tecla para continuar   ');
  ReadKey;

  for i:=0 to CANT_TOTAL do
    V[i]:=SEC[i];

  SimulateSeekToCylinder(V[0]);

  {ordeno}
  for i:=1 to C_SEC do
  begin
    for j:=i to C_SEC do
    begin
      if V[j]<V[i] then
      begin
        aux:=V[j];
        V[j]:=V[i];
        V[i]:=aux;
      end;
    end;
  end;

  {busco la pos}
  i:=1;
  while V[i]<V[0] do
    i:=i+1;
  pos:=i;

  {recorro pa'tras hasta el principio y despues pa'delante}
  if pos <> 1 then
  for i:=pos-1 downto 1 do
    SimulateSeekToCylinder(V[i]);
  SimulateSeekToCylinder(0);
  for i:=C_SEC downto pos do
    SimulateSeekToCylinder(V[i]);

  WriteLn;
  WriteLn('Fin de la Ejecucion: Algoritmo CSCAN');
  WriteLn('Presione una tecla para continuar   ');
  ReadKey;
  ClrScr;
end;


Procedure ejecutarLOOK;
var
  V: array[0..CANT_TOTAL-1] of longint;
  i, j, min, pos, bucle, aux: longint;
begin
  ClrScr;
  WriteLn('Comenzando la Ejecucion: Algoritmo LOOK');
  WriteLn('---------------------------------------');
  WriteLn('   Presione una tecla para continuar   ');
  ReadKey;

  for i:=0 to CANT_TOTAL do
    V[i]:=SEC[i];

  SimulateSeekToCylinder(V[0]);

  {ordeno}
  for i:=1 to C_SEC do
  begin
    for j:=i to C_SEC do
    begin
      if V[j]<V[i] then
      begin
        aux:=V[j];
        V[j]:=V[i];
        V[i]:=aux;
      end;
    end;
  end;

  {busco la pos}
  i:=1;
  while V[i]<V[0] do
    i:=i+1;
  pos:=i;

  {recorro pa'tras hasta el principio y despues pa'delante}
  if pos <> 1 then
  for i:=pos-1 downto 1 do
    SimulateSeekToCylinder(V[i]);
  for i:=pos to C_SEC do
    SimulateSeekToCylinder(V[i]);

  WriteLn;
  WriteLn('Fin de la Ejecucion: Algoritmo LOOK');
  WriteLn('Presione una tecla para continuar   ');
  ReadKey;
  ClrScr;
end;


Procedure ejecutarCLOOK;
var
  V: array[0..CANT_TOTAL-1] of longint;
  i, j, min, pos, bucle, aux: longint;
begin
  ClrScr;
  WriteLn('Comenzando la Ejecucion: Algoritmo CLOOK');
  WriteLn('----------------------------------------');
  WriteLn('   Presione una tecla para continuar   ');
  ReadKey;

  for i:=0 to CANT_TOTAL do
    V[i]:=SEC[i];

  SimulateSeekToCylinder(V[0]);

  {ordeno}
  for i:=1 to C_SEC do
  begin
    for j:=i to C_SEC do
    begin
      if V[j]<V[i] then
      begin
        aux:=V[j];
        V[j]:=V[i];
        V[i]:=aux;
      end;
    end;
  end;

  {busco la pos}
  i:=1;
  while V[i]<V[0] do
    i:=i+1;
  pos:=i;

  {recorro pa'tras hasta el principio y despues pa'delante}
  if pos <> 1 then
  for i:=pos-1 downto 1 do
    SimulateSeekToCylinder(V[i]);
  for i:=C_SEC downto pos do
    SimulateSeekToCylinder(V[i]);

  WriteLn;
  WriteLn('Fin de la Ejecucion: Algoritmo CLOOK');
  WriteLn('Presione una tecla para continuar   ');
  ReadKey;
  ClrScr;
end;




procedure Simular;

var
  i, j, pos, bucle :integer;
  min, aux: longint;
  V: array[0..CANT_TOTAL-1] of longint;

  nom: array[1..7] of string; {textos a imprimir de las opciones}
  opc: integer;               {opcion seleccionada al momento}
  a: char;                    {valor ASCII de la tecla presionada}
  CANT_OPC: integer;

begin
    { REGLA DE TRES SIMPLE
        la utilizamos para hacer que los valores simulados en la secuencia
        de "sectores virtuales" tomen valores que hagan que el brazo
        se mueva por el disco entero, si no, el movimiento no se apreciaria
      bytes_max ------------------------ VALOR_MAX
      x (num de sector real) -------------- sec[i]
    }


{ MENU DE EJECUCION DE ALGORITMOS ------------------------------------ }

  ClrScr;

  CANT_OPC := 7;     {cantidad de opciones a desplegar}

  {opcion y color predeterminados y se les dan los nombres a las opciones}
  opc := 1;
  nom[1] := 'Ejecutar Algoritmo FIFO';
  nom[2] := 'Ejecutar Algoritmo SSTF';
  nom[3] := 'Ejecutar Algoritmo SCAN';
  nom[4] := 'Ejecutar Algoritmo C-SCAN';
  nom[5] := 'Ejecutar Algoritmo LOOK';
  nom[6] := 'Ejecutar Algoritmo C-LOOK';
  nom[7] := 'Volver al Menu Principal';

  {MENU -->> bucle que espera teclas a ser presionadas para hacer algo}
  a := chr(0);
  while (a <> chr(27)) do {mientras tecla sea distinta de Escape}
  begin

    {se fija que tecla fue presionada}
    case ord(a) of
      {arriba}
      80: if opc<CANT_OPC then opc:=opc+1 else opc:= 1;
      {abajo}
      72: if opc>1 then opc:=opc-1 else opc:= CANT_OPC;
      {se fija en que opcion esta cuando se presiona enter y llama al proc}
      13: case opc of
            1: EjecutarFIFO;
            2: EjecutarSSTF(C_SEC);
            3: EjecutarSCAN;
            4: EjecutarCSCAN;
            5: EjecutarLOOK;
            6: EjecutarCLOOK;
            7: begin ClrScr; exit; end;
          end;
    end;

    {imprime todo el menu}
    for i := 1 to CANT_OPC do
    begin

      {elige la opcion que debe marcarse con un distinto color de background}
      if i=opc then
      begin
        TextColor(cls);
        TextBackground(cfs);
      end
      else
      begin
        TextColor(cl);
        TextBackground(cf);
      end;

      {posiciona e imprime las opciones en su lugar}
      GotoXY(28,9+i);
      write(nom[i]);

    end;

    {imprime el nombre del programa y eso arriba de la pantalla}
    TextBackground(cfs);
    TextColor(cls);
    GotoXY(1,1); Write('                        MENU DE EJECUCION DE ALGORITMOS                         ');

    {imprime la ayuda de teclas al pie de la pantalla}
    TextColor(cl);
    TextBackground(cf);
    GotoXY(2,24);
    write('   presione abajo y arriba para moverse sobre el menu y enter para ejecutar ');

    {espera a presionar una tecla}
    a:=readkey;

  end;

  ClrScr;

{FIN MENU DE EJECUCION DE ALGORITMOS-----------------------------------}

end;





{ -------------------------
   AYUDA
 -------------------------}

procedure Ayuda;
begin

  TextBackground(cf);
  ClrScr;

  TextColor(cls);
  TextBackground(cfs);

  Write('                      Ingenieria en Sistemas de Informacion                     ');
  Write('                        Universidad Tecnologica Nacional                        ');
  Write('                           Facultad Regional La Plata                           ');
  Write('                                   PROYECTO CT                                  ');
  WriteLn('');

  TextColor(cl);
  TextBackground(cf);


  WriteLn('  Cr‚ditos:');
  WriteLn('    - Trabajo en Hardware:  Maximiliano Padulo   (maxi.padulo@gmail.com)');
  WriteLn('');
  WriteLn('    - Trabajo en Software:  Julian Perelli       (julianperelli@hotmail.com)');
  WriteLn('');
  WriteLn('');
  WriteLn('          úúúúúúúúúúúúúúúúúúúúúúúADVERTENCIA!úúúúúúúúúúúúúúúúúúúúúúú');
  WriteLn('              este programa puede causarle da¤os a su computadora');
  WriteLn('           no nos responsabilizamos por la ocurrencia de los mismos');
  WriteLn('');
  WriteLn(' El programa simula los algoritmos de busqueda en un disco rigido');
  WriteLn(' que fue construido para poder observar los movimientos');
  WriteLn(' del brazo del mismo');
  WriteLn('');
  WriteLn(' Este software es gratuito. El feedback es el mejor agradecimiento.');
  WriteLn(' Cualquier consulta (o queja), no dude en comunicarse via mail');
  WriteLn('');

  WriteLn; Write('Presione una tecla para volver al menu');
  repeat until KeyPressed; ReadKey;
  ClrScr;

end;



procedure Configurar;
var
  Resp: char;
begin
  ClrScr;
  Write('Ingrese el numero maximo de sectores simulados: ');
  ReadLn(VALOR_MAX);
  WriteLn;
  WriteLn('Desea ver los codigos de depuracion (S/N): ');
  ReadLn(Resp);
  if UpCase(Resp) = 'S'
    then VER_DEBUG := True
    else VER_DEBUG := False;
  WriteLn;
  WriteLn('Valores seteados, presione una tecla para volver al menu');
  ReadKey;
  ClrScr;
end;



{---------------------------------------
            PROCEDIMIENTO
              ARRANQUE
---------------------------------------}

function CantCilindros: word;
var
  Registro: Registers; Temp:Byte;

begin
  WriteLn;
  Registro.AH := $08;
  Registro.DL := $80;  {drive number}
  WriteLn('Determinando tama¤o maximo de cilindros...');
  Intr($13, Registro);

  Temp:=Registro.CH;
  Registro.CH:=Registro.CL SHR 6;
  Registro.CL:=Temp;

  if VER_DEBUG then
  begin
    if ( Registro.Flags and $01 = $01 ) then
      WriteLn('Error en Interrupcion 0x13 Subrutina 0x08')
    else
    begin
      WriteLn('Tama¤o maximo de cilindros detectado');
      Writeln('[',Registro.CX, '] cilindros en total');
    end;
    readkey;
  end;

  CantCilindros := Registro.CX;
end;



{---------------------------------------
            PROCEDIMIENTO
              ARRANQUE
---------------------------------------}
procedure init;
var
  linea, vari, valor: string;
begin

  ClrScr;
  WriteLn('Inicializando...');


  Randomize;
  C_SEC := 0;

  TextMode(CO80); {modo de 25 lineas}

  {-------------------PARA ARCHIVO CONFIGURACION----------------------}
  begin
    WriteLn('Archivo de Configuraciones NO encontrado: cargando valores predeterminados');
    VALOR_MAX := 200;
    VER_DEBUG := true;

    WriteLn; Write('Presione una tecla para continuar');
    repeat until KeyPressed; ReadKey;
    ClrScr;



  end;
 {-----------------------------FIN ARCHIVO CONFIG----------------------}

 MAX_CILINDRO := CantCilindros;

end;




{***********************************************************************

     PRINCIPAL

************************************************************************}


begin

  init;

  Ayuda;

{INICIO MENU PRINCIPAL  --------------------------------------------------}

  CANT_OPC:= 5;     {cantidad de opciones a desplegar}
  TextBackground(cf);

  {opcion y color predeterminados y se les dan los nombres a las opciones}
  opc := 1;
  nom[1] := 'Iniciar Simulacion de disco';
  nom[2] := 'Secuencia de bloques';
  nom[3] := 'Configuracion';
  nom[4] := 'Ayuda';
  nom[5] := 'Salir';

  {MENU -->> bucle que espera teclas a ser presionadas para hacer algo}
  a := chr(0);
  while (a <> chr(27)) do {mientras tecla sea distinta de Escape}
  begin


    {se fija que tecla fue presionada}
    case ord(a) of
      {arriba}
      80: if opc<CANT_OPC then opc:=opc+1 else opc:= 1;
      {abajo}
      72: if opc>1 then opc:=opc-1 else opc:= CANT_OPC;
      {se fija en que opcion esta cuando se presiona enter y llama al proc}
      13: case opc of
            1: begin Simular end;
            2: begin Secuencia end;
            3: begin Configurar end;
            4: begin Ayuda end;
            5: exit;
          end;
    end;

    {imprime todo el menu}
    for i := 1 to CANT_OPC do
    begin

      {elige la opcion que debe marcarse con un distinto color de background}
      if i=opc then
      begin
        TextColor(cls);
        TextBackground(cfs);
      end
      else
      begin
        TextColor(cl);
        TextBackground(cf);
      end;

      {posiciona e imprime las opciones en su lugar}
      GotoXY(28,9+i);
      write(nom[i]);

    end;


    {imprime el nombre del programa y eso arriba de la pantalla}
    TextBackground(cfs);
    TextColor(cls);
    GotoXY(1,1); Write('Proyecto CT               UTN / FRLP            por Maxi Padulo y Julian Perelli');

    {imprime la ayuda de teclas al pie de la pantalla}
    TextColor(cl);
    TextBackground(cf);
    GotoXY(2,24);
    write('   presione abajo y arriba para moverse sobre el menu y enter para ejecutar ');


    {espera a presionar una tecla}
    a:=readkey;

  end;

{FIN MENU PRINCIPAL ------------------------------------------------------}
end.
