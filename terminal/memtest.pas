unit memtest;

{$mode objfpc}
{$modeswitch externalclass}

interface

uses
  Classes, SysUtils, libjquery, jsterm, mycomp, Rtl.BrowserLoadHelper, p2jsres,
  Web, JS, Types;

type

  TMyData = class(TComponent)
  private
    FString: string;
  published
    property MyString: string read FString write FString;
  end;

  THRRecord = Class external name 'Object' (TJSObject)
    LastName: string; external name 'last';
    Birthday: string; external name 'dob';
    MiddleName: string; external name 'middle';
    FirstName: string; external name 'employee';
    Position: string; external name 'position';
    Status: string; external name 'type';
  end;

  TMail = Class external name 'Object' (TJSObject)
    Item: string; external name 'item';
    Body: string; external name 'body';
  end;

  { TMemTest }

  TMemTest = class(TObject)
    constructor Create(term: TJQuery);
    destructor Destroy; override;
  private
    FTerm: TJQuery;
    FMemory: TMemoryStream;
    FMyData: TMyData;
    procedure onLogin(user, password: string; callback: TLoginEvent);
    procedure onCommand(command: string; term: TJQuery);
    procedure onInit(term: TJQuery);
    procedure onExit(term: TJQuery);
    procedure WriteString(s: string);
    function ReadString: string;
    procedure LoadFile(FileName: string);
    procedure onLoaded;
    procedure onLoadError(const msg: string);
    procedure ShowSettings;
    procedure ListFiles;
    procedure TextToBin;
    procedure HRTest;
    procedure ScenarioTest;
  end;

var
  AppSettings: TAppSettings;

procedure LoadSettings;

implementation

{$R mycomp.bin}
{$R testfile.txt}

{ TMemTest }

constructor TMemTest.Create(term: TJQuery);
var
  params: TTerminalState;
begin
  FTerm:=term;
  params:=LoginState('memtest', 'Mem>', @onLogin);
  params.onInit:=@onInit;
  params.onExit:=@onExit;
  FTerm.Push(@onCommand, params);
  {FMemory:=Nil;}
  FMyData:=TMyData.Create(Nil);
end;

destructor TMemTest.Destroy;
begin
  WriteLn('Destroy called.');
  if Assigned(FMemory) then
    FMemory.Free;
  if Assigned(FMyData) then
    FMyData.Free;
  inherited Destroy;
end;

procedure TMemTest.onLogin(user, password: string; callback: TLoginEvent);
begin
  if (user = 'root') and (password = 'secret') then
    callback('RW-TOKEN')
  else if user = 'guest' then
    callback('RO-TOKEN')
  else
    callback('');
end;

procedure TMemTest.onCommand(command: string; term: TJQuery);
var
  cmd: string;
begin
  if not Assigned(FMemory) then
    WriteLn('FMemory not assigned.');
  cmd:=getToken(command);
  case cmd of
    'level': term.echo(IntToStr(term.Level));
    'whoami': term.echo(term.Username);
    'name': term.echo(term.Name);
    'token': term.echo('Token: '+term.Token(False));
    'ltoken': term.echo('Token: '+term.Token(True));
    'write': WriteString(getToken(command));
    'setpos': FMemory.Position:=StrToInt(getToken(command));
    'pos': term.echo('Position: '+IntToStr(FMemory.Position));
    'read': term.echo(ReadString);
    'byte': term.echo(IntToStr(FMemory.ReadByte));
    'load': LoadFile(getToken(command));
    'size': term.echo('Memory size: '+IntToStr(FMemory.Size));
    'show': ShowSettings;
    'ls': ListFiles;
    'text2bin': TextToBin;
    'hrtest': HRTest;
    'stest': ScenarioTest;
  else
    term.error('Bad command.');
  end;
end;

procedure TMemTest.onInit(term: TJQuery);
begin
  if not Assigned(FMemory) then
  begin
    FTerm.echo('Initializing memory...');
    FMemory:=TMemoryStream.Create;
  end;
end;

procedure TMemTest.onExit(term: TJQuery);
begin
  FTerm.echo('Freeing memory...');
  FMemory.Free;
  FMemory:=Nil;
end;

procedure TMemTest.WriteString(s: string);
begin
  FMyData.MyString:=s;
  FMemory.WriteComponent(FMyData);
end;

