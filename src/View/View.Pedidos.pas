unit View.Pedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, System.UITypes,
  Controller.Pedido, Model.Interfaces, Dao.Cliente, Model.Cliente, Dao.Produto, Model.Produto,
  Dao.PedidoItem, Model.PedidoItem, System.Generics.Collections;

type
  TfrmPedidos = class(TForm)
    edtCodigoCliente: TEdit;
    lblCliente: TLabel;
    edtCodigoProduto: TEdit;
    edtQtde: TEdit;
    edtValorUnitario: TEdit;
    lblCodigo: TLabel;
    lblQtde: TLabel;
    lblValorUnit: TLabel;
    btnAdicionar: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    btnSalvar: TButton;
    btnCancelar: TButton;
    grdItens: TStringGrid;
    lblTotal: TLabel;
    lblNomeCliente: TLabel;
    lblDescricaoProduto: TLabel;
    lblTotalProduto: TLabel;
    edtValorTotal: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnAdicionarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure edtCodigoClienteKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtCodigoProdutoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtValorUnitarioExit(Sender: TObject);
    procedure edtQtdeExit(Sender: TObject);
    procedure edtQtdeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtValorUnitarioKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
  private
    { Private declarations }
    FService: IPedidoService;
    procedure AtualizarGrid;
    procedure AtualizarTotal;
  public
    { Public declarations }
  end;
var
  frmPedidos: TfrmPedidos;
implementation
{$R *.dfm}
procedure TfrmPedidos.AtualizarGrid;
var
  i: Integer;
  itens: TObjectList<TPedidoItem>;
  item: TPedidoItem;
  daoProd: TDaoProduto;
  produto: TProduto;
begin
  grdItens.RowCount := 1;

  if not Assigned(FService) then
    Exit;

  itens := TObjectList<TPedidoItem>(FService.GetItensObject);
  if not Assigned(itens) then
    Exit;

  grdItens.RowCount := itens.Count + 1;

  daoProd := TDaoProduto.Create;
  try
    for i := 0 to itens.Count - 1 do
    begin
      item := itens[i];

      produto := daoProd.GetById(item.CodigoProduto);

      grdItens.Cells[0, i + 1] := IntToStr(item.CodigoProduto);
      if Assigned(produto) then
        grdItens.Cells[1, i + 1] := produto.Descricao
      else
        grdItens.Cells[1, i + 1] := '';

      grdItens.Cells[2, i + 1] := FormatFloat('0.00', item.Quantidade);
      grdItens.Cells[3, i + 1] := FormatFloat('0.00', item.ValorUnitario);
      grdItens.Cells[4, i + 1] := FormatFloat('0.00', item.ValorTotal);
    end;
  finally
    daoProd.Free;
  end;
end;

procedure TfrmPedidos.AtualizarTotal;
begin
  lblTotal.Caption := Format('Total: R$ %.2f', [FService.TotalPedido]);
end;

procedure TfrmPedidos.btnAdicionarClick(Sender: TObject);
var
  codigoCliente: Integer;
  codigoProduto: Integer;
  qtde: Double;
  valorUnitario: Double;
begin
  codigoCliente := StrToIntDef(edtCodigoCliente.Text, 0);
  codigoProduto := StrToIntDef(edtCodigoProduto.Text, 0);
  qtde := StrToFloatDef(edtQtde.Text, 0);
  valorUnitario := StrToFloatDef(edtValorUnitario.Text, 0);
  if codigoCliente > 0 then
    if codigoProduto > 0 then
      if qtde > 0 then
        if valorUnitario > 0 then
            begin
              FService.AddItem(codigoProduto, qtde, valorUnitario);
              edtCodigoCliente.Enabled := false;
            end
        else
          begin
            MessageDlg('Valor inválido.', mtError, [mbOK], 0);
            edtValorUnitario.SetFocus;
          end
      else
        begin
          MessageDlg('Valor inválido.', mtError, [mbOK], 0);
          edtQtde.SetFocus;
        end
    else
      begin
        MessageDlg('Valor inválido.', mtError, [mbOK], 0);
        edtCodigoProduto.SetFocus;
      end
  else
    begin
      MessageDlg('Valor inválido.', mtError, [mbOK], 0);
      edtCodigoCliente.SetFocus;
    end;
  AtualizarGrid;
  AtualizarTotal;
end;

procedure TfrmPedidos.btnCancelarClick(Sender: TObject);
begin
  if Trim(edtCodigoCliente.Text) = '' then
    FService.CancelarPedido;
  ModalResult := mrCancel;
end;

procedure TfrmPedidos.btnEditarClick(Sender: TObject);
var
  row, index, qtde: Integer;
  valorUnit: Double;
  sQtde, sValor: string;
begin
  row := grdItens.Row;
  sQtde := grdItens.Cells[2, row];
  sValor := grdItens.Cells[3, row];

  if (not sQtde.IsEmpty) and (not sValor.IsEmpty) then
  begin
    if row <= 0 then
    begin
      MessageDlg('Selecione um item para editar.', mtWarning, [mbOK], 0);
      Exit;
    end;

    index := row - 1;

    sQtde := grdItens.Cells[2, row];
    sValor := grdItens.Cells[3, row];

    sQtde := InputBox('Editar Item', 'Quantidade:', sQtde);
    qtde := StrToIntDef(sQtde, 0);

    sValor := InputBox('Editar Item', 'Valor Unitário:', sValor);
    valorUnit := StrToFloatDef(sValor, 0);

    if (qtde <= 0) or (valorUnit <= 0) then
    begin
      MessageDlg('Valores inválidos.', mtError, [mbOK], 0);
      Exit;
    end;

    FService.EditItem(index, qtde, valorUnit);

    AtualizarGrid;
    AtualizarTotal;
  end;
