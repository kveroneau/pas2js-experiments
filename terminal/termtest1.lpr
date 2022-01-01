program termtest1;

{$mode objfpc}

uses
  browserapp, JS, Classes, SysUtils, libjquery, Web, memtest, mycomp,
  hackterm, jsterm, mxml;

type

  { TMyApplication }

  TMyApplication = class(TBrowserApplication)
    procedure doRun; override;
  private
    FTerm: TJQuery;
    FMemTest: TMemTest;
    FHackTerm: THackTerminal;
    function EnableTerm(Evt: TEventListenerEvent): boolean;
    procedure onCommand(command: string; term: TJQuery);
    procedure StartMemTest(term: TJQuery);
    procedure StartHackTerm(term: TJQuery);
  end;

procedure onInit(term: TJQuery);
begin
  WriteLn('OnInit Called!');
  term.echo('Hello World!');
end;

procedure onExit(term: TJQuery);
begin
  WriteLn('OnExit Called!');
end;

procedure onLogin(user, password: string; callback: TLoginEvent);
begin
  WriteLn('OnLogin: ',user);
  if (user = 'admin') and (password = 'password') then
    callback('A-OK')
  else
    callback('');
end;

procedure loginShell(command: string; term: TJQuery);
begin
  case command of
    'ver': term.echo('Login Shell v1.0');
    'level': term.echo(IntToStr(term.Level));
    'whoami': term.echo(term.Username);
    'name': term.echo(term.Name);
    'logout': term.Logout;
    'token': term.echo('Token: '+term.Token(False));
    'ltoken': term.echo('Token: '+term.Token(True));
  else
    term.error('What?');
  end;
end;

procedure loginCommand(term: TJQuery);
var
  params: TTerminalState;
begin
  params:=SimpleState('login', '] ');
  params.onInit:=@onInit;
  params.onExit:=@onExit;
  params.onLogin:=@onLogin;
  term.Push(@loginShell, params);
end;

procedure TMyApplication.onCommand(command: string; term: TJQuery);
var
  cmd: string;
begin
  cmd:=getToken(command);
  WriteLn('OnCommand: ',command);
  case cmd of
    'ls': term.echo('Amazing!');
    'login': loginCommand(term);
    'echo': term.echo(getToken(command));
    'prompt': term.Prompt:=getToken(command);
    'level': term.echo(IntToStr(term.Level));
    'whoami': term.echo(term.Username);
    'name': term.echo(term.Name);
    'disable': term.Enabled:=False;
    'purge': term.Purge;
    'token': term.echo('Token: '+term.Token(False));
    'ltoken': term.echo('Token: '+term.Token(True));
    'memtest': StartMemTest(term);
    'hackterm': StartHackTerm(term);
    'magic': LoadXMLContent('content', 'names.xml', 'magic.xsl');
  else
    term.error('?SYNTAX ERROR');
  end;
end;

function TMyApplication.EnableTerm(Evt: TEventListenerEvent): boolean;
begin
  WriteLn('Button Clicked!');
  FTerm.Enabled:=True;
end;

procedure TMyApplication.StartMemTest(term: TJQuery);
begin
  LoadSettings;
  if Assigned(FMemTest) then
    FMemTest.Free;
  FMemTest:=TMemTest.Create(term);
end;

procedure TMyApplication.StartHackTerm(term: TJQuery);
begin
  if Assigned(FHackTerm) then
    FHackTerm.Free;
  FHackTerm:=THackTerminal.Create(term);
end;

procedure TMyApplication.doRun;
var
  params: TJSTerminalOptions;
begin
  JQuery('#enableterm').On_('click', @EnableTerm);
  params:=LoginTerm('System v1.0', 'C:/>', @onLogin);
  FTerm:=InitTerminal('terminal', @onCommand, params, @onInit);
  {Terminate;}
end;

var
  Application : TMyApplication;

begin
  Application:=TMyApplication.Create(nil);
  Application.Initialize;
  Application.Run;
  {Application.Free;}
  WriteLn('Main code done.');
end.