function TMemTest.ReadString: string;
begin
  try
    FMemory.ReadComponent(FMyData);
    Result:=FMyData.MyString;
  except
    On EStreamError do Result:='Unexpected Stream error.';
    On EReadError do Result:='Invalid Component in memory.'
  end;
end;

procedure TMemTest.LoadFile(FileName: string);
var
  info: TResourceInfo;
  strm: TStream;
begin
  FTerm.echo('Loading file '+FileName+'...');
  if not GetResourceInfo(rsHTML, FileName, info) then
  begin
    FTerm.Enabled:=False;
    FMemory.LoadFromFile(FileName, @onLoaded, @onLoadError);
    Exit;
  end;
  WriteLn(info.format);
  WriteLn(window.atob(info.data));
  strm:=TStringStream.Create(window.atob(info.data));
  if info.format = 'application/octet-strea' then
  begin
    FMemory.Position:=0;
    ObjectTextToBinary(strm, FMemory);
    FMemory.Position:=0;
  end
  else if info.format = 'text/plain' then
  begin
    FTerm.Echo(TStringStream(strm).DataString);
  end
  else
  begin
    FMemory.Position:=0;
    FMemory.CopyFrom(strm, strm.Size);
  end;
  strm.Free;
end;

procedure TMemTest.onLoaded;
begin
  FTerm.echo('File loaded.');
  FTerm.Enabled:=True;
end;

procedure TMemTest.onLoadError(const msg: string);
begin
  FTerm.error(msg);
  FTerm.Enabled:=True;
end;

procedure TMemTest.ShowSettings;
var
  s: TAppSettings;
begin
  s:=TAppSettings.Create(Nil);
  try
    FMemory.Position:=0;
    FMemory.ReadComponent(s);
    FTerm.echo('DataString: '+s.DataString);
    FTerm.echo('URL: '+s.URL);
    if s.Enable then
      FTerm.echo('Count: '+IntToStr(s.Count));
  finally
    s.Free;
  end;
end;

procedure TMemTest.ListFiles;
var
  files: array of String;
  i: integer;
begin
  files:=GetResourceNames(rsHTML);
  for i:=0 to Length(files)-1 do
    FTerm.echo(files[i]);
end;

procedure TMemTest.TextToBin;
var
  strm: TStream;
begin
  strm:=TMemoryStream.Create;
  FMemory.Position:=0;
  strm.CopyFrom(FMemory, FMemory.Size);
  strm.Position:=0;
  FMemory.Clear;
  ObjectTextToBinary(strm, FMemory);
  strm.Free;
end;

procedure TMemTest.HRTest;
var
  info: TResourceInfo;
  hrdb: TJSObject;
  alex: THRRecord;
begin
  if not GetResourceInfo(rsHTML, 'hrdb', info) then
    Exit;
  hrdb:=TJSJSON.parseObject(window.atob(info.data));
  alex:=THRRecord(hrdb.Properties['frank']);
  FTerm.Echo(alex.Birthday);
end;

procedure TMemTest.ScenarioTest;
var
  info: TResourceInfo;
  data, flist: TJSObject;
  mail: TJSArray;
  mbox: TMail;
  files: TStringDynArray;
begin
  if not GetResourceInfo(rsHTML, 'scenario2', info) then
    Exit;
  data:=TJSJSON.parseObject(window.atob(info.data));
  flist:=TJSObject(data.Properties['mailboxes']);
  mail:=TJSArray(flist.Properties['alice']);
  WriteLn(mail.FLength);
  mbox:=TMail(mail.Elements[0]);
  FTerm.Echo(mbox.Body);
end;

procedure LoadSettings;
var
  info: TResourceInfo;
  strm: TStream;
  bin: TMemoryStream;
begin
  if Assigned(AppSettings) then
    Exit;
  if not GetResourceInfo(rsHTML, 'mycomp', info) then
  begin
    LoadHTMLLinkResources('termtest1-res.html');
    Exit;
  end;
  WriteLn(window.atob(info.data));
  AppSettings:=TAppSettings.Create(Nil);
  strm:=TStringStream.Create(window.atob(info.data));
  bin:=TMemoryStream.Create;
  ObjectTextToBinary(strm, bin);
  bin.Position:=0;
  bin.ReadComponent(AppSettings);
  bin.Free;
  strm.Free;
  WriteLn(AppSettings.DataString);
end;

end.