end;

procedure TfrmPedidos.btnExcluirClick(Sender: TObject);
var
  row: Integer;
  itemIndex: Integer;
begin
  row := grdItens.Row;
  if row <= 0 then
  begin
    MessageDlg('Selecione um item para excluir.', mtWarning, [mbOK], 0);
    Exit;
  end;

  itemIndex := row;
  if itemIndex = 0 then
  begin
    MessageDlg('Não foi possível identificar o item selecionado.', mtError, [mbOK], 0);
    Exit;
  end;

  FService.RemoveItem(itemIndex);

  AtualizarGrid;
  AtualizarTotal;
end;

procedure TfrmPedidos.btnSalvarClick(Sender: TObject);
var
  numeroPedido : Integer;
begin
  numeroPedido := FService.SalvarPedido(StrToInt(edtCodigoCliente.Text));
  if numeroPedido > 0 then
      MessageDlg('Pedido salvo com sucesso.' + sLineBreak +'Número do pedido: '+IntToStr(numeroPedido), mtInformation, [mbOK], 0);
  ModalResult := mrOk;
end;

procedure TfrmPedidos.edtCodigoClienteKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  dao: TDaoCliente;
  cliente: TCliente;
  codigo: Integer;
begin
  if Key = VK_RETURN then
  begin
    codigo := StrToIntDef(edtCodigoCliente.Text, 0);
    dao := TDaoCliente.Create;
    try
      cliente := dao.GetById(codigo);
      if Assigned(cliente) then
        begin
          lblNomeCliente.Caption := cliente.Nome;
          edtCodigoProduto.SetFocus;
        end
      else
        lblNomeCliente.Caption := 'Cliente não encontrado';
    finally
      dao.Free;
    end;
  end;
end;

procedure TfrmPedidos.edtCodigoProdutoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  dao: TDaoProduto;
  produto: TProduto;
  codigo: Integer;
begin
  if Key = VK_RETURN then
  begin
    codigo := StrToIntDef(edtCodigoProduto.Text, 0);
    dao := TDaoProduto.Create;
    try
      produto := dao.GetById(codigo);
      if Assigned(produto) then
        begin
          lblDescricaoProduto.Caption := produto.Descricao;
          edtValorUnitario.Text := FormatFloat('0.00',produto.PrecoVenda);
          edtQtde.SetFocus;
        end
      else
        lblDescricaoProduto.Caption := 'Produto não encontrado';
    finally
      dao.Free;
    end;
  end;
end;

procedure TfrmPedidos.edtQtdeExit(Sender: TObject);
begin
  if edtQtde.GetTextLen > 0 then
    if edtValorUnitario.GetTextLen > 0 then
      edtValorTotal.Text := FormatFloat('0.00',StrToFloat(edtQtde.Text)*StrToFloat(edtValorUnitario.Text));
end;

procedure TfrmPedidos.edtQtdeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    edtValorUnitario.SetFocus;
end;

procedure TfrmPedidos.edtValorUnitarioExit(Sender: TObject);
var
  valorUnitario: Double;
begin
  try
    valorUnitario := StrToFloat(edtValorUnitario.Text);
    edtValorUnitario.Text := FormatFloat('0.00',valorUnitario);
    if edtQtde.GetTextLen > 0 then
      begin
        edtValorTotal.Text := FormatFloat('0.00',StrToFloat(edtQtde.Text)*valorUnitario);
      end;
  except
      on E: EConvertError do
      begin
        MessageDlg('Valor inválido.', mtError, [mbOK], 0);
        edtValorUnitario.Text := '';
        edtValorUnitario.SetFocus;
      end;
  end;
end;

procedure TfrmPedidos.edtValorUnitarioKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    edtValorTotal.SetFocus;
end;

procedure TfrmPedidos.FormCreate(Sender: TObject);
begin
  FService := TPedidoController.Create;
  FService.NovoPedido;
  grdItens.ColCount := 5;
  grdItens.RowCount := 2;
  grdItens.FixedRows := 1;
  grdItens.Cells[0,0]   := 'Cód. Produto';
  grdItens.ColWidths[0] := 90;
  grdItens.Cells[1,0]   := 'Descrição';
  grdItens.ColWidths[1] := 200;
  grdItens.Cells[2,0]   := 'Qtde';
  grdItens.ColWidths[2] := 60;
  grdItens.Cells[3,0]   := 'Vl. Unit';
  grdItens.ColWidths[3] := 80;
  grdItens.Cells[4,0]   := 'Vl. Total';
  grdItens.ColWidths[4] := 80;
  lblNomeCliente.Caption:='';
  lblDescricaoProduto.Caption:='';
  edtCodigoCliente.Text := '0';
  edtCodigoProduto.Text := '0';
  edtQtde.Text := '0';
  edtValorUnitario.Text := '0,00';
  edtValorTotal.Text := '0,00';
end;

end.
