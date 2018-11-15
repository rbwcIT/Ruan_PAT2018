unit ContrastForm_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.Buttons;

type
  TContrastForm = class(TForm)
    scrlbrContrast: TScrollBar;
    scrlbrCenter: TScrollBar;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    imgBG: TImage;
    lblContrast: TLabel;
    lblCenter: TLabel;
    procedure SetContrast(Image: TImage);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure scrlbrCenterChange(Sender: TObject);
  //  procedure scrlbrContrastChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ContrastForm : TContrastForm;
  TemporaryImage : TImage;
  OriginalImage : TImage;
  Applied : boolean;
implementation

{$R *.dfm}


// hierdie operations kan net met bitmaps gedoen word
// daar is 2 algemene formats pf8bit en pf24bit
// 8bit het net 1 color channel en net 1 operation hoef gedeon te word om hom te trabnsform
// 24bit het 3 channels en operations moet gedoen word op R G en B apart

procedure TContrastForm.btnCancelClick(Sender: TObject);
begin
  Applied:=false;
  Close();
end;

procedure TContrastForm.scrlbrCenterChange(Sender: TObject);
var
  i,j:Integer;
  temp:real;
  pixelPointer:PByteArray;
  originalPixelPointer:PByteArray;
begin
  try
    begin
      if TemporaryImage.Picture.Bitmap.PixelFormat=pf8bit then
      for i:=0 to TemporaryImage.Picture.Height-1 do
      begin
        pixelPointer:=TemporaryImage.Picture.Bitmap.ScanLine[i];
        originalPixelPointer:=OriginalImage.Picture.Bitmap.ScanLine[i];

        for j:=0 to TemporaryImage.Picture.Width-1 do
        begin
          // formule vir contrast
          temp:=((originalPixelPointer[j]-scrlbrCenter.Position) * exp(scrlbrContrast.Position/50) + scrlbrCenter.Position;

          if temp < 0 then
            temp:=0;

          if temp > 255 then
            temp:=255;

          pixelPointer[j]:=round(temp);
        end;
      end;

      if TemporaryImage.Picture.Bitmap.PixelFormat=pf24bit then
      for i:=0 to TemporaryImage.Picture.Height-1 do
      begin
        pixelPointer:=TemporaryImage.Picture.Bitmap.ScanLine[i];
        originalPixelPointer:=OriginalImage.Picture.Bitmap.ScanLine[i];

        for j:=0 to TemporaryImage.Picture.Width-1 do
        begin                            //blou
          temp:=((originalPixelPointer[3*j]-scrlbrCenter.Position)*exp(scrlbrContrast.Position/50))+ scrlbrCenter.Position;

          if temp < 0 then
            temp := 0;

          if temp > 255 then
           temp := 255;

          pixelPointer[3*j]:=round(temp); // blou

          //groen
          temp:=((originalPixelPointer[3*j+1]-scrlbrCenter.Position)*exp(scrlbrContrast.Position/50))+ scrlbrCenter.Position;
          if temp < 0 then
            temp := 0;

          if temp > 255 then
           temp := 255;
                         //groen
          pixelPointer[3*j+1]:=round(temp);

          temp:=((originalPixelPointer[3*j+2]-scrlbrCenter.Position)*exp(scrlbrContrast.Position/50)) + scrlbrCenter.Position;
                                         //blou
          if temp < 0 then
            temp := 0;

          if temp > 255 then
           temp := 255;
                               //blou
          pixelPointer[3*j+2]:=round(temp);
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

procedure TContrastForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Applied=false then
    TemporaryImage.Picture.Bitmap.Assign(OriginalImage.Picture.Bitmap);

end;

procedure TContrastForm.btnOKClick(Sender: TObject);
begin
  Applied:=true;
  Close();
end;


procedure TContrastForm.SetContrast(Image: TImage);
begin
  try
    begin
      TemporaryImage:=Image;
      OriginalImage:=TImage.Create(self);
      OriginalImage.Picture.Bitmap.Assign(Image.Picture.Bitmap);
    end;
  except
    begin
      Free;
      ShowMessage('Cannot complete the operation');
    end;
  end;
end;

end.
