unit Brightness_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Buttons,  ImageProcessing;

type
  TfrmBrightness = class(TForm)
    scrlbrBrightness: TScrollBar;
    lblBrightness: TLabel;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    imgBG: TImage;
    procedure SetBrightness(Image: TImage);
    procedure scrlbrBrightnessChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBrightness: TfrmBrightness;
  OriginalImage, TemporaryImage: TImage;
  Applied : Boolean = False;

 {$R *.dfm}

implementation

procedure TfrmBrightness.SetBrightness(Image: TImage);
begin
  try
    begin
      TemporaryImage := Image;
      OriginalImage := TImage.Create(self);
      OriginalImage.Picture.Bitmap.Assign(GetBitmapFromImage(Image));
    end;
  except
    begin
      ShowMessage('Cannot complete the operation');
    end;
  end;
end;


procedure TfrmBrightness.scrlbrBrightnessChange(Sender: TObject);
var
i,j:Integer;
tempgreen, tempred, tempblue:integer;
pixelPointer:PByteArray;
originalPixelPointer:PByteArray;
begin
try
  begin
    for i:=0 to TemporaryImage.Picture.Height-1 do
    begin
      pixelPointer:=TemporaryImage.Picture.Bitmap.ScanLine[i];
      originalPixelPointer:=OriginalImage.Picture.Bitmap.ScanLine[i];

      for j:=0 to TemporaryImage.Picture.Width-1 do
      begin
        tempgreen:= originalPixelPointer[3*j+1]+ scrlbrBrightness.Position;
        tempred:= originalPixelPointer[3*j+2]+ scrlbrBrightness.Position;
        tempblue:= originalPixelPointer[3*j]+ scrlbrBrightness.Position;

        TreatRGB(tempred);
        TreatRGB(tempgreen);
        TreatRGB(tempblue);

        pixelPointer[3*j+1]:=tempgreen;
        pixelPointer[3*j+2]:=tempred;
        pixelPointer[3*j]:=tempblue;
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

procedure TfrmBrightness.btnOKClick(Sender: TObject);
begin
  Applied:= true;
  Close();
end;

procedure TfrmBrightness.btnCancelClick(Sender: TObject);
begin
  Applied:= false;
  Close();
end;

procedure TfrmBrightness.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if not Applied then
    TemporaryImage.Picture.Graphic.Assign(OriginalImage.Picture.Graphic);
end;

end.





