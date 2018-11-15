unit Organize_U;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Vcl.Imaging.pngimage, ImageProcessing, dmData_U,
  Vcl.Menus;

type
 TfrmOrganizeImages = class(TForm)
    btnGroupInFolder: TButton;
    btnGroupTypes: TButton;
    btnGroupDate: TButton;
    btnGroupColour: TButton;
    btnGroupSize: TButton;
    mmMainMenu: TMainMenu;
    File1: TMenuItem;
    AllinOne1: TMenuItem;
    ype1: TMenuItem;
    Date1: TMenuItem;
    Colour1: TMenuItem;
    Siz1: TMenuItem;
    N1: TMenuItem;
    Close1: TMenuItem;
    Exit1: TMenuItem;
    imgBG: TImage;

    procedure btnGroupInFolderClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnGroupTypesClick(Sender: TObject);
    procedure btnGroupDateClick(Sender: TObject);
    procedure btnGroupColourClick(Sender: TObject);
    procedure btnGroupSizesClick(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure AllinOne1Click(Sender: TObject);
    procedure ype1Click(Sender: TObject);
    procedure Date1Click(Sender: TObject);
    procedure Colour1Click(Sender: TObject);
    procedure Siz1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOrganizeImages: TfrmOrganizeImages;

implementation
uses
  OrganizeMain_U;

{$R *.dfm}

procedure TfrmOrganizeImages.AllinOne1Click(Sender: TObject);
begin
  btnGroupInFolder.Click;
end;

procedure TfrmOrganizeImages.btnGroupColourClick(Sender: TObject);
var
  button : Integer;
  SelectDlg : TFileOpenDialog;
  destination, filepath, filename, avgcolor : string;
  ColorList : TStringList;
begin
  SelectDlg := TFileOpenDialog.Create(nil);    // dialog om file te kies
  SelectDlg.Options := [fdoPickFolders];

  if SelectDlg.Execute then
  begin
    destination := SelectDlg.FileName + '\';
    ShowMessage(destination);
  end
  else
  begin
    SelectDlg.Free;
    Exit;
  end;

  button := MessageDlg('Moving files. Press yes to continue, no to copy and cancel to stop whole process', mtConfirmation, [mbYes,mbNO,mbCancel], 0);
  if button = mrCancel then
  begin
    SelectDlg.Free;
    Exit;
  end;

  SetCurrentDir(destination);
  MkDir('Grouped by colour');
  destination := destination + 'Grouped by colour';
  SetCurrentDir(destination);

  ColorList := TStringList.Create;     // save die colors

  with OrganizeMain_U.FormOrganizeMain do
  begin
    with dmData_U.DataModule1 do
    begin
      tblAllFiles.Open;
      while not tblAllFiles.Eof do
      begin
        filepath := tblAllFiles['Filepath'] ;
        filename := tblAllFiles['Filename'];

        avgColor := colortostring(AverageColour(filepath));

        if ColorList.IndexOf(avgColor) = -1 then
        begin
          MkDir(avgColor);          // maak n new directory v n new color
          ColorList.Append(avgColor);
        end;

        case button of
        mrYes :  MoveFile(PChar(filepath), (PChar(destination + '\'+ avgColor +'\' + filename)));
        mrNo : CopyFile(PChar(filepath), (PChar(destination + '\'+ avgColor +'\' + filename)), true);
        end;

        tblAllFiles.Next;
      end;
    end;
  end;

  MessageDlg('Images organized', mtInformation, [], 0);
end;

procedure TfrmOrganizeImages.btnGroupDateClick(Sender: TObject);
var
  FileAttributes : TWin32FileAttributeData;
  LocalTime, SystemTime : TSystemTime;
  button : Integer;
  SelectDlg : TFileOpenDialog;
  destination, filepath, filename, year: string;
  DateList : TStringList;
begin
  SelectDlg := TFileOpenDialog.Create(nil);
  SelectDlg.Options := [fdoPickFolders];

  if SelectDlg.Execute then
  begin
    destination := SelectDlg.FileName + '\';
    ShowMessage(destination);
  end
  else
  begin
    SelectDlg.Free;
    Exit;
  end;

  button := MessageDlg('Moving files. Press yes to continue, no to copy and cancel to stop whole process', mtConfirmation, [mbYes,mbNO,mbCancel], 0);
  if button = mrCancel then
  begin
    SelectDlg.Free;
    Exit;
  end;

  SetCurrentDir(destination);
  MkDir('Grouped by date');
  destination := destination + 'Grouped by date';
  SetCurrentDir(destination);

  DateList := TStringList.Create;

  with OrganizeMain_U.FormOrganizeMain do
  begin
    with dmData_U.DataModule1 do
    begin
      tblAllFiles.Open;
      while not tblAllFiles.Eof do
      begin
        filepath := tblAllFiles['Filepath'] ;
        filename := tblAllFiles['Filename'];

        GetFileAttributesEx(PChar(filepath), GetFileExInfoStandard, @FileAttributes);
        FileTimeToSystemTime(FileAttributes.ftCreationTime, SystemTime);
        SystemTimeToTzSpecificLocalTime(nil, SystemTime, LocalTime);        // disgusting win api functions om filetime te kry
        DateTimeToString(year , 'yyyy', SystemTimeToDateTime(LocalTime));

        if DateList.IndexOf(year) = -1 then
        begin
          MkDir(year);
          DateList.Append(year);
        end;

        case button of
        mrYes :  MoveFile(PChar(filepath), (PChar(destination + '\'+ year +'\' + filename)));
        mrNo : CopyFile(PChar(filepath), (PChar(destination + '\'+ year +'\' + filename)), true);
        end;

        tblAllFiles.Next;
      end;
    end;
  end;

  MessageDlg('Images organized', mtInformation, [], 0);
end;

procedure TfrmOrganizeImages.btnGroupInFolderClick(Sender: TObject);
var
  button : Integer;
  SelectDlg : TFileOpenDialog;
  destination, filepath, filename: string;
begin
  SelectDlg := TFileOpenDialog.Create(nil);
  SelectDlg.Options := [fdoPickFolders];
  if SelectDlg.Execute then
  begin
    destination := SelectDlg.FileName + '\';
    //ShowMessage(destination);
  end
  else
  begin
    SelectDlg.Free;
    Exit;
  end;

  button := MessageDlg('Moving files. Press yes to continue, no to copy and cancel to stop whole process', mtConfirmation, [mbYes,mbNO,mbCancel], 0);
  if button = mrCancel then
  begin
    SelectDlg.Free;
    Exit;
  end;

  with OrganizeMain_U.FormOrganizeMain do
  begin
    with dmData_U.DataModule1 do
    begin
      tblAllFiles.Open;
      while not tblAllFiles.Eof do
      begin
        filepath := tblAllFiles['Filepath'] ;
        filename := tblAllFiles['Filename'];

        case button of
        mrYes :  MoveFile(PChar(filepath), (PChar(destination + filename)));
        mrNo : CopyFile(PChar(filepath), (PChar(destination + filename)), true);
        end;

        tblAllFiles.Next;
      end;
    end;
  end;

  MessageDlg('Images organized', mtInformation, [], 0);
end;


procedure TfrmOrganizeImages.btnGroupSizesClick(Sender: TObject);
var
  FileAttributes : TWin32FileAttributeData;
  button : Integer;
  SelectDlg : TFileOpenDialog;
  destination, filepath, filename, size: string;
  SizeList : TStringList;
begin
  SelectDlg := TFileOpenDialog.Create(nil);
  SelectDlg.Options := [fdoPickFolders];

  if SelectDlg.Execute then
  begin
    destination := SelectDlg.FileName + '\';
    ShowMessage(destination);
  end
  else
  begin
    SelectDlg.Free;
    Exit;
  end;

  button := MessageDlg('Moving files. Press yes to continue, no to copy and cancel to stop whole process', mtConfirmation, [mbYes,mbNO,mbCancel], 0);
  if button = mrCancel then
  begin
    SelectDlg.Free;
    Exit;
  end;

  SetCurrentDir(destination);
  MkDir('Grouped by sizes');
  destination := destination + 'Grouped by sizes';
  SetCurrentDir(destination);

  SizeList := TStringList.Create;

  with OrganizeMain_U.FormOrganizeMain do
  begin
    with dmData_U.DataModule1 do
    begin
      tblAllFiles.Open;
      while not tblAllFiles.Eof do
      begin
        filepath := tblAllFiles['Filepath'] ;
        filename := tblAllFiles['Filename'];

        GetFileAttributesEx(PChar(filename), GetFileExInfoStandard, @Fileattributes);  // win api

        size := IntToStr(FileAttributes.nFileSizeHigh);

        if SizeList.IndexOf(size) = -1 then
        begin
          MkDir(size);
          SizeList.Append(size);
        end;

        case button of
        mrYes :  MoveFile(PChar(filepath), (PChar(destination + '\'+ size +'\' + filename)));
        mrNo : CopyFile(PChar(filepath), (PChar(destination + '\'+ size +'\' + filename)), true);
        end;

        tblAllFiles.Next;
      end;
    end;
  end;

  MessageDlg('Images organized', mtInformation, [], 0);
end;

procedure TfrmOrganizeImages.btnGroupTypesClick(Sender: TObject);
var
  button : Integer;
  SelectDlg : TFileOpenDialog;
  filename, filepath, filetype, destination : string;
begin
  SelectDlg := TFileOpenDialog.Create(nil);
  SelectDlg.Options := [fdoPickFolders];

  if SelectDlg.Execute then
    destination := SelectDlg.FileName + '\'
  else
  begin
    SelectDlg.Free;
    Exit;
  end;


  button := MessageDlg('Moving files. Press yes to continue, no to copy and cancel to stop whole process', mtConfirmation, [mbYes,mbNO,mbCancel], 0);
  if button = mrCancel then
  begin
    SelectDlg.Free;
    Exit;
  end;

  SetCurrentDir(destination);
  MkDir('Grouped by type');
  destination := destination + 'Grouped by type';
  SetCurrentDir(destination);

  with OrganizeMain_U.FormOrganizeMain do
    begin
    with dmData_U.DataModule1 do
    begin
      tblAllFiles.Open;
      while not tblAllFiles.Eof do
      begin
        filepath := tblAllFiles['Filepath'] ;
        filename := tblAllFiles['Filename'];
        filetype := tblAllFiles['Type'];

        if not DirectoryExists(filetype) then
          MkDir(filetype);

        case button of
        mrYes :  MoveFile(PChar(filepath), (PChar(destination +'\'+ filetype +'\'  + filename)));
        mrNo : CopyFile(PChar(filepath), (PChar(destination +'\'+ filetype +'\'  + filename)), true);
        end;

        tblAllFiles.Next;
      end;
    end;
  end;

  MessageDlg('Images organized', mtInformation, [], 0);
end;


procedure TfrmOrganizeImages.Close1Click(Sender: TObject);
begin
  frmOrganizeImages.Hide;
  FormOrganizeMain.Show;
end;

procedure TfrmOrganizeImages.Colour1Click(Sender: TObject);
begin
  btnGroupColour.Click;
end;

procedure TfrmOrganizeImages.Date1Click(Sender: TObject);
begin
  btnGroupDate.Click;
end;

procedure TfrmOrganizeImages.Exit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmOrganizeImages.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmOrganizeImages.Siz1Click(Sender: TObject);
begin
  btnGroupSize.Click;
end;

procedure TfrmOrganizeImages.ype1Click(Sender: TObject);
begin
 btnGroupTypes.Click;
end;

end.
