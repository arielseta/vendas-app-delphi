unit Model.Interfaces;

interface

uses
  System.Generics.Collections;

type
  IModel = interface
    ['{6CE5407A-4A08-45FB-BD5B-7C1D47BE7B8E}']
  end;

  IDAO<T: class> = interface
    ['{B3D86B7E-6963-4E15-8E83-A19E8C4B3E8A}']
    function GetById(const AId: Integer): T;
    function GetAll: TObjectList<T>;
    procedure Insert(const AValue: T);
    procedure Update(const AValue: T);
    procedure Delete(const AId: Integer);
  end;

  IPedidoService = interface
    ['{7C5B0C04-8E2D-4A42-8A2D-0F8F7B9E0B1B}']
    procedure AddItem(AProdutoId: Integer; AQtde: Double; AValorUnit: Double);
    procedure EditItem(AIndex: Integer; AQtde: Double; AValorUnit: Double);
    procedure RemoveItem(AIndex: Integer);
    procedure NovoPedido;
    procedure CancelarPedido;
    function SalvarPedido(AClienteId: Integer): Integer; // retorna Numero do Pedido
    function TotalPedido: Double;
    function GetItensObject: TObject;
  end;

implementation

end.