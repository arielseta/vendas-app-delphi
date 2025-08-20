unit Dao.Pedidos;

interface

uses
  System.SysUtils, System.Generics.Collections, Model.Interfaces, Model.Pedidos,
  FireDAC.Comp.Client, Data.DB, Config.DBConnection, FireDAC.Stan.Param;

type
  TDaoPedido = class(TInterfacedObject, IDAO<TModelPedidos>)
  public
    function GetById(const AId: Integer): TModelPedidos;
    function GetAll: TObjectList<TModelPedidos>;
    function GetByCliente(const ACliente: Integer): TObjectList<TModelPedidos>;
    procedure Insert(const AValue: TModelPedidos);
    procedure Update(const AValue: TModelPedidos);
    procedure Delete(const AId: Integer);
    function ProximoNumeroPedido: Integer;
  end;

implementation

{ TDaoPedido }

procedure TDaoPedido.Delete(const AId: Integer);
begin
  dmDB.FDConnection.ExecSQL('DELETE FROM pedidos WHERE numero = :id', [AId]);
  dmDB.FDConnection.ExecSQL('DELETE FROM pedidos_itens WHERE numero_pedido = :id', [AId]);
end;

function TDaoPedido.GetAll: TObjectList<TModelPedidos>;
var
  qry: TFDQuery;
  p: TModelPedidos;
begin
  Result := TObjectList<TModelPedidos>.Create(True);
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := dmDB.FDConnection;
    qry.SQL.Text := 'select numero, data_emissao, codigo_cliente, valor_total from pedidos order by numero desc';
    qry.Open;
    while not qry.Eof do
    begin
      p := TModelPedidos.Create;
      p.Numero := qry.FieldByName('numero').AsInteger;
      p.DataEmissao := qry.FieldByName('data_emissao').AsDateTime;
      p.CodigoCliente := qry.FieldByName('codigo_cliente').AsInteger;
      p.ValorTotal := qry.FieldByName('valor_total').AsFloat;
      Result.Add(p);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

function TDaoPedido.GetByCliente(const ACliente: Integer): TObjectList<TModelPedidos>;
var
  qry: TFDQuery;
  p: TModelPedidos;
begin
  Result := TObjectList<TModelPedidos>.Create(True);
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := dmDB.FDConnection;
    qry.SQL.Text := 'select numero, data_emissao, codigo_cliente, valor_total from pedidos where codigo_cliente = :codigo_cliente order by numero desc';
    qry.ParamByName('codigo_cliente').AsInteger := ACliente;
    qry.Open;
    while not qry.Eof do
    begin
      p := TModelPedidos.Create;
      p.Numero := qry.FieldByName('numero').AsInteger;
      p.DataEmissao := qry.FieldByName('data_emissao').AsDateTime;
      p.CodigoCliente := qry.FieldByName('codigo_cliente').AsInteger;
      p.ValorTotal := qry.FieldByName('valor_total').AsFloat;
      Result.Add(p);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

function TDaoPedido.GetById(const AId: Integer): TModelPedidos;
var
  qry: TFDQuery;
begin
  Result := nil;
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := dmDB.FDConnection;
    qry.SQL.Text := 'select numero, data_emissao, codigo_cliente, valor_total from pedidos where numero = :id';
    qry.ParamByName('id').AsInteger := AId;
    qry.Open;
    if not qry.IsEmpty then
    begin
      Result := TModelPedidos.Create;
      Result.Numero := qry.FieldByName('numero').AsInteger;
      Result.DataEmissao := qry.FieldByName('data_emissao').AsDateTime;
      Result.CodigoCliente := qry.FieldByName('codigo_cliente').AsInteger;
      Result.ValorTotal := qry.FieldByName('valor_total').AsFloat;
    end;
  finally
    qry.Free;
  end;
end;

procedure TDaoPedido.Insert(const AValue: TModelPedidos);
begin
  dmDB.FDConnection.ExecSQL(
    'INSERT INTO pedidos (numero, data_emissao, codigo_cliente, valor_total) VALUES (:numero, :data_emissao, :codigo_cliente, :valor_total)',
    [AValue.Numero, AValue.DataEmissao, AValue.CodigoCliente, AValue.ValorTotal]
  );
end;

function TDaoPedido.ProximoNumeroPedido: Integer;
var
  qry: TFDQuery;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := dmDB.FDConnection;
    qry.SQL.Text := 'update seq_pedidos set numero = numero + 1; select numero from seq_pedidos;';
    qry.Open;
  finally
    qry.Free;
  end;
  Result := dmDB.FDConnection.ExecSQLScalar('SELECT numero + 1 FROM seq_pedidos');
  dmDB.FDConnection.ExecSQL('UPDATE seq_pedidos SET numero = :n', [Result]);
end;

procedure TDaoPedido.Update(const AValue: TModelPedidos);
begin
  dmDB.FDConnection.ExecSQL(
    'update pedidos set data_emissao = :data_emissao, codigo_cliente = :codigo_cliente, valor_total = :valor_total where numero = :numero',
    [AValue.DataEmissao, AValue.CodigoCliente, AValue.ValorTotal, AValue.Numero]
  );
end;

end.