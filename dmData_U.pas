unit dmData_U;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB, Vcl.Forms;

type
  TDataModule1 = class(TDataModule)
    conDatabase: TADOConnection;
    tblAllFiles: TADOTable;
    dsDataSource: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  conDatabase.connectionstring := '' +                             // build die string dynamically sodat dit nie error gee wanneer geskuif word nie
    'Provider=Microsoft.Jet.OLEDB.4.0;' +
    'Data Source=' + ExtractFileDir(Application.ExeName) + '\databases\fotos.mdb;' +
    'Persist Security Info=True';
  conDatabase.Connected := True;
  tblAllFiles.TableName := 'AllFiles';
  tblAllFiles.Active := True;
end;

end.
