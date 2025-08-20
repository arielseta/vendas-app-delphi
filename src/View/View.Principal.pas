unit View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Config.DBConnection, View.Pedidos,
  View.ConsultaPedidos, Dao.Pedidos, System.UITypes;

type
  TfrmPrincipal = class(TForm)
    btnNovoPedido: TButton;
    btnConsultar: TButton;
    procedure btnNovoPedidoClick(Sender: TObject);
    procedure btnConsultarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.btnConsultarClick(Sender: TObject);
var
  dao: TDaoPedido;
begin
  dao := TDaoPedido.Create;
  try
    if dao.GetAll.Count = 0 then
    begin
      MessageDlg('Nenhum pedido encontrado.', mtInformation, [mbOK], 0);
      Exit;
    end;
  finally
    dao.Free;
  end;

  frmConsultaPedidos := TfrmConsultaPedidos.Create(Self);
  try
    frmConsultaPedidos.ShowModal;
  finally
    frmConsultaPedidos.Free;
  end;
end;

procedure TfrmPrincipal.btnNovoPedidoClick(Sender: TObject);
begin
  frmPedidos := TfrmPedidos.Create(Self);
  try
    frmPedidos.ShowModal;
  finally
    frmPedidos.Free;
  end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  dmDB.InitializeDatabase;
end;

end.
