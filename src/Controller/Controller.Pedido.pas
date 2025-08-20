unit Controller.Pedido;

interface

uses
  System.SysUtils, System.Generics.Collections,
  Model.Interfaces, Model.Pedidos, Model.PedidoItem,
  Dao.Pedidos, Dao.PedidoItem, Dao.Produto, Config.DBConnection;

type
  TPedidoController = class(TInterfacedObject, IPedidoService)
  private
    FPedido: TModelPedidos;
    FItens: TObjectList<TPedidoItem>;
    FDaoPedido: TDaoPedido;
    FDaoItem: TDaoPedidoItem;
    FDaoProduto: TDaoProduto;
    procedure RecalcularTotal;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddItem(AProdutoId: Integer; AQtde: Double; AValorUnit: Double);
    procedure EditItem(AIndex: Integer; AQtde: Double; AValorUnit: Double);
    procedure RemoveItem(AIndex: Integer);
    procedure NovoPedido;
    procedure CancelarPedido;
    function SalvarPedido(AClienteId: Integer): Integer;
    function TotalPedido: Double;
    function GetItensObject: TObject;
  end;

implementation

{ TPedidoController }

procedure TPedidoController.AddItem(AProdutoId: Integer; AQtde: Double; AValorUnit: Double);
var
  it: TPedidoItem;
begin
  it := TPedidoItem.Create;
  it.NumeroPedido := FPedido.Numero;
  it.CodigoProduto := AProdutoId;
  it.Quantidade := AQtde;
  it.ValorUnitario := AValorUnit;
  it.ValorTotal := AQtde * AValorUnit;
  FItens.Add(it);
  RecalcularTotal;
end;

procedure TPedidoController.CancelarPedido;
begin
  FItens.Clear;
  FPedido := nil;
end;

constructor TPedidoController.Create;
begin
  FDaoPedido := TDaoPedido.Create;
  FDaoItem := TDaoPedidoItem.Create;
  FDaoProduto := TDaoProduto.Create;
  FItens := TObjectList<TPedidoItem>.Create(True);
end;

destructor TPedidoController.Destroy;
begin
  FItens.Free;
  FDaoProduto.Free;
  FDaoItem.Free;
  FDaoPedido.Free;
  inherited;
end;

procedure TPedidoController.EditItem(AIndex: Integer; AQtde: Double; AValorUnit: Double);
var
  item: TPedidoItem;
begin
  if (AIndex >= 0) and (AIndex < FItens.Count) then
  begin
    item := FItens[AIndex];
    item.Quantidade := AQtde;
    item.ValorUnitario := AValorUnit;
    item.ValorTotal := AQtde * AValorUnit;
  end;
  RecalcularTotal;
end;

procedure TPedidoController.NovoPedido;
begin
  FPedido := TModelPedidos.Create;
  FPedido.Numero := FDaoPedido.ProximoNumeroPedido;
  FPedido.DataEmissao := Now;
  FPedido.CodigoCliente := 0;
  FPedido.ValorTotal := 0;
  FItens.Clear;
end;

procedure TPedidoController.RecalcularTotal;
var
  it: TPedidoItem;
  total: Double;
begin
  total := 0;
  for it in FItens do
    total := total + it.ValorTotal;
  if Assigned(FPedido) then
    FPedido.ValorTotal := total;
end;

function TPedidoController.SalvarPedido(AClienteId: Integer): Integer;
var
  it: TPedidoItem;
begin
  if not Assigned(FPedido) then
    raise Exception.Create('Nenhum pedido em edição.');

  FPedido.CodigoCliente := AClienteId;
  dmDB.FDConnection.StartTransaction;
  try
    // Grava cabeçalho
    FDaoPedido.Insert(FPedido);

    // Grava itens
    for it in FItens do
    begin
      it.NumeroPedido := FPedido.Numero;
      FDaoItem.Insert(it);
    end;

    dmDB.FDConnection.Commit;
    Result := FPedido.Numero;
  except
    on E: Exception do
    begin
      if dmDB.FDConnection.InTransaction then
        dmDB.FDConnection.Rollback;
      raise;
    end;
  end;
end;

function TPedidoController.TotalPedido: Double;
begin
  if Assigned(FPedido) then
    Result := FPedido.ValorTotal
  else
    Result := 0;
end;

procedure TPedidoController.RemoveItem(AIndex: Integer);
begin
  FItens.Delete(AIndex - 1);
  RecalcularTotal;
end;

function TPedidoController.GetItensObject: TObject;
begin
  Result := FItens;
end;

end.
