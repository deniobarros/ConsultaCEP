object ViewPrincipal: TViewPrincipal
  Left = 0
  Top = 0
  Caption = 'Buscador Endere'#231'o'
  ClientHeight = 567
  ClientWidth = 874
  Color = clBtnFace
  Constraints.MinHeight = 606
  Constraints.MinWidth = 890
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pnPrincipal: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 5
    Width = 864
    Height = 557
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    StyleElements = []
    object pnCamposEndereco: TPanel
      Left = 0
      Top = 0
      Width = 864
      Height = 181
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      StyleElements = []
      object lblEndereco: TLabel
        Left = 5
        Top = 17
        Width = 49
        Height = 15
        Caption = 'Endere'#231'o'
      end
      object lblCidade: TLabel
        Left = 5
        Top = 65
        Width = 37
        Height = 15
        Caption = 'Cidade'
      end
      object lblEstado: TLabel
        Left = 237
        Top = 65
        Width = 35
        Height = 15
        Caption = 'Estado'
      end
      object lblCep: TLabel
        Left = 5
        Top = 116
        Width = 21
        Height = 15
        Caption = 'CEP'
      end
      object edtEndereco: TEdit
        Left = 5
        Top = 36
        Width = 444
        Height = 23
        TabOrder = 0
      end
      object rgResultadoConsulta: TRadioGroup
        Left = 692
        Top = 25
        Width = 167
        Height = 131
        Caption = 'Resultado da Consulta'
        ItemIndex = 0
        Items.Strings = (
          'JSON'
          'XML')
        TabOrder = 6
        OnClick = rgResultadoConsultaClick
      end
      object edtEstado: TEdit
        Left = 237
        Top = 82
        Width = 65
        Height = 23
        TabOrder = 2
      end
      object edtCidade: TEdit
        Left = 5
        Top = 82
        Width = 217
        Height = 23
        TabOrder = 1
      end
      object btnPesquisaEndereco: TButton
        Left = 320
        Top = 81
        Width = 129
        Height = 25
        Caption = 'Consulta por Endere'#231'o'
        TabOrder = 4
        OnClick = btnPesquisaEnderecoClick
      end
      object btnPesquisaCEP: TButton
        Left = 320
        Top = 132
        Width = 129
        Height = 25
        Caption = 'Consulta por CEP'
        TabOrder = 5
        OnClick = btnPesquisaCEPClick
      end
      object btnLimparCampos: TButton
        Left = 488
        Top = 132
        Width = 180
        Height = 25
        Caption = 'Limpar Campos'
        TabOrder = 7
        OnClick = btnLimparCamposClick
      end
      object edtCEP: TMaskEdit
        Left = 5
        Top = 133
        Width = 212
        Height = 23
        EditMask = '99999\-999;0;_'
        MaxLength = 9
        TabOrder = 3
        Text = ''
      end
      object btnPesquisaEnderecosInseridos: TButton
        Left = 488
        Top = 81
        Width = 180
        Height = 25
        Caption = 'Consultar Endere'#231'os Inseridos'
        TabOrder = 8
        OnClick = btnPesquisaEnderecosInseridosClick
      end
    end
    object pnGrid: TPanel
      AlignWithMargins = True
      Left = 5
      Top = 186
      Width = 854
      Height = 366
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      StyleElements = []
      object grEnderecos: TDBGrid
        Left = 0
        Top = 25
        Width = 854
        Height = 341
        Align = alClient
        DataSource = dsEndereco
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        ReadOnly = True
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'CEP'
            Title.Caption = 'Cep'
            Width = 62
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LOGRADOURO'
            Title.Caption = 'Endere'#231'o'
            Width = 232
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'COMPLEMENTO'
            Title.Caption = 'Complemento'
            Width = 192
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'BAIRRO'
            Title.Caption = 'Bairro'
            Width = 120
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'UF'
            Title.Caption = 'Estado'
            Width = 66
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'LOCALIDADE'
            Title.Caption = 'Cidade'
            Width = 140
            Visible = True
          end>
      end
      object DBNavigator1: TDBNavigator
        Left = 0
        Top = 0
        Width = 854
        Height = 25
        DataSource = dsEndereco
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
        Align = alTop
        TabOrder = 0
      end
    end
  end
  object dsEndereco: TDataSource
    Left = 520
    Top = 288
  end
  object BuscaCep: TBuscaCep
    TipoRetornoConsulta = rcJSON
    TipoConsulta = tcCEP
    Left = 432
    Top = 288
  end
end
