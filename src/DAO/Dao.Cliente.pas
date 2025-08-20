unit Dao.Cliente;

interface

uses
  System.SysUtils, System.Generics.Collections, Model.Interfaces, Model.Cliente,
  FireDAC.Comp.Client, Data.DB, Config.DBConnection, FireDAC.Stan.Param;

type
  TDaoCliente = class(TInterfacedObject, IDAO<TCliente>)
  public
    function GetById(const AId: Integer): TCliente;
    function GetAll: TObjectList<TCliente>;
    procedure Insert(const AValue: TCliente);
    procedure Update(const AValue: TCliente);
    procedure Delete(const AId: Integer);
  end;

implementation

{ TDaoCliente }

procedure TDaoCliente.Delete(const AId: Integer);
begin
  dmDB.FDConnection.ExecSQL('delete from clientes where codigo = :id', [AId]);
end;

function TDaoCliente.GetAll: TObjectList<TCliente>;
var
  qry: TFDQuery;
  c: TCliente;
begin
  Result := TObjectList<TCliente>.Create(True);
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := dmDB.FDConnection;
    qry.SQL.Text := 'select codigo, nome, cidade, uf from clientes order by nome';
    qry.Open;
    while not qry.Eof do
    begin
      c := TCliente.Create;
      c.Codigo := qry.FieldByName('codigo').AsInteger;
      c.Nome := qry.FieldByName('nome').AsString;
      c.Cidade := qry.FieldByName('cidade').AsString;
      c.UF := qry.FieldByName('uf').AsString;
      Result.Add(c);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

function TDaoCliente.GetById(const AId: Integer): TCliente;
var
  qry: TFDQuery;
begin
  Result := nil;
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := dmDB.FDConnection;
    qry.SQL.Text := 'select codigo, nome, cidade, uf from clientes where codigo = :id';
    qry.ParamByName('id').AsInteger := AId;
    qry.Open;
    if not qry.IsEmpty then
    begin
      Result := TCliente.Create;
      Result.Codigo := qry.FieldByName('codigo').AsInteger;
      Result.Nome := qry.FieldByName('nome').AsString;
      Result.Cidade := qry.FieldByName('cidade').AsString;
      Result.UF := qry.FieldByName('uf').AsString;
    end;
  finally
    qry.Free;
  end;
end;

procedure TDaoCliente.Insert(const AValue: TCliente);
begin
  dmDB.FDConnection.ExecSQL(
    'INSERT INTO clientes (codigo, nome, cidade, uf) VALUES (:codigo, :nome, :cidade, :uf)',
    [AValue.Codigo, AValue.Nome, AValue.Cidade, AValue.UF]
  );
end;

procedure TDaoCliente.Update(const AValue: TCliente);
begin
  dmDB.FDConnection.ExecSQL(
    'UPDATE clientes SET nome = :nome, cidade = :cidade, uf = :uf WHERE codigo = :codigo',
    [AValue.Nome, AValue.Cidade, AValue.UF, AValue.Codigo]
  );
end;

end.