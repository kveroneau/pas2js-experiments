program termtest2;

{$mode objfpc}

uses
  browserapp, JS, Classes, SysUtils, Web, webvt100;

type

  { TMyApplication }

  TMyApplication = class(TBrowserApplication)
    FTerm: TWebTerminal;
    procedure doRun; override;
    procedure OnLine(const data: string);
    procedure OnCntl(const data: string);
  end;

procedure TMyApplication.doRun;
begin
  FTerm:=TWebTerminal.Create;
  FTerm.OnPayload:=@OnLine;
  FTerm.OnControlCode:=@OnCntl;
  FTerm.WriteLn('Hello from ObjectPascal!');
  FTerm.WriteLn('This will be on Line 2!');
  FTerm.Attr:=taBackground+tcBlue;
  FTerm.Attr:=taForeground+tcWhite;
  FTerm.WriteLn('Rows: '+IntToStr(FTerm.Rows));
  FTerm.Mouse:=True;
  FTerm.MoveTo(10,10);
  FTerm.Prompt:='C:/>';
end;

procedure TMyApplication.OnLine(const data: string);
begin
  WriteLn(data);
  if data = 'clear' then
    FTerm.Clear;
  FTerm.Prompt:='C:/>';
end;

procedure TMyApplication.OnCntl(const data: string);
begin
  WriteLn('Control Code: ',data);
end;

var
  Application : TMyApplication;

begin
  Application:=TMyApplication.Create(nil);
  Application.Initialize;
  Application.Run;
end.
