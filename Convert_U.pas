unit Convert_U;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,JPEG, Vcl.Imaging.pngimage, Vcl.Imaging.GIFImg,
  Vcl.Menus, ImageProcessing;

type
  TfrmConvert = class(TForm)
    btnChoosePhoto: TButton;
    lblConverTo: TLabel;
    imgDisplay: TImage;
    btnConvert: TButton;
    cbbFormat: TComboBox;
    img1: TImage;
    lblPreview: TLabel;
    mmOptions: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    procedure btnChoosePhotoClick(Sender: TObject);
    procedure btnConvertClick(Sender: TObject);


    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  JPG = 0;
  BMP = 1;
  PNG = 2;
  GIF = 3;

var
  frmConvert: TfrmConvert;
  filename : string;
  bImageSelected : Boolean = false;

implementation
uses
  MainMenu_U;

{$R *.dfm}

procedure TfrmConvert.btnChoosePhotoClick(Sender: TObject);
var
  openDialog : topendialog;
begin                                        // set dialog options
  openDialog := TOpenDialog.Create(self);
  openDialog.InitialDir := 'C:\Users\'+ GetEnvironmentVariable('USERNAME') +'\Pictures';
  openDialog.Options := [ofFileMustExist];
  openDialog.Filter := 'JPEG (*.jpg)|*.jpg|PNG (*.png)|*.png|BITMAP (*.bmp)|*.bmp|GIF (*.gif)|*.gif';
  openDialog.FilterIndex := 0;

  // Display dialog
  if openDialog.Execute
  then
  begin
    filename := openDialog.FileName;
    imgDisplay.Picture.LoadFromFile(filename);  // display die foto was gekies is
  end;

  bImageSelected := True;
  lblPreview.Caption := 'Preview';

  openDialog.Free;
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

    if FirstBytes = #137'PNG'#13#10#26#10 then      //  lees image data
      result := 'png';

    if Copy(FirstBytes, 1, 3) =  'GIF' then
      result := 'gif';

    if Copy(FirstBytes, 1, 2) = #$FF#$D8 then
      result := 'jpg';

  finally
    FS.Free;
  end;
end;

procedure TfrmConvert.btnConvertClick(Sender: TObject);
var
  contype : string;
begin
  if not bImageSelected then
  begin
    MessageDlg('Please select image to convert', mtError, [], 0);
    btnChoosePhoto.SetFocus;
    Exit;
  end;

  case cbbFormat.ItemIndex of
  -1 : begin
         MessageDlg('Please select an image type to convert to', mtError, [], 0);
         cbbFormat.SetFocus;
         Exit;
       end;

  0: ConvertIMG(filename, 'jpg');
  1: ConvertIMG(filename, 'bmp');
  2: ConvertIMG(filename, 'png');
  3: ConvertIMG(filename, 'gif');
  end;
end;

procedure TfrmConvert.Close1Click(Sender: TObject);
begin
  frmConvert.Hide;
  frmMainMenu.Show;
end;

procedure TfrmConvert.Exit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmConvert.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmConvert.FormShow(Sender: TObject);
begin
  lblPreview.Caption := '';
end;

procedure TfrmConvert.Open1Click(Sender: TObject);
begin
  btnChoosePhotoClick(nil);
end;

procedure TfrmConvert.Save1Click(Sender: TObject);
begin
  btnConvert.Click;
end;

procedure TfrmConvert.SaveAs1Click(Sender: TObject);
begin
  btnConvert.Click;
end;

end.
