unit Model.Pedidos;

interface

uses System.Generics.Collections, Model.Interfaces;

type
  TModelPedidos = class(TInterfacedObject, IModel)
  private
    FNumero: Integer;
    FDataEmissao: TDateTime;
    FCodigoCliente: Integer;
    FValorTotal: Double;
  public
    property Numero: Integer read FNumero write FNumero;
    property DataEmissao: TDateTime read FDataEmissao write FDataEmissao;
    property CodigoCliente: Integer read FCodigoCliente write FCodigoCliente;
    property ValorTotal: Double read FValorTotal write FValorTotal;
  end;

implementation

end.