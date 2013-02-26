unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;
  story : TStringList;
  title : string;

implementation

{$R *.lfm}

//Funktion um Artikel zuzuweisen
function Article (wrd:string) : string;
Var hlp : string;
begin

if (wrd[1] = 'a') or (wrd[1] = 'e') or (wrd[1] = 'i') or (wrd[1] = 'o') or (wrd[1] = 'u') then hlp := 'an' else hlp := 'a';
Article := hlp + ' ';

end;
//Funktion Ende

//Funktion um Wortgruppen aus txt zu lesen
function LoadWords (name:string) : string;
Var initialdir : string; listsize : integer; list: Tstringlist;
begin

 list := TStringList.create;
 InitialDir:=ExtractFilePath(Application.ExeName); //wo ist die Anwendung?
 list.LoadFromFile(InitialDir+ 'txt/' + name + '.txt');

 listsize := list.count; //Länge der Liste
 Randomize;
 LoadWords := list[Random(listsize)]; //zufälliges Element der Liste
end;
//Funktion Ende

{ TForm1 }

//Prozedur Speichere Geschichte
procedure TForm1.Button2Click(Sender: TObject);
 begin
  if title = '' then SaveDialog1.FileName := 'Unamed Story' else SaveDialog1.FileName := title;
  SaveDialog1.InitialDir := ExtractFilePath(Application.ExeName);
   if SaveDialog1.Execute then begin
    Memo1.Lines.SaveToFile(SaveDialog1.FileName + '.txt');
   end;
 end;
//Prozedur Ende

//Prozedur Erstelle Geschichte
procedure TForm1.Button1Click(Sender: TObject);
VAR strplot, pnames, pgender : TStringlist; confl,hlp : string; i : integer;
begin

 Randomize;

 //generiere den Handlungsrahmen
 strplot := TStringList.create;
 confl := LoadWords('conflict');

  if (confl = 'kidnap') or (confl = 'destroy') then begin
   strplot.add(confl);
   if random(2) = 1 then strplot.add('cheat');
  end;

  if confl = 'witch' then begin
   strplot.add(confl);
   strplot.add('cheat');
   strplot.add('entwitch');
  end;

  strplot.add(LoadWords('conflict_end'));

 //Handlungsrahmen ist fertig

 //erstelle Personen
 pnames := TStringList.create;
 pgender := TStringList.create;

   //Personennamen
   pnames.add(LoadWords('person_good'));
   pnames.add(LoadWords('person_evil'));
   //Personennamen fertig

   //Personengeschlecht
   for i := 1 to 2 do begin
    if random(2) = 1 then pgender.add('he') else pgender.add('she');
   end;
   //Personengeschlecht fertig

 //Personen erstellt

 //Formuliere Geschichte
 story := TStringList.create;

 hlp := LoadWords('adjective_good');
 if random(2) = 1 then story.add(LoadWords('onceupon') + ' there lived ' + Article(pnames[0]) + pnames[0] + '.') else  story.add(LoadWords('onceupon') + ' there lived ' + Article(hlp) + hlp + ' ' + pnames[0] + '.');

 For i := 0 to (strplot.count-1) do begin
   if strplot[i] = 'kidnap' then begin
    if random(2) = 1 then story.add (LoadWords('oneday') + ' ' + pgender[0] + ' was ' + LoadWords('kidnap') + ' by ' + Article(pnames[1]) + pnames[1] + '.') else story.add ('One day the ' + pnames[0] + ' was ' + LoadWords('kidnap') + ' by ' + Article(pnames[1]) + pnames[1] + '.')
   end;

   if strplot[i] = 'destroy' then begin
    if random(2) = 1 then story.add (LoadWords('oneday') + ' ' + Article(pnames[1]) + pnames[1] + ' ' + LoadWords('destroy') + ' the ' + LoadWords('destroyobject') + ' of the ' + pnames[0] + '.') else story.add ('One day ' + Article(pnames[1]) + pnames[1] + ' ' + LoadWords('kill') + ' the ' + LoadWords('relative') + ' of the ' + pnames[0] + '.');
   end;

   if strplot[i] = 'cheat' then begin
    hlp := pgender[0];
    if random(2) = 1 then story.add (UpCase(hlp[1]) + Copy(hlp, 2 , length(hlp)) + ' ' + LoadWords('cheat') + ' the ' + pnames[1] + '.') else story.add ('The ' + pnames[0] + ' ' + LoadWords('cheat') + ' the ' + pnames[1] + '.')
   end;

   if strplot[i] = 'kill' then begin
    if random(2) = 0 then story.add (LoadWords('then') + ' ' + pgender[0] + ' ' + LoadWords('kill') + ' the ' + pnames[1] + '.') else story.add ('Then the ' + pnames[0] + ' ' + LoadWords('kill') + ' the ' + pnames[1] + '.')
   end;

   if strplot[i] = 'flee' then begin
    if random(2) = 0 then story.add (LoadWords('then') + ' ' + pgender[0] + ' ' + LoadWords('flee') + '.') else story.add ('Then the ' + pnames[0] + ' ' + LoadWords('flee') + '.')
   end;

   if strplot[i] = 'witch' then begin
    if random(2) = 1 then story.add (LoadWords('oneday') + ' ' + pgender[0] + ' was ' + LoadWords('witch') + ' by ' + Article(pnames[1]) + pnames[1] + '.') else story.add ('One day the ' + pnames[0] + ' was ' + LoadWords('witch') + ' by ' + Article(pnames[1]) + pnames[1] + '.')
   end;

   if strplot[i] = 'entwitch' then begin
    story.add ('The ' + pnames[1] + ' ' + LoadWords('entwitch') + ' the ' + pnames[0]  + '.')
   end;

  end;

 //Geschichte ist formuliert

 //Titel
 hlp := LoadWords('adjective_good');
 if (random(2) = 1) then title := 'The ' + UpCase(pnames[1][1]) + Copy(pnames[1], 2 , length(pnames[1])) else if (random(2) = 1) then title := 'The ' + UpCase(pnames[0][1]) + Copy(pnames[0], 2 , length(pnames[0])) + ' and The ' + UpCase(pnames[1][1]) + Copy(pnames[1], 2 , length(pnames[1])) else title := 'The ' + UpCase(hlp[1]) + Copy(hlp, 2 , length(hlp)) + ' ' + UpCase(pnames[0][1]) + Copy(pnames[0], 2 , length(pnames[0])) ;
 Form1.Caption := title;
 //Titel Ende

 Memo1.lines := story;


 end;
//Prozedur Ende





end.
