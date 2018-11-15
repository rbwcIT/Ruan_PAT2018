unit OrganizeMain_U;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Data.DB, Data.Win.ADODB, Organize_U, dmData_U,
  Vcl.Imaging.pngimage, Vcl.Menus;

type
  TFormOrganizeMain = class(TForm)
    pnlFind: TPanel;
    pnlUseExisting: TPanel;
    imgBG: TImage;
    mmMainMenu: TMainMenu;
    N1: TMenuItem;
    Find1: TMenuItem;
    Organize1: TMenuItem;
    N3: TMenuItem;
    Close1: TMenuItem;
    Exit1: TMenuItem;
    procedure FileSearch(const dirName:string);
    procedure pnlFindClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pnlUseExistingClick(Sender: TObject);
    procedure pnlUseExistingMouseLeave(Sender: TObject);
    procedure pnlUseExistingMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pnlFindMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pnlFindMouseLeave(Sender: TObject);
    procedure Close1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormOrganizeMain: TFormOrganizeMain;
  dbIndex : Integer = 0;

implementation
uses
  MainMenu_U;

{$R *.dfm}

procedure TFormOrganizeMain.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Application.Terminate;
end;


procedure TFormOrganizeMain.pnlUseExistingMouseLeave(Sender: TObject);
begin
  pnlUseExisting.Height := 300;
  pnlUseExisting.Width := 310;
  pnlUseExisting.Left := 325;         // maak panel kleiner
  pnlUseExisting.Top := 5;
end;

procedure TFormOrganizeMain.pnlUseExistingMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  pnlUseExisting.Height := 310;
  pnlUseExisting.Width := 320;       // maak panel groter
  pnlUseExisting.Left := 320;
  pnlUseExisting.Top := 0;
end;

procedure TFormOrganizeMain.pnlFindMouseLeave(Sender: TObject);
begin
  pnlFind.Height := 300;
  pnlFind.Width := 310;            // maak panel kleiner
  pnlFind.Left := 5;
  pnlFind.Top := 5;
end;

procedure TFormOrganizeMain.pnlFindMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  pnlFind.Height := 310;            // maak panel groter
  pnlFind.Width := 320;
  pnlFind.Left := 0;
  pnlFind.Top := 0;
end;

procedure TFormOrganizeMain.pnlFindClick(Sender: TObject);
var
  startingfilename : string;
  SelectDlg : TFileOpenDialog;     // popup dialog wat folder select om in te search
begin
  SelectDlg := TFileOpenDialog.Create(nil);
  try
    SelectDlg.Options := [fdoPickFolders];
    if SelectDlg.Execute then
    begin
      startingfilename := SelectDlg.FileName;
      dbIndex := 0;

      with dmData_U.DataModule1 do
      begin
        tblAllFiles.Open;

        while not tblAllFiles.Eof do
          tblAllFiles.Delete;

        FileSearch(startingfilename);
      end;
    end
    else
    begin
      Exit;
    end;

  finally
    SelectDlg.Free;
  end;

  MessageDlg('Images found and stored', mtInformation, [], 0)
end;


procedure TFormOrganizeMain.pnlUseExistingClick(Sender: TObject);
begin
  Organize_U.frmOrganizeImages.Show;
  FormOrganizeMain.Hide;
end;

procedure TFormOrganizeMain.Close1Click(Sender: TObject);
begin
  FormOrganizeMain.Hide;
  frmMainMenu.show;
end;


//  recursive search function wat files soek wat sekere extentions het
procedure TFormOrganizeMain.FileSearch(const dirName:string);
var
  fileexts : TStringList;  // var om file extentions te store en v dit te check
  searchResult: TSearchRec;   // store search results
begin
  fileexts := TStringList.Create;
  fileexts.DelimitedText := '.jpg,.png,.bmp,.gif';    // formatted string

  if FindFirst(dirName+'\*', faAnyFile, searchResult)=0 then     // begin in directory search
  begin
    with dmData_U.DataModule1 do
    begin
      try
        repeat
          if (searchResult.Attr and faDirectory)=0 then      // as dit nie n directory is nie
          begin
            if fileexts.IndexOf(ExtractFileExt(searchResult.Name)) <> -1 then  // kyk of die file n image is
            begin
              tblAllfiles.open;
              tblAllFiles.Insert;
              Inc(dbIndex);                                              // save data in database
              tblAllFiles['ID'] := dbIndex;
              tblAllFiles['Filename'] := ExtractFileName(searchResult.Name);
              tblAllFiles['Filepath'] := dirName + '\' +searchResult.Name;
              tblAllFiles['Type'] := UpperCase(Copy(ExtractFileExt(searchResult.Name), 2, Length(ExtractFileExt(searchResult.Name))));
              tblAllFiles.Post;
            end;
          end
          else if (searchResult.Name<>'.') and (searchResult.Name<>'..') then    // as dit n directory is search hy dit ook
          begin
            FileSearch(dirName+ '\'+searchResult.Name);
          end;
        until FindNext(searchResult)<>0   // search tot daar nie meer files is nie
      finally
        tblAllFiles.Close;
        FindClose(searchResult);
      end;
    end;
  end;
end;

end.
