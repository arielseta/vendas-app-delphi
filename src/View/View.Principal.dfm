object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Vendas'
  ClientHeight = 202
  ClientWidth = 388
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object btnNovoPedido: TButton
    Left = 24
    Top = 80
    Width = 150
    Height = 40
    Hint = 'Criar novo pedido'
    Caption = 'Novo Pedido'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = btnNovoPedidoClick
  end
  object btnConsultar: TButton
    Left = 214
    Top = 80
    Width = 150
    Height = 40
    Hint = 'Consultar pedidos efetuados'
    Caption = 'Consultar Pedidos'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = btnConsultarClick
  end
end
