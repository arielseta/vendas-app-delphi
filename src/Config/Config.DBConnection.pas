unit Config.DBConnection;
interface
uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Comp.Client,
  FireDAC.VCLUI.Wait, FireDAC.DApt, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  Data.DB, Vcl.Dialogs, System.UITypes;
type
  TdmDB = class(TDataModule)
    FDConnection: TFDConnection;
    FDTransaction: TFDTransaction;
  private
    procedure ConfigureSQLite;
  public
    procedure InitializeDatabase;
  end;
var
  dmDB: TdmDB;
implementation
{$R *.dfm}
uses
  System.IOUtils, Vcl.Forms;
procedure TdmDB.ConfigureSQLite;
var
  DBPath: string;
begin
  DBPath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'vendas.db');
  FDConnection.Params.Clear;
  FDConnection.Params.DriverID := 'SQLite';
  FDConnection.Params.Database := DBPath;
  FDConnection.Params.Add('LockingMode=Normal');
  FDConnection.LoginPrompt := False;
end;
procedure TdmDB.InitializeDatabase;
var
  SL: TStringList;
  SchemaPath: string;
begin
  ConfigureSQLite;
  FDConnection.Connected := True;
  // Caminho do schema.sql relativo à pasta raiz do projeto
  SchemaPath := TPath.Combine(TPath.GetDirectoryName(ParamStr(0)), '..\..\src\SQL\schema.sql');
  SchemaPath := TPath.GetFullPath(SchemaPath);

  if not FileExists(SchemaPath) then
  begin
    MessageDlg(Format('Arquivo schema.sql não encontrado em: %s', [SchemaPath]), mtError, [mbOK], 0);
    Application.Terminate; // encerra a aplicação
    Exit;
  end;
  SL := TStringList.Create;
  try
    SL.LoadFromFile(SchemaPath);
    FDConnection.ExecSQL(SL.Text);
  except
    on E: Exception do
    begin
      if Pos('already exists', E.Message) = 0 then
      begin
        MessageDlg('Erro ao inicializar o banco: ' + E.Message, mtError, [mbOK], 0);
        Application.Terminate;
        Exit;
      end;
    end;
  end;
  SL.Free;
end;
end.