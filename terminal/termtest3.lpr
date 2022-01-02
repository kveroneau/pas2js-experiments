program termtest3;

{$mode objfpc}

uses
  browserapp, JS, Classes, SysUtils, Web, vtwidgets, webvt100;

type

  { TMyApplication }

  TMyApplication = class(TBrowserApplication)
  Private
    FScreen: TVTScreen;
    procedure doRun; override;
    procedure doNext;
    procedure testBSOD;
    procedure testRefresh;
    procedure doRefresh;
    procedure testWindow;
  end;

procedure TMyApplication.doRun;
begin
  FScreen:=TVTScreen.Create(Self);
  FScreen.OnRefresh:=@testRefresh;
  FScreen.DramaPrint('Hello World from VT100 Widgets!', 0, 0);
  FScreen.DramaPrint('Hello World from ObjectPascal!', 10, 10);
  FScreen.DramaPrint('It works!', 5,0, @doNext);
end;

procedure TMyApplication.doNext;
begin
  FScreen.SetColor(tcBlack, tcRed);
  FScreen.DramaPrint('It completely works!', 8, 0);
  FScreen.CountDown(10, @testBSOD);
end;

procedure TMyApplication.testBSOD;
begin
  FScreen.BSOD('Something really broke!');
end;

procedure TMyApplication.testRefresh;
begin
  FScreen.Free;
  FScreen:=TVTScreen.Create(Self);
  FScreen.SetColor(tcWhite, tcBlue);
  FScreen.DramaPrint('Attempting to Refresh page...', 0, 0);
  FScreen.CountDown(5, @doRefresh);
end;

procedure TMyApplication.doRefresh;
var
  l: TVTDataLabel;
begin
  FScreen.SetColor(tcGreen, tcBlack);
  FScreen.DramaPrint('Website refresh successful!', 0, 0, @testWindow);
  l:=TVTDataLabel.Create(FScreen.Widgets, 10, 10);
  l.Title:='Full Name';
  l.Data:='Kevin Veroneau';
end;

procedure TMyApplication.testWindow;
var
  wm: TWindowManager;
  w: TVTWindow;
begin
  wm:=TWindowManager.Create(FScreen.Widgets);
  w:=wm.NewWindow('Kevin''s Profile', 6, 10, 40, 10);
  {w.writeln('Welcome to my profile website!');
  w.write('My Name: ');
  w.writeln('Kevin Veroneau');}
  w.AddLabel('Welcome to my profile website!');
  w:=wm.NewWindow('Window 2', 4, 6, 40, 10);
  w.AddLabel('A second overlapping Window!');
  wm.Render;
end;

var
  Application : TMyApplication;

begin
  Application:=TMyApplication.Create(nil);
  Application.Initialize;
  Application.Run;
end.

