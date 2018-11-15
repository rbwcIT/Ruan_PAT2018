unit ImageProcessing;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,JPEG, Vcl.Imaging.pngimage, Vcl.Imaging.GIFImg;

type
  PRGBTripleArray = ^TRGBTripleArray;
  TRGBTripleArray = array[0..4095] of TRGBTriple;

  function DetectImage(const InputFileName: string) : string;
  function ConvertIMG(filename ,convert_to : string) : string;
  function GetBitmap(filename : string) : TBitmap;
  function AverageColour(filename : string): TColor;
  procedure TreatRGB(var temp : Integer);
  function GetBitmapFromImage(image : TImage) : TBitmap;

implementation

procedure TreatRGB(var temp : Integer);
begin
  if temp<0 then
    temp:=0;

  if temp>255 then
   temp:=255;
end;

function DetectImage(const InputFileName: string) : string;
var
  FS: TFileStream;
  FirstBytes: AnsiString;
begin
  FS := TFileStream.Create(InputFileName, fmOpenRead);

  try
    SetLength(FirstBytes, 8);
    FS.Read(FirstBytes[1], 8);

    if Copy(FirstBytes, 1, 2) = 'BM' then
      result := 'bmp';

    if FirstBytes = #137'PNG'#13#10#26#10 then
      result := 'png';

    if Copy(FirstBytes, 1, 3) =  'GIF' then
      result := 'gif';

    if Copy(FirstBytes, 1, 2) = #$FF#$D8 then
      result := 'jpg';

  finally
    FS.Free;
  end;
end;

function ConvertIMG(filename ,convert_to : string) : string;
var
  dlgFilter : string;
  bmp : TBitmap;
  converted: TGraphic;
  saveDialog : TSaveDialog;
begin
  bmp := TBitmap.Create;

  bmp := getbitmap(filename);

  if (convert_to = 'jpg') then
  begin
    converted := TJPEGImage.Create;
    dlgFilter := 'JPG|*.jpg';
  end;

  if (convert_to = 'png') then
  begin
    converted := TPNGImage.Create;
    dlgFilter := 'PNG|*.png';
  end;

  if (convert_to = 'gif') then
  begin
    converted := TGIFImage.Create;
    dlgFilter := 'GIF|*.gif';
  end;

  if (convert_to = 'bmp') then
  begin
    converted := TBitmap.Create;
    dlgFilter := 'BMP|*.bmp';
  end;

  converted.Assign(bmp);

  saveDialog := TSaveDialog.Create(nil);
  saveDialog.Title := 'Save your image';

  saveDialog.InitialDir := 'C:\Users\'+ GetEnvironmentVariable('USERNAME') +'\Pictures';
  saveDialog.Filter := dlgFilter;
  saveDialog.DefaultExt := DetectImage(filename);

  if saveDialog.Execute
  then converted.SaveToFile(saveDialog.FileName)
  else Exit;

  MessageDlg('Image saved!', mtInformation, [], 0);
     //ShowMessage(saveDialog.FileName);
  Result := saveDialog.FileName;
end;

function GetBitmap(filename : string) : TBitmap;
var
  bmp : TBitmap;
  graphic : TGraphic;
begin
  if (DetectImage(filename) = 'jpg') then
    graphic := TJPEGImage.Create;

  if (DetectImage(filename) = 'png') then
    graphic := TPNGImage.Create;

  if (DetectImage(filename) = 'gif') then
    graphic := TGIFImage.Create;

  if (DetectImage(filename) = 'bmp') then
    graphic := TBitmap.Create;


  graphic.LoadFromFile(filename);
  bmp := TBitmap.Create;
  bmp.Assign(graphic);
  Result := bmp;
end;

function AverageColour(filename : string): TColor;
var
  bmp : TBitmap;
  x, y, r, g, b, pixels: Integer;
  row : PRGBTripleArray;
begin
  //ShowMessage(filename);
  bmp :=  TBitmap.Create;
  bmp := getBitMap(filename);
  bmp.pixelformat := pf24bit;

  for y := 0 to bmp.Height-1 do
  begin
    row := bmp.ScanLine[y];
    for x := 0 to bmp.Width -1 do
    begin                                        // tel al die pixel colours by mekaar en deel deer aantal pixels
      r := r + row[x].rgbtRed;
      g := g + row[x].rgbtGreen;
      b := b + row[x].rgbtBlue;
    end;
  end;
  pixels := bmp.Height*bmp.Width;
  r := r div pixels;
  g := g div pixels;
  b := b div pixels;

  Result:= rgb(r,g,b);
end;

function GetBitmapFromImage(image : TImage) : TBitmap;
var
  bmp : TBitmap;
  graphic : TGraphic;
begin
  bmp := TBitmap.Create;
  graphic := TGraphic.Create;
  graphic := image.Picture.Graphic;
  bmp.Assign(graphic);
  Result := bmp;
end;


end.
