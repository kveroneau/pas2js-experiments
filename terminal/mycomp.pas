unit mycomp;

{$mode objfpc}

interface

uses
  Classes, SysUtils;

type
  TAppSettings = class(TComponent)
  private
    FDataString: string;
    FURL: string;
    FEnable: Boolean;
    FCount: integer;
  published
    property DataString: string read FDataString write FDataString;
    property URL: string read FURL write FURL;
    property Enable: boolean read FEnable write FEnable;
    property Count: integer read FCount write FCount;
  end;

implementation

end.

