program Fase3_P;

{$R *.dres}

uses
  Forms,
  MainMenu_U in 'MainMenu_U.pas' {frmMainMenu},
  OrganizeMain_U in 'OrganizeMain_U.pas' {FormOrganizeMain},
  Organize_U in 'Organize_U.pas' {frmOrganizeImages},
  Convert_U in 'Convert_U.pas' {frmConvert},
  ImageProcessing in 'ImageProcessing.pas',
  Edit_U in 'Edit_U.pas' {frmImageEdit},
  RGBchannels_U in 'RGBchannels_U.pas' {frmRBG},
  Brightness_U in 'Brightness_U.pas' {frmBrightness},
  ContrastForm_U in 'ContrastForm_U.pas' {ContrastForm},
  dmData_U in 'dmData_U.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMainMenu, frmMainMenu);
  Application.CreateForm(TFormOrganizeMain, FormOrganizeMain);
  Application.CreateForm(TfrmOrganizeImages, frmOrganizeImages);
  Application.CreateForm(TfrmConvert, frmConvert);
  Application.CreateForm(TfrmImageEdit, frmImageEdit);
  Application.CreateForm(TfrmRBG, frmRBG);
  Application.CreateForm(TfrmBrightness, frmBrightness);
  Application.CreateForm(TContrastForm, ContrastForm);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
