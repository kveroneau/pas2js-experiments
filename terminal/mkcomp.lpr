program mkcomp;

{$mode objfpc}{$H+}
{$modeswitch unicodestrings}

uses
  Classes, mycomp;

var
  Comp: TAppSettings;
  Mem: TMemoryStream;

begin
  Comp:=TAppSettings.Create(Nil);
  Comp.DataString:='This is a sample data string!';
  Comp.URL:='http://iamkevin.ca/';
  Comp.Enable:=True;
  Comp.Count:=42;
  Mem:=TMemoryStream.Create;
  Mem.WriteComponent(Comp);
  Mem.SaveToFile('mycomp.bin');
  Mem.Free;
  Comp.Free;
end.

