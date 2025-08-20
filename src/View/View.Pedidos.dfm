object frmPedidos: TfrmPedidos
  Left = 0
  Top = 0
  Caption = 'Pedido de Venda'
  ClientHeight = 410
  ClientWidth = 632
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
    Width = 68
    Height = 15
    Caption = 'C'#243'd. Cliente:'
  end
  object lblCodigo: TLabel
    Left = 16
    Top = 48
    Width = 71
    Height = 15
    Caption = 'C'#243'd. Produto'
  end
  object lblQtde: TLabel
    Left = 16
    Top = 82
    Width = 62
    Height = 15
    Caption = 'Quantidade'
  end
  object lblValorUnit: TLabel
    Left = 96
    Top = 82
    Width = 71
    Height = 15
    Caption = 'Valor Unit'#225'rio'
  end
  object lblTotal: TLabel
    Left = 16
    Top = 384
    Width = 68
    Height = 15
    Caption = 'Total: R$ 0,00'
  end
  object lblNomeCliente: TLabel
    Left = 182
    Top = 12
    Width = 83
    Height = 15
    Caption = 'lblNomeCliente'
  end
  object lblDescricaoProduto: TLabel
    Left = 182
    Top = 48
    Width = 107
    Height = 15
    Caption = 'lblDescricaoProduto'
  end
  object lblTotalProduto: TLabel
    Left = 202
    Top = 82
    Width = 54
    Height = 15
    Caption = 'Valor Total'
  end
  object edtCodigoCliente: TEdit
    Left = 96
    Top = 8
    Width = 80
    Height = 23
    Hint = 'Digite o c'#243'digo do cliente'
    Alignment = taRightJustify
    NumbersOnly = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnKeyDown = edtCodigoClienteKeyDown
  end
  object edtCodigoProduto: TEdit
    Left = 96
    Top = 45
    Width = 80
    Height = 23
    Hint = 'Digite o c'#243'digo do produto'
    Alignment = taRightJustify
    NumbersOnly = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnKeyDown = edtCodigoProdutoKeyDown
  end
  object edtQtde: TEdit
    Left = 16
    Top = 99
    Width = 68
    Height = 23
    Hint = 'Digite a quantidade'
    Alignment = taRightJustify
    NumbersOnly = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnExit = edtQtdeExit
    OnKeyDown = edtQtdeKeyDown
  end
  object edtValorUnitario: TEdit
    Left = 96
    Top = 99
    Width = 100
    Height = 23
    Hint = 'Digite o valor unit'#225'rio'
    Alignment = taRightJustify
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnExit = edtValorUnitarioExit
    OnKeyDown = edtValorUnitarioKeyDown
  end
  object btnAdicionar: TButton
    Left = 308
    Top = 98
    Width = 90
    Height = 25
    Caption = 'Adicionar'
    TabOrder = 4
    OnClick = btnAdicionarClick
  end
  object grdItens: TStringGrid
    Left = 16
    Top = 144
    Width = 608
    Height = 200
    TabOrder = 5
  end
  object btnEditar: TButton
    Left = 16
    Top = 352
    Width = 120
    Height = 25
    Caption = 'Editar Selecionado'
    TabOrder = 6
    OnClick = btnEditarClick
  end
  object btnExcluir: TButton
    Left = 142
    Top = 352
    Width = 120
    Height = 25
    Caption = 'Excluir Selecionado'
    TabOrder = 7
    OnClick = btnExcluirClick
  end
  object btnSalvar: TButton
    Left = 438
    Top = 352
    Width = 90
    Height = 25
    Caption = 'Salvar Pedido'
    TabOrder = 8
    OnClick = btnSalvarClick
  end
  object btnCancelar: TButton
    Left = 534
    Top = 352
    Width = 90
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 9
    OnClick = btnCancelarClick
  end
  object edtValorTotal: TEdit
    Left = 202
    Top = 99
    Width = 100
    Height = 23
    Hint = 'Digite o valor unit'#225'rio'
    Alignment = taRightJustify
    ParentShowHint = False
    ReadOnly = True
    ShowHint = True
    TabOrder = 10
  end
end
