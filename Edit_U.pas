unit Edit_U;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, Vcl.ExtDlgs,
  Vcl.ComCtrls, ImageProcessing, Vcl.Imaging.pngimage, RGBchannels_U, Brightness_U, ContrastForm_U;

type
  TfrmImageEdit = class(TForm)
    mmMainMenu: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    Close: TMenuItem;
    RGBchannel: TMenuItem;
    Edit: TMenuItem;
    Brightness1: TMenuItem;
    InvertColours1: TMenuItem;
    Contrast1: TMenuItem;
    Grayscale1: TMenuItem;
    imgDisplay: TImage;
    statInfo: TStatusBar;
    Save1: TMenuItem;
    Saveas1: TMenuItem;
    tmrRepaint: TTimer;
    procedure Open1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseClick(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure imgDisplayMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgDisplayMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgDisplayMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tmrRepaintTimer(Sender: TObject);
    procedure RGBchannelClick(Sender: TObject);
    procedure Brightness1Click(Sender: TObject);
    procedure Contrast1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure InvertColours1Click(Sender: TObject);
    procedure Grayscale1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmImageEdit: TfrmImageEdit;
  bSaved : Boolean = False;
  bOpened : Boolean = False;
  bDrawmode : Boolean = False;
  bDrawing : Boolean = False;
  filename, savedname : string;
  dX, dY : Integer;

implementation
uses
  MainMenu_U;

{$R *.dfm}

procedure TfrmImageEdit.Brightness1Click(Sender: TObject);
begin
  frmBrightness.SetBrightness(imgDisplay);
  frmBrightness.ShowModal;
end;

procedure TfrmImageEdit.CloseClick(Sender: TObject);
begin
  frmImageEdit.Hide;
  frmMainMenu.Show;
end;

procedure TfrmImageEdit.Contrast1Click(Sender: TObject);
begin
  ContrastForm.SetContrast(imgDisplay);
  ContrastForm.ShowModal;
end;

procedure TfrmImageEdit.Exit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmImageEdit.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmImageEdit.FormShow(Sender: TObject);
begin
  imgDisplay.Picture.LoadFromFile(ExtractFileDir(Application.ExeName)+'\Assets\NoImage.png');
  frmImageEdit.ClientWidth := imgDisplay.Picture.Width;
  frmImageEdit.ClientHeight := imgDisplay.Picture.Height;
end;

procedure TfrmImageEdit.Grayscale1Click(Sender: TObject);
var
  i,j:integer;
  ptr:PByteArray;
begin
  try
    for i:=0 to (imgDisplay.Height-1) do
    begin
      ptr:=imgDisplay.Picture.Bitmap.ScanLine[i];
      for j:=0 to (imgDisplay.Width-1) do
      begin
        ptr[3*j]:=round(0.114* ptr[3*j]+0.587*ptr[3*j+1] + 0.299*ptr[3*j+2]); //NTSC formule vir grayscale effect
        ptr[3*j+1]:=ptr[3*j];
        ptr[3*j+2]:=ptr[3*j];
      end;

    end;
    imgDisplay.Refresh;
  except
    ShowMessage('Cannot complete the operation');
  end
end;

procedure TfrmImageEdit.imgDisplayMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if bDrawmode then
  begin
    bDrawing := True;
    dX := X;
    dY := Y;
  end;
end;

procedure TfrmImageEdit.imgDisplayMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if bDrawmode and bDrawing then
  begin
    with imgDisplay do
    begin
      Canvas.MoveTo(dX, dY);
      Canvas.LineTo(X, Y);

      dX := X;
      dY := Y;
    end;
  end;
end;

procedure TfrmImageEdit.imgDisplayMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if bDrawmode then
  begin
     with imgDisplay do
    begin
      Canvas.MoveTo(dX, dY);
      Canvas.LineTo(X, Y);

      dX := X;
      dY := Y;
    end;
    bDrawing := False;
  end;
end;

procedure TfrmImageEdit.InvertColours1Click(Sender: TObject);

var
  i,j:integer;
  ptr:PByteArray;
begin
  try
    for i:=0 to (imgDisplay.Height-1) do
    begin
      ptr:=imgDisplay.Picture.Bitmap.ScanLine[i];  // pointer vir pixels
      for j:=0 to (imgDisplay.Width-1) do
      begin
        ptr[3*j]:=255-ptr[3*j];          // blou
        ptr[3*j+1]:=255-ptr[3*j+1];      //groen
        ptr[3*j+2]:=255-ptr[3*j+2];      // rooi
      end;
    end;
     imgDisplay.Refresh;
  except
    ShowMessage('Cannot complete the operation');
  end
end;


procedure TfrmImageEdit.New1Click(Sender: TObject);
var
  bmp : TBitmap;
begin
  bOpened := True;

  statInfo.Panels[0].Text := 'Unsaved image' + '    ' + IntToStr(frmImageEdit.Width) +'x'+ IntToStr(frmImageEdit.Height);

  bmp := TBitmap.Create;
  imgDisplay.Picture.Bitmap;

  bDrawmode := True;
end;

procedure TfrmImageEdit.Open1Click(Sender: TObject);
var
  OpenDialog : TOpenDialog;
begin
  openDialog := TOpenDialog.Create(self);
  openDialog.InitialDir := 'C:\Users\'+ GetEnvironmentVariable('USERNAME') +'\Pictures';
  openDialog.Options := [ofFileMustExist];
  openDialog.Filter := 'BITMAP (*.bmp)|*.bmp';
  openDialog.FilterIndex := 0;

  if OpenDialog.Execute() then
  begin
    filename := OpenDialog.FileName;
  end
  else
    Exit;

  imgDisplay.Picture.LoadFromFile(filename);
  frmImageEdit.ClientWidth := imgDisplay.Picture.Width;
  frmImageEdit.ClientHeight := imgDisplay.Picture.Height;

  bOpened := True;

  statInfo.Panels[0].Text  := filename + '    ' + IntToStr(imgDisplay.Picture.Width) +'x'+ IntToStr(imgDisplay.Picture.Height);
end;

procedure TfrmImageEdit.RGBchannelClick(Sender: TObject);
begin
  frmRBG.SetBrightness(imgDisplay);
  frmRBG.ShowModal;
end;

procedure TfrmImageEdit.Save1Click(Sender: TObject);
var
  bmp : TBitmap;
  png : TPngImage;
begin
  if not bOpened then
  begin
    MessageDlg('No image to save. Open ons first', mtError, [], 0);
    Exit;
  end;

  if not bSaved then
  begin
    Saveas1.Click;
    Exit;
  end;

  bmp := TBitmap.Create;
  bmp := GetBitmapFromImage(imgDisplay);
  png := TPNGImage.Create;
  png.Assign(bmp);
  DeleteFile(savedname) ;
  png.SaveToFile(savedname) ;
end;

procedure TfrmImageEdit.Saveas1Click(Sender: TObject);
var
  bmp : TBitmap;
  png : TPngImage;
  savedialog : TSaveDialog;
begin
  if not bOpened then
  begin
    MessageDlg('No image to save. Open ons first', mtError, [], 0);
    Exit;
  end;


  savedname := ConvertIMG(filename, 'png');

  bSaved := True;
end;
procedure TfrmImageEdit.tmrRepaintTimer(Sender: TObject);
begin
  imgDisplay.Refresh;
  imgDisplay.Repaint;
end;

end.
