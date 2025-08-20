unit Dao.PedidoItem;

interface

uses
  System.SysUtils, System.Generics.Collections, Model.Interfaces, Model.PedidoItem,
  FireDAC.Comp.Client, Data.DB, Config.DBConnection, FireDAC.Stan.Param;

type
  TDaoPedidoItem = class(TInterfacedObject, IDAO<TPedidoItem>)
  public
    function GetById(const AId: Integer): TPedidoItem;
    function GetAll: TObjectList<TPedidoItem>;
    function GetByPedido(const ANumeroPedido: Integer): TObjectList<TPedidoItem>;
    procedure Insert(const AValue: TPedidoItem);
    procedure Update(const AValue: TPedidoItem);
    procedure Delete(const AId: Integer);
  end;

implementation

{ TDaoPedidoItem }

procedure TDaoPedidoItem.Delete(const AId: Integer);
begin
  dmDB.FDConnection.ExecSQL('DELETE FROM pedidos_itens WHERE id = :id', [AId]);
end;

function TDaoPedidoItem.GetAll: TObjectList<TPedidoItem>;
begin
  Result := TObjectList<TPedidoItem>.Create(True);
end;

function TDaoPedidoItem.GetById(const AId: Integer): TPedidoItem;
var
  qry: TFDQuery;
begin
  Result := nil;
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := dmDB.FDConnection;
    qry.SQL.Text := 'select id, numero_pedido, codigo_produto, quantidade, valor_unitario, valor_total from pedidos_itens where id = :id';
    qry.ParamByName('id').AsInteger := AId;
    qry.Open;
    if not qry.IsEmpty then
    begin
      Result := TPedidoItem.Create;
      Result.Id := qry.FieldByName('id').AsInteger;
      Result.NumeroPedido := qry.FieldByName('numero_pedido').AsInteger;
      Result.CodigoProduto := qry.FieldByName('codigo_produto').AsInteger;
      Result.Quantidade := qry.FieldByName('quantidade').AsFloat;
      Result.ValorUnitario := qry.FieldByName('valor_unitario').AsFloat;
      Result.ValorTotal := qry.FieldByName('valor_total').AsFloat;
    end;
  finally
    qry.Free;
  end;
end;

function TDaoPedidoItem.GetByPedido(const ANumeroPedido: Integer): TObjectList<TPedidoItem>;
var
  qry: TFDQuery;
  it: TPedidoItem;
begin
  Result := TObjectList<TPedidoItem>.Create(True);

  qry := TFDQuery.Create(nil);
  try
    qry.Connection := dmDB.FDConnection;
    qry.SQL.Text := 'select id, numero_pedido, codigo_produto, quantidade, valor_unitario, valor_total from pedidos_itens where numero_pedido = :n';
    qry.ParamByName('n').AsInteger := ANumeroPedido;
    qry.Open;
    while not qry.Eof do
    begin
      it := TPedidoItem.Create;
      it.Id := qry.FieldByName('id').AsInteger;
      it.NumeroPedido := qry.FieldByName('numero_pedido').AsInteger;
      it.CodigoProduto := qry.FieldByName('codigo_produto').AsInteger;
      it.Quantidade := qry.FieldByName('quantidade').AsFloat;
      it.ValorUnitario := qry.FieldByName('valor_unitario').AsFloat;
      it.ValorTotal := qry.FieldByName('valor_total').AsFloat;
      Result.Add(it);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

procedure TDaoPedidoItem.Insert(const AValue: TPedidoItem);
begin
  dmDB.FDConnection.ExecSQL(
    'INSERT INTO pedidos_itens (numero_pedido, codigo_produto, quantidade, valor_unitario, valor_total) ' +
    'VALUES (:numero_pedido, :codigo_produto, :quantidade, :valor_unitario, :valor_total)',
    [AValue.NumeroPedido, AValue.CodigoProduto, AValue.Quantidade, AValue.ValorUnitario, AValue.ValorTotal]
  );
end;

procedure TDaoPedidoItem.Update(const AValue: TPedidoItem);
begin
  dmDB.FDConnection.ExecSQL(
    'UPDATE pedidos_itens SET quantidade = :quantidade, valor_unitario = :valor_unitario, valor_total = :valor_total WHERE id = :id',
    [AValue.Quantidade, AValue.ValorUnitario, AValue.ValorTotal, AValue.Id]
  );
end;

end.