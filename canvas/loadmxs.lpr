program loadmxs;

{$mode objfpc}

uses
  JS, Classes, SysUtils, Web, Rtl.BrowserLoadHelper;

var
  f: TMemoryStream;
  pal: array[0..255] of string;
  canvas: TJSHTMLCanvasElement;
  ctx: TJSCanvasRenderingContext2D;
  j, x, y, b: integer;

begin
  f:=TMemoryStream.Create;
  f.LoadFromFile('palettes.bin');
  f.ReadDWord;
  for j:=0 to 255 do
    pal[j]:='rgb('+IntToStr(f.ReadByte)+','+IntToStr(f.ReadByte)+','+IntToStr(f.ReadByte)+')';
  canvas:=TJSHTMLCanvasElement(document.getElementById('mxs'));
  ctx:=TJSCanvasRenderingContext2D(canvas.getContext('2d'));
  f.Position:=0;
  f.LoadFromFile('splash.mxs');
  for j:=0 to 3 do
  begin
    for y:=0 to 199 do
    begin
      x:=j;
      while x <= 319 do
      begin
        b:=f.ReadByte;
        ctx.fillStyle:=pal[b];
        ctx.fillRect(x*2,y*2,2,2);
        Inc(x,4);
      end;
    end;
  end;
end.

