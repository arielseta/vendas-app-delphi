program VendasApp;

uses
  Vcl.Forms,
  Config.DBConnection in 'src\Config\Config.DBConnection.pas' {dmDB: TDataModule},
  View.Principal in 'src\View\View.Principal.pas' {frmPrincipal},
  View.ConsultaPedidos in 'src\View\View.ConsultaPedidos.pas' {frmConsultaPedidos},
  View.Pedidos in 'src\View\View.Pedidos.pas' {frmPedidos},
  Controller.Pedido in 'src\Controller\Controller.Pedido.pas',
  Dao.Cliente in 'src\DAO\Dao.Cliente.pas',
  Dao.Pedidos in 'src\DAO\Dao.Pedidos.pas',
  Dao.PedidoItem in 'src\DAO\Dao.PedidoItem.pas',
  Dao.Produto in 'src\DAO\Dao.Produto.pas',
  Model.Cliente in 'src\Model\Model.Cliente.pas',
  Model.Interfaces in 'src\Model\Model.Interfaces.pas',
  Model.Pedidos in 'src\Model\Model.Pedidos.pas',
  Model.PedidoItem in 'src\Model\Model.PedidoItem.pas',
  Model.Produto in 'src\Model\Model.Produto.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TdmDB, dmDB);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
