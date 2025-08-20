unit Dao.Produto;

interface

uses
  System.SysUtils, System.Generics.Collections, Model.Interfaces, Model.Produto,
  FireDAC.Comp.Client, Data.DB, Config.DBConnection, FireDAC.Stan.Param;

type
  TDaoProduto = class(TInterfacedObject, IDAO<TProduto>)
  public
    function GetById(const AId: Integer): TProduto;
    function GetAll: TObjectList<TProduto>;
    procedure Insert(const AValue: TProduto);
    procedure Update(const AValue: TProduto);
    procedure Delete(const AId: Integer);
  end;

implementation

{ TDaoProduto }

procedure TDaoProduto.Delete(const AId: Integer);
begin
  dmDB.FDConnection.ExecSQL('DELETE FROM produtos WHERE codigo = :id', [AId]);
end;

function TDaoProduto.GetAll: TObjectList<TProduto>;
var
  qry: TFDQuery;
  p: TProduto;
begin
  Result := TObjectList<TProduto>.Create(True);
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := dmDB.FDConnection;
    qry.SQL.Text := 'select codigo, descricao, preco_venda from produtos order by descricao';
    qry.Open;
    while not qry.Eof do
    begin
      p := TProduto.Create;
      p.Codigo := qry.FieldByName('codigo').AsInteger;
      p.Descricao := qry.FieldByName('descricao').AsString;
      p.PrecoVenda := qry.FieldByName('preco_venda').AsFloat;
      Result.Add(p);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

function TDaoProduto.GetById(const AId: Integer): TProduto;
var
  qry: TFDQuery;
begin
  Result := nil;
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := dmDB.FDConnection;
    qry.SQL.Text := 'select codigo, descricao, preco_venda from produtos where codigo = :id';
    qry.ParamByName('id').AsInteger := AId;
    qry.Open;
    if not qry.IsEmpty then
    begin
      Result := TProduto.Create;
      Result.Codigo := qry.FieldByName('codigo').AsInteger;
      Result.Descricao := qry.FieldByName('descricao').AsString;
      Result.PrecoVenda := qry.FieldByName('preco_venda').AsFloat;
    end;
  finally
    qry.Free;
  end;
end;

procedure TDaoProduto.Insert(const AValue: TProduto);
begin
  dmDB.FDConnection.ExecSQL(
    'INSERT INTO produtos (codigo, descricao, preco_venda) VALUES (:codigo, :descricao, :preco_venda)',
    [AValue.Codigo, AValue.Descricao, AValue.PrecoVenda]
  );
end;

procedure TDaoProduto.Update(const AValue: TProduto);
begin
  dmDB.FDConnection.ExecSQL(
    'UPDATE produtos SET descricao = :descricao, preco_venda = :preco_venda WHERE codigo = :codigo',
    [AValue.Descricao, AValue.PrecoVenda, AValue.Codigo]
  );
end;

end.