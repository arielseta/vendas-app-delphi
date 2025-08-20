object frmConsultaPedidos: TfrmConsultaPedidos
  Left = 0
  Top = 0
  Caption = 'Consulta de Pedidos'
  ClientHeight = 356
  ClientWidth = 544
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object lblCliente: TLabel
    Left = 16
    Top = 12
    Width = 118
    Height = 15
    Caption = 'Filtro Cliente (c'#243'digo):'
  end
  object edtCliente: TEdit
    Left = 160
    Top = 8
    Width = 120
    Height = 23
    Hint = 'Informe o c'#243'digo do cliente ou deixe em branco para geral'
    Alignment = taRightJustify
    NumbersOnly = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnKeyDown = edtClienteKeyDown
  end
  object btnBuscar: TButton
    Left = 296
    Top = 6
    Width = 90
    Height = 25
    Hint = 'Busca pedidos cadastrados'
    Caption = 'Buscar'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = btnBuscarClick
  end
  object grdPedidos: TStringGrid
    Left = 16
    Top = 48
    Width = 528
    Height = 288
    TabOrder = 2
  end
end
