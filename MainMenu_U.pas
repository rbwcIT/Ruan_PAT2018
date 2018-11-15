unit MainMenu_U;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, OrganizeMain_U, Convert_U, Edit_U, Vcl.Imaging.pngimage;

type
  TfrmMainMenu = class(TForm)
    pnlOrganize: TPanel;
    pnlEdit: TPanel;
    pnlConvert: TPanel;
    imgBG: TImage;
    procedure pnlOrganizeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pnlConvertClick(Sender: TObject);
    procedure pnlOrganizeMouseLeave(Sender: TObject);
    procedure pnlEditMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pnlEditMouseLeave(Sender: TObject);
    procedure pnlConvertMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pnlConvertMouseLeave(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pnlOrganizeClick(Sender: TObject);
    procedure pnlEditClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMainMenu: TfrmMainMenu;

implementation

{$R *.dfm}

{ TForm1 }


procedure TfrmMainMenu.pnlConvertMouseLeave(Sender: TObject);
begin
  pnlConvert.Height := 300;
  pnlConvert.Width := 310;              // maak panel kleiner
  pnlConvert.Left := 645;
  pnlConvert.Top := 5;
end;

procedure TfrmMainMenu.pnlConvertMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  pnlConvert.Height := 310;
  pnlConvert.Width := 320;
  pnlConvert.Left := 640;          // maak panel groter
  pnlConvert.Top := 0;
end;

procedure TfrmMainMenu.pnlEditClick(Sender: TObject);
begin
  frmImageEdit.Show;
  frmMainMenu.Hide;
end;

procedure TfrmMainMenu.pnlEditMouseLeave(Sender: TObject);
begin
  pnlEdit.Height := 300;
  pnlEdit.Width := 310;
  pnlEdit.Left := 325;             // maak panel kleiner
  pnlEdit.Top := 5;
end;

procedure TfrmMainMenu.pnlEditMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  pnlEdit.Height := 310;
  pnlEdit.Width := 320;
  pnlEdit.Left := 320;           // maak panel groter
  pnlEdit.Top := 0;
end;

procedure TfrmMainMenu.pnlOrganizeClick(Sender: TObject);
begin
  OrganizeMain_U.FormOrganizeMain.show;
  frmMainMenu.Hide;
end;

procedure TfrmMainMenu.pnlOrganizeMouseLeave(Sender: TObject);
begin
  pnlOrganize.Height := 300;
  pnlOrganize.Width := 310;         // maak panel kleiner
  pnlOrganize.Left := 5;
  pnlOrganize.Top := 5;
end;

procedure TfrmMainMenu.pnlOrganizeMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  pnlOrganize.Height := 310;
  pnlOrganize.Width := 320;
  pnlOrganize.Left := 0;         // maak panel groter
  pnlOrganize.Top := 0;
end;

procedure TfrmMainMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmMainMenu.pnlConvertClick(Sender: TObject);
begin
  Convert_U.frmConvert.Show;
  frmMainMenu.Hide;
end;

end.
