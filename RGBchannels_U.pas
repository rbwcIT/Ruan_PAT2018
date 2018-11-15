unit RGBchannels_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,  Vcl.ExtCtrls, Vcl.Buttons,
  Vcl.Imaging.pngimage, ImageProcessing;

type
  TfrmRBG = class(TForm)
    scrlbrRed: TScrollBar;
    scrlbrBlue: TScrollBar;
    scrlbrGreen: TScrollBar;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    lblRed: TLabel;
    lblGreen: TLabel;
    lblBlue: TLabel;
    imgBG: TImage;

    procedure SetBrightness(Image: TImage);
    procedure scrlbrGreenChange(Sender: TObject);
    procedure scrlbrBlueChange(Sender: TObject);
    procedure scrlbrRedChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  frmRBG: TfrmRBG;
  OriginalImage, TemporaryImage: TImage;
  Applied : Boolean = False;


implementation

{$R *.dfm}

procedure TfrmRBG.scrlbrGreenChange(Sender: TObject);
var
i, j : Integer;
temp : integer;
pixelPointer : PByteArray;
originalPixelPointer : PByteArray;
begin
try
  begin
    for i := 0 to TemporaryImage.Picture.Height-1 do
    begin
      pixelPointer:=TemporaryImage.Picture.Bitmap.ScanLine[i];
      originalPixelPointer:=OriginalImage.Picture.Bitmap.ScanLine[i];

      for j := 0 to TemporaryImage.Picture.Width-1 do
      begin
        temp := originalPixelPointer[3*j+1] + scrlbrGreen.Position;

        if temp < 0 then
          temp := 0;

        if temp > 255 then
          temp := 255;    // moet byte value wees

        pixelPointer[3*j+1]:=temp;
      end;
    end;
    TemporaryImage.Refresh;
  end;
except
  begin
    Free;
    ShowMessage('Cannot complete the operation');
  end;
end ;
end;

procedure TfrmRBG.scrlbrRedChange(Sender: TObject);
var
i , j : Integer;
temp : integer;
pixelPointer : PByteArray;
originalPixelPointer : PByteArray;
begin
try
  begin
    for i := 0 to TemporaryImage.Picture.Height-1 do
    begin
      pixelPointer := TemporaryImage.Picture.Bitmap.ScanLine[i];
      originalPixelPointer := OriginalImage.Picture.Bitmap.ScanLine[i];

      for j:=0 to TemporaryImage.Picture.Width-1 do
      begin
        temp:=originalPixelPointer[3*j+2]+ scrlbrRed.Position;
        if temp < 0 then
          temp := 0;

        if temp > 255 then
        temp := 255;

        pixelPointer[3*j+2] := temp;
      end;
    end;
    TemporaryImage.Refresh;
  end ;
except
  begin
    Free;
    ShowMessage('Cannot complete the operation');
  end;
end;
end ;

procedure TfrmRBG.SetBrightness(Image: TImage);
begin
  try
    begin
      TemporaryImage := Image;
      OriginalImage := TImage.Create(self);
      //OriginalImage.Picture.Bitmap.Assign(Image.Picture.Bitmap);
      OriginalImage.Picture.Bitmap.Assign(GetBitmapFromImage(Image));
    end;
  except
    begin
      ShowMessage('Cannot complete the operation');
    end;
  end;
end;


procedure TfrmRBG.scrlbrBlueChange(Sender: TObject);
var
i,j:Integer;
temp:integer ;
pixelPointer:PByteArray;
originalPixelPointer:PByteArray;
begin
try
  begin
    for i:=0 to TemporaryImage.Picture.Height-1do
    begin
      pixelPointer := TemporaryImage.Picture.Bitmap.ScanLine[i];
      originalPixelPointer:=OriginalImage.Picture.Bitmap.ScanLine[i];

      for j:=0  to  TemporaryImage.Picture.Width-1 do
      begin
        temp:=originalPixelPointer[3*j] + scrlbrBlue.Position;

        if temp < 0  then
          temp := 0;

        if  temp > 255 then
        temp := 255;

        pixelPointer[3*j] :=temp;
      end;
    end;

    TemporaryImage.Refresh;
  end;
except
  begin
    Free;
    ShowMessage('Cannot complete the operation');
  end;
end;
end;

procedure TfrmRBG.btnOKClick(Sender: TObject);
begin
  Applied:= true;
  Close();
end;

procedure TfrmRBG.btnCancelClick(Sender: TObject);
begin
  Applied:= false;
  Close();
end;

procedure TfrmRBG.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not Applied then
    TemporaryImage.Picture.Graphic.Assign(OriginalImage.Picture.Graphic);
end;

end.

