unit View.ConsultaPedidos;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Dao.Pedidos, Model.Pedidos,
  System.Generics.Collections, System.UITypes;
type
  TfrmConsultaPedidos = class(TForm)
    edtCliente: TEdit;
    lblCliente: TLabel;
    btnBuscar: TButton;
    grdPedidos: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure edtClienteKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure CarregarPedidos(AClienteId: String);
  public
    { Public declarations }
  end;
var
  frmConsultaPedidos: TfrmConsultaPedidos;
implementation
{$R *.dfm}
procedure TfrmConsultaPedidos.btnBuscarClick(Sender: TObject);
begin
  CarregarPedidos(edtCliente.Text);
end;

procedure TfrmConsultaPedidos.CarregarPedidos(AClienteId: String);
var
  dao: TDaoPedido;
  pedidos: TObjectList<TModelPedidos>;
  i: Integer;
  codigoCliente : Integer;
begin
  dao := TDaoPedido.Create;
  codigoCliente := 0;
  if not AClienteId.IsEmpty then
    codigoCliente := StrToInt(AClienteId);
  try
    begin
      if codigoCliente > 0 then
        pedidos := dao.GetByCliente(codigoCliente)
      else
        pedidos := dao.GetAll;
    end;
    try
      if pedidos.Count = 0 then
        MessageDlg('Nenhum pedido encontrado.', mtInformation, [mbOK], 0)
      else
        begin
          grdPedidos.RowCount := pedidos.Count + 1;
          for i := 0 to pedidos.Count - 1 do
          begin
            grdPedidos.Cells[0, i+1] := pedidos[i].Numero.ToString;
            grdPedidos.Cells[1, i+1] := DateToStr(pedidos[i].DataEmissao);
            grdPedidos.Cells[2, i+1] := pedidos[i].CodigoCliente.ToString;
            grdPedidos.Cells[3, i+1] := FormatFloat('0.00', pedidos[i].ValorTotal);
          end;
        end;
    finally
      pedidos.Free;
    end;
  finally
    dao.Free;
  end;
end;

procedure TfrmConsultaPedidos.edtClienteKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    CarregarPedidos(edtCliente.Text)
end;

procedure TfrmConsultaPedidos.FormCreate(Sender: TObject);
begin
  grdPedidos.ColCount := 4;
  grdPedidos.RowCount := 1;
  grdPedidos.Cells[0,0] := 'Número';
  grdPedidos.ColWidths[0] := 60;
  grdPedidos.Cells[1,0] := 'Emissão';
  grdPedidos.ColWidths[1] := 90;
  grdPedidos.Cells[2,0] := 'Cliente';
  grdPedidos.ColWidths[2] := 200;
  grdPedidos.Cells[3,0] := 'Valor Total';
  grdPedidos.ColWidths[3] := 90;
end;
end.